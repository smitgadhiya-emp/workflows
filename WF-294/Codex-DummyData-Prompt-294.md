# Codex Prompt — Create WF-294 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (Notion, Google
Drive/Sheets/Docs, Linear, Microsoft Teams). **Create every item in the actual app. Do NOT write
anything to the local file system.**

---

You are setting up **mock source data** for a workflow that crawls a Notion workspace, finds redundant
knowledge clusters and schema drift, scores each cluster's monthly maintenance cost, picks a canonical
page per cluster, opens Linear issues, upserts a redundancy-map Sheet, rewrites an architecture-report
Doc, and posts a Teams summary. Your job is ONLY to create the seed data the workflow reads.

**Do NOT run the workflow.** Do NOT compute clusters, similarity scores, maintenance numbers, canonical
picks, or the ranking; do NOT create the audit Linear issues; do NOT write this run's rows into the
redundancy-map Sheet (beyond the seeded prior rows); do NOT write the architecture Doc body (beyond the
seeded stale prior body); do NOT post to Teams. The catalog below tells you what **Notion content to
build** so the workflow has real redundancy to find — it is your build spec, not output to transcribe.

## Where each source lives

- **Notion, Google Drive/Sheets/Docs, Linear, Teams** → create real items via the connectors.
- **The workspace content must be real Notion** — pages, databases, synced blocks, relations — because
  the whole audit is about content overlap, schema drift, and what actually drives what.
- **Per-page edit activity → the "Workspace Activity Log" Google Sheet.** See the **big caveat** below:
  a freshly-created workspace's Notion history is all at load-time, so the sheet is the real edit
  source, not Notion's page history.

## Anchor values (use everywhere; keep identical across every item)

- Notion workspace: **Acme Knowledge Base** (personal stand-in; nothing confidential)
- Google Drive folder: **Engineering / Knowledge Audit**
- Activity fallback sheet: **Workspace Activity Log**
- Redundancy map sheet: **Knowledge Redundancy Map**
- Architecture report doc: **Knowledge Architecture Report**
- Linear team: **KA**
- Microsoft Teams: team **Workflow test**, channel **knowledge audit**
- Edit window: **2026-06-15 through 2026-07-14** inclusive, Asia/Kolkata
- Similarity threshold: **0.75** (token/shingle overlap on normalized body)
- Propagation constant: **8 minutes** per edit per duplicate location
- Linear issue threshold: **2 or more hours/month**
- Maintenance formula: `hours/month = (total edit events across all members in-window) × (member count − 1) × 8 / 60`

## ⚠️ The edit-data caveat — read this first, it decides whether the whole thing is reproducible

The maintenance number is driven by **edit events in 2026-06-15…07-14**. But you are creating this
workspace **now**, so every page's Notion `last_edited` is the load date — **outside** that window.
Notion's own history will therefore show ~0 in-window edits for every seeded page, and because that
history is *reachable* (just empty), a naive run would never fall back and would score every cluster 0.

So: **the "Workspace Activity Log" Sheet is the authoritative edit source for this seeded workspace**,
exactly like a stand-in for real page history. Seed it with the per-page in-window edit counts below so
the maintenance math is deterministic. (This is the same shape as other WFs where the platform's own
timestamp reflects load time — see the note to add to the workflow prompt in the setup file.)

## The workspace catalog — the shared spine (build every cluster exactly)

Build these under **Acme Knowledge Base**. Cluster members must have **genuinely overlapping normalized
body content ≥ 0.75** (paraphrase the same process into each copy, drifting wording and going a little
stale, so the overlap is real but not identical). Do **not** write any similarity score, cluster id,
maintenance number, canonical verdict, or "this is a duplicate" note anywhere in the content.

