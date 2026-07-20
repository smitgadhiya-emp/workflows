[corpus folder]	"Company Knowledge Base" Google Drive folder (walk all subfolders)
[ops folder]	"Knowledge Base Ops" Google Drive folder (holds the tracker)
[tracker sheet]	"KB Index Tracker", tabs: catalog, gaps, ledger (in Knowledge Base Ops)
[question sheet]	"KB Query Set", tab: questions
[MongoDB]	database knowledge_base, collections chunks + routing_domains
[team name] > [channel name]	Workflow test > Knowledge Base
[staleness cutoff]	2026-04-17 (on-or-after = fresh; before = stale). ~90 days of freshness.
[confidence rule]	High = chunks directly + completely answer AND every source >= 2026-04-17; Medium = partial/indirect OR any source older than cutoff; Low = thin/off-topic OR routed to whole corpus (no domain). Tie: older sources -> lower score.
[chunk stable id]	file id + file version/stated-last-modified + chunk position. Unchanged file -> leave chunks; changed -> replace that file's chunks (no append).

Source-of-truth note:
There is NO mock log sheet in this workflow. The "source" is the Drive corpus itself, read as-is.
Last-updated dates come from INSIDE each file (Last-Updated: line in Docs/PDFs, slide-1 notes in
Slides, _meta tab last_updated in Sheets) - NOT from Drive's modified timestamp, which here reflects
load time, not content change. Files stating no date must be flagged, never back-filled from Drive.

Intended ledger (build so it reconciles; NOT to be pasted as output):
Files found (unique ids) 20 = indexed 15 + unparsed 2 (F07 scanned, F10 empty) + inaccessible 1 (F15)
+ out-of-scope 2 (F19 png, F20 mp4). F18 is one file id shortcut-linked into two folders -> index once,
home = shortest path (Product/).

Deterministic date spine (relative to cutoff 2026-04-17):
Fresh: F01 2026-06-10, F03 2026-05-20, F04 2026-06-28, F06 2026-07-01, F08 2026-06-15, F11 2026-05-30,
F14 2026-04-17 (boundary=fresh), F16 2026-06-20, F18 2026-05-25.
Stale: F02 2026-02-03, F05 2026-01-15, F13 2026-03-10, F17 2026-04-16 (boundary=stale).
Special: F09 no stated date; F12 stated 2026-07-05 but content unrevised (date-wrinkle).

Question -> path spine (for review, NOT an answer key):
Q1 F01 High | Q2 F02 Medium(stale) | Q3 F03 High | Q4 F04 High | Q5 F07 unknown-coverage(unparsed) |
Q6 F15 unknown-coverage(inaccessible) | Q7 F09 Medium/Low(no date) | Q8 F11 High | Q9 F12 Medium(stale
content) | Q10 F14 High(boundary) | Q11 F17 Medium(one day stale) | Q12 confirmed gap (DR, Infra) |
Q13 cross-domain Security(F18)+HR(F13), Medium | Q14 no-domain -> whole corpus, Low | Q15 F08 High.

Seeded state the workflow must reconcile with (not workflow output):
- KB Index Tracker catalog: 3 prior rows keyed on the REAL F01/F08/F13 file ids; human owner set on
  F01 (eng-backend-team) and F08 (product-team) -> UPDATE in place, preserve owner. gaps tab: 1 prior
  row (Disaster Recovery / confirmed gap / Q12) -> UPDATE not duplicate. ledger tab: stale prior counts
  -> refresh.
- MongoDB chunks: F01 prior chunks under CURRENT id (2026-06-10) -> unchanged, leave alone. F04 prior
  chunks under STALE id (2026-05-01) -> changed, replace (delete stale-id, write fresh), no duplicates.
  routing_domains empty -> workflow builds it.

Prompt ambiguities to decide before the run (see Manual-Setup-236.md):
1. F09 no-date vs "every chunk needs a date" - index-with-null-flag or unknown-coverage? (changes ledger)
2. F12 fresh-date-stale-content - score by date (High) or content (Medium)? Intended: Medium.
3. Cutoff boundary inclusive: F14 04-17 fresh, F17 04-16 stale.
4. Catalog row whose file id disappears from Drive - undefined (seed doesn't force it).

Verify-after-Codex note:
Collect the REAL Drive file ids for F01/F08/F13 (tracker match keys), F04 (MongoDB replace test) and
F18 (shortcut) from Codex's report and confirm the tracker prior rows + seeded chunks use them. If any
file id in the tracker/chunks doesn't match the actual Drive file, the idempotency test silently fails.
