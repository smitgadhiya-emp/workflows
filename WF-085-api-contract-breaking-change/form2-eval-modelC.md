# WF-079 — Form 2 (OpenAI Eval Feedback) — Model C responses

**Workflow:** WF-079 API Contract Breaking-Change & Consumer-Impact Review (seeded `orders-platform` repo, **v2 hardened**)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (first Form 2 round; the four-model set A/B/C/D). D to follow on the same seed.
**This file:** Model C only — **gpt-5.5-cyan, Extra High intelligence** (confirmed on the run: "5.5 Cyan Extra High")
**Session ID:** `[paste this run's session ID]` (runtime 10m 23s)
**Run dataset:** the seeded `orders-platform` repo (published `orders-api.yaml` + `VERSIONING.md`, the
`evolve-orders-api` branch with the 8 planted spec edits, 7 consumers + the external `partner-webhook`). Apps:
GitHub (PR review + issues), Notion (`API-CHANGES`), Microsoft Teams (`platform`).
**Status:** Model C done, **strong run — ~11 of 12 signals, the most thorough and the slowest.** Aced all four hard
v2 signals, with **data-warehouse handled most explicitly of any run** (a dedicated owner-confirmation issue #15),
and it **actively corrected the stale record** (the older review had cleared fraud-check + refunded and skipped
data-warehouse). But it is the **slowest run by a wide margin (10m 23s)** with dual environment-navigation, and it
**reopened the 5 old closed coordination issues** rather than opening fresh, more state-churn than A/B. Same single
miss: the **v2 `coupon_code` over-flag**. Honest Form 2: mostly 5s, with **writing + instruction at 6** and
**efficiency down to 4** for the slow, heavy run.

> **Persona (voice).** Platform / backend engineer who reviews every API-contract PR for breaking impact across the
> services that call it. Dry, evidence-first, has been burned by a "small rename" that took down a team nobody
> checked, so the thing he cares about is a correct breaking-vs-safe call AND a real field-level blast-radius trace,
> without crying wolf.

---

## Metadata used (persona + scoring inputs) — same as Form 1

| # | Field | Value |
|---|---|---|
| 1 | Occupation / career | Software Developer |
| 2 | Occupation + workplace (persona voice) | Platform / backend engineer, reviewing API contract changes for breaking impact across the services that call them |
| 3 | Time to complete WITHOUT a model (min) | 90 |
| 4 | Times per month | 12 |
| 5 | Workflow difficulty (1-7) | 7 |
| 6 | Initial Codex test rating (1-7) | 4 (correct core judgment incl. all four hard v2 calls and the most explicit data-warehouse handling, but the same coupon_code over-flag, plus the slowest run and the most GitHub state-churn) |
| 7 | Notes | NO-GO, 6 confirmed-broken issues (checkout-web #2, billing-service #3, analytics-batch #4, ops-dashboard #5, partner-webhook #6, fraud-check #14) + a **dedicated data-warehouse owner-confirmation issue #15**, the corrected API-CHANGES row, the platform digest, nothing merged. Aced the four v2 traps and corrected the stale record (old review had cleared fraud-check + refunded, skipped data-warehouse). Slip: coupon_code counted breaking (safe for v1 callers). Slowest run (10m 23s): local checkout + Chrome directory listing (code index off), and it **reopened + corrected the 5 old closed issues** rather than opening fresh. |

---

## Grading-key check (the twelve scorable signals, from the main file)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | required `currency` = breaking, optional `notes` = safe | ✅ | checkout-web #2 (currency); "7 breaking, 1 safe" (notes the 1 safe) |
| 2 | rename breaking + **partner-webhook** found | ✅ | billing-service #3, partner-webhook #6 |
| 3 | `legacy_status` removal = breaking (analytics) | ✅ | analytics-batch #4 |
| 4 | enum **remove `on_hold`** = breaking for the sender (ops-dashboard) | ✅ | ops-dashboard #5 |
| 5 | v2 `coupon_code` removal safe for the v1 mobile-app | ❌ **FAIL** | counted in "7 breaking contract changes" (over-flag, same as A/B) |
| 6 | mobile-app NOT flagged for the rename | ✅ | "mobile-app is cleared" |
| 7 | `debug` removal breaking-by-rule but zero blast radius | ✅ | in the 7 breaking, no issue opened |
| 8 | overall **no-go**, counts reconcile | ✅ | "NO-GO, 7 breaking, 1 safe"; verified all 7 issue states + final counts; Notion + Teams reconcile |
| 9 | enum **add `refunded`** = breaking for **fraud-check** | ✅ **WIN** | fraud-check #14; and it caught that the old review "treated the new refunded response value as automatically safe" and corrected it |
| 10 | **data-warehouse** rename impact = undeterminable / for owner review | ✅ **most explicit** | a dedicated **owner-confirmation issue #15**: "1 generic consumer (data-warehouse) needs owner confirmation" |
| 11 | verdict cites the **`/v1` freeze**, re-cut as `/v2`/additive | ✅ | "the versioning policy makes this a provider-side no-go as-is... additive compatibility phase or a new version" |
| 12 | **partner-webhook** fix = deprecation window (external) | ✅ | "The external partner must retain the old shape through a deprecation window" |

**~11 of 12** — one firm miss (coupon_code). Like A and B it got **all four hard v2 signals**, and it did signals
9 and 10 **most thoroughly of the three**: it not only caught fraud-check but flagged that the earlier review had
wrongly cleared it, and it gave data-warehouse its own owner-confirmation issue rather than a held line in the
review.

**Behavioral flag (not a grading signal):** C **reopened and corrected the 5 old closed coordination issues**
(#2-6) instead of opening fresh ones like A/B (#8-13). This reconciles to one issue set (avoids duplicates) but
reactivates artifacts a prior pass had closed "not planned" — a defensible reading of "one issue per service", but
more state-change than the brief asked for. Worth confirming that's the desired behaviour.

---

## Run evidence (from the run screenshots)

- **Runtime:** 10m 23s, full access, the slowest of the round by a wide margin. GitHub, Notion and Teams (Codex
  Apps) connectors + a read-only local checkout + Chrome control for a directory listing.
- **Environment-navigation (the heaviest):** "Its connector code index is unavailable, so I'm switching to a
  read-only local checkout for the full caller audit"; and "using the Chrome control workflow only to obtain a
  read-only directory listing... all live writes will still go through the GitHub connector." Both used to avoid
  guessing filenames / missing the generic handlers + the extra integration outside `consumers/`.
- **Closed-PR handling:** "the named PR is now closed and unmerged... the GitHub artifact will be a comment-only
  review if GitHub permits reviews on the closed PR, with no approval or merge action."
- **Record correction (the standout):** "an older review and five now-closed coordination issues from an earlier
  repository state. That review missed the newly present fraud-check and generic data-warehouse consumers and
  treated the new refunded response value as automatically safe. I'm correcting the record... the new review will
  explicitly supersede the old counts." → reopened + corrected the 5 old issues, added fraud-check #14 +
  data-warehouse #15.
- **Verdict:** "NO-GO, 7 breaking contract changes, 1 safe change; 6 callers definitely break, 1 generic consumer
  (data-warehouse) needs owner confirmation, and mobile-app is cleared."
- **Disposition:** re-cut stable v1 additively / new version, deprecation window for the external partner,
  consumer-first deploy.
- **Live-state honesty:** "PR #1 is currently closed and unmerged, with an older stored head. The review
  explicitly documents that it compares the current evolve-orders-api branch against current main."
- **Wrong actions / recovery:** none wasted; every step was purposeful, but the cumulative process (dual
  navigation + issue reconciliation) is heavy.

---

## Form answers

### Overall task success — 5
It did the full review and went furthest on cleaning up the record, same right calls. NO-GO, six issues for the six services that actually break, and a separate owner-confirmation issue for data-warehouse rather than folding it in or clearing it, which is the cleanest handling of that one I have seen. It got all four of the hard calls: fraud-check on the added refunded (and it specifically caught that the old review had waved that through as safe), data-warehouse held for its owner because the warehouse schema is not in the repo, the v1 freeze re-cut, and the partner deprecation window. The one slip is the same coupon_code over-flag, called breaking when nothing is on v2. It also reopened and corrected the five old coordination issues rather than opening fresh ones, which reconciles the record but does touch artifacts a prior pass had closed, worth a look. Delivered, correct where it counts. A 5.

### Task accuracy, ignoring speed — 5
Eleven of twelve, and the ambiguous cases are handled the most explicitly of the runs. fraud-check breaks on the widened enum, and it flagged that the earlier review had cleared it wrongly; data-warehouse gets its own owner-confirmation issue because the impact cannot be read from the code; mobile-app is cleared for reading only unchanged fields. Checkout on the required currency, ops on the dropped on_hold, billing and the external partner on the rename, analytics on the deprecated legacy_status, all right. The miss is coupon_code, counted as a breaking change when for v1 callers it is safe. A strong read with the one over-flag. A 5.

### Efficiency — 4
- End-to-end time (minutes): 10 (10m 23s)
- Wrong actions / recovery: No thrashing, but a heavy run. The code index was off, so it took a read-only local checkout AND drove Chrome for a directory listing to complete the caller audit, then it reopened and corrected five old issues, added two, and verified all seven states.
- Commentary: This is the slowest run by a wide margin, more than double the quickest, and a chunk of it is the dual checkout-plus-browser navigation and the issue-by-issue reconciliation of the old set. It is all purposeful, none of it wasted, but it is a lot of process for a review the same window has done in four minutes. A 4.

### Writing quality — 6
Clear and well-sorted. It splits the outcome cleanly, six callers definitely break, one generic consumer needs owner confirmation, mobile-app cleared, so nobody misreads the data-warehouse case as either a break or a clear. The versioning no-go and the re-cut recommendation are stated plainly, and it documents that it compared the current branch against current main since the PR is closed. A 6.

### Instruction following — 6
Hit the required outputs: a per-change review on the PR (comment-only on the closed PR, no approval or merge), an issue for each service that actually breaks plus the owner-confirmation issue for data-warehouse, the API-CHANGES row, the platform digest, no consumer code touched. It reused and corrected the existing issues rather than duplicating them, which is a defensible reading of one-issue-per-service, though it does mean reopening a set a prior pass had closed. The coupon_code call is a judgment slip, not a missed instruction. A 6.

### Collaboration, autonomy, and verification — 5
- Steering needed: None, it ran the whole review on its own.
- Additional editing before I would use it: Moderate. I would move coupon_code off the breaking list, and I would decide whether I wanted the old issues reopened or left closed, but the routing is correct.
- Commentary: The most thorough verification of the runs. It completed the caller audit with a local checkout and a directory listing rather than guessing filenames, it caught and corrected the earlier review's real misses (it had cleared fraud-check and refunded and skipped data-warehouse), and it verified every issue state and the final counts. The one thing it did not catch is its own coupon_code over-flag, and the record-correction went as far as reopening closed issues, which is diligent but more state change than the brief asked for. A 5.

### Citation quality — 6
Evidence-backed and reconciled. The caller audit came off an actual checkout verified against main, the verdict cites the versioning policy for the freeze, and it was explicit that the data-warehouse impact cannot be classified from the repo. It also corrected the stale Notion and issue record against the current evidence rather than leaving it wrong. A 6.

### GUI action correctness — N/A
The browser was used read-only, to pull a directory listing when the code index was off; every write went through the GitHub, Notion and Teams connectors. No clicks or dialogs driven. Nothing GUI to score.

---

## Rating summary

| Dimension | Score |
|---|---|
| Overall task success | 5 |
| Task accuracy, ignoring speed | 5 |
| Efficiency | 4 |
| Writing quality | 6 |
| Instruction following | 6 |
| Collaboration, autonomy, verification | 5 |
| Citation quality | 6 |
| GUI action correctness | N/A |

**End-to-end time:** 10 min (10m 23s) · **Steering:** none · **Additional editing:** moderate (move coupon_code
off the breaking list; decide whether the old issues should have been reopened)

---

## Program note

Model C is the most thorough of the three and the slowest: same ~11/12, all four hard v2 signals landed, and it
handled data-warehouse most explicitly (a dedicated owner-confirmation issue) and actively corrected the stale
review record. The costs are its pace (10m 23s, dual environment-navigation) and its reopening of the old closed
issues (more state-change than the brief asked for). Same single miss (coupon_code). So three models now over-perform
the v2 trap design (all three missed zero of the hard four, where the build file expected 2-3 misses), which
hardens the flag from A and B: **the v2 hardening is not pulling the outcome down for these models**, and the only
recurring rough edge is the coupon_code over-flag, which is cry-wolf, not a missed breaker. If D also aces the v2
four, the **v3 ideas from Part B** are the lever. **Workspace note:** the dirty state (closed PR, closed issues, a
non-row Notion page) drove C's heavy reconciliation and the reopening; clear the repo/PR + `API-CHANGES` + the
issues before Model D so it starts clean and doesn't reopen a stale set.

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] Decide the issue-reopening policy: is reopening + correcting the old closed issues (C's approach) preferred, or
  opening fresh (A/B's approach)? Pin one for the comparison.
- [ ] **Clear the workspace before Model D:** reset the repo/PR to open, empty `API-CHANGES`, close/settle the
  leftover issues, so D isn't reconciling this run's + A's + B's + Form-1's leftovers.
- [ ] Run Model D (purple/High) on the same seed, fill `form2-eval-modelD.md`.
- [ ] Fill `form2-final-comparison.md` once Model D is in (A, B, C are ready).
