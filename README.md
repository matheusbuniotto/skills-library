# Skills Library

A curated collection of reusable `SKILL.md` files for Claude Code.

## Skills

- [Engineering](skills/engineering/README.md) — architecture, implementation, debugging, and code review skills
- [Productivity](skills/productivity/README.md) — reusable workflows, documentation, and authoring support

## Structure

```text
skills-library/
├── README.md
├── SKILL.md.template
└── skills/
    └── <category>/
        ├── README.md
        └── <skill-name>/
            └── SKILL.md
```

## How to use a skill

Copy the relevant `SKILL.md` into your project's `.claude/skills/<skill-name>/SKILL.md`, then invoke it with `/skill-name` in Claude Code.

Alternatively, reference the raw GitHub URL directly in your `CLAUDE.md` via `@`.

## Contributing

1. Choose the category that best fits the skill, or create a new one when the distinction is useful.
2. Create `skills/<category>/<skill-name>/SKILL.md` from `SKILL.md.template`.
3. Add the skill to that category's `README.md`.
4. Open a PR.
