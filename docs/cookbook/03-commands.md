# 03 · Commands

> **Intent:** Ship a slash command — the flat-file form of a skill — and know when to use it versus a
> full `skills/` directory.
> **Reads-with:** `04-skills` (the richer form), `01-anatomy-and-layout`.

## Commands are flat-file skills

Custom commands have merged into skills. A file at `commands/<name>.md` and a skill at
`skills/<name>/SKILL.md` both create a `/<name>` invocation and behave the same way. The command's
name comes from the **filename** (`commands/example-command.md` → `/example-plugin:example-command`).

> **SHOULD:** prefer `skills/<name>/SKILL.md` for new plugins — a skill directory can carry
> supporting files (reference docs, scripts, examples). Use `commands/` for genuinely simple,
> single-file commands or to keep a classic flat layout.

## Frontmatter

A command file takes the **same frontmatter as a skill** (`04-skills` has the full table). The
fields you reach for most:

| Field | Purpose |
| ----- | ------- |
| `description` | What it does + when; the routing cue. Lead with the trigger. |
| `disable-model-invocation` | `true` → only the user can run it; Claude never auto-fires it |
| `allowed-tools` | Pre-approve tools while the command runs (scope them narrowly) |
| `argument-hint` | Autocomplete hint, e.g. `[issue-number]` |

## Arguments

Whatever the user types after the command name is available in the body:

| Placeholder | Expands to |
| ----------- | ---------- |
| `$ARGUMENTS` | the full argument string |
| `$0`, `$1`, … | positional args (shell-style quoting; wrap multi-word in quotes) |
| `$ARGUMENTS[N]` | the Nth argument (0-based) |

If the body omits `$ARGUMENTS`, Claude Code appends `ARGUMENTS: <input>` so the command still sees
what was typed.

## Dynamic context injection

A `` !`command` `` line (at the start of a line or after whitespace) runs **before** Claude sees the
body, and its output replaces the placeholder. This grounds the command in live data:

```markdown
---
description: Summarize uncommitted changes. Use when the user asks what changed.
disable-model-invocation: true
allowed-tools: Read, Bash(git status:*)
---

## Working tree
!`git status --short`

## Task
Summarize the output above in one or two lines.
```

This is preprocessing, not a tool call — Claude only sees the rendered result. Use a fenced ` ```! `
block for multi-line commands. (`skeleton/commands/example-command.md` is exactly this pattern.)

## What to verify

- The file is at `commands/` in the plugin **root**, not under `.claude-plugin/`.
- The `description` leads with a trigger phrase.
- Any `` !`…` `` command is read-only and fast — it runs every time the command is invoked.
