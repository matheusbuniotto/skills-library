# Deep Agents Implementation Notes

Use these as compact heuristics while designing or reviewing a Deep Agents system.

## Mental Model

Deep Agents is an **agent harness** around a normal tool-calling loop. The harness becomes useful when the agent needs:

- planning (`write_todos`)
- a virtual filesystem
- context compression and offloading
- subagents for isolated work
- long-term memory and reusable skills
- optional approval gates or code execution

Do not add all of those by default. Add the capability because the task needs it.

## Where Things Belong

| Need | Put it in |
|---|---|
| Stable behavior or policy | `system_prompt` |
| Reusable task-specific procedure | `skills` |
| Cross-session facts, preferences, conventions | `memory` |
| Large artifacts or intermediate outputs | filesystem backend |
| Narrow independent task with noisy work | subagent |

## Backend Heuristics

| Situation | Prefer |
|---|---|
| Scratch work within one run/thread | default state-backed storage |
| Real local files | filesystem backend |
| Cross-thread persistence | store-backed memory |
| Mixed ephemeral + persistent paths | composite routing |

If the agent reads or writes sensitive paths, add explicit permissions before exposing the filesystem broadly.

## Subagent Heuristics

Use subagents when the task:

- is independently solvable
- would create a lot of noisy intermediate context
- benefits from specialist instructions or tools
- can return a concise final report

Avoid subagents when the supervisor needs every intermediate step, when the task is trivial, or when delegation only adds latency.

## Sandboxes vs Interpreters

| Need | Prefer |
|---|---|
| Install packages, run shell commands, edit environment files | sandbox backend |
| Batch tool calls, transform structured data, keep temporary calculations out of context | interpreter |

## Human-in-the-loop

Use approval gates for:

- destructive edits
- expensive external calls
- sensitive writes
- ambiguous actions where user intent materially changes the outcome

Approval is not a substitute for good permissions. Use both when appropriate.

## Failure Modes to Watch

| Smell | Likely issue |
|---|---|
| Giant system prompt full of every rule | Skills or memory should carry some of that load |
| Subagents returning raw transcripts | Delegation boundary is wrong; require concise results |
| Persistent facts living only in chat history | Use memory |
| Agent writes everywhere by default | Missing permission design |
| Shell execution used for tiny transforms | Interpreter or ordinary Python may be simpler |
| Deep Agents chosen for a one-shot task | Wrong abstraction |

## Minimal Build Order

1. One runnable agent
2. One real tool
3. Correct backend
4. Correct context placement
5. Only then add delegation, approvals, or code execution

