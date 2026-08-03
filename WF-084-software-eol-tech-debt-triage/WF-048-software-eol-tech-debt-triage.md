# WF-048 — Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date)

**Source:** net-new — no EXP idea (net-new live no-seed build). WF build IDs are their own series, not EXP-aligned; map in `../../../context.md` §2a. · **Status:** Done — all three models run + Form 2 + 3-way comparison (`form2-eval-modelA/B/C.md` + `form2-final-comparison.md`). **Rank: red > yellow > blue.** Yellow (clean rerun) and red both completed the sweep **autonomously** (clean 6s); blue stopped over the OpenJDK 8 blocker and needed **one steering nudge** to finish (5,5,5,6,5,4,6), which we now know is **run-to-run variance** (yellow itself stopped on its first run and completed on its rerun). All three land the same judgment (active-vs-security split, grouping, OpenJDK handled honestly), so **too easy once the workspace is clean = 6**. **Feather submission pending, harden before resubmitting** (more LTS/ESM-divergent cycles, bigger inventory, tighten the ambiguous stop clause). Open answer-key calls: Ubuntu 20.04 (public-EOL vs paid ESM), OpenJDK 8 (map-to-Red-Hat-fine vs unresolved), grouping (6 consolidated vs 10). Earlier single-run notes in `form-1-submission.md` §13-14.

> **No data-seeding step by design.** Like WF-040/043/044/047, this is the **real-data / live-source
> path**: the agent reads straight off the live **endoflife.date API** (public, no key). Reproducibility
> comes from a **pinned reference date** plus the named inventory, not from a seeded test bed. Authored
> per `../../../workflow-prompt-guide.md` §5 (real-data path).
>
> **Complexity tier: High.** This is the "high" of the IT no-seed pair (its sibling WF-047 is the "very
> high"). One full-fledged eval prompt, no Part A.

A platform / SRE engineer runs the periodic tech-debt sweep to catch software that has gone
end-of-life or is about to. The agent takes the inventory (product + version, given in the prompt),
looks each one up live on endoflife.date, works out its **support status as of a pinned reference date**
(already past end-of-life, approaching, or still supported), reads the **active-support vs
security-support** distinction that decides how urgent it really is, tiers by urgency and how critical the
component is, groups by upgrade path, writes the worklist to a named Google Sheet, files a Notion
upgrade-planning entry per item that needs one, and posts a digest. There is no seeded test bed: the
lifecycle dates are real and the difficulty is in reading each version's cycle correctly.

---

## Why this idea (complexity rationale)

It's High for the reasons EOL triage is hard for a person, and it all lives in the real endoflife.date data
with no seeding:

- **The status isn't one field.** endoflife.date gives, per release cycle, an active-support end and a
  separate security-support / EOL date. A version can be out of **active** support (no more bug fixes, plan
  the upgrade) while still getting **security** patches (not yet a fire), which is a different urgency from a
  version that's fully past EOL. Reading the right cycle and both dates is the core judgment.
- **The reference date matters.** "Approaching" only means something against a fixed "today"; the same
  version is supported one quarter and EOL the next.
- **Criticality weights it.** An EOL operating system or database under an internet-facing service is a far
  bigger deal than an EOL dev-tooling version on an internal box.
- **Grouping.** Several services on the same dead runtime are one upgrade initiative, not N entries.
- **Don't over-flag.** A still-supported version (a current Python/Node/Postgres LTS) needs no action;
  flagging it is noise that erodes trust in the sweep.

It reads from a **live, real provider** (endoflife.date, no key) and ends in real actions across three apps
(a Sheet, a Notion database, a digest), not a document. Distinct from WF-047 (actively-exploited
vulnerabilities, imminent security risk) in source, judgment, and urgency driver.

---

## Snapshot

- **Workflow name:** Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date)
- **ID:** WF-048
- **Occupation:** Computer Systems Analyst (platform engineering / SRE)
- **Tools:** read — **endoflife.date API** (public JSON, no key); act — **Google Sheets** (tech-debt
  worklist) + **Notion** (`TECHDEBT` database, one entry per item needing an upgrade) + **Microsoft Teams**
  (`platform` channel digest)
