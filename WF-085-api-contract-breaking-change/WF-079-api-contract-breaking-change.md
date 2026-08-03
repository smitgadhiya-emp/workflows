# WF-079 — API Contract Breaking-Change & Consumer-Impact Review

**Department/Area:** Engineering / Platform (backend / API platform)
**Tools (5):** GitHub (read the change PR + the org's consumer code, act by posting a PR review + opening coordination issues) + code (run `oasdiff`/`openapi-diff` to diff the spec, ripgrep/AST to trace callers) → Notion (`API-CHANGES` database) → Microsoft Teams (`platform` channel). Any plugin Codex supports is fair game; the only fixed rule is Notion (not Jira) + Microsoft Teams (not Slack).
**Source:** EXP-68 (`../../../ideas/workflow-ideas-4.md`). Build IDs are their own series, not EXP-aligned; this one sits at WF-079, above the registry's WF-001..078 ceiling so it can't be confused with a registry item (map in `../../../context.md` §2a).
**Status:** In Progress — v2 rerun done, **lands a 4 (Model A, 8m 2s)**, in the reviewer's requested 3-4 band, so **submission-ready**. The core judgment was right (fraud-check, data-warehouse held for review, `/v1` re-cut, external-partner window) but the run was noisy — it over-flagged the v2 `coupon_code` removal, led with an inflated 7-breaking headline, and fought the setup — which is what keeps it mid-scale. Next: run Models B/C for the A/B/C comparison, then move to `3-done`. (If a reviewer bounces it again as still-too-easy, the v3 discovery/indirection ideas are noted in Part B.)

> Three parts plus the grading material:
> - **Part A — Data-seeding prompt** (run first, builds the test-bed repo + opens the change PR)
> - **Part B — Workflow prompt** (the eval prompt we submit + run in Codex)
> - **Part C — Feather form data** (every submission field, filled)
> - **Grading key** + **How to check the result** (for you when scoring a run — NOT pasted into Codex)
>
> Run everything in **Codex 5.5 on Extra High**, pasted as-is. The point: the model should *struggle*, so
> the "Rate the experience and outcome" field comes out **low (1–3)**.

**What it is (one paragraph):** A platform engineer reviews a pull request that changes a service's API
contract and has to answer the question the diff alone can't: does this break anyone, and who. The agent
diffs the changed OpenAPI spec against the published one, classifies each change as breaking or safe under
real API-evolution rules (a rename is breaking, a new *required* request field is breaking but a new
*optional* one is safe, removing a field is breaking, narrowing an enum is breaking but widening it is
safe), and then traces which of the org's consumer services actually call the changed operations and read
the changed fields, so it can tell a scary-looking change that breaks nobody from a quiet one that takes
down billing. It posts a compatibility verdict as a PR review, opens a coordination issue for each
consumer that really breaks, logs the review to Notion, and posts a digest to the platform channel. It
does not merge anything. The judgment is the breaking-vs-safe call *and* the blast-radius trace; a bot
that just prints the schema diff gets both halves wrong.

---

## Why this idea (complexity rationale)

**Very High.** API breaking-change review is two hard judgments stacked on each other, and both live in the
seeded repo:

- **Breaking vs safe is a rules call, not a text diff.** Adding a required field breaks callers; adding an
  optional one doesn't. Removing or renaming a field breaks readers of it. Narrowing an enum (dropping an
  accepted value) breaks a caller that sends it; widening it (adding a value) is safe for request params.
  A change to `/v2` doesn't touch a caller still on `/v1`. A model that flags every diff line, or waves
  through a rename because "it's just a name", scores low.
- **Blast radius is real usage, not a guess.** The same rename is a five-alarm fire if billing reads that
  field and a non-event if nobody does. The agent has to search the consumer code and find *who actually
  reads the changed field or sends the changed param*, including a consumer sitting in an easy-to-miss
  folder, and it has to notice a deprecated field that a consumer still depends on.
- **The costly misses go both ways.** Miss a real breaker (analytics still reads the "deprecated" field
  that's being removed) and something falls over in prod after merge. Cry wolf on a safe change (a new
  optional field, an enum widening, a v2-only edit, a removed endpoint nobody calls) and reviewers learn
  to ignore the check.

It reads and writes across GitHub + code + Notion + Teams and ends in real actions (a PR review, coordination
issues), not a document. Distinct from the approved dependency-vuln example (that scans a repo's dependency
manifests); this is cross-code API-contract compatibility plus a consumer blast-radius trace.

---

## Part A — Data-seeding prompt (set up the test bed)

