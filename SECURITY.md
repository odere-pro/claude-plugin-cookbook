# Security policy

`plugin-cookbook` is a reference cookbook plus a scaffolder. It ships no network code and no compiled
binaries; its moving parts are Markdown instructions, JSON manifests, and a few Bash scripts.

## Trust model

The plugin's one privileged action — the `new-plugin` skill writing files — is fenced, and nothing it
ships reaches the network.

- **Scaffolding writes only into a new directory.** `/plugin-cookbook:new-plugin <name>` runs
  `skills/new-plugin/scripts/scaffold.sh`, which refuses a non-kebab name, **refuses to overwrite an
  existing `./<name>`**, copies the validated `skeleton/` there, then validates `--strict` and
  initializes a git history inside that new directory. It never edits files outside `./<name>`.
- **No network at routing time.** No shipped hook or script calls `curl` / `wget` or fetches a remote
  package; the gate `tests/gates/08-hooks-no-remote.sh` enforces this.
- **No secrets in shipped files.** `tests/gates/07-secret-scan.sh` scans for concrete credential
  formats; `tests/gates/04-no-absolute-paths.sh` blocks machine-specific paths.
- **The author-only `.claude/` config is never shipped.** Its format-on-edit hook only runs Prettier
  over files you just edited and is scoped to this repository (see `09-claude-md-and-author-config`).

## In scope

- The scaffolder writing outside the new `./<name>` directory, or overwriting an existing path.
- A shipped skill, manifest, or script leaking a secret or fetching untrusted remote content.
- A `skeleton/` file that fails `claude plugin validate --strict` or ships an unsafe default.

## Out of scope

- Files you create or edit by hand after scaffolding a new plugin.
- The behaviour of plugins you build from the skeleton once you customise them.
- Third-party GitHub Actions referenced by the workflows (these are pinned by commit SHA and tracked
  by Dependabot; report issues to their upstreams).

## Supported versions

| Version | Supported |
| ------- | --------- |
| 0.1.x   | ✅        |
| < 0.1   | ❌        |

## Reporting a vulnerability

Please report privately via **GitHub Security Advisories** —
<https://github.com/odere-pro/claude-plugin-cookbook/security/advisories/new> — rather than opening a
public issue. You can also reach the maintainer at <odere.pub@gmail.com>. We aim to acknowledge within
a few days and to fix or mitigate confirmed issues before any public disclosure.
