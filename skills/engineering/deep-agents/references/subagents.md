# Subagents

Read this when the task involves **delegation, specialization, parallel work, or keeping the supervisor context clean**.

## Official Docs

- `/oss/python/deepagents/subagents`
- `/oss/python/deepagents/async-subagents`
- `/oss/python/deepagents/context-engineering`

## Why Subagents Exist

Subagents are primarily a **context management tool**, not just an architecture flourish. They are useful when a task creates a lot of intermediate work that the supervisor does not need to keep in its own context.

Use them for:

- multi-step work with noisy tool output
- specialist instructions or toolsets
- different model needs
- work that can be summarized into a compact final result

Avoid them for:

- one-step tasks
- work where the supervisor needs every intermediate detail
- cases where delegation overhead is larger than the task

## Default vs Custom Subagents

Deep Agents includes a default **`general-purpose`** subagent:

- same system prompt as the main agent
- same tools
- same model unless overridden
- inherited skills when configured

Use the default worker when you want **context quarantine** without a distinct specialist role.

Create custom subagents when you need:

- a narrower tool surface
- a different model
- specialized instructions
- a stable role that will be reused

## Synchronous vs Async

| Need | Prefer |
|---|---|
| Supervisor should wait for one delegated result | synchronous subagent |
| Long-running background work, parallel streams, steering, or cancellation | async subagent |

Do not reach for async purely because it sounds more advanced; it is for genuinely concurrent workflows.

## Good Delegation Boundaries

A good subagent contract states:

1. what it owns
2. what inputs it receives
3. what final shape it should return
4. what it should not decide

Example:

```text
Researcher owns source gathering and synthesis for topic X.
Input: question, constraints, allowed sources.
Output: concise findings, citations, unresolved questions.
Do not decide the final product recommendation.
```

## Review Checklist

- Does each subagent have a clear reason to exist?
- Is its toolset smaller or its prompt sharper than the supervisor's?
- Can its output be returned as a compact result?
- Would raw intermediate work pollute the main context if not delegated?
- If multiple subagents run, who merges the outputs?

