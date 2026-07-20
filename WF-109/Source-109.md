[Jira project key/name]	API (Acme API Platform)

[Jira board/filter or JQL]	project = API AND status = "To Do" AND component in (Backend, API)
[priority and tie-break rule]	highest Jira priority first, tie-break by board rank then oldest created
[GitHub org/repo]	keyurempiricinfotech-art/acme-commerce
[branch name]	develop
[number]	15
[Google Doc or markdown file] (×2)	Google Doc
[exact Drive folder or exact repo docs path]	Engineering / Backend Blueprints
[final Jira status]	In Review
[in-progress status (hardcoded in prompt)]	In Progress (was Analysis In Progress)
[selection status (hardcoded in prompt)]	To Do (was Selected/Ready for Development)
[exact Team name] / [exact channel or chat]	Workflow test / Workflow test

Runtime value left as-is:
Backend blueprint ready: [selected Jira issue summary] — the Teams header bracket is filled by the workflow from whichever ticket it selects (resolves to "Product Reviews & Ratings API"), not a value you pre-fill.

Note: status names were remapped to the ones the Jira project actually exposes (To Do / In Progress / In Review / Done) because the custom statuses could not be added through the connector. Repo name matches what Codex actually created.
