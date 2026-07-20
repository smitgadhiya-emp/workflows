# Codex Prompt — Create WF-236 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (Google Drive/Sheets,
MongoDB, Microsoft Teams). **Create every item in the actual app. Do NOT write anything to the local
file system.**

---

You are setting up **mock source data** for a workflow that catalogs a Google Drive knowledge base,
builds a chunked index + routing layer in MongoDB, answers a question set against it with confidence
scores, finds knowledge gaps, and posts a Teams summary. Your job is ONLY to create the seed data the
workflow reads.

**Do NOT run the workflow.** Do NOT catalog anything into the tracker, do NOT chunk or write the index
(beyond the small prior-run MongoDB state described below for idempotency), do NOT build the routing
domains, do NOT answer the questions, do NOT compute gaps, and do NOT post to Teams. The file catalog
below tells you what **documents to place in Drive** so the workflow has a real, trap-laden corpus to
index — it is your build spec, not output to transcribe.

## Where each source lives

- **Google Drive / Sheets, MongoDB, Teams** → create real items via the connectors.
- **The corpus must be real files** — the whole workflow is about parsing Docs/Sheets/Slides/PDFs on
  their own terms and pinning a chunk to a section/tab/slide/page, so these are actual Drive files
  with real structure, not a spreadsheet describing them.
- There is **no mock log sheet** here. The "source" is the Drive folder itself as it stands.

## Anchor values (use everywhere; keep identical across every item)

- Drive corpus folder: **Company Knowledge Base** (walk it and every subfolder)
- Ops folder: **Knowledge Base Ops** — holds the tracker
- Tracker sheet: **KB Index Tracker**, tabs **catalog**, **gaps**, **ledger**
- Question sheet: **KB Query Set**, tab **questions**
- MongoDB: database **knowledge_base**, collections **chunks** and **routing_domains**
- Microsoft Teams: team **Workflow test**, channel **Knowledge Base**
- **Staleness cutoff: 2026-04-17.** A stated last-updated date **on or after** 2026-04-17 is fresh;
  **before** it is stale/possibly-outdated. Build the dates below so this cutoff bites deterministically.

## How "last updated" works here (critical — the whole freshness signal depends on it)

Drive's own modified timestamp is **unreliable** in this corpus (it reflects when the file was loaded
into the workspace, not when content changed). So each file states its own date **inside** it, and the
workflow reads that:
- **Docs / PDFs / Slides** → a `Last-Updated: YYYY-MM-DD` line near the top (for Slides, in the speaker
  notes of slide 1).
- **Sheets** → a `last_updated` value on a `_meta` tab.
- **Some files deliberately state NO date** — those must be flagged as "no stated date", never
  back-filled from the Drive timestamp.

## The file catalog — the shared spine (place every file exactly)

Build this folder tree under **Company Knowledge Base** and place the files with the exact stated
dates and parse traps. Do **not** write any parse-status, confidence, gap, or "this is stale/empty"
note **inside** the files or anywhere else — the workflow has to derive all of that.

Subfolders: `Engineering/Backend/`, `Engineering/Frontend/`, `Engineering/Infrastructure/`,
`Product/`, `Sales/`, `HR/`, `Finance/`.

| id | title | type | folder (home) | stated date | the trap it exercises |
|----|-------|------|---------------|-------------|-----------------------|
| F01 | API Authentication Guide | Doc | Engineering/Backend | **2026-06-10** | clean fresh source, real heading hierarchy → High-confidence answer |
| F02 | Database Schema Reference | Doc | Engineering/Backend | **2026-02-03** | fresh-looking content but **stale date** → answers must be flagged possibly-outdated |
| F03 | Deployment Runbook | PDF | Engineering/Backend | **2026-05-20** (page 1) | real text layer, page numbers preserved |
| F04 | Component Library Standards | Doc | Engineering/Frontend | **2026-06-28** | fresh; used in the MongoDB "changed → replace" idempotency test |
| F05 | Frontend Onboarding Deck | Slides | Engineering/Frontend | **2026-01-15** (slide-1 notes) | slide numbers + speaker notes; **stale** |
| F06 | Server Inventory | Sheet | Engineering/Infrastructure | **2026-07-01** (`_meta` tab) | multiple tabs (`prod`, `staging`, `_meta`); table shape + headers preserved per tab |
| F07 | Network Diagram (scanned) | PDF | Engineering/Infrastructure | — (none) | **SCANNED — image pages, NO extractable text layer** → must go to the **unparsed** bucket, never indexed as empty. Covers "network topology" so it's the **unknown-coverage** blocker for Q5. |
| F08 | Product Roadmap 2026 | Doc | Product | **2026-06-15** | fresh; prior-run tracker row exists (idempotency) |
| F09 | Feature Spec: Checkout V2 | Doc | Product | **NONE — no stated date at all** | parseable but **states no date** → must be flagged "no stated date", not back-filled from Drive |
| F10 | Q2 Product Review | Slides | Product | — (none) | **title slide only, no body/notes** → **unparsed (empty)**, never indexed as empty text |
| F11 | Pricing Tiers | Sheet | Sales | **2026-05-30** (`_meta`) | fresh; table shape preserved |
| F12 | Sales Playbook | Doc | Sales | **2026-07-05 (stated)** but body unrevised | **the date wrinkle**: stated date is recent but content plainly hasn't changed (body references 2025 quarters and a since-renamed product; end note "re-saved after folder reorg — content unchanged since 2025-11"). Must be caught, not treated as fresh. |
| F13 | Employee Handbook | Doc | HR | **2026-03-10** | **stale**; part of the cross-domain Q13 |
| F14 | Benefits Summary 2026 | PDF | HR | **2026-04-17** (page 1) | **exactly on the cutoff → fresh** (boundary test, on-or-after = fresh) |
| F15 | Remote Work Policy | Doc | HR | (unreadable) | **INACCESSIBLE — permissions block the workspace account** → counted as inaccessible, never skipped. It's the only doc on remote work, so it's the **unknown-coverage** blocker for Q6. |
| F16 | Budget FY26 | Sheet | Finance | **2026-06-20** (`_meta`) | fresh |
| F17 | Expense Policy | PDF | Finance | **2026-04-16** (page 1) | **one day before the cutoff → stale** (boundary test, opposite side) |
| F18 | Security Best Practices | Doc | Product **and** Engineering/Backend/Security (shortcut) | **2026-05-25** | **same file id in two places via a shortcut** → index **once**; home = the **shortest** path (`Product/`), note the other path; must NOT be indexed twice |
| F19 | architecture.png | image (PNG) | Engineering/Infrastructure | — | **out-of-scope type** → not indexed, but **counted** in the ledger |
| F20 | allhands.mp4 | video (MP4) | Product | — | **out-of-scope type** → not indexed, but **counted** in the ledger |

