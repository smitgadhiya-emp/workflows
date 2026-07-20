# WF-092 — Dummy Data Inventory

Data that must exist **before** the WF-092 prompt runs. Only the systems the workflow *reads*
are listed. The four write targets (Google Sheet matrix, Jira test tasks, Google Doc QA report,
Teams summary) are produced by the workflow and need no seeding.

## Anchor values (fill these into the WF-092 prompt brackets)

Keep every dataset consistent with these. Change them if you like, but change them everywhere.

| Placeholder | Value |
|---|---|
| `[version]` | `4.2.0` |
| `[Jira project/key]` | `WEB` |
| `[fixVersion/filter]` | fixVersion = `4.2.0` |
| `[owner/repo]` | `acme-commerce/storefront` |
| `[base ref] to [release ref]` | `v4.1.0` → `v4.2.0` |
| `[GA4 property name/ID]` | `Acme Storefront – GA4` / `319284756` |
| `[Clarity project name/ID]` | `Acme Storefront – Clarity` / `qa7k2m9x1c` |
| date range | `2026-04-04` → `2026-07-02` (inclusive) |
| `[conversion event names]` | `purchase`, `begin_checkout`, `sign_up` |
| `[revenue metric]` | `totalRevenue` (GA4 `purchaseRevenue`) |
| `[Jira bug JQL/filter]` | `project = WEB AND labels IN (browser-compat, regression)` |
| `[folder name/path]` | `QA / Release 4.2 Notes` |
| `[Teams team name]` | `Acme QA` |
| `[Teams channel name]` | `QA` |
| `[number]` (ranked combos) | `12` |

## Consistency contract (what makes the ranking verifiable)

1. Browser traffic shares sum to ~100%: Chrome ~45%, Safari ~27%, Edge ~10%, Samsung Internet ~7%,
   Firefox ~5%, Opera ~2%, other ~4%. Chrome/Windows/desktop is the single largest cell (~40%),
   Safari/iOS/iPhone second.
2. At least one **low-traffic / high-revenue** browser exists (e.g. Safari on macOS desktop: small
   user %, high AOV and revenue %) so the revenue factor diverges from the traffic factor.
3. **Checkout/payment is touched in GitHub** (payment form refactor + Apple Pay change + checkout
   CSS) so the checkout factor (5 pts) and the ×1.25 multiplier both fire.
4. Historical browser bugs **cluster** on Safari/iOS and Samsung Internet/Android so those combos
   score higher on the prior-bug factor (15 pts).
5. Drive notes and the Teams thread corroborate the same two hotspots (Safari checkout, Samsung
   Internet sticky header) so cross-source evidence lines up.
6. Expected top tier after scoring: Chrome/Windows/Desktop, Chrome/Android/Mobile, Safari/iPhone/iOS.

## Files produced

```
WF-092-dummy-data/
├── README.md                       # index + anchor values + how files interrelate
├── data-dictionary.md              # every column/field explained
├── ga4/
│   ├── ga4_browser_device_os_res.csv
│   ├── ga4_traffic_sources.csv
│   └── ga4_conversions.csv
├── clarity/
│   └── clarity_browser_device.csv
├── jira/
│   ├── jira_release_scope.json     # fixVersion 4.2.0: features + bug fixes + modules
│   └── jira_browser_bugs.json      # open / fixed / reopened / regression / compat
├── github/
│   ├── github_commits.json         # v4.1.0..v4.2.0 with per-file risk tags
│   └── github_pull_requests.json
├── drive/
│   ├── release-4.2-qa-notes.md
│   └── browser-support-policy.md
└── teams/
    └── teams-qa-thread.md
```