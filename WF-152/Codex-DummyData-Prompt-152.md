# Codex Prompt — Create WF-152 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (GitHub, Google
Drive/Docs, Microsoft Teams) and a Chrome session, so create every item **in the actual app** — do
NOT write anything to the local file system.

---

You are setting up **mock source data** for a workflow that turns a release's merged PRs into three
audience-specific release notes (a technical changelog, a plain-language user update, and an
executive summary), saves them to Drive, posts them to Teams, and opens a changelog PR. **Your job is
only to create the seed data the workflow reads:** a GitHub repo with a release history (a last stable
tag, a decoy pre-release tag, a set of merged PRs after the tag, and a baseline changelog), plus
confirming the Drive folder and Teams channels exist. Do NOT run the release-notes workflow itself.
Do NOT create any of its outputs (the three Docs, the Teams posts, the new changelog PR). Do NOT
create any local files — everything must be created officially through the connected plugins.

## Anchor values (must match exactly across every item you create)

- **GitHub repo:** `smitempiricinfotech-wq/Multi-Audience-Generator`, primary branch **main**.
- **Last stable release tag (the boundary the workflow must resolve to):** **`v1.4.0`**.
- **Computed next version after seeding (do not create it — it's the workflow's output):** **`v2.0.0`**
  (because the seeded range contains breaking changes → major bump off `v1.4.0`).
- **Google Drive folder:** **`Engineering / Release Notes`**.
- **Microsoft Teams team:** **`Workflow test`**, channels **`Dev Releases`**, **`Product Updates`**,
  **`Leadership Updates`** (with **`Workflow test`** as the fallback channel).

The repo must be a **real** GitHub repository with real commits, real tags, and real **merged** PRs —
the workflow reads the actual PR graph (merge status, labels, titles, bodies, revert links). It does
not need to be a runnable app; a small coherent codebase is enough so PRs touch real files.

---

## The single most important thing: the release ground-truth

Build the repo so the boundary resolves to `v1.4.0` and the PR range below is exactly what a correct
run must find. Every tag, PR, label, and body must agree with these tables — this is what makes the
classification, versioning, and consistency checks gradeable.

### Tags to create

> **Do not skip this — it is the most-missed and most-critical step.** Without a stable `v1.4.0`
> **tag** on `main`, the workflow cannot resolve a release boundary and will refuse to run. Create
> these as real, **published** GitHub Releases (`v1.4.0` and `v1.3.0` **stable / non-draft /
> non-pre-release**; `v1.5.0-rc.1` **pre-release**). If the connector can't publish Releases, create
> the tags directly as git refs (`refs/tags/v1.4.0` …) pointing at the chosen commits — the workflow
> looks for the highest `vX.Y.Z` **tag**, so a tag alone is sufficient. Verify with the tags endpoint
> that all three exist before you report done.

| Tag | Kind | Where | Purpose |
|---|---|---|---|
| `v1.3.0` | stable, released | early commit | an older release, already contained — must be excluded from the range |
| `v1.4.0` | stable, released | mid commit | **the last stable tag** — the boundary; note the commit it points at |
| `v1.5.0-rc.1` | **pre-release** | a commit *after* v1.4.0, inside the range | decoy — must be **skipped** (suffix `-rc`), must NOT become the boundary |

So the correct run picks `v1.4.0`, skips `v1.5.0-rc.1`, and takes **every PR merged into `main` after
v1.4.0's commit**, regardless of the rc tag sitting in the middle.

### PRs merged into `main` AFTER `v1.4.0` (this is the range)

Create these as real branches → PRs → **merged** into `main`, in roughly this order. Give each the
labels shown and a body that supports the "evidence" column.

