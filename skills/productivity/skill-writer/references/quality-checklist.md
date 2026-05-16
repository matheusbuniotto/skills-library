# Skill Quality Checklist

Use this when reviewing a skill before sharing it.

## Discovery

- [ ] `name` is lowercase, hyphenated, and under 64 characters
- [ ] `description` is specific and under 1024 characters
- [ ] `description` says both what the skill does and when to use it
- [ ] `description` includes the keywords, contexts, file types, or intents that distinguish it from neighboring skills
- [ ] the skill does not rely on a separate "When to use" section to compensate for a vague description

## Body Quality

- [ ] `SKILL.md` stays focused and concise
- [ ] important workflows have clear steps
- [ ] examples are concrete rather than abstract
- [ ] terminology is consistent across all files
- [ ] no stale or time-sensitive guidance is embedded without context
- [ ] the skill recommends defaults instead of dumping many equal options on the agent

## Progressive Disclosure

- [ ] detailed material lives in `references/` when it is not always needed
- [ ] bundled references are linked directly from `SKILL.md`
- [ ] references do not require multi-hop navigation to reach important details
- [ ] longer references include enough structure to skim efficiently

## Resources

- [ ] scripts exist only when deterministic code is genuinely useful
- [ ] fragile operations use scripts or exact commands instead of asking the agent to improvise
- [ ] scripts handle predictable failures explicitly
- [ ] assets are included only when they are meant to be reused in outputs

## Testing

- [ ] at least three representative requests have been tried
- [ ] at least one non-trigger case has been considered
- [ ] failures observed during testing were folded back into the skill
- [ ] the skill works from its own text and resources, not hidden evaluator knowledge

