# WF-109 — Dummy Data Inventory

Data that must exist **before** the WF-109 prompt runs. Only the systems the workflow *reads* /
needs-as-destination are seeded. The blueprint Doc, Jira comment/status change, and Teams message
are **outputs** — never pre-create them.

## Key difference from WF-092

WF-092's GitHub was mocked as a Google Sheet because we only needed change *signals*. WF-109 is
different: the workflow **analyzes an actual codebase** (framework, folder structure, models,
migrations, services, controllers, existing APIs, jobs, events). You cannot mock a codebase as a
spreadsheet — so GitHub here must be a **real repository with a realistic backend app**, created on
GitHub via the connector (still not on the local file system).

## Anchor values (fill these into the WF-109 prompt brackets)

| Placeholder | Value |
|---|---|
| `[Jira project key/name]` | `API` — "Acme API Platform" |
| `[Jira board/filter or JQL]` | `project = API AND status in ("Ready for Development","Selected for Development") AND component in (Backend, API)` |
| `[priority and tie-break rule]` | Highest Jira priority first; tie-break by board rank (topmost), then oldest created |
| `[GitHub org/repo]` | `acme-commerce/storefront-api` |
| `[branch name]` | `develop` |
| `[number]` (checklist threshold for arch guidance) | `15` |
| `[Google Doc or markdown file]` | Google Doc |
| `[exact Drive folder or exact repo docs path]` | Drive folder `Engineering / Backend Blueprints` |
| `[final Jira status]` | `Analysis Complete` |
| `[exact Team name]` | `Workflow test` |
| `[exact channel or chat]` | `Workflow test` |
| Framework of the seeded repo | Laravel 11 (PHP 8.3) |
| The feature the selected ticket describes | Product Reviews & Ratings |

## Seed these (INPUTS the workflow reads)

1. **GitHub repo `acme-commerce/storefront-api`, branch `develop`** — a real, coherent Laravel 11
   backend with existing domains (Users, Products, Categories, Orders, Cart, Addresses) and all the
   architectural elements the workflow reports on: validation (Form Requests), auth (Sanctum),
   policies, exception handler, logging, events/listeners, queues/jobs, caching, API versioning (v1),
   repositories/services, DTMs/Resources, factories/seeders, l5-swagger, a few existing tests.
   The Reviews feature is **deliberately absent** — it's the new thing the blueprint is for.
2. **Jira project `API`** with:
   - The **primary selected issue** — "Product Reviews & Ratings API" — highest priority,
     status *Selected for Development*, component Backend/API, fully scoped: description, acceptance
     criteria, comments (API contract + client requirement), a design-link attachment, and a linked
     frontend task. This is what the workflow must pick and be able to blueprint.
   - **Decoy issues** so selection is a real decision: 2–3 lower-priority backend issues, one
     frontend-only issue, one lower-priority under-specified issue. None outrank the primary.
   - Workflow statuses must include *Analysis In Progress* and *Analysis Complete*.
3. **Google Drive folder `Engineering / Backend Blueprints`** — exists and empty (blueprint output
   destination).
4. **Microsoft Teams `Workflow test` / `Workflow test`** — exists (reuse from WF-092).

## Do NOT seed (OUTPUTS the workflow produces)
- The "… – Backend Implementation Blueprint" Google Doc
- The structured Jira comment + status flips (Analysis In Progress → Analysis Complete)
- The Teams "Backend blueprint ready: …" message

## Consistency contract (what makes the blueprint derivable/verifiable)
1. The repo already has **Products, Users, Orders** so the new Reviews feature has real things to
   relate to, and the "only customers who purchased can review" rule is checkable against Orders.
2. Reviews is genuinely **new** — no `reviews` table, model, controller, or rating columns on
   `products` exist yet, so the impact/migration analysis has real work to describe.
3. The selected ticket's acceptance criteria imply **specific** DB changes (new `reviews` +
   `review_votes` tables, `rating_avg`/`rating_count` on `products`) and **specific** APIs (create/
   list/update/delete review, vote), so impact analysis can be graded against ground truth.
4. The repo contains real **perf/security hooks** for the risk pass: an N+1-prone product listing,
   a cache layer on product reads (cache-invalidation concern), Sanctum auth + policies (security
   pass), API versioning (backward-compat concern).
5. The highest-priority backend issue is the **well-scoped** one, so the run proceeds rather than
   hitting the prompt's "under-specified → leave in Analysis In Progress and post blocker" path.