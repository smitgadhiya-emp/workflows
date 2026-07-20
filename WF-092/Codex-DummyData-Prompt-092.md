# Codex Prompt — Create WF-092 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (Jira, Google Drive/
Sheets/Docs, Microsoft Teams), so create every item **in the actual app** — do NOT write anything
to the local file system.

---

You are setting up **mock source data** for a QA workflow that later prioritizes cross-browser and
device testing for a software release. The workflow will read this data to build a weighted risk
matrix, so the data must be **internally consistent and realistic**, not random. Your job is only
to create the seed data in the connected apps. Do NOT run the QA workflow itself. Do NOT create any
local files — everything must be created officially (Jira issues, Google Sheets, Google Docs, Teams
messages) using the connected plugins.

Use these anchor values everywhere; they must match across every item you create:

- Release version: **4.2.0**
- Jira project key: **WEB**, release fixVersion: **4.2.0**
- GitHub repo (for reference in the mock data): **acme-commerce/storefront**, range **v4.1.0 → v4.2.0**
- GA4 property name (for reference): **Acme Storefront – GA4** (ID 319284756)
- Microsoft Clarity project name (for reference): **Acme Storefront – Clarity** (ID qa7k2m9x1c)
- Reporting window: **2026-04-04 through 2026-07-02**, inclusive (timezone Asia/Kolkata)
- Conversion events: **purchase**, **begin_checkout**, **sign_up**; revenue metric **totalRevenue**
- Supported browsers: Chrome, Safari, Edge, Firefox, Samsung Internet, Opera
- Google Drive folder to put all Sheets and Docs in: **QA / Release 4.2 Notes**
- Microsoft Teams team: **Workflow test**, channel: **Workflow test**

GA4, Microsoft Clarity, and GitHub cannot have data injected into the live products, so represent
each of them as a **Google Sheet in the Drive folder** that stands in as the mock source (same
pattern as a "mock api data" sheet). Jira, Drive, and Teams get real items created in them.

## Consistency rules (enforce all of these across every item)

1. Browser traffic shares total ~100%: Chrome ~45%, Safari ~27%, Edge ~10%, Samsung Internet ~7%,
   Firefox ~5%, Opera ~2%, other ~4%. The single largest cell is Chrome / Windows / Desktop (~40%
   of all traffic); Safari / iOS / iPhone is second (~22%).
2. Include at least one **low-traffic but high-revenue** combo — Safari on macOS Desktop: ~3% of
   users but a high average order value and a revenue share noticeably above its user share. Make
   revenue-per-user vary by combo so revenue ranking ≠ traffic ranking.
3. The release **touches checkout/payment** in the mocked GitHub data: include a payment-form
   refactor, an Apple Pay integration change, and a checkout-page CSS/layout change, visible in the
   file paths and PR labels.
4. Historical browser bugs **cluster** on Safari/iOS and Samsung Internet/Android (give those the
   most open + reopened + regression defects). Chrome/Windows has few, low-severity bugs.
5. The Drive QA notes and the Teams thread independently mention the same two hotspots: a Safari
   checkout / Apple Pay issue and a Samsung Internet sticky-header issue.
6. Realistic device/OS pairings only (Safari↔iOS/macOS, Samsung Internet↔Android, Edge↔Windows).
   Use plausible browser versions and common resolutions (1920×1080, 1536×864, 390×844, 360×800,
   412×915, 1440×900, 768×1024).

## What to create

### A) Google Sheet — "WF-092 GA4 Export – Acme Storefront 4.2.0" (in the Drive folder)
Create this Sheet with three tabs:
- **Tab `browser_device_os_res`** — 40–55 rows, one per browser × deviceCategory × os ×
  screenResolution × country. Columns: `browser, browserVersion, deviceCategory, operatingSystem,
  screenResolution, country, users, newUsers, sessions, engagedSessions, trafficPct, bounceRate,
  conv_purchase, conv_begin_checkout, conv_sign_up, conversionRate, totalRevenue, revenuePct,
  avgOrderValue`. Countries: US, IN, UK, DE, CA, AU. `trafficPct` and `revenuePct` each sum to ~100.
