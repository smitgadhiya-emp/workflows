# WF-152 — Manual Setup (do these yourself, before anything runs)

These are the things Codex can't bootstrap on its own (OAuth logins, GitHub repo permissions, Teams
team/channel creation). Do them first, then run the Codex seed prompt, then run the workflow prompt.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to all three connectors it will use:
- [ ] **GitHub** (with permission to create a repo, tags, branches, and PRs in the target account)
- [ ] **Google Drive / Docs**
- [ ] **Microsoft Teams**
- [ ] (Optional) confirm the **Chrome** session the workflow may reuse is logged in.

## 2. GitHub — make sure the repo can be created
- [ ] Confirm you can create the repo **`smitempiricinfotech-wq/Multi-Audience-Generator`** — OR
      decide to use a different account/repo and tell me so I update the name in the prompt and
      Source file everywhere.
- [ ] Codex creates the actual repo + `main` branch + commits + the merged PRs + `CHANGELOG.md`.
      You don't build those by hand.
- [ ] **You create the tags yourself.** The Codex GitHub connector has **no create-tag / create-
      release / create-ref tool**, so Codex can map the correct commits but cannot create
      `v1.3.0` / `v1.4.0` / `v1.5.0-rc.1`. After the seed, have Codex report the exact commit SHAs
      for each tag, then create them via the GitHub REST API (a PAT with `repo` / Contents:write
      scope). A ready-to-run helper is in [Create-Release-Tags-152.ps1](Create-Release-Tags-152.ps1)
      — paste your token and run it. (`git tag <name> <sha>` + `git push origin <name>` works too if
      you have a local clone; the GitHub *web* release UI does **not**, because it only tags at a
      branch tip, not an arbitrary historical commit.)

## 3. Microsoft Teams — team + channels must exist
Codex can post messages but generally can't create a team or channels.
- [ ] Confirm team **`Workflow test`** exists (reuse from prior WFs).
- [ ] Confirm these channels exist under it (create if missing): **`Dev Releases`**,
      **`Product Updates`**, **`Leadership Updates`**, and the **`Workflow test`** fallback channel.

> These matter because the workflow routes each version to a specific channel and only uses the
> `Workflow test` fallback (loudly, in its summary) if a target channel is missing. If you *want* to
> test the fallback path, deliberately leave one of the three channels out.

## 4. Google Drive — output folder
- [ ] Create the Drive folder **`Engineering / Release Notes`** (empty). The three release Docs are
      outputs — leave it empty.

---

## Run order after setup
1. **Manual setup** (this file) — done.
2. **Seed data:** paste [Codex-DummyData-Prompt-152.md](Codex-DummyData-Prompt-152.md) into Codex.
   It creates the repo (commits, tags, merged PRs, `CHANGELOG.md`) and confirms the Drive folder +
   Teams channels exist.
3. **Verify seed** (quick check before the real run):
   - [ ] Repo `smitempiricinfotech-wq/Multi-Audience-Generator` exists on `main`.
   - [ ] Tags: `v1.4.0` (stable, the boundary), `v1.5.0-rc.1` (pre-release decoy), `v1.3.0` (older).
   - [ ] 14 merged PRs after `v1.4.0` incl. the two breaking (P4 `feat!:`, P5 mislabeled), the revert
         pair (P12 + P13), the non-breaking label/content conflict (P11), and the unclassifiable one
         (P14). The three decoys (open / closed-unmerged / merged-before-tag) are present but excluded.
   - [ ] `CHANGELOG.md` has only `v1.4.0` + `v1.3.0` entries.
   - [ ] Drive folder empty; Teams team + all four channels present.
4. **Run the workflow:** execute [Prompt-152-final.md](Prompt-152-final.md).

## Expected outcome of a correct run (so you can grade it)
- Boundary `v1.4.0`; next version **`v2.0.0`** (major, driven by P4/P5).
- User-visible set: P1, P2, P3, P4, P5, P10, P11. Internal (excluded from user/exec): P6–P9.
- P12+P13 called out as reverted-not-shipped; P14 as unclassified-needs-review.
- Breaking block at the top of the `Dev Releases` and `Product Updates` posts.

## What you do NOT set up (the workflow produces these)
- The three Google Docs in `Engineering / Release Notes`.
- The three Teams posts.
- The `v2.0.0` section of `CHANGELOG.md`, the `release-notes/v2.0.0` branch, and its PR.

---

## Between test runs — reset before re-running the SAME prompt (e.g. comparing models)

> **Easiest path:** run **`Codex-CleanupSeedData-Prompt-152.md`** in Codex before each new model run.
> It deletes the three Drive Docs, the Teams posts (all four channels, fallback included), closes the
> changelog PR without merging and deletes its branch, removes any stray tag/release (e.g. a `v2.0.0`
> tag), verifies the seed (tags / 14 PRs / decoys / CHANGELOG), and reports READY / NOT READY.

Two WF-152-specific things to know:
- [ ] **Never merge the changelog PR** between runs. If a run (or a stray click) merged it, `main` now
      contains the `v2.0.0` changelog **and** an extra merged PR *inside the workflow's PR range* — the
      next run's expected results change. The cleanup prompt can reset `main` to the merge's first
      parent, but GitHub still lists that PR as merged, so a strictly comparable next run needs a
      re-seed. Cheapest insurance: always close (not merge) the PR.
- [ ] A wrong-version run (a model that computed e.g. `v1.5.0` instead of `v2.0.0`) leaves docs,
      posts, branches, and possibly tags under that other version — the cleanup matches by pattern
      (`Release * - …`, `release-notes/*`, any non-seeded tag), so it catches those too.
