# Codex Prompt — WF-236 Cleanup (reset outputs before a new model run)

Run this **before** each WF-236 execution when testing the same prompt on a new model. It clears the
run's outputs and **restores the seeded "previous run" state**, so every model starts identically.

⚠ WF-236 is different from a simple output-delete: some seeded state (the 15 prior chunks, the 3 prior
tracker rows) lives **inside** the same collections/tabs the workflow writes to, and the workflow
**mutates** part of it by design (it replaces the Sales Playbook chunks). So cleanup is *wipe and
restore*, not just delete.

Paste everything below the line into Codex (Google Drive/Sheets + MongoDB + Microsoft Teams needed).

---

You are **resetting the outputs** of a previously-run workflow so the same prompt can be re-run cleanly
on a different model. Your job is **ONLY to clear that run's outputs, restore the documented seed
state, and verify the inputs are intact**. Do **NOT** run the indexing workflow, do **NOT** rebuild the
corpus, do **NOT** derive routing domains, do **NOT** answer any question, and do **NOT** post to Teams.

## Scope — the only things you may change

### 1. Microsoft Teams — delete the summary post
- Team **Workflow test**, channel **Knowledge Base**.
- Delete the workflow's KB index/gap summary post (and any duplicate of it), including attachments and
  thread replies.
- **Read each message before deleting.** Delete only messages that are plainly this workflow's summary
  (files cataloged / indexed / unparsed / blind spots / gaps / tracker link). If a message is anything
  else — a human's message, another workflow's post — **leave it and report it**.

### 2. MongoDB — wipe and restore (database **`knowledge_base`**)
- **`routing_domains`** → delete **all** documents. The collection must end up **empty** (the workflow
  derives domains; seeding them hands it the answer).
- **`chunks`** → delete **all** documents, then **re-insert exactly the 15 seeded prior-run chunks**
  below. Do not try to surgically keep the existing ones — the workflow will have replaced the Sales
  Playbook chunks with fresh-dated ones, so they must be rewritten back to the seeded values.

Chunk shape: `{ _id, file_id, doc_title, author, last_modified, folder_path, doc_type, position, text }`
Stable id scheme: **`<file_id>::<last_modified_iso>::<chunk_index>`**

| file (look up its real Drive file id) | `last_modified` to store | chunks | folder_path | author |
|---|---|---|---|---|
| **Engineering Onboarding Guide** | `2026-06-20` | **4** | Company Knowledge Base/Engineering/Onboarding | Priya Sharma |
| **Employee Handbook** | `2026-05-12` | **6** | Company Knowledge Base/HR & Policies | Meera Nair |
| **Sales Playbook** | **`2026-04-02`** ← deliberately OLDER than the file's stated 2026-06-15 | **5** | Company Knowledge Base/Sales/Playbooks | Ananya Gupta |

Every chunk needs complete metadata (title, file id, author, last_modified, folder path, doc type,
position marker) and short plausible text from that document's real content. **The Sales Playbook's
`2026-04-02` is the point of the test** — it must be older than the file's stated `Last-Updated`
(2026-06-15) so the next run sees the file as changed and has to replace those chunks. Do not
"helpfully correct" it.

Total after restore: **`chunks` = exactly 15 documents**, `routing_domains` = **0**.

### 3. Google Sheet **KB Index Tracker** (in **Knowledge Base Ops**) — clear and restore
- **`catalog` tab** → delete all data rows, then restore **exactly these 3 prior rows** (keyed to the
  real file ids), keeping the header:

| file_id | title | chunk_count | parse_status | stale_flag | **owner** |
|---|---|---|---|---|---|
| (Engineering Onboarding Guide id) | Engineering Onboarding Guide | 4 | indexed | FALSE | **Priya Sharma** |
| (Employee Handbook id) | Employee Handbook | 6 | indexed | FALSE | **Meera Nair** |
| (Sales Playbook id) | Sales Playbook | 5 | indexed | TRUE | **Ananya Gupta** |

  Fill the remaining columns (type, author, created_date, last_modified_date, folder_path) with
  plausible older values. The **`owner`** values are the human-managed column the workflow is forbidden
  to overwrite — they must be present before the run or that rule can't be tested.

- **`gaps` tab** → delete all data rows, then restore **exactly this 1 prior row**:

| topic | status | question | domain | blocker | recommended_document | **assignee** |
|---|---|---|---|---|---|---|
| Onboarding checklist for contractors | confirmed gap | (from a previous run) | HR & Policies | | Contractor Onboarding Checklist | **Meera Nair** |

- **`ledger` tab** → delete all data rows. **Headers only.**

## Hard guardrails — never touch these

- ❌ **Never modify, re-create, or re-seed the `Company Knowledge Base` folder or any file in it.**
  Re-seeding regenerates **file ids** (breaking every tracker row and chunk). Editing a file also bumps
  its version, which the idempotency check reads, so an edit could make the next run re-chunk that file.
  Read-only. (Staleness reads each file's stated `Last-Updated:` line, so don't alter those either.)
- ❌ **Never modify the `KB Query Set` sheet** — it is read-only input.
- ❌ Never delete the `Company Knowledge Base` folder, the `Knowledge Base Ops` folder, the `KB Index Tracker`
  or `KB Query Set` sheets, the `knowledge_base` database, the `Workflow test` team, or the
  `Knowledge Base` channel. Clear contents only — never drop the containers.
- ❌ Never delete unrelated messages, files, or collections.
- ❌ Do not "fix" anything you find wrong in the corpus — **report it instead** (see below).

## Then verify the inputs are still pristine

Read (do not edit) and confirm:

- [ ] **Stated `Last-Updated` dates intact** (read from file content, check these three exactly):
      API Design Principles = **2026-01-08** · Procurement Process = **2026-04-10** ·
      Vendor Management Guide = **exactly 2026-04-17**. *If any is missing or changed, the corpus was
      edited or re-seeded — rebuild from `Codex-DummyData-Prompt-236.md`.*
- [ ] **30 unique files / 31 folder entries** — the `System Architecture Overview` shortcut still lives
      in `Product/Specs/Reference/` with the real file in `Engineering/Architecture/`.
- [ ] **3 unparsed files still extract to nothing**: Scanned Network Diagram (image-only PDF),
      Q2 2026 Sales Deck (title slide only), Mobile App Spec (Draft) (no body).
- [ ] **Security Incident Postmortem** is still listable but **not readable** (or note that it was never
      created — the fallback).
- [ ] **4 out-of-scope files** present (`.jpg`, `.mp4`, `.zip`, `.txt`).
- [ ] **KB Query Set › questions** still has **16** rows and **no** answer/domain/confidence columns.
- [ ] **Pets** and **performance reviews** still appear in no document.

If any check fails, **say so and stop** — do not proceed to declare READY.

## Report back

State plainly:
1. Teams: how many messages deleted (0 = "channel was already clean"), and the title of each.
2. MongoDB: `chunks` count **before** and **after** (after must be **15**); `routing_domains` count
   after (must be **0**); confirmation the Sales Playbook chunks carry `last_modified = 2026-04-02`.
3. Tracker: rows removed per tab; confirmation `catalog` = 3 rows with `owner` set, `gaps` = 1 row with
   `assignee` set, `ledger` = headers only.
4. Whether **every** input verification check above passed — if not, exactly which and what you saw.
5. A one-line verdict: **READY for the next model run**, or **NOT READY** with the reason.

Do not leave any local files behind.
