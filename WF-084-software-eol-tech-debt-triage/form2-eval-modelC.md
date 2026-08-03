# WF-048 — Form 2 (OpenAI Eval Feedback) — Model C responses

**Workflow:** WF-048 Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date, no-seed)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (red, clean run on an emptied workspace; completes the blue / yellow / red lineup)
**This file:** Model C only — **gpt-5.5-red, Extra High intelligence**
**Session ID:** `[paste this run's session ID]` (runtime 5m 50s, single pass, no continuation)
**Run dataset:** live endoflife.date, fixed reference date **2025-06-01**, the pinned 15-item inventory, on a
**freshly emptied workspace** (it verified `EOL Sweep` was empty apart from the header). Apps: Google Sheets
(`Tech Debt Tracker` / `EOL Sweep`), Notion (`TECHDEBT`), Microsoft Teams (`platform`, Development team).
**Status:** Model C (red) done, **completed autonomously on the original prompt, no steering.** It did not stop,
it retried transient feed errors, mapped OpenJDK 8 to the Red Hat build with a documented rationale, grouped the
13 upgrade items into 6 tight initiatives, and posted the digest, all verified. Clean run, which for our program
is the **too-easy** outcome. Arguably the strongest of the three on grouping and robustness.

> **Persona (voice).** Platform / SRE engineer running the monthly EOL sweep. Plain and a bit dry, likes to see
> a run recover from a flaky feed instead of bailing or making something up.

> **No continuation was sent.** Red finished the full sweep on the original prompt alone. Unlike blue and the
> first yellow run, it never hit the stop, it retried the failed reads and carried on. Steering-needed = 0.

---

## Metadata used (persona + scoring inputs) — same as Form 1

| # | Field | Value |
|---|---|---|
| 1 | Occupation / career | Computer Systems Analyst |
| 2 | Occupation + workplace (persona voice) | Platform engineering / SRE, running the periodic end-of-life tech-debt sweep across our software estate |
| 3 | Time to complete WITHOUT a model (min) | 90 |
| 4 | Times per month | 1 |
| 5 | Workflow difficulty (1-7) | 6 |
| 6 | Initial Codex test rating (1-7) | 6 (clean, unattended, correct, recovered from flaky feeds on its own; note we WANT this low, so 6 = too easy and wants harder inputs) |
| 7 | Notes | Single-pass run on an emptied workspace, no stop, no steering. Retried the transient PostgreSQL/Django/OpenJDK read failures before deciding on the stop rule. 15 rows, 6 grouped initiatives for the 13 upgrade items, digest to platform/Development, counts reconcile. OpenJDK 8 mapped to the Red Hat build (estate is CentOS-based), documented not invented; PostgreSQL active-support marked "not published". |

---

## Grading-key check (validation rules + the six checkpoints)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | Every inventory item classified | ✅ | 15 verified rows on `EOL Sweep`, no blanks: 4 Critical / 6 High / 3 Medium / 2 fine |
| 2 | Active-vs-security honored | ✅ | "10 past EOL, 3 security-support-only, 0 approaching, and 2 fine" read correctly; Ubuntu 20.04 counted past public EOL, consistent with the other runs (though not spelled out as explicitly as yellow did) |
| 3 | Status read against 2025-06-01 | ✅ | "no 'approaching' rows"; reconciled every cycle against the fixed date |
| 4 | Tiers reflect urgency × criticality | ✅ | 4 Critical / 6 High / 3 Medium, OS/DB critical shape |
| 5 | Grouping into upgrade initiatives | ✅ **(strong)** | "six verified grouped initiatives covering all 13 attention items", the tight, consolidated grouping (folds the pairs), matching blue and tighter than yellow's 10 |
| 6 | Entries for exactly the needs-upgrade items | ✅ | 6 initiatives for the 13 upgrade items; no entry for the 2 fine (PostgreSQL 16 and OpenJDK 8/Red Hat) |
| 7 | No fabricated data | ✅ **(strength)** | Retried the transient read failures "before deciding whether the clean-stop rule applies" rather than inventing; OpenJDK "mapped transparently to the Red Hat build ... keeps the date vendor-specific rather than invented"; PostgreSQL cells "explicitly say" no separate active-support date |
| 8 | Counts reconcile | ✅ | 15 = 13 upgrade + 2 fine; "posting those exact counts to Teams"; digest matches the sheet and the 6 initiatives |

