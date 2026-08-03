# WF-079 — Form 2 (OpenAI Eval Feedback) — Model D responses

**Workflow:** WF-079 API Contract Breaking-Change & Consumer-Impact Review (seeded `orders-platform` repo, **v2 hardened**)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (first Form 2 round; the four-model set A/B/C/D).
**This file:** Model D only — **gpt-5.5-purple, High intelligence** (confirmed on the run: "5.5 Purple High")
**Session ID:** `[paste this run's session ID]` (runtime 3m 33s)
**Run dataset:** the seeded `orders-platform` repo (published `orders-api.yaml` + `VERSIONING.md`, the
`evolve-orders-api` branch with the 8 planted spec edits, 7 consumers + the external `partner-webhook`). Apps:
GitHub (intended: PR review + issues), Notion (`API-CHANGES`), Microsoft Teams (`platform`).
**Status:** Model D done, **correct judgment, but STOPPED, delivered nothing live.** The evidence review matches
the other three (~11/12, aced the hard v2 four, same coupon_code miss), but it found PR #7 closed/unmerged,
concluded there was no valid open target, and **held all four live outputs** (no PR review, issues, Notion, or
Teams), asking to reopen the PR. It correctly refused to reopen without authorization, but it over-held the
PR-independent outputs (issues/Notion/Teams don't need an open PR). Its non-delivery is largely an artifact of the
**un-cleared workspace** (closed PR). Honest Form 2: judgment 5-6, delivery 3-4.

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
| 6 | Initial Codex test rating (1-7) | 3 (correct evidence review, but it stopped at the live-write stage and shipped none of the four outputs, asking me to reopen the closed PR before it would post) |
| 7 | Notes | Preliminary NO-GO, correct classification: 6 definite breakers (billing, checkout, analytics, ops, fraud-check, external partner-webhook), data-warehouse held for owner confirmation, mobile-app cleared, notes the only safe change; anchored to exact base/head SHAs. Same coupon_code over-flag (listed breaking). Then blocked itself on the live writes because PR #7 is closed/unmerged; did not post the PR review, the issues, the Notion row, or the Teams digest; did not reopen the PR (correctly, unauthorized) but also held the PR-independent outputs. Asked me to reopen PR #7 or send a new PR URL. |

---

## Grading-key check (the twelve scorable signals, from the main file)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | required `currency` = breaking, optional `notes` = safe | ✅ | "required currency" breaking; "The only safe change is optional NewOrder.notes" |
| 2 | rename breaking + **partner-webhook** found | ✅ | "v1 customer_id response rename" breaking; "external partner-webhook" in the 6 broken |
| 3 | `legacy_status` removal = breaking (analytics) | ✅ | "deprecated legacy_status removal" breaking; analytics-batch broken |
| 4 | enum **remove `on_hold`** = breaking for the sender (ops-dashboard) | ✅ | "on_hold removal" breaking; ops-dashboard broken |
| 5 | v2 `coupon_code` removal safe for the v1 mobile-app | ❌ **FAIL** | "v2 coupon_code removal" listed among the 7 breaking (over-flag, same as A/B/C) |
| 6 | mobile-app NOT flagged for the rename | ✅ | "mobile-app only reads unchanged id, status, and total" |
| 7 | `debug` removal breaking-by-rule but zero blast radius | ✅ | "v1 debug operation removal" in the 7 breaking, no caller |
| 8 | overall **no-go**, counts reconcile across outputs | ◐ **partial** | verdict "NO-GO, 7 breaking, 1 safe" is correct, but **the live outputs were not created** (blocked), so there's nothing to reconcile across |
| 9 | enum **add `refunded`** = breaking for **fraud-check** | ✅ **WIN** | "response refunded widening for the strict Fraud caller"; fraud-check broken |
| 10 | **data-warehouse** rename impact = undeterminable / for owner review | ✅ | "data-warehouse generically persists response keys, so its schema/downstream impact needs owner confirmation rather than being classified as safe or definitely broken" |
| 11 | verdict cites the **`/v1` freeze**, re-cut as `/v2`/additive | ◐ **not surfaced** | it read the versioning policy and called NO-GO, but stopped before the full review, so the explicit re-cut recommendation isn't in the output |
| 12 | **partner-webhook** fix = deprecation window (external) | ◐ **not surfaced** | identified partner-webhook as external + broken, but stopped before the per-caller disposition, so the deprecation-window recommendation isn't stated |

**Classification: as strong as A/B/C** (signals 1-4, 6, 7, 9, 10 all correct, incl. the hard fraud-check +
data-warehouse; same coupon_code miss). **But because it stopped before the live writes, signals 8, 11 and 12 are
incomplete** — the counts couldn't reconcile across outputs that don't exist, and the freeze re-cut + partner
deprecation-window recommendations (which A/B/C all articulated) weren't surfaced.

---

## Run evidence (from the run screenshots)

- **Runtime:** 3m 33s, full access — short partly because it did not do the live writes. GitHub, Notion, Teams
  (Codex Apps) connectors + a read-only in-app browser step.
- **Evidence pass (correct):** resolved the branch + exact base/head SHAs off repo metadata when the PR index
  didn't return the PR; used the in-app browser "only for that repository-tree gap" (the one unknown Mobile source
  filename); "eight semantic changes, seven breaking and one safe, with six definite callers broken and one generic
  Data Warehouse path requiring owner confirmation."
