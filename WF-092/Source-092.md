[release]	4.2.0 (appears ~8x: matrix sheet name, Jira tasks, QA report, Teams post)
[Jira project/key]	WEB, release fixVersion = 4.2.0
[bug JQL/filter]	project = WEB AND labels IN (browser-compat, regression)
[repo]	acme-commerce/storefront, range v4.1.0 -> v4.2.0 (referenced in mock data, not read live)
[GA4 property]	Acme Storefront – GA4 (319284756) — read from the mock export sheet, not live
[Clarity project]	Acme Storefront – Clarity (qa7k2m9x1c) — read from the mock export sheet, not live
[conversion events]	purchase, begin_checkout, sign_up ; revenue metric totalRevenue (GA4 purchaseRevenue)
[window]	2026-04-04 through 2026-07-02 inclusive (Asia/Kolkata) — a fixed data window; all mock rows fall inside it
[drive folder]	QA / Release 4.2 Notes (holds the 3 mock sheets + 2 seeded docs; the run adds the matrix sheet + QA report here)
[team name] > [channel name]	Workflow test > Workflow test
[ranked combos]	12 (one Jira task each)
[supported browsers]	Chrome, Safari, Edge, Firefox, Samsung Internet, Opera

Mock-source note:
GA4, Microsoft Clarity, and GitHub CANNOT have data injected into the live products, so each is a
Google Sheet in the "QA / Release 4.2 Notes" Drive folder that stands in as the mock source. Jira,
Drive Docs, and the Teams thread are real items. The workflow reads all of these; it does not touch a
live GA4/Clarity/GitHub API. (Older files said team "Acme QA" / channel "QA" — that is WRONG; the
prompt and seed both use team "Workflow test", channel "Workflow test".)

Seeded artifacts (created in the real apps; this is the "folder/file structure" the run reads):
- Sheet "WF-092 GA4 Export – Acme Storefront 4.2.0" — tabs: browser_device_os_res, traffic_sources, conversions
- Sheet "WF-092 Clarity Export – Acme Storefront 4.2.0" — 1 tab (rageClicks / deadClicks / scriptErrors per combo)
- Sheet "WF-092 GitHub Changes – storefront v4.1.0->v4.2.0" — tabs: commits, pull_requests
- Doc "Release 4.2 QA Notes" — human-sounding QA meeting notes (Safari/Apple Pay + Samsung sticky-header)
- Doc "Browser Support Policy" — supported browsers, min versions, tier-1 combos
- Jira WEB: ~12 release-scope stories/tasks + ~8 bug fixes (fixVersion 4.2.0) + 18–26 browser-compat/
  regression bug-history issues (open / in-progress / done / reopened), all unassigned
- Teams "Workflow test" > "Workflow test": a 6–10 message discussion thread (named people, in-window)

Consistency contract (what makes the ranking verifiable):
1. Browser traffic shares ~100%: Chrome ~45, Safari ~27, Edge ~10, Samsung Internet ~7, Firefox ~5,
   Opera ~2, other ~4. Largest cell Chrome/Windows/Desktop ~40%; Safari/iOS/iPhone second ~22%.
2. At least one LOW-traffic / HIGH-revenue combo (Safari on macOS Desktop: ~3% users, AOV + revenue %
   well above user %) so revenue ranking diverges from traffic ranking.
3. Checkout/payment IS touched in the GitHub mock (payment-form refactor + Apple Pay change + checkout
   CSS) so the checkout factor (5 pts) and the x1.25 multiplier both fire.
4. Historical browser bugs CLUSTER on Safari/iOS and Samsung Internet/Android (most open + reopened +
   regression); Chrome/Windows is few + low severity.
5. Drive notes AND the Teams thread independently corroborate the same two hotspots (Safari checkout /
   Apple Pay, Samsung Internet sticky header).
6. Realistic device/OS pairings only (Safari<->iOS/macOS, Samsung Internet<->Android, Edge<->Windows);
   plausible versions + common resolutions (1920x1080, 1536x864, 390x844, 360x800, 412x915, 1440x900,
   768x1024).

Risk score (per browser/device combo, 1–100; from the prompt):
traffic 20 + revenue 20 + conversion value 10 + features affected 15 + prior browser-bugs 15 +
device/OS popularity 10 + device impact 5 + checkout-touched 5, then x1.25 if checkout/payment is
affected, capped at 100. Bands: Critical 80–100, High 60–79, Medium 40–59, Low 1–39.

Expected top tier after scoring (for review, NOT an answer key to paste):
Chrome/Windows/Desktop, Chrome/Android/Mobile, Safari/iPhone/iOS. Safari/macOS/Desktop rises above its
traffic rank on the revenue factor (contract rule 2). Safari/iOS and Samsung Internet/Android carry the
prior-bug weight (rule 4).

Outputs the run produces (NOT seeded — see Cleanup-092.md):
- Sheet "Release Browser Test Matrix 4.2.0" (in the Drive folder)
- ~12 Jira tasks in WEB, one per ranked combo, labels browser-testing + release-testing + priority,
  unassigned
- A QA report Google Doc (usage summary, device split, high-risk browsers, recommended order, overall
  compatibility risk) — the prompt does not fix its title
- A single Teams summary message in Workflow test > Workflow test (critical order, high-risk areas,
  Jira task count, links)

Verify-after-Codex note:
Names above are what the seed prompt instructs. If Codex creates a sheet/doc/issue under a different
name, replace the value here and in Prompt-092.md with the exact names Codex reports, plus the real
Sheet/Doc URLs and Jira keys. The run joins GA4/Clarity/GitHub data by browser+device+os, so a browser
or resolution string that drifts between the three mock sheets silently changes a combo's score.
