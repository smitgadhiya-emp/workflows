# Codex Prompt — WF-092 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and leaves the seed exactly as it was, so you can re-run WF-092 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-092 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-092 browser/device test-prioritization run. Delete **only what the run
produced**. The seed data must survive untouched — it is expensive to rebuild and the next run depends
on it.

WF-092 is simpler to reset than most: the run **only reads** the seed and **creates four new outputs**
(a matrix Sheet, ~12 Jira test tasks, a QA report Doc, a Teams summary). It does not edit any seeded
sheet, doc, or issue in place — so there is nothing to "restore", only outputs to delete.

### Do NOT touch (this is the seed)
- The three **mock-source Google Sheets** in `QA / Release 4.2 Notes`, read-only to the run:
  - **WF-092 GA4 Export – Acme Storefront 4.2.0**
  - **WF-092 Clarity Export – Acme Storefront 4.2.0**
  - **WF-092 GitHub Changes – storefront v4.1.0→v4.2.0**
- The two seeded **Google Docs**: **Release 4.2 QA Notes** and **Browser Support Policy**.
- The seeded **Jira issues in project WEB** — the ~12 release-scope stories/tasks + ~8 bug fixes
  (fixVersion 4.2.0) and the 18–26 browser-compat/regression bug-history issues. The run does **not**
  modify these; if you find edits, **stop and report it** rather than reverting.
- The seeded **Teams discussion thread** in `Workflow test` > `Workflow test` (the 6–10 messages from
  named people about Release 4.2 browser risks). Leave every one of those messages.
- The Drive folder **QA / Release 4.2 Notes**, the Teams team **Workflow test**, and the channel
  **Workflow test** themselves.

### 1) Jira — project `WEB`, delete only the run's test tasks
- The run creates **one Jira task per ranked browser/device combo** (~12), each labeled
  **`browser-testing`**, **`release-testing`**, and a priority label. **Delete (or archive) every WEB
  issue carrying the `browser-testing` label** — that label is the reliable marker of run output; no
  seeded issue has it (seeded issues use `browser-compat` / `regression` / `frontend` / `css` etc.).
- **Do not delete any issue without `browser-testing`** — those are seed (release scope + bug history).
- **Before deleting anything, list what you are about to delete and confirm none of them are seeded
  release-scope or bug-history issues.** Expect ~12 deletions.

### 2) Google Sheet — the test matrix
- Delete the Sheet **`Release Browser Test Matrix 4.2.0`** from `QA / Release 4.2 Notes`. Do **not**
  touch the three `WF-092 …` mock-source sheets.

### 3) Google Doc — the QA report
- Delete the QA report Doc the run created in `QA / Release 4.2 Notes` (usage summary, device split,
  high-risk browsers, recommended testing order, overall compatibility risk). It is **not** one of the
  two seeded docs — match it by content/recency and confirm it is not `Release 4.2 QA Notes` or
  `Browser Support Policy` before deleting. The prompt doesn't fix its title, so if a run named it
  differently, identify it by being a run-authored QA/browser report.

### 4) Microsoft Teams — `Workflow test` > `Workflow test`
- Delete the **single summary message the run posted** (critical testing order, highest-risk areas,
  the count of Jira tasks created, and links to the matrix Sheet and the QA report Doc), plus any
  thread replies under it.
- **Leave the seeded discussion thread alone** — those 6–10 messages are seed. If you can't tell the
  run's summary from the seeded thread, the summary is the one that lists a Jira-task count and links
  to the matrix/report; the seeded ones are a casual back-and-forth with no such links.

### 5) Report back
State exactly: how many WEB test tasks you deleted (all `browser-testing`, ~12) and that no seeded
release-scope or bug-history issue was touched; that the `Release Browser Test Matrix 4.2.0` Sheet and
the QA report Doc were found and deleted while the three mock sheets and two seeded Docs remain; and
whether the run's Teams summary was found and deleted while the seeded thread was left intact. If the
run left anything you couldn't classify as seed-or-output, **name it and leave it alone** rather than
guessing.

---

## Mode B — Full teardown (only when you're finished with WF-092)

Delete everything WF-092 created, seed included. This is destructive and there is no undo — the sheets,
docs, and Jira state take a full seed run to rebuild. Confirm that's what you want before running it.

1. **Google Drive** — in `QA / Release 4.2 Notes`, delete the matrix Sheet (`Release Browser Test
   Matrix 4.2.0`), the QA report Doc, the three mock-source Sheets (`WF-092 GA4 Export …`,
   `WF-092 Clarity Export …`, `WF-092 GitHub Changes …`), and the two seeded Docs (`Release 4.2 QA
   Notes`, `Browser Support Policy`). Then delete the folder **QA / Release 4.2 Notes** if it is now
   empty; if it holds anything you didn't create, leave the folder and say what's in it.
2. **Jira** — delete/archive every WF-092 issue in project **WEB**: the ~12 run test tasks
   (`browser-testing`), the ~12 release-scope stories + ~8 bug fixes (fixVersion 4.2.0), and the
   18–26 browser-compat/regression bug-history issues. **Do NOT delete the WEB project itself** unless
   you're certain no other work uses it — it's a generic key; if unsure, clear the WF-092 issues and
   say so.
3. **Teams** — delete every message in **Workflow test** > **Workflow test** (the seeded thread and the
   run summary), then the channel **if it is not the team's default/General channel** (Teams won't let
   you delete the default one — if so, just clear the messages). **Leave the team `Workflow test`
   itself** — it is shared with many other workflows (WF-052 / WF-138 / WF-206 / WF-236 / WF-239 /
   WF-297 and more).

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
