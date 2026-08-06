# WF-180 cleanup / reset (run this FIRST, before every re-seed)

Run this before you re-seed, and again before each model when you compare A/B/C/D, so every run
starts clean. It removes the run's output (the records a run writes into the Notion "Deviation
Register - July 2026" database, the IRB submission it leaves in Gmail Drafts, the post it puts in the
"site-deviations" Teams channel) plus the five seeded Google Docs and the 25 seeded Google Calendar
events. Paste into Codex with Drive/Docs + Google Calendar + Gmail + Notion + Microsoft Teams
connected (or browser control on a demo account). It only clears things, it never creates.

Why it matters: a run writes 12 Notion records, a Gmail draft and a Teams post. Left in place, the
next model finds a finished answer sitting next to the inputs and "verifies" it instead of doing the
work. The Notion records are the dangerous ones, they carry the class and the due date, which is the
entire answer key.

The calendar matters for a second reason. Leftover visit events do not just clutter, they **break the
fixture**. If ORN-014 ends up with two "attended" events from two seedings, the plus-or-minus-7 call
has two answers and the restraint trap is gone. Clear the events even if you are only re-running one
model.

> **Notion caveat (learned the hard way on WF-028 and WF-045).** The Notion connector often no-ops on
> row deletes and reports success anyway, without actually emptying the database. After this runs,
> open the "Deviation Register - July 2026" database yourself and confirm it has zero rows. If any are
> still there, delete them by hand before you re-seed. Do not trust the model's "cleared" line for
> Notion.

```
I need a test bench reset before I re-seed it. Everything here is invented test data for a clinical
protocol-deviation exercise, no real studies, no real people, no real patient data, so delete freely.
Do all of the below and give me a one-line status per app. Do not seed or create any new test data in
this step, this is cleanup only.

1) Notion. Open the database "Deviation Register - July 2026" and delete every record in it so it is
completely empty (a run writes one record per queue entry, twelve of them). Leave the database itself
in place with its properties. Tell me how many records you deleted and how many remain. If you cannot
delete a record, say which ones are still there so I can clear them by hand.

2) Gmail. In Drafts, delete the IRB prompt-report submission that a past run left there (it is
addressed to irb-submissions@vensara.example.org and is about the July 2026 protocol deviations).
Only touch Drafts, do not touch anything in Sent or Inbox. Tell me how many drafts you removed.

3) Microsoft Teams. In the "site-deviations" channel, delete the deviation post a past run put up so
the channel is clear of it. Leave the channel itself in place. If you cannot delete a message, tell me
which ones are still there. If the channel does not exist yet, say so.

4) Google Calendar. Delete the seeded test events so I can re-seed clean ones. These are the
"Institute Foundation Day - institute closed" event on Friday 17 July 2026, and every subject visit
event whose title starts with "ORION-3 ORN-", "CASTELLA-2 CST-" or "NIMBUS-7 NMB-". They run between
Monday 22 June 2026 and Friday 17 July 2026, and there are 25 of them in all. Leave everything else on
the calendar alone. Tell me how many events you deleted and list anything matching that you could not
delete.

5) Google Drive. So I can re-seed clean copies, move these five Google Docs to trash: "Deviation Queue
- week of 13 July 2026", "ORION-3 Protocol", "CASTELLA-2 Protocol", "NIMBUS-7 Protocol" and "Site SOP
- Deviation Reporting". If you cannot delete one, give me its link and leave it, I will re-seed clean
copies anyway. Tell me what you removed.

When you are done, report exactly: how many records remain in the Notion "Deviation Register - July
2026" database, how many IRB drafts remain in Gmail, whether the "site-deviations" Teams channel is
clear, how many of the 25 seeded calendar events remain, and whether all five Google Docs are in the
trash. If any app is not connected or you cannot reach it, say so and carry on, do not guess or invent
anything.
```

## After it runs

Check the reply says: the Notion "Deviation Register - July 2026" database at zero records, the Gmail
draft cleared, the "site-deviations" Teams channel clear, zero of the 25 seeded calendar events left,
and all five Docs moved to trash.

**Open Notion yourself and confirm zero rows,** the connector lies about this. Clear anything left by
hand now, before seeding.

**Open the Google Calendar on Friday 17 July 2026 and on Monday 13 July 2026 and check they are
clear.** A stray "Institute Foundation Day" or a leftover ORN-014 visit is worse than a leftover Notion
row, because the seed will add its own on top and the fixture then has two answers instead of one.

Then run [`seed-prompt.md`](seed-prompt.md) and paste the eval (Part B) from the
[main file](WF-180-protocol-deviation-irb-clock.md).
