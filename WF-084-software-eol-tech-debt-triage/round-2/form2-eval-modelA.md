# WF-048 — Form 2 (OpenAI Eval Feedback) — Model A responses — ROUND 2 (four-model set)

**Workflow:** WF-048 Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date, no-seed)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 2 — the four-model set (A/B/C/D) on the same pinned inventory + reference date. Round 1 (the v1 3-model
blue/yellow/red round) is the root `../form2-eval-modelA/B/C.md`.
**This file:** Model A only — **gpt-5.5-cyan, High intelligence** (confirmed on the run: "5.5 Cyan High")
**Session ID:** `[paste this run's session ID]` (turn 1 1m 45s stopped + turn 2 3m 37s continuation, ~5m 22s total)
**Run dataset:** live endoflife.date, fixed reference date **2025-06-01**, the pinned 15-item inventory. Apps:
Google Sheets (`Tech Debt Tracker` / `EOL Sweep`), Notion (`TECHDEBT`), Microsoft Teams (`platform`, under the
Development team).
**Status:** Model A done, **completed with one steering message** — a near-exact replay of the v1 blue run. Turn 1
it **stopped over the OpenJDK 8 blocker** before Notion/Teams; a continuation nudge got it to finish. Post-nudge:
clean-sweep judgment (15-row sheet, 6 grouped TECHDEBT initiatives, Teams digest, counts reconcile), same buckets
as blue (4 Critical / 6 High / 3 Medium / 1 Fine / 1 Unresolved), OpenJDK 8 kept unresolved. The stop is the known
**run-to-run variance**. Honest Form 2: mostly 5s with autonomy 4 (the nudge), matching blue.

> **Persona (voice).** Platform / SRE engineer running the monthly EOL sweep. Reads the two support dates
> carefully, won't cry wolf on a version that's still patched, and wants the sweep to actually land in the tracker
> and the channel, not sit half done in a sheet.

