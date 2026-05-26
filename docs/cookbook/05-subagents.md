# 05 · Subagents

> **Intent:** Ship a worker subagent with a correct, least-privilege frontmatter, and know when a
> subagent is the right tool over a skill.
> **Reads-with:** `04-skills`, `06-hooks`.

## The shape

A subagent is a single markdown file in `agents/<name>.md`: YAML frontmatter plus a system prompt
that defines the agent's role. Claude delegates to it when a task matches its `description`; it runs
in its own context window and returns a final message to the parent.

```markdown
---
name: example-agent
description: >-
  What this subagent specializes in and when to delegate to it. Keep it specific — Claude routes
  on this text.
tools: Read, Grep, Glob
model: sonnet
---

You are a focused worker subagent. <role, method, and the exact output shape to return.>
```

## Frontmatter reference

| Field | Purpose |
| ----- | ------- |
| `name` | Unique id; appears as `<plugin>:<name>` |
| `description` | What it does + when Claude should delegate. Routing cue |
| `model` | `haiku` / `sonnet` / `opus` / `inherit` |
| `effort` | `low` … `max` |
| `maxTurns` | Cap on agent turns |
| `tools` | **Explicit allow-list** of tools the agent may use |
| `disallowedTools` | Tools to subtract |
| `skills` | Skills to preload into the agent at startup |
| `memory` | Enable persistent per-agent auto-memory |
| `isolation` | Only valid value: `"worktree"` (run in a git worktree) |

> **SHOULD: declare `tools` explicitly.** On the platform `tools` is optional, and **omitting it
> inherits every tool — including MCP tools.** An explicit list is least-privilege and the calibration
> plugin enforces it on every shipped agent. Give a read-only reviewer `Read, Grep, Glob`; give a
> writer the narrowest set it needs.

> **MUST NOT** set `hooks`, `mcpServers`, or `permissionMode` on a plugin-shipped agent — the
> platform blocks these for security. (They are allowed on local user/project agents, not plugin
> ones.)

## Skill ↔ subagent, both directions

| Approach | System prompt | Task | Also loads |
| -------- | ------------- | ---- | ---------- |
| Skill with `context: fork` | from the agent type | the SKILL.md body | CLAUDE.md (except Explore/Plan) |
| Subagent with `skills:` field | the agent's own body | Claude's delegation message | the preloaded skills + CLAUDE.md |

So a skill can *become* a subagent task, and a subagent can *carry* skills as reference. Pick the
first when the work is a one-shot procedure; the second when you want a reusable specialist.

## When to use a subagent

- **Context isolation** — a noisy task (large search, long transcript) that shouldn't pollute the
  main thread.
- **Parallel fan-out** — many independent units of work. The calibration plugin fans one evaluator
  out to nine per-feature workers in parallel.
- **A focused specialist** — a reviewer, a planner, a build-fixer with a tightly-scoped prompt and
  toolset.

## Invocation boundary

Plugin subagents are invoked by **Claude** (or by your own skills' delegation), never typed directly
by the user as a first move. Routing lives in the skill/orchestrator layer, not in a routing table —
keep each agent's `description` precise so the right one is chosen.