- **Frequency:** monthly to quarterly (~1 time/month)
- **Difficulty target:** a strong model should land **1–4 / 7** on outcome — it conflates active-support
  with security-support, mis-reads the cycle, or flags still-supported versions

---

## Complete flow

End to end, the agent:

1. Reads the inventory (product + version + where it runs, given in the prompt) and the pinned reference
   date.
2. Looks each component up live on endoflife.date and finds the matching release cycle.
3. Works out the status as of the reference date: past EOL, in security-support-only, approaching, or
   fully supported, reading both the active-support and the security/EOL dates.
4. Tiers each item that needs attention by urgency (how overdue) and component criticality/exposure.
5. Groups items that share one upgrade path into a single initiative.
6. Writes the worklist to the Sheet, files a `TECHDEBT` entry per item needing an upgrade, posts the digest.
7. If endoflife.date can't be reached, writes a failure note and stops instead of inventing dates.

How it weighs urgency, how it groups upgrade paths, and how it phrases each call are left to the agent.

---

## Required integrations

### endoflife.date (read — primary path)

Accessed **live at run time**, public, **no API key required**:
- **Per product:** `https://endoflife.date/api/<product>.json` (e.g. `python.json`, `nodejs.json`,
  `postgresql.json`, `ubuntu.json`, `centos.json`, `django.json`, `java.json`) returns an array of release
  cycles.
- **Product list:** `https://endoflife.date/api/all.json`.

Each cycle carries the fields this task reads:
- `cycle` (e.g. `"3.7"`, `"20.04"`)
- `releaseDate`
- `support` — end of **active** support (a date), or a boolean
- `eol` — end of life / end of **security** support (a date), or a boolean (`true` = already EOL)
- `lts` — whether it's an LTS cycle (boolean or a date)
- `latest`, `latestReleaseDate`

**The key read:** `support` (active support end) and `eol` (security support / EOL) are *different* dates.
A cycle past `support` but before `eol` is "security-support-only" (plan the upgrade), distinct from one
past `eol` (urgent). Compare both against the pinned reference date.

**Etiquette:** one GET per product (cache and reuse across versions of the same product); back off and
retry on a transient error; don't fabricate cycles or dates.

**Access paths:** (1) direct HTTPS GETs from a code/tool step (primary); (2) an MCP/web tool returning
the same JSON (acceptable); (3) browser Computer Use on endoflife.date (last resort).

### Action tools (named)
- **Google Sheets** — the worklist (`Tech Debt Tracker` → tab `EOL Sweep`).
- **Notion** — the **`TECHDEBT`** database, one entry per item needing an upgrade.
- **Microsoft Teams** — channel **`platform`**, the sweep digest.

---

## The eval prompt (Part B)

*The block below is the actual prompt to paste into Codex. Everything else is our own design notes. It's
written the way the approved example prompts read, first-person and casual like briefing a colleague,
no em-dashes. Make the wording your own before submitting.*

