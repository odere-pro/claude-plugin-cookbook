# 04 · Skills

> **Intent:** Author a `SKILL.md` and, when it earns it, a full skill bundle — the primary way a
> plugin adds capability and ships instructions into a user's context.
> **Reads-with:** `03-commands`, `05-subagents`, `07-rules`.

## The shape

A skill is a directory with `SKILL.md` as its entry point. The command name comes from the
**directory** (`skills/review/SKILL.md` → `/plugin:review`), so the frontmatter `name` is just the
display label. Supporting files load only when referenced:

```text
skills/<name>/
├── SKILL.md          # frontmatter + body (required)
├── reference.md      # detailed rules, loaded on demand
├── scripts/          # scripts the skill runs (executed, not read into context)
└── examples/         # sample inputs/outputs
```

> **SHOULD:** keep `SKILL.md` under ~500 lines. Once invoked, the body stays in context for the rest
> of the session, so every line is a recurring cost. Push long reference material into `reference.md`
> and link to it. (The calibration plugin's `calibrate-*` bundles are the worked example: a thin
> `SKILL.md` over a `reference.md` + `scripts/` + `examples/`.)

## Frontmatter reference

All fields are optional; only `description` is recommended.

| Field | Purpose |
| ----- | ------- |
| `name` | Display label (defaults to the directory name) |
| `description` | What it does + when to use it. **Routing cue.** Lead with the trigger |
| `when_to_use` | Extra trigger phrases; appended to `description` |
| `disable-model-invocation` | `true` → only the user invokes; removes the skill from Claude's routing context |
| `user-invocable` | `false` → only Claude invokes; hidden from the `/` menu |
| `allowed-tools` | Pre-approve tools while active (does **not** restrict; narrow the scopes) |
| `argument-hint` / `arguments` | Autocomplete hint / named positional args |
| `model` / `effort` | Override model / effort while the skill runs |
| `paths` | Glob patterns; auto-activate the skill only when matching files are in play |
| `context: fork` / `agent` | Run the skill in a forked subagent of the named type |

> **The 1,536-char routing budget.** `description` + `when_to_use` is truncated at 1,536 characters
> in the skill listing. Put the key use case first; spend the budget on triggers, not prose.

## Who invokes it

| Frontmatter | You can invoke | Claude can invoke | Description in context? |
| ----------- | :------------: | :---------------: | :---------------------: |
| (default) | yes | yes | yes |
| `disable-model-invocation: true` | yes | no | no |
| `user-invocable: false` | no | yes | yes |

> **MUST:** any side-effecting skill (deploy / commit / publish / release / delete / post) sets
> `disable-model-invocation: true`. You don't want Claude deciding to deploy because the code looks
> ready. The calibration plugin enforces this on **every** shipped skill as a house rule — a strong
> default worth copying.

## Pre-approving tools

`allowed-tools` grants the listed tools without a per-use prompt while the skill is active; it does
not block anything else. Scope narrowly — `Bash(git status:*)`, not bare `Bash`:

```yaml
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git status:*)
```

## String substitutions

Available in the body: `$ARGUMENTS`, `$0`/`$1`/`$ARGUMENTS[N]`, named `$name`, `${CLAUDE_SESSION_ID}`,
`${CLAUDE_EFFORT}`, and `${CLAUDE_SKILL_DIR}` — the skill's own directory, the right way to reference
a bundled script regardless of the working directory:

```markdown
Run the analysis: !`python3 ${CLAUDE_SKILL_DIR}/scripts/analyze.py .`
```

## Running in a subagent

`context: fork` runs the skill's body as the prompt for a fresh subagent (pick the type with
`agent:`). The forked run has no conversation history — use it for self-contained research or
generation tasks. For the inverse (a subagent that *preloads* skills as reference), see
`05-subagents`.
