---
name: skill-writer
description: Create and improve reusable agent skills with clear triggers, concise instructions, progressive disclosure, bundled resources, and practical validation. Use when the user asks to create, write, design, refactor, review, or improve a `SKILL.md` file or an agent skill folder.
---

# Skill Writer

Use this skill to produce **skills that another agent can discover quickly and execute reliably**.

## Quick Start

For a new skill:

1. Clarify the concrete job the skill should help with.
2. Write a specific `description` that says both what it does and when to use it.
3. Put only the core workflow in `SKILL.md`.
4. Move detailed references, examples, and deterministic utilities into bundled resources.
5. Test the skill on representative requests before calling it done.

## Workflow

### 1. Understand the skill before writing it

Capture:

- the job the skill should perform
- realistic user requests that should trigger it
- realistic requests that should **not** trigger it
- whether the work needs instructions, references, scripts, assets, or some mix

Do not start by filling a template if the actual use cases are still fuzzy.

### 2. Write the discovery surface first

The frontmatter is the only part always visible before the skill is loaded:

```yaml
---
name: <lowercase-hyphenated-name>
description: <What it does>. Use when <specific triggers, contexts, or file types>.
---
```

Prefer a crisp third-person description with distinguishing keywords over a vague capability label.

### 3. Keep `SKILL.md` lean

Use the body for:

- a quick start
- the main workflow
- high-value rules Claude is unlikely to know already
- direct links to bundled resources

Move detail out when:

- the file starts mixing multiple domains
- advanced cases are rarely needed
- a reference would be easier to load only on demand
- deterministic code would otherwise be rewritten repeatedly

### 4. Add bundled resources only when they earn their place

| Need | Prefer |
|---|---|
| Detailed background or API docs | `references/` |
| Repeated deterministic operation | `scripts/` |
| Files used in the final output | `assets/` |

Keep references one level deep from `SKILL.md` so the agent can discover them directly.

### 5. Validate with real tasks

Before sharing:

1. Run at least three representative requests through the skill.
2. Watch where the agent hesitates, overreads, or ignores the intended workflow.
3. Tighten the description, workflow, or resources based on observed failures.

If the skill only works when the evaluator already knows the intended answer, it is not ready yet.

## Authoring Rules

- Be concise; assume the agent is already capable.
- Prefer one recommended default over many peer options.
- Use concrete examples instead of abstract prose.
- Match specificity to fragility: looser guidance for judgment-heavy work, tighter steps or scripts for brittle work.
- Avoid time-sensitive claims unless they are clearly versioned or intentionally historical.
- Keep terminology consistent across the skill and every reference file.
- Make workflows verifiable: include outputs, checks, or revision loops when quality matters.

## Resource Guide

- [references/quality-checklist.md](references/quality-checklist.md) — use when reviewing a skill before sharing it
- [references/structure-patterns.md](references/structure-patterns.md) — use when deciding how to split content across the skill body and bundled files
- [references/examples.md](references/examples.md) — use when the user wants concrete good/bad examples