> ⚠️ **This run needed a nudge, by design of how we handle it.** We're not changing the eval prompt. When the model
> over-reads the stop clause and halts over the single OpenJDK 8 blocker, we send one continuation message and
> record the steering here (it's a scored signal).

---

## Metadata used (persona + scoring inputs) — same as Form 1

| # | Field | Value |
|---|---|---|
| 1 | Occupation / career | Computer Systems Analyst |
| 2 | Occupation + workplace (persona voice) | Platform engineering / SRE, running the periodic end-of-life tech-debt sweep across our software estate |
| 3 | Time to complete WITHOUT a model (min) | 90 |
| 4 | Times per month | 1 |
| 5 | Workflow difficulty (1-7) | 6 |
| 6 | Initial Codex test rating (1-7) | 4 (completed correctly but needed a steering nudge to not halt over OpenJDK 8, plus the one Ubuntu 20.04 call to confirm; note we WANT this low, so 4 is in-band and the steering is the genuine reason it isn't a clean 6) |
| 7 | Notes | Turn 1 stopped before Notion/Teams over OpenJDK 8 (endoflife.date only lists OpenJDK from cycle 9, so it refused to guess a distribution); one continuation got it to finish. Post-nudge: 15-row sheet, 6 grouped TECHDEBT initiatives for all 13 upgrade items, Teams digest, counts reconcile. Buckets: 4 Critical (CentOS 7, PostgreSQL 11, PostgreSQL 12, Ubuntu 20.04) / 6 High / 3 Medium (Python 3.11, Node 20, Django 4.2 = security-support-only) / 1 Fine (PostgreSQL 16) / 1 Unresolved (OpenJDK 8). One to confirm: Ubuntu 20.04 at Critical (ESM/Ubuntu Pro question). |

---

## Grading-key check (validation rules + the checkpoints)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | Every inventory item classified | ✅ | 15 rows: "4 critical, 6 high, 3 medium, 1 fine, and 1 unresolved"; "15 rows verified" |
| 2 | Active-vs-security honored (the marquee nuance) | ✅ (1 to confirm) | "3 security-support-only items" (Python 3.11, Node 20, Django 4.2 = Medium/plan), past-EOL not softened. ⚠️ Ubuntu 20.04 at Critical is the ambiguous ESM/Pro call (same as blue) |
| 3 | Status read against the pinned 2025-06-01 date | ✅ | "calculate all lifecycle buckets against 1 June 2025"; "10 past-EOL items, 3 security-support-only, 1 fully supported, 1 unresolved" |
| 4 | Tiers reflect urgency × criticality | ✅ | 4 Critical = past-EOL OS/DB; 6 High = legacy runtimes/framework; 3 Medium = security-support-only. Same shape as blue |
| 5 | Grouping into upgrade initiatives | ✅ | "the 13 upgrade items consolidate into 6 shared initiatives"; "6 grouped initiatives covering 13 upgrade items" |
| 6 | Entries for exactly the needs-upgrade items | ✅ | 6 initiatives = the 13 needs-upgrade items grouped; no entry for PostgreSQL 16 (fine) or OpenJDK 8 (unresolved) |
| 7 | No fabricated data | ✅ **(strength)** | OpenJDK 8 kept unresolved: "inventing or substituting a vendor lifecycle would violate your rule"; "No dates were invented" |
| 8 | Counts reconcile | ✅ | 15 = 13 + 1 fine + 1 unresolved; 4+6+3 = 13; 6 initiatives; digest "same counts" across sheet + Notion + Teams |

**Clean sweep on judgment**, identical to blue's round-1 answer key. **The one caveat (same as blue):** signals
5-8 (the Notion + Teams half) happened only **after the steering message**. On the unchanged prompt turn 1 stopped
at the OpenJDK blocker with just the sheet. That's captured in the steering box, not by failing these signals.

---

## Run evidence (from the run screenshots)

**Turn 1 (stopped, 1m 45s):** pulled the 7 product feeds once for the 15 rows, held 2025-06-01. Hit the OpenJDK 8
sourcing gap ("the legacy openjdk.json and java.json endpoints are unavailable, and the current OpenJDK-builds feed
starts at cycle 9"), recorded the blocker + 6/7 completed feeds in the sheet, and "Stopped cleanly as instructed"
before Notion/Teams. No dates invented.

**Steering (1 message):** a continuation, keep OpenJDK 8 unresolved (no guess, no tier, no entry), and finish the
rest, all 15 rows, the grouped TECHDEBT entries, the digest, counts matching. No judgment was handed to it (no
tiers, no item calls).

**Turn 2 (continuation, 3m 37s):** "I'll keep OpenJDK 8 unresolved, calculate all lifecycle buckets against 1 June
2025, and verify the row, initiative, and digest counts before sending."
- **Sheet:** 15 rows verified; buckets 10 past-EOL / 3 security-support-only / 1 fine / 1 unresolved, tiered 4
  Critical / 6 High / 3 Medium / 1 Fine / 1 Unresolved.
- **Notion:** 6 grouped TECHDEBT initiatives covering all 13 upgrade items.
- **Teams:** digest posted to `platform` in the Development team with the same counts.
- **Final:** "Matching totals: 4 critical, 6 high, 3 medium, 1 fine, and 1 unresolved. OpenJDK 8 remains unresolved
  with no tier or Notion entry."
- **Wrong actions / recovery:** the one off-path event is the stop itself, recovered via the continuation. No
  retries or wrong writes within either turn; each turn was tight and quick.

---

## Form answers (copy-paste ready, plain spoken, no em dashes)

### Overall task success — 5
Once I nudged it past the stop it did the whole sweep and did it right. Fifteen rows in the sheet, six upgrade initiatives in Notion folding the thirteen items sensibly one per shared runtime, and a digest in the platform channel with the numbers matching across all three. The OpenJDK 8 handling is exactly what I want: it saw endoflife.date only lists OpenJDK from cycle 9, refused to guess a distribution or invent a lifecycle, left it unresolved, and gave it no tier and no entry. The buckets are right too, ten past-EOL, three security-support-only, one fine, one unresolved. Two things keep it at a 5: it stopped before Notion and Teams over that one OpenJDK item and needed me to tell it to carry on, and I still want to confirm the Ubuntu 20.04 call. End to end the outcome is there and mostly right. A 5.

### Task accuracy, ignoring speed — 5
The reading is solid. Where the two support dates split it got it right: Python 3.11, Node 20 and Django 4.2 are past active support but still patched, so it put them at Medium as plan-work, not urgent and not fine. CentOS 7 and the old PostgreSQLs at Critical are correct, the grouping and the upgrade targets are the current versions, and nothing is fabricated. The one to check is Ubuntu 20.04, it called it Critical past-EOL on the date crossing, which holds if we are not on Ubuntu Pro but is security-support-only if we are (ESM to 2030). It is the classic LTS/ESM ambiguity, so I dock one for verify, not wrong. A 5.

### Efficiency — 5
- End-to-end time (minutes): ~5 (1m 45s to the stop, then 3m 37s on the continuation)
- Wrong actions / recovery: One off-path event, the stop. It halted before Notion and Teams over the single OpenJDK 8 blocker and needed a continuation to resume. No retries or wrong writes otherwise, one fetch per product, clean writes, and it was quick within each turn.
- Commentary: The work in each turn was tight and faster than a lot of runs, but it still cost an extra turn and a nudge because it stopped when it did not need to, the site was up and fourteen items were fine. A clean run does this in one pass. A 5.

### Writing quality — 6
Clean and skimmable. The final summary gives the bucket totals, the six initiatives covering the thirteen items, and the three live outputs, and the OpenJDK exception is called out plainly. The digest reads the way I would post it. A 6.

### Instruction following — 5
It hit every explicit instruction in the end: the right sheet and tab, TECHDEBT entries for exactly the thirteen grouped into six, the digest in the platform channel, all fifteen rows, OpenJDK left unresolved with no entry, nothing invented. The catch is it only got there after I told it to continue, its first read of the stop clause had it halt over one item when it should have finished the other fourteen. Compliant, but not on its own. A 5.

### Collaboration, autonomy, and verification — 4
- Steering needed: One, moderate. It stopped short of Notion and Teams over the single OpenJDK 8 blocker and had to be told to finish the rest. Once nudged it completed cleanly.
- Additional editing before I would use it: Light. Confirm the Ubuntu 20.04 tier against our Ubuntu Pro status, otherwise the sheet, the six initiatives and the digest are usable as they stand.
- Commentary: The good part is real, it made the right no-guess call on OpenJDK, verified its row, initiative and digest counts before sending, and reconciled across the three outputs. The not-good part is it needed a human to tell it not to halt the whole sweep over one unresolved item, which is the opposite of hands-off. The nudge is why this drops to 4.

### Citation quality — 6
Well grounded. Every date is from endoflife.date, one fetch per product, and it was straight about the OpenJDK gap, the legacy openjdk.json and java.json endpoints are gone and the current feed starts at cycle 9, so it left the item unresolved rather than inventing a date. Auditable and honest. A 6.

### GUI action correctness — N/A
Sheet, Notion and Teams over connectors plus the web fetches, no browser UI, no dialogs. Nothing GUI to score.

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

**End-to-end time:** ~5 min (1m 45s to the stop + 3m 37s continuation) · **Steering:** 1, moderate (told it to
continue past the OpenJDK blocker) · **Additional editing:** light (confirm the Ubuntu 20.04 tier vs Ubuntu Pro)

---

## Program note

Model A (cyan/High) is a near-exact replay of the v1 blue run: clean-sweep judgment (all eight signals, the same
buckets and the same 6 initiatives), completed after **one steering nudge** because it stopped over the single
OpenJDK 8 blocker. So the honest outcome sits at a 4-ish (in-band) purely because of the stop, and the judgment
itself is a clean sweep = **too easy once the workspace is clean = 6**, same read as round 1. The stop is the known
**run-to-run variance** (blue and yellow's first run stopped; red didn't), and we handle it by sending the one
continuation and recording the steering. The one real piece of judgment difficulty is still the Ubuntu 20.04
LTS/ESM call. If a reviewer wants the outcome pulled down durably (rather than relying on the stop), the levers are
in the main file: **tighten the ambiguous stop clause** (scope it to a total source failure) and **add more
LTS/ESM-divergent cycles** so the active-vs-security read is tested harder, plus a larger inventory. Watch across
B/C/D whether they stop-and-nudge (like this run) or complete autonomously (like red).

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] **Confirm the Ubuntu 20.04 tier** vs the estate's Ubuntu Pro status (with Pro = security-support-only/plan;
  without = past-EOL/Critical). That settles the one open call.
- [ ] Reset the workspace (sheet rows + the 6 Notion TECHDEBT entries; the Teams post may linger) before Model B.
- [ ] Run Model B (purple/XH), Model C (cyan/XH), Model D (purple/High) on the same prompt, send the same
  continuation on a stop, fill `form2-eval-modelB/C/D.md`.
- [ ] Fill `round-2/form2-final-comparison.md` once 2+ models are in.