**OpenJDK 8, red's call:** it mapped the row to the Red Hat build on the reasoning that the surrounding estate is
CentOS-based, found it supported (single phase to late 2026), classified it fine, and opened no entry, all
documented as an assumption to confirm. That's contextual judgment (using the estate to disambiguate the vendor)
rather than the "leave it unresolved" reading the nudge imposed on blue and yellow. Both are defensible; red's is
the more resolved and, given the CentOS estate, the better-reasoned one.

---

## Run evidence (from the run screenshots)

- **Runtime:** 5m 50s, single pass, no continuation.
- **Plan:** fetch each dataset once, reconcile every cycle against 2025-06-01, then write and cross-check the
  sheet, work items and digest.
- **Recovered from flaky feeds:** "PostgreSQL and Django came back without their bodies, and OpenJDK hit a
  transient retrieval error, so I'm retrying only those failed reads before deciding whether the clean-stop rule
  applies." It retried, got them, and continued, no fabrication, no premature stop.
- **OpenJDK mapping:** "treating the OpenJDK row as the Red Hat build because the surrounding estate is
  CentOS-based; endoflife.date has no vendor-neutral OpenJDK lifecycle, and this mapping keeps the date
  vendor-specific rather than invented."
- **Destination checks:** "the 'EOL Sweep' tab exists and is empty apart from its header; TECHDEBT has the
  expected priority/status fields; and 'platform' resolves uniquely to the Development team." Confirmed the clean
  workspace before writing.
- **Order + verification:** wrote the 15-row sheet first, created 6 grouped initiatives, and "only send Teams
  after both are verified." Posted to Development / platform.
- **Totals:** 4 critical, 6 high, 3 medium, 2 fine; 10 past EOL, 3 security-support-only, 0 approaching, 2 fully
  supported. PostgreSQL active-support "not published"; OpenJDK mapped transparently to Red Hat.
- **Wrong actions / recovery:** the only adversity was the transient feed errors, and it recovered by retrying.
  No wrong-target writes, no stop, nothing walked back.

---

## Form answers (copy-paste ready, plain spoken, no em dashes)

### Overall task success — 6
Best of the three on delivery. It did the whole sweep off the original prompt, no stopping and no nudge from me,
and it came out clean: 15 rows, six tight upgrade initiatives covering all thirteen items, a digest on the
platform channel, counts matching across all three. What I liked most is it hit flaky feeds partway, Postgres and
Django empty, OpenJDK erroring, and instead of bailing under the stop rule or inventing dates it retried just
those and carried on. That's the judgment the stop rule is actually asking for. A strong 6, which for us means
the inputs are too soft.

### Task accuracy, ignoring speed — 6
The reading is right and the grouping is the tightest of the runs. Ten past EOL, three security-support-only, two
fine, the buckets line up, and it folded the thirteen items into six initiatives properly rather than leaving the
Ubuntu and Postgres pairs loose. OpenJDK it mapped to the Red Hat build off the CentOS estate and said so, which
is a sensible way to resolve an ambiguous vendor without guessing blind. Nothing invented, Postgres active
support marked "not published". The one thing I'd note is it didn't spell out the Ubuntu 20.04 ESM reasoning as
explicitly as yellow did, but the call is the same and correct. 6.

### Efficiency — 6
- End-to-end time (minutes): ~6 (5m 50s, single pass)
- Wrong actions / recovery: The only hiccup was three feeds failing on the first pass; it retried exactly those
  and moved on. No wrong writes, no stop, no thrashing.
