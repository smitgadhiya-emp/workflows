# Codex Prompt — WF-152 Seed FIX: create the missing release tags

The WF-152 repo was seeded with commits and merged PRs, but **no tags or releases were created**, so
the release-notes workflow can't resolve a "last release" boundary and stops. Your job is to add the
missing tags/releases at the correct commits so the workflow has a stable `v1.4.0` boundary with the
in-range PRs after it. Do this **in the actual GitHub repo** via the connector — no local files. Do
NOT run the release-notes workflow, do NOT create a `v2.0.0` tag, and do NOT touch `CHANGELOG.md`
beyond confirming its baseline.

Repo: **`smitempiricinfotech-wq/Multi-Audience-Generator`**, branch **main**.

## Step 1 — Map the history
List every PR merged into `main`, oldest → newest, with its merge-commit SHA, title, and labels.
Match them against the WF-152 ground-truth set (the 14 in-range PRs P1–P14: the plain feature/fix/
perf ones, the two breaking ones `feat!: new auth token response…` and `feat: bulk export endpoint`,
the internal ones, the referral-rewards label/content conflict, the **revert pair** `feat: add live
chat widget` + its `Revert …`, and the unclassifiable `misc updates`). Also identify any
"merged before release" decoy PR (e.g. `fix: patch before release`), if one exists.

## Step 2 — Place the tags (this is the whole point)
The boundary rule: **`v1.4.0` must be an ancestor of `main`'s head, positioned so that all 14 in-range
PRs (P1–P14) are merged AFTER it, and the "before release" decoy (if any) is BEFORE it.**

- **`v1.4.0`** (the stable boundary): tag the first-parent **parent commit of the earliest in-range
  PR merge** (the commit immediately before `feat: add saved carts…` landed). Publish it as a
  **stable GitHub Release** — **not a draft, not a pre-release**.
- **`v1.3.0`** (older, already-contained): tag an earlier commit (the "before release" decoy's commit,
  or the initial scaffold commit if there's no decoy). Publish as a **stable** Release too.
- **`v1.5.0-rc.1`** (pre-release decoy): tag a commit **in the middle of the in-range PRs** (e.g. just
  after the internal PRs). Mark it **pre-release**. It must exist but must never become the boundary.

If you genuinely cannot map PRs to commits confidently, use this safe fallback: tag the repo's
**initial scaffold commit** (before any feature PR) as `v1.4.0`, so all merged feature PRs fall in
range. Say clearly that you used the fallback and that the "before-release" exclusion decoy is
therefore not exercised.

If the connector cannot publish GitHub **Releases**, create the tags directly as git refs
(`refs/tags/v1.4.0`, etc.) pointing at the chosen SHAs — the workflow looks for the highest `vX.Y.Z`
**tag**, so tags alone are sufficient; publish Releases as well only if the connector supports it.

## Step 3 — Verify before you finish
Compute what the workflow will see and confirm it's correct:
- The highest stable `vX.Y.Z` tag on `main` resolves to **`v1.4.0`** (with `v1.5.0-rc.1` skipped as a
  pre-release).
- The set of PRs merged after `v1.4.0` is exactly the **14 in-range PRs** (P1–P14), including the
  revert pair and the unclassifiable one, and excludes the before-release decoy and any open/closed-
  unmerged decoys.
- That range contains the two breaking changes → the next version would compute to **`v2.0.0`**.
- `CHANGELOG.md` still contains only the `v1.4.0` and `v1.3.0` entries (no `v2.0.0`).

## Report back
The three tags with their commit SHAs and kind (stable / pre-release), the exact list of PRs that now
fall after `v1.4.0`, confirmation the boundary resolves to `v1.4.0` and the computed next version is
`v2.0.0`, and whether you used the safe fallback for `v1.4.0`'s placement.
