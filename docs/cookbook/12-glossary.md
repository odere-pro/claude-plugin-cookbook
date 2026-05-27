# 12 · Glossary

> **Intent:** The canonical vocabulary for this cookbook. When prose elsewhere conflicts with an
> entry here, this wins.
> **Reads-with:** every chapter.

**Plugin** — a self-contained directory of components that extends Claude Code, named by a
`.claude-plugin/plugin.json` manifest.

**Manifest** — `.claude-plugin/plugin.json`. Optional; `name` is its only required field. The
**version of record** (`02-manifest`).

**Marketplace** — a catalog (`.claude-plugin/marketplace.json`) that distributes one or more plugins;
each entry has a `name` and a `source`.

**Component** — a recognized unit a plugin contributes: skill, command, subagent, hook, MCP server,
and the advanced ones (LSP, monitor, theme, output style, executable, settings).

**Skill** — a `skills/<name>/SKILL.md` capability (plus optional supporting files), invoked as
`/<plugin>:<name>` by you or Claude (`04-skills`).

**Command** — a flat-file skill at `commands/<name>.md`; the classic single-file form (`03-commands`).

**Subagent** — an `agents/<name>.md` worker with its own context and toolset that Claude delegates to
(`05-subagents`). _Agent_ and _subagent_ are used interchangeably for this; the user-facing actor is
the main Claude session, the delegate is the subagent.

**Hook** — an event handler in `hooks/hooks.json` that runs in the harness on a lifecycle event;
a `PreToolUse` hook can **block** a tool call via exit code 2 (`06-hooks`).

**MCP server** — a Model Context Protocol server bundled via `.mcp.json`; its tools appear in
Claude's toolkit automatically (`08-mcp`).

**Rule / path-scoped rule** — a `.claude/rules/*.md` memory file; with `paths:` frontmatter it loads
only when matching files are in play. A _project/user_ feature, not a plugin component (`07-rules`).

**`disable-model-invocation`** — skill/command frontmatter; `true` means only the user can invoke it
and it leaves Claude's routing context. Mandatory for side-effecting skills (`04-skills`).

**`user-invocable`** — skill frontmatter; `false` means only Claude invokes it (hidden from `/`).

**`allowed-tools`** — frontmatter that pre-approves tools while a skill/command is active; it grants,
it does not restrict.

**Routing / listing text** — the always-on `description` (+ `when_to_use`/command name) Claude reads
to decide whether to load a component. Capped at **1,536 characters** per skill listing.

**Routing budget** — the per-session character budget for listing text; overflow drops least-used
descriptions first.

**Hot path** — code that runs on every matching tool call (a hook) or session start. Must be fast and
local; no network.

**`${CLAUDE_PLUGIN_ROOT}`** — absolute path to the plugin's (ephemeral) install dir; changes on
update.

**`${CLAUDE_PLUGIN_DATA}`** — persistent per-plugin dir that survives updates; for caches, deps,
state.

**`${CLAUDE_PROJECT_DIR}`** — the user's project root.

**Version of record** — the precedence rule for a plugin's version: `plugin.json` > marketplace entry

> git SHA > `unknown` (`02-manifest`, `11-distribution-and-versioning`).

**Scope** — where a plugin (or skill) is enabled: `user` / `project` / `local` / `managed`.

**Namespacing** — plugin components appear as `<plugin>:<component>`, so they never collide.

**Gate** — a small standalone CI check enforcing one well-formed-plugin invariant (`10-validation-and-gates`).

**Shipped vs author-only** — _shipped_: recognized component dirs + manifest, loaded for users.
_Author-only_: `CLAUDE.md`, `.claude/`, `tests/`, `.github/` — copied to the cache, never loaded
(`09-claude-md-and-author-config`).

**Conventional Commits** — the `<type>: <subject>` commit convention (`feat` / `fix` / `docs` / …)
that doubles as the semver signal and changelog source (`13-repository-hygiene`).

**CHANGELOG** — a `CHANGELOG.md` in Keep a Changelog format whose top released version MUST match the
manifest version; gated against drift (`13-repository-hygiene`, `10-validation-and-gates`).

**Badge** — a README status marker (CI, license, `validate --strict`); each MUST reflect a real
signal, not a sticker (`13-repository-hygiene`).

**Changelog fragment** — a one-bullet `changelog/<NN>-<slug>.md` file a PR adds instead of editing
`CHANGELOG.md` directly, so concurrent PRs never collide; aggregated at release time
(`14-supply-chain-and-governance`).

**CODEOWNERS** — `.github/CODEOWNERS`; maps paths to default reviewers so branch-protected PRs require
code-owner review (`14-supply-chain-and-governance`).

**Dependabot** — `.github/dependabot.yml`; opens automated version-bump PRs for watched ecosystems
(GitHub Actions, npm) and refreshes SHA-pinned action versions (`14-supply-chain-and-governance`).

**Pinned action SHA** — a GitHub Action referenced by full commit SHA (`uses: x/y@<sha> # vN`) rather
than a movable tag, so the supply chain is immutable (`14-supply-chain-and-governance`).

**OpenSSF Scorecard** — an automated supply-chain score (branch protection, pinned deps, token
permissions, SAST); published from `scorecard.yml`, needs no registration
(`14-supply-chain-and-governance`).

**OpenSSF Best Practices** — a self-assessment badge against an open criteria checklist; requires
registering the project for a per-repo numeric id (`14-supply-chain-and-governance`).

**CodeQL** — GitHub's SAST engine; for a content-only plugin it analyzes the `actions` language,
inspecting workflow YAML for security issues (`14-supply-chain-and-governance`).

**SLSA provenance** — a signed, verifiable attestation of which workflow built which release artifact,
attached to the GitHub Release (`14-supply-chain-and-governance`).
