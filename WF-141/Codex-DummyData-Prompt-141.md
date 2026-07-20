# Codex Prompt — Create WF-141 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (Google Drive / Sheets,
Microsoft Teams, Chrome). **Create every item in the actual app. Do NOT write anything to the local
file system.**

---

You are setting up **mock source data** for a workflow that reads a single-label ML training manifest
from a Google Sheet, cleans the labels, and reports class imbalance to a Teams channel. Your job is
**ONLY to create the one input sheet the workflow reads**. Do NOT run the imbalance analysis, do NOT
build the `class_distribution_2026-07-16.csv`, and do NOT post anything to Teams — those are the
workflow's outputs.

## Where each source lives (the important rule)
- **Google Drive / Sheets, Microsoft Teams** → create/confirm real items via the connectors.
- **No local files.** The manifest is a real Google Sheet, not a CSV on disk.
- The workflow's CSV and the Teams report are **outputs** — do not create them here.

## Anchor values (use everywhere; keep them identical)
- Google Drive folder: **ML Datasets**
- Google Sheet (the manifest / source of truth): **train_manifest_v1**  → put it in **ML Datasets**
- Snapshot timestamp the workflow analyzes: **2026-07-16 12:00 Asia/Kolkata** (deliberately after the
  sheet's creation). Do NOT try to backdate the sheet or forge revision history — just create it fresh
  and don't edit it afterward.
- Next training run (reference only): **2026-07-23 09:00 Asia/Kolkata**
- Timezone: **Asia/Kolkata** for every date
- Microsoft Teams: team **Workflow test**, channel **ML Data Quality** (confirm it exists; do NOT post)
- Columns the workflow uses: **`sample_id`** (unique id), **`label`** (class), **`split`** (only rows
  where `split` = `train` are analyzed)

## The sheet: `train_manifest_v1`

One tab (call it `manifest`). Header row, then data rows. Columns in this order:

`sample_id, label, split, image_uri, last_modified`

- `image_uri` — a benign non-PII reference like `gs://acme-ml-datasets/images/<sample_id>.jpg`. The
  workflow ignores it; it's just there to make the manifest realistic. **No personal data, no
  credentials, no free-text sample contents.**
- `last_modified` — **cosmetic only; the workflow does NOT read this column.** Give each row an
  `Asia/Kolkata` timestamp on or before **2026-07-15** (spread across 2026-05-01 … 2026-07-15) just so
  the manifest looks realistic. Nothing in the analysis depends on these values — the snapshot is the
  sheet's current state, not a per-row timestamp.
- `split` values are `train`, `val`, or `test`. Only `train` is analyzed; `val`/`test` exist so the
  workflow can (a) catch split leakage and (b) prove it correctly ignores non-train rows.

### Part 1 — the valid training set (this defines the class distribution)

Create **exactly 1021 unique valid training sample_ids**, ids `TR-00001` … `TR-01021`, each with
**one** `train` row, `split = train`, labelled to hit these **exact** per-class counts. These counts
are unique-sample counts (one id each). Every `TR-xxxxx` id must appear **only** in `train` — never
in `val`/`test` (that would make it leakage and break the distribution).

| # | class (display spelling) | valid sample count | true share | priority | severely underrepresented |
|---|--------------------------|-------------------:|-----------:|----------|---------------------------|
| 1 | t-shirt | 175 | 17.140% | — | FALSE |
| 2 | shoes   | 155 | 15.181% | — | FALSE |
| 3 | dress   | 135 | 13.222% | — | FALSE |
| 4 | bag     | 115 | 11.263% | — | FALSE |
| 5 | watch   | 100 |  9.794% | — | FALSE |
| 6 | jacket  |  88 |  8.619% | — | FALSE |
| 7 | jeans   |  74 |  7.248% | — | FALSE |
| 8 | hat     |  60 |  5.877% | — | FALSE |
| 9 | scarf   |  51 |  **4.9951%** | **P2** | **TRUE** |
| 10 | belt   |  40 |  3.918% | P2 | TRUE |
| 11 | socks  |  20 |  1.959% | P1 | TRUE |
| 12 | gloves |   8 |  0.784% | P0 | TRUE |

Counts sum to **1021**. This gives **12 distinct classes** (deliberately ≤ 20, so the workflow's
">20 classes" branch is NOT triggered — one clean scenario).

Why these numbers (do not change them — they are the test):
- **`scarf` = 51 / 1021 = 4.99510%** is the **precision trap**: it rounds to **5.00%** for display but
  is strictly **under 5%**, so it must still count as severely underrepresented and P2, and its
  "samples needed to reach 5%" = `ceil(0.05 × 1021) − 51` = `52 − 51` = **1**.
- `gloves` < 1% → **P0**, which forces the overall balance risk to **HIGH**.
- `socks` in [1.00%, 2.50%) → **P1**; `belt` and `scarf` in [2.50%, 5.00%) → **P2**.
- The 8 classes ≥ 5% get **no priority**.

You may assign the labels to the ids in contiguous blocks (e.g. TR-00001…TR-00175 = t-shirt, …); the
order does not matter, only the per-class counts.

### Part 2 — label spelling variants (tests canonicalization + collapse reporting)

Within the counts above, **do not** write every label with one spelling. For two classes, spread the
rows across spellings that must **canonicalize to the same class** (trim ends, collapse internal
whitespace, compare case-insensitively). Keep the counts exactly as above.

- **`watch` (100 rows total):** `watch` ×70, `Watch` ×20, `␣watch␣` (leading+trailing space) ×7,
  `WATCH` ×3. → display name resolves to **`watch`** (plurality 70). The workflow must report `watch`
  as a class whose raw variants `Watch`(20), ` watch `(7), `WATCH`(3) collapsed in.
- **`jacket` (88 rows total):** `jacket` ×80, `Jacket` ×8. → display **`jacket`**, variant `Jacket`(8)
  collapsed in.

All other classes: use a single consistent spelling.

### Part 3 — benign punctuation (tests the "don't false-trigger multi-label" rule)

`t-shirt` contains a hyphen. A hyphen is **not** a multi-label delimiter, so `t-shirt` must remain a
single label. **Do NOT** put any comma, semicolon, or pipe inside any label, and **do NOT** create any
genuinely multi-label row anywhere in the sheet — a real multi-label row would make the workflow STOP
before producing a report, which is not what we're testing here.

### Part 4 — duplicate-but-agreeing rows (tests roll-up, not conflict)

Add **20 extra `train` rows** that **reuse** existing valid ids `TR-00001` … `TR-00020`, each with the
**same class** as its original row (so each id still rolls up to exactly ONE valid sample; class counts
do NOT change). For at least **5** of these, use a differently-cased spelling of the same class (e.g.
original row `watch`, duplicate row `Watch`) so the workflow must recognize them as **agreeing after
canonicalization**, not as a conflict.

### Part 5 — the exclusion buckets (extra rows, NEW ids, all `split = train` unless noted)

These rows are **not** part of the 1021 valid samples. Use distinct id prefixes so they're easy to
audit. Each must land in exactly one bucket:

1. **Split leakage — 5 ids** `LK-0001`…`LK-0005`. Each id gets **one `train` row AND one non-train
   row** (`val` or `test`) with a normal label (e.g. shoes, t-shirt, dress, bag, watch). Because the id
   appears under more than one split, it is compromised and dropped entirely → **leakage**. (5 train
   rows total.)
2. **Blank label — 6 `train` rows** `BL-0001`…`BL-0006`. `label` is empty or whitespace-only (mix
   `""` and `"   "`).
3. **Malformed label — 10 `train` rows** `MF-0001`…`MF-0010`, one placeholder/garbage each:
   `null`, `N/A`, `none`, `unknown`, `tbd`, `---`, `???`, `...`, `•`, and one value containing a
   **control character** (e.g. a bell/`` or a stray ``).
4. **Conflicting label — 4 ids** `CF-0001`…`CF-0004`, each with **two `train` rows whose canonical
   labels disagree**: CF-0001 = `shoes` / `bag`; CF-0002 = `dress` / `t-shirt`; CF-0003 = `watch` /
   `hat`; CF-0004 = `jeans` / `socks`. Whole id dropped → **conflict**. (8 train rows total.)
5. **Unresolved — 0.** Every edge case above fits a defined bucket, so the workflow should report
   `unresolved = 0`. Do not fabricate an "unclassifiable" row.

### Part 6 — legit non-train rows (tests that the workflow ignores non-train)

Add about **40 rows** with `split = val` or `split = test`, NEW unique ids `NT-0001`…`NT-0040`, normal
labels from the class list. These ids must appear in **only one** non-train split (so they are NOT
leakage) and must never collide with any `TR-`/`LK-` id. The workflow must ignore all of these.

## Row/count summary (so you can self-check before finishing)

- Valid unique training samples: **1021** (one row each) → **1021** train rows.
- Duplicate-agreeing rows: **20** train rows (reuse TR-00001..20).
- Leakage: **5** train rows (+5 matching non-train rows on LK ids).
- Blank: **6** train rows. Malformed: **10** train rows. Conflict: **8** train rows. Unresolved: **0**.
- **Total `train` rows (rows read) = 1021 + 20 + 5 + 6 + 10 + 8 = 1070.**
- Reconciliation the workflow should reach: `rows read (1070) = leakage(5) + blank(6) + malformed(10)
  + conflict(8) + unresolved(0) + rows-rolled-into-valid(1041)`, where 1041 = 1021 valid + 20 dup.
- Non-train rows: 5 leakage partners + ~40 ignored = ~45.

You do NOT need to compute shares, priorities, gaps, or the ledger in the sheet — the workflow does
that. Just make sure the rows above exist exactly.

## Consistency rules (verify all before reporting done)
1. `manifest` tab has header `sample_id, label, split, image_uri, last_modified` and every
   `last_modified` is ≤ 2026-07-15 Asia/Kolkata (cosmetic; not read by the workflow).
2. Exactly **1021** `TR-` ids, each in `train` only, hitting the 12 per-class counts **exactly**;
   `scarf` = 51 and `gloves` = 8 (do not round these off).
3. `watch` and `jacket` are spread across the spelling variants listed; every other class uses one
   spelling. **No comma / semicolon / pipe in any label, and no genuine multi-label row anywhere.**
4. 20 duplicate-agreeing rows on TR-00001..20 (≥5 using a case-variant spelling); class counts
   unchanged.
5. Leakage (5 ids in train + a non-train split), blank (6), malformed (10), conflict (4 ids / 8 rows)
   buckets all present on their own id prefixes; unresolved = 0.
6. ~40 legit `val`/`test` rows on `NT-` ids that appear in only one split (not leakage).
7. Total train rows = **1070**; total sheet rows ≈ **1115** + header.

## What NOT to create (these are the workflow's outputs)
- The `class_distribution_2026-07-16.csv` file.
- Any post in the **ML Data Quality** Teams channel.
- Any computed shares, priorities, gaps, or reconciliation ledger inside the sheet.

## When done — report back
Report: the **URL of the `train_manifest_v1` Google Sheet** and confirm it sits in the **ML Datasets**
folder; the exact tab name and header row; confirmation that the 12 class counts (especially
`scarf = 51`, `gloves = 8`) are exact and total 1021 valid ids; confirmation that the leakage / blank
/ malformed / conflict rows and the 20 duplicate-agreeing rows exist; confirmation there is **no**
genuine multi-label row; and whether the **Workflow test › ML Data Quality** Teams channel is visible
(say so explicitly if it is not). Do not create any local files.