> Run once before testing. Builds a fixed, reproducible GitHub repo with a published API spec, six consumer
> services wired to specific fields, and one open PR that changes the spec with the traps planted. Allowed to
> be explicit, it's the test-bed, not the thing being scored. Everything is invented. Paste into Codex with the
> **GitHub** connector on a demo account (Notion + Microsoft Teams just need to exist for the eval).

```
Set up a test GitHub repo for an API breaking-change review task. Everything here is invented for testing.
Create a repo, seed it, and open one pull request. Do all of the below and give me the repo link, the PR
link, and a short confirmation of the file tree at the end.

1) Create a repository called "orders-platform" (private is fine) on my GitHub account. On the default
branch (main), commit this layout:

  provider/openapi/orders-api.yaml     <- the PUBLISHED, current contract (the base)
  provider/openapi/VERSIONING.md       <- the org's contract-versioning policy (what may change on /v1)
  consumers/billing-service/README.md
  consumers/billing-service/src/orders_client.py
  consumers/checkout-web/README.md
  consumers/checkout-web/src/createOrder.ts
  consumers/analytics-batch/README.md
  consumers/analytics-batch/src/pull_orders.py
  consumers/ops-dashboard/README.md
  consumers/ops-dashboard/src/orders_widget.ts
  consumers/fraud-check/README.md
  consumers/fraud-check/src/score_order.py
  consumers/data-warehouse/README.md
  consumers/data-warehouse/src/sync_orders.py
  consumers/mobile-app/README.md
  consumers/mobile-app/src/OrderScreen.swift
  integrations/partner-webhook/handler.js      <- deliberately NOT under consumers/, easy to miss

2) provider/openapi/orders-api.yaml is the base contract. Make it a valid OpenAPI 3.0 file for an
"Orders API" with these operations and schemas (keep it minimal but valid):

  Define ONE reusable string enum "OrderStatus" with values [open, paid, shipped, on_hold, cancelled],
  and use that same enum in BOTH places: as the type of the Order "status" RESPONSE property, and as the
  "status" query param on GET /v1/orders. So the same value set is what a caller sends AND what the API
  returns.

  GET /v1/orders/{id}      -> 200 returns an Order
  POST /v1/orders          -> 201, request body NewOrder, returns an Order
  GET /v1/orders           -> 200 returns a list of Order; query param "status" is an OrderStatus enum
  GET /v1/orders/debug     -> 200 returns a DebugInfo object (internal diagnostics)
  GET /v2/orders/{id}      -> 200 returns an OrderV2

  Order schema properties: id (string), customer_id (string), status (OrderStatus enum), total (number),
    currency (string), legacy_status (string, described as "Deprecated since 2025-11, use status"),
    created_at (string, date-time). Required: id, customer_id, status, total.
  NewOrder schema properties: customer_id (string, required), items (array of strings, required).
  OrderV2 schema properties: id (string), customerId (string), status (string), total (number),
    coupon_code (string), created_at (string, date-time). Required: id, customerId, status, total.
  DebugInfo schema: id (string), trace (string).

  Also commit provider/openapi/VERSIONING.md with the org's contract-versioning policy, in roughly these
  words (this is the rule a reviewer is meant to apply, so write it plainly):

    # Orders API - versioning policy
    - /v1 is a STABLE, published contract. It is frozen for backward compatibility.
    - Only additive, backward-compatible changes may land in place on /v1: a new OPTIONAL request field,
      a new OPTIONAL response field, or a change no caller can observe as a break.
    - Any BREAKING change (a rename, a removal, a new REQUIRED request field, narrowing an enum a caller
      sends, changing a type) must NOT be made in place on /v1. It ships as a new version path
      (/v2, /v3, ...) or as an additive change plus a deprecation window on the old shape.
    - External / third-party integrations get a deprecation window; they cannot be force-migrated on our
      release schedule.

3) The consumer files each call the API. Write them so the usage is real and greppable:

  consumers/billing-service/src/orders_client.py  -> calls GET /v1/orders/{id} and reads the
    "customer_id" and "total" fields off the response (e.g. order["customer_id"]). Internal team.
  consumers/checkout-web/src/createOrder.ts        -> calls POST /v1/orders sending a JSON body of
    { customer_id, items } and nothing else. Internal team.
  consumers/analytics-batch/src/pull_orders.py     -> calls GET /v1/orders/{id} and reads
    "legacy_status" and "created_at". Internal team.
  consumers/ops-dashboard/src/orders_widget.ts     -> calls GET /v1/orders?status=on_hold (it filters
    the board to on-hold orders, i.e. it SENDS status=on_hold). Internal team.
  consumers/fraud-check/src/score_order.py         -> calls GET /v1/orders/{id} and reads ONLY the
    response "status". It then runs an EXHAUSTIVE match/switch over that value: one explicit branch for
    each of open, paid, shipped, on_hold, cancelled (each mapped to a risk action), and the final
    else/default RAISES an error, e.g. `raise ValueError(f"unhandled status {status}")`. There is NO
    catch-all pass, so any status value outside those five blows up at runtime. It does not read
    customer_id or any other field. Owned by the internal Risk team.
  consumers/data-warehouse/src/sync_orders.py      -> calls GET /v1/orders/{id} and does a GENERIC
    passthrough: it loops over every key/value in the response and writes each into a warehouse table
    keyed by the field name, e.g. `for k, v in order.items(): upsert_column(table="orders", column=k,
    value=v)`. It has NO explicit list of field names and never mentions "customer_id" (or any field)
    literally anywhere in the file. Owned by the internal Data team.
  consumers/mobile-app/src/OrderScreen.swift        -> calls GET /v1/orders/{id} and reads ONLY "id",
    "status" and "total" (it does not touch customer_id, legacy_status or currency); it just DISPLAYS
    status as text with no branching on its value, and it is pinned to the /v1 path.
  integrations/partner-webhook/handler.js           -> calls GET /v1/orders/{id} and reads "customer_id"
    (this one is the forgotten consumer, outside the consumers/ folder). In its README AND a comment at
    the top of the file, state that this is an EXTERNAL third-party partner integration that we do not
    deploy or control, so it cannot be force-migrated on our release schedule.

  In each README.md put one line naming the team that owns it, whether it's internal or an external
  partner, and the endpoints it depends on, so the repo reads like a real multi-team setup.

4) Now create a branch called "evolve-orders-api" and on it edit provider/openapi/orders-api.yaml to
apply exactly these changes (this is the proposed change under review), then open a pull request from
"evolve-orders-api" into main titled "Evolve Orders API - v1 cleanup + v2 tweak" with a short body that
says "cleaning up the orders schema and tightening the create payload". The edits:

  a. In the Order schema (the response schema callers read), RENAME the property "customer_id" to
     "customerId". Leave NewOrder's "customer_id" exactly as it is, the create payload still uses
     customer_id, so this rename is a response-side change only.
  b. In the NewOrder schema, ADD a new property "currency" (string) and mark it REQUIRED.
  c. In the NewOrder schema, ADD a new property "notes" (string), NOT required.
  d. In the Order schema, REMOVE the "legacy_status" property entirely.
  e. Change the OrderStatus enum (the SINGLE enum used by both the "status" query param on GET /v1/orders
     AND the Order "status" response property): REMOVE the value "on_hold" and ADD a new value
     "refunded". Because the enum is shared, this one edit lands on both the request param and the
     response field at once.
  f. REMOVE the GET /v1/orders/debug operation entirely.
  g. In the OrderV2 schema, REMOVE the "coupon_code" property.

  Do not change the consumer files on this branch. The PR is spec-only.

5) In Notion, make sure there's a database named "API-CHANGES" with properties for status, severity and
type. Leave it empty. If it already exists, confirm it and leave its contents alone.

6) In Microsoft Teams, make sure there's a channel called "platform". Create it if it's not there. Leave it empty.

When you're done, tell me: the repo link, the open PR link and number, confirmation the file tree matches
the layout above, confirmation the API-CHANGES Notion database exists and is empty, and confirmation the
platform Microsoft Teams channel exists.
```

