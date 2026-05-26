---
name: example-skill
description: >-
  REPLACE ME. What this skill does and WHEN to use it — lead with the trigger ("Use when the user
  asks to …"). Claude routes on this text; description + when_to_use is truncated at 1,536 chars in
  the skill listing, so put the key use case first.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob
argument-hint: "[topic]"
---

# Example skill

A manually-invoked skill. `disable-model-invocation: true` means only the user fires it — by typing
`/example-plugin:example-skill` — and Claude never auto-loads it. The command name comes from the
directory (`example-skill`), namespaced by the plugin. Delete this directory if your plugin ships no
skills.

## When to use

- The user explicitly runs `/example-plugin:example-skill`.

## Steps

1. Describe the first step here.
2. Describe the second step.

Anything typed after the skill name arrives as `$ARGUMENTS` (here: `$ARGUMENTS`). For positional
access use `$0`, `$1`, … or declare named `arguments:` in the frontmatter.

<!-- This HTML comment is stripped before the skill loads into context — use it for maintainer notes. -->
