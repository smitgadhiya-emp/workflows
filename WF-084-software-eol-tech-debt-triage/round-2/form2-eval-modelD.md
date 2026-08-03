# WF-048 — Form 2 (OpenAI Eval Feedback) — Model D responses — ROUND 2 (four-model set)

**Workflow:** WF-048 Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date, no-seed)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 2 — the four-model set (A/B/C/D) on the same pinned inventory + reference date. Round 1 (the v1 3-model
blue/yellow/red round) is the root `../form2-eval-modelA/B/C.md`.
**This file:** Model D only — **gpt-5.5-purple, High intelligence** (confirmed on the run: "5.5 Purple High")
**Session ID:** `[paste this run's session ID]` (turn 1 1m 23s stopped + turn 2 2m 43s continuation, ~4m 6s total)
**Run dataset:** live endoflife.date, fixed reference date **2025-06-01**, the pinned 15-item inventory. Apps:
Google Sheets (`Tech Debt Tracker` / `EOL Sweep`), Notion (`TECHDEBT`), Microsoft Teams (`platform`, under the
Development team).
**Status:** Model D done, **completed with one steering message — the A/blue profile exactly.** Stopped over
OpenJDK 8 (took the safe no-guess handling, kept it **unresolved** — opposite of C), then finished on the nudge:
15-row sheet, **6 grouped initiatives** (Ubuntu grouped, like A), Teams digest, counts reconcile 15/13/6. Buckets
4 Critical / 6 High / 3 Medium / 1 Fine / 1 Unresolved. Fastest of the stop-and-nudge runs (~4m 6s). Honest Form 2:
mostly 5s with autonomy 4 (the nudge), matching A.

> **Persona (voice).** Platform / SRE engineer running the monthly EOL sweep. Reads the two support dates
> carefully, won't cry wolf on a version that's still patched, and wants the sweep to actually land in the tracker
> and the channel, not sit half done in a sheet.

> ⚠️ **This run needed a nudge, by design of how we handle it.** We're not changing the eval prompt. When the model
> over-reads the stop clause and halts over the single OpenJDK 8 blocker, we send one continuation and record it.

---

## Metadata used (persona + scoring inputs) — same as Form 1

