# Codex Prompt — WF-152 Cleanup (reset outputs before a new model run)

Run this **before** each WF-152 execution when testing the same prompt on a new model. It deletes only
the **outputs** of a previous run (Drive docs, Teams posts, the changelog branch/PR, any stray
tag/release) and leaves the seeded repo history untouched, so every model starts from the same state.

Paste everything below the line into Codex (GitHub + Google Drive/Docs + Microsoft Teams needed).

---

You are **resetting the outputs** of a previously-run release-notes workflow so the same prompt can be
re-run cleanly on a different model. Your job is **ONLY to delete that run's outputs and verify the
seeded input state is intact**. Do NOT run the release-notes workflow, do NOT re-seed the repo, do NOT
create tags or PRs, and do NOT post to Teams.

Context you need: the seeded repo is **`smitempiricinfotech-wq/Multi-Audience-Generator`** (branch
`main`). The seed's ground truth is: tags **`v1.3.0`**, **`v1.4.0`** (the stable boundary), and
**`v1.5.0-rc.1`** (pre-release decoy); **14 merged PRs after `v1.4.0`** plus 3 decoys (one open, one
closed-unmerged, one merged before the tag); and a root **`CHANGELOG.md` containing only `v1.4.0` and
`v1.3.0` entries**. The expected run computes version `v2.0.0` — but a buggy model may have used a
**different** version (e.g. `v1.5.0`), so match outputs by **pattern**, not just by `v2.0.0`.

## Scope — the only things you may delete

### 1. Google Drive — the three release Docs
- In the folder **`Engineering / Release Notes`**, delete every Doc matching
  **`Release <anything> - Technical Changelog`**, **`Release <anything> - User Update`**,
  **`Release <anything> - Executive Summary`** — whatever version string a run used.
- The folder must end up **empty** (it is seeded empty; the three Docs are the only expected content).
  If it contains anything that is plainly NOT a release doc from this workflow, leave it and report it.

### 2. Microsoft Teams — the release posts
- Team **`Workflow test`**. Check **four** channels: **`Dev Releases`**, **`Product Updates`**,
  **`Leadership Updates`**, and the fallback channel **`Workflow test`** (a run that couldn't find a
  target channel posts there instead).
- Delete every release-notes post (version header + Drive-doc link + lead-in, possibly a
  "Breaking Changes, Action Required" block), including duplicates, attachments, and thread replies.
- **Read each message before deleting.** Delete only posts that are plainly this workflow's release
  notes. Anything else — a human's message, another workflow's post — leave it and report it.

### 3. GitHub — the changelog branch, PR, and any stray tag/release
Work through these in order:

1. **The changelog PR.** Find PRs (open or closed) from any branch matching **`release-notes/*`**
   against `main`.
   - If **open** → **close it without merging**, then delete its `release-notes/*` branch.
   - If **closed unmerged** → just delete the branch if it still exists.
   - If **MERGED** → see the ⚠ MERGED-PR CASE below. Handle it before anything else.
2. **Stray tags / releases.** The repo must have **exactly three** tags: `v1.3.0`, `v1.4.0`,
   `v1.5.0-rc.1`. Delete any other tag or GitHub Release a run created (e.g. a `v2.0.0` tag — the
   workflow computes that version but must never tag it). **Never touch the three seeded tags.**
3. **Stray branches.** Delete any leftover `release-notes/*` branches. Never delete `main` or any
   seeded branch.
4. **Direct pushes to `main`.** The workflow is forbidden from pushing to `main` directly, but check
   anyway: the latest commits on `main` must all be the seeded ones (the newest commits should be the
   seeded PR merges). If there are commits on `main` that are not part of the seed and not explained
   by the merged-PR case below, **report them — do not try to fix history on your own initiative**.

### ⚠ THE MERGED-PR CASE (if a run merged its changelog PR into `main`)
This is the one output that contaminates the input: the merge added the new `CHANGELOG.md` section to
`main` **and** added a merged PR inside the workflow's PR range, which changes what the next run sees.

