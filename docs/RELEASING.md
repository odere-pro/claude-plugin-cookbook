# Releasing `plugin-cookbook`

This is a Claude Code **plugin**, distributed through a marketplace — not npm. A "release" is a git tag
plus a GitHub Release; marketplace consumers update by re-pulling the tagged commit. The version of
record is `.claude-plugin/plugin.json` → `version` (the marketplace entry deliberately omits `version`
so there is one source of truth).

## Before you tag

1. **Bump the version** in `.claude-plugin/plugin.json`. Use [SemVer](https://semver.org):
   - patch — doc fixes, lint-script tweaks, no behaviour change;
   - minor — a new chapter, skill, or skeleton capability, backward-compatible;
   - major — a breaking change to the skeleton contract or the `new-plugin` interface.
2. **Aggregate the changelog fragments**, then cut the version section:

   ```bash
   bash scripts/changelog-aggregate.sh           # dry-run: preview the fragment bullets
   bash scripts/changelog-aggregate.sh --apply    # inline them under [Unreleased] ### Added, remove fragments
   ```

   Then move the now-complete `[Unreleased]` items into a new `## [X.Y.Z] - YYYY-MM-DD` section.
   (Per-PR fragments live under `changelog/`; see [`../changelog/README.md`](../changelog/README.md).) A
   release commit that bumps `.claude-plugin/plugin.json` **and** edits `CHANGELOG.md` is exempt from
   the fragment gate (`tests/gates/10-changelog-fragment-present.sh`) — it consumes fragments rather
   than adding one.

3. **Reconcile any count text** in `README.md` and the cookbook index if you added or removed a
   chapter, skill, or gate.
4. **Run the gates locally:**

   ```bash
   bun install && bun run lint:md && bun run format:check
   bash tests/gates/run-all.sh
   ```

5. **Smoke-test the plugin** against itself:

   ```bash
   claude --plugin-dir .
   # then, in the session:
   /plugin-cookbook:new-plugin demo a plugin with one skill
   ```

## Tag and publish

```bash
git commit -am "chore(release): vX.Y.Z"
git tag vX.Y.Z          # MUST equal plugin.json version (the release workflow asserts this)
git push origin HEAD --tags
```

Pushing the `vX.Y.Z` tag triggers [`.github/workflows/release.yml`](../.github/workflows/release.yml),
which verifies the tag matches `plugin.json`, re-runs the gates, extracts the matching `CHANGELOG.md`
section, packages a tarball, creates the GitHub Release, and attaches SLSA build provenance. There is
no registry publish step.

## After release

Marketplace users pick up the new version with:

```text
/plugin update plugin-cookbook@plugin-cookbook
```
