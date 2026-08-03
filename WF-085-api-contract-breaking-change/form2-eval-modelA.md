# WF-079 — Form 2 (OpenAI Eval Feedback) — Model A responses

**Workflow:** WF-079 API Contract Breaking-Change & Consumer-Impact Review (seeded `orders-platform` repo, **v2 hardened**)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (first Form 2 round; this is the four-model set A/B/C/D. WF-079 had no earlier 3-model round, only the
Form-1 v2 run). B/C/D to follow on the same seed.
**This file:** Model A only — **gpt-5.5-cyan, High intelligence** (confirmed on the run: "5.5 Cyan High")
**Session ID:** `[paste this run's session ID]` (runtime 6m 28s)
**Run dataset:** the seeded `orders-platform` repo (published `orders-api.yaml` + `VERSIONING.md`, the
`evolve-orders-api` PR with the 8 planted spec edits, 7 consumers + the external `partner-webhook`). Apps: GitHub
(PR review + issues), Notion (`API-CHANGES`), Microsoft Teams (`platform`).
**Status:** Model A done, **strong run for a hardened build — ~11 of 12 signals.** It aced **all four hard v2
signals** (fraud-check on the `refunded` add, data-warehouse held for owner review, the `/v1` freeze re-cut, the
external-partner deprecation window), which the build file expected models to miss 2-3 of. The one firm miss is the
same as the Form-1 v2 run: it **over-flagged the v2 `coupon_code` removal as breaking** and led every surface with
an inflated **7-breaking headline** (only 6 services break). Handled a messy leftover workspace well (PR #7 already
closed, the Notion page not a real DB row). Honest Form 2: a **"correct core, noisy run" profile, mostly 5s**, with
6s on instruction-following and citation. (Form 1's outcome field stays a 4 in the reviewer's 3-4 band; Form 2 is
scored honestly here.)

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
| 6 | Initial Codex test rating (1-7) | 4 (correct on the judgment that matters, including all four hard v2 calls, but noisy: over-flagged the v2 `coupon_code` removal as breaking and led with an inflated 7-breaking headline, plus setup friction from a messy leftover workspace) |
| 7 | Notes | NO-GO verdict, 6 coordination issues for exactly the 6 real breakers (checkout #8 currency, ops #9 on_hold, billing #10 rename, fraud-check #11 refunded, analytics #12 legacy_status, partner-webhook #13 rename/external), the API-CHANGES Notion row, the platform digest, nothing merged. Aced the four v2 traps: fraud-check on the widened enum, data-warehouse held for owner review, the `/v1` freeze re-cut, the partner deprecation window. Slip: called the v2 `coupon_code` removal breaking (safe for v1 callers) and led with 7 breaking / 1 safe (6 services break). Handled a dirty workspace: PR #7 already closed from a prior run, the Notion page not a real DB row, code-search index down (browser fallback to re-trace callers). |

---

## Grading-key check (the twelve scorable signals, from the main file)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | required `currency` = breaking, optional `notes` = safe | ✅ | checkout-web issue #8 (currency); `notes` is the "1 safe" in "7 breaking, 1 safe" |
| 2 | rename breaking + **partner-webhook** found (outside `consumers/`) | ✅ | partner-webhook issue #13 |
| 3 | `legacy_status` removal = breaking (analytics still reads it) | ✅ | analytics-batch issue #12 |
| 4 | enum **remove `on_hold`** = breaking for the sender (ops-dashboard) | ✅ | ops-dashboard issue #9 |
| 5 | v2 `coupon_code` removal safe for the v1 mobile-app | ❌ **FAIL** | over-flagged: "7 breaking" includes coupon_code (no issue opened, but wrongly classified breaking) |
| 6 | mobile-app NOT flagged for the rename (reads only unchanged fields) | ✅ | not among the 6 issues |
| 7 | `debug` removal breaking-by-rule but zero blast radius, ranked low | ✅ | no issue opened for it (zero-impact handling); folded into the freeze violation |
| 8 | overall **no-go** verdict, counts reconcile across PR/issues/Notion/Teams | ✅ | "Verdict: NO-GO"; "Matching digest verified in the platform channel"; API-CHANGES row verified |
| 9 | enum **add `refunded`** = breaking for **fraud-check** (exhaustive response reader) | ✅ **WIN** | fraud-check issue #11 (the signature v2 trap, not waved through as a safe widening) |
| 10 | **data-warehouse** rename impact = undeterminable / for owner review | ◐ likely | "affecting 6 **confirmed** services" (data-warehouse excluded from the 6, not a clean issue) — verify it reads as a held/for-review flag in-app, not a silent clear |
| 11 | verdict cites the **`/v1` freeze** and recommends re-cut as `/v2`/additive | ✅ | "re-cut stable-v1 changes additively or under a new version, migrate internal callers first" |
| 12 | **partner-webhook** fix is a **deprecation window** (external), not a same-day cutover | ✅ | "retain the partner's old shape through a deprecation window" |

**~11 of 12** — the one firm miss is signal 5 (the coupon_code over-flag). **Notable:** it got **all four hard v2
signals (9, 10, 11, 12)**, where the build file's "real expectation" was that a model misses 2-3 of them. So on the
hardened judgment this run over-performed the design target; its only stumble is on an original signal (the v2-only
`coupon_code` removal), the same one the Form-1 v2 run tripped.

**The recurring rough edge:** the inflated **"7 breaking / 1 safe"** headline. The correct change-level count is
**6 breaking + 2 safe** (`notes` and `coupon_code` safe; `debug` breaking-by-rule but zero-impact). Calling
coupon_code breaking pushes it to 7, and that headline leads the PR comment, the Notion row and the Teams digest,
over-stating the severity, which is exactly the cry-wolf this check exists to prevent.

---

## Run evidence (from the run screenshots)

- **Runtime:** 6m 28s, full access. GitHub, Notion and Teams (Codex Apps) connectors + a signed-in browser step.
- **Messy leftover workspace, handled honestly:** "GitHub currently reports the matching 'Evolve Orders API' pull
  request as closed rather than open" (a prior run left PR #7 closed/unmerged) → it verified the target before
  writing. The code-search index was unavailable → it "used the signed-in browser workflow to inspect the two
  remaining caller folders... specifically to avoid treating the existing review as proof of caller behavior" (it
  re-traced callers rather than trusting leftover state). The existing Notion page "is not actually a row in
  API-CHANGES" → it created the proper database entry, preserving the page.
