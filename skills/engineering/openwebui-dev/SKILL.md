---
name: openwebui-dev
description: Create, manage, debug, and fix Open WebUI Tools, Functions (Filter/Pipe/Action), and external tool server integrations. Use when building OpenWebUI extensions, writing toolkit Python classes, implementing Filter inlets/outlets, creating Pipe models, adding Action buttons, configuring Valves, using __event_emitter__, or debugging why a tool/function isn't loading or being called correctly.
---

# Open WebUI Extension Developer

## Quick orientation

Two extension systems exist:

- **Tools** — Python class `Tools` whose public methods become LLM-callable functions
- **Functions** — Python class `Filter` | `Pipe` | `Action` loaded as plugins

Both share: frontmatter, Valves/UserValves config, and `__dunder__` injected params.

## Workflows

### Create a Tool

```python
"""
title: My Tool
author: you
version: 0.1
requirements: requests
"""
from pydantic import BaseModel, Field
from typing import Optional

class Tools:
    class Valves(BaseModel):
        api_key: str = Field(default="", description="API key")

    def __init__(self):
        self.valves = self.Valves()
        self.citation = True  # show results as citable sources

    async def my_method(self, query: str, __event_emitter__: callable = None) -> str:
        """
        Does something useful.

        :param query: The search query.
        :return: Result string.
        """
        if __event_emitter__:
            await __event_emitter__({"type": "status", "data": {"description": "Working...", "done": False}})
        result = f"result for {query}"
        if __event_emitter__:
            await __event_emitter__({"type": "status", "data": {"description": "Done", "done": True}})
        return result
```

**Checklist:**
- [ ] Class named exactly `Tools`
- [ ] All params type-hinted (required for schema generation)
- [ ] Docstring: description before `:param` lines; `:param name: desc` for each param
- [ ] `__dunder__` params have defaults so they're not exposed to LLM
- [ ] Secrets in `Valves`, not hardcoded
- [ ] `async def` for any I/O

### Create a Filter

```python
class Filter:
    class Valves(BaseModel):
        priority: int = Field(default=0, description="Execution order")

    def __init__(self):
        self.valves = self.Valves()

    def inlet(self, body: dict, __user__: Optional[dict] = None) -> dict:
        # Modify request before LLM; raise Exception to block
        return body  # MUST return body

    def outlet(self, body: dict, __user__: Optional[dict] = None) -> dict:
        # Modify response after LLM
        return body  # MUST return body
```

### Create a Pipe (custom model)

```python
class Pipe:
    class Valves(BaseModel):
        API_URL: str = "https://api.example.com"
        API_KEY: str = ""

    def __init__(self):
        self.valves = self.Valves()

    def pipe(self, body: dict, __user__: dict = {}) -> Union[str, Generator, Iterator]:
        # body is full OpenAI chat completion request
        # Check body.get("stream", False) to support streaming
        return "response"
```

### Create an Action (message button)

```python
class Action:
    def __init__(self):
        self.valves = self.Valves()

    async def action(self, body: dict, __event_emitter__: callable = None) -> Optional[dict]:
        # body["messages"][-1] is the message that was acted upon
        return body
```

## Key rules to never break

| Rule | Why it matters |
|---|---|
| Always return `body` from `inlet`/`outlet` | Forgetting this silently breaks the pipeline |
| Type-hint every Tool param | Missing hints = method excluded from LLM spec |
| Docstring before `:param` = tool description | LLM reads this to know when to call the tool |
| `__dunder__` params need default values | Without defaults they appear in the LLM spec |
| Strip pipe ID prefix: `body["model"].split(".", 1)[1]` | Pipe model IDs are `pipe_id.actual_model_id` |
| Raise `Exception` in `inlet` to block requests | That string is shown to the user |

## Debugging checklist

- Tool not appearing? → Check class is named `Tools`, all params type-hinted, no syntax errors on save
- Tool not called? → Improve docstring description; LLM decides based on it
- Filter not running? → Check `priority` ordering; verify `inlet`/`outlet` returns `body`
- Pipe not showing as model? → Check class named `Pipe`, `pipe()` method exists
- Valves not saving? → Must be a Pydantic `BaseModel` with `Field(default=...)`
- `__event_emitter__` not working? → Must be `async def` method; add `callable = None` default

## Event emitter types

```python
# Status indicator
await __event_emitter__({"type": "status", "data": {"description": "msg", "done": False}})

# Citation source
await __event_emitter__({"type": "source", "data": {"source": {"name": "Title", "url": "https://..."}, "document": ["content"]}})

# Task list
await __event_emitter__({"type": "chat:message:tasks", "data": {"tasks": [{"id": "1", "content": "Step", "status": "done"}]}})
```

## Available `__dunder__` injections

| Param | Type | Use for |
|---|---|---|
| `__user__` | dict | `{id, name, email, role, valves}` |
| `__event_emitter__` | callable | Real-time UI updates |
| `__event_call__` | callable | Client-side calls with response |
| `__messages__` | list | Full conversation history |
| `__files__` | list | Attached files |
| `__metadata__` | dict | `{chat_id, message_id, ...}` |
| `__id__` | str | Tool/function ID |

See [references/REFERENCE.md](references/REFERENCE.md) for full manifold pipe patterns, external tool servers, and pipe return type details.
See [references/EXAMPLES.md](references/EXAMPLES.md) for complete working examples of each type.
