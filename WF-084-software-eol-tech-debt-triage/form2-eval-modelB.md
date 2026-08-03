# WF-048 — Form 2 (OpenAI Eval Feedback) — Model B responses

**Workflow:** WF-048 Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date, no-seed)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (yellow, clean rerun on an emptied workspace; red still to come)
**This file:** Model B only — **gpt-5.5-yellow, Extra High intelligence**
**Session ID:** `[paste this run's session ID]` (completed autonomously in 3m 54s; a follow-up nudge added a 47s
reconcile turn that wasn't needed)
**Run dataset:** live endoflife.date, fixed reference date **2025-06-01**, the pinned 15-item inventory, on a
**freshly emptied workspace** (sheet cleared, Notion `TECHDEBT` emptied). Apps: Google Sheets (`Tech Debt
Tracker` / `EOL Sweep`), Notion (`TECHDEBT`), Microsoft Teams (`Platform`).
**Status:** Model B (yellow) done, **completed on its own, no steering needed.** On the clean workspace it did
NOT stop, it mapped OpenJDK 8 to the Red Hat feed and flagged it, reasoned the Ubuntu 20.04 ESM call explicitly,
and landed all three deliverables in one pass. This is a clean autonomous run, which for our program is the
**too-easy** outcome. It also flips the earlier finding: yellow stopped in its first (contaminated) run and
completed unattended here, so the stop behaviour is run-to-run variance, not fixed.

> **Persona (voice).** Platform / SRE engineer running the monthly EOL sweep. Short, plain, checks the two
> support dates and where each thing runs.

> **Why this supersedes the earlier yellow run.** The first yellow run stopped at OpenJDK, needed a nudge, and
> sat on blue's un-cleared Notion records. We emptied the workspace and reran. This clean run is the one to
> score and compare. Keeping the earlier observations only as the non-determinism note below.

> **The continuation was sent but not needed.** Yellow had already completed the full sweep at 3m 54s (OpenJDK
> mapped to Red Hat + flagged). The nudge (sent out of process habit) only made it reclassify OpenJDK from
> Red-Hat-mapped to "unresolved" and repost a superseding digest. Steering-needed here is **0**. Going forward,
> only send the continuation if a model actually stops.

---

## Metadata used (persona + scoring inputs) — same as Form 1

| # | Field | Value |
|---|---|---|
| 1 | Occupation / career | Computer Systems Analyst |
| 2 | Occupation + workplace (persona voice) | Platform engineering / SRE, running the periodic end-of-life tech-debt sweep across our software estate |
| 3 | Time to complete WITHOUT a model (min) | 90 |
| 4 | Times per month | 1 |
| 5 | Workflow difficulty (1-7) | 6 |
| 6 | Initial Codex test rating (1-7) | 6 (clean, unattended, correct, documented the tricky calls; note we WANT this low, so 6 = too easy and needs harder inputs) |
| 7 | Notes | Clean run on an emptied workspace, no stop, no steering needed. Completed all three in one pass: 15 rows, 10 grouped initiatives, Platform digest, counts reconcile. Reasoned the Ubuntu 20.04 public-eol-vs-paid-ESM call explicitly, mapped OpenJDK 8 to Red Hat and flagged it (then the unneeded nudge made it unresolved), recorded PostgreSQL active-support as "not published" rather than inventing. |

---

## Grading-key check (validation rules + the six checkpoints)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | Every inventory item classified | ✅ | 15 rows verified in `EOL Sweep!A1:K16`, no blanks: 4 Critical / 6 High / 3 Medium / 2 fine (Turn 1) then 1 fine + 1 unresolved after the nudge reclassified OpenJDK |
| 2 | Active-vs-security honored (the marquee nuance) | ✅ **(handled deliberately)** | Explicit: "the public eol field is separate from paid extended support; I'm using the requested active-support (support) and security/EOL (eol) dates, not the optional extended-support date. That makes Ubuntu 20.04 just past public EOL." It engaged the ESM trap on purpose and documented the call. 10 past EOL / 3 security-support-only read correctly. |
| 3 | Status read against 2025-06-01 | ✅ | "none fall in the six-month 'approaching' window"; 0 approaching |
| 4 | Tiers reflect urgency × criticality | ✅ | 4 Critical / 6 High / 3 Medium; OS/DB critical, legacy runtimes high, security-support-only runtimes medium |
| 5 | Grouping into upgrade initiatives | ✅ (less consolidated) | 10 initiatives, "consolidating Python 3.7/3.8 and Node.js 16/18/20 into shared upgrades while retaining each component's individual EOL date and status". Grouped the same-language multi-version families; kept the cross-version pairs (Ubuntu 18.04/20.04, PostgreSQL 11/12) separate. Defensible, just less aggregated than blue's 6. |
| 6 | Entries for exactly the needs-upgrade items | ✅ | 10 initiatives for the 13 needs-upgrade items; no entry for the fine items or OpenJDK 8 |
| 7 | No fabricated data | ✅ **(strength)** | OpenJDK 8 mapped to the real Red Hat feed with "vendor/build must be confirmed"; PostgreSQL cells say "Not published by endoflife.date"; "rather than containing invented dates" |
| 8 | Counts reconcile | ✅ | 15 = 13 upgrade + 1 fine + 1 unresolved (post-nudge); the digest totals match the sheet and the initiatives |

**On OpenJDK 8:** yellow's own call was to map it to Red Hat OpenJDK (single support phase to 30 Nov 2026,
still supported on the assessment date) and flag that the vendor must be confirmed. That's a valid, documented
reading, not a fabrication. The nudge then reclassified it to "unresolved". Both are defensible; the nudge just
imposed the more conservative one.

