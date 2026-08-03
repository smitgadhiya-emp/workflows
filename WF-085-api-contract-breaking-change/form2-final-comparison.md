# WF-079 — Form 2 Final Comparison (Model A vs B vs C vs D)

**Workflow:** WF-079 API Contract Breaking-Change & Consumer-Impact Review (seeded `orders-platform` repo, **v2 hardened**)

**Models run (the four-model set; WF-079's first Form 2 round):**
- **Model A** = gpt-5.5-cyan, **High** (confirmed "5.5 Cyan High"; 6m 28s)
- **Model B** = gpt-5.5-purple, **Extra High** (confirmed "5.5 Purple Extra High"; 4m 14s)
- **Model C** = gpt-5.5-cyan, **Extra High** (confirmed "5.5 Cyan Extra High"; 10m 23s)
- **Model D** = gpt-5.5-purple, **High** (confirmed "5.5 Purple High"; 3m 33s)

**Same-input check:** confirmed on the judgment. All four reviewed the same `evolve-orders-api` change against the
same `orders-platform` seed. **Major run-condition confound: the workspace was NOT cleared, and PR #7 was closed
(from prior runs) for all four.** A/B/C adapted (comment reviews on the closed PR; C reopened the old issues); **D
stopped and delivered nothing live**, asking for the PR to be reopened. So the *judgment* compares cleanly (a
four-way near-tie), but the *delivery* comparison is muddied by the dirty workspace and should be re-run clean.

| | Model A (cyan/High) | Model B (purple/XH) | Model C (cyan/XH) | Model D (purple/High) |
|---|---|---|---|---|
| Runtime | 6m 28s | 4m 14s | 10m 23s | 3m 33s |
| Steering needed | 0 | 0 | 0 | **1 (stopped)** |
| **Classification signals (of ~12)** | ~11 | ~11 | ~11 | ~11 |
| Hard v2 four (fraud-check / data-warehouse held / freeze / partner window) | ✅✅✅✅ | ✅✅✅✅ | ✅✅✅✅ | ✅✅ + freeze/partner **not surfaced** (stopped) |
| coupon_code over-flag (the shared miss) | ❌ | ❌ | ❌ | ❌ |
| data-warehouse handling | held (implicit "6 confirmed") | held **explicitly** | **dedicated owner-confirmation issue** | held explicitly |
| **Delivered the 4 live outputs?** | ✅ all 4 | ✅ all 4 | ✅ all 4 (reopened old issues) | **❌ none (stopped)** |
| Workspace handling | fresh issues, fixed Notion row | fresh issues, fixed Notion row | **reopened + corrected old issues** | held all writes, asked to reopen |
| Ratings | 5,5,5,5,6,5,6,N/A | 5,5,6,6,6,5,6,N/A | 5,5,4,6,6,5,6,N/A | **3,5,5,6,4,4,6,N/A** |

Ratings order = Overall · Accuracy · Efficiency · Writing · Instruction · Autonomy · Citation · GUI.

---

## Form answers (copy-paste ready, plain spoken, no em dashes)

### Rank all four responses from best to worst
**B > C > A > D.** On judgment it is a four-way near-tie, all four got the same ~11 of 12 and aced the four hard v2
calls. The ranking is about the run: B delivered everything fastest and cleanest, C delivered but slow and heavy,
A delivered clean in the middle, and D did not deliver at all, it stopped and asked me to reopen the PR.

### Which model is best overall?
**Model B, gpt-5.5-purple at Extra High.** Same right judgment as the rest, delivered live in four minutes with the
clearest write-up and the cleanest handling of the two ambiguous cases.

### Why is the top model best, and what separates the other models?
The judgment does not separate them. All four read the diff and the callers correctly: required currency breaks
checkout, the dropped on_hold breaks the ops sender, the rename breaks billing and the forgotten external partner,
the deprecated legacy_status removal breaks analytics, and, the one this review is built to catch, the added
refunded value breaks fraud-check because it reads the response and switches on it with no default. All four held
data-warehouse for its owner instead of clearing or asserting it, left mobile-app alone, and all four made the same
single slip, tagging the v2 coupon_code removal as breaking when it is safe for callers still on v1. That is the
finding on its own: the four hard v2 traps were supposed to make a model miss two or three of them, and every one
of the four models missed none. On the judgment this build is no longer hard for this model line.

So the split is the run. B is first: it delivered all four live outputs in four minutes, laid the review out as a
clean per-change table, held data-warehouse explicitly, even caught that checkout forwards the response
generically too, and anchored the review to exact revisions so it could not drift. C is second and the most
thorough, it gave data-warehouse its own owner-confirmation issue and actively corrected the earlier review's real
misses, but it took ten minutes and it reopened the old closed issues, which is more state change than the task
asked for. A is third, a clean middle-of-the-road run that delivered everything in six and a half minutes, its only
softness a compact write-up and a slightly less explicit data-warehouse note. D is fourth, and it is a delivery
gap, not a judgment one: its analysis is as good as the others, but it found the PR closed, decided there was no
open target, and stopped without posting the review, the issues, the Notion row or the digest, asking me to reopen
the PR first. Its caution about not writing to a dead PR or reopening one unauthorized is fair, but the issues, the
Notion row and the digest do not need an open PR, and it held those too.

One honest caveat on the ranking: the delivery differences are heavily shaped by the workspace being dirty. PR #7
was already closed for all four runs, so A, B and C were working around a broken state (and C's reopening and the
Notion-row fixes are all clean-up of prior-run leftovers), and D stopped over it. On a clean board with an open PR,
D almost certainly delivers like the rest, and the four collapse back toward the judgment tie. This round should be
re-run clean before the delivery order is treated as real.

---

## Time comparison (exact, no mismatch across files)

| Model | Runtime (logs) | End-to-end box (min, rounded) |
|---|---|---|
| A (cyan/High) | 6m 28s | 6 |
| B (purple/XH) | 4m 14s | 4 |
| C (cyan/XH) | 10m 23s | 10 |
| D (purple/High) | 3m 33s | 4 |

B was the fastest complete run. D's 3m 33s is shorter still but incomplete, it stopped before the live writes. C
was the outlier at ten minutes, spent on the dual checkout-plus-browser caller audit and the reopening/correcting
of the old issue set. A sat in the middle and delivered cleanly. All four hit the same closed-PR + code-index-off
environment; how each handled it is most of the runtime spread.

---

## Judgment across models (the hard calls)

| Call | A | B | C | D |
|---|---|---|---|---|
| required `currency` breaking / optional `notes` safe | ✅ | ✅ | ✅ | ✅ |
| rename breaking + partner-webhook found | ✅ | ✅ | ✅ | ✅ |
| `legacy_status` removal breaking (analytics) | ✅ | ✅ | ✅ | ✅ |
| enum remove `on_hold` breaking (ops sender) | ✅ | ✅ | ✅ | ✅ |
| **v2 `coupon_code` safe for v1** | ❌ | ❌ | ❌ | ❌ |
| mobile-app NOT flagged | ✅ | ✅ | ✅ | ✅ |
| `debug` removal breaking-by-rule, zero-impact | ✅ | ✅ | ✅ | ✅ |
| **enum add `refunded` breaking for fraud-check** | ✅ | ✅ | ✅ | ✅ |
| **data-warehouse held for owner review** | ✅ | ✅ | ✅ | ✅ |
| **`/v1` freeze re-cut** | ✅ | ✅ | ✅ | ◐ read policy, not surfaced (stopped) |
| **partner-webhook deprecation window** | ✅ | ✅ | ✅ | ◐ not surfaced (stopped) |

The judgment is a near-tie. Every model made every classification call and all four aced the hard v2 four
(fraud-check, data-warehouse, and, where they got to the disposition, the freeze and the partner window). The one
universal miss is coupon_code. D's two blanks are because it stopped before the disposition, not because it got
them wrong.

---

## Open follow-up

- [ ] Paste the four session IDs into the per-model files.
- [ ] **Clear the workspace and re-run** (reset PR to open, empty `API-CHANGES`, close/settle leftover issues). The
  closed-PR state stopped D outright and forced A/B/C into leftover-reconciliation; a clean board is needed before
  the delivery ranking is treated as real.
- [ ] Decide the issue-handling policy for the re-run: open fresh (A/B/D-intended) vs reopen + correct the old set
  (C). Pin one so runs are graded the same way.
- [ ] **Program takeaway (the important one).** The four hard v2 signals were designed so a model would miss 2-3 of
  them, landing the outcome at 3-4. **All four models missed zero.** So the v2 hardening is no longer challenging
  this model line on judgment, and the only recurring rough edge is the coupon_code over-flag (cry-wolf, not a
  missed breaker). Before submission, **apply the v3 hardening from Part B**: a change that is breaking only for a
  caller on a specific older minor version, a second forgotten consumer in a vendored/generated path, or a narrowed
  `total` type (number → string) that breaks a caller doing arithmetic but not one that only displays it. Then
  re-run the four-model set on a cleared workspace. (Form 1's outcome field stays a 4 for the current submission;
  this note is about whether the build survives another reviewer bounce.)
