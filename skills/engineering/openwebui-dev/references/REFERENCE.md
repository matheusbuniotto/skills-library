# Open WebUI Extension Reference

## Frontmatter keys (module docstring)

```python
"""
title: Display Name
author: Your Name
author_url: https://github.com/you
version: 0.1
license: MIT
requirements: requests, httpx
"""
```

`requirements` — comma-separated pip packages auto-installed on save.

## Manifold Pipe (multiple sub-models)

```python
class Pipe:
    def __init__(self):
        self.type = "manifold"  # required flag
        self.valves = self.Valves()

    def pipes(self) -> list[dict]:
        return [
            {"id": "model-a", "name": "Model A"},
            {"id": "model-b", "name": "Model B"},
        ]

    def pipe(self, body: dict) -> str:
        model_id = body["model"].split(".", 1)[1]  # strip "pipe_id." prefix
        # route based on model_id
```

## Pipe return types

| Return | Behavior |
|---|---|
| `str` | Full message content |
| `Generator` / `Iterator` | Streamed line by line |
| `AsyncGenerator` | Streamed async |
| `dict` | Must be OpenAI-format, returned as-is |
| `StreamingResponse` | Passed through directly |
| `{"error": {"detail": "msg"}}` | Displays error in UI |

## Filter stream hook

```python
def stream(self, event: dict) -> dict:
    """Intercepts each SSE streaming chunk."""
    return event
```

## `file_handler` flag

Set `self.file_handler = True` in `__init__` to:
- **Tools**: signal your tool processes files (disables default RAG)
- **Filters**: suppress automatic file/RAG injection into `inlet`

## UserValves vs Valves

```python
class Tools:
    class Valves(BaseModel):       # Admin-only in UI
        api_key: str = Field(default="")

    class UserValves(BaseModel):   # Each user configures their own
        language: str = Field(default="en")

    def __init__(self):
        self.valves = self.Valves()
        # self.user_valves populated automatically from __user__["valves"]
```

`__user__["valves"]` contains the user's `UserValves` instance at call time.

## How the spec pipeline works (Tools)

1. Save → `exec()` the code into a fresh module
2. `get_functions_from_tool()` → all public non-class methods
3. `convert_function_to_pydantic_model()` → Pydantic model from type hints
4. `convert_pydantic_model_to_openai_function_spec()` → OpenAI function schema
5. Schema stored in DB; `__dunder__` params stripped from schema
6. At chat time: valves applied, params injected, LLM receives specs
7. LLM calls tool → `tool_function(**params)` executed

## How function loading works (Filter/Pipe/Action)

```
load_function_module_by_id()
  → replace_imports()
  → exec(content) into fresh module
  → detect: Pipe? Filter? Action?
  → return (instance, type, frontmatter)
```

Class detection order: `Pipe` → `Filter` → `Action`. Only one per file.

## External Tool Servers

Connect any OpenAPI-compatible HTTP server:
- Admin Settings → Tools → Add Tool Server
- Open WebUI fetches `openapi.json` and converts `operationId`s to tool specs
- MCP servers: wrap with `mcpo` proxy to get OpenAPI interface

## Priority (Filters)

Lower `priority` value = runs first. Set explicitly when multiple filters active:

```python
class Valves(BaseModel):
    priority: int = Field(default=0, description="Execution order")
```

## Common patterns

### Inject system prompt (Filter inlet)

```python
def inlet(self, body: dict, __user__: Optional[dict] = None) -> dict:
    system_msg = {"role": "system", "content": "You are a helpful assistant."}
    messages = body.get("messages", [])
    if not any(m["role"] == "system" for m in messages):
        body["messages"] = [system_msg] + messages
    return body
```

### Forward to another LLM (Pipe)

```python
def pipe(self, body: dict, __user__: dict = {}) -> Union[str, Iterator]:
    import requests
    r = requests.post(
        f"{self.valves.API_URL}/chat/completions",
        headers={"Authorization": f"Bearer {self.valves.API_KEY}"},
        json=body,
        stream=body.get("stream", False),
    )
    if body.get("stream"):
        return r.iter_lines()
    return r.json()["choices"][0]["message"]["content"]
```

### Per-user API key (UserValves in Pipe)

```python
class UserValves(BaseModel):
    api_key: str = Field(default="", description="Your personal API key")

def pipe(self, body: dict, __user__: dict = {}) -> str:
    key = __user__.get("valves", self.UserValves()).api_key or self.valves.API_KEY
```

## Security note

Tools and Functions execute **arbitrary Python** with the privileges of the Open WebUI process. Only install from trusted sources. Put all secrets in `Valves`, never hardcoded.
