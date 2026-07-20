# WF-239 — Manual Setup (do these yourself, before anything runs)

Things Codex can't bootstrap on its own (OAuth logins, Linear team/admin config, GitHub org, Teams
creation). Do these first, then run the Codex seed prompt, then confirm the workflow prompt matches
what Codex reports, then run the workflow.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **GitHub** (with permission to create repos under `sahidempiricinfotech-dotcom`)
- [ ] **Linear**
- [ ] **Google Drive / Sheets**
- [ ] **Microsoft Teams**

> You do NOT need to connect a web-server log source or a CDN. Production request/origin data can't be
> injected into those, so it's mocked as the **CORS Request Logs** Sheet. The *workflow* run also reads
> traffic from that Sheet — the prompt says so in its closing note.

## 2. Linear — team + issue search
- [ ] Team **CORS** exists.
- [ ] Confirm the connector can **search issues and filter by state** on the CORS team — the whole
      "update, don't duplicate" idempotency step depends on it, and the seed includes one *closed*
      issue (`GET /api/products`) that must NOT suppress a new one.
- [ ] Linear has no "components" like Jira; ownership comes from CODEOWNERS and is recorded on the
      issue (assignee or a label). Decide which before the run and keep it consistent.

## 3. GitHub — one repo
- [ ] Repo **sahidempiricinfotech-dotcom/cors-audit** exists, or Codex can create it.
- [ ] Confirm **`main` is the default branch** (Settings → Branches).
- [ ] Confirm the connector can **search file contents repo-wide** — resolving CORS across Nginx
      `include`s, Express middleware, and Next.js config/middleware/handlers all need it.

## 4. Microsoft Teams — team + channel
- [ ] Confirm team **Workflow test** exists (reuse from WF-092/109/138/200/206) and that the channel
      **cors audit** exists under it — create the channel if it isn't there yet.

> This was the blocker on WF-138 (team not visible to the connected account). Check it **before** the
> run — the Teams post is the last step and the prompt says post once, only after Linear and the sheet
> are done, so a missing channel wastes a whole run.

## 5. Google Drive — folder for the two Sheets
- [ ] Create the folder **Engineering / CORS Audit**. Codex puts both Sheets there (CORS Request Logs,
      CORS Effective Policy Audit).
- [ ] Leave the audit sheet's current-run rows empty — only the four seeded prior rows. That's the
      workflow's output.

---

## Two edges in Prompt-239 worth deciding before you run
The seed deliberately lands on both; decide the call and hold the run to it, or two engineers diverge.

1. **A clean route that scores ≥45.** The self-audit trichotomy says every route ends as *clean / gap
   with issue-or-under-45 / unresolved*, and "only open issues for routes scoring 45 or more." **R14
   `POST /api/login` is clean but scores exactly 45** (auth data 25 + reach 20, zero policy risk). Does
   it get a Linear issue? The trichotomy says no (no gaps); the threshold line, read alone, says yes.
   The intended reading is **no issue — a clean route never tickets regardless of score** — but the
   prompt doesn't say it outright. Decide and note it.
2. **A gap route with zero policy-risk points.** **R06 `POST /api/orders/:id/cancel`** has only a
   *silently-blocked origin*, which the rubric gives **no policy-risk points** — so it scores 45 purely
   on data (25) + reach (20) and **does** cross the threshold. That's correct per the literal rubric,
   but it feels low-severity, so a run that "rounds it down" would wrongly drop the issue. It should
   ticket. This is a deliberate test that the run applies the rubric literally.

A third, softer one: exposure maxes at **90** (45 + 25 + 20), never 100, because a route can't hold two
policy-risk tiers at once. That's fine and expected — don't let anyone "fix" a route to reach 100.

## Verify the seed before the real run
Spot-check these by hand; they're the ones that silently break the audit if Codex drifts.

- [ ] **14 routes** across three layers; R01/R04/R07 genuinely have two layers fighting.
- [ ] **R01's Nginx location block sets its own `add_header`**, dropping the inherited server-block
      CORS and re-adding `*`. This is the headline — open `infra/nginx/conf.d/orders.conf` and confirm.
- [ ] **Request-log paths match the repo byte-for-byte**; distinct-origin counts and total request
      counts per route match the seed table (they drive reach and the tie-break).
