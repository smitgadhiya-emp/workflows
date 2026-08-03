# WF-079 — Form 1 (Feather submission) — ready to paste

The **first form** you fill when the prompt is created: the workflow-definition / submission form. This is the
clean, copy-paste view of **Part C** of the [main file](WF-079-api-contract-breaking-change.md) (the canonical
source), laid out field-by-field in the exact order the Feather form asks, in the submission voice. Field 1 (the
prompt) is the **hardened v2** Part B. Fields 13 and 14 are filled from the **v2 rerun (Model A, 8m 2s)**: the
judgment came out right but the run was noisy (over-flagged the v2 `coupon_code` removal, led with an inflated
7-breaking headline) and fought the setup, landing a **4** — in the reviewer's requested 3-4 band, so
submission-ready.

> House rules this meets: field 1 is instructions (reads human, no AI tells, no em-dashes, first person is fine),
> ≥2 apps, ends in real changes (a live PR review, five coordination issues, an API-CHANGES Notion entry, a
> Development/platform Teams digest), names every resource, pins what affects scoring and leaves the judgment open
> (Moderately specified). See [`../../../forms/form-1-workflow-definition.md`](../../../forms/form-1-workflow-definition.md).

---

## 1. Workflow description / prompt
*(paste this whole block as the prompt — it is Part B verbatim)*

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

## 2. How specified is this workflow prompt?
**Moderately specified.** It pins the repo, the spec file, the PR/branch, where the consumers live, the
API-evolution rules to apply, and where each output goes, but it leaves the per-change classification, the
blast-radius trace, the ranking and the phrasing to the model. (Our balance-principle house style.)

## 3. Local professional environment & resources the agent needs
I run the API platform for a backend team. Every change to one of our service contracts goes through a review
where we work out if it breaks any of the other teams that call it. Here it's all in my GitHub repo
"orders-platform": the published OpenAPI contract on main, the proposed change as an open PR on a branch, and the
calling services under consumers/ plus one integration under integrations/. The review lands as a comment on the
PR, coordination issues get opened in the same repo for the teams that need to act, the review gets logged in our
Notion database "API-CHANGES", and the go/no-go digest goes to the "platform" Microsoft Teams channel. So the
agent's reading the spec diff and the caller code, deciding breaking vs safe, tracing who's actually hit, and
routing that out.

## 4. Operating system
macOS.

## 5. Applications required
GitHub (repo read + PR review + issues), a code/terminal step to diff the spec (`oasdiff` / `openapi-diff` /
`buf`) and search the callers (ripgrep or an AST search), Notion, Microsoft Teams. All via connector, or browser
control where I log in and the agent drives. In the real setup the consumers are separate repos across the org;
here they're folders in one repo so the run is reproducible.

## 6. Additional context (why / when / larger workflow)
We ship a lot of contract changes and the ones that hurt are never the obvious removals, they're the "small"
rename or the new required field that quietly breaks a team nobody thought to check. Doing this by hand means
eyeballing the diff and then trying to remember who calls what, which is exactly the part that gets skipped under
time pressure. It runs on every API-change PR before merge, and it feeds the merge decision plus the heads-up to
the teams that have to change their code first. Getting it right at review time is what stops a staging or prod
outage after the merge.

## 7. Interim checkpoints / required outputs (for partial credit)
- Diffs the proposed spec against the published one and classifies every change breaking vs safe under real
  evolution rules (required-vs-optional add, removal/rename, enum narrow-vs-widen, request-vs-response enum
  direction, v1-vs-v2)
- Catches the deprecated-but-still-read `legacy_status` removal as a real breaker (analytics-batch)
- Finds the forgotten consumer under integrations/partner-webhook, not just the ones under consumers/
- Splits the shared-enum edit correctly: `on_hold` removal breaks the sender (ops-dashboard), `refunded`
  addition breaks the exhaustive response reader (fraud-check), not waved through as a safe widening
- Flags the generic-passthrough consumer (data-warehouse) as undeterminable / for owner review on the rename,
  not silently cleared or asserted as a hard break
- Cites the `/v1` freeze policy: the breaking edits should be re-cut as `/v2` or additive+deprecation, and the
  external partner-webhook needs a deprecation window rather than an immediate cutover
- Does NOT flag the genuinely safe changes (optional `notes`, the v2-only `coupon_code` removal, and mobile-app
  which reads only unchanged fields and doesn't branch on status)
- Treats the removed `GET /v1/orders/debug` as breaking-by-rule but zero-blast-radius, ranked low
- Posts a PR review with a per-change verdict; opens one coordination issue per truly-broken service; logs the
  Notion API-CHANGES entry; posts the platform digest with reconciling counts; merges nothing

## 8. Occupation category (dropdown)
**Software Developer** — nearest allowed dropdown value; consistent with the other engineering builds. The
platform/API-review specialization is in field 9.

## 9. Occupation & workplace
Platform / backend engineer, reviewing API contract changes for breaking impact across the services that call
them.

## 10. Time to complete manually (minutes)
**90** *(confirm your own honest figure — reading the diff, classifying each change, grepping six services plus
the odd integration for real field-level usage, writing the review, opening the issues and the digest
realistically runs an hour and a half)*

## 11. Times per month
**12** *(roughly one contract-change PR every couple of working days)*

## 12. Workflow difficulty (1 easy – 7 hard)
**7** *(breaking-vs-safe classification under real evolution rules plus a field-level consumer blast-radius trace
across multiple services including one that's easy to miss, where both a false alarm and a missed breaker are
costly)*

## 13. Rate the experience and outcome (1 horrible – 7 perfect)
**4.** Right on the judgment that matters, but not a clean run: a couple of over-conservative calls plus real
setup friction keep it mid-scale rather than high. Reasons in field 14.

## 14. Notes on Codex's performance
**Session ID:** _(paste from the Codex session)_ · **Runtime:** 8 min 2 sec

The judgment was mostly right, the run around it was a bit rough, so I landed on a 4.

The hard calls it got: fraud-check flagged on the refunded value, data-warehouse left as "ask the owner"
rather than guessed, a note to re-cut the breaking changes as a new version, and a deprecation window for the
external partner. It posted a NO-GO comment on PR #7, opened one issue each for the six that break (Checkout
#8, Operations #9, Billing #10, Risk #11, Analytics #12, Partner #13), added the Notion row and the Teams
digest, and merged nothing.

What pulled it down: it called the v2 coupon_code removal breaking when nothing's on v2, so that one is
actually safe. It also led everywhere with "7 breaking" when only 6 services really break, which reads worse
than it is. And it lost the first stretch fighting the setup, no usable local checkout, so it had to pull the
repo and PR off the connector before it could start.

## 15. Confidentiality checkbox
Tick after confirming the prompt text holds no real client data or credentials. (It doesn't, every repo, service,
endpoint and field here is invented.)