- Restore `main` by **resetting it to the merge commit's first parent** (the pre-merge tip of `main`):
  update the `main` ref to that SHA (force). Then verify `CHANGELOG.md` on `main` contains **only**
  the `v1.4.0` and `v1.3.0` entries and the 14 seeded merged PRs + 3 tags are intact.
- If `main` is protected or you lack permission to move the ref, **stop and report NOT READY** with
  the merge-commit SHA and its first-parent SHA so a human can do it.
- **Flag this loudly either way**: even after the reset, GitHub's API still lists that PR as *merged*,
  so a model that builds the PR range from "merged PRs" (rather than commits reachable from `main`)
  may still pick it up as a 15th PR. Say plainly that the only 100% clean recovery from a merged
  changelog PR is a full re-seed of the repo.

## Hard guardrails — never touch these

- ❌ Never delete or archive the **repo**, the **`main`** branch, the seeded **commits**, the seeded
  **14 merged PRs**, or the **3 decoy PRs** (the open one stays open, the closed-unmerged one stays
  closed). The revert pair (P12/P13), the mislabeled P5, and the vague P14 are **deliberate seed
  data** — do not "tidy" their labels, titles, or bodies.
- ❌ Never delete or move the tags **`v1.3.0`**, **`v1.4.0`**, **`v1.5.0-rc.1`** — `v1.5.0-rc.1` is a
  deliberate pre-release decoy; leaving it is the point.
- ❌ Never edit `CHANGELOG.md` by hand-committing to `main` — that adds a commit inside the PR range
  and pollutes the next run. The only sanctioned repair is the ref reset described above.
- ❌ Never delete the Drive folder `Engineering / Release Notes`, the Teams team, or any channel —
  only the release posts and release Docs inside them.
- ❌ Never delete unrelated messages, files, branches, or other people's work.

## Then verify the seeded input is still pristine

Read (do not modify) and confirm:

- [ ] Tags are exactly `v1.3.0` (stable), `v1.4.0` (stable), `v1.5.0-rc.1` (pre-release) — no others.
- [ ] **14 PRs merged into `main` after `v1.4.0`'s commit**, including: P4 (`feat!:` breaking),
      P5 (mislabeled breaking — label `feature`, body removes `GET /v1/export`), P11 (label/content
      conflict), P12 + P13 (the revert pair), P14 (`misc updates`, unclassifiable).
- [ ] The 3 decoys exist and are still excluded by state: one **open** PR, one **closed-unmerged** PR,
      one PR **merged before `v1.4.0`**.
- [ ] `CHANGELOG.md` at the repo root contains **only** the `v1.4.0` and `v1.3.0` sections — no
      `v2.0.0` (or other) section on `main`.
- [ ] No `release-notes/*` branch exists; no open or newly-merged changelog PR remains.
- [ ] Drive folder `Engineering / Release Notes` is **empty**.
- [ ] All four Teams channels exist (`Dev Releases`, `Product Updates`, `Leadership Updates`,
      `Workflow test`) and hold no release post.

If any check fails, **say so explicitly and stop** — the seed was mutated and must be repaired or
re-created from `Codex-DummyData-Prompt-152.md` before the next run.

## Report back

State plainly:
1. Drive: which Docs you deleted (0 = "folder was already empty").
2. Teams: how many posts deleted per channel, and whether any went to the fallback channel (that means
   the previous run couldn't find a target channel — worth knowing).
3. GitHub: the PR(s) you closed and branch(es) you deleted; any stray tags/releases removed; whether
   the **merged-PR case** occurred and exactly what you did about it (with SHAs).
4. Whether **every** input verification check passed — if not, exactly which and what you saw.
5. A one-line verdict: **READY for the next model run**, or **NOT READY** with the reason. If the
   merged-PR case occurred, READY only with the explicit caveat about the residual "merged PR ghost"
   in the GitHub API (recommend re-seed if the next run must be strictly comparable).

Do not create any local files.
