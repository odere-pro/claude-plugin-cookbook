# 14 · Supply-chain and governance

> **Intent:** Make the repository _trustworthy to depend on_ — provenance for what it ships, a stated
> security and contribution posture, and automation that keeps the supply chain honest — building on
> the hygiene of `13-repository-hygiene`.
> **Reads-with:** `10-validation-and-gates`, `11-distribution-and-versioning`, `13-repository-hygiene`.

`13-repository-hygiene` makes a repo well-formed: clean history, configuration, presentation. This
chapter makes it **trustworthy**: a third party can see how it is secured, who answers for it, and that
its dependencies and releases are watched. None of it ships to end users (`09-claude-md-and-author-config`),
and all of it is pre-wired in `skeleton/` so a new plugin inherits the posture by copying.

A note on proportion: a young, single-author plugin does **not** need all of this on day one. Treat the
sections below as a menu ordered roughly by cost. The governance docs and Dependabot are cheap and
always worth it; OpenSSF Best Practices registration and the fragment changelog earn their keep once a
plugin has real users or contributor traffic.

## Governance documents

Four small Markdown files state the social contract. GitHub surfaces each one in its UI (the security
tab, the "report a vulnerability" button, the new-issue chooser), so they are read far more than their
size suggests.

- **`SECURITY.md`** — the trust model and how to report a vulnerability **privately** (GitHub Security
  Advisories, not a public issue). Describe the actual attack surface, not a template's: for a plugin,
  that is which component can write or execute, and the guarantee that nothing ships a network call.