- **Tab `traffic_sources`** — 15–20 rows. Columns: `sessionSource, sessionMedium, referrer,
  sessions, users, totalRevenue, conversions, topBrowser`. Include organic, direct, paid cpc,
  social, referral, email.
- **Tab `conversions`** — Columns: `eventName, browser, deviceCategory, eventCount, eventValue,
  conversionRate` for the top ~8 browser+device combos; sign_up value 0.

### B) Google Sheet — "WF-092 Clarity Export – Acme Storefront 4.2.0" (in the Drive folder)
One tab, 25–35 rows. Columns: `browser, deviceCategory, operatingSystem, sessions, pagesPerSession,
avgScrollDepthPct, rageClicks, deadClicks, excessiveScrolling, quickBackClicks, scriptErrors,
jsErrorSessions`. Safari/iOS and Samsung Internet/Android show elevated rageClicks / deadClicks /
scriptErrors on checkout paths; Chrome/Windows is clean.

### C) Google Sheet — "WF-092 GitHub Changes – storefront v4.1.0→v4.2.0" (in the Drive folder)
Two tabs:
- **Tab `commits`** — 30–45 rows. Columns: `sha, message, author, date, prNumber, module, filePath,
  additions, deletions, riskTags`. `riskTags` (semicolon-separated) from: css, layout, responsive,
  media-query, animation, framework-upgrade, polyfill, browser-api, third-party-bump, checkout,
  payment. Include a framework minor upgrade, a polyfill removal, a new `:has()`/IntersectionObserver
  usage, a Stripe/Apple Pay SDK bump, several checkout/payment CSS + layout edits, responsive
  component changes, media-query and animation tweaks. Realistic paths like
  `src/components/checkout/PaymentForm.tsx`, `src/styles/checkout.css`.
- **Tab `pull_requests`** — 10–15 rows. Columns: `prNumber, title, author, mergedAt, labels,
  filesChanged, additions, deletions, riskSummary, touchesCheckout`. Labels: frontend, css,
  dependencies, payments, responsive.

### D) Jira — issues in project WEB (create these as real tickets)
- **Release scope, fixVersion 4.2.0:** ~12 Stories/Tasks (features going out) + ~8 Bug fixes. For
  each: proper issue type, summary, status, components, labels, story points, fixVersion 4.2.0.
  Components/modules across checkout, payments, dashboard, search, auth, uploads, cart, product-page.
  Label frontend work with frontend/css/responsive/javascript. At least 3 stories are
  frontend/responsive; at least 2 touch checkout or payments.
- **Browser bug history:** 18–26 browser-specific defects reachable by the filter
  `project = WEB AND labels IN (browser-compat, regression)`. Mix of Open, In Progress, Done
  (recently fixed), and Reopened. Each ticket states the browser, browser version, device, OS,
  affected module, and whether it's a regression/reopened. Labels from browser-compat, regression,
  css, layout, ios-safari, samsung-internet, apple-pay. Cluster the worst on Safari/iOS and Samsung
  Internet/Android (rule 4). Created/resolved dates within or shortly before the reporting window.
  Leave all of these unassigned.

### E) Google Docs — in the Drive folder "QA / Release 4.2 Notes"
- **Doc "Release 4.2 QA Notes"** — realistic, human-sounding QA meeting notes. Reference the
  Safari/Apple Pay checkout concern and the Samsung Internet sticky-header issue, plus a couple of
  routine items, and a short "browsers to watch" line. Sound like notes a person typed, not polished.
- **Doc "Browser Support Policy"** — short internal policy: supported browsers, minimum versions,
  mobile-first note, and which combos are tier-1. Consistent with the anchor browser list.

### F) Microsoft Teams — team "Workflow test", channel "Workflow test"
Post a short thread (6–10 messages, plausible named people, timestamps within the window) discussing
Release 4.2 browser risks. Corroborate the same two hotspots (Safari checkout / Apple Pay, Samsung
Internet sticky header). Casual tone.

## When done
Do not create any local files, and do not build the test matrix, the Jira test tasks, the QA report,
or the Teams QA summary — those are the workflow's job, not yours. Report back with: the links/IDs of
the three Google Sheets, the two Google Docs, the Jira issue keys you created (release scope vs.
browser bugs), and a confirmation that the Teams thread was posted. Finish with a one-paragraph note
confirming the six consistency rules were satisfied.