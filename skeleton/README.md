# example-plugin

<!-- REPLACE the your-handle/example-plugin slug below with your repo, then delete this comment.
     The CI badge is commented out: the starter ships no `.github/workflows/ci.yml`, so it would 404.
     Add a workflow first (see the cookbook's `10-validation-and-gates`), then uncomment it. -->

<!-- [![CI](https://github.com/your-handle/example-plugin/actions/workflows/ci.yml/badge.svg)](https://github.com/your-handle/example-plugin/actions/workflows/ci.yml) -->

[![plugin validate --strict](https://img.shields.io/badge/claude%20plugin%20validate-strict-brightgreen)](https://docs.claude.com/en/docs/claude-code/plugins)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)](https://docs.claude.com/en/docs/claude-code/plugins)

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
