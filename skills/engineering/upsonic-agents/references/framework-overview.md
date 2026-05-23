# Upsonic framework overview

Distilled from https://docs.upsonic.ai/get-started/introduction (see llms-full.txt for full site).

Upsonic is a Python framework for **autonomous agents** (OpenClaw / Cowork-style) and **traditional** single-task agents plus **multi-agent teams**. One pipeline covers agents, tools, memory, knowledge bases, teams, and deployment.

## Install & keys

```bash
uv pip install upsonic
```

Provider keys in `.env` — 30+ providers (OpenAI, Anthropic, Google, Bedrock, Azure, Ollama, vLLM, Groq, OpenRouter). See [LLM Support](https://docs.upsonic.ai/concepts/llm-support/llm-overview).

## Two agent primitives

| Primitive | When |
|-----------|------|
| **AutonomousAgent** | Open-ended multi-step work; shell/filesystem in sandboxed `workspace` |
| **Agent** + **Task** | Structured tool-driven tasks with defined I/O |

```python
# Autonomous
from upsonic import AutonomousAgent, Task
agent = AutonomousAgent(model="anthropic/claude-sonnet-4-5", workspace="/path/to/logs")
agent.print_do(Task("Analyze server logs and detect anomaly patterns"))

# Traditional
from upsonic import Agent, Task
from upsonic.tools import tool

@tool
def sum_tool(a: float, b: float) -> float:
    """Add two numbers together."""
    return a + b

agent = Agent(model="anthropic/claude-sonnet-4-5", name="Calculator")
agent.print_do(Task(description="Calculate 15 + 27", tools=[sum_tool]))
```

## Core building blocks

- **Prebuilt Autonomous Agents** — community installable agents
- **Tools** — `@tool`, MCP, integrations (Tavily, Firecrawl, E2B, YFinance, …)
- **Memory** — conversation, focus, summary; SQLite, Postgres, Redis, Mongo, Mem0
- **Knowledge Base (RAG)** — loaders, splitters, embeddings, vector stores
- **Teams** — Sequential, Coordinate, Route modes
- **Skills** — reusable capabilities from local paths, URLs, GitHub
- **OCR** — unified OCR across providers
- **HITL** — confirmations, user input, durable pauses
- **Tracing** — Langfuse, PromptLayer
- **Safety Engine** — guardrails (privacy, financial, security, content)

## Doc navigation (site map)

**GET STARTED:** Introduction, Quickstart, Installation, Guides, Examples, IDE Integration

**CONCEPTS:** Agent, Autonomous Agent, Prebuilt Autonomous Agents, Safety Engine, Task, Tools, Usage Registry, Tracing, Skills, Memory, Knowledge Base, Team, LLM Support, OCR, HITL, Culture, Deep Agent, Direct LLM Call, Interfaces, Chat, StateGraph, UEL, Simulation, Evals, Canvas, Graph

**CLI:** Overview, Initialization, Start Agent API

**SNIPPETS:** AGENTS.md, BOOTSTRAP.md, SKILL.md, SOUL.md, USER.md

**DEPLOYMENT:** Overview, FastAPI, Django

## Next steps (official)

- [Quickstart](https://docs.upsonic.ai/get-started/quickstart)
- [Framework 101 / guides](https://docs.upsonic.ai/guides/2-create-an-agent)
- [Examples](https://docs.upsonic.ai/examples/overview/introduction)
- [IDE Integration](https://docs.upsonic.ai/get-started/ide-integration) — add `https://docs.upsonic.ai/llms-full.txt`
