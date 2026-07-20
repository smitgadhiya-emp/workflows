# WF-294 — Manual Setup (do these yourself, before anything runs)

Things Codex can't bootstrap on its own (OAuth logins, a Notion workspace, Linear team, Teams
creation). Do these first, then run the Codex seed prompt, then confirm the workflow prompt matches
what Codex reports, then run the workflow.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **Notion** (with access to the stand-in workspace and permission to create pages/databases)
- [ ] **Linear**
- [ ] **Google Drive / Sheets / Docs**
- [ ] **Microsoft Teams**

## 2. Notion — the stand-in workspace
- [ ] Workspace **Acme Knowledge Base** exists (personal stand-in, nothing confidential), and the
      connector can **create pages, databases, synced blocks, and relations** in it.
- [ ] Confirm the connector can **page through the whole workspace** (list all pages/databases) — the
      prompt says crawl all, do not sample.

## 3. Linear — team + issue search
- [ ] Team **KA** exists.
- [ ] Confirm the connector can **search issues and filter by state** on KA — the "update, don't
      duplicate" step depends on it, and the seed includes one *closed* issue (vacation policy) that
      must NOT suppress a new one.

## 4. Microsoft Teams — team + channel
- [ ] Confirm team **Workflow test** exists (reuse from earlier WFs) and that the channel
      **knowledge audit** exists under it — create it if not.

> Teams was the blocker on WF-138. Check it before the run — the summary post is the last step, only
> after the sheet, doc, and Linear are done, so a missing channel wastes a whole run.

## 5. Google Drive — folder for the two Sheets + the Doc
- [ ] Create the folder **Engineering / Knowledge Audit**. Codex puts the **Workspace Activity Log**
      and **Knowledge Redundancy Map** Sheets and the **Knowledge Architecture Report** Doc there.
- [ ] Leave the redundancy map's current-run rows empty (only the three seeded prior rows) and the
      report doc holding only its stale prior body. Those are the workflow's output.

---

## The one that will silently break the run — edit data is load-time in Notion
**This is the most important thing on the page.** The maintenance number is driven by edit events in
**2026-06-15…07-14**, but the seeded workspace is created **now (July 2026)**, so every page's Notion
`last_edited` is the load date — **after** the window. Notion's own history shows ~0 in-window edits,
and because that history is *reachable* (just empty), a run that reads Notion history first and only
"falls back where history is not reachable" (Prompt-294 line 27) will **never fall back** and will
score **every cluster 0 hours** — collapsing the entire ranking.

**Fix before running:** add a line to Prompt-294 (near line 27) like —
> *"This stand-in workspace's Notion page history reflects when pages were loaded, not when content
> actually changed, so read per-page in-window edit activity from the **Workspace Activity Log**
> Sheet, not from Notion history."*

The seed puts all in-window edit data in that Sheet for exactly this reason. Without the line, the run
is not reproducible — it's not even non-zero.

## Three more ambiguities in Prompt-294 worth deciding before you run
1. **Driven clusters still get a maintenance number and an issue.** C3 (Deployment Runbook) is kept in
   sync by a synced block → **not** a single-source-of-truth gap → but it still has 30 in-window edits
   and costs 4.0h by the formula, so it crosses the 2h issue threshold. Is that right? The formula is
   purely mechanical and doesn't zero-out driven clusters, and the issue threshold is cost-based, not
   gap-based — so **yes, C3 gets a row and an issue but is flagged "driven, not a gap."** But a synced
   block means one logical edit shows up on every mirror, so counting "edits across all members" may
   *double-count* automatic propagation and overstate a driven cluster's cost. Decide whether driven
   clusters' synced edits should be de-duplicated before the formula. (Intended for the seed: leave the
   formula literal, flag C3 driven — but this is a real judgment call.)
2. **The coin-flip canonical (C9).** The prompt says pick deterministically (…→ URL A-Z) **and** "if
   it's genuinely a coin flip between two live pages, say so." C9 is built to tie all the way to the URL
   rule. So the canonical is deterministic (URL wins) **and** it's flagged coin-flip for a human. Make
   sure the run does both, not one.
