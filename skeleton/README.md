# example-plugin

<!-- REPLACE every your-handle/example-plugin slug below with your repo, then delete this comment.
     The CI badge tracks the shipped `.github/workflows/ci.yml`. The OpenSSF badges are commented out
     because they need a PUBLIC repo (Scorecard) and a registered project id (Best Practices) —
     uncomment them per the cookbook's `14-supply-chain-and-governance`. -->

[![CI](https://github.com/your-handle/example-plugin/actions/workflows/ci.yml/badge.svg)](https://github.com/your-handle/example-plugin/actions/workflows/ci.yml)
[![plugin validate --strict](https://img.shields.io/badge/claude%20plugin%20validate-strict-brightgreen)](https://docs.claude.com/en/docs/claude-code/plugins)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)](https://docs.claude.com/en/docs/claude-code/plugins)

<!-- Uncomment once the repo is public / the project is registered (see `14-supply-chain-and-governance`):
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/your-handle/example-plugin/badge)](https://scorecard.dev/viewer/?uri=github.com/your-handle/example-plugin)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/REPLACE-ME/badge)](https://www.bestpractices.dev/projects/REPLACE-ME)
-->

> REPLACE ME. One-line pitch: what this plugin gives a Claude Code user.

## Install

```text
/plugin marketplace add your-handle/example-plugin
/plugin install example-plugin@your-marketplace
```

Or load it locally while developing:

```bash
claude --plugin-dir /path/to/example-plugin
# then, in-session:
/reload-plugins
```

## What's inside

- `/example-plugin:example-skill` — REPLACE ME, what it does.
- `/example-plugin:example-command` — REPLACE ME, what it does.
- `example-agent` — a worker subagent Claude delegates to when REPLACE ME.
- A `PostToolUse` hook that REPLACE ME.

## Components

| Component  | Where                           | Invocation                        |
| ---------- | ------------------------------- | --------------------------------- |
| Skill      | `skills/example-skill/SKILL.md` | `/example-plugin:example-skill`   |
| Command    | `commands/example-command.md`   | `/example-plugin:example-command` |
| Subagent   | `agents/example-agent.md`       | delegated by Claude               |
| Hook       | `hooks/hooks.json`              | fires on `Write`/`Edit`           |
| MCP server | `.mcp.json`                     | auto-starts when enabled          |

## License

MIT
