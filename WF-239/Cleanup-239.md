# Codex Prompt — WF-239 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-239 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-239 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-239 CORS audit run. Delete **only what the run produced**. The seed data
must survive untouched — it is expensive to rebuild and the next run depends on it.

### Do NOT touch (this is the seed)
- The GitHub repo **sahidempiricinfotech-dotcom/cors-audit** — nothing at all, in any branch. The run
  does not write to the repo; if you find changes there, **stop and report it** rather than reverting.
  The three-layer CORS config (including R01's Nginx `add_header` drop) is seed — leave it exactly as
  it is; do not "fix" any CORS gap.
- The Google Sheet **CORS Request Logs** — leave the Requests tab completely alone. The run only reads
  it.
- The **Linear team CORS itself** and these **three seeded issues**:
  - `CORS gap on POST /api/orders` (open)
  - `CORS gap on POST /api/checkout` (open)
  - `CORS gap on GET /api/products` (closed)
- The Teams team **Workflow test** and the channel **cors audit** themselves.
- The Drive folder **Engineering / CORS Audit**.

### 1) Linear — team `CORS`
- Find every issue in the CORS team. The run creates one issue **per route** titled
  `CORS gap on <METHOD> <route>`.
- **Delete (or archive) every CORS issue except the three seeded ones listed above.** Match the seeded
  ones by their exact title — if you seeded them and recorded the issue IDs, match on ID instead, which
  is safer.
- The two **open** seeded issues were *updated in place* by the run (it refreshes the effective policy,
  gaps and score rather than duplicating). **Restore them to their stale "previous run" state**: put
  back the old description and score, set both back to their seeded state (e.g. `POST /api/orders` →
  Todo, `POST /api/checkout` → Todo/In Progress as seeded), and remove any comment, label, or link the
  run added. Do not delete these two.
- Leave the closed `GET /api/products` issue exactly as it is.
- **Before deleting anything, list what you are about to delete and what you are keeping**, and confirm
  the count of survivors is exactly 3.

### 2) Google Sheet — "CORS Effective Policy Audit"
- Keep the header row (all 17 columns) exactly as-is.
- **Delete every data row except the four seeded prior rows**, keyed on route + method:
  1. `POST` / `/api/orders`
  2. `GET` / `/api/products`
  3. `POST` / `/api/login`
  4. `DELETE` / `/api/legacy-webhook`
- Those four rows were **upserted** by the run, so restore their seeded values:
  - All four: `last reviewed` back to **2026-05-20** (rows 1–3) and **2026-04-02** (row 4); restore the
    stale effective policy, gap types, exposure score, breakdown and Linear link from the seed; clear
    anything the run added to `resolved effective policy`, `winning layer per header`, `confidence`,
    `origins seen`, `request count`.
  - Row 1 (`/api/orders`): `owner` = **infra-team**, `status` = **In Progress**.
  - Row 2 (`/api/products`): `owner` = **web-team**, `status` = **Accepted Risk**.
  - Row 3 (`/api/login`): `owner` and `status` back to **empty**.
  - Row 4 (`/api/legacy-webhook`): `status` back to **Open** — the run will have flipped it to
    **Resolved** with the run date because that route doesn't exist in the code. That flip is the thing
    being tested, so undo it for the next run.
- Do not delete the sheet and recreate it — the URL is wired into the workflow prompt.

### 3) Microsoft Teams — `Workflow test` > `cors audit`
- Delete the summary message the run posted (route count, per-gap-type counts, wildcard-on-auth
  callout, top-10 by score, dead/blocked origin counts, and the sheet link). Delete any follow-ups or
  thread replies under it.
- Leave the channel itself in place.

### 4) Report back
State exactly: how many CORS issues you deleted and how many survived (must be 3), that the two open
seeded issues are back to their stale state, how many audit-sheet rows you deleted and that the four
seeded rows are restored to their seeded values (including `/api/legacy-webhook` back to Open), and
whether the Teams message was found and deleted. If the run left anything you couldn't classify as
seed-or-output, **name it and leave it alone** rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-239)

Delete everything WF-239 created, seed included. This is destructive and there is no undo — the repo
and the sheets take a full seed run to rebuild. Confirm that's what you want before running it.

1. **GitHub** — delete the repo **sahidempiricinfotech-dotcom/cors-audit** entirely.
2. **Google Drive** — delete both Sheets (**CORS Request Logs**, **CORS Effective Policy Audit**) and
   then the folder **Engineering / CORS Audit** if it is now empty. If the folder holds anything you
   didn't create, leave the folder and say what's in it.
3. **Linear** — delete/archive every issue in the CORS team, then the team itself. If deleting the team
   needs admin rights you don't have, clear all the issues and say so.
4. **Teams** — delete every message in **Workflow test** > **cors audit**, then the channel. **Leave
   the team `Workflow test` itself** — it's shared with WF-092 / WF-109 / WF-138 / WF-200 / WF-206 /
   WF-237.

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
