# WF-048 — Form 2 (OpenAI Eval Feedback) — Model B responses — ROUND 2 (four-model set)

**Workflow:** WF-048 Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date, no-seed)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 2 — the four-model set (A/B/C/D) on the same pinned inventory + reference date. Round 1 (the v1 3-model
blue/yellow/red round) is the root `../form2-eval-modelA/B/C.md`.
**This file:** Model B only — **gpt-5.5-purple, Extra High intelligence** (confirmed on the run: "5.5 Purple Extra High")
**Session ID:** `[paste this run's session ID]` (turn 1 3m stopped + turn 2 2m 9s continuation, ~5m 9s total)
**Run dataset:** live endoflife.date, fixed reference date **2025-06-01**, the pinned 15-item inventory. Apps:
Google Sheets (`Tech Debt Tracker` / `EOL Sweep`), Notion (`TECHDEBT`), Microsoft Teams (`platform`, under the
Development team).
**Status:** Model B done, **completed with one steering message** — same clean-sweep judgment and stop-and-nudge as
Model A. Turn 1 it **stopped over OpenJDK 8** before Notion/Teams; a continuation got it to finish. Post-nudge:
same buckets (4 Critical / 6 High / 3 Medium / 1 Fine / 1 Unresolved), but **7 grouped initiatives, not 6** (it kept
the two Ubuntu estates separate by risk/rollout), plus cleaner execution (removed its own stop note, native Notion
Critical, a dual-count digest). Honest Form 2: mostly 5s with autonomy 4 (the nudge), matching A.

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
| 7 | Notes | Turn 1 stopped before Notion/Teams over OpenJDK 8 (generic openjdk.json/java.json 404, site now splits Java by distribution); one continuation got it to finish. Post-nudge: 15-row sheet, **7 grouped TECHDEBT initiatives** (Python/Node/PostgreSQL/Django families grouped; the two Ubuntu estates kept separate by risk/rollout), Teams digest, counts reconcile. Buckets: 4 Critical / 6 High / 3 Medium / 1 Fine / 1 Unresolved. Removed its own turn-1 "sweep stopped" row; used the real Notion Critical value; dual-count digest (13 items + 7 initiatives). One to confirm: Ubuntu 20.04 at Critical (ESM/Pro). |

---

## Grading-key check (validation rules + the checkpoints)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | Every inventory item classified | ✅ | 15 rows: "4 Critical, 6 High, 3 Medium, 1 fine, and OpenJDK 8 unresolved" |
| 2 | Active-vs-security honored (the marquee nuance) | ✅ (1 to confirm) | 3 Medium = security-support-only (Python 3.11, Node 20, Django 4.2 = "three related medium components"); past-EOL not softened. ⚠️ Ubuntu 20.04 at Critical is the ESM/Pro call (same as A) |
| 3 | Status read against the pinned 2025-06-01 date | ✅ | "treating 1 June 2025 as the audit date exactly as requested"; buckets computed against it |
| 4 | Tiers reflect urgency × criticality | ✅ | 4 Critical = past-EOL OS/DB (incl. Ubuntu 20.04 fleet); 6 High; 3 Medium = security-support-only |
| 5 | Grouping into upgrade initiatives | ✅ (variation) | **7 initiatives** for the 13 items: Python/Node/PostgreSQL/Django families grouped on shared targets; **the two Ubuntu estates kept separate** ("fleet servers and legacy build servers require distinct rollout work and have different risk tiers"). A defensible variation on blue/A's 6 (which grouped Ubuntu 18.04+20.04 → 24.04) |
| 6 | Entries for exactly the needs-upgrade items | ✅ | 7 initiatives cover all 13 upgrade items; "exclude those two" (PostgreSQL 16 fine, OpenJDK 8 unresolved) |
| 7 | No fabricated data | ✅ **(strength)** | OpenJDK 8 unresolved: "using one without knowing the installed distribution would invent the result"; "I won't invent a Java lifecycle date" |
| 8 | Counts reconcile | ✅ | 15 = 13 + 1 fine + 1 unresolved; 4+6+3 = 13; 7 initiatives; digest reports both the 13-item count and the 7-initiative count so they can't be confused |

