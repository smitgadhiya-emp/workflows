# Codex Prompt — WF-297 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-297 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-297 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-297 realtime connection-budget run. Delete **only what the run
produced**. The seed data must survive untouched — it is expensive to rebuild and the next run depends
on it.

### Do NOT touch (this is the seed)
- The GitHub repo **smitempiricinfotech-wq/realtime-app** — nothing at all, in any branch. The run
  only *reads* the repo; if you find changes there, **stop and report it** rather than reverting.
  In particular do **not** "fix" anything you find: the missing teardown in `MetricsPanel.tsx` and
  `TaskRow.tsx`, the unreachable `LiveCursors.tsx`, the runtime-string dynamic import behind
  `OldPresence.tsx`, and the fake service-role key in `createIsolatedClient.ts` are all **deliberate
  seed**. Leave every one of them exactly as it is.
- The Google Sheet **Realtime Usage Data** — leave all four tabs (`monthly`, `monthly_peaks`,
  `daily_peaks`, `feature_usage`) completely alone. The run only reads it. Do **not** add a
  projects-per-user or tasks-per-project column — its absence is the test.
- The Teams team **Workflow test** and the channel **Engineering Capacity** themselves.
- The Drive folder **Engineering / Capacity Planning**.

### 1) Google Sheet — "Realtime Connection Budget"
Keep all four tabs and their header rows exactly as-is. On each tab, **delete every data row except
the seeded prior rows**, then restore those rows to their seeded values (the run will have upserted
them).

**Tab `subscriptions`** — keep exactly **3** rows, keyed on `file path`:
1. `hooks/useNotifications.ts` — restore the stale details; `owner` = **platform-team**.
2. `components/dashboard/MetricsPanel.tsx` — `owner` = **web-team**, and put `teardown present` back to
   **yes**. It is *wrong* (the file leaks) and that is the point — the run corrects it, so undo the
   correction for the next run.
3. `components/legacy/RemovedWidget.tsx` — restore it, `owner` empty, and clear whatever the run wrote
   into `notes` (it will have marked it stale/removed, since that file isn't in the repo).

Delete every other subscriptions row the run added (there will be ~14 more).

**Tab `sessions`** — keep exactly **2** rows, keyed on `pattern name`:
1. `Logged-in baseline` — back to `channels per session` **4**, `sockets per session` **1**,
   `owner` = **platform-team**.
2. `Chat user` — back to `channels per session` **2**, `sockets per session` **1** (the run will have
   corrected this to 2 — undo it), `owner` empty.

Delete every other sessions row the run added.

**Tab `plan model`** — keep exactly **2** rows, keyed on `tier`, restored to their stale values:
1. `Pro` — limit 500, fixed overhead **0**, sockets per session **1**, sessions **500**, users **500**,
   MAU trigger **20000**.
2. `Team` — limit 10000, fixed overhead **0**, sockets per session **1**, sessions **10000**, users
   **10000**, MAU trigger **400000**.

**Tab `assumptions`** — keep exactly **1** row: the old settled assumption (`Settled`,
`owner` = platform-team). Delete every assumption/unresolved row the run added.

Do not delete the sheet and recreate it — the URL is wired into the workflow prompt.

### 2) Microsoft Teams — `Workflow test` > `Engineering Capacity`
- Delete the summary message the run posted (commit sha, sockets/channels per session, Pro concurrent
  ceiling, MAU upgrade trigger, leaks, sheet link, and any "Assumption, Not Measured" block). Delete
  any follow-ups or thread replies under it.
- Leave the channel itself in place.

### 3) Report back
State exactly: how many rows you deleted from each of the four tabs and that the seeded counts are back
to **3 / 2 / 2 / 1**; that the human `owner` values are restored on `useNotifications`, `MetricsPanel`
and `Logged-in baseline`; that `MetricsPanel`'s `teardown present` is back to the (deliberately wrong)
**yes** and `Chat user`'s `sockets per session` is back to **1**; that the repo and the usage sheet were
not modified; and whether the Teams message was found and deleted. If the run left anything you
couldn't classify as seed-or-output, **name it and leave it alone** rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-297)

Delete everything WF-297 created, seed included. This is destructive and there is no undo — the repo
and the sheets take a full seed run to rebuild. Confirm that's what you want before running it.

1. **GitHub** — delete the repo **smitempiricinfotech-wq/realtime-app** entirely.
2. **Google Drive** — delete both Sheets (**Realtime Usage Data**, **Realtime Connection Budget**) and
   then the folder **Engineering / Capacity Planning** if it is now empty. If the folder holds anything
   you didn't create, leave the folder and say what's in it.
3. **Teams** — delete every message in **Workflow test** > **Engineering Capacity**, then the channel.
   **Leave the team `Workflow test` itself** — it's shared with WF-092 / WF-109 / WF-138 / WF-200 /
   WF-206 / WF-236 / WF-237 / WF-239.

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
