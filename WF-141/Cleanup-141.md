# Codex Prompt — WF-141 Cleanup (reset outputs before a new model run)

Run this **before** each WF-141 execution when you're testing the same prompt on a new model. It
deletes only the **outputs** of a previous run and leaves the seeded input untouched, so every model
starts from the same clean state.

Paste everything below the line into Codex (Google Drive/Sheets + Microsoft Teams connectors needed).

---

You are **resetting the outputs** of a previously-run workflow so the same workflow prompt can be
re-run cleanly on a different model. Your job is **ONLY to delete that run's outputs and verify the
input seed is intact**. Do **NOT** run the imbalance workflow, do **NOT** recreate the seed data, do
**NOT** post anything to Teams, and do **NOT** write any local files.

## Scope — the only things you may delete

**1. The Teams report post**
- Team **Workflow test**, channel **ML Data Quality**.
- Delete every message whose title is exactly **`Training Data Imbalance Report - 2026-07-16`**
  (the report for snapshot **2026-07-16 12:00 Asia/Kolkata**), including any duplicates, any
  attachments on them, and any replies in their threads.
- **Read each message before deleting it** to confirm it really is that report for that snapshot. If a
  message's title matches but its content is clearly something else, **do not delete it** — stop and
  report it instead.

**2. The generated CSV**
- Delete every copy of **`class_distribution_2026-07-16.csv`** — attached to the post above, and any
  copy sitting loose in Google Drive (check the **ML Datasets** folder, "Recent", and the connected
  account's Drive root).

## Hard guardrails — never touch these

- ❌ **Never delete or edit `train_manifest_v1`** (the Google Sheet in **ML Datasets**). It is the
  read-only input seed. If a previous run modified it, **report that — do not "fix" it yourself.**
- ❌ Never delete the **ML Datasets** Drive folder, the **Workflow test** team, or the
  **ML Data Quality** channel — only messages inside the channel.
- ❌ Never delete a report for a **different snapshot** (a different date in the title, e.g.
  `... - 2026-07-06`). A different timestamp is a different snapshot and owns its own report.
- ❌ Never delete unrelated messages, files, or other people's posts in the channel.
- ❌ Do not re-seed, re-create, or "restore" anything. Cleanup only.

## Then verify the input seed is still pristine

Read (do not edit) **`train_manifest_v1`**, tab `manifest`, and confirm a previous run only read it:

- [ ] Header is exactly `sample_id, label, split, image_uri, last_modified` — no extra columns
      (no shares / priority / rank / flags written into the sheet).
- [ ] Total rows where `split = train` is **1070**.
- [ ] **1021** distinct `TR-` sample ids, each in `train` only.
- [ ] Spot-check class counts: **scarf = 51**, **gloves = 8**, **watch = 100**, **jacket = 88**,
      **t-shirt = 175** (unique valid ids, after canonicalizing case/whitespace).
- [ ] Exclusion buckets still present: `LK-0001..5`, `BL-0001..6`, `MF-0001..10`, `CF-0001..4`.
- [ ] No label contains a comma, semicolon, or pipe (no genuine multi-label row).

If any of these fail, **say so explicitly and stop** — the seed was mutated and must be re-created
from `Codex-DummyData-Prompt-141.md` before the next run.

## Report back

State plainly:
1. How many Teams messages you deleted (0 is a valid, good answer — say "channel was already clean"),
   and the title/timestamp of each.
2. How many copies of `class_distribution_2026-07-16.csv` you deleted, and where each lived.
3. Whether the input seed passed **every** verification check above — if not, exactly which check
   failed and what the value was.
4. A one-line verdict: **READY for the next model run**, or **NOT READY** with the reason.

Do not create any local files.
