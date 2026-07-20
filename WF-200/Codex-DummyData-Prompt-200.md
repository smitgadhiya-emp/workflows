# Codex Prompt — Create WF-200 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (GitHub, Jira, Google
Drive/Sheets, Microsoft Teams). **Create every item in the actual app. Do NOT write anything to the
local file system.**

---

You are setting up **mock source data** for a workflow that audits authentication coverage across
Next.js Server Actions, then files Jira tickets, upserts a coverage matrix Sheet, and posts a Teams
summary. Your job is ONLY to create the seed data the workflow reads.

**Do NOT run the audit.** Do NOT decide or record verdicts, do NOT compute or write severity scores,
do NOT create the audit Jira tickets, do NOT post to Teams, and do NOT write this run's rows into the
coverage matrix. The tables below tell you what code to *write* so the audit has something true to
find — they are your build spec, not output to be transcribed into a sheet.

## Where each source lives

- **GitHub, Jira, Google Drive/Sheets, Teams** → create real items via the connectors.
- **Invocation traffic + caller exposure** → cannot be injected into live Vercel/APM, so they are a
  **Google Sheet** that stands in as the mock source.
- **The code must be real.** This whole audit pins an action to a file, a line, and a guard, so the
  repo is an actual working-looking Next.js app, not a spreadsheet describing one.

## Anchor values (use everywhere; keep identical across every item)

- GitHub repo: **sahidempiricinfotech-dotcom/next-action-audit**, branch **main** (the default branch).
  If it already exists, update files in place — do not create a second repo.
- Folders in scope: `app/`, `src/actions/`, `src/components/`, `src/lib/`
- Google Drive folder for both Sheets: **Engineering / Server Action Audit**
- Traffic sheet: **Action Traffic Data**
- Tracker sheet: **Server Action Auth Coverage Matrix**
- Jira project: key **SAA**, name **Server Action Audit**
- Microsoft Teams: team **Workflow test**, channel **server action audit**
- Traffic window: **2026-06-15 through 2026-07-14** inclusive, Asia/Kolkata
- Stack: Next.js 14 App Router, TypeScript, `next-auth` (`getServerSession`), Prisma

## The action catalog — the shared spine (enforce exactly)

**27 Server Actions.** Every row must exist as real code at the stated file, with the stated
directive kind and the stated guard shape. The "Intended finding" column is *why the code is written
that way* — build the code so an honest reader reaches that conclusion on their own. Do not leave a
comment anywhere in the repo announcing the verdict, the score, or that an action is vulnerable. The
audit has to earn it from the code.

### A) `src/actions/` — 15 actions, all under a **file-level** `"use server"` at the top of the file

| # | File | Action | Guard shape to write | Intended finding |
|---|------|--------|----------------------|------------------|
| 1 | `billing.ts` | `getBillingProfile` | `getServerSession()` first; returns early if falsy; reads own profile via session id | guarded |
| 2 | `billing.ts` | `updateBillingProfile` | **no session call at all**; goes straight to the repo write | unguarded, no auth |
| 3 | `billing.ts` | `_recalculateInvoiceTotals` | no auth; exported **only so a unit test can import it** — add the test that imports it under `__tests__/` and give it a leading `_` and a comment like `// exported for tests` | unguarded; the file-level directive silently makes this a public POST. **No caller anywhere in app code.** |
| 4 | `auth.ts` | `getSessionUser` | session first, returns early | guarded |
| 5 | `auth.ts` | `updateUserRole` | `getServerSession()` first and returns early if falsy — **but no role/admin check**, then writes `Role` | partially-guarded: privileged op, missing role check |
| 6 | `auth.ts` | `resetPasswordForUser` | writes the new credential **first**, `getServerSession()` check sits **after** the mutation | unguarded: guard runs after the write |
| 7 | `orders.ts` | `listMyOrders` | session first, filters by session user id | guarded |
| 8 | `orders.ts` | `cancelOrder(orderId, ...)` | session **and** `role === 'support'` check, both first and both return early — **but never checks the order belongs to the caller**; uses `orderId` from args directly | partially-guarded: IDOR, missing ownership check |
| 9 | `orders.ts` | `exportOrdersCsv` | `if (!session) { console.warn('no session on export') }` and then **falls straight through** to the query — no return, no throw | unguarded: guard does not stop execution |
| 10 | `admin.ts` | `purgeUserData` | session + role check, both first, both return early | guarded |
| 11 | `admin.ts` | `impersonateUser` | calls `checkAdmin(session)` which **returns a boolean**, but the return value is **never assigned, awaited, or branched on** — next line mints the session token | unguarded: guard result ignored |
| 12 | `config.ts` | `getPublicConfig` | no auth; reads `AppConfig`; called **only** from an admin-only page | unguarded but low sensitivity |
| 13 | `config.ts` | `updateThemeSetting(userId, theme)` | session + role check first — no ownership check on the `userId` arg | partially-guarded: missing ownership check |
| 14 | `content.ts` | `publishBlogPost` | session + role + ownership all checked first | guarded |
| 15 | `content.ts` | `updateBlogPost(postId, body)` | session + role first — no ownership check on `postId` | partially-guarded: missing ownership check |

