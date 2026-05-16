# Context and Backends

Read this when the question is about **what goes into context, what should live in files, or where those files should be stored**.

## Context Engineering

Official docs:

- `/oss/python/deepagents/context-engineering`
- `/oss/python/deepagents/harness`

Deep Agents manages several different kinds of context:

| Kind | Use for |
|---|---|
| `system_prompt` | Stable role, policies, and behavior |
| `memory` | Always-loaded cross-session context |
| `skills` | On-demand procedural knowledge |
| runtime context | Per-run metadata, IDs, credentials, feature flags |
| filesystem | Large artifacts and recoverable working material |
| subagents | Context isolation for noisy multi-step work |

### Placement Rules

- Keep the system prompt focused on enduring behavior.
- Put always-relevant conventions in memory, but keep memory small because it loads every run.
- Put detailed workflows in skills so they load only when relevant.
- Use runtime context for values that change per invocation; do not hardcode those into prompts.
- Offload large tool outputs and intermediate artifacts to files instead of keeping them in chat.

### Compression Behavior

Deep Agents uses two important compression strategies:

1. **Offloading** — move large tool results or artifacts into the filesystem.
2. **Summarization** — when context approaches model limits, replace older message history with a structured summary while preserving the original messages in files.

The docs describe summarization around **85% of the model context window**, with a fallback trigger when model-profile information is unavailable. Use that as a runtime behavior to understand, not as a reason to design giant prompts up front.

### Dynamic Prompting

Use dynamic prompt behavior only when instructions truly depend on runtime state, such as permissions, user identity, or feature flags. Otherwise, a static system prompt is simpler.

## Backend Selection

Official docs:

- `/oss/python/deepagents/backends`
- `/oss/python/deepagents/permissions`

| Backend shape | Best for |
|---|---|
| default state-backed storage | thread-local scratch work |
| filesystem-backed storage | real local files |
| store-backed storage | cross-thread persistence |
| composite routing | mixing ephemeral files with durable paths like `/memories/` |

### Composite Routing

Use composite routing when:

- `/workspace/` should stay ephemeral
- `/memories/` or `/skills/` should persist
- separate backend implementations need to appear as one virtual filesystem

This is usually the right design once an agent has both **working files** and **long-term memory**.

## Permissions

Permissions are declarative rules for built-in filesystem tools:

- rules are evaluated in declaration order
- **first matching rule wins**
- if nothing matches, the operation is allowed

Use permissions to:

- constrain work to a workspace
- protect `.env`, secrets, or policy files
- make some memory paths read-only
- give subagents narrower access than the supervisor

Important limit: permissions apply to the built-in filesystem tools, not arbitrary custom tools or sandbox command execution. If a sandbox can run shell commands, protect that capability separately.

## Design Checklist

- What information is static, per-run, on-demand, or long-lived?
- Which files must outlive a thread?
- Which paths should be writable, read-only, or hidden?
- Will large outputs be offloaded before they flood the main context?
- Are there cases where a subagent is better than more prompt text?

