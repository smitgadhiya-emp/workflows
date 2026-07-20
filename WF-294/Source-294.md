[Notion workspace]	"Acme Knowledge Base" (personal stand-in; nothing confidential)
[activity fallback sheet]	"Workspace Activity Log" (Drive folder: Engineering / Knowledge Audit)
[redundancy map sheet]	"Knowledge Redundancy Map" (Drive folder: Engineering / Knowledge Audit)
[architecture report doc]	"Knowledge Architecture Report" (Drive folder: Engineering / Knowledge Audit)
[Linear team]	KA
[team name] > [channel name]	Workflow test > knowledge audit
[exact start date]	2026-06-15
[exact end date]	2026-07-14
[timezone]	Asia/Kolkata (IST)
[similarity threshold]	0.75 (token/shingle overlap on normalized body; transitive clustering; min 2 members)
[propagation constant]	8 minutes per edit per duplicate location
[issue threshold]	2 or more hours/month (make easy to change)
[maintenance formula]	hours/month = (total in-window edit events across all members) x (member count - 1) x 8 / 60
[canonical rule ladder]	1 most-recent last_edited -> 2 most-complete schema (props filled) -> 3 most inbound links/relations -> 4 earliest created -> 5 page URL A-Z (flag coin-flip if it ties to rule 5)
[cluster ranking]	hours desc -> member count desc -> cluster id A-Z
[cluster id]	derived from the sorted member page ids (stable across runs)

CRITICAL edit-data note (see Manual-Setup-294.md):
The maintenance number needs edit events in 2026-06-15..07-14, but the seeded workspace is created now,
so Notion's last_edited is load-time (outside the window). Notion history is reachable-but-empty, so a
run that only falls back "where history is not reachable" scores every cluster 0. FIX: add a line to
Prompt-294 (~line 27) telling the run to read in-window edit activity from the "Workspace Activity Log"
Sheet, not Notion history, for this stand-in workspace. The seed puts all in-window edit data there.

Source-of-truth split:
- Workspace content (pages, databases, synced blocks, relations, schemas) -> Notion directly.
- Per-page in-window edit activity -> "Workspace Activity Log" Sheet (page id, date, edit count),
  join on page id. (Not Notion history - it's load-time here.)

Expected results spine (for review, NOT an answer key):
Ranking: C1 6.00 (n4,E15,gap,issue) | C2 4.80 (n3,E18,gap,issue) | C3 4.00 (n2,E30,DRIVEN-not-gap,
issue) | C6 2.67 (n2,E20,gap+drift,issue) | C9 2.27 (n2,E17,gap,coin-flip canon,issue) | C5 1.60
(n3,E6,gap,sheet-only) | C4 1.60 (n2,E12,gap,sheet-only) | C7 0.00 (n2,E0,gap,edit-data-unknown,
sheet-only). Total ~22.93 h/mo. Issues (>=2h): 5. SSoT gaps: 7 (all but C3). 1.6h tie -> C5 before C4
on member count. Canonical rules exercised: C1 recency, C2 schema, C5 inbound links, C4 created, C9 url.

Seeded state the workflow must reconcile with (not workflow output):
- Linear KA: 2 open issues (onboarding C1, expense policy C2) -> UPDATE not duplicate. 1 closed issue
  (vacation policy C9) -> closed is not open, so a NEW issue is correct.
- Redundancy Map: 3 prior rows keyed on sorted-member-page-id cluster ids. C1 (owner=platform-team,
  decision=Merge into wiki A) and C2 (owner=ops-team, decision=Keep both for now) have human columns
  that must survive the upsert. One GHOST cluster whose member pages no longer exist -> mark Resolved
  with the run date, not deleted.
- Architecture Report doc: stale prior body -> body REPLACED each run (living doc).

Prompt ambiguities to decide before the run (see Manual-Setup-294.md):
1. Edit source (the big one): read from the Activity Log sheet, not load-time Notion history.
2. Driven cluster (C3) still costs >=2h by the literal formula -> gets an issue but flagged not-a-gap;
   decide whether synced-block edits should be de-duplicated before the formula.
3. Coin-flip canonical (C9): deterministic (URL wins) AND flagged coin-flip - do both.

Verify-after-Codex note:
Collect the REAL Notion page ids for all C1 and C2 members (the prior-row cluster-id keys) and the
ghost cluster's members from Codex's report; confirm the redundancy-map prior rows and the Activity Log
rows use them. If a page id drifts between Notion, the log sheet, and the map, the join and the upsert
key both silently fail.
