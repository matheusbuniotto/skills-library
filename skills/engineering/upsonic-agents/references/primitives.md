# Upsonic primitives (beyond Agent + Task)

Use this when the user’s problem is **not** a single structured tool task.

## Decision tree

```
Need open-ended coding / shell / files in a folder?
  → AutonomousAgent(workspace=...)

Need built-in todos + VFS + subagent spawning (Upsonic native)?
  → DeepAgent

Need multi-turn chat product with session metrics?
  → Chat

Need one LLM call, no tools?
  → Direct

Need explicit graph / nodes / parallel branches?
  → StateGraph

Need multiple specialists?
  → Team (sequential | coordinate | route)

Default: Agent + Task
```

## AutonomousAgent

- Sandboxed `workspace`; blocks path traversal and dangerous commands.
- Filesystem + shell tools built-in.
- Optional E2B cloud sandbox for isolation.
- Docs: https://docs.upsonic.ai/concepts/autonomous-agent/overview

```python
from upsonic import AutonomousAgent, Task

agent = AutonomousAgent(
    model="anthropic/claude-sonnet-4-6",
    workspace="/path/to/project",
)
agent.do(Task("Analyze logs under data/ and list anomalies"))
```

Configure behavior via `AGENTS.md` in workspace.

## DeepAgent (Upsonic)

Not LangGraph `create_deep_agent`. Upsonic’s DeepAgent adds planning, todos, virtual FS, subagent generation.

Docs: https://docs.upsonic.ai/concepts/deep-agent/overview

## Chat

Stateful sessions; shares memory patterns with Agent but optimized for conversational UX and chat-level metrics.

Docs: https://docs.upsonic.ai/concepts/chat/overview

## Direct

Fast structured extraction / classification without tool loop or memory.

Docs: https://docs.upsonic.ai/concepts/direct-llm-call/overview

## KnowledgeBase (RAG)

Attach to Task `context` or use as tool; control injection with `query_knowledge_base` on Task.

Docs: https://docs.upsonic.ai/concepts/knowledgebase/overview

## StateGraph

Low-level workflow graphs, parallel execution, custom nodes.

Docs: https://docs.upsonic.ai/concepts/stategraph/overview

## Prebuilt Autonomous Agents

Community installable agents for common domains.

Docs: https://docs.upsonic.ai/concepts/prebuilt-autonomous-agents/overview

## Deployment

- FastAPI agent API via CLI: https://docs.upsonic.ai/CLI/start-agent-api
- Agent/Team as MCP server: agent-as-mcp, team-as-mcp docs