### B) `src/lib/` — 3 actions, file-level `"use server"` (the "why is this even here" cases)

| # | File | Action | Guard shape | Intended finding |
|---|------|--------|-------------|------------------|
| 16 | `db-helpers.ts` | `runModelQuery(model, where)` | none; does `(prisma as any)[model].findMany(where)` — **model name arrives as an argument** | unguarded; data reach is **unbounded** (dynamic model), medium confidence at best |
| 17 | `db-helpers.ts` | `bulkUpdateModel(model, ids, patch)` | none; `(prisma as any)[model].updateMany(...)` | unguarded; **unbounded** write |
| 18 | `audit.ts` | `writeAuditLog(entry)` | none; writes `AuditLog` | unguarded; **no caller anywhere in the repo** |

> Write `src/lib/db-helpers.ts` and `src/lib/audit.ts` so the `"use server"` at the top reads like
> drift — a plain helper module someone slapped the directive on. Everything else in `src/lib/`
> (repositories, `auth.ts` session helpers, `prisma.ts`) must have **no** directive and must not be
> counted as actions.

### C) `app/` — 6 actions

| # | File | Action | Directive | Guard shape | Intended finding |
|---|------|--------|-----------|-------------|------------------|
| 19 | `app/(marketing)/contact/actions.ts` | `submitContactForm` | file-level | none; writes `ContactSubmission` | unguarded (called from a public page) |
| 20 | `app/(dashboard)/settings/actions.ts` | `updateProfile` | file-level | session first, ownership from session | guarded |
| 21 | `app/(dashboard)/settings/actions.ts` | `updateEmailPreferences` | file-level | **none in the action** — the only check is in `middleware.ts` | unguarded: **false comfort from middleware** |
| 22 | `app/(dashboard)/team/actions.ts` | `inviteTeamMember` | file-level | **none in the action** — the only check is `getServerSession()` + `redirect()` in `app/(dashboard)/layout.tsx` | unguarded: **false comfort from the layout** |
| 23 | `app/admin/users/actions.ts` | `deleteUser` | file-level | session + role first | guarded |
| 24 | `app/(dashboard)/settings/page.tsx` | `deleteSessionToken` | **inline** `"use server"` inside a closure in a Server Component | none | unguarded; inline action in `app/` |

### D) `src/components/` — 3 actions, all **inline** `"use server"` (a file-level scan must miss these)

| # | File | Action | Guard shape | Intended finding |
|---|------|--------|-------------|------------------|
| 25 | `CartWidget.tsx` | `applyPromoCode` | none; inline closure **inside a `"use client"` Client Component**; writes `Cart` / `PromoCode` | unguarded; inline inside a Client Component |
| 26 | `AdminRoleSelect.tsx` | `setRoleInline` | session check first, **no role check**; inline closure **passed down as a prop** to `<RoleDropdown onSelect={...} />` | partially-guarded: missing role check; hides behind a prop |
| 27 | `SupportChat.tsx` | `attachFileToTicket` | none; inline closure in a Client Component; writes `TicketAttachment` | unguarded |

## What to create

### 1) GitHub repo `sahidempiricinfotech-dotcom/next-action-audit` (branch `main`)

