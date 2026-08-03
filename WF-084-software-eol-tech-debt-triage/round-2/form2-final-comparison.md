# WF-048 — Form 2 Final Comparison (Model A vs B vs C vs D) — ROUND 2 (four-model set)

**Workflow:** WF-048 Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date, no-seed)

**Models run (the round-2 four-model set):**
- **Model A** = gpt-5.5-cyan, **High** (confirmed "5.5 Cyan High"; ~5m 22s across two turns)
- **Model B** = gpt-5.5-purple, **Extra High** (confirmed "5.5 Purple Extra High"; ~5m 9s across two turns)
- **Model C** = gpt-5.5-cyan, **Extra High** (per the round convention; 12m 26s, one turn)
- **Model D** = gpt-5.5-purple, **High** (confirmed "5.5 Purple High"; ~4m 6s across two turns)

**Same-input check:** confirmed. All four ran the same pinned 15-item inventory + reference date (2025-06-01), and
**the workspace was reset between runs** (B, C and D each found `EOL Sweep` header-only before writing), so this is
a clean four-way comparison.

| | Model A (cyan/High) | Model B (purple/XH) | Model C (cyan/XH) | Model D (purple/High) |
|---|---|---|---|---|
| Runtime | ~5m 22s (2 turns) | ~5m 9s (2 turns) | **12m 26s (1 turn)** | ~4m 6s (2 turns) |
| **Stopped over OpenJDK 8?** | Yes (nudged) | Yes (nudged) | **No (autonomous)** | Yes (nudged) |
| Steering needed | 1 | 1 | **0** | 1 |
| Buckets (4C / 6H / M / 1 Fine) | 3 Medium + 1 Unresolved | 3 Medium + 1 Unresolved | **4 Medium** (no unresolved) | 3 Medium + 1 Unresolved |
| **OpenJDK 8 handling** | unresolved | unresolved | **mapped → Oracle JDK 8, Medium, + flag** | unresolved |
| **Grouping** | 6 (Ubuntu grouped) | **7 (Ubuntu split)** | **7 (Ubuntu split)** | 6 (Ubuntu grouped) |
| Active-vs-security read (Py3.11 / Node20 / Django4.2 = Medium) | ✅ | ✅ | ✅ | ✅ |
| No fabricated data | ✅ | ✅ | ✅ (OpenJDK substitution flagged) | ✅ |
| Counts reconcile | ✅ | ✅ | ✅ | ✅ |
| Ratings | 5,5,5,6,5,4,6,N/A | 5,5,5,6,5,4,6,N/A | 5,5,4,6,5,6,6,N/A | 5,5,5,6,5,4,6,N/A |

Ratings order = Overall · Accuracy · Efficiency · Writing · Instruction · Autonomy · Citation · GUI.

---

## Form answers (copy-paste ready, plain spoken, no em dashes)

### Rank all four responses from best to worst
**C > D > B > A**, but the bottom three are a near-tie. C is first because it did the whole sweep autonomously with
no nudge, which is the thing this workflow keeps tripping models on. A, B and D all did the same clean sweep but
each stopped over OpenJDK 8 and needed the same continuation, so they separate only on small run details.

### Which model is best overall?
**Model C, gpt-5.5-cyan Extra High.** It is the only one of the four that finished the sweep without a steering
nudge. It paid for it with the slowest runtime and a more assumptive OpenJDK call, but on the thing that actually
distinguishes a good run here, not halting the whole sweep over one item, it is the only one that got it right.

### Why is the top model best, and what separates the other models?
On the core reading these four are a tie. All of them treated the two support dates separately and got the
active-vs-security nuance right, the three still-patched runtimes (Python 3.11, Node 20, Django 4.2) at Medium as
plan-work, the past-EOL operating systems and databases Critical, PostgreSQL 16 fine, and none of them invented a
date. The buckets and the tiers match. So the judgment is a clean sweep for everyone, which is the too-easy signal
again.

What separates them is the stop and two open calls. The stop is the big one: A, B and D each halted before Notion
and Teams over the single OpenJDK 8 blocker and needed me to tell them to finish the other fourteen, while C
carried on and completed the whole thing on its own. That is exactly the ambiguous-stop-clause difficulty this
sweep is built around, and only C cleared it, so C is first. It is not a free win, C was the slowest by a wide
margin at twelve and a half minutes and it made the more assumptive OpenJDK call, but the autonomous finish is
worth more here than a couple of saved minutes.

