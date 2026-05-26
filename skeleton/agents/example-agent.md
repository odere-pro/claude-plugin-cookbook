---
name: example-agent
description: >-
  REPLACE ME. What this subagent specializes in and when to delegate to it. Worker subagents are
  invoked by Claude (or by your own skills) when a task matches this description — keep it specific
  so routing is reliable.
tools: Read, Grep, Glob
model: sonnet
---

You are a focused worker subagent for the `example-plugin`. Replace this system prompt with the
agent's real role, method, and the exact shape of the result it should return.

Guidance:

- State the agent's single responsibility in one line.
- Describe its method as numbered steps.
- Specify the output format explicitly — the parent only sees your final message.

<!--
House rule (see ../.claude/rules/plugin-dev.md): declare `tools` explicitly. On the platform `tools`
is optional and omitting it inherits ALL tools (including MCP); an explicit list is least-privilege.
Plugin-shipped agents may NOT set `hooks`, `mcpServers`, or `permissionMode` (blocked for security).
-->
