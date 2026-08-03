# WF-048 — Form 2 (OpenAI Eval Feedback) — Model A responses

**Workflow:** WF-048 Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date, no-seed)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (blue; yellow and red to follow on the same inventory + reference date)
**This file:** Model A only — **gpt-5.5-blue, Extra High intelligence**
**Session ID:** `[paste this run's session ID]` (stopped at 3m 17s, then a continuation message → 4m 38s more,
so ~7m 55s of model work across two turns)
**Run dataset:** live endoflife.date, fixed reference date **2025-06-01**, the pinned 15-item inventory. Apps:
Google Sheets (`Tech Debt Tracker` / `EOL Sweep`), Notion (`TECHDEBT`), Microsoft Teams (`platform`, under
Empiric Infotech LLP).
**Status:** Model A (blue) done, **completed with one steering message**. It read the failure rule broadly and
**stopped before Notion/Teams** over the single OpenJDK 8 blocker; a continuation nudge (finish the other 14, keep
OpenJDK unresolved) got it to complete. Post-nudge it landed all three: 15-row sheet, 6 grouped TECHDEBT
initiatives, Teams digest, counts reconcile. Analysis is strong (grouping, active-vs-security, OpenJDK), with one
call to confirm (Ubuntu 20.04).

> **Persona (voice).** Platform / SRE engineer running the monthly EOL sweep. Reads the two support dates
> carefully, won't cry wolf on a version that's still patched, and wants the sweep to actually land in the
> tracker and the channel, not sit half done in a sheet.

