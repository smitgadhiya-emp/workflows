# WF-236 — Manual Setup (do these yourself, before anything runs)

Things Codex can't reliably bootstrap on its own (OAuth logins, a MongoDB target, file permissions,
Teams creation, and the two "unreadable/unparseable" traps). Do these first, then run the Codex seed
prompt, then confirm the workflow prompt matches what Codex reports, then run the workflow.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **Google Drive / Sheets**
- [ ] **MongoDB** (with a reachable target and write access to a `knowledge_base` database)
- [ ] **Microsoft Teams**
- [ ] **Chrome / browser control** — optional; the prompt says use the existing session "if it helps."

## 2. MongoDB — target + collections
- [ ] A reachable MongoDB the connector can write to. Create database **knowledge_base** and the two
      collections **chunks** and **routing_domains** (Codex seeds a little prior state into `chunks`).
- [ ] Confirm the connector can **query, upsert by `_id`, and delete** — the run-twice idempotency
      (leave-unchanged / replace-changed / no-duplicates) needs all three.

## 3. Google Drive — two folders
- [ ] Folder **Company Knowledge Base** exists (Codex fills the subfolder tree and 20 files).
- [ ] Folder **Knowledge Base Ops** exists (Codex puts the **KB Index Tracker** there).
- [ ] Decide where **KB Query Set** lives and make sure the connected account can read it.

## 4. The two traps Codex may not be able to set by itself — verify by hand
These are the heart of the workflow and the easiest to get silently wrong.
- [ ] **F15 Remote Work Policy must be truly unreadable** by the workspace account. If Codex can't set
      per-file permissions, set it yourself (share-restrict it so the connected account gets a
      permission error). If it's readable, the "inaccessible → unknown coverage" path never fires.
- [ ] **F07 Network Diagram must have no extractable text layer** (a real scan/image PDF). If the
      connector produced a normal text PDF, replace it with an image-only one. If text extracts, the
      "unparsed → unknown coverage" path never fires.
- [ ] **F10 Q2 Product Review must be genuinely empty** (title slide only, no body, no notes).

## 5. Microsoft Teams — team + channel
- [ ] Confirm team **Workflow test** exists (reuse from WF-092/109/138/200/206/239) and that the
      channel **Knowledge Base** exists under it — create it if not.

> Teams was the blocker on WF-138. Check it before the run — the summary post is the last step, and the
> prompt is explicit that a half-finished run must not go up.

---

## Four ambiguities in Prompt-236 worth deciding before you run
The seed lands on all four on purpose. Pick the call and hold the run to it, or two engineers diverge.

1. **A parseable file with no stated date (F09).** The prompt says *every chunk must carry a last
   modified date* ("a chunk without complete metadata doesn't get written") **and** says if a file
   states no date, flag it rather than back-filling from Drive. Those pull opposite ways for F09: is it
   indexed with a null/"unknown" date and flagged, or bumped to **unknown coverage** because its chunks
   can't be metadata-complete? Decide. (My read: index with an explicit "no stated date" flag and score
   any answer from it no higher than **Medium**, since freshness can't be established — but the prompt
   doesn't say, and it changes the ledger's indexed count.)