**Why the data is shaped this way (the planted traps):**

| Change in the PR | Consumer(s) that read/send it | Correct verdict | What it tests |
|---|---|---|---|
| **Rename `customer_id` → `customerId`** (Order) | billing-service, partner-webhook | **breaking**, breaks both | rename is breaking; must find the caller *and* the forgotten one outside `consumers/` |
| **Add required `currency`** (NewOrder) | checkout-web (sends `{customer_id, items}` only) | **breaking**, breaks checkout | new *required* request field breaks existing callers |
| **Add optional `notes`** (NewOrder) | none | **safe** | new *optional* field is safe, do not flag |
| **Remove `legacy_status`** (Order) | analytics-batch still reads it | **breaking**, breaks analytics | a "deprecated" field still in use is a real breaker, not a freebie |
| **Enum: remove `on_hold`** (shared status, request side) | ops-dashboard sends `status=on_hold` | **breaking**, breaks ops | narrowing an enum breaks a caller that SENDS the dropped value |
| **Enum: add `refunded`** (shared status, request side) | senders: none | **safe for senders** | widening is safe for a caller that SENDS the value — but the same enum is also a response field, see the v2 response-reader row below |
| **Remove `GET /v1/orders/debug`** | none | **breaking but zero blast radius** | removal is breaking by the rules, but nobody calls it, so low priority, note it |
| **Remove `coupon_code`** (OrderV2) | mobile-app is on **/v1** only | **safe for current callers** | a v2-only change doesn't touch a v1 caller; don't raise an impact |
| mobile-app reads only `id/status/total` on /v1 | — | **not impacted** by the rename | reading the response ≠ reading the *changed* field; blast radius is field-level |
| **Enum add `refunded` on the shared status enum** (v2) | fraud-check reads the *response* `status` with an exhaustive switch, no default | **breaking for fraud-check** | enum direction: adding a value is safe for a *sender* but breaks a caller that exhaustively handles what it *receives*; the same edit's `on_hold` removal breaks the sender (ops), not the reader |
| **Rename read via a generic passthrough** (v2) | data-warehouse copies *every* field by name into a table; never names `customer_id` | **undeterminable → flag for owner review** | ambiguous usage: impact can't be read off the code; don't silently clear it, don't hard-assert it breaks |
| **`/v1` freeze policy** (v2, `VERSIONING.md`) | every in-place breaking edit on `/v1` | **NO-GO on policy grounds; re-cut as `/v2` or additive+deprecation** | versioning trade-off: a breaking change on a frozen version is the wrong way to ship it, even where blast radius is small (e.g. `debug`) |
| **External partner on the rename** (v2) | partner-webhook is a third-party integration we don't deploy | **breaking, needs a deprecation window, not an immediate cutover** | conflicting migration: internal callers migrate now, the external one needs the old field kept behind an alias |

