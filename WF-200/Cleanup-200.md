# Codex Prompt — WF-200 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-200 from a clean slate
without re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-200 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-200 Server Action audit run. Delete **only what the run produced**.
The seed data must survive untouched — it is expensive to rebuild and the next run depends on it.

### Do NOT touch (this is the seed)
- The GitHub repo **sahidempiricinfotech-dotcom/next-action-audit** — nothing at all, in any branch.
  The run does not write to the repo; if you find changes there, **stop and report it** rather than
  reverting.
- The Google Sheet **Action Traffic Data** — leave both tabs (`invocations`, `callers`)
  completely alone. The run only reads it.
- The **Jira SAA project itself**, its six components (`web-team`, `admin-team`, `app-team`,
  `payments-team`, `auth-team`, `platform-team`), and these **three seeded tickets**:
  - `Unguarded Server Action: updateBillingProfile in src/actions/billing.ts` (open)
  - `Unguarded Server Action: resetPasswordForUser in src/actions/auth.ts` (open)
  - `Unguarded Server Action: exportOrdersCsv in src/actions/orders.ts` (closed)
- The Teams team **Workflow test** and the channel **server action audit** themselves.
- The Drive folder **Engineering / Server Action Audit**.

### 1) Jira — project `SAA`
- Find every ticket in SAA. The run creates tickets titled
  `Unguarded Server Action: <actionName> in <filePath>` (and the partially-guarded equivalents).
- **Delete every SAA ticket except the three seeded ones listed above.** Match the seeded ones by
  their exact summary — if you seeded them and recorded the keys, match on key instead, which is
  safer.
- The two **open** seeded tickets were *updated in place* by the run (the run refreshes the score,
  verdict, line number and description rather than duplicating). **Restore them to their stale
  "previous run" state**: put back the old description and score, set `updateBillingProfile` back to
  **To Do** and `resetPasswordForUser` back to **In Progress**, and remove any comment, label, or
  link the run added. Do not delete these two.
- Leave the closed `exportOrdersCsv` ticket exactly as it is.
- **Before deleting anything, list what you are about to delete and what you are keeping**, and
  confirm the count of survivors is exactly 3.

### 2) Google Sheet — "Server Action Auth Coverage Matrix"
- Keep the header row (all 25 columns) exactly as-is.
- **Delete every data row except the four seeded prior rows**, which are keyed on file path + action
  name:
  1. `updateBillingProfile` / `src/actions/billing.ts`
  2. `cancelOrder` / `src/actions/orders.ts`
  3. `getBillingProfile` / `src/actions/billing.ts`
  4. `deleteLegacyWebhook` / `src/actions/webhooks.ts`
- Those four rows were **upserted** by the run, so restore their seeded values:
  - All four: `last reviewed` back to **2026-05-20** (rows 1–3) and **2026-04-02** (row 4); restore
    the stale severity score, verdict, models, and Jira link from the seed; clear anything the run
    added to `score breakdown`, `confidence`, `missing controls`, `csrf note`.
  - Row 1: `owner` = **payments-team**, `status` = **In Progress**.
  - Row 2: `owner` = **orders-team**, `status` = **Accepted Risk**.
  - Row 3: `owner` and `status` back to **empty**.
  - Row 4: `status` back to **Open** — the run will have flipped it to **Resolved** with the run date,
    because `src/actions/webhooks.ts` doesn't exist. That flip is the thing being tested, so it has to
    be undone for the next run to test it again.
- Do not delete the sheet and recreate it — the URL is wired into the workflow prompt.

### 3) Microsoft Teams — `Workflow test` > `server action audit`
- Delete the audit summary message the run posted (the one with the action counts, zero-auth
  percentage, and top-10 table). Delete any follow-ups or thread replies under it.
- Leave the channel itself in place.

### 4) Report back
State exactly: how many SAA tickets you deleted and how many survived (must be 3), that the two open
seeded tickets are back to their stale state, how many matrix rows you deleted and that the four
seeded rows are restored to their seeded values, and whether the Teams message was found and deleted.
If the run left anything you couldn't classify as seed-or-output, **name it and leave it alone**
rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-200)

Delete everything WF-200 created, seed included. This is destructive and there is no undo — the repo
and the sheets take a full seed run to rebuild. Confirm that's what you want before running it.

1. **GitHub** — delete the repo **sahidempiricinfotech-dotcom/next-action-audit** entirely.
2. **Google Drive** — delete both Sheets (**Action Traffic Data**, **Server Action Auth
   Coverage Matrix**) and then the folder **Engineering / Server Action Audit** if it is now empty.
   If the folder holds anything you didn't create, leave the folder and say what's in it.
3. **Jira** — delete every ticket in project **SAA**, then the six components, then the project.
   If deleting the project needs admin rights you don't have, delete all the tickets and say so.
4. **Teams** — delete every message in **Workflow test** > **server action audit**, then the channel.
   **Leave the team `Workflow test` itself** — it's shared with WF-092 / WF-109 / WF-138.

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