2. **Fresh date, stale content (F12).** The High/Medium rule keys on the *stated date* ("every source
   dated 2026-04-17 or later" = High). F12's stated date is fresh (2026-07-05) but its content is
   plainly unrevised, and the prompt says catch that and "say so rather than treating it as fresh." So
   does F12 score by its **date** (High-eligible) or by its **content** (downgrade to Medium)? Intended
   is downgrade, but the scoring rule as written is date-only. Decide whether content-stale overrides a
   fresh date.
3. **The `2026-04-17 or later` boundary.** F14 is exactly 2026-04-17 (intended **fresh**), F17 is
   2026-04-16 (intended **stale**). The prompt says "2026-04-17 or later," so on-the-day is fresh —
   confirm the run treats the boundary as inclusive, because F14 vs F17 is one day apart by design.
4. **A catalog row whose file id vanished from Drive.** The prompt says match on file id and update in
   place, but doesn't say what to do if a previously-cataloged file is gone. The seed doesn't force this
   (all three prior catalog rows still exist), but if you later delete a file, decide the behavior.

## Verify the seed before the real run
Spot-check these by hand; they're the ones that silently break the audit if Codex drifts.

- [ ] **20 files** in the tree; the intended ledger reconciles: **20 found = 15 indexed + 2 unparsed
      (F07, F10) + 1 inaccessible (F15) + 2 out-of-scope (F19, F20)**.
- [ ] **F18 shortcut**: same file id in `Product/` and `Engineering/Backend/Security/`; home is the
      shorter `Product/` path; it must index **once**.
- [ ] **F07 extracts no text**, **F10 is empty**, **F15 is unreadable** — the three checks from §4.
- [ ] **Dates land where the workflow reads them**: `Last-Updated:` lines (Docs/PDFs), slide-1 notes
      (Slides), `_meta.last_updated` (Sheets). F09 states none.
- [ ] **Boundary dates**: F14 = 2026-04-17 (fresh), F17 = 2026-04-16 (stale).
- [ ] **F12** states a fresh 2026-07-05 but its body is 2025-era with the "content unchanged since
      2025-11" note.
- [ ] **Topic separation is clean**: F07 covers only network topology (blocks Q5), F15 covers only
      remote work (blocks Q6), and **nothing** covers disaster recovery (Q12 is the confirmed gap).
- [ ] **KB Query Set** has the 15 questions + a human note or two; no expected answers written.
- [ ] **KB Index Tracker**: three tabs; prior rows keyed on the **real** F01/F08/F13 file ids; human
      `owner` on F01/F08; one prior gaps row for Q12.
- [ ] **MongoDB**: F01 prior chunks under the **current** id (2026-06-10), F04 prior chunks under a
      **stale** id (2026-05-01); `routing_domains` empty; both collections exist.
- [ ] **No verdicts anywhere in the seed** — no parse status, confidence, domain, gap, or chunk count
      written inside any file or the question sheet.

## What the seed is designed to catch (why these specific files)
Useful when reviewing the run's output — these are the traps, not an answer key.

| Trap | Where | What a shallow run does wrong |
|---|---|---|
| Scanned PDF, no text layer | F07 | indexes it as empty text → looks like coverage that isn't there |
| Empty deck (title only) | F10 | indexes near-nothing as a real doc |
| Inaccessible file | F15 | skips it silently instead of counting it |
| Unparsed/inaccessible ≠ gap | Q5→F07, Q6→F15 | calls a confirmed gap when a blocked file may cover it |
| Real confirmed gap | Q12 (disaster recovery) | mislabels it unknown-coverage, or misses it |
| Shortcut = one file id | F18 in two folders | indexes twice; ledger over-counts |
| Shortest path is home | F18 | picks the deep Engineering path over `Product/` |
| Drive timestamp is a lie | all files | dates answers off Drive's modified time, not the stated date |
| No stated date | F09 | back-fills the Drive timestamp as if real |
| Fresh date, stale content | F12 | scores High off the bumped date |
| Cutoff boundary inclusive | F14 (04-17) vs F17 (04-16) | flips one of them |
| Per-type parsing | Sheets F06/F11/F16, Slides F05, PDFs F03/F14/F17 | flattens tables/slides into a wall of text, loses position markers |
| Cross-domain routing | Q13 (Security + HR) | forces it into one domain |
| No-domain routing | Q14 (coffee budget) | shoves it into the nearest domain instead of whole-corpus + Low |
| Stale source downgrades confidence | Q2 (F02), Q11 (F17) | scores High despite a pre-cutoff source |
| Run-twice idempotency | MongoDB F01 (leave) / F04 (replace) | appends a second copy of a file's chunks |
| Chunk missing metadata | any | writes a dateless chunk, poisoning recency filters |
| Ledger must reconcile | the whole catalog | writes a tidy sheet whose numbers don't add up |
| Human owner column | tracker F01/F08 rows | overwrites `owner` on upsert |
| Prior gap row | gaps tab Q12 | duplicates the gap instead of updating |

## What you do NOT set up (the workflow produces these)
- The full `chunks` index and the `routing_domains` layer (beyond the tiny idempotency seed)
- The current-run rows in the KB Index Tracker (catalog / gaps / ledger)
- The Teams summary with the Blind Spots section
