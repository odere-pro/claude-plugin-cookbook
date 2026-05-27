# OpenSSF Best Practices — self-assessment

Evidence for the [OpenSSF Best Practices](https://www.bestpractices.dev/) badge. Registration yields a
numeric project id; until it exists, the badge in [`README.md`](../README.md) stays commented out. Keep
this table in sync with the criteria so the answers are reviewable rather than asserted. See
[`14-supply-chain-and-governance`](cookbook/14-supply-chain-and-governance.md) for the rationale.

| Criterion             | Status | Evidence                                                            |
| --------------------- | ------ | ------------------------------------------------------------------- |
| Project homepage      | ✅     | `README.md` describes what the project does and how to get it       |
| Stable download       | ✅     | GitHub Releases via `.github/workflows/release.yml` (tag-triggered) |
| OSS license           | ✅     | `LICENSE` (MIT)                                                     |
| Documentation         | ✅     | `docs/cookbook/` — a 15-chapter reference                           |
| Version control       | ✅     | public git; Conventional Commits (`13-repository-hygiene`)          |
| Unique versioning     | ✅     | `.claude-plugin/plugin.json` `version` is the version of record     |
| Release notes         | ✅     | `CHANGELOG.md` (Keep a Changelog) + fragment system (`changelog/`)  |
| Bug-reporting process | ✅     | `.github/ISSUE_TEMPLATE/` + `SUPPORT.md`                            |
| Vulnerability report  | ✅     | `SECURITY.md` — private GitHub Security Advisories                  |
| Working build         | ✅     | content-only plugin; `claude plugin validate --strict` is the build |
| Automated test suite  | ✅     | `tests/gates/` run by `.github/workflows/ci.yml` on every push/PR   |
| Static analysis       | ✅     | CodeQL (`languages: actions`) + the gate suite                      |
| Secured delivery      | ✅     | actions pinned by commit SHA; SLSA build provenance on release      |
| Dependency monitoring | ✅     | `.github/dependabot.yml` (github-actions + npm)                     |
