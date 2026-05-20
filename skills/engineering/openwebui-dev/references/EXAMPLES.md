# Open WebUI Extensions — Examples

## Tool: web search with status events

```python
"""
title: Web Search
version: 0.1
requirements: requests
"""
from pydantic import BaseModel, Field
from typing import Optional
import requests

class Tools:
    class Valves(BaseModel):
        api_key: str = Field(default="", description="Search API key")
        max_results: int = Field(default=5, description="Max results")

    def __init__(self):
        self.valves = self.Valves()
        self.citation = True

    async def search(
        self,
        query: str,
        __user__: dict = {},
        __event_emitter__: callable = None,
    ) -> str:
        """
        Search the web for current information.
        :param query: The search query.
        :return: Search results as text.
        """
        await __event_emitter__({"type": "status", "data": {"description": f"Searching: {query}", "done": False}})
        r = requests.get("https://api.example.com/search", params={"q": query, "key": self.valves.api_key})
        results = r.json().get("results", [])[:self.valves.max_results]
        await __event_emitter__({"type": "status", "data": {"description": "Done", "done": True}})
        return "\n".join(f"- {r['title']}: {r['url']}" for r in results)
```

## Filter: conversation turn limiter

```python
"""
title: Turn Limiter
version: 0.1
"""
from pydantic import BaseModel, Field
from typing import Optional

class Filter:
    class Valves(BaseModel):
        priority: int = Field(default=0)
        max_turns: int = Field(default=20)

    class UserValves(BaseModel):
        max_turns: int = Field(default=10)

    def __init__(self):
        self.valves = self.Valves()

    def inlet(self, body: dict, __user__: Optional[dict] = None) -> dict:
        messages = body.get("messages", [])
        limit = min(__user__["valves"].max_turns, self.valves.max_turns)
        if len(messages) > limit:
            raise Exception(f"Turn limit exceeded ({limit}). Start a new chat.")
        return body

    def outlet(self, body: dict, __user__: Optional[dict] = None) -> dict:
        return body
```

## Filter: inject system prompt

```python
"""
title: System Prompt Injector
version: 0.1
"""
from pydantic import BaseModel, Field
from typing import Optional

class Filter:
    class Valves(BaseModel):
        priority: int = Field(default=0)
        system_prompt: str = Field(default="You are a helpful assistant.", description="System prompt to inject")

    def __init__(self):
        self.valves = self.Valves()

    def inlet(self, body: dict, __user__: Optional[dict] = None) -> dict:
        messages = body.get("messages", [])
        if not any(m["role"] == "system" for m in messages):
            body["messages"] = [{"role": "system", "content": self.valves.system_prompt}] + messages
        return body

    def outlet(self, body: dict, __user__: Optional[dict] = None) -> dict:
        return body
```

## Pipe: proxy to external API

```python
"""
title: My Custom LLM
version: 0.1
requirements: requests
"""
from pydantic import BaseModel, Field
from typing import Union, Iterator
import requests

class Pipe:
    class Valves(BaseModel):
        API_URL: str = Field(default="https://api.example.com/v1")
        API_KEY: str = Field(default="")

    def __init__(self):
        self.valves = self.Valves()

    def pipe(self, body: dict, __user__: dict = {}) -> Union[str, Iterator]:
        headers = {"Authorization": f"Bearer {self.valves.API_KEY}"}
        r = requests.post(
            f"{self.valves.API_URL}/chat/completions",
            headers=headers,
            json=body,
            stream=body.get("stream", False),
        )
        if body.get("stream"):
            return r.iter_lines()
        return r.json()["choices"][0]["message"]["content"]
```

## Pipe: manifold (multiple sub-models)

```python
"""
title: Multi-Model Router
version: 0.1
requirements: requests
"""
from pydantic import BaseModel, Field
from typing import Union, Iterator
import requests

class Pipe:
    class Valves(BaseModel):
        API_KEY: str = Field(default="")

    def __init__(self):
        self.type = "manifold"
        self.valves = self.Valves()

    def pipes(self) -> list[dict]:
        return [
            {"id": "fast", "name": "Fast Model"},
            {"id": "smart", "name": "Smart Model"},
        ]

    def pipe(self, body: dict, __user__: dict = {}) -> Union[str, Iterator]:
        model_id = body["model"].split(".", 1)[1]  # strip "pipe_id." prefix
        # route to different endpoints based on model_id
        url = f"https://api.example.com/{model_id}/chat"
        r = requests.post(url, json=body, stream=body.get("stream", False))
        if body.get("stream"):
            return r.iter_lines()
        return r.json()["choices"][0]["message"]["content"]
```

## Action: summarize message on click

```python
"""
title: Summarize Message
version: 0.1
"""
from typing import Optional

class Action:
    def __init__(self):
        pass

    async def action(
        self,
        body: dict,
        __user__: Optional[dict] = None,
        __event_emitter__: callable = None,
    ) -> Optional[dict]:
        messages = body.get("messages", [])
        last = messages[-1]["content"] if messages else ""
        await __event_emitter__({"type": "status", "data": {"description": "Summarizing...", "done": False}})
        # call your summarization logic here
        await __event_emitter__({"type": "status", "data": {"description": "Done", "done": True}})
        return body
```