Below C, the three stop-and-nudge runs are near-identical. They all completed correctly after the same nudge with
the same scores, so they order only on runtime and the two open calls: D was quickest at about four minutes, then
B, then A. On the open calls, A and D left OpenJDK 8 unresolved and grouped the two Ubuntu estates into one
initiative (six total); B split the Ubuntu estates by risk (seven); C both mapped OpenJDK 8 to the Oracle JDK 8
lifecycle with a verify flag and split Ubuntu (seven). None of those is wrong, they are the two genuinely open
answer-key calls, but they need pinning so the four are graded on the same key.

### The stop is run-to-run variance, confirmed
Across both rounds, blue, yellow's first run, and now A, B and D stopped over OpenJDK 8; red and now C did not. So
the stop is not a stable model property, it is variance on how a given run reads the ambiguous stop clause. That is
why we handle it by sending the one continuation and scoring the steering, and it is why the honest outcome for
this workflow is stop-dependent rather than judgment-dependent.

---

## Time comparison (exact, no mismatch across files)

| Model | Runtime (logs) | End-to-end box (min, rounded) |
|---|---|---|
| A (cyan/High) | ~5m 22s (1m 45s stop + 3m 37s) | 5 |
| B (purple/XH) | ~5m 9s (3m + 2m 9s) | 5 |
| C (cyan/XH) | 12m 26s (one pass) | 12 |
| D (purple/High) | ~4m 6s (1m 23s stop + 2m 43s) | 4 |

C is the outlier, slowest by far but one-pass and autonomous. A, B and D are all in the four-to-five-minute range
across two turns, the extra turn being the stop-and-continue.

---

## Judgment across models (the hard calls)

| Call | A | B | C | D |
|---|---|---|---|---|
| Active-vs-security split (3 runtimes = Medium/plan) | ✅ | ✅ | ✅ | ✅ |
| Past-EOL OS/DB = Critical | ✅ | ✅ | ✅ | ✅ |
| PostgreSQL 16 = fine (no over-flag) | ✅ | ✅ | ✅ | ✅ |
| No fabricated dates | ✅ | ✅ | ✅ (OpenJDK substitution flagged) | ✅ |
| Counts reconcile (15/13/6 or 15/14/7) | ✅ | ✅ | ✅ | ✅ |
| **OpenJDK 8** | unresolved | unresolved | Oracle-Medium + flag | unresolved |
| **Grouping (Ubuntu)** | 6 (grouped) | 7 (split) | 7 (split) | 6 (grouped) |
| **Completed without a nudge** | ❌ | ❌ | ✅ | ❌ |
| **Ubuntu 20.04 tier (open, all Critical)** | verify | verify | verify | verify |

The core buckets are a four-way tie. The three rows that vary are the two open answer-key calls (OpenJDK, grouping)
and the stop.

---

## Open follow-up

- [ ] Paste the four session IDs; confirm C's build tag (cyan/XH per the round convention).
- [ ] **Pin the two open answer-key calls so the four grade on one key:**
  - **OpenJDK 8** — recommend **unresolved (refuse to guess the distribution)** as the primary expected handling
    (A/B/D, and the build file's "handled honestly" lean); a transparent **map-to-a-named-distribution + verify
    flag** (C) is acceptable but not required. Note C picked Oracle JDK 8 → Medium; the documented alternative is
    Red Hat OpenJDK 8 → fine, so the tier swings with the distribution, which is exactly why "unresolved" is the
    safer primary.
  - **Grouping** — recommend **6 with the two Ubuntu estates grouped** onto the shared 24.04 target as the primary
    (A/D, matches the build file's established count); **7 with Ubuntu split by risk** (B/C) acceptable, since the
    prompt does allow splitting on distinct rollout/risk.
- [ ] **Confirm the Ubuntu 20.04 tier** vs the estate's Ubuntu Pro status (with Pro = security-support-only/plan;
  without = past-EOL/Critical). All four called it Critical.
- [ ] **Program takeaway.** Judgment is a clean four-way sweep = **too easy**, and the honest low outcome is
  **stop-dependent** (3 of 4 stopped and were nudged; the one that didn't landed autonomy 6). To make the outcome
  durably low **regardless of the stop**, harden per the main file: **tighten the stop clause** (scope it to a
  total source failure so a model doesn't halt over one item), **add more LTS/ESM-divergent cycles** so the
  active-vs-security read is tested harder, and **enlarge the inventory**. Then rerun the four-model set on a reset
  workspace.