| cluster | members (n) | build so that… | canonical decided by | gap? |
|---------|-------------|----------------|----------------------|------|
| **C1 Onboarding Process** | 4 pages in 4 different team wikis | A~B~C~D **transitively**: A–B, B–C, C–D each ≥0.75, but A–D ~0.72 (below threshold) so it only clusters via the chain. Nothing drives them (plain copies). | **rule 1**: one page clearly has the most recent edit | **gap** |
| **C2 Expense Policy** | 3 pages | two of them tie on most-recent-edit (same day) | **rule 2**: schema/property completeness breaks the recency tie | **gap** |
| **C3 Deployment Runbook** | 2 pages | page B is a **Notion synced block mirror** of page A → the cluster **is driven**, kept in sync automatically | rule 1 (recency) | **NOT a gap** (driven) — but still costs ≥2h, so it still gets a row + issue |
| **C4 Brand Guidelines** | 2 pages | tie on recency, schema, and inbound links | **rule 4**: earliest created time decides | **gap** |
| **C5 API Style Guide** | 3 pages | tie on recency and schema | **rule 3**: most inbound links/relations decides | **gap** |
| **C6 Project Tracker (schema drift)** | 2 **databases** from a shared template | same logical fields, **drifted property names**: `Due Date`/`Deadline`, `Owner`/`Assignee`, `Status`/`Stage`, `Priority`/`Urgency` (same types + sample values + role). Add **one field that genuinely differs** — one DB has `Client` (text), the other `Budget` (number) — that must **NOT** be matched (or be marked low confidence). Their description/schema content overlaps ≥0.75. | rule 1 (recency) | **gap** + schema drift |
| **C7 Security Policy** | 2 pages | **no edit data anywhere** — give these pages **no rows in the Activity Log sheet** → count 0 edits, flag **edit-data-unknown** | n/a (unknown) | gap, but 0h |
| **C9 Vacation Policy** | 2 pages | a **genuine coin flip**: tie on recency, schema completeness, inbound links, **and** created time | **rule 5**: page URL A-Z decides, and it must be flagged as a coin-flip the human may want to override | **gap** |

**The boilerplate trap (NOT a cluster):** build **two "Meeting Notes" pages** that share the same
template shell (identical header, the same section headings: Attendees / Agenda / Decisions / Action
Items) but whose **actual body content is different meetings**. Raw text overlaps a lot; **meaningful
body overlaps <0.75**. The workflow must **exclude** this pair with the reason "shared template, bodies
differ" — so do not make their bodies similar.

**Singletons (no cluster):** build **5 unique pages** on distinct topics (e.g. Incident Postmortem
Q2, Office Map, Laptop Request Form, 2026 Holiday Calendar, Logo Usage FAQ) with no near-duplicate, so
the crawl is real and a good run does **not** over-merge them into clusters.

> Total ≈ 20 clustered pages/databases + 2 boilerplate + 5 singletons. Give the databases (C6) a few
> real entries each so the field types and sample values are inspectable. This is a "crawl all, do not
> sample" workspace, so make it genuinely a few dozen nodes.

## What to create

### 1) Notion workspace "Acme Knowledge Base"

All clusters, the boilerplate pair, and the singletons above, as real pages/databases with real
property schemas, real synced block (C3), real relations/inbound links (C5, and enough elsewhere that
the canonical tie-breaks have data), and drifted database schemas (C6). Vary each cluster's members on
`last_edited`, schema completeness (how many properties are filled), inbound-link count, and created
time **exactly enough** to make the canonical rule in the table the deciding one. Do **not** annotate
any verdict anywhere.

### 2) Google Sheet — "Workspace Activity Log" (in the Drive folder), the edit source of truth

Columns: `date, page id, page title, edit count`. One row per (page × day). Seed in-window edits
(2026-06-15…07-14) so each cluster's **total edits across all members** sum to exactly:

| cluster | total in-window edits (E) | → hours = E×(n−1)×8/60 |
|---------|---------------------------|------------------------|
| C1 (n=4) | **15** (spread across the 4, e.g. 6/4/3/2) | 6.00 |
| C2 (n=3) | **18** | 4.80 |
| C3 (n=2) | **30** | 4.00 |
| C4 (n=2) | **12** | 1.60 |
| C5 (n=3) | **6** | 1.60 |
| C6 (n=2) | **20** | 2.67 |
| C7 (n=2) | **0 — NO ROWS AT ALL** | 0.00 (edit-data-unknown) |
| C9 (n=2) | **17** | 2.27 |

Also seed edit rows for the boilerplate pair and singletons (any plausible counts) so they exist in the
log but don't form clusters. Rules:
- **C7's two pages get no rows at all** (that's the edit-data-unknown trap).
- **Add out-of-window rows** (2026-06-01…06-14 and 2026-07-15…07-20) with **different** counts so a run
  that forgets to filter inflates E — e.g. C1's most-recent member has a big burst on 2026-07-16 that
  must NOT be counted, and C6 has extra edits on 2026-06-10.
- Keep in-window per-cluster totals **exactly** the E values above; the ranking depends on them.
- Join key is **page id** — use the real Notion page ids so the join is genuine.

