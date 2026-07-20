# WF-141 — Source / Anchor Values

The workflow reads ONE input (a Google Sheet) and writes to Teams. Fill/confirm these before running.

| Field | Value |
|-------|-------|
| [dataset sheet] (source of truth) | **train_manifest_v1** Google Sheet, tab `manifest` |
| [drive folder] | **ML Datasets** (Google Drive) |
| [id column] | `sample_id` (unique id) |
| [label column] | `label` (class) |
| [split column] | `split` — analyze only rows where `split` = `train` |
| [snapshot timestamp] | **2026-07-16 12:00 Asia/Kolkata** (must be AFTER the sheet's creation — see note) |
| [next training run] | **2026-07-23 09:00 Asia/Kolkata** (reference only) |
| [timezone] | Asia/Kolkata (every date) |
| [team] > [channel] | **Workflow test** > **ML Data Quality** (post the report here) |
| [report title] | `Training Data Imbalance Report - 2026-07-16` |
| [CSV name] (OUTPUT — not seeded) | `class_distribution_2026-07-16.csv` |
| [5% threshold] | severely underrepresented when **true share < 5.00%** (full precision, not rounded) |
| [priority bands] | P0 < 1.00% · P1 [1.00%, 2.50%) · P2 [2.50%, 5.00%) · none ≥ 5.00% |
| [gap formula] | `max(0, ceil(0.05 × total valid) − class count)` |
| [plugins] | Google Drive/Sheets, Microsoft Teams, Chrome |

## Mock-source note
There is no live source to inject into — the manifest is the Google Sheet `train_manifest_v1` in the
**ML Datasets** folder, and the workflow reads it directly. Everything is created via the connectors;
**no local files.**

## Snapshot note — the timestamp must be AFTER the sheet was created
A snapshot timestamp *before* the sheet exists can't be satisfied: Drive's revision history starts at
the real creation time, so a model asked for "the snapshot as of 2026-07-13 09:00" will (correctly)
refuse, because that moment predates the file. That's what blocked the first run. Backdating
`createdTime` doesn't help — revision history still begins at creation.

Fix: the snapshot timestamp is set to **2026-07-16 12:00**, which is after the sheet's creation
(~10:40 on 2026-07-16) and before you run — so it points at a real revision. Keep it that way. The
`last_modified` column is cosmetic (the workflow doesn't read it). **Freeze the sheet after seeding**
so nothing is edited after the snapshot time.

> If you re-seed on another day, the sheet's creation moves — bump this snapshot timestamp to a time
> after the new creation (and before your run), and update the date labels in the CSV name and report
> title to match if you change the day.

## Expected result (for verifying the workflow run — NOT seeded)
Derived from the engineered seed. Use this to check the workflow's output.

- **Total valid unique training samples: 1021.** Distinct classes: **12**.
- **Reconciliation ledger:** rows read **1070** = leakage **5** + blank **6** + malformed **10** +
  conflict **8** + unresolved **0** + rows-rolled-into-valid **1041** (1021 valid + 20 dup-agreeing).
- **Classes below 5.00%: 4** (33.33% of classes): gloves, socks, belt, scarf.
- **Overall balance risk: HIGH** (gloves is P0).
- **Collection list (severely underrepresented, ranked):**
  1. gloves — 8 — 0.78% — **P0** — needs 44
  2. socks — 20 — 1.96% — P1 — needs 32
  3. belt — 40 — 3.92% — P2 — needs 12
  4. scarf — 51 — **displays 5.00% but true 4.9951%** — P2 — needs **1** (the precision trap)
- **Collapsed-label groups reported:** `watch` (variants Watch/ watch /WATCH) and `jacket` (variant
  Jacket).
- **Provisional flags:** none (unresolved = 0, so nothing can tip a class across a line).
- The ">20 classes" heads-up is NOT expected (only 12 classes).
- CSV rank order: gloves, socks, belt, scarf, then no-priority classes by ascending share — hat,
  jeans, jacket, watch, bag, dress, shoes, t-shirt.
