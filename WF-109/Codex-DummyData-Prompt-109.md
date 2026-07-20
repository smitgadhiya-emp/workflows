# Codex Prompt — Create WF-109 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (Jira, GitHub, Google
Drive/Docs, Microsoft Teams), so create every item **in the actual app** — do NOT write anything to
the local file system.

---

You are setting up **mock source data** for a workflow that produces a backend implementation
blueprint before coding starts. The workflow later reads a Jira ticket and analyzes a backend
GitHub repository, then writes a blueprint doc, a Jira comment, and a Teams message. Your job is
only to create the seed data (the ticket and the codebase it analyzes) in the connected apps. Do
NOT run the blueprint workflow itself. Do NOT create any local files — everything must be created
officially (a real GitHub repo, real Jira issues, a Drive folder) using the connected plugins.

Use these anchor values everywhere; they must match across every item you create:

- Jira project: key **API**, name **Acme API Platform**
- GitHub repo: **acme-commerce/storefront-api**, primary branch **develop**
- Framework of the repo: **Laravel 11 (PHP 8.3)**
- Feature the selected ticket describes: **Product Reviews & Ratings**
- Google Drive folder (blueprint destination): **Engineering / Backend Blueprints**
- Microsoft Teams team: **Workflow test**, channel: **Workflow test**

GitHub cannot be mocked as a spreadsheet here because the workflow analyzes real code, so create an
actual repository with a coherent (not necessarily fully runnable) Laravel backend that is rich
enough to analyze.

## Consistency rules (enforce all of these)

1. The repo already contains **Users, Products, Categories, Orders, OrderItems, Cart, CartItems,
   Addresses** domains with Eloquent relationships, so the new Reviews feature has real things to
   relate to and the "only customers who purchased can review" rule is checkable against Orders.
2. The **Reviews feature is deliberately absent** — no `reviews`/`review_votes` tables, no Review
   model/controller/migration, and no `rating_avg`/`rating_count` columns on `products`. It is the
   new thing the blueprint will describe.
3. The selected Jira ticket's acceptance criteria imply **specific** DB changes (new `reviews` and
   `review_votes` tables, `rating_avg` + `rating_count` on `products`) and **specific** APIs
   (create / list-by-product / update / delete a review, and vote helpful), so impact analysis can
   be graded against ground truth.
4. The repo includes real hooks for the risk pass: an N+1-prone product listing endpoint, a cache
   layer on product reads (cache-invalidation concern), Sanctum auth + policies (security pass),
   and `/api/v1` versioning (backward-compatibility concern).
5. The highest-priority backend/API issue is the **well-scoped** Reviews ticket, so a workflow run
   would proceed rather than hit the "under-specified → blocker" path.

## What to create

### A) GitHub repository — `acme-commerce/storefront-api` (branch `develop`)
Create a real repo with a coherent Laravel 11 backend. Include representative, cross-referenced
files (they must be internally consistent — models match migrations, routes match controllers,
service bindings match providers). Aim for analyzable depth, not a full production app.

- `composer.json` — laravel/framework ^11, laravel/sanctum, darkaonline/l5-swagger, predis/predis;
  PHP ^8.3. `README.md` with a short architecture summary (MVC + service/repository layering).
- **Models** (`app/Models/`): User, Product, Category, Order, OrderItem, Cart, CartItem, Address —
  with `hasMany`/`belongsTo`/`belongsToMany` relationships. No Review model.
- **Migrations** (`database/migrations/`): create tables for all of the above with foreign keys,
  indexes, unique constraints, timestamps, and soft deletes on Product and Order. No reviews table,
  no rating columns.
- **Controllers** (`app/Http/Controllers/Api/V1/`): AuthController, ProductController,
  CategoryController, OrderController, CartController. Make ProductController@index N+1-prone
  (loads products then accesses a relation in a loop) and cache the product show response.
