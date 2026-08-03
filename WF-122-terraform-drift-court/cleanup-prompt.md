# WF-092 — Cleanup / reset prompt (run FIRST, before each re-seed)

Run this once before you re-seed, and again before each model when you compare A/B/C, so every run starts on a
clean, identical workspace. It clears the seeded repo (the `infra-live` repo, and everything a run adds to it: the
`reconcile-drift` branch, the reconcile PR, the security issue). Paste it into Codex with the **GitHub** connector
connected (or browser control on a demo account). It only clears, it never creates anything. No Notion or Teams on
this build.

> **Why this is strict.** A run opens a PR (with `main.tf` edits) and a security issue that a later model would
> otherwise "verify" and build on instead of redoing from scratch. Deleting the whole repo is the cleanest reset
> for a code test-bed, and it takes the branch, the PR and the issue with it.

```
I need you to fully reset a test workspace before I re-seed it. Everything here is invented test data for a
Terraform drift-reconciliation task, nothing real, so you can delete freely. Do all of the below and then give
me a short status line at the end. Do not seed or create any new test data in this step, this is cleanup only.

1) GitHub - the test repo. Find the repository called "infra-live" on my account. Delete the whole repo, that
is the cleanest reset and it takes the seeded main.tf, the tfstate, the snapshot and attribution files, the
reconcile-drift branch, the reconcile PR and any security issue a run opened with it. If you cannot delete the
repo, then instead: close the reconcile PR without merging, delete the reconcile-drift branch, close every
open issue a run filed, revert main.tf and any other file on main back to the seeded state, and tell me the
repo link and what is left. End state I want: either no "infra-live" repo exists, or one with just a clean
main branch, no open PR, no open issues, and the five seed files unedited. Tell me which it is.

When you are done, report exactly: the final state of the "infra-live" repo (deleted, or reset to a clean main
with no PR/issues and the seed files unedited). If GitHub is not connected or you cannot reach it, say so and
stop, do not guess or invent anything.
```

## After running this
- Confirm in the reply: **no** `infra-live` repo (or one reset to a clean main, no open PR, no open issues, seed
  files unedited).
- If it reports anything it could not delete, **remove it by hand now** before you seed, especially any lingering
  open PR/branch/issue on the repo.
- Then run [`seed-prompt.md`](seed-prompt.md) to rebuild the fixed scenario.
