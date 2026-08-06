# WF-184 cleanup / reset (run this FIRST, before every re-seed)

Run this before you re-seed, and again before each model when you compare A/B/C/D, so every run
starts clean. It removes the run's output (the rows a run writes into the Notion "Capex Gate
Decisions" database, the agenda it posts to the "capital-planning" Teams channel) plus the seeded
Google Sheet and the two seeded Google Docs. Paste into Codex with Drive/Sheets/Docs + Notion +
Microsoft Teams connected (or browser control on a demo account). It only clears things, it never
creates.

Why it matters: a run writes 11 Notion rows and one Teams agenda. Left in place, the next model finds
a finished answer sitting next to the inputs and "verifies" it instead of doing the work. The Notion
rows are the dangerous ones, they carry the tier and the verdict, which is the entire answer key. The
Teams agenda is nearly as bad, because its item count is where the split pair shows up.

> **Notion caveat (learned the hard way on WF-028 and WF-045).** The Notion connector often no-ops on
> row deletes and reports success without actually emptying the database. After this runs, open the
> "Capex Gate Decisions" database yourself and confirm it has zero rows. If any are still there,
> delete them by hand before you re-seed. Do not trust the model's "cleared" line for Notion.

```
I need a test bench reset before I re-seed it. Everything here is invented test data for a capital
request screening exercise, no real company, no real people, no real money, so delete freely. Do all
of the below and give me a one-line status per app. Do not seed or create any new test data in this
step, this is cleanup only.

1) Notion. Open the database "Capex Gate Decisions" and delete every row in it so it is completely
empty (a run writes one row per capital request, eleven of them). Leave the database itself in place
with its properties. Tell me how many rows you deleted and how many remain. If you cannot delete a
row, say which ones are still there so I can clear them by hand.

2) Microsoft Teams. In the "capital-planning" channel, delete the committee agenda post a past run
put up so the channel is clear of it. Leave the channel itself in place. If you cannot delete a
message, tell me which ones are still there. If the channel does not exist yet, say so.

3) Google Drive. So I can re-seed clean copies, move these three to trash: the Google Sheet
"Ashgrove Capital Requests - July 2026 Committee", the Google Doc "Ashgrove Delegation of Authority -
Capital Requests", and the Google Doc "Ashgrove Capital Requests - Business Cases (July 2026)". If
you cannot delete one, give me its link and leave it, I will re-seed clean copies anyway. Tell me
what you removed.

When you are done, report exactly: how many rows remain in the Notion "Capex Gate Decisions"
database, whether the "capital-planning" Teams channel is clear, and whether the Google Sheet and
both Google Docs are in the trash. If any app is not connected or you cannot reach it, say so and
carry on, do not guess or invent anything.
```

## After it runs

Check the reply says: the Notion "Capex Gate Decisions" database at zero rows, the "capital-planning"
Teams channel clear, and the Sheet plus both Docs moved to trash.

**Open Notion yourself and confirm zero rows,** the connector lies about this. Clear anything left by
hand now, before seeding. Then run [`seed-prompt.md`](seed-prompt.md) and paste the eval (Part B)
from the [main file](WF-184-capex-gate-split-detection.md).