**Content depth:** the indexed Docs/Sheets/Slides/PDFs need enough real, on-topic content that
retrieval can actually answer the matching question (see the question set) — a few sections / rows /
slides / pages each, with genuine headings, column headers, slide notes, and page breaks so the
per-type parsing and position markers (section / tab+cell-range / slide number / page number) are real.
Keep topics cleanly separated so plausibility calls are unambiguous: F07 is about **network topology**
only (not disaster recovery), F15 is about **remote work** only.

### The intended ledger (build the files so this reconciles exactly — do not write it into the seed)

- **Files found (unique file ids): 20.** F18 is encountered via two paths but is **one** id.
- Out-of-scope types: **2** (F19, F20).
- In-scope typed (Doc/Sheet/Slides/PDF): **18** (F01–F18).
- Inaccessible: **1** (F15). Unparsed: **2** (F07 scanned, F10 empty).
- Indexed: **15** (18 − 1 − 2).
- Reconciliation: 15 indexed + 2 unparsed + 1 inaccessible + 2 out-of-scope = **20 found**. The
  shortcut must not double-count F18.

## What else to create

### 1) Google Sheet — "KB Query Set" (in the Company Knowledge Base's org, anywhere reachable), tab **questions**

Columns: `question id, question, notes (human)`. Seed these 15 questions verbatim-ish. They are built
so each lands on a specific path — do not tag the expected answer anywhere:

| qid | question | intended path (for your review only — do NOT write this in the sheet) |
|-----|----------|----------------------------------------------------------------------|
| Q1 | How do we authenticate API requests? | F01, fresh → **High** |
| Q2 | What does our orders database schema look like? | F02, stale → **Medium** |
| Q3 | How do I deploy a service to production? | F03, fresh → **High** |
| Q4 | What are our frontend component standards? | F04, fresh → **High** |
| Q5 | What is our network topology? | only F07 (unparsed) covers it → **unknown coverage**, name F07 |
| Q6 | What is our remote-work policy? | only F15 (inaccessible) covers it → **unknown coverage**, name F15 |
| Q7 | What's the spec for Checkout V2? | F09 (no stated date) → answerable but freshness unknown → **Medium/Low**, flag the missing date |
| Q8 | What are our pricing tiers? | F11, fresh → **High** |
| Q9 | What's our enterprise sales process? | F12 (fresh date, stale content) → **Medium**, flag date-not-trustworthy |
| Q10 | What are the 2026 employee benefits? | F14 (exactly 2026-04-17) → **High** (boundary = fresh) |
| Q11 | What's the expense reimbursement limit? | F17 (2026-04-16) → **Medium** (stale by one day) |
| Q12 | What is our disaster-recovery plan? | nothing covers it; no unparsed/inaccessible file plausibly does → **confirmed gap** (Infrastructure) |
| Q13 | How do we handle an employee data-privacy / GDPR request? | spans Security (F18) + HR handbook (F13) → **routes to both domains**; F13 stale → **Medium** |
| Q14 | What's the office coffee budget? | matches no domain → **routes to whole corpus**, **Low** |
| Q15 | What's on the product roadmap? | F08, fresh → **High** |

