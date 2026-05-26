# 00 · Overview

> **Intent:** Give you the one mental model of a Claude Code plugin — what it is, what it's made of,
> and what it costs — before any single component is explained in depth.
> **Reads-with:** `01-anatomy-and-layout`, `02-manifest`.

## What a plugin is

A **plugin** is a self-contained directory of components that extends Claude Code. The components
are **skills**, **commands** (flat-file skills), **subagents**, **hooks**, and **MCP servers**, plus
a set of advanced/optional ones (LSP servers, monitors, themes, output styles, bundled executables).
A `.claude-plugin/plugin.json` manifest names the plugin and, optionally, carries metadata.

Users get a plugin one of two ways:

- **Marketplace install** — `/plugin install <name>@<marketplace>`. Claude Code copies the plugin
  into a local cache and loads it every session.
- **Local load** — `claude --plugin-dir ./path`, for the duration of a session. This is how you
  develop and test (see `11-distribution-and-versioning`).

## The mental model: descriptions are always-on, bodies load on invoke

This is the single idea that governs every design decision in the rest of the cookbook.

| Layer | When it's in context | Cost |
| ----- | -------------------- | ---- |
| **Listing text** — skill/agent/command *descriptions*, command *names* | Every session, always | Small, but paid by every user on every turn |
| **Bodies** — a skill's `SKILL.md`, an agent's prompt | Only when the component is invoked | Larger, but paid only when used |
| **Hooks / MCP servers** | Run in the harness, not the model context | No model-context cost; pay latency on the hot path |

So: a description is a **routing cue** Claude reads to decide *whether* to load the body. Write
descriptions for routing ("use when…", "after…"), keep bodies for instructions, and push long
reference material into supporting files that load on demand. `claude plugin details <name>` prints
the always-on vs on-invoke token cost of each component — read it before you ship.

## What ships, and what doesn't

A plugin contributes context through **skills, agents, and hooks** — not through a `CLAUDE.md`.

> A `CLAUDE.md` at the plugin root is **not** loaded into an end user's session. It is dev-repo
> memory for the people building the plugin. To ship instructions into a user's context, put them in
> a skill. (See `09-claude-md-and-author-config`.)

Likewise, a `.claude/` directory in the plugin repo is author-only project config — it is not a
plugin component and is never loaded for users. The clean split between *shipped components* and
*author-only config* is the heart of "transforming a repo for plugin purposes" (the `BOOTSTRAP.md`
playbook in this package walks it step by step).

## The fastest path

1. Copy `skeleton/` — a minimal plugin that already passes `claude plugin validate --strict`.
2. Rename it, fill in `plugin.json` and each component's `description`.
3. Keep the component directories you need; delete the rest.
4. `claude --plugin-dir .` → `/reload-plugins` → invoke a component.

Every later chapter explains one piece of that skeleton in depth. Start at `01-anatomy-and-layout`.