| # | PR title | Labels | Body must convey | Ground-truth type | Breaking? | User-visible? | Edge case being tested |
|---|---|---|---|---|---|---|---|
| P1 | `feat: add saved carts to storefront API` | `feature` | new saved-carts capability | Feature | No | Yes | plain feature |
| P2 | `fix: correct tax rounding at checkout` | `bug` | fixes wrong tax by a cent | Bug fix | No | Yes | plain fix |
| P3 | `perf: cache category tree for faster listings` | `performance` | faster category loads | Performance | No | Yes | plain perf |
| P4 | `feat!: new auth token response, drops legacy fields` | `breaking-change`, `feature` | removes `legacyToken`/`expiresAt` from the login response shape | **Breaking** | Yes | Yes | `!` marker + breaking label + response-shape change |
| P5 | `feat: bulk export endpoint` | `feature` | **body says: "removes the old `GET /v1/export` endpoint and changes the export response shape; run the export migration"** | **Breaking** (content overrides label) | Yes | Yes | **mislabeled breaking** — label says feature, content is breaking; trust content |
| P6 | `refactor: restructure logging module` | `internal` | internal logging only, no user effect | Internal | No | No | plain internal |
| P7 | `chore(ci): bump Node to 20 in CI` | `internal` | CI/tooling only | Internal | No | No | ci/chore internal |
| P8 | `test: add cart service coverage` | *(none)* | tests only | Internal | No | No | test-only internal, no labels |
| P9 | `docs: expand API README` | `documentation` | docs only | Internal | No | No | docs internal |
| P10 | `fix: handle null shipping address` | `bug` | fixes a crash on missing address | Bug fix | No | Yes | plain fix |
| P11 | `feat: add referral rewards` | `bug` | new referral-rewards feature | **Bug fix** (label wins) | No | Yes | **non-breaking label/content conflict** — prefix says feat, label says bug → go with label, log conflict |
| P12 | `feat: add live chat widget` | `feature` | new chat widget | *(reverted)* | No | Yes | **revert pair (original)** |
| P13 | `Revert "feat: add live chat widget"` | *(none)* | reverts P12 | *(revert)* | No | — | **revert pair (revert)** — drop both from notes, list as "reverted, not shipped" |
| P14 | `misc updates` | *(none)* | empty/vague body, touches mixed files | **Unclassified** | Unknown | Unknown | **unclassifiable** — park "needs review", keep out of user + exec versions |

### Decoys that must be EXCLUDED (create them so exclusion is a real decision)

| Decoy | State | Why it must be excluded |
|---|---|---|
| `feat: dark mode` | **open**, not merged | open PRs aren't in the range |
| `fix: minor typo` | **closed, unmerged** | closed-unmerged aren't in the range |
| `fix: patch before release` | merged **before** `v1.4.0` | already contained in the last tag |

### What the correct run should produce (for your own verification — do NOT create these)

- **Next version = `v2.0.0`** (major bump: P4 and P5 are breaking).
- **Shipped & user-visible:** P1, P2, P3, P4, P5, P10, P11.
- **Internal (excluded from user/exec):** P6, P7, P8, P9.
- **Reverted, not shipped:** P12 + P13.
- **Unclassified, needs review:** P14.
- **Breaking (must appear in all three versions + loud block):** P4, P5.

## The baseline `CHANGELOG.md`

At the repo root, seed `CHANGELOG.md` with existing entries for **`v1.4.0`** and **`v1.3.0`** only
(newest on top), each with a date and a few grouped bullets. Do **not** add a `v2.0.0` section — the
workflow prepends that on a new `release-notes/v2.0.0` branch via PR, and must leave the existing
entries untouched.

## The codebase (light, just enough to be real)

A small TypeScript/Node storefront-style service is plenty: a few route/handler files (so P4/P5 can
plausibly touch an auth/login response and an `/v1/export` endpoint), a logging module (P6), a CI
config (P7), a tests folder (P8), and a README (P9). Internal consistency matters only enough that the
breaking PRs' diffs actually touch the files their bodies describe.

---

## What to confirm exists (do NOT post or create content in these)

- **Google Drive folder `Engineering / Release Notes`** — exists and empty (the three Docs are outputs).
- **Microsoft Teams team `Workflow test`** with channels **`Dev Releases`**, **`Product Updates`**,
  **`Leadership Updates`**, plus the **`Workflow test`** fallback channel — all exist. Post nothing.

## Do NOT create (these are the workflow's outputs)
- The three Google Docs (`Release v2.0.0 - Technical Changelog` / `- User Update` / `- Executive Summary`).
- Any Teams posts in any channel.
- The `v2.0.0` CHANGELOG section, the `release-notes/v2.0.0` branch, or its PR.
- Any local files at all.

## When done
Report back with:
1. The repo URL and confirmation branch `main` exists.
2. The three tags with the commit SHAs (clearly marking `v1.4.0` as the stable boundary and
   `v1.5.0-rc.1` as the pre-release decoy).
3. The full list of created PRs with their numbers, labels, and merged/open/closed state — clearly
   separating the 14 in-range merged PRs (incl. the revert pair and the unclassifiable one) from the
   three excluded decoys.
4. Confirmation `CHANGELOG.md` has only `v1.4.0` and `v1.3.0` entries.
5. Links to the Drive folder and confirmation the Teams team + all four channels exist.
6. A one-paragraph note confirming the seed yields next-version `v2.0.0`, that P4/P5 are the breaking
   changes, and that the revert pair and unclassifiable PR are in place.