**Clean sweep on judgment**, same buckets as blue/A. **The grouping differs (7 vs 6):** B kept the two Ubuntu
estates as separate initiatives by risk/rollout, where blue/A folded them into one Ubuntu 24.04 migration. Both are
defensible, and the build file already flags grouping granularity as an open answer-key call. **Same caveat as A:**
the Notion + Teams half happened only **after the steering message** (turn 1 stopped at the OpenJDK blocker with
just the sheet).

---

## Run evidence (from the run screenshots)

**Turn 1 (stopped, 3m):** metadata-first sheet approach; fetched each product feed once. Hit the OpenJDK 8 gap
("the literal openjdk.json endpoint... is not a current endoflife.date product. The site now tracks OpenJDK by
vendor/distribution"), wrote all 15 rows + a stop note, and "Stopped cleanly under your failure rule" before
Notion/Teams. Recorded 14/15 matched, 13 need attention, 1 fine.

**Steering (1 message):** the continuation, keep OpenJDK 8 unresolved, finish the rest with counts matching.

**Turn 2 (continuation, 2m 9s):** "I'll keep OpenJDK 8 unresolved and excluded from tiering and Notion... 13: 4
critical, 6 high, and 3 medium; PostgreSQL 16 is fine, and OpenJDK 8 is unresolved."
- **Sheet:** readback confirmed 15 rows; set OpenJDK's Tier to `unresolved`; **removed the obsolete "sweep stopped"
  row** so the tracker is just header + 15 rows; PostgreSQL 16 = fine, OpenJDK 8 = unresolved.
- **Notion:** handled the schema honestly (enhanced-Markdown resource unavailable → plain syntax; used only the
  DB's existing allowed values, incl. the real `Critical` value); 7 initiatives (3 Critical first, 4 High) covering
  all 13, grouping the families, keeping the Ubuntu estates separate; verified the component lists + properties.
- **Teams:** one top-level digest reporting both the 13-item inventory count and the 7-initiative count.
- **Wrong actions / recovery:** the one off-path event is the stop, recovered via the continuation. No retries or
  wrong writes within either turn; it cleaned up its own stop row.

---

## Form answers (copy-paste ready, plain spoken, no em dashes)

### Overall task success — 5
Same story as the other run: once I nudged it past the stop it did the whole sweep well. Fifteen rows in the sheet, seven upgrade initiatives in Notion covering the thirteen items, and a digest in the platform channel with the numbers matching across all three. The OpenJDK 8 call is right, it saw the generic feed 404s and the site now splits Java by distribution, so it left it unresolved rather than guessing. It also tidied up after itself, it removed the "sweep stopped" note from the first turn so the sheet is just the header plus the fifteen rows. The two things holding it at a 5 are the same: it stopped before Notion and Teams over OpenJDK 8 and needed me to say carry on, and the Ubuntu 20.04 tier is the one call I want to confirm. End to end it landed and it is mostly right. A 5.

### Task accuracy, ignoring speed — 5
The reading is right. The security-support-only three (Python 3.11, Node 20, Django 4.2) are at Medium as plan-work, the past-EOL OS and databases are Critical, the buckets are 4 critical, 6 high, 3 medium, 1 fine, 1 unresolved, and nothing is fabricated. It grouped the Python, Node, PostgreSQL and Django families onto their shared targets, and it made a defensible call to keep the two Ubuntu estates separate rather than folding them, because 20.04 is most of the fleet at Critical and 18.04 is legacy build servers at High, different rollout and risk. That is where its seven initiatives differ from the six the other run used, and both are reasonable. The one to verify is the same Ubuntu 20.04 LTS/ESM call. A 5.

### Efficiency — 5
- End-to-end time (minutes): ~5 (3m to the stop, then 2m 9s on the continuation)
- Wrong actions / recovery: One off-path event, the stop. It halted before Notion and Teams over the single OpenJDK 8 blocker and needed a continuation to resume. Otherwise clean, one fetch per product, a metadata-first sheet write with a readback, and it removed its own obsolete stop row on the second turn.
- Commentary: Tight work in each turn, but it still cost an extra turn and a nudge because it stopped when the site was up and fourteen items were fine. A clean run does this in one pass. A 5.

### Writing quality — 6
Clear and careful. The digest reports the thirteen-item inventory count and the seven-initiative count as two separate levels so they cannot be confused, the initiatives each list their components and target, and the OpenJDK exception is stated plainly. It also called out honestly that a Notion formatting resource was unavailable and it used the plain syntax instead. Skimmable and complete. A 6.

### Instruction following — 5
It hit every explicit instruction in the end: the right sheet and tab, TECHDEBT entries for exactly the thirteen items grouped, the digest in the platform channel, all fifteen rows, OpenJDK left unresolved with no entry, nothing invented, and it stuck to the database's existing allowed values rather than inventing new ones. The catch is the same, it only got there after the nudge, its first read of the stop clause halted the whole sweep over one item. Compliant, not on its own. A 5.

### Collaboration, autonomy, and verification — 4
- Steering needed: One, moderate. It stopped short of Notion and Teams over the single OpenJDK 8 blocker and had to be told to finish. Once nudged it completed cleanly.
- Additional editing before I would use it: Light. Confirm the Ubuntu 20.04 tier, otherwise the sheet, the seven initiatives and the digest are usable.
- Commentary: The verification is good, it read the sheet back to confirm the fifteen rows, checked the TECHDEBT schema and its allowed values before writing, removed its own stale stop note, and reconciled the two counting levels across the three outputs. But it needed a human to tell it not to halt over one unresolved item, which is the hands-off failure this workflow keeps hitting. The nudge is why this is a 4.

### Citation quality — 6
Well grounded. Every date is from endoflife.date with one fetch per product, and it was explicit about the OpenJDK gap, the generic openjdk.json and java.json endpoints 404 and the site now tracks distribution-specific Java with different dates, so it would not pick one blind. Auditable and honest. A 6.

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

**End-to-end time:** ~5 min (3m to the stop + 2m 9s continuation) · **Steering:** 1, moderate (told it to continue
past the OpenJDK blocker) · **Additional editing:** light (confirm the Ubuntu 20.04 tier vs Ubuntu Pro)

---

## Program note

Model B is the same profile as A: clean-sweep judgment, completed after one steering nudge because it stopped over
OpenJDK 8. So two models now stop-and-nudge on this workflow (like blue and yellow's first run in round 1), which
is the known **run-to-run variance** on the ambiguous stop clause. The one substantive judgment difference from A
is the grouping: **B used 7 initiatives (Ubuntu estates separate) vs A's 6 (Ubuntu grouped)** — both defensible,
and this is exactly the "6 vs more" open answer-key call the build file flags, so the round is usefully surfacing
that the grouping granularity isn't pinned. On the program: the judgment is still a clean sweep = too easy, and the
honest 4-ish outcome is the stop, not the calls. Levers if a reviewer wants it durably lower: **tighten the stop
clause** (scope it to a total source failure so the model doesn't halt over one item) and **add more
LTS/ESM-divergent cycles** + a larger inventory. Watch C/D for stop-vs-autonomous and 6-vs-7 grouping.

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] **Pin the grouping convention** (6 with Ubuntu grouped, or 7 with Ubuntu split by risk) so A/B/C/D are graded
  the same way, and **confirm the Ubuntu 20.04 tier** vs Ubuntu Pro.
- [ ] Reset the workspace (sheet rows + the Notion TECHDEBT entries; the Teams post may linger) before Model C.
- [ ] Run Model C (cyan/XH) and Model D (purple/High) on the same prompt, send the same continuation on a stop,
  fill `form2-eval-modelC/D.md`.
- [ ] Fill `round-2/form2-final-comparison.md` once C and D are in (A and B are ready).
