---
name: deep-agents
description: Build, review, and reason about LangChain Deep Agents systems. Use when working with `deepagents`, `create_deep_agent`, agent harness design, planning with `write_todos`, virtual filesystem backends, permissions, subagents, context management, skills, memory, sandboxes, interpreters, human-in-the-loop flows, or when deciding whether Deep Agents is the right abstraction for a long-running agent.
---

# Deep Agents

Use this skill to help build **Deep Agents applications that stay understandable as they gain planning, files, memory, and delegation**.

Deep Agents is not the default answer for every agent. Start by checking whether the task actually needs the harness: multi-step planning, large context, filesystem-backed work, persistent memory, or isolated subagents. If not, prefer a simpler agent or a direct LangGraph workflow.

## Working Rules

1. **Use the current official docs as source of truth.** Before exploring Deep Agents documentation, fetch the LangChain docs index at `https://docs.langchain.com/llms.txt`, then open only the relevant Python pages for the task. Read [official-docs-map.md](references/official-docs-map.md) when choosing pages.
2. **Treat local course material as examples, not API truth.** Use it for mental models, pedagogy, and runnable examples after checking the current docs. Read [local-course-map.md](references/local-course-map.md) when the user wants examples or teaching support.
3. **Keep the architecture honest.** Decide explicitly on:
   - why this needs Deep Agents instead of a lighter alternative
   - what belongs in tools vs memory vs skills
   - which backend stores which files
   - whether subagents, permissions, human approval, or code execution are actually needed
4. **Build the smallest runnable harness first.** Start with a working agent, then add one capability at a time: tools, backend, permissions, memory/skills, subagents, human-in-the-loop, code execution.
5. **Prefer context isolation over prompt inflation.** Use files, references, and subagents to keep the main agent focused instead of stuffing every instruction and intermediate result into the top-level prompt.

## Decision Flow

### 1. Decide whether Deep Agents is the right fit

Use Deep Agents when the task needs one or more of:

- explicit multi-step planning
- long-running work with large intermediate context
- filesystem-backed artifacts or memory
- delegation to specialized subagents
- approval gates or durable execution

If the job is a single prompt, a thin tool-calling agent, or a highly custom deterministic graph, say so and consider a simpler design.

### 2. Classify the user's need

| User need | First docs to read |
|---|---|
| "Should I use Deep Agents?" | overview, harness |
| "Build my first agent" | quickstart, customization |
| "How should I store files or memory?" | backends, memory, context engineering |
| "How do I split work?" | subagents, async subagents |
| "How do I keep it safe?" | permissions, human-in-the-loop |
| "How do I run code?" | sandboxes, interpreters |
| "How do I package reusable behavior?" | skills, memory |

Use [official-docs-map.md](references/official-docs-map.md) for the exact page map.

### 3. Make the design decisions before writing much code

Capture these seven answers:

1. **Fit** — Why Deep Agents here?
2. **Model and tools** — What must the model call?
3. **Backend** — Which files are ephemeral, local, or persistent?
4. **Context** — What belongs in prompt, files, memory, and skills?
5. **Delegation** — Are subagents helpful, and what boundaries do they own?
6. **Safety** — Which paths or tools need permissions or approval?
7. **Execution** — Is shell access needed, or is an interpreter enough?

If one of those answers is unknown, pause there instead of hiding the gap behind extra abstraction.

### 4. Implement incrementally

Recommended order:

1. Minimal `create_deep_agent(...)`
2. One real tool
3. Backend choice
4. Permissions if files are exposed
5. Memory and skills if behavior must persist or be reusable
6. Subagents only after the main task shape is clear
7. Human-in-the-loop or code execution when the use case proves it needs them

Read [implementation-notes.md](references/implementation-notes.md) for compact patterns and failure modes while coding.

Load focused references only when the task needs them:

- [context-and-backends.md](references/context-and-backends.md) — prompts, compression, offloading, runtime context, backend routing, and permissions
- [subagents.md](references/subagents.md) — delegation boundaries, the default `general-purpose` worker, and sync vs async choices
- [memory-skills-and-execution.md](references/memory-skills-and-execution.md) — memory, skills, sandboxes, interpreters, and human approval

### 5. Verify the harness, not just the happy path

Before calling the work done, verify:

- the agent can finish a representative multi-step task
- large intermediate data does not pollute the main context unnecessarily
- persistent memory survives the intended boundary
- permissions behave as expected
- subagents return useful summaries rather than dumping raw work
- approval gates pause where they should
- the chosen backend matches the deployment model

## Resource Guide

- [official-docs-map.md](references/official-docs-map.md) — authoritative map from task to current LangChain Deep Agents docs
- [implementation-notes.md](references/implementation-notes.md) — compact design and implementation heuristics
- [context-and-backends.md](references/context-and-backends.md) — context strategy, storage, and permission design
- [subagents.md](references/subagents.md) — delegation and context-isolation guidance
- [memory-skills-and-execution.md](references/memory-skills-and-execution.md) — persistence, reusable capabilities, and code-execution choices
- [local-course-map.md](references/local-course-map.md) — your local Scoras Deep Agents examples and what each module is useful for
