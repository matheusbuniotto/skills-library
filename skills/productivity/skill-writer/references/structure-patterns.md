# Skill Structure Patterns

Use this when deciding how to organize a skill.

## Pattern 1: Single-file skill

Use when the skill has:

- one narrow job
- little background material
- no reusable code or assets

```text
skill-name/
└── SKILL.md
```

## Pattern 2: Overview plus references

Use when the skill has one workflow but meaningful detail that is not always needed.

```text
skill-name/
├── SKILL.md
└── references/
    ├── api.md
    └── examples.md
```

`SKILL.md` should tell the agent **when** to read each reference.

## Pattern 3: Domain split

Use when one skill covers multiple domains and loading all of them every time would waste context.

```text
skill-name/
├── SKILL.md
└── references/
    ├── finance.md
    ├── sales.md
    └── product.md
```

## Pattern 4: Deterministic utilities

Use scripts when the same brittle operation would otherwise be regenerated again and again.

```text
skill-name/
├── SKILL.md
├── references/
│   └── usage.md
└── scripts/
    └── validate.py
```

Prefer scripts for validation, formatting, extraction, conversion, or other repeatable operations where consistency matters.

## Splitting Heuristic

Move content out of `SKILL.md` when:

- the body grows long
- one section is rarely needed
- examples overwhelm the main workflow
- a domain has its own vocabulary or rules
- the agent would benefit from loading only one slice of knowledge

Keep references one level deep from the main skill file.