- **Form Requests** (`app/Http/Requests/`): validation classes for store/update on Product, Order,
  Cart. **API Resources / DTOs** (`app/Http/Resources/`): ProductResource, OrderResource, etc.
- **Services** (`app/Services/`): ProductService, OrderService, CartService.
- **Repositories** (`app/Repositories/` + `Contracts/` interfaces): ProductRepository,
  OrderRepository, bound in `app/Providers/RepositoryServiceProvider.php`.
- **Policies** (`app/Policies/`): OrderPolicy, ProductPolicy, registered in AuthServiceProvider.
- **Middleware** (`app/Http/Middleware/`): one custom (e.g. ForceJsonResponse) plus Sanctum auth.
- **Events + Listeners** (`app/Events/`, `app/Listeners/`): OrderPlaced → SendOrderConfirmation.
- **Jobs** (`app/Jobs/`): a queued job, e.g. RecalculateProductPopularity.
- **Notifications** (`app/Notifications/`): OrderConfirmation.
- `app/Exceptions/Handler.php`, logging config, `config/cache.php`, `config/queue.php`,
  `config/sanctum.php`.
- **Routes** (`routes/api.php`): all endpoints under `/api/v1`, protected by Sanctum where relevant.
- **Factories + Seeders** (`database/factories/`, `database/seeders/`) for User, Product, Order.
- **Swagger**: l5-swagger annotations on the controllers.
- **Tests** (`tests/Feature/`, `tests/Unit/`): a few, e.g. ProductApiTest, OrderServiceTest — so the
  workflow can point at existing tests that need updating.

### B) Jira — project `API` (create these as real issues)
First make sure the project workflow has the statuses **Selected for Development**, **Ready for
Development**, **Analysis In Progress**, and **Analysis Complete**, and components **Backend** and
**API**. Then create:

- **Primary issue (the one the workflow must select):** type Story, summary
  **"Product Reviews & Ratings API"**, priority **Highest**, status **Selected for Development**,
  component **Backend, API**, ranked top of the board. Fully scoped:
  - Description: customers can review products they purchased; 1–5 star rating + text; one review per
    product per customer; edit/delete own review; mark reviews helpful; product pages show average
    rating and count.
  - Acceptance criteria that imply the DB/API changes in consistency rule 3.
  - 2–3 comments: one containing a proposed **API contract** (endpoints + request/response JSON),
    one a **client requirement** (mobile app needs average rating in the product list response).
  - A **design link / attachment** (a Figma-style URL or attached spec).
  - A **linked frontend task** (e.g. "Product page: reviews section UI").
- **Decoy issues** (none may outrank the primary):
  - 2–3 lower-priority backend/API issues, Ready/Selected for Development (e.g. "Add coupon code
    validation endpoint", "Order export CSV job", "Rate-limit auth endpoints").
  - One **frontend-only** issue (component Frontend) so it's correctly skipped.
  - One **under-specified** low-priority backend issue (title only, no acceptance criteria) to test
    that selection still lands on the well-scoped primary.
  Leave every issue **unassigned**.

### C) Google Drive
Ensure the folder **Engineering / Backend Blueprints** exists and is empty. Do not put a blueprint
in it — that is the workflow's output.

### D) Microsoft Teams
Confirm the team **Workflow test** and channel **Workflow test** exist. Do not post anything — the
completion message is the workflow's output.

## When done
Do not create any local files. Do not generate the blueprint document, do not post the Jira analysis
comment, do not change the primary ticket's status to Analysis In Progress or Analysis Complete, and
do not post the Teams message — those are all the workflow's outputs, not seed data. Report back
with: the GitHub repo URL and confirmation branch `develop` exists, the Jira issue keys (clearly
marking which is the primary Reviews issue vs. the decoys), the Drive folder link, and confirmation
the Teams team/channel exist. Finish with a one-paragraph note confirming the five consistency rules
were satisfied (especially that the Reviews feature is absent from the codebase).