- Commentary: A bit slower than yellow's clean run, but that's the retry cost and it was time well spent, it
  recovered the missing feeds instead of stopping. Straight line otherwise, fetch, classify, verify, write. 6.

### Writing quality — 6
Clear and it documents the calls that need documenting, the OpenJDK Red Hat mapping and why, the Postgres "not
published" note, the reconciled totals. The digest states the exact counts. Reads clean, 6.

### Instruction following — 6
Everything's there: right sheet and tab, six initiatives for the thirteen upgrade items, digest to the platform
channel (resolved uniquely to Development, no mixup), all 15 rows, nothing invented. It handled OpenJDK by
mapping-and-flagging rather than leaving it blank, a fair read of "don't invent dates" since the Red Hat cycle is
real. No overreach on the Notion schema. 6.

### Collaboration, autonomy, and verification — 6
- Steering needed: None. It completed the full sweep on the original prompt with no intervention.
- Additional editing before I'd use it: Light. Confirm the OpenJDK 8 vendor assumption (Red Hat) matches the
  actual batch service, otherwise the sheet, the six initiatives and the digest are usable as they stand.
- Commentary: This is the top of the band for me. It ran hands-off, and the verification was real, it checked the
  three destinations before writing, retried the failed feeds before deciding the stop rule applied, and held the
  Teams post until the sheet and Notion were both verified. Recovering from a flaky feed rather than stopping or
  faking it is exactly what I want and the reason this edges the others. A strong 6.

### Citation quality — 6
Well grounded. Every date from endoflife.date, the OpenJDK row pinned to the Red Hat build with the vendor
assumption stated, Postgres active-support marked not published, and the retried reads mean the dates are real,
not filled in. Auditable, 6.

### GUI action correctness — N/A
Sheet, Notion and Teams over connectors plus web fetches, no browser UI. Nothing GUI to score.

---

## Rating summary

| Dimension | Score |
|---|---|
| Overall task success | 6 |
| Task accuracy, ignoring speed | 6 |
| Efficiency | 6 |
| Writing quality | 6 |
| Instruction following | 6 |
| Collaboration, autonomy, verification | 6 |
| Citation quality | 6 |
| GUI action correctness | N/A |

**End-to-end time:** ~6 min (5m 50s, single pass) · **Steering:** 0 needed · **Additional editing:** light
(confirm the OpenJDK 8 = Red Hat vendor assumption)

---

## Program note (important)

Red is the third clean autonomous run in a row (after yellow's clean rerun), so the honest outcome is a 6 and
**WF-048 is sitting in the too-easy band** for the gpt-5.5 variants once the workspace is clean. The judgment the
sweep tests, the active-vs-security split, the Ubuntu 20.04 ESM call, the grouping, the OpenJDK vendor ambiguity,
all three models handle well. The only thing that ever tripped a model was the stop clause (blue and the first
yellow), and red showed the correct way through it (retry, then decide), which confirms that's a prompt-wording
soft spot, not real task difficulty. So before submission, harden the inputs: more LTS/ESM-divergent cycles, a
bigger inventory, a second genuinely ambiguous item, and if we can touch the prompt, tighten the stop clause.
That's what moves the outcome back toward the 1-3 we want.

---

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] Confirm the **OpenJDK 8 vendor** assumption (Red Hat) matches the real batch service, and settle the
  answer-key reading of OpenJDK (map-to-Red-Hat-and-fine, as red and yellow's Turn 1 did, vs unresolved, as the
  nudge imposed).
- [ ] Settle the **grouping** convention for the key (6 consolidated, red/blue, vs 10, yellow) and the **Ubuntu
  20.04** public-EOL-vs-ESM call, so all three are graded on one rule.
- [ ] **Decide on a clean blue rerun** (blue's scored run stopped and needed steering; yellow and red both
  completed clean, so blue may just be variance) before finalising, or accept it and flag the variance.
- [ ] Fill `form2-final-comparison.md` now that all three are in.