Leave the `notes (human)` column with one or two human notes (e.g. on Q13: *"Legal cares about this
one"*) so the workflow's "leave human columns alone" behavior can be checked.

### 2) Google Sheet — "KB Index Tracker" (in the **Knowledge Base Ops** folder), tabs **catalog**, **gaps**, **ledger**

Create all three tabs with headers; seed only a small **prior-run** state (matched on **file id**) so
update-in-place and human-column preservation can be tested. This run's full results are output.

**`catalog`** columns: `file id, title, type, author, created date, last modified date, folder path,
chunk count, parse status, stale flag, owner`. Seed **three prior rows** with an older run's values:
1. **F01** — stale prior chunk count and an older `last modified date`, **`owner` = eng-backend-team**
   (human-set). *(Upsert must refresh but keep `owner`.)*
2. **F08** — prior values, **`owner` = product-team** (human-set). *(Same test.)*
3. **F13** — prior values, `owner` empty. *(Clean update.)*
Use the **real F01/F08/F13 file ids** Drive assigns, so the match key is genuine.

**`gaps`** columns: `topic, status, question, domain, blocker, recommended doc`. Seed **one prior row**:
- topic `Disaster Recovery`, status `confirmed gap`, question `Q12`, domain `Engineering/Infrastructure`,
  blocker empty, recommended doc `DR Runbook`. *(Tests update-not-duplicate on the gaps tab.)*

**`ledger`** columns: `metric, count, as of`. Seed the header and one stale prior row set (older `as of`
date) so the reconciliation is visibly refreshed on the run.

### 3) MongoDB — database **knowledge_base**

Ensure collections **chunks** and **routing_domains** exist. Seed a **minimal prior-run state** in
`chunks` so the run-twice idempotency (leave-unchanged / replace-changed / no-duplicates) has something
to reconcile:
- **F01 (unchanged case):** a few chunks whose stable `_id` is derived from **F01's file id +
  2026-06-10 + position**, carrying full metadata. Because F01's stated date is unchanged, the run must
  **leave these alone**.
- **F04 (changed case):** a few chunks whose stable `_id` is derived from **F04's file id + an OLD date
  (2026-05-01) + position** — i.e. a version that no longer matches F04's current stated date
  (2026-06-28). The run must **replace** these (delete the stale-id chunks, write fresh ones) and must
  **not** leave both copies.
Leave `routing_domains` **empty** (the workflow builds it). Do not seed any other chunks.

### 4) Microsoft Teams

Confirm team **Workflow test** and channel **Knowledge Base** exist; create the channel if it isn't
there. Do not post — the summary is the workflow's output.

## Consistency rules (verify all before reporting done)

1. All 20 files exist at the exact folders/types/dates above; F18 is one file id shortcut-linked into a
   second folder, with `Product/` the shorter (home) path.
2. **F07 truly has no extractable text layer** (image-only scan) and **F10 is genuinely empty** (title
   only) — open them and confirm nothing meaningful extracts. These are the unparsed traps.
3. **F15 is actually unreadable** by the workspace account (permissions), not just named "inaccessible".
4. **F09 states no date anywhere**; F14 states exactly 2026-04-17; F17 states 2026-04-16; F12 states a
   fresh 2026-07-05 while its body is plainly 2025-era.
5. Stated dates live where the workflow looks: `Last-Updated:` lines in Docs/PDFs, slide-1 notes in
   Slides, `_meta` tab `last_updated` in Sheets.
6. F19/F20 are out-of-scope types present in the tree so the ledger's out-of-scope count is real.
7. The intended ledger reconciles (20 = 15 + 2 + 1 + 2) and the shortcut does not double-count.
8. KB Query Set `questions` tab has the 15 questions with one or two human notes; no expected
   answer/confidence written anywhere.
9. KB Index Tracker has the three tabs, the seeded prior rows keyed on the **real** F01/F08/F13 file
   ids, human `owner` on F01/F08 rows, and the one prior gaps row for Q12.
10. MongoDB has the F01 (current-id) and F04 (stale-id) prior chunks and nothing else; `routing_domains`
    is empty; both collections exist.
11. **No parse status, confidence, domain assignment, gap verdict, or chunk-count truth appears inside
    any Drive file or in the question sheet.** The seed builds the corpus; the workflow derives every
    verdict.

## When done — report back (so the workflow prompt can be filled to match)

List: the **Company Knowledge Base folder** confirmed with all 20 files and the subfolder tree; the
**real file ids** for F01/F08/F13 (used as the tracker match keys) and for F04/F18 (used in the MongoDB
and shortcut tests); the **URLs of KB Index Tracker and KB Query Set**; confirmation the **MongoDB
`knowledge_base` db + `chunks`/`routing_domains` collections** exist with the seeded prior chunks; and
confirmation the **Teams team/channel** exist. If any of the corpus files (especially the scanned F07,
the empty F10, or the inaccessible F15), the Sheets, MongoDB, or the Teams channel could not be created
as specified, **say so explicitly and name which** — do not report done with a gap. Finish with a short
note confirming the eleven consistency rules hold, especially that F07/F10 truly extract nothing, F15 is
truly unreadable, and no verdicts were seeded. Do not create any local files.