Anchor: `legacy_status` is described as "Deprecated since 2025-11" so the "deprecated but still used"
trap is unambiguous. No run-time date math is needed. **The last four rows are the v2 hardening (added after
the reviewer flagged the first run as too easy at 6): each needs a judgment call, not a mechanical rule, so a
model is expected to slip on some and land the outcome at 3-4.**

---

## Part B — Workflow prompt (the eval prompt — submit this)

> First-person and casual like the approved example prompts, no em-dashes. Names every resource and states
> the evolution rules and where each output goes, but never says which changes are the traps or which
> consumers break; leaves the classification, the blast-radius trace and the phrasing open. Draft-vs-live is
> explicit.

```
I look after our API platform and there's a pull request up that changes our Orders API, I need you to
work out whether it breaks any of our services before it goes anywhere near merge. This is the review we
do on every contract change and the bit that bites us is a change that looks harmless but takes down a
caller we forgot about.

Everything's in my GitHub repo "orders-platform". The published contract is
provider/openapi/orders-api.yaml on main. The proposed change is the open PR "Evolve Orders API", on the
branch evolve-orders-api, which edits that same spec. Our services that call this API live under
consumers/ (billing-service, checkout-web, analytics-batch, ops-dashboard, fraud-check, data-warehouse,
mobile-app), and there's one more integration under integrations/partner-webhook that also calls it, so
don't stop at the consumers folder. Each service's code shows which endpoints it hits and which fields it
actually reads or sends, and some read the response differently from others, so read the code rather than
assuming.

First, diff the proposed spec against the published one and go through every change. For each one decide
if it's breaking or safe for existing callers, going by how APIs actually evolve, not just whether the
text changed. The things that trip people up: adding a new required field to a request body breaks callers
that don't send it, but a new optional field is fine. Removing or renaming a field breaks whoever reads
it. Taking a value out of an accepted enum breaks a caller that still sends that value, and adding a new
value is fine for callers that send it, but watch which way the enum flows: a value the API can now
return, on a status a caller reads back and branches on, can break a caller that only handles the old set,
so a widening isn't automatically safe. And a change to a v2 path doesn't affect a service that's still
calling v1. Watch for a field that's marked deprecated but is still being read by someone, pulling it is
still a breaking change for them. And check what we even allow to change in place, there's a versioning
note in the provider docs about what can move on a stable version versus what has to go out as a new
version or an additive step, so factor the policy in, a change can look fine on impact and still be the
wrong way to ship it.

Then, for every change you call breaking, work out who actually breaks. Search the service code for real
usage of the changed operation and the changed field or parameter, not just any mention of orders. A
service that reads a different field off the same endpoint isn't affected, this is about the specific
thing that changed. Some services read the whole response generically rather than by named field, so
whether a rename actually reaches them may not be answerable from the code in front of you, where you
honestly can't tell, say so and route it to the owner to confirm rather than calling it clear or calling
it broken. Some changes will break more than one service, some will break nobody. A breaking change that
no service actually uses is worth noting but it's not an emergency, so rank by real impact.

I want a compatibility verdict on the PR: overall is it safe to merge as-is, and if it isn't, whether the
right fix is the callers changing their code or this PR being re-cut as a versioned or additive change
instead. Then a per-change list saying breaking or safe with the reason, and for the breaking ones which
services are hit and what each of them would need to do, remembering the fix isn't one-size: an internal
service can move on our own schedule but a third-party or external integration usually needs the old shape
kept behind a deprecation window, so say what each specific caller needs, not a blanket "everyone rename
it". Post that as a review on the PR itself (a review comment is fine, don't approve and
don't merge). Then open a GitHub issue in this same repo for each service that actually breaks, one issue
per service, titled so the owning team can find it, describing what changed and what they need to fix, and
tag it so it's clearly a coordination issue off this PR. Don't open issues for services that aren't
affected.

Log the review in my Notion database API-CHANGES, one entry for this PR, with the overall verdict, the
count of breaking vs safe changes, and the list of impacted services. Then post a short digest to my
Microsoft Teams channel platform, for real: lead with the go/no-go call, then the breaking changes and who
they hit, then a line on what you checked and cleared as safe. Keep it skimmable and have the numbers line
up with the PR review and the issues.

The PR review, the issues, the Notion entry and the Teams post are all live. Don't approve or merge the
PR and don't touch the consumer code, this is a review that stops at flagged-and-routed. If you can't read
the repo or the diff tool won't run, say so in the Teams post and stop rather than guessing at the diff.
You're done when the PR has a review with a per-change verdict, there's an issue for each service that
really breaks, the Notion entry's in, and the digest is up with matching numbers.
```

