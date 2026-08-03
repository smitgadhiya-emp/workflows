# WF-079 — Seed / re-seed prompt (run AFTER cleanup, BEFORE the eval)

Run this after [`cleanup-prompt.md`](cleanup-prompt.md) and before the eval prompt (Part B in the
[main file](WF-079-api-contract-breaking-change.md)). It rebuilds the **fixed, reproducible** test-bed repo with
every planted trap and one open PR, identical each time, so runs across models or over time are directly
comparable. Setup is allowed to be explicit, it is the test-bed, not the thing being scored. Paste into Codex with
the **GitHub** connector on a demo account (Notion + Microsoft Teams just need to exist for the eval).

> Same data as **Part A** of the main file, kept here as the standalone, copy-paste, repeatable seed. If you
> change the data, change it in the main file too so the two do not drift. The one addition versus Part A is the
> opening line telling it to delete any leftover same-named repo first, so re-seeding is safe even if a stray one
> survived cleanup.

```
Set up a test GitHub repo for an API breaking-change review task. Everything here is invented for testing.
If a repo called "orders-platform" already exists on my account from an earlier run, delete it first (or
empty it and reset it to a single clean main branch) so there's exactly one clean copy, then create it
fresh. Seed it, and open one pull request. Do all of the below and give me the repo link, the PR link, and
a short confirmation of the file tree at the end.

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
type. Leave it empty. If it already exists, confirm it and leave its contents alone (it should be empty
after the cleanup step).

6) In Microsoft Teams, make sure there's a channel called "platform". Create it if it's not there. Leave it empty.

When you're done, tell me: the repo link, the open PR link and number, confirmation the file tree matches
the layout above, confirmation the API-CHANGES Notion database exists and is empty, and confirmation the
platform Microsoft Teams channel exists.
```

## The planted traps (for your reference only — do NOT paste into Codex)

| Change in the PR | Consumer(s) affected | Correct verdict | What it tests |
|---|---|---|---|
| Rename `customer_id` → `customerId` | billing-service, partner-webhook, data-warehouse (unclear) | **breaking** | rename is breaking; find the forgotten integration too |
| Add required `currency` | checkout-web | **breaking** | new required request field breaks callers |
| Add optional `notes` | none | **safe** | new optional field is safe |
| Remove `legacy_status` | analytics-batch still reads it | **breaking** | deprecated-but-used is a real breaker |
| Enum **remove `on_hold`** (shared status) | ops-dashboard (sends it) | **breaking** | narrowing an enum breaks the SENDER |
| Enum **add `refunded`** (shared status) | fraud-check (exhaustive response reader) | **breaking** *(v2)* | widening a RESPONSE enum breaks an exhaustive reader; not a safe widening |
| Remove `GET /v1/orders/debug` | none | **breaking, zero blast radius** | breaking by rule, nobody calls it |
| Remove `coupon_code` (OrderV2) | mobile-app on /v1 | **safe for current callers** | v2 change doesn't touch a v1 caller |
| Rename read via **generic passthrough** | data-warehouse (loops all fields) | **undeterminable → flag for review** *(v2)* | ambiguous usage; escalate, don't clear or hard-assert |
| **`/v1` freeze policy** (VERSIONING.md) | all in-place breaking edits | **NO-GO on policy; re-cut as /v2 / additive** *(v2)* | versioning trade-off, not just blast radius |
| **External partner** on the rename | partner-webhook (third-party) | **breaking; needs deprecation window** *(v2)* | conflicting migration; not a same-day cutover |

Anchor: `legacy_status` is "Deprecated since 2025-11". No run-time date math is needed. **The four *(v2)* rows
were added after the reviewer flagged the first run as too easy at 6: they need a judgment call, not a rule,
so a model is expected to slip on some and land the outcome at 3-4.**

## After running this
- Confirm: **repo link + open PR link returned**, file tree matches, **API-CHANGES Notion database exists and
  is empty**, **platform Teams channel exists and is empty**.
- Then paste **Part B** from the [main file](WF-079-api-contract-breaking-change.md) as the eval prompt, and
  capture the session ID + runtime.
