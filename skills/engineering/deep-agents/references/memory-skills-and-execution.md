# Memory, Skills, and Execution

Read this when the question touches **persistent knowledge, reusable behavior, code execution, or safety gates**.

## Official Docs

- `/oss/python/deepagents/memory`
- `/oss/python/deepagents/skills`
- `/oss/python/deepagents/sandboxes`
- `/oss/python/deepagents/interpreters`
- `/oss/python/deepagents/human-in-the-loop`

## Memory

Use memory for information that should survive across conversations:

- user preferences
- project conventions
- accumulated facts
- long-lived operating guidance

### Scope Choices

| Scope | Use when |
|---|---|
| agent-scoped | all users should share the agent's accumulated knowledge |
| user-scoped | preferences and memories must stay isolated per user |
| organization-scoped | shared policy or institutional knowledge matters |

### Design Notes

- Long-term memory is filesystem-backed through your chosen backend.
- Keep always-loaded memory concise.
- For shared writable memory, watch for concurrent-write contention; topic-split files or background consolidation reduce collisions.
- Use permissions when some memory should be read-only.

## Skills

Use skills for **procedural memory**:

- repeatable workflows
- domain-specific instructions
- bundled references, scripts, and assets

Deep Agents skills:

- live in skill directories with `SKILL.md`
- load frontmatter at startup
- load full content only when relevant
- can include references, scripts, and assets

### Skills vs Memory

| Need | Prefer |
|---|---|
| Applies to every conversation | memory |
| Applies only to certain tasks | skill |
| Reusable step-by-step behavior | skill |
| Stable preference or convention | memory |

## Sandboxes vs Interpreters

| Need | Prefer |
|---|---|
| Shell commands, package installs, OS files, CLI tools | sandbox backend |
| Lightweight in-loop code, batching, deterministic transforms, programmatic tool composition | interpreter |

Sandbox backends expose `execute` in addition to file operations. Interpreters keep work inside the agent loop without providing shell or filesystem access.

## Human-in-the-loop

Use human approval when a tool call is:

- destructive
- costly
- security-sensitive
- ambiguous enough that human intent matters

The docs require a **checkpointer** for human-in-the-loop so the run can pause and resume safely. Pair approval gates with permissions; they solve different problems.

## Practical Separation

| Concern | Put it in |
|---|---|
| "Always write concise answers" | memory |
| "How to review a PR in this org" | skill |
| "Remember this user likes Python examples" | user-scoped memory |
| "Run pytest and inspect files" | sandbox |
| "Sort, filter, batch, transform" | interpreter |
| "Ask before editing production config" | human-in-the-loop |

## Review Checklist

- Is durable information in memory rather than buried in chat?
- Are reusable workflows in skills instead of a bloated base prompt?
- Is code execution stronger than necessary for the task?
- If shell access exists, is the safety model explicit?
- If the agent can pause for approval, is checkpointing configured?