- **`CODE_OF_CONDUCT.md`** — the [Contributor Covenant](https://www.contributor-covenant.org/) is the
  de-facto standard; ship it verbatim with a real enforcement contact.
- **`SUPPORT.md`** — where questions go (docs first, then issues), so they don't arrive as security
  reports or stale bugs.
- **`.github/CODEOWNERS`** — a default reviewer (`* @owner`). With branch protection it requires
  code-owner review on every PR, which is also an OpenSSF Scorecard signal.

## Dependabot

A pure-Markdown plugin still has dependencies: the **GitHub Actions** its workflows call, and (if it
lints docs) its **npm/Bun dev tools**. `.github/dependabot.yml` watches both ecosystems and opens
version-bump PRs. This matters because actions SHOULD be pinned by commit SHA (next section) — a pin
is frozen until something bumps it, and Dependabot is that something. It updates the SHA and the
trailing `# vX.Y.Z` comment together.

## Pin actions by commit SHA

A workflow that calls `actions/checkout@v4` re-resolves that tag on every run — if the tag is moved to
a malicious commit, you run it. Pinning to a full commit SHA (`actions/checkout@<sha> # v6.0.2`) makes
the supply chain immutable; the trailing comment keeps it readable. This is a top OpenSSF Scorecard
"Pinned-Dependencies" signal, and Dependabot keeps the pins fresh. The one deliberate exception is a
reusable workflow that self-verifies and refuses SHA refs (the SLSA generator below) — pin it to a
semver tag.

## OpenSSF Scorecard

[OpenSSF Scorecard](https://securityscorecards.dev/) scores a repo against a battery of supply-chain
checks (branch protection, pinned dependencies, token permissions, SAST, dangerous workflow patterns).
`.github/workflows/scorecard.yml` runs it weekly and on pushes to `main`, with `publish_results: true`
so the score is uploaded to the public Scorecard API and the README badge renders. It needs **no
registration** — but the badge only populates after the first run on the default branch, and the repo
**MUST be public**. Read the score as a to-do list, not a grade: each failing check links to a fix.

## CodeQL

CodeQL is GitHub's SAST engine, and `.github/workflows/codeql.yml` runs it. A plugin has no compiled
language, so the useful target is **`languages: actions`** — CodeQL then inspects the GitHub Actions
workflows themselves for injection and over-broad-permission issues. (It does not analyze Bash, and
analyzing the repo's JSON/Markdown would find nothing.) Its results upload to code-scanning and feed
the Scorecard SAST check, so the two reinforce each other.

## Release workflow and provenance

`11-distribution-and-versioning` covers _how_ a marketplace release works (a git tag + a GitHub
Release; the version of record is `plugin.json`). `.github/workflows/release.yml` automates and guards
it on every `v*` tag:

1. **Verify the tag matches `plugin.json`** — `vX.Y.Z` MUST equal `.claude-plugin/plugin.json`'s
   `version`, or the release fails. One source of truth, enforced.
2. **Re-run the gate suite** (`tests/gates/run-all.sh`) so a release can never ship a red build.
3. **Extract the matching `CHANGELOG.md` section** into the GitHub Release notes.
4. **Package a tarball and attach [SLSA](https://slsa.dev/) build provenance** — a signed, verifiable
   attestation of _which workflow built which artifact_, so a consumer can prove the tarball came from
   your CI and was not tampered with. The provenance job is a reusable workflow pinned to a semver tag
   by design (see the pinning exception above).

The human side of the procedure lives in [`docs/RELEASING.md`](../RELEASING.md).

## Fragment-based changelog

`13-repository-hygiene` requires a `CHANGELOG.md`; this is an _optional upgrade_ to how it is
maintained. When several PRs are in flight, they all want to edit the same `[Unreleased]` block and
collide on every rebase. The fix: each PR drops a one-bullet fragment under `changelog/<NN>-<slug>.md`,
and `scripts/changelog-aggregate.sh` promotes the fragments into `[Unreleased]` at release time
(prepending each with the short SHA of the commit that introduced it), then deletes them. No two PRs
ever touch the same file.

Two gates back it: [`tests/gates/10-changelog-fragment-present.sh`](../../tests/gates/10-changelog-fragment-present.sh)
requires a fragment for any non-doc change (and **skips** safely when there is no merge base to diff
against — local checkouts, pushes to `main`), and
[`tests/gates/11-changelog-fragment-unique.sh`](../../tests/gates/11-changelog-fragment-unique.sh)
rejects a duplicate `<NN>`. Adopt this once concurrent PRs start fighting over `CHANGELOG.md`; below
that threshold, editing the file by hand is simpler. See [`changelog/README.md`](../../changelog/README.md).

## OpenSSF Best Practices

The [OpenSSF Best Practices badge](https://www.bestpractices.dev/) is a **self-assessment** against an
open checklist (reporting process, tests, static analysis, release notes). Unlike Scorecard it requires
**registering the project** to get a numeric id, which is baked into the badge URL — so the id is
per-repository and cannot be inherited. The honest sequence:

1. Register the repo at <https://www.bestpractices.dev> and answer the criteria. Keep the evidence in a
   `docs/openssf-badge.md` self-assessment so the answers are reviewable and don't drift.
2. Add the badge to `README.md` with the real id. **Never ship a placeholder or borrowed id** — a wrong
   id renders a broken or foreign badge, which is worse than no badge. Until the id exists, leave the
   badge line commented out (as `skeleton/` and this repo's `README.md` do).

## Reuse this for a new plugin

`skeleton/` ships the cheap, always-applicable layer pre-wired: `SECURITY.md`, `CODE_OF_CONDUCT.md`,
`SUPPORT.md`, `.github/CODEOWNERS`, `.github/dependabot.yml`, and the four workflows (`ci`, `scorecard`,
`codeql`, `release`) with SHA-pinned actions — plus a `docs/RELEASING.md` and a commented Best-Practices
badge. The work after copying is filling the `REPLACE-ME` placeholders (the owner in `CODEOWNERS` and
the Scorecard badge, the advisory URL in `SECURITY.md`, the Best-Practices id once registered) and
deciding whether to opt into the fragment changelog. The skeleton deliberately keeps a simple
hand-edited `CHANGELOG.md` so a day-one plugin carries no fragment overhead.
