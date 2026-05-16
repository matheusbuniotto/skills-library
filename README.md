# Skills Library

A curated collection of reusable agent skills for Claude Code, Codex, and other `skills`-compatible agents.

[![skills.sh](https://skills.sh/b/matheusbuniotto/skills-library)](https://skills.sh/matheusbuniotto/skills-library)

## Install

Install the whole library:

```bash
npx skills add matheusbuniotto/skills-library
```

List the available skills without installing:

```bash
npx skills add matheusbuniotto/skills-library --list
```

Install one skill into specific agents:

```bash
npx skills add matheusbuniotto/skills-library --skill deep-agents --agent claude-code codex
```

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

## Manual use

If you are not using the CLI, copy the relevant skill folder into the directory your agent expects, such as:

```text
.claude/skills/<skill-name>/
.agents/skills/<skill-name>/
```

For Claude Code specifically, you can also reference a raw GitHub URL directly in `CLAUDE.md` via `@`.

## Contributing

1. Choose the category that best fits the skill, or create a new one when the distinction is useful.
2. Create `skills/<category>/<skill-name>/SKILL.md` from `SKILL.md.template`.
3. Add the skill to that category's `README.md`.
4. Open a PR.
