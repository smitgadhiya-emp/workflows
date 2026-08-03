# WF-079 — Cleanup / reset prompt (run FIRST, before each re-seed)

Run this once before you re-seed, and again before each model when you compare A/B/C, so every run starts on a
clean, identical workspace. It clears the seeded repo (the "orders-platform" repo, its branch and PR) plus
everything a run produces: the PR review, the coordination issues, the API-CHANGES Notion entries and the platform
Teams digest. Paste it into Codex with the **GitHub** connector + Notion + Microsoft Teams connected (or browser
control on a demo account). It only clears, it never creates anything.

> **Why this is strict.** Two lessons baked in. (1) A run opens issues and a PR review that a later model would
> otherwise "verify" instead of redoing. (2) The Codex Notion connector often silently no-ops on page deletes. So
> this deletes the whole seeded repo (cleanest reset for a code test-bed), empties Notion to a **verified zero**,
> and tells you exactly what it could not remove so you can finish by hand before seeding. (Background: the project
> memory note *notion-cleanup-doesnt-empty-db*.)

```
I need you to fully reset a test workspace before I re-seed it. Everything here is invented test data for an
API breaking-change review task, nothing real, so you can delete freely. Do all of the below and then give
me a short status line per app at the end. Do not seed or create any new test data in this step, this is
cleanup only.

1) GitHub - the test repo. Find the repository called "orders-platform" on my account. Delete the whole
repo (that's the cleanest reset and it takes the seeded spec, the consumer folders, the evolve-orders-api
branch, the open PR, the PR review and any coordination issues with it). If you can't delete the repo, then
instead: close the "Evolve Orders API" pull request without merging, delete the evolve-orders-api branch,
close every open issue that references that PR, and delete any review comments a run left, and tell me the
repo link and what's left. End state I want: either no "orders-platform" repo exists, or one with just a
clean main branch, no open PR, no open issues. Tell me which it is.

2) Notion. Open the database called "API-CHANGES" that holds the review entries a run files. Delete or
archive every page in it so the database is completely empty, zero pages. Do not delete the database
itself, just empty it. After you think it's empty, list it again and confirm the page count is zero. If the
connector won't let you delete some pages, don't pretend it worked, tell me the exact titles of the pages
still in there so I can remove them by hand. If no API-CHANGES database exists yet, just say so.

3) Microsoft Teams. In the "platform" channel, delete the review digest post an earlier run put up (the
go/no-go / breaking-changes / cleared-safe summary), so the channel is clear of it. Leave the channel
itself in place. If you can't delete a message, tell me which ones are still there. If the channel doesn't
exist yet, say so.

When you're done, report exactly: the final state of the "orders-platform" repo (deleted, or reset to a
clean main with no PR/issues), the Notion API-CHANGES page count now (it must be zero), and whether the
Teams platform channel is clear. If any app isn't connected or you can't reach it, say so and carry on,
don't guess or invent anything.
```

## After running this
- Confirm in the reply: **no** "orders-platform" repo (or one reset to a clean main, no open PR, no open
  issues), **API-CHANGES Notion database = 0 pages**, Teams **platform** channel clear.
- If it reports anything it couldn't delete, **remove those by hand now** before you seed, especially the
  **Notion** pages (the connector regularly can't delete them) and any lingering open issues on the repo. When
  a later model reports "verified existing entries, avoided duplicates", that's the tell the DB wasn't actually
  emptied.
- Then run [`seed-prompt.md`](seed-prompt.md) to rebuild the fixed scenario.
