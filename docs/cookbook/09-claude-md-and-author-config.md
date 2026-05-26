# 09 · CLAUDE.md and author config

> **Intent:** Draw the line between what a plugin *ships* and the *author-only* config that turns a
> plain repo into a plugin-development repo. This is the conceptual core of the bootstrap playbook.
> **Reads-with:** `01-anatomy-and-layout`, `07-rules`, the package `BOOTSTRAP.md` playbook.

## The root `CLAUDE.md` is dev memory, not shipped context

This is the fact that surprises people:

> A `CLAUDE.md` at the plugin root is **not** loaded into an end user's session. Plugins contribute
> context through **skills, agents, and hooks** — not through `CLAUDE.md`. To ship instructions into
> a user's context, put them in a skill.

So the root `CLAUDE.md` exists for the people (and Claude) **developing** the plugin: what ships,
where things live, the gate map, where to read before editing. It is project memory for *this repo*,
which happens to be a plugin. When the plugin is installed, the file is copied into the cache but
never loaded. (`skeleton/CLAUDE.md` is written exactly this way.)

The CLAUDE.md memory hierarchy, for reference (broadest → most specific): **managed policy** →
**user** (`~/.claude/CLAUDE.md`) → **project** (`./CLAUDE.md` or `./.claude/CLAUDE.md`) → **local**
(`CLAUDE.local.md`). Block-level HTML comments are stripped before the content enters context — use
them for maintainer notes.

## `.claude/` is author-only config

A `.claude/` directory in the plugin repo is **not** a plugin component. It is the same project-config
mechanism any repo uses: house rules (`.claude/rules/*.md`), dev-only skills, maintenance agents. It
serves you while building the plugin and is invisible to end users.

This produces a clean two-zone repo:

| Zone | Examples | Loaded for users? |
| ---- | -------- | :---------------: |
| **Shipped components** | `skills/`, `commands/`, `agents/`, `hooks/`, `.mcp.json`, `.claude-plugin/` | yes |
| **Author-only config** | `CLAUDE.md`, `.claude/`, `tests/`, `.github/`, `README.md` | no (copied, never loaded) |

> There is no ship-whitelist or `.claudeignore`: Claude Code clones the **whole** repo into the
> cache. Author-only files cost nothing at runtime because Claude only *loads* recognized component
> dirs plus the manifest — so you don't need a build step to strip them.

## "Transform the repo for plugin purposes"

Standing up a plugin repo is two moves on top of creating the components:

1. **Override `.claude/`** — replace any generic project config with plugin-dev house rules: a
   path-scoped `.claude/rules/plugin-dev.md` (the hardening conventions from `10-validation-and-gates`),
   plus any maintenance skills/agents you want while developing.
2. **Override `CLAUDE.md`** — replace the repo's project memory with the plugin's: a "what ships /
   what doesn't" inventory, a source-layout table, the gate map, and a "where to read before editing"
   pointer. Start from `skeleton/CLAUDE.md` and edit it down.

The calibration plugin is the worked reference: its root `CLAUDE.md` opens with "every file under
here ships to end users… except `.claude/` (author config, never loaded)," then lists the source
layout and gate map. Copy that structure.

The package's `BOOTSTRAP.md` (alongside these chapters) is the **imperative** version of these
two moves — an agent-followable playbook you can run on a fresh repo.
