# WF-048 — Seed / setup prompt (run AFTER cleanup, BEFORE the eval)

WF-048 is **no-seed / live** by design: the agent reads the real endoflife.date API at run time, and
reproducibility comes from the **pinned reference date (2025-06-01) + the named 15-item inventory** in Part B, not
from fixture data. So there's nothing to "seed", this prompt just makes sure the three empty **destinations**
exist for the run to write into. Run it after [`cleanup-prompt.md`](cleanup-prompt.md) and before the eval (Part B
in the [main file](WF-048-software-eol-tech-debt-triage.md)). Paste into Codex with Google Sheets + Notion +
Microsoft Teams connected. If you'd rather let the run create the sheet itself, you can skip step 1, the eval
writes to "Tech Debt Tracker" / "EOL Sweep" straight in.

```
Set up the empty destinations for a software end-of-life tech-debt run. Don't put any data in them, I just want
the containers ready. Do the three things below and tell me the links when you're done.

1) Make a Google Sheet called "Tech Debt Tracker" in my Google Drive with a single tab named "EOL Sweep". Put a
header row on it with these columns: Product, Version, Where It Runs, Active Support End, EOL Date, Status, Tier,
Reason. Leave it at just the header, no data rows. If a sheet by that name already exists, confirm it and leave
the "EOL Sweep" tab empty (header only).

2) In Notion, make sure there's a database called "TECHDEBT" with properties for status, priority and type. Leave
it empty, no pages. If a TECHDEBT database already exists, confirm it and leave its contents alone (it should be
empty after the cleanup step).

3) In Microsoft Teams, make sure there's a channel called "platform". Create it if it's not there. Leave it
empty.

When you're done, tell me: the link to the Tech Debt Tracker sheet, confirmation the TECHDEBT Notion database
exists and is empty, and confirmation the platform Microsoft Teams channel exists.
```

## Note on "no seed"

There is no planted answer key. The lifecycle dates are live on endoflife.date, and the grade comes from looking
the same 15 inventory items up against the same pinned reference date and spot-checking the agent's status
buckets and tiers (see "Grading / how to check" in the main file). The inventory the agent sweeps is named inside
Part B, not seeded here.

## After running this

- Confirm: **Tech Debt Tracker sheet exists** with an empty "EOL Sweep" tab (header only), **TECHDEBT Notion
  database exists and is empty**, **platform Teams channel exists and is empty**.
- Then paste **Part B** from the [main file](WF-048-software-eol-tech-debt-triage.md) as the eval prompt, and
  capture the session ID + runtime.
