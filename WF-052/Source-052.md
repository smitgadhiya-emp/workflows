# WF-052 — Source / Anchor Values

The WF-052 prompt names its resources directly (no `[brackets]`). This file maps each **named
resource in the prompt** to the **actual thing Codex creates**, and records every place the prompt
had to be adapted so it points at real, reachable systems instead of a local path.

| Resource named in the prompt | Actual value to use |
|---|---|
| Backend code path `/Desktop/test-repo/apps/backend` | GitHub repo `keyurempiricinfotech-art/test-repo`, path `apps/backend` |
| Default branch ("latest commit on the default branch") | `main` (record the exact commit SHA at run time for a rerunnable baseline) |
| Backend stack | NestJS 10 (TypeScript, Node 20), Apollo GraphQL + REST + webhooks, versioned `/api/v1` & `/api/v2` |
| "the whole codebase" (grep surfaces) | The whole `test-repo` monorepo: `apps/web`, `apps/mobile`, `services/*`, `packages/sdk`, `packages/shared`, `docs/openapi.yaml` |
| `mock api data` (traffic Google Sheet) | Google Sheet `mock api data` in Drive folder `Engineering / API Lifecycle` |
| Window `2026-05-01 … 2026-06-29`, `05-06/2026` | Same, Asia/Kolkata (the full 60-day window) |
| `api workflow test` (Lifecycle Tracker Sheet) | Google Sheet `api workflow test` in `Engineering / API Lifecycle` (7 baseline rows pre-seeded) |
| `api-reporting` (Jira project) | Jira project `api-reporting` (+ one dedup fixture issue for the wishlist endpoint) |
| `API Technical Debt Report Months-Year` | **Output** — a new Google Sheet the workflow creates in `Engineering / API Lifecycle`; the title's Months-Year is derived from the analysis window (resolves to `05-06/2026` for this seed data), not hardcoded. Do not pre-seed. |
| `Workflow test` team / `Workflow test` channel | Microsoft Teams team `Workflow test`, channel `Workflow test` |
| "below 25 requests" | Low-usage threshold used by the bucketing rules (10–24 real hits) |

## Adaptations from the original tough prompt (why they were made)

1. **Local path → real GitHub repo.** The tough prompt points at `/Desktop/test-repo/apps/backend` on
   the local disk. Codex runs against connected apps and must not touch the local file system, so the
   codebase is created as an actual GitHub repo and the prompt is rewritten to open
   `keyurempiricinfotech-art/test-repo` at branch `main`, analyzing `apps/backend` and grepping the
   rest of the monorepo. (Same reasoning as WF-109: a codebase can't be mocked as a spreadsheet.)
2. **Report location + title clarified.** "Drop it in the Google Sheet" is made concrete: the report
   is a new Google Sheet whose title follows the pattern `API Technical Debt Report Months-Year`,
   with Months-Year derived from the analysis window (resolves to `05-06/2026` here) rather than
   hardcoded, saved in the `Engineering / API Lifecycle` Drive folder and linked from Jira and Teams.
3. **Jira statuses remapped.** The prompt's tracker statuses (Active, Candidate for Deprecation,
   Pending Review, Approved for Removal, Removed) live in the **Sheet's Status column**, not in Jira.
   In Jira `api-reporting`, deprecation issues are created in the project's default open state
   (whatever it actually exposes — e.g. To Do / Open); record the real state name if it differs.
4. **Repo/branch names match what Codex actually created** — if Codex has to change the org, repo, or
   branch (permissions), update this table and the prompt everywhere.

## Runtime values left as-is (filled by the workflow, not pre-set)
- The per-endpoint buckets, removal-risk verdicts, and debt scores — computed from the seed data.
- The report title's Months-Year, its counts, and the Teams "Immediate Engineering Review" section —
  all derived at run time (the deprecated-but-live `/api/v1/recommendations` is the item that should
  surface loudly).