---

## Run evidence (from the run screenshots)

**Turn 1 (3m 54s, completed autonomously, no stop):**
- Plan: fetch each feed once, bucket against 2025-06-01, then write all three.
- Ubuntu 20.04: reasoned the public-eol vs paid-ESM distinction and called it past public EOL, documented.
- OpenJDK 8: "endoflife.date has no generic OpenJDK cycle, so I'm documenting the explicit Red Hat OpenJDK 8
  mapping in the sheet; that feed has a single support phase ending 30 November 2026 and does not publish a
  separate active-support date." Did **not** stop.
- Sheet: verified `EOL Sweep!A1:K16`, header + 15 rows. Notion: created 10 initiatives in tier order (Python
  3.7/3.8 and Node 16/18/20 shared). Teams: "Platform Teams digest: posted successfully."
- Final totals: 10 past EOL / 3 security-support-only / 0 approaching / 2 fine; tiers 4 critical, 6 high, 3
  medium. Self-verified the cell block before writing Notion.

**Turn 2 (47s, from the unneeded nudge):** "revise the existing live artifacts rather than add OpenJDK work: mark
its row unresolved with no dates or tier, confirm the remaining 14 rows and 10 grouped TECHDEBT initiatives still
reconcile, then post a corrected Teams digest that supersedes the earlier count." Result: OpenJDK 8 → unresolved,
10 initiatives unchanged, superseding Platform digest. No real new work, it was already done.

- **Wrong actions / recovery:** none. No stop, no retries, no wrong-target writes. The only extra motion (Turn 2)
  was our nudge, not its own misstep.

---

## Form answers (clean, short, plain)

### Overall task success — 6
This is the run I'd want. It did the whole sweep on its own, no stopping, no hand-holding: 15 rows, ten upgrade
initiatives in Notion, a digest in the Platform channel, counts matching. And it handled the two awkward bits
head-on, it reasoned out loud that Ubuntu 20.04 is past public EOL if you don't count paid ESM, and it mapped
OpenJDK 8 to the Red Hat feed with a flag to confirm the vendor rather than either guessing blindly or bailing.
The only small thing is I'd have consolidated the Ubuntu and Postgres pairs like the other run did. A strong 6,
which for us means the inputs need to be harder.

### Task accuracy, ignoring speed — 6
The reading is right and, better, it's documented. Ten past EOL, three security-support-only, two fine, the
buckets line up, and the Ubuntu 20.04 call I was worried about on the other runs is here made deliberately with
the reason written down, so even if someone disagrees they can see the basis. OpenJDK mapped to a real Red Hat
cycle and flagged, Postgres active-support marked "not published" instead of invented. The grouping is a touch
looser than I'd do (ten instead of folding the Ubuntu and Postgres pairs), but it kept each component's own EOL
and status, so nothing's lost. 6.