- **Verdict:** "NO-GO, 8 semantic changes: 7 breaking, 1 safe, affecting 6 confirmed services."
- **Issues (the actionable output, exactly the 6 real breakers):** checkout-web #8, ops-dashboard #9,
  billing-service #10, fraud-check #11, analytics-batch #12, partner-webhook #13. None for mobile-app, none for any
  safe change, none for coupon_code/debug (zero-impact).
- **Fix framing:** "re-cut stable-v1 changes additively or under a new version, migrate internal callers first, and
  retain the partner's old shape through a deprecation window."
- **Live-state honesty:** "GitHub currently shows PR #7 as closed and unmerged, not open; its coordination issues
  are also closed. I did not approve, merge, reopen, or modify consumer code."
- **Wrong actions / recovery:** none wasted; the detours (target check, browser fallback, Notion-row fix) were all
  correct responses to a dirty workspace + a down code index.

---

## Form answers

### Overall task success — 5
It did the whole review live and got the calls that matter right. NO-GO verdict on the PR, six coordination issues open for exactly the six services that actually break, checkout on the required currency, ops on the dropped on_hold it still sends, billing and the forgotten partner-webhook on the rename, analytics on the deprecated legacy_status it still reads, and the one that usually slips, fraud-check on the added refunded value it switches on with no default. It cited the v1 freeze and said re-cut the change as v2 or additive, and it gave the external partner a deprecation window rather than a same-day cutover. Where it drops a mark: it called the v2 coupon_code removal breaking when nothing is on v2 so it is safe for current callers, and it led every surface with a 7-breaking headline when only six services break. No issue was opened off those, so nothing downstream is wrong, but the classification and the headline over-state it. It also handled a messy repo well, the PR was already closed from an earlier run and the Notion page was not a real database row, and it flagged both honestly and fixed the row. A 5, right where it counts, noisy on the edges.

### Task accuracy, ignoring speed — 5
On the hard part it is strong. Eleven of the twelve calls land, including all four of the ones this review is built to catch: fraud-check breaks on the widened enum because it reads the response and handles the old set exhaustively, data-warehouse reads the response generically so its rename impact is held for the owner rather than cleared or asserted, the v1 freeze makes it a policy no-go not just a caller-fix, and the external partner needs a deprecation window. The blast radius is field-level and correct, mobile-app reads only unchanged fields so it is left alone, and the forgotten partner outside the consumers folder is found. The one real miss is the v2 coupon_code removal called breaking, which for callers still on v1 is safe, and that also inflates the change count. A strong accuracy read with one false positive on the safe side. A 5.

### Efficiency — 5
- End-to-end time (minutes): 6 (6m 28s)
- Wrong actions / recovery: None wasted, but it had to work around a messy environment. The PR was already closed from an earlier run, so it verified the target before writing; the repo's code-search index was down, so it drove the signed-in browser to inspect the caller folders instead; and the existing Notion page was not a real database row, so it created the proper entry.
- Commentary: A clean line through a dirty setup. None of the time was thrashing, but a fair chunk went into confirming the PR target, the browser fallback for the caller trace, and fixing the Notion gap, so it is not a quick run. A 5.

