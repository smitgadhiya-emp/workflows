# WF-092 — Terraform Drift Court: three-way reconciliation with a destructive-change guard (run pack)

**In Progress** on [`../../../BOARD.md`](../../../BOARD.md) — **hardened build (v2); rerun landed a 4** (Model A),
in the 3-4 band, so **submission-ready**. The first run scored a 6 (too easy), so the seed now carries three extra
judgment traps (a break-glass change that looks unauthorized, a nested SSH backdoor, a live-only resource that
needs `import`); the rerun caught all three but stalled at the start (stopped and asked for the GitHub CLI,
resumed on continue) and over-filed security issues, which lands it at a 4. **Seeded** GitHub build: one repo
(`infra-live`) holding the Terraform code,
the recorded state, a live-cloud snapshot, and the CloudTrail + CHANGES attribution, with the drift cases planted.
The agent does a three-way reconcile (code vs state vs live), attributes each drift, decides codify / ignore /
revert (or import) per resource, edits `main.tf`, opens one reconcile PR with a per-resource decision table, and
opens a security issue per unauthorized change, without applying anything destructive. Full design, decision rules
and grading live in the main file. Source: EXP-94.

## Files here

| File | What it is |
|---|---|
| [`WF-092-terraform-drift-court.md`](WF-092-terraform-drift-court.md) | The canonical build: seed design, the Part B eval prompt, the planted-traps table, the destructive-guard rules, grading, Feather fields |
| [`seed-prompt.md`](seed-prompt.md) | **Reusable seed** — builds the `infra-live` repo with the five fixture files and all the drifts (six v1 + three v2). Run before each run |
| [`cleanup-prompt.md`](cleanup-prompt.md) | **Reusable reset** — deletes the seeded repo (branch + PR + issue with it). Run before each re-seed |
| [`form-1-submission.md`](form-1-submission.md) | **Form 1**, clean and paste-ready (Part C in submission voice); field 1 is the hardened v2 prompt; fields 13-14 await the v2 rerun |

## Run order (repeat this loop for each run / each model)

1. **Connect apps** in Codex: GitHub (on a demo account) + a local code/terminal step (git, `jq`, read/diff the
   `.tf` / `.tfstate` / `.json` files, edit `main.tf`). No Notion or Teams on this build.
2. **Cleanup** — [`cleanup-prompt.md`](cleanup-prompt.md). Then confirm by hand: no `infra-live` repo (or one
   reset to a clean main, no PR/issues, seed files unedited).
3. **Seed** — [`seed-prompt.md`](seed-prompt.md). Rebuilds the repo, the five fixture files, and all the drifts
   (six v1 + the three v2 traps).
4. **Run the eval** — paste **Part B** from the main file into Codex 5.5 Extra High, submit. Capture the
   **session ID + runtime**. Run the same prompt in Claude side by side.
5. **Verify + score** — grade against the **Grading key** in the main file (nine per-resource verdicts + the
   guards, including the v2 signals 7-9). Target outcome **3-4** now that v2 is in; if it is still 5+, harden
   further per the v3 ideas in the main file and rerun from step 2.

## What the grader actually does (short list — full detail in the main file)

1. **Attribution-driven verdicts** — SG 443 tightening codified (not reverted); RDS incident resize codified;
   ASG `desired_capacity` routed to `ignore_changes`; S3 `public-read` reverted as unauthorized + a security
   issue filed. · 2. **The destructive guard** — EBS volume codified up to 500 AND flagged that applying it back
   to 100 would force-replace the volume; zero destructive ops proposed. · 3. **v2 judgment calls** — the
   break-glass db-sg change codified (not reverted); the nested port-22 backdoor on web-sg caught, reverted +
   filed; the live-only SNS topic handled as an `import`, not a bare codify. · 4. **The clean resource** — the
   log group left untouched. · 5. **Structural** — one reconcile PR with a per-resource decision table citing an
   attribution each, a security issue per unauthorized change, nothing applied, nothing merged.

Clean on all of it = too easy -> harden further. We want the outcome **3-4** now that v2 is in.

## Next

**v2 hardened; rerun done, landed a 4.** The rerun (Model A) caught all three v2 traps — codified the break-glass
db-sg change instead of reverting it, split the web SG into keep-443 / revert-the-SSH-rule, and staged the SNS
topic as a `terraform import` — plus the six v1 calls, nothing applied or downsized. It lands at a **4** (not
higher) because it stalled at the start (stopped and asked for the GitHub CLI, resumed on continue) and over-filed
security issues (three, splitting the S3 owner-tag into its own incident). Fields 13-14 filled from that run
(draft PR #6 on `reconcile-drift`, commit `311c8d9`). Next: (1) run Models B/C on fresh names (re-run pack) for
the A/B/C comparison; (2) when the comparison's in, move to `../../3-done/` (update the `Status:` line + the
[`../../../BOARD.md`](../../../BOARD.md) card).
