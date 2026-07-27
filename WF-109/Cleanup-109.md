# Codex Prompt — WF-109 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-109 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-109 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

> Repo note: the seed repo is **keyurempiricinfotech-art/acme-commerce** (branch `develop`) per
> `Source-109.md` — the authoritative post-seed name. If Codex actually created it as
> `acme-commerce/storefront-api`, use that name instead wherever this file says the repo.

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-109 backend-blueprint run. Delete **only what the run produced**. The
seed data must survive untouched — it is expensive to rebuild and the next run depends on it.

WF-109 is a read-mostly workflow: the run **reads** the Jira ticket and the repo and produces three
outputs — a blueprint Google Doc, a structured Jira comment plus status flips on the selected ticket,
and a Teams message. The only seed it *changes* is the selected ticket's status, so the only thing to
restore is that ticket.

### Do NOT touch (this is the seed)
- The GitHub repo **keyurempiricinfotech-art/acme-commerce** — nothing at all, in any branch. The run
  only *reads* the code; if you find changes there, **stop and report it** rather than reverting. The
  deliberately-absent Reviews feature (no `reviews`/`review_votes` tables, no Review model/controller,
  no `rating_avg`/`rating_count` on `products`) and the deliberate risk hooks (the N+1 product listing,
  the product-read cache, Sanctum + policies, `/api/v1` versioning) are all seed — leave them.
- **Every Jira issue in project `API` except for the status/comment changes on the primary ticket**:
  the decoys (the 2–3 lower-priority backend issues, the frontend-only issue, the under-specified
  issue) must stay exactly as seeded, unassigned.
- The Drive folder **Engineering / Backend Blueprints** itself.
- The Teams team **Workflow test** and channel **Workflow test** themselves.

### 1) Jira — project `API`, reset the selected ticket
- Find the primary ticket **"Product Reviews & Ratings API"** (the highest-priority backend/API issue
  the run selects).
- **Revert its status back to `To Do`.** The run flips it `To Do` → `In Progress` (on selection) →
  `In Review` (on completion); set it back to **To Do** so the next run re-selects it cleanly.
- **Delete the structured comment the run added** — the one with the architecture summary, files-
  impacted count, DB changes, APIs, risk level/complexity, and the blueprint Doc link. Leave any
  seeded comments (the proposed API contract comment and the client-requirement comment) **intact**.
- Do not touch the ticket's description, acceptance criteria, seeded comments, design link/attachment,
  or the linked frontend task. Leave it unassigned.
- **Before changing anything, confirm you have the right ticket** (the well-scoped Reviews Story), and
  report the status it was in when you found it.

### 2) Google Drive — the blueprint Doc
- Delete the blueprint Google Doc the run created in **Engineering / Backend Blueprints**, titled
  **"Product Reviews & Ratings API Backend Implementation Blueprint"** (title = the selected issue
  summary + "Backend Implementation Blueprint"). The folder should end up **empty** again. If it holds
  anything that isn't that blueprint, leave it and say what's there.

### 3) Microsoft Teams — `Workflow test` > `Workflow test`
- Delete the message the run posted, which starts with the header
  **"Backend blueprint ready: Product Reviews & Ratings API"** (feature name, summary, key concerns,
  deliverables, doc link), plus any thread replies under it.
- Leave the channel itself in place. (WF-109 seeds **no** Teams thread of its own, so there is nothing
  else of WF-109's to preserve here — but do not delete other workflows' messages.)

### 4) Report back
State exactly: that the primary ticket is back to **To Do** and its run-added structured comment is
deleted (seeded comments intact); that the blueprint Doc was found and deleted and the folder is empty;
that the Teams "Backend blueprint ready" message was found and deleted; and that the repo and all decoy
issues were left untouched. If the run left anything you couldn't classify as seed-or-output, **name it
and leave it alone** rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-109)

Delete everything WF-109 created, seed included. This is destructive and there is no undo — the repo
and the Jira issues take a full seed run to rebuild. Confirm that's what you want before running it.

1. **GitHub** — delete the repo **keyurempiricinfotech-art/acme-commerce** entirely. (If it was seeded
   under `acme-commerce/storefront-api`, delete that one.)
2. **Google Drive** — delete the blueprint Doc, then the folder **Engineering / Backend Blueprints**
   if it is now empty. If the folder holds anything you didn't create, leave it and say what's in it.
3. **Jira** — delete/archive every issue in project **API** (the primary + all decoys). Delete the
   project itself only if you're certain nothing else uses it; if unsure, clear the WF-109 issues and
   say so.
4. **Teams** — delete the run's message in **Workflow test** > **Workflow test**, then the channel
   **if it is not the team's default/General channel** (Teams won't let you delete the default one — if
   so, just clear the messages). **Leave the team `Workflow test` itself** — it is shared with many
   other workflows (WF-052 / WF-092 / WF-138 / WF-236 / WF-239 / WF-297 and more).

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
