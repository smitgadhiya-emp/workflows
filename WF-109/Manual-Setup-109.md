
0000
# WF-109 — Manual Setup (do these yourself, before anything runs)

These are the things Codex can't bootstrap on its own (OAuth logins, Jira admin config, org/team
creation). Do them first, then run the Codex seed prompt, then run the workflow prompt.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to all four connectors it will use:
- [ ] **Jira**
- [ ] **GitHub** (with permission to create repos under the target org)
- [ ] **Google Drive / Docs**
- [ ] **Microsoft Teams**

## 2. Jira — create the project and its workflow config (admin)
Codex can create *issues*, but not a project or custom statuses.
- [ ] Create Jira project, key **API**, name **Acme API Platform**.
- [ ] Add components **Backend** and **API**.
- [ ] Make sure these statuses exist in the project workflow (add them if missing):
      **Selected for Development**, **Ready for Development**, **Analysis In Progress**,
      **Analysis Complete**.
- [ ] Confirm the priority scheme includes **Highest** (Jira default does).

> The statuses matter twice: the workflow *selects* "Selected/Ready for Development" issues, then
> moves the ticket to **Analysis In Progress** and finally **Analysis Complete**. If those statuses
> don't exist, the run can't flip the ticket.

## 3. GitHub — make sure the repo can be created
- [ ] Confirm the org **acme-commerce** exists and you can create repos in it — OR decide to use
      your own account/org and tell me so I update the repo name everywhere.
- [ ] (Codex creates the actual repo + `develop` branch + code — you don't build it by hand.)

## 4. Microsoft Teams — team + channel must exist
Codex can post messages but generally can't create a team/channel.
- [ ] Confirm team **Workflow test** with channel **Workflow test** exists (reuse from WF-092).

## 5. Google Drive — output folder
- [ ] Create the folder **Engineering / Backend Blueprints** (empty). Pre-making it ensures Codex
      and the workflow both point at the same place. Leave it empty — the blueprint is an output.

---

## Run order after setup
1. **Manual setup** (this file) — done.
2. **Seed data:** paste [Codex-DummyData-Prompt-109.md](Codex-DummyData-Prompt-109.md) into Codex.
   It creates the GitHub repo + code, the Jira issues (primary + decoys), and confirms the folder/
   team exist.
3. **Verify seed** (quick check before the real run):
   - [ ] Repo `acme-commerce/storefront-api` exists, branch `develop`, and has NO reviews feature.
   - [ ] Jira project API has the "Product Reviews & Ratings API" issue as the highest-priority
         Selected-for-Development backend issue, fully scoped, plus the decoys.
   - [ ] Drive folder empty; Teams channel present.
4. **Run the workflow:** execute [Prompt-109.md](Prompt-109.md).

## What you do NOT set up (the workflow produces these)
- The "… – Backend Implementation Blueprint" Google Doc
- The Jira analysis comment + status flips
- The Teams "Backend blueprint ready" message