# 07 · Rules and path-scoped guidance

> **Intent:** Ship guidance that loads only when it's relevant — and understand why "rules" are a
> memory feature, not a plugin component.
> **Reads-with:** `04-skills`, `09-claude-md-and-author-config`.

## Rules are a memory feature, not a plugin component

Path-scoped **rules** are markdown files with a `paths:` frontmatter field. They live at
`.claude/rules/*.md` (project) or `~/.claude/rules/*.md` (user). A rule **without** `paths:` loads
every session; a rule **with** `paths:` loads only when Claude touches a matching file.

```markdown
---
paths:
  - "src/api/**/*.ts"
  - "tests/**/*.test.ts"
---

# API rules
- All endpoints validate input.
- Use the standard error envelope.
```

> The recognized **plugin** component list (`01-anatomy-and-layout`) does **not** include a `rules/`
> directory. Rules are a project/user memory mechanism. So a plugin ships scoped guidance one of two
> ways below.

## How a plugin ships scoped guidance

**1. A `paths:`-scoped skill (portable, recommended).** Skills support the same `paths:` field
(`04-skills`). A skill with `paths:` and `user-invocable: false` is the plugin-native equivalent of a
path-scoped rule: Claude auto-loads it only when working in matching files, and it never clutters the
`/` menu. This is the officially-supported way for a plugin to "ship instructions into context."

**2. A plugin-root `rules/` directory (the calibration convention).** The calibration plugin ships
`rules/signatures.md` and `rules/dispatch.md`, each with `paths:` frontmatter scoping them to the
calibration working directories. This keeps a canonical catalogue in one place at near-zero standing
cost. Treat it as a project-style convention layered on the plugin; if you need guaranteed,
version-independent loading, prefer option 1.

## The author side: `.claude/rules/` for plugin development

The most reliable use of path-scoped rules in a plugin repo is **author-only**: house rules for
*developing* the plugin. `skeleton/.claude/rules/plugin-dev.md` is exactly this — scoped to the
component directories so it loads only when you edit them:

```markdown
---
description: House rules for developing THIS plugin. Author-only; never shipped.
paths:
  - "skills/**"
  - "agents/**"
  - "hooks/**"
---

# Plugin-dev house rules
- Every shipped skill sets `disable-model-invocation: true` unless it must auto-fire.
- Agents declare `tools` explicitly.
- Hook scripts use `${CLAUDE_PLUGIN_ROOT}`; no network on the hot path.
```

This is `.claude/` config — it serves you and Claude while building the plugin, and is **not**
loaded for end users. The `BOOTSTRAP.md` playbook installs this file as part of "transforming the repo."

## `paths:` glob quick reference

| Pattern | Matches |
| ------- | ------- |
| `**/*.ts` | all TypeScript files |
| `src/**/*` | everything under `src/` |
| `*.md` | markdown at the project root |
| `src/**/*.{ts,tsx}` | brace expansion for multiple extensions |
