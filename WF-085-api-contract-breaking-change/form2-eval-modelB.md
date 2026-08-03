# WF-079 — Form 2 (OpenAI Eval Feedback) — Model B responses

**Workflow:** WF-079 API Contract Breaking-Change & Consumer-Impact Review (seeded `orders-platform` repo, **v2 hardened**)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (first Form 2 round; the four-model set A/B/C/D). C/D to follow on the same seed.
**This file:** Model B only — **gpt-5.5-purple, Extra High intelligence** (confirmed on the run: "5.5 Purple Extra High")
**Session ID:** `[paste this run's session ID]` (runtime 4m 14s)
**Run dataset:** the seeded `orders-platform` repo (published `orders-api.yaml` + `VERSIONING.md`, the
`evolve-orders-api` branch with the 8 planted spec edits, 7 consumers + the external `partner-webhook`). Apps:
GitHub (PR review + issues), Notion (`API-CHANGES`), Microsoft Teams (`platform`).
**Status:** Model B done, **strong run — ~11 of 12 signals, the cleaner and faster of A/B so far.** Aced all four
hard v2 signals, with **data-warehouse explicitly held** ("its warehouse schema is absent, so the impact genuinely
cannot be classified from this repo"), a detailed per-change table, an extra nuance (checkout also forwards the
response generically), and revision-anchored evidence, in 4m 14s. Same single miss as A: **over-flagged the v2
`coupon_code` removal as a "breaking contract change"** (safe for v1 callers), though it marked it no-caller-found.
Handled a messy leftover workspace (both PRs #1/#7 closed, the Notion page not a real DB row) cleanly. Honest Form
2: "correct core, noisy edge", mostly 5s with **6s on efficiency + writing**. (Form 1's outcome stays a 4; Form 2
scored honestly.)

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
| 6 | Initial Codex test rating (1-7) | 4 (correct core judgment incl. all four hard v2 calls, cleaner and faster than the last run, but the same coupon_code over-flag on the safe side plus the off-by-one breaking count) |
| 7 | Notes | NO-GO, per-change table, 6 coordination issues for exactly the 6 real breakers (Checkout #8, Operations #9, Billing #10, Risk #11, Analytics #12, Partner #13), the corrected API-CHANGES row, the platform digest, nothing merged. Aced the four v2 traps: fraud-check on refunded, **data-warehouse explicitly held** (schema absent → can't classify), the `/v1` freeze re-cut, the partner deprecation window; also noticed checkout forwards the response generically. Slip: called the v2 coupon_code removal a breaking contract change (safe for v1 callers), marked no-caller-found. Anchored the review to exact base/head revisions; flagged both PRs (#1/#7) closed and the Notion page not a real row, corrected it. |

---

## Grading-key check (the twelve scorable signals, from the main file)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | required `currency` = breaking, optional `notes` = safe | ✅ | table: "Require request currency, Breaking, checkout-web omits it"; "Add optional request notes, Safe, existing requests remain valid" |
| 2 | rename breaking + **partner-webhook** found | ✅ | "Rename response customer_id → customerId, Breaking, billing-service, external partner-webhook" (Partner #13) |
| 3 | `legacy_status` removal = breaking (analytics) | ✅ | "Remove deprecated legacy_status, Breaking, analytics-batch reads it" (Analytics #12) |
| 4 | enum **remove `on_hold`** = breaking for the sender (ops-dashboard) | ✅ | "Remove request value on_hold, Breaking, ops-dashboard sends it" (Operations #9) |
| 5 | v2 `coupon_code` removal safe for the v1 mobile-app | ❌ **FAIL** | "Remove v2 response coupon_code, **Breaking contract change**, No scoped v2 caller found" (marked no-caller, but classified breaking not safe) |
| 6 | mobile-app NOT flagged for the rename | ✅ | "mobile-app only reads unchanged id, status, and total" → not among the 6 issues |
| 7 | `debug` removal breaking-by-rule but zero blast radius | ✅ | "Remove GET /v1/orders/debug, Breaking, No scoped caller found" (no issue) |
| 8 | overall **no-go**, counts reconcile | ✅ | "NO-GO... 8 semantic changes: 7 breaking and 1 safe, with 6 confirmed affected callers"; Teams digest + API-CHANGES row reconcile |
| 9 | enum **add `refunded`** = breaking for **fraud-check** | ✅ **WIN** | "Add returned status refunded, Breaking for strict readers, fraud-check rejects unknown statuses" (Risk #11) |
| 10 | **data-warehouse** rename impact = undeterminable / for owner review | ✅ **explicit** | "data-warehouse generically persists every response key. Its warehouse schema is absent, so the rename/removal impact genuinely cannot be classified from this repo" (held, not cleared, not asserted) |
| 11 | verdict cites the **`/v1` freeze**, re-cut as `/v2`/additive | ✅ | "re-cut stable v1 additively or use a new version: retain/deprecate old operations and fields, continue accepting on_hold, keep currency optional/defaulted during migration" |
| 12 | **partner-webhook** fix = deprecation window (external) | ✅ | "The external partner needs customer_id retained for a published deprecation window" |

**~11 of 12** — the one firm miss is signal 5 (coupon_code). Like A, it got **all four hard v2 signals (9-12)**,
and it did signal 10 (data-warehouse) **most explicitly of the two**, stating outright the impact can't be
classified from the repo. Extra credit: it flagged that checkout-web *also* forwards the response generically, a
nuance beyond the answer key.

**The shared rough edge:** the change-level count is off by one, coupon_code counted as "breaking" makes it 7
breaking where the correct split is 6 breaking + 2 safe. B mitigates it by pairing "7 breaking" with "6 confirmed
affected callers" and marking the two zero-impact removals no-caller-found, so the reader can see which changes hit
nobody, but the coupon_code classification is still on the wrong side of the safe/breaking line.

---

## Run evidence (from the run screenshots)

- **Runtime:** 4m 14s, full access. GitHub, Notion and Teams (Codex Apps) connectors. No browser driving.
- **Revision-anchoring:** "anchoring the review to its exact base/head revisions so the audit can't drift if the
  branch moves while I'm inspecting it."
- **Messy workspace, handled cleanly:** "the two PRs ever opened from it (#1 and #7) are both closed and unmerged;
  there is no open PR in the connector's results... I won't fabricate an 'open PR' target." It treated the earlier
  closed review "only as leads for file paths and independently read the current code and versioning policy."
- **Notion cleanup:** "the prior Orders review page contains the right 8-change/6-service audit, but it was created
  as a standalone page, not as a row in API-CHANGES... moving that existing page into API-CHANGES and setting its
  classification fields instead of creating a duplicate."
- **Verdict + table:** "NO-GO... 8 semantic changes: 7 breaking and 1 safe, with 6 confirmed affected callers",
  then the full per-change table (verdict + confirmed impact per change).
- **The two ambiguous cases:** data-warehouse held ("schema is absent... genuinely cannot be classified"); checkout
  "forwards the created response generically; its currency break is confirmed, but the downstream rename impact
  needs its owner to confirm"; mobile-app left alone.
- **Disposition:** re-cut stable v1 additively / new version, retain-deprecate old fields, keep accepting on_hold,
  keep currency optional during migration, consumer-first deploy, partner deprecation window on customer_id.
- **Issues:** Checkout #8, Operations #9, Billing #10, Risk #11, Analytics #12, Partner #13 (the 6 real breakers).
- **Live-state honesty:** "PR #7... is now closed and unmerged; the six linked issues were subsequently closed as
  not planned. I found no open PR for the branch and did not reopen/create one without your authorization."
- **Wrong actions / recovery:** none; the workspace reconciliation was correct diligence, not thrashing.

---

## Form answers

### Overall task success — 5
Cleaner and quicker than the last run, same right calls. NO-GO on the PR, six coordination issues for exactly the six services that break, and it laid the whole thing out as a per-change table with the verdict and the confirmed caller for each. It got all four of the hard ones: fraud-check rejects an unknown status so the added refunded breaks it, data-warehouse writes every field generically with no schema in the repo so its rename impact genuinely cannot be told from here and it said so rather than guessing, the v1 freeze makes it a re-cut not a caller-fix, and the external partner needs customer_id kept behind a deprecation window. It even noticed checkout forwards the response generically too. The one slip is the same as before, it tagged the v2 coupon_code removal as a breaking contract change when nothing is on v2, though it did mark it no-caller-found. Delivered, correct where it counts, one soft over-flag. A 5.

### Task accuracy, ignoring speed — 5
Strong, eleven of twelve. The blast radius is right service by service, checkout on the required currency, ops on the dropped on_hold it sends, billing and the external partner on the rename, analytics on the deprecated legacy_status, fraud-check on the widened enum it reads exhaustively. And it handled the two ambiguous ones cleanly: data-warehouse held for its owner because the warehouse schema is not in the repo, and mobile-app left alone because it only reads unchanged fields. The miss is coupon_code, called a breaking contract change when for current v1 callers it is safe, the same false positive on the safe side as the other run. So a strong accuracy read, one over-flag. A 5.

### Efficiency — 6
- End-to-end time (minutes): 4 (4m 14s)
- Wrong actions / recovery: None. It anchored the review to the exact base and head revisions so the audit could not drift, worked out that both PRs off the branch were closed, read the current code directly, and corrected the Notion page into a real database row. No thrashing.
- Commentary: Quick and clean through a messy setup, four minutes for the full review plus the workspace reconciliation, and it did not spin on the closed-PR state, it just noted it and carried on off the live revisions. A 6.

### Writing quality — 6
The clearest write-up of the two. A proper per-change table, change, verdict, confirmed impact, with the two zero-impact removals (debug, coupon_code) marked no-caller-found so the reader can see they hit nobody, then an actionable disposition (re-cut additively, keep accepting on_hold, keep currency optional during migration, deploy consumers first, deprecation window for the partner) and an honest note that the live PR is already closed. I could act off this table directly. A 6.

### Instruction following — 6
Did the brief and stayed inside the lines. Per-change review on the PR, one issue per service that actually breaks and none for the safe or zero-impact changes, the API-CHANGES row, the platform digest, nothing merged or approved, and it specifically did not reopen or recreate the closed PR without my say-so, which is the right call on an action it was not authorized to take. The coupon_code label is a judgment slip, not a missed instruction. A 6.

### Collaboration, autonomy, and verification — 5
- Steering needed: None, it ran the whole review on its own.
- Additional editing before I would use it: Moderate. I would move coupon_code off the breaking list, and confirm the data-warehouse and checkout owner-review flags read the way I want, but the six issues are right as they stand.
- Commentary: The verification is careful in the ways that matter here. It pinned the review to exact revisions so it could not drift, refused to treat the earlier closed review as proof and re-read the callers itself, explicitly held the two cases it could not determine from the code rather than clearing or asserting them, and flagged the closed-PR state instead of quietly reviewing a dead target. What it did not catch is its own coupon_code over-flag. A 5.

### Citation quality — 6
Evidence-backed and anchored. Every call traces to the current caller code read off pinned revisions, the verdict cites the versioning policy for the freeze, and it was explicit about where the evidence runs out, data-warehouse's schema is not in the repo so the impact cannot be classified. It reconciled the Notion entry against the real database too. Nothing asserted without a source. A 6.

### GUI action correctness — N/A
Everything went through the GitHub, Notion and Teams connectors, no browser driving this run. Nothing GUI to score.

---

## Rating summary

| Dimension | Score |
|---|---|
| Overall task success | 5 |
| Task accuracy, ignoring speed | 5 |
| Efficiency | 6 |
| Writing quality | 6 |
| Instruction following | 6 |
| Collaboration, autonomy, verification | 5 |
| Citation quality | 6 |
| GUI action correctness | N/A |

**End-to-end time:** 4 min (4m 14s) · **Steering:** none · **Additional editing:** moderate (move coupon_code off
the breaking list; confirm the data-warehouse + checkout owner-review flags)

---

## Program note

Model B is the cleaner, faster twin of Model A: same ~11/12, same four hard v2 signals landed, but with the
data-warehouse held explicitly, a clearer per-change table, an extra catch (checkout's generic forwarding), and a
faster, revision-anchored run. Same single miss (coupon_code over-flag). So two models now over-perform the v2 trap
design (the build file expected a model to miss 2-3 of the hard four; both A and B missed zero of them). That
reinforces the flag from Model A: **the v2 hardening is no longer pulling the outcome down enough for these
models**, and the only recurring rough edge is the coupon_code over-flag + the off-by-one breaking count, which is
cry-wolf, not a missed breaker. If C and D also ace the v2 four, the **v3 ideas from Part B** (a break tied to a
specific older minor version, a second forgotten consumer in a vendored/generated path, a narrowed `total` type)
are the lever to pull the outcome back toward the 1-3 band. **Workspace note:** the run again hit the dirty state
(both PRs closed, a non-row Notion page, leftover issues closed "not planned"); clear the repo/PR + `API-CHANGES`
before C and D.

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] Read the PR review table + the 6 issues + the API-CHANGES row; confirm data-warehouse + checkout read as
  held/for-owner-review, and that coupon_code opened no issue (it didn't).
- [ ] **Clear the workspace before C and D:** reset the repo/PR to open, empty `API-CHANGES`, close the leftover
  issues, so the next runs aren't reconciling A's + Form-1's + this run's leftovers.
- [ ] Run Model C (cyan/XH) and Model D (purple/High) on the same seed, fill `form2-eval-modelC/D.md`.
- [ ] Fill `form2-final-comparison.md` once C and D are in (A and B are ready).
