# Deep Agents Official Docs Map

Use the official LangChain docs as the source of truth for current APIs and behavior.

## Start Here

Before exploring pages, fetch:

- `https://docs.langchain.com/llms.txt`

Use the index to confirm current page names and discover newly added docs. Prefer the **Python** pages below unless the codebase is JavaScript/TypeScript.

## Core Reading Path

| Need | Read |
|---|---|
| Decide whether Deep Agents fits | `/oss/python/deepagents/overview` |
| Build the first runnable agent | `/oss/python/deepagents/quickstart` |
| Understand the harness capabilities | `/oss/python/deepagents/harness` |
| See `create_deep_agent` options | `/oss/python/deepagents/customization` |

## Capability Map

| Topic | Official page |
|---|---|
| Virtual filesystem and backend selection | `/oss/python/deepagents/backends` |
| Filesystem permissions | `/oss/python/deepagents/permissions` |
| Context strategy for long runs | `/oss/python/deepagents/context-engineering` |
| Persistent memory | `/oss/python/deepagents/memory` |
| Reusable skills | `/oss/python/deepagents/skills` |
| Synchronous delegation | `/oss/python/deepagents/subagents` |
| Background / concurrent delegation | `/oss/python/deepagents/async-subagents` |
| Human approval gates | `/oss/python/deepagents/human-in-the-loop` |
| Sandbox-backed shell execution | `/oss/python/deepagents/sandboxes` |
| Lightweight in-loop code execution | `/oss/python/deepagents/interpreters` |
| Provider/model configuration bundles | `/oss/python/deepagents/profiles` |
| Production concerns | `/oss/python/deepagents/going-to-production` |

## Adjacent Pages Worth Checking

| Topic | Official page |
|---|---|
| Model selection | `/oss/python/deepagents/models` |
| Managed deployment | `/oss/python/deepagents/managed-deep-agents` |
| Agent Client Protocol | `/oss/python/deepagents/acp` |
| MCP integration | `/oss/python/deepagents/mcp` |
| A2A server | `/oss/python/deepagents/a2a` |
| Deep Agents Code overview | `/oss/python/deepagents/code/overview` |
| Deep Agents Code memory and skills | `/oss/python/deepagents/code/memory-and-skills` |
| Deep Agents Code subagents | `/oss/python/deepagents/code/subagents` |
| Remote sandboxes in Deep Agents Code | `/oss/python/deepagents/code/remote-sandboxes` |

## Example-Oriented Pages

| Example | Official page |
|---|---|
| Deep research agent | `/oss/python/deepagents/deep-research` |
| Content builder agent | `/oss/python/deepagents/content-builder` |
| Data analysis agent | `/oss/python/deepagents/data-analysis` |
| Streaming behavior | `/oss/python/deepagents/streaming` |
| Event streaming | `/oss/python/deepagents/event-streaming` |

## Reading Rules

1. Open the narrowest relevant page first.
2. Check the page date or changelog if the implementation depends on unstable behavior.
3. Use example pages only after understanding the underlying capability page.
4. If docs and local examples disagree, follow the official docs and treat the local example as stale until updated.