### 3) Google Sheet — "Knowledge Redundancy Map" (in the Drive folder)

Create it with **exactly** these header columns, in this order:

`cluster id, member titles, member urls, pairwise similarity scores, schema drift, ssot gap,
maintenance hours, edit events, duplicate locations, canonical source, canonical rule, confidence,
linear issue, owner, decision, last reviewed`

(`edit events` and `duplicate locations` are two of the three formula inputs; `maintenance hours` is
the result — the third input, the 8-minute constant, is fixed.) Add **exactly three prior-run rows**
and nothing else:
1. Cluster **C1** (keyed on the cluster id derived from C1's sorted member page ids) — `last reviewed`
   **2026-05-20**, stale hours/canonical, **`owner` = platform-team**, **`decision` = Merge into wiki
   A** (human-set). *(Upsert must refresh members/scores/hours/canonical/linear but leave owner +
   decision.)*
2. Cluster **C2** — `last reviewed` **2026-05-20**, **`owner` = ops-team**, **`decision` = Keep both
   for now** (human-set). *(Same test.)*
3. A **ghost cluster** whose member page ids **do not exist** in the workspace (pages were merged/
   deleted) — `last reviewed` **2026-04-02**, some stale data. *(Must be marked **Resolved** with the
   run date, not deleted.)*

### 4) Google Doc — "Knowledge Architecture Report" (in the Drive folder)

Create it with a short **stale prior-run body** (an old consolidation plan referencing only two
clusters, older dates) so the workflow's "replace the body each run" behavior is visible. Do not write
the current plan — that's output.

### 5) Linear — team **KA**

Ensure the team exists. Create **exactly three** pre-existing issues and no others:
1. **Open** — `Consolidate knowledge cluster: onboarding process (4 copies)` (C1), stale body. *(Must
   be updated, not duplicated.)*
2. **Open** — `Consolidate knowledge cluster: expense policy (3 copies)` (C2), stale body. *(Must be
   updated, not duplicated.)*
3. **Done/Canceled** — `Consolidate knowledge cluster: vacation policy (2 copies)` (C9). *(The workflow
   searches only **open** issues, so C9 should get a **new** issue — closed is not a reason to skip.)*

Do **not** create any other issues — those are the workflow's output.

### 6) Microsoft Teams

Confirm team **Workflow test** and channel **knowledge audit** exist; create the channel if it isn't
there. Do not post — the summary is the workflow's output.

## Consistency rules (verify all before reporting done)

1. All 8 clusters exist as real Notion content with member content that genuinely overlaps ≥0.75 (C1
   only transitively — A–D below threshold), plus the boilerplate pair (bodies <0.75) and 5 singletons.
2. **C3 is driven by a real synced block**; **C6 is two databases with the drifted property names** (and
   the one genuinely-different field that must not be matched); no other cluster is driven.
3. Canonical tie-breaks are set up so the deciding rule per cluster is exactly the one in the table
   (C1 recency, C2 schema, C5 inbound links, C4 created time, C9 coin-flip→url).
4. Activity Log in-window totals per cluster are exactly E above; **C7 has no rows**; out-of-window rows
   carry different counts; join is on real page ids.
5. Redundancy Map has the 16 headers, exactly three prior rows (C1, C2 with human owner+decision; one
   ghost cluster), keyed on cluster ids derived from **sorted member page ids**.
6. The Architecture Report doc has a stale prior body.
7. Linear KA has exactly three issues (two open, one closed) and no others.
8. **No similarity score, cluster id, maintenance number, canonical verdict, or gap flag appears
   anywhere in the Notion content** — the seed builds the swamp; the workflow maps it.

## When done — report back (so the workflow prompt can be filled to match)

List: the **Notion workspace** confirmed with the cluster/boilerplate/singleton counts; the **real page
ids** for every C1 and C2 member (the prior-row cluster-id keys) and for the ghost cluster's members;
the **URLs of the two Sheets and the Doc**; the **Linear team + the three seeded issue ids**; and
confirmation the **Teams team/channel** exist. If Notion, a Sheet, the Doc, the Linear team, or the
Teams channel could not be created, **say so explicitly and name which** — do not report done with a
gap. Finish with a short note confirming the eight consistency rules hold, especially that the edit data
lives in the Activity Log sheet (because Notion history is load-time), that C3 is synced and C6 is
drifted, and that no verdicts were seeded. Do not create any local files.
