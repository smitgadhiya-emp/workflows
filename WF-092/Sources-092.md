
#	Placeholder in prompt	What it is	Example value
1	[version]	Release number (appears ~8×: title, sheet name, tasks, Teams post)	4.2.0
2	[Jira project/key]	Jira project the release lives in	WEB
3	[fixVersion/filter]	How to find the release's issues in Jira	fixVersion = 4.2.0
4	[owner/repo]	GitHub repository	acme-commerce/storefront
5	[base ref]	Start of the release code range	v4.1.0
6	[release ref]	End of the release code range	v4.2.0
7	[GA4 property name/ID]	Google Analytics 4 property	Acme Storefront – GA4 / 319284756
8	[Clarity project name/ID]	Microsoft Clarity project	Acme Storefront – Clarity / qa7k2m9x1c
9	[conversion event names]	Events counted as conversions	purchase, begin_checkout, sign_up
10	[revenue metric]	Which revenue figure to rank on	totalRevenue (GA4 purchaseRevenue)
11	[Jira bug JQL/filter]	Query for browser-specific bugs	project = WEB AND labels IN (browser-compat, regression)
12	[folder name/path]	Google Drive folder with QA notes	QA / Release 4.2 Notes
13	[team name]	Microsoft Teams team	Acme QA
14	[channel name]	Microsoft Teams channel	QA
15	[number]	How many ranked browser/device combos to create Jira tasks for	12


Notes
Date range is already hardcoded in the prompt (April 4 2026 through July 2 2026), so it's not a bracket — but your dummy data must cover exactly that window.
Several placeholders repeat: [version] and [GA4 property name/ID] each appear many times — replace all occurrences, not just the first.
The Google Sheet name ("Release Browser Test Matrix [version]") and the QA report/Doc are outputs, so their names derive from [version] — no separate value needed.
Keep these identical to the anchor values in DummyData-Inventory-092.md; if you change one (e.g. combo count from 12), change it in both places.