# Codex Prompt — WF-236 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-236 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-236 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-236 knowledge-base indexing run. Delete **only what the run produced**.
The seed data must survive untouched — the corpus is expensive to rebuild and the next run depends on
it.

### Do NOT touch (this is the seed)
- The **Company Knowledge Base** Drive folder and all 20 files, the subfolder tree, the F18 shortcut,
  the stated dates, and the deliberate traps (F07 scanned, F10 empty, F15 inaccessible). The run only
  **reads** the corpus; if you find a corpus file changed or deleted, **stop and report it** rather
  than fixing it.
- The **KB Query Set** sheet and its `questions` tab, including the human notes.
- The **Knowledge Base Ops** folder and the **KB Index Tracker** sheet itself (structure + the seeded
  prior rows — see below for what to reset).
- The MongoDB **knowledge_base** database and the two collections themselves.
- The Teams team **Workflow test** and the channel **Knowledge Base** themselves.

### 1) MongoDB — `knowledge_base`
- **`chunks`**: delete every chunk the run wrote, then **restore the seeded prior state**:
  - Keep / re-create the **F01** prior chunks under the **current** id (file id + 2026-06-10 +
    position) — these represent "unchanged, left alone."
  - Keep / re-create the **F04** prior chunks under the **stale** id (file id + 2026-05-01 + position)
    — these represent "changed, to be replaced." The run will have deleted the stale-id chunks and
    written fresh F04 chunks; remove those fresh ones and put the stale-id set back, so the next run
    tests the replace path again.
  - Remove chunks for every other file (F02, F03, F05, F06, F08, F09, F11–F14, F16, F17, F18) — those
    were all written by the run.
- **`routing_domains`**: **empty it completely** — the whole routing layer is run output.
- If you can't tell a seeded chunk from a run-written one, note it and leave it rather than guessing —
  but the clean state is exactly the F01-current + F04-stale sets and nothing else.

### 2) Google Sheet — "KB Index Tracker"
- **`catalog`** tab: keep the header; **delete every row except the three seeded prior rows** (F01,
  F08, F13, matched on file id). Restore those three to their seeded prior values (older `last modified
  date` and chunk count), and put back **`owner` = eng-backend-team** on F01 and **`owner` =
  product-team** on F08; leave F13's `owner` empty. Clear any `parse status` / `stale flag` the run set
  on these three.
- **`gaps`** tab: keep the header; **delete every row except the one seeded prior row** (Disaster
  Recovery / confirmed gap / Q12), restored to its seeded values.
- **`ledger`** tab: keep the header; **delete the run's reconciliation rows** and restore the single
  stale prior count set with its older `as of` date.
- Do not delete and recreate the sheet — its URL is wired into the workflow prompt.

### 3) Microsoft Teams — `Workflow test` > `Knowledge Base`
- Delete the summary message the run posted (the one with the catalog counts, chunks written, domains,
  High/Medium/Low tallies, gap vs unknown-coverage counts, stale-source count, the **Blind Spots**
  section, and the tracker link). Delete any follow-ups or thread replies under it.
- Leave the channel itself in place.

### 4) Report back
State exactly: how many chunks you deleted and that `chunks` is back to only the F01-current + F04-stale
seeded sets, that `routing_domains` is empty; how many catalog/gaps/ledger rows you deleted and that the
seeded prior rows are restored with F01/F08 `owner` intact; and whether the Teams message was found and
deleted. If the run left anything you couldn't classify as seed-or-output, **name it and leave it
alone** rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-236)

Delete everything WF-236 created, seed included. This is destructive and there is no undo — the corpus
takes a full seed run to rebuild. Confirm that's what you want before running it.

1. **Google Drive** — delete the **Company Knowledge Base** folder and all its files, the **KB Query
   Set** sheet, and the **KB Index Tracker** sheet; then delete the **Knowledge Base Ops** folder if it
   is now empty. If any folder holds something you didn't create, leave it and say what's in it.
2. **MongoDB** — drop the **knowledge_base** database (or empty both `chunks` and `routing_domains` and
   drop them). If you lack rights to drop the database, empty the collections and say so.
3. **Teams** — delete every message in **Workflow test** > **Knowledge Base**, then the channel.
   **Leave the team `Workflow test` itself** — it's shared with WF-092 / WF-109 / WF-138 / WF-200 /
   WF-206 / WF-237 / WF-239.

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