- [ ] **Dead origins** `staging-old.acme.com` and `legacy-admin.acme.com` appear in **config only**,
      never in any in-window log row.
- [ ] **`app.acme.com` hits `POST /api/orders/:id/cancel`** in the logs but is not in that route's
      allow list (silently blocked).
- [ ] **`GET /api/admin/export` has zero log rows** (traffic-unknown).
- [ ] **Out-of-window rows** exist with different values (7th origin on `/api/public/config`, lower
      `/api/orders` total).
- [ ] **R02** preflight advertises fewer methods than the handler implements; **R11** has no OPTIONS;
      **R14** is correctly credentialed with correct preflight (the false-positive control).
- [ ] **R13** Nginx include is genuinely unresolvable.
- [ ] **CODEOWNERS**: no `*` default, last-wins overlap on `/services/`, R13 include falls through to
      platform.
- [ ] **Audit sheet**: 17 headers, exactly 4 prior rows, human owner/status on `POST /api/orders` and
      `GET /api/products`, and `DELETE /api/legacy-webhook` pointing at a route that does **not** exist.
- [ ] **Linear CORS**: exactly 3 issues — 2 open (`/api/orders`, `/api/checkout`), 1 closed
      (`/api/products`). No others.
- [ ] **No policy/gap/score anywhere in the seed** — not in a code comment, not in a sheet column, not
      in an issue. Delete any `// wildcard here` / `// FIXME cors` Codex adds.

## What the seed is designed to catch (why these specific values)
Useful when reviewing the run's output — these are the traps, not an expected answer sheet.

| Trap | Where | What a shallow run does wrong |
|---|---|---|
| Nginx location drops inherited add_header | R01 | reads the Express allowlist, calls it locked; misses Nginx re-adds `*` |
| Next handler overrides next.config headers() | R07 | trusts next.config, misses the handler's `*` |
| Handler hand-sets ACAO over middleware | R04 | credits the global cors() allowlist |
| Wildcard + credentials is browser-rejected | R01, R07 | flags "loose" but misses it's outright broken |
| Wildcard on auth (45) vs non-auth (35) | R01/R04/R07/R12 vs R05/R08 | scores both at one tier |
| Dead whitelist entry | R03, R09 | never cross-checks config origins against the logs |
| Silently blocked origin | R06 | only audits config, never the logs → misses real CORS failures |
| Silently-blocked has zero policy risk | R06 (scores 45 on data+reach) | "rounds down" and drops the issue |
| Split-config override | R01, R04, R07 | reports the global policy as effective |
| Preflight: implemented-not-advertised | R02 | misses the DELETE that fails after preflight |
| Preflight missing entirely | R11 | doesn't check OPTIONS at all |
| Wildcard-on-auth, no traffic | R12 | drops it for having no logs instead of scoring reach 5 |
| Genuinely unresolvable layer order | R13 | invents an effective policy to look complete |
| False-positive wildcard-on-auth | R14 (credentials done right) | flags a correctly-credentialed route |
| Clean route at score 45 | R14 | opens an issue for a route with no gaps |
| Assign by worst-gap layer, not route owner | R01 (Nginx caused it) | assigns the Express service instead of infra |
| CODEOWNERS last-wins | `/services/` vs `/services/users-api/` | picks most-specific instead of last |
| CODEOWNERS fall-through | R13 include | leaves unassigned instead of platform + note |
| Out-of-window rows | `/api/public/config`, `/api/orders` | wrong origin count / wrong tie-break |
| Ties in the ranking | 90, 60, 47, 45, 17 | order moves between runs |
| 60-tie uses policy-risk tiebreak | R05(35) vs R03(15) | orders by score alone, gets it backwards |
| Closed issue ≠ open issue | `/api/products` | skipped as "already exists" |
| Human owner/status columns | prior rows 1–2 | overwritten |
| Route deleted since last run | `DELETE /api/legacy-webhook` | row deleted instead of marked Resolved |

## What you do NOT set up (the workflow produces these)
- The per-route Linear issues (beyond the three seeded ones)
- The current-run rows in the CORS Effective Policy Audit sheet
- The Teams summary
