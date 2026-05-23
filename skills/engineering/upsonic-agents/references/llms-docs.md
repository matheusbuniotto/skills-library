# Upsonic documentation sources

Upsonic publishes machine-readable docs for IDEs and agents. Use them **before guessing APIs**.

| File | URL | Size | Use for |
|------|-----|------|---------|
| **llms.txt** | https://docs.upsonic.ai/llms.txt | ~60 KB | Discover page titles + URLs; pick the right doc to fetch |
| **llms-full.txt** | https://docs.upsonic.ai/llms-full.txt | ~2.2 MB | Full markdown dump of all pages; grep locally for APIs, examples, params |
| **Live site** | https://docs.upsonic.ai/get-started/introduction | — | Human reading; IDE can add llms-full URL per [IDE integration](https://docs.upsonic.ai/get-started/ide-integration) |

## Local cache (recommended)

From the skill directory:

```bash
bash scripts/sync-upsonic-docs.sh
```

Writes:

- `references/cache/llms.txt`
- `references/cache/llms-full.txt`

Re-run after Upsonic releases or when docs feel stale.

## How agents should use llms-full.txt

1. **Discover** — read `cache/llms.txt` or grep it for a keyword (e.g. `MCPHandler`, `Memory`, `continue_run`).
2. **Deep dive** — grep `cache/llms-full.txt` for the symbol or section title:

```bash
rg -n "MCPHandler" references/cache/llms-full.txt | head
rg -n "^# (Running Agents|Memory)$" references/cache/llms-full.txt
```

3. **Format** — each page in `llms-full.txt` starts with:

```text
# Page Title
Source: https://docs.upsonic.ai/...
```

Read from that heading until the next `# Title` block.

4. **If cache missing** — run `sync-upsonic-docs.sh` or:

```bash
curl -fsSL https://docs.upsonic.ai/llms-full.txt -o /tmp/upsonic-llms-full.txt
rg -n "your_term" /tmp/upsonic-llms-full.txt
```

## Cursor / IDE

Add to project or user docs (per Upsonic IDE integration):

```text
https://docs.upsonic.ai/llms-full.txt
```

That gives the editor retrieval over the full corpus; this skill’s cache is for **agent shell grep** when MCP/web fetch is unavailable.

## Related in this skill

- Curated links by topic: [docs-links.md](docs-links.md)
- Framework intro (distilled): [framework-overview.md](framework-overview.md)
- Implementation patterns: [../SKILL.md](../SKILL.md)
