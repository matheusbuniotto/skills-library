---
name: upsonic-agents
description: >-
  Build and debug Upsonic agents (Agent, Task, tools, MCP, memory, teams, HITL).
  Use when implementing upsonic, upsonic[tools], @tool, MCPHandler, structured
  Task outputs, Agent.do/do_async/stream, llms.txt, or llms-full.txt.
---

# Upsonic Agents

**Version note:** This skill targets Upsonic **0.77.x** (`upsonic[tools]`). APIs are a custom DSL — do not infer syntax from LangChain/LangGraph alone.

## Documentation lookup (llms.txt / llms-full.txt)

Upsonic ships machine-readable docs for agents and IDEs:

| Resource | URL |
|----------|-----|
| Page index (~60 KB) | https://docs.upsonic.ai/llms.txt |
| **Full doc dump (~2.2 MB)** | https://docs.upsonic.ai/llms-full.txt |
| Human intro | https://docs.upsonic.ai/get-started/introduction |

**Before guessing an API:** use the index to find the page, then grep the full dump or fetch the live URL.

1. **Sync locally** (once per machine or after releases):

```bash
# From this skill folder (or repo path after install):
bash scripts/sync-upsonic-docs.sh
```

2. **Discover** — `rg "MCPHandler" references/cache/llms.txt` or open [references/cache/llms.txt](references/cache/llms.txt) after sync.

3. **Deep dive** — grep full corpus:

```bash
rg -n "continue_run_async" references/cache/llms-full.txt | head
```

Each page in `llms-full.txt` is `# Title` + `Source: https://docs.upsonic.ai/...` + markdown body.

Details: [references/llms-docs.md](references/llms-docs.md). Framework summary: [references/framework-overview.md](references/framework-overview.md).