- **The stop:** "I'm blocked on the live writes because there is no open PR to review. The matching PR is
  orders-platform PR #7, but GitHub reports it as closed, unmerged. Its head is exactly evolve-orders-api at
  0050abc98e125b7632c8365395b828a6c0a6c2c7." → "Please reopen PR #7 or send me the new open PR number/URL. I can
  then post the review, create the correctly linked coordination issues, add the single API-CHANGES entry, and
  publish the matching Teams digest."
- **Boundary respect (the good part):** "I did not create duplicates, attach a new review to a closed PR, or create
  a Notion entry that falsely refers to an open PR. I also did not reopen or create a PR because that was not
  authorized."
- **The over-hold:** it held the issues, the Notion row and the Teams digest too, none of which requires an open PR.
- **Wrong actions / recovery:** none wasted, but the run ended incomplete at the live-write stage.

---

## Form answers

### Overall task success — 3
The analysis is right, but it did not deliver. It worked out the whole review correctly, NO-GO, the six services that break, data-warehouse held for owner confirmation, mobile-app cleared, notes the only safe change, and it caught fraud-check on the widened enum. Then it stopped: it found the PR is closed and unmerged, decided there was no valid open target for the live writes, and asked me to reopen PR #7 or send a new PR URL before it would post anything. So none of the four things I actually need landed, no PR review, no coordination issues, no Notion entry, no Teams digest. Some of its caution is fair, it would not attach a review to a dead PR or reopen one without my say-so, but the issues, the Notion row and the digest do not need an open PR, and it held those too. The judgment is there, the delivery is not. A 3.

### Task accuracy, ignoring speed — 5
On the judgment it matches the other runs. Six definite breakers, checkout on currency, ops on on_hold, billing and the external partner on the rename, analytics on legacy_status, fraud-check on the added refunded, data-warehouse held for owner confirmation because it persists fields generically, mobile-app cleared, notes the only safe change. It anchored all of that to the exact base and head SHAs. The same miss as the rest, coupon_code listed as breaking when it is safe for v1 callers. What it did not get to is the full disposition, the explicit re-cut recommendation and the partner deprecation window, because it stopped before writing the review. So the classification is right, the write-up is unfinished. A 5.

### Efficiency — 5
- End-to-end time (minutes): 4 (3m 33s)
- Wrong actions / recovery: None wasted. It resolved the branch and the exact SHAs off the repo metadata when the PR index did not return the PR, used the in-app browser only for the one missing Mobile filename, and did the caller audit, then stopped at the live-write stage.
- Commentary: The time is short, but partly because it did not do the live writes. The evidence pass itself was clean and quick, no thrashing, but the run ended incomplete, so there is not a lot of end-to-end to score. A 5.