**What makes it hard (keeps the Codex outcome score low, 1–3):**
- **The safe-looking-but-not / breaking-looking-but-not pairs.** Optional `notes` (safe) sits next to
  required `currency` (breaking); a removed endpoint (breaking by rule) with zero callers; a v2 removal
  that doesn't touch the v1 caller. A model that classifies by "did the text change" flags all of them.
- **The deprecated-but-used field.** `legacy_status` reads like a freebie removal; analytics-batch still
  depends on it, so it's a real breaker.
- **The forgotten consumer.** partner-webhook lives outside `consumers/` and also reads `customer_id`; a
  search that only looks in `consumers/` misses it.
- **Field-level blast radius.** mobile-app calls the same `GET /v1/orders/{id}` but reads only
  `id/status/total`, so the `customer_id` rename doesn't touch it. Endpoint-level matching over-reports it.

**The v2 hardening (added after the reviewer flagged the first run as too easy at 6 — these carry the score
down to 3-4):**
- **Enum direction (overlapping compatibility).** `status` is now one shared enum on both the request
  param and the response field. The single edit — remove `on_hold`, add `refunded` — breaks the *sender*
  (ops-dashboard sends `on_hold`) via the removal AND the *exhaustive reader* (fraud-check switches on the
  returned status with no default) via the addition. A model that recites "removing = breaking, adding =
  safe" clears fraud-check and misses a real breaker.
- **Ambiguous usage (needs escalation, not a guess).** data-warehouse reads the response generically
  (`for k, v in order.items()`), never naming `customer_id`, so the rename's impact on it can't be read
  off the code. The right move is flag-for-owner-review; a model tends to either silently clear it or
  hard-assert it breaks.
- **Versioning policy (the trade-off).** `VERSIONING.md` freezes `/v1`: breaking changes must go to `/v2`
  or ship additively with a deprecation window. The whole PR makes in-place breaking edits on `/v1`, so
  the correct call is NO-GO on policy grounds and "re-cut this, don't just tell everyone to fix their
  code" — even the zero-blast-radius `debug` removal violates the freeze. A model that reasons only from
  blast radius never raises it.
- **Conflicting migration (per-caller fix).** partner-webhook is an external third-party integration we
  don't deploy, so the rename's fix for it is a deprecation window / kept alias, not the immediate cutover
  the internal callers can do. A model that writes one blanket "rename to customerId" instruction gets the
  external caller's migration wrong.

**If it's STILL too clean (v3 ideas), harden further by:** a change that's breaking only for a caller on a
specific older minor version, a second forgotten consumer in a vendored/generated path, or a field whose
type is narrowed (e.g. `total` number → string) that breaks a caller doing arithmetic on it but not one
that only displays it. Retest after any change.

