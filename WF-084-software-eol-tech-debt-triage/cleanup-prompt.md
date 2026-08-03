# WF-048 — Cleanup / reset prompt (run FIRST, before each run)

Run this once before each run (and before each model when you compare A/B/C) so every run starts on a clean,
identical set of destinations. WF-048 is **no-seed / live** (it reads the live endoflife.date API), so there's no
fixture data to rebuild, just three destination apps to clear of the prior run's output: the "Tech Debt Tracker"
sheet, the Notion `TECHDEBT` database, and the `platform` Teams digest. Paste it into Codex with Google Sheets +
Notion + Microsoft Teams connected (or browser control on a demo account). It only clears, it never creates
anything.

> **Why this is strict.** The Codex Notion connector often silently no-ops on page deletes, and stale rows from a
> prior run make the next model just verify old data instead of doing the sweep. So this empties Notion to a
> **verified zero** and tells you exactly what it could not remove so you can finish by hand. (Background: the
> project memory note *notion-cleanup-doesnt-empty-db*.)

```
I need you to reset the destinations for a software end-of-life tech-debt test before I run it again. This is a
test workspace, the entries are invented output from earlier runs, nothing real, so you can delete freely. Do all
of the below and give me a short status line per app at the end. Do not create or seed anything in this step, this
is cleanup only.

1) Google Drive - the tracker sheet. Find every Google Sheet called "Tech Debt Tracker". There may be more than
one from earlier runs. Move all of them to trash so none are left. If you cannot delete one, then instead clear
the "EOL Sweep" tab completely, every row including the header, so it is fully empty, and give me its link. End
state I want: either no sheet by that name exists, or exactly one and its "EOL Sweep" tab is empty. Tell me which
it is and how many you found.

2) Notion. Open the database called "TECHDEBT" that holds the upgrade-planning entries a run files. Delete or
archive every page in it so the database is completely empty, zero pages. Do not delete the database itself, just
empty it. After you think it is empty, list it again and confirm the page count is zero. If the connector will
not let you delete some pages, do not pretend it worked, tell me the exact titles of the pages still in there so I
can remove them by hand. If no TECHDEBT database exists yet, just say so.

3) Microsoft Teams. In the "platform" channel, delete the sweep digest post an earlier run put up, so the channel
is clear of it. Leave the channel itself in place. If you cannot delete a message, tell me which ones are still
there. If the channel does not exist yet, say so.

When you are done, report exactly: how many "Tech Debt Tracker" sheets you found and their final state, the
Notion TECHDEBT page count now (it must be zero), and whether the Teams platform channel is clear. If any app is
not connected or you cannot reach it, say so and carry on, do not guess or invent anything.
```

## After running this

- Confirm in the reply: **no** "Tech Debt Tracker" sheet (or one with an empty "EOL Sweep" tab), **TECHDEBT Notion
  database = 0 pages**, Teams **platform** channel clear.
- If it reports anything it could not delete, **remove those by hand now** before you run, especially the
  **Notion** pages (the connector regularly cannot delete them). When a later model reports "verified existing
  entries, avoided duplicates", that is the tell the DB was not actually emptied.
- Then run [`seed-prompt.md`](seed-prompt.md) to make sure the empty destinations exist, and run **Part B** from
  the main file. (WF-048 has no seeded data, reproducibility comes from the pinned reference date + inventory in
  Part B.)