```
I look after our platform and I run a tech-debt sweep to catch software that's gone end-of-life or is
about to, working off endoflife.date, live. Treat today as 1 June 2025 for any of the date math.

Here's the inventory I'm sweeping, product, version, and where it runs:
- CentOS 7, on most of our app servers, some internet-facing
- Ubuntu 18.04 LTS, a handful of legacy build servers
- Ubuntu 20.04 LTS, most of the fleet
- Python 3.7, two legacy services
- Python 3.8, several services
- Python 3.11, our newer services
- Node.js 16, the legacy frontend API
- Node.js 18, most of our services
- Node.js 20, the newest services
- PostgreSQL 11, the legacy reporting database
- PostgreSQL 12, a secondary database
- PostgreSQL 16, the primary database
- Django 3.2, the legacy web app
- Django 4.2, the main web app
- OpenJDK 8, a legacy Java batch service

For each one, look it up on endoflife.date (the JSON is at https://endoflife.date/api/<product>.json,
for example python.json or postgresql.json, no key needed) and find the matching release cycle. Grab
each product's file once and reuse it for the versions on it. If you can't reach the site or can't finish,
write a short note in the sheet about what failed and how far you got, and stop. Don't make up cycles
or dates, they have to come from endoflife.date.

Here's the bit that actually takes care. endoflife.date gives two different dates per cycle: the end of
active support, and the end of life or security support. They're not the same. A version that's past
active support but still getting security fixes needs an upgrade planned, but it's not on fire. A version
that's past its end-of-life date gets nothing, no security fixes, and that's the urgent one. So read both
dates against today (1 June 2025) and say which bucket each version is in: past end-of-life, security
support only, approaching (end-of-life within about six months, so by the end of November 2025), or
still fully supported.

Then weigh how much each one matters. Already past end-of-life is worse than approaching, and what
the thing is matters too, an end-of-life operating system or database under a live service is a much
bigger deal than an old version of a dev tool on an internal box, and an internet-facing component
outranks an internal one. Put each item that needs attention into a tier, critical, high, medium, and say
why. The versions that are still fully supported don't need a tier or an entry, just note them as fine so it's
clear you checked.

If several things are on the same dead runtime and would move on one upgrade, group them as a single
initiative rather than separate jobs, but list each component.

Write the worklist to my Google Sheet "Tech Debt Tracker" on the tab "EOL Sweep", one row per
inventory item, written straight in. Each row wants at least the product and version, where it runs, the
active-support end date, the end-of-life date, the status bucket, the tier (or "fine" if it's supported), and
a one-line why. Add any columns that seem handy. Every item in the inventory gets a row, don't leave
blanks, and the dates have to match endoflife.date, don't invent them.

Then open an entry in my Notion database TECHDEBT for each item that needs an upgrade (anything past
end-of-life, security-support-only, or approaching), highest tier first. Each entry wants the product and
version, where it runs, the end-of-life date, the status, the tier, and the upgrade target (the current
supported version). Group the shared-upgrade ones into a single entry that lists the components. Don't
open entries for the still-supported items.

Last, post a digest in my Microsoft Teams channel platform, for real. Lead with the critical ones, the past-EOL
operating systems and databases, then high, then medium, then a one-line note on what's still fine.
Short headers and bullets, the kind of thing the team would skim. Numbers should line up with the
sheet and the entries.

The sheet, the Notion entries and the Microsoft Teams post go up live. You're done when every inventory item has a
row with a status and a tier (or "fine"), the ones that need upgrades have an entry, and the digest is up
with numbers that match. If you couldn't finish because endoflife.date was unreachable, then done just
means the failure note's in the sheet and you stopped cleanly.
```

---

## Validation rules

- **Every inventory item is classified.** A status bucket and a tier (or "fine") for each; no blanks. The
  supported ones stay visible so it's clear they were checked.
- **Active-support vs security-support is honored.** A version past active support but pre-EOL is
  security-support-only (plan), not lumped with fully-EOL (urgent); a fully-EOL version is not softened.
- **Status is read against the pinned reference date** (2025-06-01), from the correct cycle.
- **Tiers reflect urgency × criticality.** Past-EOL OS/database under a live/internet-facing service is
  critical; an internal old dev tool is lower; supported versions get no tier.
- **Grouping is correct.** Shared-upgrade items are one initiative listing each component.
- **Entries match.** A `TECHDEBT` entry for each item needing an upgrade and none of the
  still-supported items.
- **No fabricated data.** Every active-support and EOL date matches endoflife.date for the right cycle.
- **Counts reconcile.** inventory = needs-upgrade + supported; entries = needs-upgrade items (after
  grouping); the digest's numbers match the Sheet and the entries.

---

## Expected outputs

