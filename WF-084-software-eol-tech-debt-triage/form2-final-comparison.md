# WF-048 — Form 2 Final Comparison (Model A vs B vs C)

**Workflow:** WF-048 Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date, no-seed)

**Models run (all Extra High):**
- **Model A** = **gpt-5.5-blue**
- **Model B** = **gpt-5.5-yellow**
- **Model C** = **gpt-5.5-red**

**Same-input check:** confirmed on the judgment. All three ran the **same 15-item inventory** against the **same
fixed reference date (2025-06-01)** off live endoflife.date, so the buckets, tiers and grouping are directly
comparable. Two things differed in the *run conditions*, both flagged below and neither changing the judgment:
(1) **completion mode**, blue's scored run stopped and needed one steering message, while yellow (clean rerun) and
red completed on their own, and we now know that stop is **run-to-run variance** (yellow itself stopped on its
first run and completed on its second); (2) **workspace**, blue and the clean yellow/red runs all wrote their own
records, but blue's first yellow run (discarded) had sat on blue's un-cleared Notion, which is why yellow was
rerun clean.

| | Model A (blue) | Model B (yellow, clean) | Model C (red) |
|---|---|---|---|
| Completion | **stopped → 1 steering → completed** | completed on its own (nudge sent but not needed) | **completed on its own, no nudge** |
| Runtime | ~8 min (3m 17s + 4m 38s) | ~4 min (3m 54s; +47s unneeded reconcile) | ~6 min (5m 50s single pass) |
| Steering needed | 1 (moderate) | 0 | 0 |
| Inventory classified | 15/15 | 15/15 | 15/15 |
| Active-vs-security split | 10 past EOL / 3 sec-support | same (ESM reasoning spelled out) | same |
| Ubuntu 20.04 | Critical (past public EOL) | Critical (explicitly public-eol not ESM) | Critical (past public EOL) |
| OpenJDK 8 | unresolved (via nudge) | Red Hat → unresolved (via nudge) | **Red Hat, fine (own call)** |
| Grouping (13 items) | **6 tight initiatives** | 10 looser initiatives | **6 tight initiatives** |
| Recovered from feed errors | n/a | n/a | ✅ retried transient failures |
| Fabrication | none | none | none |
| Counts reconcile | ✅ | ✅ | ✅ |
| Ratings | 5,5,5,6,5,4,6,N/A | 6,6,6,6,6,6,6,N/A | 6,6,6,6,6,6,6,N/A |

Ratings order = Overall · Accuracy · Efficiency · Writing · Instruction · Autonomy · Citation · GUI.

---

## Form answers (copy-paste ready, plain spoken, no em dashes)

### Rank all three responses from best to worst
Model C (red) > Model B (yellow) > Model A (blue)

### Which model is best overall?
**Model C, gpt-5.5-red** — narrowly over yellow, and blue's third place is down to run luck, not weaker judgment.

### Why is the top model best, and what separates the other models?
First the thing that matters most: on the actual EOL judgment, all three are basically right and basically the
same. Every one of them classified the 15 items, read the active-support versus security-support split correctly
(ten past EOL, three still getting security patches), called Ubuntu 20.04 past public EOL, didn't invent a date,
and reconciled the counts across the sheet, Notion and the digest. That is the whole hard part of this task and
none of them got it wrong. Which, same story as the other sweeps, is why WF-048 is sitting in the too-easy zone
for us once the workspace is clean.

So the separation is about how cleanly each one got there.

Red is first. It did the entire sweep off the original prompt with no help from me, and it was the most robust of
the three, when three of the feeds came back empty or errored it retried just those before deciding the stop rule
even applied, which is exactly the right way to read that rule. Its grouping was the tightest, thirteen items
folded into six proper initiatives, and it resolved the OpenJDK 8 ambiguity with actual reasoning (mapped it to
the Red Hat build because the estate is CentOS-based, and said so) instead of either guessing blind or leaving it
hanging. Nothing about it needed me.

Yellow is a very close second. Its clean rerun also finished on its own and also nailed the judgment, and it was
the one that spelled out the Ubuntu 20.04 ESM reasoning most explicitly, public eol versus paid extended support,
which I liked. What keeps it just behind red is the grouping, it left thirteen items in ten initiatives where the
Ubuntu and Postgres pairs could have folded together like red and blue did. Small, and defensible, but red's is
the tidier deliverable. Worth noting the continuation I sent yellow was not needed, it had already finished, so
its steering count is really zero.