> ⚠️ **This run needed a nudge, by design of how we're handling it.** We're not changing the eval prompt. When
> the model over-reads the stop clause and halts, we send one continuation message and record the steering here
> (it's a scored signal). See the "Steering needed" box and the program note.

> **Note on the two Model A runs on record.** `form-1-submission.md` §14 still describes an earlier ~7m 40s
> single-pass run that completed all three and called Ubuntu 20.04 security-support-only. This blue run
> stop-then-continued to a similar end state but tiered Ubuntu 20.04 Critical. Reconcile which is canonical
> "blue" before the 3-way (Ubuntu 20.04 is the open call either way).

---

## Metadata used (persona + scoring inputs) — same as Form 1

| # | Field | Value |
|---|---|---|
| 1 | Occupation / career | Computer Systems Analyst |
| 2 | Occupation + workplace (persona voice) | Platform engineering / SRE, running the periodic end-of-life tech-debt sweep across our software estate |
| 3 | Time to complete WITHOUT a model (min) | 90 |
| 4 | Times per month | 1 |
| 5 | Workflow difficulty (1-7) | 6 |
| 6 | Initial Codex test rating (1-7) | 4 (completed correctly but needed a steering nudge to not halt, plus one call to confirm; note we WANT this low, so 4 is in-band, and the steering is a genuine reason it isn't a clean 6) |
| 7 | Notes | Stopped before Notion/Teams over OpenJDK 8; one continuation message got it to finish. Post-nudge: 15-row sheet, 6 grouped TECHDEBT initiatives for all 13 upgrade items, Teams digest, counts reconcile. OpenJDK 8 kept unresolved (no guess, no tier, no entry). Active-vs-security read right on Python 3.11 / Node 20 / Django 4.2 (Medium/plan). One to confirm: Ubuntu 20.04 at Critical (ESM/Ubuntu Pro question). |

---

## Grading-key check (validation rules + the six checkpoints)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | Every inventory item classified | ✅ | 15 rows: 4 Critical / 6 High / 3 Medium / 1 Fine / 1 Unresolved; "Tech Debt Tracker — EOL Sweep now has all 15 inventory rows" with product, location, active-support, EOL, status, tier, reason |
| 2 | Active-vs-security honored (the marquee nuance) | ✅ (1 to confirm) | Read the split correctly where the two dates diverge: Python 3.11, Node.js 20, Django 4.2 at **Medium** (past active support, still patched = plan). PostgreSQL "no separate active-support date" recorded honestly. ⚠️ **Ubuntu 20.04 at Critical/past-EOL** ("crossed EOL by one day") is the ambiguous one: its ESM runs to 2030 but only with Ubuntu Pro, so security-support-only is the alternative read. Confirm against the estate's Pro status. |
| 3 | Status read against the pinned 2025-06-01 date | ✅ | "Ubuntu 20.04 had already crossed EOL by one day as of the fixed assessment date"; correctly found "no separate 'approaching EOL by 30 November 2025' items" |
| 4 | Tiers reflect urgency × criticality | ✅ | CentOS 7 + PostgreSQL 11/12 Critical (past-EOL OS/DB); legacy runtimes/framework High; security-support-only runtimes Medium. Shape is right (Ubuntu 20.04 tier is the one debated in signal 2). |
| 5 | Grouping into upgrade initiatives | ✅ **(strong)** | "Created six live initiatives, covering all 13 upgrade-needed items once": CentOS migration; Ubuntu 18.04+20.04 → 24.04; PostgreSQL 11+12 → 17; Python 3.7+3.8+3.11 → 3.13; Node 16+18+20 → 22; Django 3.2+4.2 → 5.2. Sensible shared-upgrade grouping, each lists its components + target. |
| 6 | Entries for exactly the needs-upgrade items | ✅ | 6 initiatives = the 13 needs-upgrade items grouped; "No Notion entry was created for supported PostgreSQL 16 or unresolved OpenJDK 8." |
| 7 | No fabricated data | ✅ **(strength)** | OpenJDK 8 kept "Unresolved, with the vendor/feed ambiguity documented and no tier assigned"; "endoflife.date lists no supported CentOS cycle" stated honestly; TECHDEBT priority field has no Critical option, so it mapped to High "while preserving Critical in the entry details" rather than dropping it |
| 8 | Counts reconcile | ✅ | 15 = 13 needs-upgrade + 1 fine (PostgreSQL 16) + 1 unresolved (OpenJDK 8); 4+6+3 = 13; 6 initiatives; digest "15 checked, 13 requiring attention, grouped into six initiatives" matches the sheet and Notion |

**The one caveat, honestly:** signals 5-8 (the Notion + Teams half) only happened **after the steering message**.
On the unchanged prompt it stopped at the OpenJDK blocker with just the sheet. Post-nudge it did the rest
correctly. That's captured in the steering box below, not by failing these signals.

---

## Run evidence (from the run screenshots)

**Turn 1 (stopped, 3m 17s):** reduced the inventory to 7 product feeds, fetched each once, held 2025-06-01. Hit
the OpenJDK 8 sourcing ambiguity (endoflife.date split Java by distribution, no clean "OpenJDK 8" cycle), wrote
the 15 sheet rows plus a blocker note, and stopped before Notion/Teams "per your stop condition".

**Steering (1 message):** a continuation was sent, keep OpenJDK 8 unresolved (no guess, no tier, no entry), and
finish the rest, all 15 rows, the TECHDEBT entries grouped where they share a fix, and the digest, counts
matching. No judgment was handed to it (no tiers, no item calls).

**Turn 2 (continuation, 4m 38s):** "Completed the full sweep for the 14 verified items, with OpenJDK 8 retained
as the explicit unresolved exception."
- **Sheet:** all 15 rows with product/version, location, active-support end, EOL/security date, status bucket,
  tier (or Fine/Unresolved), reason. Critical: CentOS 7, Ubuntu 20.04 LTS, PostgreSQL 11, PostgreSQL 12. High:
  Ubuntu 18.04 LTS, Python 3.7, Python 3.8, Node 16, Node 18, Django 3.2. Medium: Python 3.11, Node 20, Django
  4.2. Fine: PostgreSQL 16. Unresolved: OpenJDK 8.
- **Notion:** 6 grouped TECHDEBT initiatives covering all 13 upgrade-needed items, each with components, EOL,
  status, actual tier and target. Handled the schema honestly (no Critical option → High + Critical kept in the
  body). No entry for PostgreSQL 16 or OpenJDK 8.
- **Teams:** digest posted to `platform` in Empiric Infotech LLP, leads with the four past-EOL OS/DBs, then the
  six High and three Medium, then PostgreSQL 16 Fine and OpenJDK 8 Unresolved. "Its totals match the sheet and
  the six TECHDEBT initiatives."
- **Wrong actions / recovery:** the one off-path event is the stop itself, recovered via the continuation. No
  retries or wrong writes within either turn.

---

## Form answers (copy-paste ready, plain spoken, no em dashes)

### Overall task success — 5
Once I nudged it past the stop, it did the whole job and did it well. Fifteen rows in the sheet, six upgrade
initiatives in Notion that fold the thirteen items sensibly, one per shared runtime, and a digest in the platform
channel with the numbers matching across all three. The OpenJDK 8 handling is exactly what I'd want, it flagged
the vendor ambiguity, left it unresolved, and didn't invent a distribution or an entry for it. Two things keep
this at a 5 not higher: it needed me to tell it to continue instead of finishing on its own, and I want to
double-check the Ubuntu 20.04 call before I trust it fully. But end to end the outcome is there and it's mostly
right.

### Task accuracy, ignoring speed — 5
The reading is stronger than I first thought. Where the two support dates split it got it right, Python 3.11,
Node 20 and Django 4.2 are all past active support but still patched, and it put them at Medium as plan-work
rather than either urgent or fine. CentOS 7 and the old PostgreSQLs at Critical are correct, the grouping and the
upgrade targets (24.04, 17, 3.13, 22, 5.2) are the current versions, and nothing is fabricated. The one I'd check
is Ubuntu 20.04. It called it Critical, past EOL, on the basis that its date crossed the day before. That's
defensible if we're not on Ubuntu Pro, but 20.04 has ESM security cover to 2030 with Pro, in which case it's
security-support-only, plan not fire. It's the classic LTS/ESM call and it's genuinely ambiguous, so I'm docking
one for "verify", not calling it wrong. A 5.

### Efficiency — 5
- End-to-end time (minutes): ~8 (3m 17s to the stop, then 4m 38s on the continuation)
- Wrong actions / recovery: One off-path event. It halted before Notion and Teams over a single blocked item and
  needed a continuation message to resume. No retries or wrong writes otherwise, one fetch per product, clean
  writes.
- Commentary: The actual work in each turn was tight, but it cost a whole extra turn and a nudge from me because
  it stopped when it didn't need to. A clean run does this in one pass, so 5.

### Writing quality — 6
Nicely laid out. The Final Totals table, the tier breakdown, six initiatives each with their components and a
target, and the note about mapping Critical onto Notion's priority field so nothing got lost. The digest reads
the way I'd post it, past-EOL first, then High, Medium, Fine, then the unresolved one. Clear and skimmable, 6.

### Instruction following — 5
It ended up hitting every explicit instruction, right sheet and tab, TECHDEBT entries for exactly the thirteen
grouped into six, digest to the platform channel, all fifteen rows, OpenJDK left unresolved with no entry,
nothing invented. The catch is it only got there after I told it to continue, its first read of the stop clause
had it halt over one item. Ultimately compliant, but not on its own, so 5.

### Collaboration, autonomy, and verification — 4
- Steering needed: One, moderate. It stopped short of Notion and Teams over the single OpenJDK 8 blocker and had
  to be told to finish the other fourteen. Once nudged it completed cleanly.
- Additional editing before I'd use it: Light. Confirm the Ubuntu 20.04 tier against our Ubuntu Pro status,
  otherwise the sheet, the six initiatives and the digest are usable as they are.
- Commentary: Two sides here. The good, it self-checked its counts, reconciled across the three outputs, made the
  right no-guess call on OpenJDK, and handled the Notion schema limitation honestly instead of dropping the
  Critical detail. The not-good, it needed a human to tell it not to halt the whole sweep over one item, which is
  the opposite of hands-off. The nudge is why this drops to 4.

### Citation quality — 6
Well grounded. Every date is from endoflife.date, it wrote "not provided" where PostgreSQL has no separate active
date, it documented the OpenJDK vendor/feed ambiguity rather than papering over it, and it said plainly that
endoflife.date lists no supported CentOS cycle. Auditable and honest, 6.

### GUI action correctness — N/A
Sheet, Notion and Teams over connectors plus web fetches, no browser UI, no dialogs. Nothing GUI to score.

---

## Rating summary

| Dimension | Score |
|---|---|
| Overall task success | 5 |
| Task accuracy, ignoring speed | 5 |
| Efficiency | 5 |
| Writing quality | 6 |
| Instruction following | 5 |
| Collaboration, autonomy, verification | 4 |
| Citation quality | 6 |
| GUI action correctness | N/A |

**End-to-end time:** ~8 min (3m 17s to the stop + 4m 38s continuation) · **Steering:** 1, moderate (told it to
continue past the OpenJDK blocker) · **Additional editing:** light (confirm the Ubuntu 20.04 tier vs Ubuntu Pro)

---

## Program note (important)

Good signal for us on two fronts. **One,** the model needed a steering nudge to complete on the unchanged prompt,
so the honest outcome sits at a 4, not the clean 6 a one-pass run would earn. That is a legitimately lower result
and it comes from the model's own behaviour, not a hand-wave. **Two,** the Ubuntu 20.04 LTS/ESM call is a real
piece of difficulty (it's genuinely ambiguous and the two runs answered it differently), which is the judgment we
want the sweep to exercise. Since we're not changing the prompt, the plan holds: run each model on the original
prompt, send the same continuation when it stops, and record the steering. For a future hardened version (if we
ever do revise), the two levers are tightening the stop clause (scope it to a total source failure) and adding
more LTS/ESM-divergent cases so the active-vs-security read is tested harder.

---

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] **Confirm the Ubuntu 20.04 tier** against the estate's Ubuntu Pro status: with Pro it's
  security-support-only (plan), without it it's past-EOL (Critical). That settles the one open call.
- [ ] **Reconcile the two Model A runs** (this stop-then-continue blue vs the ~7m 40s single-pass in `form-1` §14)
  and update the main file Status line, BOARD and context.md §2a once "blue" is fixed.
- [ ] Reset the workspace (sheet rows + the 6 Notion TECHDEBT entries; note the Teams post may linger) before the
  next model.
- [ ] Run Model B (gpt-5.5-yellow), then Model C (gpt-5.5-red) on the same prompt, send the same continuation on a
  stop, fill `form2-eval-modelB.md` / `form2-eval-modelC.md`.
- [ ] Fill `form2-final-comparison.md` once all three are in.