| # | Field | Value |
|---|---|---|
| 1 | Occupation / career | Computer Systems Analyst |
| 2 | Occupation + workplace (persona voice) | Platform engineering / SRE, running the periodic end-of-life tech-debt sweep across our software estate |
| 3 | Time to complete WITHOUT a model (min) | 90 |
| 4 | Times per month | 1 |
| 5 | Workflow difficulty (1-7) | 6 |
| 6 | Initial Codex test rating (1-7) | 4 (completed correctly but needed a steering nudge to not halt over OpenJDK 8, plus the one Ubuntu 20.04 call to confirm; we WANT this low, so 4 is in-band and the steering is the genuine reason it isn't a clean 6) |
| 7 | Notes | Turn 1 stopped before Notion/Teams over OpenJDK 8, explicitly refusing to substitute a vendor/distribution ("I won't infer them from a different JDK distribution"); one continuation got it to finish. Post-nudge: 15-row sheet, **6 grouped TECHDEBT initiatives** (Ubuntu grouped; Medium components folded into their Python/Node/Django initiatives), Teams digest, counts reconcile. Buckets: 4 Critical / 6 High / 3 Medium / 1 Fine / 1 Unresolved (OpenJDK 8 unresolved, no tier/entry). PostgreSQL active-support gap written as "Not provided by endoflife.date". One to confirm: Ubuntu 20.04 at Critical. |

---

## Grading-key check (validation rules + the checkpoints)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | Every inventory item classified | ✅ | 15 rows: "4 Critical, 6 High, 3 Medium, 1 fine, and 1 unresolved" |
| 2 | Active-vs-security honored (the marquee nuance) | ✅ (1 to confirm) | 3 Medium = security-support-only (Python 3.11, Node 20, Django 4.2), folded into their shared initiatives; past-EOL not softened. ⚠️ Ubuntu 20.04 Critical (ESM/Pro) is the one to verify |
| 3 | Status read against the pinned 2025-06-01 date | ✅ | explicit status rule "after EOL → past end-of-life; otherwise after active-support end → security support only; otherwise EOL on or before 30 November 2025 → approaching; otherwise fully supported" |
| 4 | Tiers reflect urgency × criticality | ✅ | 4 Critical = past-EOL OS/DB; 6 High; 3 Medium = security-support-only |
| 5 | Grouping into upgrade initiatives | ✅ | 6 initiatives (3 Critical incl. Ubuntu grouped, 3 High) covering the 13 items; matches blue/A |
| 6 | Entries for exactly the needs-upgrade items | ✅ | "No entries were created for PostgreSQL 16 or OpenJDK 8"; 6 initiatives cover the 13 |
| 7 | No fabricated data | ✅ **(strength)** | refused to guess an OpenJDK distribution; PostgreSQL active-support "Not provided by endoflife.date... no dates were inferred" |
| 8 | Counts reconcile | ✅ | 15 = 13 + 1 fine + 1 unresolved; digest "same 15/13/6 counts" across sheet + Notion + Teams |

**Clean sweep on judgment**, same buckets and grouping (6) as blue/A, and the safe OpenJDK handling (unresolved).
Same caveat as A/B: the Notion + Teams half happened only **after the steering message** (turn 1 stopped at the
OpenJDK blocker with just the sheet note).

---

## Run evidence (from the run screenshots)

**Turn 1 (stopped, 1m 23s):** explicit status rule set; fetched the 7 feeds. Six returned; the OpenJDK 8 lookup
404'd. "Because 'OpenJDK 8' alone does not identify which distribution's support policy applies, choosing one would
invent the source mapping." Wrote a stop/progress note (6/7 feeds retrieved), and "Stopped cleanly under your
failure rule" before Notion/Teams. Refused to substitute a vendor's dates.

**Steering (1 message):** the continuation, keep OpenJDK 8 unresolved, finish the rest with counts matching.

**Turn 2 (continuation, 2m 43s):** "I'll keep OpenJDK 8 as the single unresolved row, complete the other 14... 10
past end-of-life, 3 security-support-only, 1 still fully supported, and 1 unresolved... 4 critical, 6 high, 3
medium, 1 fine, and 1 unresolved; the 13 actionable inventory rows consolidate into six product-family upgrade
initiatives."
- **Sheet:** all 15 rows with lifecycle fields, status, tier/fine/unresolved, target, grouping, source URL;
  PostgreSQL active-support = "Not provided by endoflife.date".
- **Notion:** 6 initiatives (3 Critical first, then 3 High), the 3 Medium security-only components folded into
  their Python/Node/Django shared initiatives; read back. No entry for PostgreSQL 16 or OpenJDK 8.
- **Teams:** digest posted + read back with the same 15/13/6 counts.
- **Wrong actions / recovery:** the one off-path event is the stop, recovered via the continuation. No retries or
  wrong writes within either turn; the fastest of the stop-and-nudge runs.

---

## Form answers (copy-paste ready, plain spoken, no em dashes)

### Overall task success — 5
Same shape as the other stop-and-nudge runs, and the fastest of them. Once I told it to carry on it did the whole sweep: fifteen rows, six upgrade initiatives folding the thirteen items, and a digest in the platform channel, all reconciling on 15/13/6. The OpenJDK 8 call is the safe one, it saw the generic feed 404s and the site now splits Java by distribution and refused to substitute a vendor's dates, leaving it unresolved with no tier and no entry. It also handled PostgreSQL's missing active-support date honestly, writing "Not provided by endoflife.date" rather than copying the EOL date across. Two things keep it at a 5, the same two: it stopped before Notion and Teams over that one OpenJDK item and needed the nudge, and Ubuntu 20.04 is the tier I want to confirm. A 5.

### Task accuracy, ignoring speed — 5
The reading is right. The three security-support-only runtimes are at Medium, the past-EOL OS and databases Critical, PostgreSQL 16 fine, OpenJDK 8 unresolved, and nothing is fabricated, every date off endoflife.date and the PostgreSQL active-support gap called out rather than filled in. It grouped the Python, Node, PostgreSQL and Django families and folded the two Ubuntu estates into one initiative, so six initiatives like the first run rather than seven. The one to verify is the same Ubuntu 20.04 LTS/ESM call. A 5.

### Efficiency — 5
- End-to-end time (minutes): ~4 (1m 23s to the stop, then 2m 43s on the continuation)
- Wrong actions / recovery: One off-path event, the stop. It halted before Notion and Teams over the OpenJDK 8 blocker and needed the continuation. Otherwise clean, one fetch per product, a re-grounded sheet write with a readback.
- Commentary: The quickest of the stop-and-nudge runs, about four minutes across the two turns, and tight within each. But it still cost the extra turn because it stopped when it did not need to. A clean run does this in one pass. A 5.

### Writing quality — 6
Clear and complete. It states the buckets and the 15/13/6 counts, keeps the per-component detail in the TECHDEBT page bodies because the database schema is compact, and is honest about the PostgreSQL active-support gap. The digest reads the way I would post it. A 6.

### Instruction following — 5
It hit every explicit instruction in the end: the right sheet and tab, TECHDEBT entries for exactly the thirteen grouped into six, the digest in the platform channel, all fifteen rows, OpenJDK unresolved with no entry, nothing invented, and it stayed within the database's writable fields. The catch is the same, it only got there after the nudge, its first read of the stop clause halted the whole sweep over one item. Compliant, not on its own. A 5.

### Collaboration, autonomy, and verification — 4
- Steering needed: One, moderate. It stopped short of Notion and Teams over the single OpenJDK 8 blocker and had to be told to finish. Once nudged it completed cleanly.
- Additional editing before I would use it: Light. Confirm the Ubuntu 20.04 tier, otherwise the three outputs are usable.
- Commentary: The good part is real, it made the safe no-guess call on OpenJDK and PostgreSQL's missing date, re-grounded the sheet layout and the Notion and Teams destinations before writing, read the sheet and the six entries back, and reconciled the counts across all three. The not-good part is the stop, it needed a human to tell it not to halt over one unresolved item. The nudge is why this is a 4.

### Citation quality — 6
Well grounded. Every date is off endoflife.date, one fetch per product, and it was explicit twice over about not inventing, it refused to pick a JDK distribution for OpenJDK 8, and it wrote "Not provided by endoflife.date" for PostgreSQL's active-support date instead of copying the EOL date. Auditable and honest. A 6.

### GUI action correctness — N/A
Sheet, Notion and Teams over connectors plus web fetches, no browser UI. Nothing GUI to score.

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

**End-to-end time:** ~4 min (1m 23s to the stop + 2m 43s continuation) · **Steering:** 1, moderate (told it to
continue past the OpenJDK blocker) · **Additional editing:** light (confirm the Ubuntu 20.04 tier vs Ubuntu Pro)

---

## Program note

Model D is the A/blue profile: clean-sweep judgment, the safe OpenJDK handling (unresolved, refused to guess), 6
initiatives (Ubuntu grouped), completed after one steering nudge. So three of the four models stopped over OpenJDK
8 (A, B, D), and only C did not, which confirms the stop is **run-to-run variance** on the ambiguous stop clause,
not a stable property. On judgment WF-048 is still a clean sweep = too easy, and the honest low outcome depends on
whether a run happens to stop. The round cleanly surfaced two open answer-key calls to pin: the **OpenJDK 8
handling** (A/B/D = unresolved, the safe majority; C = mapped-to-Oracle-Medium + flag) and the **grouping** (A/D =
6 with Ubuntu grouped; B/C = 7 with Ubuntu split). See the final comparison for the recommendation. Durable-outcome
levers if a reviewer wants it below 4 regardless of the stop: tighten the stop clause + add more LTS/ESM-divergent
cycles + a bigger inventory.

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] Round 2 is complete (A, B, C, D all in). See `round-2/form2-final-comparison.md`.
- [ ] **Pin the two answer-key calls** (OpenJDK handling; 6-vs-7 grouping) and **confirm the Ubuntu 20.04 tier**.
- [ ] For a durable sub-4 outcome, harden per the main file (tighten the stop clause + more LTS/ESM-divergent cases).
