# Skill Authoring Examples

## Good Description

```yaml
description: Extract text and tables from PDF files, fill forms, and merge documents. Use when working with PDFs, forms, document extraction, or `.pdf` files.
```

Why it works:

- says what the skill does
- includes concrete trigger contexts
- distinguishes itself from generic document skills

## Weak Description

```yaml
description: Helps with documents.
```

Why it fails:

- too broad
- no trigger terms
- gives the agent no reason to prefer it over neighboring skills

## Good Workflow

```markdown
## Workflow

1. Inspect the input files.
2. Extract the required fields.
3. Validate the output against the source.
4. Revise any mismatches before returning the result.
```

Why it works:

- ordered
- observable
- includes a quality loop

## Weak Workflow

```markdown
## Workflow

Handle the document carefully and make sure it is correct.
```

Why it fails:

- no executable sequence
- no verification point
- leaves the hardest decisions unstated

## Good Use of References

```markdown
## Resources

- [references/redlining.md](references/redlining.md) — read when tracked changes are required
- [references/forms.md](references/forms.md) — read when filling PDF forms
```

Why it works:

- references are direct
- the loading condition is explicit
- advanced material stays out of the base context

