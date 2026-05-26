# 06 · Hooks

> **Intent:** Wire a hook that fires on a Claude Code lifecycle event, and write a guard that can
> block a tool call — without slowing the hot path.
> **Reads-with:** `05-subagents`, `01-anatomy-and-layout`.

## The shape

Hooks live in `hooks/hooks.json` (or inline under `hooks` in `plugin.json`). The structure is an
event → matcher → handler list:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}\"/hooks/example-hook.sh",
            "description": "What this hook does."
          }
        ]
      }
    ]
  }
}
```

- `matcher` is a tool-name pattern (`"Write|Edit"`), regex-style with `|` to OR. Event names are
  **case-sensitive** (`PostToolUse`, not `postToolUse`).
- Reference scripts with `"${CLAUDE_PLUGIN_ROOT}"` (quoted, shell form) and **`chmod +x`** them.

## Events and types

Hooks fire on a large set of lifecycle events. The ones you'll use most:

| Event | Fires |
| ----- | ----- |
| `PreToolUse` | before a tool call — **can block it** |
| `PostToolUse` | after a tool call succeeds |
| `UserPromptSubmit` | when the user submits a prompt |
| `SessionStart` | when a session begins/resumes (e.g. install deps) |
| `Stop` | when Claude finishes responding |
| `SubagentStart` / `SubagentStop` | around a subagent's lifecycle |

(The full list — `PreCompact`, `InstructionsLoaded`, `Notification`, … — is in the official hooks
reference.) Hook `type` is one of: `command` (run a script), `http` (POST the event JSON),
`mcp_tool` (call an MCP tool), `prompt` (evaluate an LLM prompt), `agent` (run a verifier agent).

## Exit codes and stdin

A `command` hook receives the event as **JSON on stdin** and signals its verdict via exit code:

| Exit | Effect |
| ---- | ------ |
| `0` | pass through (for `PostToolUse`, output is advisory) |
| `2` | in a **`PreToolUse`** hook, **block** the tool call; stderr is fed back to Claude |

The exit code is load-bearing. `skeleton/hooks/example-hook.sh` is a non-blocking `PostToolUse`
example (reads stdin, logs the path, exits 0).

## The guard pattern

The most powerful plugin hook is a **`PreToolUse` write-guard**: it inspects the pending tool call
and exits `2` to block writes outside an allow-list. The calibration plugin ships two
(`calibrator-write-guard.sh`, `audit-write-guard.sh`) that enforce a subagent's allowed write paths.
The discipline that makes a guard safe:

- **Fail open on the irrelevant case.** Exit `0` early when the guard doesn't apply (wrong subagent,
  path already allowed). A guard that errors should not wedge the session.
- **Zero standing cost.** It runs on *every* matching tool call — keep it a few milliseconds of
  local shell.

> **MUST NOT** put `curl`/`wget`/remote `npx` on a hook's hot path. A network round-trip on every
> tool call is unacceptable latency, and it's a supply-chain risk. Bundle everything under
> `${CLAUDE_PLUGIN_ROOT}`.

## What to verify

- The script is executable (`chmod +x`) and starts with a `#!/usr/bin/env bash` shebang.
- The `command` path uses `"${CLAUDE_PLUGIN_ROOT}"`, not an absolute path.
- `claude --debug` shows the hook registering; trigger the matched tool and confirm it fires.
