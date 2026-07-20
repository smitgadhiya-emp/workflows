# WF-052 — Manual Setup (do these yourself, before anything runs)

These are the things Codex can't bootstrap on its own (OAuth logins, Jira project/admin config,
team/channel creation, GitHub org permissions). Do them first, then run the Codex seed prompt, then
run the workflow prompt.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to all four connectors it will use:
- [ ] **Jira**
- [ ] **GitHub** (with permission to create a repo under the target account/org)
- [ ] **Google Drive / Sheets**
- [ ] **Microsoft Teams**
- [ ] (Optional) confirm the **Chrome** session the workflow may reuse is logged in.

## 2. GitHub — make sure the repo can be created
- [ ] Confirm you can create the repo **`keyurempiricinfotech-art/test-repo`** — OR decide to use a
      different account/org and tell me so I update the repo name in the prompt and Source file
      everywhere.
- [ ] Codex creates the actual monorepo + `main` branch + all the code (backend, web, mobile,
      services, packages, docs). You don't build it by hand.

## 3. Jira — create the project (admin)
Codex can create *issues*, but usually not a project.
- [ ] Create Jira project **`api-reporting`**.
- [ ] Confirm these **labels** are available (create if missing): `technical-debt`, `api-cleanup`,
      `backend`, `architecture`, `deprecation`.
- [ ] Note the project's default open status name (To Do / Open / Backlog). If it isn't "To Do",
      tell me so the Source mapping records it. The tracker's own statuses (Active, Candidate for
      Deprecation, Pending Review, Approved for Removal, Removed) live in the **Sheet**, not Jira —
      no Jira workflow changes needed for those.

## 4. Google Drive — folder + sheets container
- [ ] Create the Drive folder **`Engineering / API Lifecycle`** (empty). Codex will create the two
      input Sheets (`mock api data`, `api workflow test`) inside it. The report Sheet is an output —
      leave room for it but don't pre-create it.

## 5. Microsoft Teams — team + channel must exist
Codex can post messages but generally can't create a team/channel.
- [ ] Confirm team **`Workflow test`** with channel **`Workflow test`** exists (reuse from prior WFs).

---

## Run order after setup
1. **Manual setup** (this file) — done.
2. **Seed data:** paste [Codex-DummyData-Prompt-052.md](Codex-DummyData-Prompt-052.md) into Codex.
   It creates the GitHub monorepo + code, the `mock api data` traffic Sheet, the `api workflow test`
   tracker (7 baseline rows), the one Jira dedup fixture issue, and confirms the folder/team exist.
3. **Verify seed** (quick check before the real run):
   - [ ] Repo `keyurempiricinfotech-art/test-repo` exists on `main`; `apps/backend` holds the NestJS
         API surface; note the baseline commit SHA.
   - [ ] Endpoints **#5 (`DELETE /api/v1/wishlist/{id}`), #13 (`POST /webhooks/legacy-shipping`),
         #16 (GraphQL `legacyInventory`)** are grep-clean across the whole monorepo and absent from
         `docs/openapi.yaml` — the three intended Safe-to-Remove cases.
   - [ ] Endpoint **#6 (`GET /api/v1/legacy/export`)** has **zero traffic** but IS called by
         `services/notification-worker` — the zero-traffic-but-Keep trap.
   - [ ] `mock api data` real-caller totals reconcile with the ground-truth table (exact on the
         low-count endpoints); synthetic rows (`k6`, `Pingdom`, `/healthz`, …) are present and
         strippable; the ambiguous `acme-status-checker` (#11) and the unattributed-version
         `/orders/{id}/invoice` (#8) fixtures are in place.
   - [ ] `api workflow test` has exactly the 7 baseline rows, two with a blank Owner cell.
   - [ ] Jira `api-reporting` has exactly one issue (the wishlist dedup fixture); Teams channel
         present; Drive folder holds only the two input Sheets.
4. **Run the workflow:** execute [Prompt-052-final.md](Prompt-052-final.md).

## What you do NOT set up (the workflow produces these)
- The `API Technical Debt Report Months-Year` Google Sheet (title derived from the window; resolves
  to `05-06/2026` for this seed data).
- The Jira deprecation issues (other than the single pre-seeded dedup fixture).
- The filled-in / newly-added tracker rows in `api workflow test`.
- The Teams "Immediate Engineering Review" + summary post.