**Cursor:** add `https://docs.upsonic.ai/llms-full.txt` in IDE docs ([IDE integration](https://docs.upsonic.ai/get-started/ide-integration)).

## Mental model

Upsonic separates **who runs** (Agent / Team / AutonomousAgent / …) from **what to do** (Task).

| Primitive | Use when |
|-----------|----------|
| **`Agent` + `Task`** | Structured, tool-driven work with clear I/O (default for implementation) |
| **`Team`** | Multiple agents; sequential pipeline, leader delegation, or routing |
| **`AutonomousAgent`** | Open-ended shell/filesystem work inside a sandboxed `workspace` |
| **`DeepAgent`** | Built-in planning, todos, VFS, subagents (Upsonic’s Deep Agent, not LangGraph Deep Agents) |
| **`Chat`** | Stateful multi-turn UI sessions with shared memory |
| **`Direct`** | One-shot LLM call, no tools/memory |

For primitive choice details, see [references/primitives.md](references/primitives.md).

## Essential imports

```python
from upsonic import Agent, Task

# Tools
from upsonic.tools import tool

# MCP (optional extra: upsonic[tools] or MCP deps)
from upsonic.tools.mcp import MCPHandler, MultiMCPHandler

# Memory (install storage extra, e.g. upsonic[sqlite-storage])
from upsonic.storage.memory import Memory
from upsonic.storage.sqlite import SqliteStorage

# Teams
from upsonic import Team

# Structured output
from pydantic import BaseModel
```

## Minimal agent

```python
from upsonic import Agent, Task

agent = Agent(model="anthropic/claude-sonnet-4-6")  # default: "openai/gpt-4o"
task = Task("What is the capital of France?")

# Dev only — prints to terminal:
agent.print_do(task)

# Production:
result = agent.do(task)           # sync; also accepts str or list[str|Task]
result = await agent.do_async(task)  # async pipeline
```

**Models:** `"provider/model_id"` strings (e.g. `"openai/gpt-4o"`, `"anthropic/claude-sonnet-4-6"`, `"google/gemini-2.0-flash-exp"`). Set API keys in `.env`. See [LLM support](https://docs.upsonic.ai/concepts/llm-support/model-as-string).

## Agent configuration (high-signal)

```python
agent = Agent(
    model="anthropic/claude-sonnet-4-6",
    name="Analyst",
    role="Data Analyst",
    goal="Produce accurate, cited analysis",
    instructions="Ask clarifying questions before analyzing data.",  # preferred over raw system_prompt
    # system_prompt="...",  # full control when needed
    tools=[...],            # agent-level tools (also: agent.add_tools([...]))
    memory=memory,          # or db=... (db overrides memory)
    session_id="sess-1",
    user_id="user-1",
    show_tool_calls=True,
    tool_call_limit=5,      # docs default 5; inspect signature may show 100
    enable_thinking_tool=False,
    enable_reasoning_tool=False,
    retry=2,                # extra attempts after first failure
    mode="raise",           # or "return_false"
    debug=False,
    reflection=False,
    context_management=False,  # long-run context compression when True
)
```

**Prompting:** Prefer `instructions` for behavior; use `system_prompt` only when you need full control. Combine with `role` / `goal` for persona.

**Policies / safety:** `user_policy`, `agent_policy`, `tool_policy_pre`, `tool_policy_post` — see [Safety Engine](https://docs.upsonic.ai/concepts/safety-engine/overview).

## Task configuration

```python
task = Task(
    description="Analyze Q4 sales and return structured insights",
    tools=[my_tool],              # task-scoped tools (can combine with agent tools)
    response_format=MyModel,      # Pydantic model or str (default)
    context=[...],                # files, images, other tasks, KnowledgeBase
    guardrail=...,                # output validation
    enable_cache=True,            # task-level response cache
    query_knowledge_base=True,    # when KnowledgeBase attached via context
)
```

Task chaining: pass prior `Task` instances or outputs in `context` for multi-step workflows without Team.

## Running agents

| Method | When |
|--------|------|
| `do(task)` / `do_async(task)` | Production; returns output (or list for list input) |
| `print_do` / `print_do_async` | Local debugging only |
| `stream(task)` / `astream(task)` | Token/chunk streaming (`async for chunk in agent.astream(task)`) |
| `continue_run` / `continue_run_async` | Resume after HITL pause |
| `get_run_output()` | Last run metadata after execution |
| `cancel_run(run_id)` | Cancel in-flight run |

**Batch:** `do(["q1", "q2"])` or `do([task1, task2])` runs sequentially; single-element list returns scalar.

**Full run object:**

```python
run = agent.do(task, return_output=True)
# run.output, run.status, run.usage, run.tools, run.messages, run.is_paused, ...
```

Statuses: `running`, `completed`, `paused`, `cancelled`, `error`. See [Accessing Agent Output](https://docs.upsonic.ai/concepts/agents/access_output).

## Tools

### Function tools (`@tool`)

Docstrings drive the schema — write Args/Returns clearly.

```python
from upsonic.tools import tool

@tool
def search_web(query: str) -> str:
    """Search the web for information.

    Args:
        query: Search query

    Returns:
        Summarized results
    """
    ...

# Async tools: use agent.do_async / astream
@tool
async def fetch(url: str) -> dict:
    ...
```

**Attach at Agent or Task** (Task tools apply to that run only). Prefer Task-level for one-off capabilities; Agent-level for persistent toolkit.

### Tool behavior flags (common)

```python
@tool(requires_confirmation=True)   # HITL — pauses until confirm/reject
def delete_row(id: str) -> str: ...

@tool(requires_user_input=True)     # agent pauses for user fields
def deploy(env: str) -> str: ...

@tool(external_execution=True)      # run outside framework; resume with result
def payment(amount: float) -> str: ...
```

Also: `stop_after_tool_call`, `show_result`, `cache=True`, `timeout=...`. See [tool behavior control](https://docs.upsonic.ai/concepts/tools/function-class-tools/advanced/behavior-control/instructions).

### MCP

Only connect trusted servers (stdio runs arbitrary processes).

```python
from upsonic.tools.mcp import MCPHandler, MultiMCPHandler

mcp = MCPHandler(command="uvx mcp-server-sqlite --db-path /tmp/app.db", timeout_seconds=60)

task = Task(description="List tables and summarize schema", tools=[mcp])

# Multiple servers — prefix tool names to avoid collisions:
multi = MultiMCPHandler(
    commands=["uvx mcp-server-a", "uvx mcp-server-b"],
    tool_name_prefixes=["a", "b"],
    timeout_seconds=60,
)
```

Use `StdioServerParameters` when you need explicit `command`/`args`/`env`. Docs: [MCP overview](https://docs.upsonic.ai/concepts/tools/mcp-tools/overview).

### Agent as tool

Wrap another `Agent` for hierarchical flows — [agent-as-tool](https://docs.upsonic.ai/concepts/tools/advanced/agent-as-tool).

## Structured output

```python
from pydantic import BaseModel

class Report(BaseModel):
    summary: str
    confidence: float
    recommendations: list[str]

task = Task(description="...", response_format=Report)
result = agent.do(task)  # result is Report instance when successful
```

## Memory

Memory **saves** and **loads** are independent — tune token use by saving full history but loading summaries only.

```python
storage = SqliteStorage(db_file="memory.db")
memory = Memory(
    storage=storage,
    session_id="session_001",
    user_id="user_123",
    full_session_memory=True,
    summary_memory=True,
    user_analysis_memory=True,
    load_full_session_memory=False,   # save history, inject summary only
    load_summary_memory=True,
    load_user_analysis_memory=True,
    model="anthropic/claude-sonnet-4-6",  # required for summary/profile
)

agent = Agent(model="anthropic/claude-sonnet-4-6", memory=memory)
```

Install storage extras before importing backends (e.g. `uv add "upsonic[sqlite-storage]"` — pulls SQLAlchemy for `SqliteStorage`):

`upsonic[sqlite-storage]`, `[postgres-storage]`, `[redis-storage]`, `[mongo-storage]`, `[mem0-storage]`.

## Human-in-the-loop (HITL)

```python
import asyncio
from upsonic import Agent, Task
from upsonic.tools import tool

@tool(requires_confirmation=True)
def sensitive_op(data: str) -> str:
    return f"done: {data}"

async def main():
    agent = Agent("anthropic/claude-sonnet-4-6")
    out = await agent.do_async(
        Task("Run sensitive_op on 'records'", tools=[sensitive_op]),
        return_output=True,
    )
    assert out.is_paused and out.pause_reason == "confirmation"
    for req in out.active_requirements:
        if req.needs_confirmation:
            req.confirm()  # or req.reject()
    final = await agent.continue_run_async(run_id=out.run_id, return_output=True)
    print(final.output)

asyncio.run(main())
```

Also: `requires_user_input`, `external_execution` — [HITL overview](https://docs.upsonic.ai/concepts/hitl/overview).

## Teams (multi-agent)

```python
from upsonic import Agent, Task, Team

researcher = Agent(model="anthropic/claude-sonnet-4-6", name="Researcher", role="Research", goal="Find facts")
writer = Agent(model="anthropic/claude-sonnet-4-6", name="Writer", role="Writer", goal="Draft clear prose")

team = Team(
    agents=[researcher, writer],
    mode="sequential",  # "coordinate" | "route"
    model="anthropic/claude-sonnet-4-6",  # required for coordinate/route leader
)

tasks = [
    Task("Research EV market trends"),
    Task("Write executive summary from prior findings"),
]
result = team.do(tasks)  # also print_do, do_async, stream patterns
```

| Mode | Pattern |
|------|---------|
| `sequential` | Linear handoff; each task flows to next agent |
| `coordinate` | Leader plans and delegates to members |
| `route` | Leader picks one specialist per request |

Nested teams: pass `Team` instances in `entities=[agent, sub_team]`. Docs: [Choosing team mode](https://docs.upsonic.ai/concepts/team/choosing-right-team-mode).

## Advanced agent features (enable deliberately)

| Flag | Purpose |
|------|---------|
| `enable_thinking_tool=True` | Orchestrated multi-tool thinking |
| `enable_reasoning_tool=True` | Deeper step-by-step reasoning (builds on thinking) |
| `reflection=True` | Self-critique pass on responses |
| `recommend_model_for_task` / `model_selection_criteria` | Auto model pick per task |
| `instrument=True` | Tracing / OpenTelemetry |
| `workspace="path"` | Load agent config from workspace folder |

## Implementation workflow

When implementing Upsonic agents in a repo:

1. **Confirm primitive** — default `Agent`+`Task`; see [primitives.md](references/primitives.md) if user needs autonomy or chat.
2. **Fetch doc page** from https://docs.upsonic.ai/llms.txt for the feature (MCP, memory, teams, etc.).
3. **Define Task contract** — description, `response_format`, tools, context.
4. **Configure Agent** — model string, `instructions`, limits (`tool_call_limit`, `retry`).
5. **Use `do_async`** if any tool is async or you need HITL/streaming.
6. **Verify** with `return_output=True` in tests; use `print_do` only locally.
7. **Production** — env keys, storage extras, trusted MCP only, policies for sensitive tools.

## Common mistakes

| Mistake | Fix |
|---------|-----|
| `from upsonic.tasks import Task` | Use `from upsonic import Task` |
| Using `print_do` in production | Use `do` / `do_async` |
| No docstring on `@tool` | Add Args/Returns; schema comes from docstring |
| `tool_call_limit` too low on MCP-heavy tasks | Raise limit (e.g. 10–20) |
| Expecting LangGraph `invoke({"messages":...})` | Upsonic uses `Task` + `agent.do(task)` |
| Same tool names from multiple MCP servers | `MultiMCPHandler(..., tool_name_prefixes=[...])` |
| Memory summaries without `model` on `Memory` | Pass `model=` to `Memory` |

## Project deps (contextos pattern)

```toml
dependencies = [
    "upsonic[tools]>=0.77.3",
    "dotenv>=0.9.9",
]
# Add when needed:
# upsonic[sqlite-storage]
# upsonic[postgres-storage]
```

Load env before runs: `from upsonic import load_dotenv` or project `dotenv`.

## Additional references

- **llms-full.txt workflow:** [references/llms-docs.md](references/llms-docs.md)
- Framework overview (from introduction): [references/framework-overview.md](references/framework-overview.md)
- Curated doc links by topic: [references/docs-links.md](references/docs-links.md)
- Autonomous / Deep / Chat / Direct / StateGraph: [references/primitives.md](references/primitives.md)