Blue is third, and I want to be clear this is about luck, not thinking. Blue's run happened to stop at the
OpenJDK blocker and needed one nudge to finish the Notion and Teams half, which cost it on autonomy and
instruction following. But we know that stop is a coin-flip, yellow did the exact same stop on its first run and
then completed cleanly on its rerun. When blue did finish it landed the same judgment as the others and grouped
into six initiatives like red, so on the work itself it is right there with them. If blue were rerun clean it
would very likely be another six across the board. So read blue's lower scores as one unlucky run, not a weaker
model.

---

## Time comparison (exact, no mismatch across files)

| Model | Runtime (logs) | End-to-end box (min, rounded) |
|---|---|---|
| A (blue) | 3m 17s to the stop + 4m 38s continuation | 8 |
| B (yellow) | 3m 54s (complete) + 47s unneeded reconcile | 4 |
| C (red) | 5m 50s (single pass) | 6 |

Yellow's clean run was the fastest and it was a genuine one-pass finish. Red took longer but that was the retry
cost on the flaky feeds, time well spent. Blue's total is the biggest because of the stop-and-continue round
trip, which is the variance, not slow work.

---

## Judgment across models (the hard calls)

| Call | Blue | Yellow | Red |
|---|---|---|---|
| All 15 classified, no blanks | ✅ | ✅ | ✅ |
| Active vs security split (10 / 3) | ✅ | ✅ (ESM reasoning explicit) | ✅ |
| Ubuntu 20.04 past public EOL / Critical | ✅ | ✅ | ✅ |
| Ubuntu 18.04 tier | High | (High, clean run) | High |
| OpenJDK 8 | unresolved (nudged) | Red Hat then unresolved (nudged) | Red Hat, fine (own call) |
| Grouping of the 13 | 6 tight | 10 looser | 6 tight |
| No fabricated dates | ✅ | ✅ | ✅ |
| Counts reconcile across 3 apps | ✅ | ✅ | ✅ |
| Completed unattended | ❌ needed 1 nudge | ✅ | ✅ |
| Recovered from feed failures | n/a | n/a | ✅ retried |

All three agree on every judgment call I can grade. The real differences are completion mode (blue needed a
nudge, variance), grouping tightness (red and blue 6, yellow 10), and how OpenJDK was resolved. On OpenJDK the
two models left to their own devices (red, and yellow before the nudge) both chose to map it to the Red Hat build
and flag it, so "map to Red Hat" is arguably the natural model answer and "unresolved" was our imposition via the
continuation message.

---

## Open follow-up

- [ ] Paste the three session IDs into the per-model files.
- [ ] **Lock the answer key on the three genuinely-open calls**, so any future run is graded on one rule:
  - **OpenJDK 8:** map to the Red Hat build and mark fine (what red and yellow chose on their own), or leave
    unresolved (what the nudge imposed). Lean toward crediting either as long as it's documented and not invented.
  - **Grouping:** 6 consolidated initiatives (fold the Ubuntu / Postgres / Django pairs, red + blue) vs 10
    (yellow). Both defensible, pick the house convention.
  - **Ubuntu 20.04:** past-public-EOL / Critical (all three) vs security-support-only via paid ESM. All three
    agreed on past-public-EOL, so that's the de facto key, but state it.
- [ ] **Refine the continuation-message protocol:** only send it if a model actually stops, and if it stops on
  OpenJDK, the "leave it unresolved" line fits; do not send it to a run that already finished (it made yellow
  un-map a reasonable OpenJDK call).
- [ ] **Reconcile the docs:** the main file Status line, BOARD and context.md §2a still describe the older
  ~7m 40s single-pass Model A run. Update them to this blue/yellow/red round (blue stopped+steered; yellow and
  red clean autonomous 6s; verdict too-easy, harden).
- [ ] **Pin the Teams channel:** it resolved differently per run (blue `platform` in Empiric Infotech LLP, yellow
  `Platform`, red `platform` in Development). Name the exact team+channel so it's stable.
- [ ] **Program takeaway (the real one):** clean runs from all three models land the judgment correctly, so
  **WF-048 is too easy** and the honest outcome is a 6, not the 1-3 we want. The only thing that ever tripped a
  model was the stop clause, which red showed the correct way through, so that is a prompt-wording soft spot, not
  task difficulty. **Harden before submission:** more LTS/ESM-divergent cycles, a bigger inventory, a second
  genuinely ambiguous item, and if the prompt can be touched, tighten the stop clause. Then rerun.
