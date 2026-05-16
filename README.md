# skills-library

A curated collection of `SKILL.md` files for Claude Code — reusable, prompt-ready engineering guides.

## Structure

```
skills-library/
├── README.md
├── CATALOG.md               # Index of all skills with one-line descriptions
└── skills/
    └── <skill-name>/
        └── SKILL.md         # The skill itself
```

## How to use a skill

Copy the relevant `SKILL.md` into your project's `.claude/skills/<skill-name>/SKILL.md`, then invoke it with `/skill-name` in Claude Code.

Alternatively, reference the raw GitHub URL directly in your CLAUDE.md via `@`.

## Contributing

1. Create `skills/<your-skill-name>/SKILL.md` following the template in `SKILL.md.template`
2. Add a one-line entry to `CATALOG.md`
3. Open a PR
