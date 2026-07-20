# WF-141 — Manual Setup (do these yourself, before anything runs)

Things Codex can't bootstrap on its own (OAuth logins, Teams creation, Drive folder). Do these first,
then run the Codex seed prompt, then run the workflow.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **Google Drive / Sheets** (permission to create a sheet in the target folder)
- [ ] **Microsoft Teams**
- [ ] **Chrome** session available (the workflow may open one; optional but wire it up)

> You do NOT need any ML/training platform connector — there is no live source. The manifest is just a
> Google Sheet.

## 2. Google Drive — folder for the manifest
- [ ] Create the folder **ML Datasets**. Codex puts the **train_manifest_v1** sheet there.

## 3. Microsoft Teams — team + channel must exist
- [ ] Confirm team **Workflow test** exists (reuse from prior WFs).
- [ ] Confirm/create the channel **ML Data Quality** under it. The workflow posts the imbalance report
      here — leave it empty; the report is the workflow's output.

## 4. Run the Codex seed prompt
- [ ] Run `Codex-DummyData-Prompt-141.md`. It creates `train_manifest_v1` (tab `manifest`) with the
      1021 engineered valid rows + the edge-case buckets. It does **not** post to Teams or build the CSV.

## 5. Freeze the sheet (the "snapshot")
- [ ] After seeding, **do not edit** the sheet, so its state stays equal to the engineered seed.
- [ ] The prompt's snapshot timestamp is **2026-07-16 12:00**, chosen to be **after** the sheet's
      creation (~10:40 on 2026-07-16) and before you run. A timestamp *before* creation can't exist in
      Drive history and a correct model will refuse to run (this already happened once). If you re-seed
      on another day, move the snapshot timestamp to just after the new creation time (and update the
      2026-07-16 date labels in the CSV name / report title if the day changes).

---

## Verify the seed before the real run
- [ ] Sheet **train_manifest_v1** exists in **ML Datasets**, tab `manifest`, header
      `sample_id, label, split, image_uri, last_modified`.
- [ ] Exactly **1021** `TR-` ids in `train`, one row each, matching the 12 class counts — spot-check
      **scarf = 51** and **gloves = 8** (these two drive the precision trap and the HIGH risk).
- [ ] `watch` (100) and `jacket` (88) rows are spread across the listed spelling variants; all other
      classes use one spelling.
- [ ] **No comma / semicolon / pipe inside any label, and no genuine multi-label row** — otherwise the
      workflow halts before producing a report. (`t-shirt`'s hyphen is fine and intended.)
- [ ] 20 duplicate-agreeing rows on `TR-00001..20` (≥5 case-variant); class counts unchanged.
- [ ] Exclusion buckets present on their own id prefixes: leakage `LK-0001..5` (train + a non-train
      split), blank `BL-0001..6`, malformed `MF-0001..10` (incl. one control char), conflict
      `CF-0001..4` (2 disagreeing train rows each); **unresolved = 0**.
- [ ] ~40 legit `val`/`test` rows on `NT-` ids, each in only one split (not leakage).
- [ ] `last_modified` values are ≤ 2026-07-15 (cosmetic — the workflow doesn't read this column).
- [ ] Total `train` rows = **1070**.

## What you do NOT set up (the workflow produces these)
- The `class_distribution_2026-07-16.csv` file.
- The Teams post in **ML Data Quality** ("Training Data Imbalance Report - 2026-07-16").
- Any shares / priorities / gaps / reconciliation ledger inside the sheet.

---

## Between test runs — reset before re-running the SAME prompt (e.g. comparing models)

The seed is the **input** and does not get consumed, but the workflow leaves **outputs** behind. If you
run the prompt again (a second model, or the same model twice) without cleaning up, the workflow's
own idempotency ("one report per snapshot") kicks in: it finds the existing post and **edits it in
place** instead of producing a fresh one — and if two runs left **two** posts, it will **stop and
report duplicates** instead of posting at all. So reset the outputs between runs.

> **Easiest path:** run **`Codex-CleanupSeedData-Prompt-141.md`** in Codex before each new model run. It does
> everything in this section automatically — deletes the outputs, refuses to touch the seed, and
> reports READY / NOT READY. The checklists below are what it does (and what to check by hand if you'd
> rather not run it).

### Delete after each run (the outputs)
- [ ] **Teams post** — in **Workflow test › ML Data Quality**, delete the message titled
      **`Training Data Imbalance Report - 2026-07-16`** (and any duplicate of it). Do this after every
      run so the next model posts a clean, comparable report from scratch.
- [ ] **CSV** — delete every copy of **`class_distribution_2026-07-16.csv`** the run created (attached
      to the Teams post, and any stray copy left in Drive / the run's workspace).
- [ ] If the model wrote a scratch/working copy anywhere, delete that too.

### Do NOT delete or re-seed (the input stays put)
- [ ] **Keep `train_manifest_v1` exactly as seeded.** It's read-only input — do not re-run the Codex
      seed prompt between models, or you'll get a different sheet and the runs won't be comparable.

### Verify the input is still pristine before the next run
A previous run *should* only read the sheet, but confirm no model edited it:
- [ ] Total `train` rows still **1070**; **1021** `TR-` valid ids; **scarf = 51**, **gloves = 8**.
- [ ] No new rows, no changed labels, no filled-in shares/priority columns. If anything changed,
      re-seed from the Codex prompt to restore it.

### If you want the SAME conditions for every model
- [ ] Clean outputs (above), keep the input pristine (above), then run the prompt. Each model starts
      from an empty channel + untouched sheet → an apples-to-apples comparison.

### Optional — to instead test the workflow's *update-in-place* path
- [ ] Leave **exactly one** prior post in the channel (do not delete it) and re-run. The workflow
      should find that single post and **edit it + swap the CSV attachment**, not create a second one.
      (Two or more prior posts is the "stop and report duplicates" case — only use that to test the
      duplicate-detection guard.)