### Efficiency — 6
- End-to-end time (minutes): ~4 (done at 3m 54s in one pass; a 47s reconcile followed from a nudge that wasn't needed)
- Wrong actions / recovery: None. No stop, no retries, one fetch per product, straight through to all three writes.
- Commentary: Clean single pass. It fetched, classified, verified the cell block, then wrote Notion and the
  digest in order. The extra 47 seconds was us nudging it after it had already finished, so I'm not counting that
  against it. 6.

### Writing quality — 6
Clear and it shows its working, which I value on this one. The Ubuntu ESM reasoning, the Red Hat OpenJDK note, the
"not published by endoflife.date" cells, all spelled out so the sheet defends itself. The digest states the
totals explicitly. 6.

### Instruction following — 6
Hit everything: right sheet and tab, ten Notion initiatives for the thirteen upgrade items, digest to the
Platform channel this time (the earlier run's ml-platform mixup is gone), all 15 rows, nothing invented, and it
didn't over-reach on the schema. OpenJDK it mapped-and-flagged rather than leaving blank, which is a defensible
read of "don't invent dates" since Red Hat's cycle is real. 6.

### Collaboration, autonomy, and verification — 6
- Steering needed: None. It completed the full sweep unattended. The continuation I sent afterward wasn't needed,
  the work was already done, it just reclassified OpenJDK.
- Additional editing before I'd use it: Light. Maybe fold the Ubuntu and Postgres pairs into single initiatives,
  otherwise the sheet, the ten initiatives and the digest are usable as they are.
- Commentary: This is the standout. It ran the whole thing on its own, self-verified the sheet cell block before
  writing downstream, documented its assumptions, and made a real judgment call on OpenJDK instead of stopping.
  Exactly the hands-off behaviour I want. 6.

### Citation quality — 6
Strong grounding. Every date from endoflife.date, the Ubuntu ESM field distinction called out, OpenJDK pinned to
the Red Hat feed, Postgres active-support honestly marked as not published. Auditable and used to make the calls. 6.

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

**End-to-end time:** ~4 min (complete at 3m 54s; a 47s reconcile from an unneeded nudge) · **Steering:** 0 needed
· **Additional editing:** light (optionally fold the Ubuntu and Postgres pairs into single initiatives)

---

## Program note (important)

Two takeaways. **One, this clean run is the too-easy outcome for us:** yellow did the whole sweep unattended and
correct, so the honest score is a 6, not the 1-3 we want. **Two, the stop is not deterministic.** Yellow stopped
on its first (contaminated) run and completed on its own here, same model, same prompt. So the "needed steering"
we saw on blue and on the first yellow is partly run-to-run luck, not a fixed model trait. That has a fairness
implication for the 3-way: blue's scored run happened to stop, this yellow didn't, and the difference may be
variance rather than quality. Worth a clean rerun of blue before finalising, or at least flagging it in the
comparison. On the judgment itself, the models agree closely (buckets, Ubuntu 20.04 as past-public-EOL, OpenJDK
handled honestly), so the sweep is leaning too easy and wants harder inputs (more LTS/ESM-divergent cases, a
bigger inventory, maybe a second genuinely ambiguous item).

---

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] **Consider a clean rerun of blue** on the emptied workspace, so all three are scored on the same footing
  (blue's current run stopped and needed steering; this yellow didn't, and that may be variance).
- [ ] For **red**: empty the workspace again first, and **only send the continuation if red actually stops** (if
  it completes on its own like this yellow did, no nudge, that's the stronger result).
- [ ] Settle the Ubuntu 20.04 (public-EOL vs ESM) and grouping-consolidation (6 vs 10 initiatives) calls for the
  answer key so all three are scored on one rule.
- [ ] Run Model C (gpt-5.5-red), fill `form2-eval-modelC.md`.
- [ ] Fill `form2-final-comparison.md` once red is in.
