# WF-200 — Manual Setup (do these yourself, before anything runs)

Things Codex can't bootstrap on its own (OAuth logins, Jira project/admin config, GitHub org, Teams
creation). Do these first, then run the Codex seed prompt, then confirm the workflow prompt's
placeholders match what Codex actually reports, then run the workflow.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **GitHub** (with permission to create repos under `sahidempiricinfotech-dotcom`)
- [ ] **Jira**
- [ ] **Google Drive / Sheets**
- [ ] **Microsoft Teams**

> You do NOT need to connect Vercel, Datadog, or any APM. Invocation traffic and caller exposure
> can't be injected into those, so they're mocked as the **Action Traffic Data** Sheet. The
> *workflow* run also reads traffic from that Sheet, not from live logs — the prompt already says so.

## 2. Jira — project + components
- [ ] Project **SAA** (Server Action Audit) exists.
- [ ] Components created: `web-team`, `admin-team`, `app-team`, `payments-team`, `auth-team`,
      `platform-team`. These are the CODEOWNERS teams plus the fall-through owner. CODEOWNERS decides
      which team owns a file; the workflow records it on the ticket's **Component** field.
- [ ] Confirm the connector can **run a JQL search** on SAA — the whole "update, don't duplicate"
      idempotency step depends on it. Status set To Do / In Progress / In Review / Done is fine.
- [ ] Confirm the connector can **filter by status**, since the seed includes one *closed* ticket
      (`exportOrdersCsv`) that must NOT suppress a new one.

## 3. GitHub — one repo
- [ ] Repo **sahidempiricinfotech-dotcom/next-action-audit** exists, or Codex can create it.
- [ ] Confirm **`main` is the default branch** (Settings → Branches) so repo searches don't hit an
      empty `develop`.
- [ ] Confirm the connector can **search file contents repo-wide** — finding inline `"use server"`
      closures and proving the four uncalled actions have zero call sites both need it.

## 4. Microsoft Teams — team + channel
- [ ] Confirm team **Workflow test** exists (reuse from WF-092/109/138) and that the channel
      **server action audit** exists under it — create the channel if it isn't there yet.

> This was the blocker on WF-138 (team not visible to the connected account). Check it **before**
> the run, not after — the Teams post is the last step and a half-finished run is the one thing the
> prompt explicitly tells the workflow not to do.

## 5. Google Drive — folder for the mock sheet + tracker
- [ ] Create the folder **Engineering / Server Action Audit**. Codex puts both Sheets there
      (Action Traffic Data, Server Action Auth Coverage Matrix).
- [ ] Leave the matrix's current-run rows empty — only the four seeded prior rows. That's the
      workflow's output.

---

## Verify the seed before the real run
Spot-check these by hand; they're the ones that silently break the audit if Codex drifts.

- [ ] **27 actions**: 23 file-level (15 `src/actions/`, 3 `src/lib/`, 5 `app/`) + 4 inline
      (1 in `app/(dashboard)/settings/page.tsx`, 3 in `src/components/`).
- [ ] The **four uncalled actions** (`_recalculateInvoiceTotals`, `writeAuditLog`, `runModelQuery`,
      `bulkUpdateModel`) have **zero call sites**. Grep the repo yourself. An accidental call site
      moves the exposure score from 15 to 6 and quietly changes the ranking.
- [ ] **`middleware.ts`** matcher is `/dashboard/:path*` only **and** it strips/rewrites `Origin`.
- [ ] **`app/(dashboard)/layout.tsx`** has the session check (the false comfort for `inviteTeamMember`).
- [ ] **`next.config.js`** has the three widened `allowedOrigins` entries.
- [ ] **`CODEOWNERS`** has **no `*` default**, has `/src/actions/` listed *after* the `billing.ts` and
      `auth.ts` lines (last-wins overlap), and leaves `src/lib/` unmatched (fall-through → platform).
- [ ] **Traffic sheet** has out-of-window rows with different values for `updateBillingProfile`
      (~1400 in-window vs ~40 before) and `resetPasswordForUser` (~250 in-window vs ~1800 after), and
      **no rows at all** for the four traffic-unknown actions.
- [ ] **`callers` tab** agrees with the repo's real call sites, exactly.
- [ ] **Matrix sheet** has the 25 headers, exactly 4 prior rows, human `owner`/`status` set on
      `updateBillingProfile` and `cancelOrder`, and `deleteLegacyWebhook` / `src/actions/webhooks.ts`
      pointing at a file that does **not** exist.
- [ ] **Jira SAA** has exactly 3 tickets: 2 open (`updateBillingProfile`, `resetPasswordForUser`),
      1 closed (`exportOrdersCsv`). No others.
- [ ] **No verdict or score appears anywhere in the seed** — not in a code comment, not in a sheet
      column, not in a ticket. If Codex helpfully annotated `// VULNERABLE: no auth`, delete it; the
      audit has to find it, and a run that reads the answer off a comment proves nothing.

## What the seed is designed to catch (why these specific values)
Useful when reviewing the run's output — these are the traps, not the expected answer sheet.

| Trap | Where | What a lazy run does wrong |
|---|---|---|
| File-level directive exports a test helper | `_recalculateInvoiceTotals` | never finds it; it's the highest-scoring action in the repo |
| Inline directive inside a Client Component | `applyPromoCode`, `attachFileToTicket` | file-level grep misses it entirely |
| Inline action passed down as a prop | `setRoleInline` | missed unless closures are traced |
| Middleware matcher doesn't cover the POST | `updateEmailPreferences` | credited as guarded |
| Layout check doesn't run on direct invoke | `inviteTeamMember` | credited as guarded |
| Guard after the mutation | `resetPasswordForUser` | credited because `getServerSession` is "present in the file" |
| Guard logs and falls through | `exportOrdersCsv` | credited on pattern match |
| Guard return value ignored | `impersonateUser` | credited on pattern match |
| Session ≠ authorization | `updateUserRole`, `setRoleInline` | called guarded; it's partial (missing role) |
| Trusting an id from the args | `cancelOrder`, `updateBlogPost`, `updateThemeSetting` | IDOR missed |
| Dynamic model name | `runModelQuery`, `bulkUpdateModel` | picks one model instead of reporting unbounded |
| Out-of-window traffic rows | `updateBillingProfile`, `resetPasswordForUser` | wrong bucket → wrong score → wrong ranking |
| No traffic row | 4 actions | dropped, or a number invented, instead of 2 + traffic-unknown |
| Score exactly at the threshold | `getPublicConfig` (lands on 45) | dropped from Jira by an off-by-one on "45 or more" |
| CODEOWNERS last-wins | `billing.ts`, `auth.ts` | assigned to payments/auth instead of app-team |
| CODEOWNERS fall-through | all of `src/lib/` | left unassigned instead of platform + a note |
| Closed ticket ≠ open ticket | `exportOrdersCsv` | skipped as "already exists" |
| Human-owned columns | `updateBillingProfile`, `cancelOrder` rows | overwrites `owner`/`status` |
| Code deleted since last run | `deleteLegacyWebhook` row | row deleted instead of marked Resolved |
| Ties in the ranking | 77 three-way, 55 two-way | order moves between runs |

## What you do NOT set up (the workflow produces these)
- The per-action Jira tickets (beyond the three seeded ones)
- The current-run rows in the Server Action Auth Coverage Matrix
- The Teams summary