---

## Part C — Feather form data (fill the submission form with this)

### Workflow description / prompt
→ Use **Part B** above verbatim.

### Specification level (how specified is this prompt?)
**Moderately specified.** It pins the repo, the spec file, the PR/branch, where the consumers live, the
API-evolution rules to apply, and where each output goes, but it leaves the per-change classification, the
blast-radius trace, the ranking and the phrasing to the model. (Our balance-principle house style.)

### Local professional environment & resources the agent needs
> (first person is fine here)

I run the API platform for a backend team. Every change to one of our service contracts goes through a
review where we work out if it breaks any of the other teams that call it. Here it's all in my GitHub repo
"orders-platform": the published OpenAPI contract on main, the proposed change as an open PR on a branch,
and the calling services under consumers/ plus one integration under integrations/. The review lands as a
comment on the PR, coordination issues get opened in the same repo for the teams that need to act, the
review gets logged in our Notion database "API-CHANGES", and the go/no-go digest goes to the "platform"
Microsoft Teams channel. So the agent's reading the spec diff and the caller code, deciding breaking vs
safe, tracing who's actually hit, and routing that out.

### Operating system
macOS.

### Applications required
GitHub (repo read + PR review + issues), a code/terminal step to diff the spec (`oasdiff` / `openapi-diff`
/ `buf`) and search the callers (ripgrep or an AST search), Notion, Microsoft Teams. All via connector, or
browser control where I log in and the agent drives. In the real setup the consumers are separate repos
across the org; here they're folders in one repo so the run is reproducible.

### Additional context (why / when / larger workflow)
> (first person is fine here)

We ship a lot of contract changes and the ones that hurt are never the obvious removals, they're the
"small" rename or the new required field that quietly breaks a team nobody thought to check. Doing this by
hand means eyeballing the diff and then trying to remember who calls what, which is exactly the part that
gets skipped under time pressure. It runs on every API-change PR before merge, and it feeds the merge
decision plus the heads-up to the teams that have to change their code first. Getting it right at review
time is what stops a staging or prod outage after the merge.

### Interim checkpoints / required outputs (for partial credit)
- Diffs the proposed spec against the published one and classifies every change breaking vs safe under
  real evolution rules (required-vs-optional add, removal/rename, enum narrow-vs-widen, request-vs-response
  enum direction, v1-vs-v2)
- Catches the deprecated-but-still-read `legacy_status` removal as a real breaker (analytics-batch)
- Finds the forgotten consumer under integrations/partner-webhook, not just the ones under consumers/
- Splits the shared-enum edit correctly: `on_hold` removal breaks the sender (ops-dashboard), `refunded`
  addition breaks the exhaustive response reader (fraud-check), not waved through as a safe widening
- Flags the generic-passthrough consumer (data-warehouse) as undeterminable / for owner review on the
  rename, rather than silently clearing it or asserting it breaks
- Cites the `/v1` freeze policy: the breaking edits should be re-cut as `/v2` or additive+deprecation, and
  the external partner-webhook needs a deprecation window rather than an immediate cutover
