# claude-plugin-cookbook — dev memory

Project memory for working in **this** repository. This repo is **both** a reference cookbook for
building Claude Code plugins **and** the installable `plugin-cookbook` plugin itself — whose
`new-plugin` skill scaffolds a new plugin from `skeleton/`.

## Layout

| Path                         | Role                                                                                                |
| ---------------------------- | --------------------------------------------------------------------------------------------------- |
| `docs/cookbook/`             | the 14-chapter reference (`00`–`13`), the `SOFTWARE-3-0.md` thesis, and the `BOOTSTRAP.md` playbook |
| `.claude-plugin/`, `skills/` | the root **plugin-cookbook** plugin: manifests + the `new-plugin` scaffolding skill                 |
| `skeleton/`                  | the copyable starter plugin (its own author-only `CLAUDE.md` becomes a new plugin's project memory) |
| `.claude/`                   | author-only config: path-scoped house rules + a format-on-edit hook (never shipped)                 |
| `tests/gates/`               | standalone CI checks; `run-all.sh` is the runner                                                    |
| `.github/workflows/ci.yml`   | runs the gates on push / PR via Bun                                                                 |

Two `CLAUDE.md` files exist and serve different repos: **this** one (dev memory for the cookbook) and
`skeleton/CLAUDE.md` (a template installed as a new plugin's memory). `docs/cookbook/BOOTSTRAP.md` is
the playbook, not memory.

## Working rules

- Before a PR: `bun run lint:md`, `bun run format:check`, and `bash tests/gates/run-all.sh` must pass.
- Both the root plugin and `skeleton/` MUST stay `claude plugin validate --strict`-clean (gate `02`).
- Chapter numbers are stable — cite `04-skills`, never "the skills chapter". A new chapter goes at the
  end; don't renumber.
- Commits follow Conventional Commits; keep the history one-concern-per-commit (see
  `docs/cookbook/13-repository-hygiene.md`).
- Documentation is wrapped by hand (prettier runs with `proseWrap: preserve`); keep line breaks tidy.