### Writing quality — 5
The structure is good, verdict first, then the per-change list, the six issues, the fix, and an honest note that the live PR is already closed. But it leads the PR comment, the Notion row and the Teams digest with 7 breaking / 1 safe, and that headline over-states the severity, six services actually break and two of the seven breaking changes hit nobody. On a review people act on, leading with an inflated count is the one thing this check is supposed to avoid. Clear, but the framing oversells it. A 5.

### Instruction following — 6
It followed the brief closely. A per-change review posted on the PR, one coordination issue per service that actually breaks and none for the safe changes or the zero-impact ones, the Notion API-CHANGES entry, the platform digest, nothing approved or merged and no consumer code touched. It even kept the issue set to the six real breakers rather than opening one for every change it labeled breaking, which is the right reading. The coupon_code call is a judgment slip, not a missed instruction. A 6.

### Collaboration, autonomy, and verification — 5
- Steering needed: None, it ran the whole review on its own.
- Additional editing before I would use it: Moderate. I would drop coupon_code from the breaking list and re-headline the count to six services, and I would confirm the data-warehouse review flag reads the way I want.
- Commentary: The verification is genuinely careful where it counts. It refused to trust the existing review as proof of caller behavior and re-traced the callers itself through the browser when the code index was down, it caught that the Notion page was not a real database row and fixed it, and it flagged the closed-PR state instead of quietly reviewing a dead PR. What it did not catch is its own coupon_code over-flag and the inflated headline, which is the cry-wolf this check exists to prevent. A 5.

### Citation quality — 6
Evidence-backed throughout. Each breaking call traces to the actual caller code, and it re-verified that trace independently rather than leaning on the leftover review, the verdict cites the VERSIONING policy for the v1 freeze, and the Notion entry was reconciled against the real database. Nothing asserted without the code or the policy behind it. A 6.

### GUI action correctness — N/A
The browser was used read-only, to inspect the caller folders and the file tree when the code-search index was unavailable; all the writes (the PR review, the issues, Notion, Teams) went through connectors. No clicks or dialogs driven, so nothing GUI to score.

---

## Rating summary

| Dimension | Score |
|---|---|
| Overall task success | 5 |
| Task accuracy, ignoring speed | 5 |
| Efficiency | 5 |
| Writing quality | 5 |
| Instruction following | 6 |
| Collaboration, autonomy, verification | 5 |
| Citation quality | 6 |
| GUI action correctness | N/A |

**End-to-end time:** 6 min (6m 28s) · **Steering:** none · **Additional editing:** moderate (drop coupon_code from
the breaking list, re-headline to 6 services, confirm the data-warehouse review flag)

---

## Program note

Unlike the clean-sweep workflows (WF-047/082/086/096), WF-079 is **v2-hardened**, so the honest Form 2 is not
straight 6s, it is a "correct core, noisy run" of mostly 5s. What's worth flagging for the program: this run got
**all four hard v2 signals** (fraud-check, data-warehouse held, the `/v1` freeze, the partner window), where the
build file's design target was for a model to **miss 2-3 of them**. So on the hardened judgment, gpt-5.5-cyan/High
is over-performing the trap design, and the only thing keeping the run off a clean pass is the **coupon_code
over-flag + the inflated 7-breaking headline** (both cry-wolf, not missed breakers). If B/C/D also ace the v2 four,
the v2 hardening is no longer doing enough to pull the outcome down, and the **v3 ideas from Part B** (a break tied
to a specific older minor version, a second forgotten consumer in a vendored/generated path, a narrowed `total`
type that breaks arithmetic but not display) are the lever. **Workspace note:** the run hit a dirty state (PR #7
closed from a prior run, a non-row Notion page, leftover issues); clear the repo/PR + the `API-CHANGES` DB before
the B/C/D runs so they start clean.

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] Read the PR review + the 6 issues + the Notion row: confirm data-warehouse reads as a held/for-owner-review
  flag (not silently cleared), and that coupon_code opened no issue (it didn't).
- [ ] **Clear the workspace before B/C/D:** reset the repo/PR to open, empty `API-CHANGES`, close the leftover
  issues, so the next runs aren't reconciling this run's + the Form-1 run's leftovers.
- [ ] Run Model B (purple/XH), Model C (cyan/XH), Model D (purple/High) on the same seed, fill
  `form2-eval-modelB/C/D.md`.
- [ ] Fill `form2-final-comparison.md` once 2+ models are in.
