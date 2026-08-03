I look after our platform and I run a tech-debt sweep to catch software that's gone end-of-life or is about to, working off endoflife.date, live. Treat today as 1 June 2025 for any of the date math.

Here's the inventory I'm sweeping, product, version, and where it runs:

CentOS 7, on most of our app servers, some internet-facing
Ubuntu 18.04 LTS, a handful of legacy build servers
Ubuntu 20.04 LTS, most of the fleet
Python 3.7, two legacy services
Python 3.8, several services
Python 3.11, our newer services
Node.js 16, the legacy frontend API
Node.js 18, most of our services
Node.js 20, the newest services
PostgreSQL 11, the legacy reporting database
PostgreSQL 12, a secondary database
PostgreSQL 16, the primary database
Django 3.2, the legacy web app
Django 4.2, the main web app
OpenJDK 8, a legacy Java batch service
For each one, look it up on endoflife.date (the JSON is at https://endoflife.date/api/<product>.json, for example python.json or postgresql.json, no key needed) and find the matching release cycle. Grab each product's file once and reuse it for the versions on it. If you can't reach the site or can't finish, write a short note in the sheet about what failed and how far you got, and stop. Don't make up cycles or dates, they have to come from endoflife.date.

Here's the bit that actually takes care. endoflife.date gives two different dates per cycle: the end of active support, and the end of life or security support. They're not the same. A version that's past active support but still getting security fixes needs an upgrade planned, but it's not on fire. A version that's past its end-of-life date gets nothing, no security fixes, and that's the urgent one. So read both dates against today (1 June 2025) and say which bucket each version is in: past end-of-life, security support only, approaching (end-of-life within about six months, so by the end of November 2025), or still fully supported.

Then weigh how much each one matters. Already past end-of-life is worse than approaching, and what the thing is matters too, an end-of-life operating system or database under a live service is a much bigger deal than an old version of a dev tool on an internal box, and an internet-facing component outranks an internal one. Put each item that needs attention into a tier, critical, high, medium, and say why. The versions that are still fully supported don't need a tier or an entry, just note them as fine so it's clear you checked.

If several things are on the same dead runtime and would move on one upgrade, group them as a single initiative rather than separate jobs, but list each component.

Write the worklist to my Google Sheet "Tech Debt Tracker" on the tab "EOL Sweep", one row per inventory item, written straight in. Each row wants at least the product and version, where it runs, the active-support end date, the end-of-life date, the status bucket, the tier (or "fine" if it's supported), and a one-line why. Add any columns that seem handy. Every item in the inventory gets a row, don't leave blanks, and the dates have to match endoflife.date, don't invent them.

Then open an entry in my Notion database TECHDEBT for each item that needs an upgrade (anything past end-of-life, security-support-only, or approaching), highest tier first. Each entry wants the product and version, where it runs, the end-of-life date, the status, the tier, and the upgrade target (the current supported version). Group the shared-upgrade ones into a single entry that lists the components. Don't open entries for the still-supported items.

Last, post a digest in my Microsoft Teams channel platform, for real. Lead with the critical ones, the past-EOL
operating systems and databases, then high, then medium, then a one-line note on what's still fine. Short headers and bullets, the kind of thing the team would skim. Numbers should line up with the sheet and the entries.

The sheet, the Notion entries and the Microsoft Teams post go up live. You're done when every inventory item has a row with a status and a tier (or "fine"), the ones that need upgrades have an entry, and the digest is up with numbers that match. If you couldn't finish because endoflife.date was unreachable, then done just means the failure note's in the sheet and you stopped cleanly.


Metadata:

1. Occupation / career (dropdown choice):
-> Computer software analyst 
2. Occupation + workplace (one line, this is the persona voice):
-> Platform engineering / SRE, running the periodic end-of-life tech-debt sweep across our software estate.
3. Time to complete this workflow WITHOUT a model (minutes):
-> 90 minutes
4. Times PER MONTH I run this workflow (decimal ok, 0.5 = every 2 months):
-> 1
5. Workflow difficulty 1-7 (1 easy, 7 hard):
-> 6