# WF-048 — Form 1 (Feather submission) — ready to paste

The **first form** you fill when the prompt is created: the workflow-definition / submission form. This is the
clean, copy-paste view of the **Feather form fields** in the [main file](WF-048-software-eol-tech-debt-triage.md)
(the canonical source), laid out field-by-field in the exact order the Feather form asks, in the submission voice.
This is a **no-seed / live** build, reproducibility comes from the pinned reference date + inventory in field 1,
not fixtures. Fields 13 and 14 are the only ones you fill **after** the Codex run.

> House rules this meets: field 1 is instructions (reads human, no AI tells, no em-dashes, first person is fine),
> ≥2 apps (reads the live endoflife.date API, acts in Sheets + Notion + Teams), ends in real changes (a live
> Sheet, Notion TECHDEBT entries, a Teams digest), names every resource, pins what affects scoring (the
> inventory, the reference date, the active-vs-security-support logic) and leaves the tiering/grouping open
> (Moderately specified). See [`../../../forms/form-1-workflow-definition.md`](../../../forms/form-1-workflow-definition.md).

---

## 1. Workflow description / prompt
*(paste this whole block as the prompt — it is Part B verbatim)*

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

## 2. How specified is this workflow prompt?
**Moderately specified.** It pins the inventory, the reference date and the support-status logic (active vs
security support), but leaves the urgency × criticality tiering and the upgrade-path grouping to the model. (Our
balance-principle house style.)

## 3. Local professional environment & resources the agent needs
My `Tech Debt Tracker` Google Sheet (tab `EOL Sweep`), my Notion database `TECHDEBT`, and the `platform` Microsoft
Teams channel. endoflife.date needs no login, the agent just pulls the public JSON over HTTPS. The inventory it
sweeps is what I name in the prompt.

## 4. Operating system
macOS.

## 5. Applications required
endoflife.date API (public JSON, no key), Google Sheets, Notion, Microsoft Teams.

## 6. Additional context (why / when / larger workflow)
I run this every month or so to stay ahead of software going unsupported, because an end-of-life OS or database is
both a security and a reliability problem and the upgrades take planning. The judgment is in reading the two
different support dates right (a version can be out of active support but still patched, which is plan-soon,
versus fully end-of-life, which is urgent), weighing how critical the component is, and not crying wolf on
versions that are still fine. It feeds the platform upgrade roadmap and the quarterly planning.

## 7. Interim checkpoints / required outputs (for partial credit)
1. Each item looked up on endoflife.date and its cycle found
2. Status bucket set against the 2025-06-01 reference date, reading both support dates
3. Needs-attention items tiered by urgency × criticality and shared upgrades grouped
4. Worklist Sheet written
5. TECHDEBT entries for exactly the needs-upgrade items
6. Digest posted with reconciling counts

## 8. Occupation category (dropdown)
**Computer Systems Analyst** — nearest allowed dropdown value; consistent with the other IT builds. The platform /
SRE specialization is in field 9.

## 9. Occupation & workplace
Platform engineering / SRE, running the periodic end-of-life tech-debt sweep across our software estate.

## 10. Time to complete manually (minutes)
**90** *(confirm your own honest figure — for ~15 items: look each up, read the cycle and both dates, bucket,
tier, group, log, file entries, write the digest)*

## 11. Times per month
**1** *(monthly to quarterly)*

## 12. Workflow difficulty (1 easy – 7 hard)
**6** *(the active-support-vs-security-support read, status-against-a-date, criticality weighting and grouping
over live lifecycle data, plus the JSON plumbing; a notch below WF-047 because the lookup is more bounded than
applicability-against-an-estate)*

## 13. Rate the experience and outcome (1 horrible – 7 perfect)
**6 (provisional, off Codex's own summary, confirm in-app).** This one it did end to end and got the tricky part
right, so on the evidence it's a clean run, which for us is the problem, it means too easy (a 5+ gets bounced, we
want 1-3). The main thing is it read the active-support vs security-support split properly instead of calling
everything EOL, it wrote "not provided in API" where endoflife.date doesn't give a separate active date instead of
making one up, and it even said out loud it was treating our generic "OpenJDK 8" as the Red Hat build of OpenJDK
because that's the cycle that matches, rather than hiding the guess. All three writes landed live this time, the
sheet, the 5 Notion entries and the Teams digest. So treat this as a harden-and-rerun, not a submit: add more of
the messy LTS/ESM cases where the two dates split, a bigger inventory, maybe a product or two with confusing cycle
names, per the "if 5+" note in the file. Final number pending the in-app check and a Claude side-by-side.

## 14. Notes on Codex's performance
**Session ID:** _(paste from the Codex session)_ · **Runtime:** 7 min 40 sec

The detail that sold me was the OpenJDK 8 call. endoflife.date splits Java out by distribution, and instead of
quietly guessing, it mapped our generic "OpenJDK 8" onto the Red Hat build of OpenJDK on cycle 8 and wrote that
down in the sheet's source column. That's the sort of thing a careful engineer does and a rushed one skips right
past.

The rest was in the same spirit. The whole test on this one is whether it reads the two support dates as two
different dates, and it did, the 15 items came out as 10 past EOL, 3 security-support-only, 2 still fine and 0
approaching, so the past-active-support ones didn't get mashed in with the fully dead ones. Where endoflife.date
publishes no separate active date it wrote "not provided in API" and made nothing up. It pulled each product's
file once and reused it across the versions, and before writing to Notion or Teams it did a readback of the sheet
(A1:N16) to check its own row counts, which I always like to see. Grouping was sensible, the 13 that need
attention folded into 5 initiatives (Linux OS, PostgreSQL major-version, Node.js, Python, Django), OS and
database tiered critical, runtimes and framework high, about the shape I'd have drawn myself.

Everything landed this time, unlike the KEV run where the channel wasn't visible to the connector. The
endoflife.date pull worked. "Tech Debt Tracker" / "EOL Sweep" has its 15 rows and the readback matched. Notion
TECHDEBT has 5 entries (2 critical Linux/PostgreSQL, 3 high Node/Python/Django), and since that schema is only
Name/priority/status/type it kept those and put the per-component detail in the page body, mapping critical/high
onto Notion's High with the exact tier still in the body. The digest posted to "platform", resolved uniquely
under the Development team. Counts agree end to end, 15 rows, 13 upgrades, 5 entries, 2 fine.

I'll still put eyes on the cells by hand, mostly the membership of the 3 security-support-only versus the 2 fine
(Ubuntu 20.04, Node 20, Django 4.2, and that OpenJDK mapping) and whether the active-support and EOL dates match
endoflife.date cycle by cycle. Nothing read as invented, but I want to see it rather than trust the summary. It's
a 6, so it wants a nastier inventory before we'd submit, and a Claude run alongside for the compare.

## 15. Confidentiality checkbox
Tick after confirming the prompt text holds no real client data or credentials. (It doesn't — endoflife.date is a
public feed and the inventory named is a generic, non-confidential software list.)