### Writing quality — 6
The summary is clear and honest. A preliminary NO-GO with the eight changes broken out, the six breakers, the held data-warehouse and the cleared mobile-app, and then a plain explanation of why it is blocked, the PR is closed at a specific SHA, GitHub returns no open PR, and a clear ask to reopen it or send the new URL. It even gives the exact head commit. Nothing muddy about it. A 6.

### Instruction following — 4
It followed the analysis and the safety lines well, read the spec and every caller, did not merge or approve, did not reopen the PR without authorization, and refused to write a Notion row that falsely points at an open PR. But the brief's four deliverables, the PR review, an issue per broken service, the Notion entry and the Teams digest, are the point of the task, and it produced none of them. The prompt's stop-and-tell-me clause is for when it cannot read the repo or run the diff, and it could do both here, so stopping over a closed PR is stretching that clause. Good on the guardrails, short on the deliverables. A 4.

### Collaboration, autonomy, and verification — 4
- Steering needed: One, and it is the issue. It stopped and asked me to reopen PR #7 or hand it a new PR before it would post anything.
- Additional editing before I would use it: Heavy. I have to reopen the PR (or point it at a new one) and tell it to continue, and then it still owes me all four live outputs.
- Commentary: The verification is careful, it pinned the exact SHAs, checked for existing issues and digests so it would not duplicate, and would not create a misleading record. But being careful is not finishing, and it handed the task back over a blocker that only touches the PR review, not the issues or the Notion row or the digest, which it could have posted. A 4.

### Citation quality — 6
Evidence-backed and precise. Every call traces to the caller code read off the exact base and head SHAs, it named the head commit, and it was explicit that data-warehouse's downstream impact cannot be classified from the repo. It used the browser only to close the one file-tree gap. Nothing asserted without a source. A 6.

### GUI action correctness — N/A
The browser was used read-only, to get the one Mobile source filename the connector would not list; there were no live writes through it. Nothing GUI to score.

---

## Rating summary

| Dimension | Score |
|---|---|
| Overall task success | 3 |
| Task accuracy, ignoring speed | 5 |
| Efficiency | 5 |
| Writing quality | 6 |
| Instruction following | 4 |
| Collaboration, autonomy, verification | 4 |
| Citation quality | 6 |
| GUI action correctness | N/A |

**End-to-end time:** 4 min (3m 33s, incomplete) · **Steering:** one (reopen the PR / send a new PR URL) ·
**Additional editing:** heavy (reopen the PR, tell it to continue; it still owes all four live outputs)

---

## Program note

Model D is the odd one out on delivery, not judgment. Its classification is as strong as A/B/C (~11/12, all four
hard v2 signals landed, same coupon_code miss), but it stopped at the live-write stage and shipped none of the four
outputs, because it found the PR closed and would not post to a dead target or reopen it unauthorized. Its
caution about the PR review and the no-reopen boundary is defensible, but it over-held the issues, the Notion row
and the digest, which don't need an open PR. **The real story is the workspace:** all four runs hit the same dirty
state (PR closed from prior runs), and where A/B/C adapted and delivered, D stopped, so D's non-delivery is largely
an artifact of the un-cleared workspace, not a judgment weakness. Two takeaways: (1) **the round should be re-run
on a clean workspace** (open PR, empty `API-CHANGES`, no leftover issues) for a fair delivery comparison, D almost
certainly delivers on a clean board; and (2) the **judgment finding stands across all four** — every model aced the
v2 four (the build file expected 2-3 misses), so the **v2 hardening is not challenging this model line**, and the
**v3 ideas from Part B** (a break tied to a specific older minor version, a second forgotten consumer in a
vendored/generated path, a narrowed `total` type) are the lever to pull the outcome back toward 1-3.

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] Round 1 is complete (A, B, C, D all in). See `form2-final-comparison.md`.
- [ ] **Clear the workspace and re-run** (reset PR to open, empty `API-CHANGES`, close/settle leftover issues) so
  the delivery comparison isn't confounded by the closed-PR state (it stopped D and forced heavy reconciliation on
  A/B/C).
- [ ] **Apply the v3 hardening** (Part B) before submission, since the v2 four no longer challenges the model line.
