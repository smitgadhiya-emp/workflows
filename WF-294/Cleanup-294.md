# Codex Prompt — WF-294 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-294 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-294 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-294 Notion knowledge-audit run. Delete **only what the run produced**.
The seed data must survive untouched — the workspace is expensive to rebuild and the next run depends
on it.

### Do NOT touch (this is the seed)
- The **Acme Knowledge Base** Notion workspace and all of it — every cluster, the synced block (C3),
  the drifted databases (C6), the boilerplate pair, the singletons, and every page's schema. The run
  only **reads** Notion; if you find a page changed, merged, or deleted, **stop and report it** rather
  than fixing it.
- The Google Sheet **Workspace Activity Log** — leave it completely alone. The run only reads it.
- The Google Doc **Knowledge Architecture Report** as a file (its body gets reset — see below).
- The **Knowledge Redundancy Map** Sheet as a file (its rows get reset — see below).
- The **Linear team KA itself** and these **three seeded issues**:
  - `Consolidate knowledge cluster: onboarding process (4 copies)` (open)
  - `Consolidate knowledge cluster: expense policy (3 copies)` (open)
  - `Consolidate knowledge cluster: vacation policy (2 copies)` (closed)
- The Teams team **Workflow test** and the channel **knowledge audit** themselves.
- The Drive folder **Engineering / Knowledge Audit**.

### 1) Linear — team `KA`
- Find every issue in KA. The run creates one issue per cluster titled
  `Consolidate knowledge cluster: <name> (<n> copies)`.
- **Delete (or archive) every KA issue except the three seeded ones above.** Match on exact title, or
  on the issue ids if you recorded them (safer).
- The two **open** seeded issues were *updated in place* by the run. **Restore them to their stale
  "previous run" state**: put back the old body (stale members/canonical/hours), set both back to their
  seeded state, and remove any comment, label, or link the run added. Do not delete these two.
- Leave the closed `vacation policy` issue exactly as it is.
- **Before deleting anything, list what you are about to delete and what you are keeping**, and confirm
  the count of survivors is exactly 3.

### 2) Google Sheet — "Knowledge Redundancy Map"
- Keep the header row (all 16 columns) exactly as-is.
- **Delete every data row except the three seeded prior rows**: cluster **C1**, cluster **C2**, and the
  **ghost cluster** (its member pages don't exist).
- Those rows were **upserted** by the run, so restore their seeded values:
  - C1 and C2: `last reviewed` back to **2026-05-20**; restore the stale similarity scores, hours,
    canonical pick and rule, Linear link; clear anything the run added to `pairwise similarity scores`,
    `schema drift`, `edit events`, `duplicate locations`, `confidence`.
  - C1: `owner` = **platform-team**, `decision` = **Merge into wiki A**.
  - C2: `owner` = **ops-team**, `decision` = **Keep both for now**.
  - Ghost cluster: `last reviewed` back to **2026-04-02** and its seeded stale data; the run will have
    flipped it to **Resolved** with the run date because its pages don't exist — undo that so the next
    run tests the Resolved path again.
- Do not delete the sheet and recreate it — its URL is wired into the workflow prompt.

### 3) Google Doc — "Knowledge Architecture Report"
- The run **replaced the whole body** with the current consolidation plan. **Restore the seeded stale
  prior body** (the short old plan referencing only two clusters, older dates). Do not delete the doc —
  its URL is wired into the workflow prompt.

### 4) Microsoft Teams — `Workflow test` > `knowledge audit`
- Delete the summary message the run posted (pages crawled, cluster count, SSoT-gap count, total hours,
  top-10 by cost, issues opened vs updated, doc + sheet links). Delete any follow-ups or thread replies.
- Leave the channel itself in place.

### 5) Report back
State exactly: how many KA issues you deleted and how many survived (must be 3), that the two open
seeded issues are back to their stale state; how many redundancy-map rows you deleted and that C1/C2 are
restored with owner+decision intact and the ghost cluster is back to its stale (non-Resolved) state;
that the architecture doc is back to its stale prior body; and whether the Teams message was found and
deleted. If the run left anything you couldn't classify as seed-or-output, **name it and leave it
alone** rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-294)

Delete everything WF-294 created, seed included. This is destructive and there is no undo — the Notion
workspace takes a full seed run to rebuild. Confirm that's what you want before running it.

1. **Notion** — delete every page and database in **Acme Knowledge Base** that the seed created (all
   clusters, boilerplate pair, singletons). If the workspace itself is shared/reused, empty the seeded
   content rather than deleting the workspace, and say so.
2. **Google Drive** — delete the two Sheets (**Workspace Activity Log**, **Knowledge Redundancy Map**)
   and the Doc (**Knowledge Architecture Report**), then the folder **Engineering / Knowledge Audit** if
   it is now empty. If the folder holds anything you didn't create, leave it and say what's in it.
3. **Linear** — delete/archive every issue in team **KA**, then the team itself. If deleting the team
   needs admin rights you don't have, clear the issues and say so.
4. **Teams** — delete every message in **Workflow test** > **knowledge audit**, then the channel.
   **Leave the team `Workflow test` itself** — it's shared with WF-092 / WF-109 / WF-138 / WF-200 /
   WF-206 / WF-236 / WF-237 / WF-239.

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