1. **Google Sheet `Tech Debt Tracker`, tab `EOL Sweep`** — one row per inventory item with: `Product`,
   `Version`, `Where It Runs`, `Active Support End`, `EOL Date`, `Status`, `Tier`, `Reason`. Created live.
2. **Notion `TECHDEBT` entries** — one per item needing an upgrade (shared-upgrade items grouped), each
   with the version, where it runs, EOL date, status, tier, and upgrade target. Created live.
3. **Microsoft Teams `platform` digest** — critical (past-EOL OS/DB) first, then high, then medium, then a
   still-fine note. Posted live, with the sheet link.
4. **Failure note (only if endoflife.date is unreachable)** — a short note in the Sheet, no fabricated dates.

---

## Grading / how to check (no-seed approach)

There is no seeded answer key by design — the source is live. The run is still **reproducibly gradeable**
because the reference date and inventory are pinned, and judgment quality is graded by spot-check plus
structural checkpoints.

**Freeze the run (this replaces a seeded key):**
- The reference date is pinned (**2025-06-01**), never "today", so "approaching" and "past EOL" are
  deterministic.
- The inventory is fixed (the 15 named items), and the endoflife.date EOL dates for those specific cycles
  are stable historical facts, so the status buckets repeat across runs.
- To grade: the grader looks the same 15 items up on endoflife.date, applies the same reference date, and
  reads the agent's Sheet against the buckets.

**The grading key substitute (what the grader actually does):**
1. **Status spot-check.** Confirm the obvious calls: the clearly-past-EOL items (an old CentOS, the oldest
   Python/Node/PostgreSQL/Django cycles in the list) are past-EOL and tiered high/critical; the current
   LTS versions (the newest Python/Node/PostgreSQL/Django in the list) are "fine" with no entry. The
   **dangerous miss** is a fully-EOL OS or database softened or marked fine; the **noise miss** is a
   supported version flagged for upgrade.
2. **Active-vs-security nuance.** Check the items where the two dates differ (e.g. a cycle in
   security-support-only, or an LTS/ESM case): it should be "plan", not lumped with fully-EOL, and not
   waved off as fully supported either.
3. **Structural checkpoints (objective, pass/fail):** every item classified; entries for exactly the
   needs-upgrade items (grouped sensibly); counts reconcile; no fabricated dates.

**Landing 1–4/7 honestly:**
- **Failing-ish (1–2):** conflates active-support with EOL (softens a fire or over-escalates a planned
  upgrade), mis-reads the cycle and reports a wrong date, flags supported versions, or counts don't
  reconcile. Worst case, fabricates an EOL date.
- **Mediocre (3–4):** mostly-right buckets but the active-vs-security nuance missed on a couple, or a
  mis-tier.
- **Clean (5+):** both dates read correctly, buckets right, tiers reflect criticality, grouping sensible,
  entries match, counts reconcile, nothing fabricated. If a strong model lands here, add more
  ambiguous LTS/ESM cases or a larger inventory.

If Codex scores 5+, harden by adding more cycles where active-support and EOL diverge (LTS, ESM,
extended-support products) and a couple of products with confusing cycle naming.

---

## Feather form fields

- **Workflow name / description:** Software End-of-Life / Tech-Debt Risk Triage (live endoflife.date). Run
  the periodic EOL sweep live off endoflife.date: look each inventory item up, work out its support status
  against a reference date (reading active-support vs security-support), tier by urgency and criticality,
  group upgrade paths, log to a Sheet, file Notion upgrade entries, post a Microsoft Teams digest.
- **Specification level:** Moderately specified — pins the inventory, the reference date and the
  support-status logic (active vs security support), but leaves the urgency × criticality tiering and the
  upgrade-path grouping to the model. Our balance-principle house style.
- **Operating system:** macOS.
- **Applications required:** endoflife.date API (public JSON, no key), Google Sheets, Notion, Microsoft Teams.
- **Local professional environment / resources the agent needs:** my `Tech Debt Tracker` Google Sheet
  (tab `EOL Sweep`), my Notion database `TECHDEBT`, and the `platform` Microsoft Teams channel. endoflife.date needs
  no login, the agent just pulls the public JSON over HTTPS. The inventory it sweeps is what I name in
  the prompt.