A coherent, compact Next.js 14 App Router + TypeScript + Prisma app containing all 27 actions above
at real, findable lines. Also include:

**`prisma/schema.prisma`** — models: `User`, `Session`, `Account`, `Role`, `Permission`,
`BillingProfile`, `Invoice`, `Payment`, `Order`, `OrderItem`, `Cart`, `PromoCode`, `Post`,
`ContactSubmission`, `AuditLog`, `AppConfig`, `EmailPreference`, `TeamInvite`, `SupportTicket`,
`TicketAttachment`.

**Repositories in `src/lib/repositories/`** (no `"use server"` on these). Actions must reach Prisma
**through two hops**, so model tracing is a real step and not a first-boundary guess. For example:
`updateBillingProfile` → `billingRepo.saveProfile()` → `prisma.billingProfile.update()` **and**
`prisma.payment.create()` (so one action touches two models); `resetPasswordForUser` →
`credentialRepo.rotate()` → `prisma.account.update()` + `prisma.session.deleteMany()`.
Concentrate `Payment` / `BillingProfile` / `Account` under several of the unguarded actions so the
"most exposed models" ranking has a real winner rather than a flat tie.

**`middleware.ts`** — must do **both** jobs:
- a session check whose `matcher` is `['/dashboard/:path*']` only — so it does **not** cover the POST
  paths the actions actually arrive on (this is the false comfort behind #21);
- a CORS workaround that **strips/rewrites the `Origin` header** before the request continues (e.g.
  copies `origin` to `x-forwarded-origin` then deletes `origin`). Make it look like a real fix for a
  real problem, not a planted bug.

**`app/(dashboard)/layout.tsx`** — `getServerSession()` + `redirect('/login')`. This is the false
comfort behind #22.

**`next.config.js`** — widen CSRF posture:
```js
experimental: {
  serverActions: {
    allowedOrigins: ['*.preview.vercel.app', 'localhost:3000', 'staging.acme-internal.dev'],
  },
},
```

**Pages / call sites** — these decide the exposure score, so they must match the `callers` tab of the
traffic sheet exactly:
- **Public, no login**: `app/(marketing)/contact/page.tsx` → `submitContactForm`;
  `app/(marketing)/cart/page.tsx` → renders `<CartWidget />` (`applyPromoCode`);
  `app/(marketing)/support/page.tsx` → renders `<SupportChat />` (`attachFileToTicket`);
  `app/(auth)/forgot-password/page.tsx` → `resetPasswordForUser`.
- **Authenticated pages** (under `app/(dashboard)/`): `updateBillingProfile`, `getBillingProfile`,
  `updateProfile`, `updateEmailPreferences`, `inviteTeamMember`, `cancelOrder`, `listMyOrders`,
  `exportOrdersCsv`, `updateBlogPost`, `publishBlogPost`, `updateThemeSetting`, `deleteSessionToken`,
  `getSessionUser`.
- **Admin-only pages** (under `app/admin/`, guarded by a role check in `app/admin/layout.tsx`):
  `deleteUser`, `purgeUserData`, `impersonateUser`, `updateUserRole`, `getPublicConfig`,
  `setRoleInline` (via `<AdminRoleSelect />`).
- **No caller anywhere**: `_recalculateInvoiceTotals` (only the test imports it — a test is not a
  caller), `writeAuditLog`, `runModelQuery`, `bulkUpdateModel`. Make sure nothing in `app/` or
  `src/` calls these four. **Verify this with a repo-wide search before you report done** — an
  accidental call site silently changes the audit's answer.

**`CODEOWNERS`** (repo root) — GitHub precedence is **last match wins**. Write it so that a naive
"most specific pattern wins" reading gets a different answer, and so `src/lib/` has **no** match at
all. Do **not** add a `*` default line.
```
/app/                      @web-team
/app/admin/                @admin-team
/src/components/           @web-team
/src/actions/billing.ts    @payments-team
/src/actions/auth.ts       @auth-team
/src/actions/              @app-team
```
(Last-wins means `/src/actions/` overrides the two specific lines above it — `billing.ts` and
`auth.ts` land on `@app-team`, not `@payments-team`/`@auth-team`. That is intentional; leave it.
`src/lib/` matches nothing and must fall through.)

Also add a root `README.md` describing the layout, and a `package.json` / `tsconfig.json` so the repo
reads as a real app.

### 2) Google Sheet — "Action Traffic Data" (in the Drive folder)

**Tab `invocations`** — columns: `date, action_name, file_path, invocations_per_hour`.
Daily rows joined on **action name + file path** (paths must match the repo byte-for-byte).

- Cover the window **2026-06-15 → 2026-07-14** for every action **except** these four, which get
  **no rows at all** so the traffic-unknown path is exercised: `_recalculateInvoiceTotals`,
  `attachFileToTicket`, `bulkUpdateModel`, `deleteSessionToken`.
- **Also add out-of-window rows** — 2026-06-01 → 2026-06-14 and 2026-07-15 → 2026-07-20 — carrying
  **deliberately different** values, so a run that forgets to filter by the window lands in the wrong
  bucket. Specifically: `updateBillingProfile` runs ~1,400/hr in-window but ~40/hr in the earlier
  rows; `resetPasswordForUser` runs ~250/hr in-window but ~1,800/hr in the July 15–20 rows.
- Keep each action's in-window daily values **tightly clustered** so the bucket can't flip on
  rounding — the audit must be reproducible. Target daily averages:

| ~1,000+/hr (bucket 10) | 100–999/hr (bucket 6) | <100/hr (bucket 2) |
|---|---|---|
| `updateBillingProfile` ~1400, `submitContactForm` ~2000, `applyPromoCode` ~1600, `cancelOrder` ~1200 | `resetPasswordForUser` ~250, `exportOrdersCsv` ~180, `updateEmailPreferences` ~300 | `updateUserRole` ~15, `impersonateUser` ~4, `writeAuditLog` ~60, `inviteTeamMember` ~20, `setRoleInline` ~8, `getPublicConfig` ~30, `updateThemeSetting` ~50, `updateBlogPost` ~12, `runModelQuery` ~90 |

  Guarded actions (`getBillingProfile`, `getSessionUser`, `listMyOrders`, `purgeUserData`,
  `deleteUser`, `publishBlogPost`, `updateProfile`) also get in-window rows — any plausible value.

**Tab `callers`** — columns: `action_name, file_path, called_from_path, caller_auth_level, notes`.
`caller_auth_level` ∈ `public | authenticated | admin | none`. One row per call site. **This tab and
the repo's real call sites must agree exactly** — if they disagree the audit is unreproducible. The
four uncalled actions get either no row or a single row with `caller_auth_level = none` and a note
saying no call site was found.

### 3) Google Sheet — "Server Action Auth Coverage Matrix" (in the Drive folder)

Create it with **exactly** these header columns, in this order:

`action name, file path, line number, folder, directive type, exported, called from, data models
touched, read or write, auth check present, auth check location, runs before mutation, role check,
ownership check, CSRF note, guard verdict, missing controls, severity score, score breakdown,
invocations per hour, confidence, Jira ticket, status, owner, last reviewed`

Add **exactly four rows from a pretended previous run** (older `last reviewed` dates) and nothing
else — this run's rows are the workflow's output:

1. `updateBillingProfile` / `src/actions/billing.ts` — `last reviewed` **2026-05-20**, a stale score
   and verdict, **`owner` = payments-team** and **`status` = In Progress** filled in by a human.
   *(Tests that the upsert refreshes verdict/score/models/Jira/last-reviewed but leaves `owner` and
   `status` alone.)*
2. `cancelOrder` / `src/actions/orders.ts` — `last reviewed` **2026-05-20**, **`owner` = orders-team**,
   **`status` = Accepted Risk**. *(Same test, on a partially-guarded action.)*
3. `getBillingProfile` / `src/actions/billing.ts` — `last reviewed` **2026-05-20**, verdict guarded,
   `owner` and `status` **empty**. *(Tests that a guarded row updates cleanly.)*
4. `deleteLegacyWebhook` / `src/actions/webhooks.ts` — `last reviewed` **2026-04-02**, verdict
   unguarded, `status` = Open. **This action and this file must NOT exist in the repo.** *(Tests that
   a row whose code is gone gets marked Resolved with the run date instead of deleted.)*

### 4) Jira — project `SAA` (Server Action Audit)

Ensure the project exists with **components** `web-team`, `admin-team`, `app-team`, `payments-team`,
`auth-team`, `platform-team` (these are the CODEOWNERS teams plus the fall-through owner).

Create **exactly three** pre-existing tickets and no others:

1. **Open** — `Unguarded Server Action: updateBillingProfile in src/actions/billing.ts`, status To Do,
   with a stale score and description from the "previous run". *(Must be updated, not duplicated.)*
2. **Open** — `Unguarded Server Action: resetPasswordForUser in src/actions/auth.ts`, status In
   Progress, stale details. *(Must be updated, not duplicated.)*
3. **Done/Closed** — `Unguarded Server Action: exportOrdersCsv in src/actions/orders.ts`. *(The
   workflow only searches for **open** tickets, so this one should get a **new** ticket — closed is
   not a reason to skip.)*

Do **not** create any other audit tickets — those are the workflow's output.

### 5) Microsoft Teams

Confirm team **Workflow test** and channel **server action audit** exist; create the channel if it
isn't there. Do not post — the summary is the workflow's output.

## Consistency rules (verify all before reporting done)

1. **27 actions exist**: 23 file-level (15 in `src/actions/`, 3 in `src/lib/`, 5 in `app/`) and 4
   inline (1 in `app/(dashboard)/settings/page.tsx`, 3 in `src/components/`). Nothing else in the four
   folders carries a `"use server"` directive.
2. Every guard shape in the catalog is written **exactly as specified** — after-the-mutation ordering
   for `resetPasswordForUser`, log-and-fall-through for `exportOrdersCsv`, ignored return value for
   `impersonateUser`. These three must look like ordinary code, not like planted bugs.
3. `middleware.ts` matcher covers `/dashboard/:path*` **only**, and it strips/rewrites `Origin`.
   `app/(dashboard)/layout.tsx` has the session check. Neither `updateEmailPreferences` nor
   `inviteTeamMember` has any in-action check.
4. `next.config.js` has the three widened `allowedOrigins` entries.
5. `_recalculateInvoiceTotals`, `writeAuditLog`, `runModelQuery`, `bulkUpdateModel` have **zero call
   sites** anywhere in `app/` or `src/` (the `__tests__/` import of `_recalculateInvoiceTotals` is the
   only reference, and it is not a caller). Confirm by repo-wide search.
6. Every action reaches Prisma through a repository (**two hops**), not directly, except the two
   dynamic-model helpers in `src/lib/db-helpers.ts`, which take the model name as an **argument**.
7. `invocations` covers the window for every action **except** the four traffic-unknown ones, and
   carries out-of-window rows with different values for `updateBillingProfile` and
   `resetPasswordForUser`.
8. `callers` matches the repo's real call sites exactly; action names and file paths in **both** tabs
   match the repo byte-for-byte.
9. `CODEOWNERS` has no `*` default, has the last-wins overlap on `/src/actions/`, and leaves
   `src/lib/` unmatched.
10. The matrix Sheet has the 25 headers, exactly four prior rows, human `owner`/`status` set on rows 1
    and 2, and `deleteLegacyWebhook` pointing at a file that does not exist.
11. Jira SAA has exactly three tickets (two open, one closed) and the six components.
12. **Nowhere in the repo, the sheets, or the tickets is there a comment, column, or note that states
    a verdict or a severity score for this run.** The seed describes the world; the audit draws the
    conclusions.

## When done — report back (so the workflow prompt can be filled to match)

List: the **repo full name + default branch** and confirmation all four folders exist with the 27
actions at real lines; the **URL of both Google Sheets**; the **Jira project key + the six component
names + the three seeded ticket keys**; and confirmation the **Teams team/channel** exist. If any of
the Jira components, the Teams channel, or the repo could not be created, **say so explicitly and
name which** — do not report done with a gap. Finish with a short note confirming the twelve
consistency rules hold, calling out specifically that the four uncalled actions have zero call sites
and that no verdict/score appears anywhere in the seed. Do not create any local files.