- Does NOT flag the genuinely safe changes (optional `notes`, the v2-only `coupon_code` removal, and
  mobile-app which reads only unchanged fields and doesn't branch on status)
- Treats the removed `GET /v1/orders/debug` as breaking-by-rule but zero-blast-radius, ranked low (still a
  freeze violation)
- Posts a PR review with a per-change verdict; opens one coordination issue per truly-broken service; logs
  the Notion API-CHANGES entry; posts the platform digest with reconciling counts; merges nothing

### Occupation dropdown
Software Developer

### Occupation & workplace (keep short and specific)
Platform / backend engineer, reviewing API contract changes for breaking impact across the services that
call them.

### Time to complete manually (minutes)
**90** *(set your own honest figure — reading the diff, classifying each change, grepping six services plus
the odd integration for real field-level usage, writing the review, opening the issues and the digest
realistically runs an hour and a half)*

### Times per month
**12** *(set your own honest figure — roughly one contract-change PR every couple of working days)*

### Workflow difficulty (1 easy – 7 hard)
**7** — breaking-vs-safe classification under real evolution rules plus a field-level consumer blast-radius
trace across multiple services (including one that's easy to miss), where both a false alarm and a missed
breaker are costly.

### Rate the experience and outcome (1 horrible – 7 perfect) — v2 rerun done
**4 (v2 rerun).** Right on the judgment that matters, but not a clean run, so it sits mid-scale (in the
reviewer's requested 3-4 band, so submission-ready). The core calls were correct — fraud-check on the
`refunded` add, data-warehouse held for owner confirmation, the `/v1` freeze re-cut recommendation, the
external-partner deprecation window — but it lost points on the way there: it over-flagged the v2
`coupon_code` removal as breaking (nothing live is on v2, so it's safe for current callers), it led every
surface with an inflated "7 breaking" headline when only 6 services actually break, and it fought the setup
(no usable local checkout) before it could diff. Full writeup in
[`form-1-submission.md`](form-1-submission.md) fields 13-14.

### Codex notes (evidence-based) — v2 rerun done
See [`form-1-submission.md`](form-1-submission.md) field 14 for the paste-ready notes (runtime 8m 2s; session
ID to be pasted). Summary of why it's a 4: the outcome was correct but the run was noisy. It over-flagged the
v2 `coupon_code` removal as breaking (safe for current callers, since nothing is on v2 — zero impact and no
issue opened, but a false positive against the rule); it led the PR comment, the Notion row and the Teams
digest with "7 breaking / 1 safe" when only 6 services break and two of the seven breakers (`debug`,
`coupon_code`) are zero-impact; and it lost the opening stretch resolving the repo/PR off the connector
(no local checkout) before it could diff. Where it was fine: it traced all eight changes across the seven
consumers + the partner, flagged fraud-check on the `refunded` add, held data-warehouse for owner
confirmation, cited the `/v1` freeze, and gave the external partner a deprecation window. NO-GO comment on
PR #7, six issues (Checkout #8, Operations #9, Billing #10, Risk #11, Analytics #12, Partner #13), the Notion
API-CHANGES row, the platform Teams digest, nothing merged, counts reconciling. Solid core, rough edges → 4.

### Confidentiality checkbox
Tick after confirming the prompt text holds no real client data or credentials. (It doesn't, every repo,
service, endpoint and field here is invented.)

---

## Grading key (for YOU when scoring a run — NOT part of the prompt)

> Exact review wording, issue layout and digest phrasing are the model's call. Grade the calls below.

**Expected per-change verdict and blast radius:**

| Change | Verdict | Breaks | Notes |
|---|---|---|---|
| Rename `customer_id` → `customerId` | **breaking** | billing-service, **partner-webhook**, **data-warehouse (undeterminable)** | find the integrations/ one; data-warehouse reads generically so its impact is flag-for-review, not clear/broken |
| Add required `currency` (NewOrder) | **breaking** | checkout-web | new required request field |
| Add optional `notes` (NewOrder) | **safe** | none | do not flag |
| Remove `legacy_status` (Order) | **breaking** | analytics-batch | deprecated but still read |
| Enum **remove `on_hold`** (shared status) | **breaking** | ops-dashboard | narrowing breaks the *sender* |
| Enum **add `refunded`** (shared status) | **breaking** | **fraud-check** | widening a *response* enum breaks an exhaustive *reader* (not safe here) |
| Remove `GET /v1/orders/debug` | **breaking, zero blast radius** | none | note, rank low — but still a `/v1` freeze violation |
| Remove `coupon_code` (OrderV2) | **safe for current callers** | none | v2-only; mobile-app is on v1 |

**Overall verdict:** NOT safe to merge as-is, on **two** grounds: (a) it breaks real callers, and (b) it
violates the `/v1` freeze in `VERSIONING.md` — every in-place breaking edit belongs in `/v2` or an
additive+deprecation migration, so the correct call is "re-cut this PR", not just "callers, go fix your
code". A run that only reasons from blast radius and never cites the policy has missed half the verdict.

**Issues that should exist:** one coordination issue per truly-broken service — billing-service,
checkout-web, analytics-batch, ops-dashboard, **fraud-check** (the `refunded` reader), and
**partner-webhook** (with an external deprecation-window migration, not an immediate cutover). That's six
clean ones (accept partner-webhook folded into the rename issue with both services named, so 5-6).
**data-warehouse** is NOT a clean issue — it should surface as a needs-owner-confirmation flag (its own
review note or a "verify" issue), never silently cleared and never asserted as a hard break. No issue for
mobile-app or for any safe change.

**The scorable signals:** (1) required `currency` = breaking, optional `notes` = safe; (2) rename is
breaking and **partner-webhook** is found; (3) `legacy_status` removal = breaking (analytics still reads
it); (4) enum **remove `on_hold`** = breaking for the sender (ops-dashboard); (5) v2 `coupon_code` removal
is safe for the v1 mobile-app; (6) mobile-app is NOT flagged for the rename (reads only unchanged fields);
(7) `debug` removal is breaking-by-rule but ranked zero-impact; (8) overall no-go verdict with counts that
reconcile across PR review, issues, Notion and Teams. **v2 signals (the hard four):** (9) enum **add
`refunded`** = breaking for **fraud-check** (response-side, exhaustive reader), NOT waved through as a safe
widening; (10) **data-warehouse** rename impact = flagged undeterminable / for owner review, not cleared
and not hard-asserted; (11) the overall verdict cites the **`/v1` freeze policy** and recommends re-cutting
as `/v2` or additive+deprecation, not just caller fixes; (12) **partner-webhook**'s migration is a
deprecation window because it's external, not a same-day rename. Nail all twelve = still too easy. **Real
expectation:** it clears fraud-check on the "adding is safe" reflex, and/or never cites the freeze policy,
and/or treats data-warehouse as clear — missing 2-3 of the v2 four and landing outcome **3-4**.

---

## How to check the result (manual verification in the apps)

After Part B finishes, open each surface and look. ~10 minutes.

### 0. The 60-second sanity check
1. Overall verdict = **no-go / not safe to merge**?
2. Is required `currency` **breaking** and optional `notes` **safe**?
3. Is the `legacy_status` removal called **breaking** (analytics-batch), not waved through as "deprecated"?
4. Was **partner-webhook** found (outside `consumers/`)?
5. Is **mobile-app** left alone (not flagged for the rename or the v2 change)?
6. **(v2)** Is the `refunded` enum add called **breaking for fraud-check** (exhaustive response reader), not
   waved through as a safe widening?
7. **(v2)** Is **data-warehouse** flagged **undeterminable / for owner review** on the rename, not silently
   cleared and not asserted as a hard break?
8. **(v2)** Does the verdict **cite the `/v1` freeze policy** and say re-cut as `/v2`/additive, not just
   "callers fix your code"?
9. **(v2)** Is **partner-webhook**'s fix a **deprecation window** (external), not an immediate cutover?

If checks 1-5 pass but several of 6-9 are wrong, that's the intended v2 result (outcome 3-4). If 1-5 are
also wrong, the model struggled hard.

### 1. GitHub — the PR review
Read the review on the "Evolve Orders API" PR. Check the per-change table: the four breakers vs the four
safe calls, the reasons, and the impacted-service list. Confirm it did NOT approve or merge.

### 2. GitHub — the issues
One coordination issue per truly-broken service (billing-service, checkout-web, analytics-batch,
ops-dashboard, and partner-webhook accounted for). No issue for mobile-app or any safe change.

### 3. Notion — "API-CHANGES"
One entry for this PR: overall verdict, breaking-vs-safe counts, impacted services. Numbers match the PR
review.

### 4. Microsoft Teams — "platform"
One live digest: go/no-go first, then the breaking changes and who they hit, then what was cleared safe.
Counts reconcile with the PR review, the issues and the Notion entry.

### 5. Score it and compare
Tally against the **Grading key**, set the outcome score (want 1–3; if clean it's too easy → harden), and
run the same prompt in **Claude** for the side-by-side. Paste any exact error text verbatim.

---

## Notes for the build (optional, not pasted into Codex)
- **Re-run pack** for a fresh workspace: clone Part A with a new repo name, renamed services and fields, and
  the *same* trap structure — one rename, one required-add, one deprecated-removal, one shared-enum edit
  (narrow the sender + widen an exhaustive response reader), one forgotten consumer, one v2-only change, one
  generic-passthrough consumer, one `/v1` freeze policy doc, one external partner; the grading key (including
  v2 signals 9-12) still applies with an ID map.
- **Tool swaps if a connector is flaky:** Notion → an `API-CHANGES` tab in a Google Sheet; Microsoft Teams
  → post the digest to a Google Doc. Keep GitHub for the PR review + issues (that's the real action).
- **Diff tool note:** `oasdiff` classifies most of these directly (required-add, removal, enum change); the
  rename and the consumer trace still need the code search, so the code step isn't optional.

## Distinct from
- **Approved dependency-vuln example:** that inspects a repo's dependency manifests for vulnerable packages
  and PRs fixes. WF-079 reviews an **API contract change** for breaking impact and traces the **consumer
  blast radius** across calling code. Different object and judgment.
- **WF-047 / WF-048 (the IT no-seed builds):** those triage a live vuln/EOL catalog against an estate. This
  is a seeded code-review workflow on a change PR.
- **Registry WF-052 "dead API endpoints" / WF-057 "update to latest API":** those find *unused* endpoints or
  upgrade a *caller*. This is cross-code **contract compatibility + blast radius** on a proposed change.
