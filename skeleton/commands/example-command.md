---
description: >-
  REPLACE ME. The flat-file command form. A file at commands/<name>.md creates
  /example-plugin:<name>, equivalent to a skill. Prefer skills/ for new plugins (they support
  supporting files and a directory); commands/ is the classic flat layout, kept for back-compat.
disable-model-invocation: true
allowed-tools: Read, Bash(git status:*)
argument-hint: ""
---

Show the current git status and summarize anything uncommitted.

## Working tree

!`git status --short`

## Task

Summarize the output above in one or two lines. If it is empty, say the tree is clean.