3. **Cluster id stability.** The cluster id derives from the sorted member page ids. If the run merges
   or splits a cluster (e.g. C1's transitive A–D chain resolves differently), the id changes and the
   upsert can't match the prior row. The seed's C1 is built to cluster the same way every run (the chain
   is unambiguous), but confirm the run's clustering method is deterministic, not order-dependent.

## Verify the seed before the real run
Spot-check these by hand; they're the ones that silently break the audit if Codex drifts.

- [ ] **8 clusters** exist with member content overlapping ≥0.75; **C1 only transitively** (A–D below
      threshold); the **boilerplate pair** bodies are <0.75; the **5 singletons** don't near-duplicate.
- [ ] **C3 has a real synced block** (driven); **C6 is two databases** with the drifted property names
      plus the one genuinely-different field (`Client` text vs `Budget` number) that must not match.
- [ ] **Canonical tie-breaks**: C1→recency, C2→schema completeness, C5→inbound links, C4→created time,
      C9→URL (coin-flip). Each cluster's members differ *only* enough to make that rule decide.
- [ ] **Activity Log** in-window totals per cluster are exactly: C1 15, C2 18, C3 30, C4 12, C5 6,
      C6 20, C7 **0 (no rows)**, C9 17. Out-of-window rows carry different counts. Join on real page ids.
- [ ] **Redundancy Map**: 16 headers, exactly 3 prior rows (C1 + C2 with human owner/decision; one
      ghost cluster whose pages don't exist), keyed on sorted-member-page-id cluster ids.
- [ ] **Architecture Report doc** holds only a stale prior body.
- [ ] **Linear KA**: exactly 3 issues — 2 open (onboarding, expense policy), 1 closed (vacation policy).
- [ ] **No verdicts anywhere in Notion** — no score, cluster id, hours, canonical, or gap flag written
      into any page.

## Expected results spine (for review — NOT an answer key to paste)
Ranking by hours desc, tie-break member count then cluster id:

| rank | cluster | n | E | hours | gap? | decision |
|------|---------|---|---|-------|------|----------|
| 1 | C1 Onboarding | 4 | 15 | **6.00** | gap | issue |
| 2 | C2 Expense Policy | 3 | 18 | **4.80** | gap | issue |
| 3 | C3 Deployment Runbook | 2 | 30 | **4.00** | **driven, not gap** | issue |
| 4 | C6 Project Tracker | 2 | 20 | **2.67** | gap + drift | issue |
| 5 | C9 Vacation Policy | 2 | 17 | **2.27** | gap (coin-flip canon) | issue |
| 6 | C5 API Style Guide | 3 | 6 | **1.60** | gap | sheet-only |
| 7 | C4 Brand Guidelines | 2 | 12 | **1.60** | gap | sheet-only |
| 8 | C7 Security Policy | 2 | 0 | **0.00** | gap, **edit-data-unknown** | sheet-only |

Total ≈ **22.93 h/month**. Issues (≥2h): **5** (C1, C2, C3, C6, C9). SSoT gaps: **7** (all but C3).
The 1.6h tie (C5 vs C4) breaks on member count → **C5 ranks above C4**.

## What the seed is designed to catch (traps, not an answer key)

| Trap | Where | What a shallow run does wrong |
|---|---|---|
| Load-time Notion history | whole workspace | scores every cluster 0 by reading Notion instead of the sheet |
| Transitive clustering | C1 (A–D below threshold) | drops A or D because A–D pairwise <0.75 |
| Boilerplate ≠ redundancy | Meeting Notes pair | clusters them on shared template header |
| Synced block = driven | C3 | flags it a single-source-of-truth gap |
| gap ≠ cost threshold | C3 (driven but 4h) | drops its issue because "it's maintained" |
| Schema drift by role not name | C6 | misses `Due Date`≡`Deadline`, or forces `Client`≡`Budget` |
| Canonical tie-break ladder | C2/C4/C5/C9 | uses recency alone and gets the wrong canonical |
| Coin-flip disclosure | C9 | hides the tie instead of flagging it |
| Edit-data-unknown | C7 (no rows) | invents a number instead of 0 + flag |
| Out-of-window edits | C1 07-16 burst, C6 06-10 | inflates E, changes hours and ranking |
| Ranking tie-break | C5 vs C4 at 1.6h | orders by hours alone, gets them backwards |
| Cluster id from sorted ids | upsert key | can't match prior rows → duplicates |
| Ghost cluster | prior row, pages gone | deletes the row instead of marking Resolved |
| Closed issue ≠ open | C9 | skipped as "already exists" |
| Human owner/decision cols | prior rows C1/C2 | overwritten on upsert |

## What you do NOT set up (the workflow produces these)
- The per-cluster Linear issues (beyond the three seeded ones)
- The current-run rows in the Knowledge Redundancy Map
- The current body of the Knowledge Architecture Report
- The Teams summary
