# Codex Prompt — WF-237 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-237 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-237 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-237 MERN docs-assistant run. Delete **only what the run produced**. The
seed data must survive untouched — it is expensive to rebuild and the next run depends on it.

### Do NOT touch (this is the seed)
- The GitHub repo's **`main` branch** and everything on it — the MERN skeleton, `package.json`,
  lockfiles, `docker-compose.yml`, `server/`, `client/`, `README.md`. The version pins **and the five
  deliberately-wrong code files (C1–C5: `db.js`, `orders.js`, `userRepo.js`, `auth.js`, `LiveFeed.jsx`)
  are seed** — the workflow only *reports* on them, it does not fix them, so leave the code exactly as
  it is. **Do not "fix" any of those bugs during cleanup.** If you find the run actually pushed a code
  change to `main`, **stop and report it** rather than reverting blindly.
- The **Dev Questions Log** Sheet's seeded rows: every question Q01–Q29 and QX1–QX4 in the Questions
  tab (the question text, date, asked-by, category hint), and the seeded prior-run state on Q04, Q16,
  G-001, G-002.
- The Teams team **Workflow test** and the channel **docs assistant** themselves.
- The Drive folder **Engineering / Docs Assistant**.

### 1) GitHub — the corpus pull request
- Find the pull request the run opened against `main` — it adds the **`docs-corpus/`** folder (corpus
  markdown). **Close it without merging** and **delete its branch** (the corpus/docs branch).
- If the PR was already merged, **revert the merge** so `docs-corpus/` is removed from `main`, then
  delete the branch. Confirm `main` has **no `docs-corpus/` folder** afterward.
- Do not touch any other branch or the skeleton on `main`.

### 2) Google Sheet — "Dev Questions Log", tab **Questions**
- Keep the header row and every seeded question row (Q01–Q29, Q30–Q36, QX1–QX4) — do not delete rows.
- For every row **except the three prior-run rows (Q04, Q16, Q30)**, **clear the workflow's output
  columns**: `routed to`, `answer`, `sources`, `versions covered`, `confidence`, `code contradiction`,
  `duplicate of`, `answered date`, `status`. Leave `question id`, `date logged`, `asked by`,
  `question`, `category hint`, and `human notes` exactly as seeded.
- For **Q04 and Q16**, restore them to their **stale prior-run state**: put back the seeded stale
  answer (Q04's Express-5-style answer, Q16's plausible prior answer), `confidence` = High,
  `routed to` as seeded, `answered date` = **2026-05-22**, empty `code contradiction` and
  `duplicate of`, and **leave the `human notes` cell exactly as it is** (Ravi's Express-4 note on Q04,
  Priya's runbook note on Q16). The run will have overwritten the answers — undo that so the next run
  tests the update again — but never touch the notes.
- For **Q30**, restore its seeded **consolidated** state: `duplicate of` = **Q01**, `status` =
  **consolidated**, `answered date` = **2026-05-22**, and `answer` / `code contradiction` empty. The
  run may have re-answered or re-pointed it — undo that so the next run tests consolidation idempotency.

### 3) Google Sheet — tab **Knowledge Gaps**
- Keep the header row and the two seeded prior rows **G-001** and **G-002**.
- **Delete every gap row the run added** (anything beyond G-001 and G-002).
- Restore G-001 and G-002 to their seeded state: `last updated` = **2026-05-22**, seeded priority and
  `status` = Open, and **leave G-001's human note in place**. The run will have updated priority /
  status / last-updated on these two — undo that so the next run tests the update-not-duplicate path.

### 4) Microsoft Teams — `Workflow test` > `docs assistant`
- Delete the summary message the run posted (counts of confident answers vs gaps, the code-vs-docs
  disagreement count, the version conflicts, and the PR + sheet links). Delete any follow-ups or
  thread replies under it.
- Leave the channel itself in place.

### 5) Report back
State exactly: whether the corpus PR was found and closed (and the branch deleted, and `main` is free
of `docs-corpus/` **and the five seeded code bugs are still present, untouched**); how many Questions
rows you cleared and that Q04/Q16 are back to their stale state and Q30 is back to consolidated-into-Q01,
all with notes intact; how many Gaps rows you deleted and that G-001/G-002 are restored with G-001's
note intact; and whether the Teams message was found and deleted. If the run left anything you couldn't
classify as seed-or-output, **name it and leave it alone** rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-237)

Delete everything WF-237 created, seed included. This is destructive and there is no undo — the repo
and the Sheet take a full seed run to rebuild. Confirm that's what you want before running it.

1. **GitHub** — delete the repo **sahidempiricinfotech-dotcom/mern-docs-assistant** entirely (this
   removes the skeleton and any corpus PR/branch with it).
2. **Google Drive** — delete the **Dev Questions Log** Sheet (both tabs go with it), then the folder
   **Engineering / Docs Assistant** if it is now empty. If the folder holds anything you didn't
   create, leave the folder and say what's in it.
3. **Teams** — delete every message in **Workflow test** > **docs assistant**, then the channel.
   **Leave the team `Workflow test` itself** — it's shared with WF-092 / WF-109 / WF-138 / WF-200 /
   WF-206.

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