- **Additional context (why / when):** I run this every month or so to stay ahead of software going
  unsupported, because an end-of-life OS or database is both a security and a reliability problem and the
  upgrades take planning. The judgment is in reading the two different support dates right (a version can
  be out of active support but still patched, which is plan-soon, versus fully end-of-life, which is urgent),
  weighing how critical the component is, and not crying wolf on versions that are still fine. It feeds the
  platform upgrade roadmap and the quarterly planning.
- **Interim checkpoints / required outputs (for partial credit):** (1) each item looked up on endoflife.date
  and its cycle found; (2) status bucket set against the 2025-06-01 reference date, reading both support
  dates; (3) needs-attention items tiered by urgency × criticality and shared upgrades grouped; (4) worklist
  Sheet written; (5) TECHDEBT entries for exactly the needs-upgrade items; (6) digest posted with
  reconciling counts.
- **Occupation:** Computer Systems Analyst (platform engineering / SRE).
- **Time to complete manually:** ~90 minutes for ~15 items (look each up, read the cycle and both dates,
  bucket, tier, group, log, file entries, write the digest).
- **Times per month:** ~1 (monthly to quarterly).
- **Workflow difficulty (1–7):** **6** — the active-support-vs-security-support read, status-against-a-date,
  criticality weighting and grouping over live lifecycle data, plus the JSON plumbing. A notch below
  WF-047 because the lookup is more bounded than applicability-against-an-estate.
- **Rate the experience and outcome (1–7):** **Model A = 6 (provisional, confirm in-app).** Clean and complete run (active-vs-security read right, OpenJDK-8 mapping handled openly, all 3 writes live), so too easy for us. Harden + rerun. Full per-app notes in `form-1-submission.md` §14.
- **What the rating notes must capture:** per-app status (did the live lookups succeed; did Sheets / Notion /
  Microsoft Teams writes land), exact error text for any failure, the active-vs-security and wrong-date misses found
  in the spot-check with the product/version, whether tiers reflected criticality, and whether any date
  was fabricated.

---

## Implementation considerations

- **NO seeding is required, and why.** The source is the live endoflife.date API. Reproducibility comes
  from **pinning the reference date** (2025-06-01) and the named inventory, not from fixtures. The EOL
  dates for the specific named cycles are stable historical facts.
- **The reference date is the freeze.** "Approaching" and "past EOL" only mean something against a fixed
  date; pinning it (not "today") is what makes the buckets reproducible.
- **Two dates, not one.** The whole eval turns on reading `support` (active) and `eol` (security/EOL)
  separately; an agent that reads only one collapses the security-support-only bucket.
- **One fetch per product.** Cache each product's JSON and reuse it across its versions.
- **Failure path is part of the task, not a crash.** Unreachable site → failure note + stop, no fabricated
  dates. Keeps a low outcome score attributable to judgment, not plumbing.
- **Bounded work.** A fixed 15-item inventory keeps action volume stable and gradeable.

---

## Distinct from

- **WF-047 (its no-seed IT sibling):** WF-047 triages the CISA KEV catalog (vulnerabilities actively
  exploited in the wild, imminent security urgency, CISA due dates, ransomware). WF-048 triages
  software lifecycle (end-of-life dates, active-vs-security support, upgrade-roadmap planning). Different
  source, judgment, and urgency driver (an attacker at the door vs planned obsolescence).
- **WF-040/043/044 (the other no-seed builds):** different live sources and domains (PubMed,
  ClinicalTrials.gov, Grants.gov); this is platform lifecycle management.
- **Approved dependency-vuln example:** that scans a repo's dependency manifests for vulnerable
  packages; this checks a named infrastructure inventory against authoritative end-of-life dates. Different
  source and judgment.
