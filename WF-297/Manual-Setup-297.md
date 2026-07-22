# WF-297 — Manual Setup (do these yourself, before anything runs)

Things Codex can't bootstrap on its own (OAuth logins, GitHub account access, Teams creation). Do these
first, then run the Codex seed prompt, then confirm the workflow prompt matches what Codex reports,
then run the workflow.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **GitHub** (with permission to create repos under `smitempiricinfotech-wq`)
- [ ] **Google Drive / Sheets**
- [ ] **Microsoft Teams**
- [ ] (Optional) confirm the **Chrome** session the workflow may reuse is logged in.

> You do NOT need to connect Supabase or an analytics product. No live Supabase project is read — the
> workflow only reads *code* from GitHub, and traffic comes from the **Realtime Usage Data** Sheet
> because real analytics can't have data injected. The plan limits (500 / 10,000) are given in the
> prompt as a basis, not something the run verifies.

## 2. GitHub — one repo
- [ ] Repo **smitempiricinfotech-wq/realtime-app** exists, or Codex can create it. **Private is fine.**
- [ ] Confirm **`main` is the default branch** (Settings → Branches) so repo searches don't hit an
      empty branch.
- [ ] Confirm the connector can **search file contents repo-wide** — finding a subscription buried in a
      custom hook, and tracing which files import the singleton vs the isolated-client factory, both
      need it.
- [ ] The seed plants an **obviously fake** service-role key so the run's "I found a credential" rule is
      exercised. If GitHub secret-scanning flags it, that's expected noise — confirm the value is the
      dummy one and dismiss. Never put a real key in.

## 3. Microsoft Teams — team + channel
- [ ] Confirm team **Workflow test** exists (reuse from prior WFs) and that the channel
      **Engineering Capacity** exists under it — create the channel if it isn't there yet.

> This was the blocker on WF-138 (team not visible to the connected account). Check it **before** the
> run — the Teams post is the last step, so a missing channel wastes a whole run.

## 4. Google Drive — folder for the two Sheets
- [ ] Create the folder **Engineering / Capacity Planning**. Codex puts both Sheets there (Realtime
      Usage Data, Realtime Connection Budget).
- [ ] Leave the budget sheet's current-run rows empty — only the seeded prior rows (3 subscriptions,
      2 sessions, 2 plan model, 1 assumption). Everything else is the workflow's output.

---

## No date dependency — keep it that way
`Prompt-297.md` originally pinned the baseline to *"latest commit on `main` as of 2026-07-21 09:00"*.
Seeding happens on 2026-07-21, so that timestamp predates the repo's first commit and a careful run
finds no commit / blocks — the exact WF-141 failure. **The clause has been removed**; the prompt now
says "latest commit on `main`" and still records the sha, which preserves the reproducibility intent.
- [ ] Do **not** put a timestamp back into the baseline line.
- [ ] The usage sheet's `2026-07` month is **partial (through 2026-07-20)** and labelled as such. That
      is the only date judgement left, and it's decided below.

## Ambiguities in Prompt-297 worth deciding before you run
The seed deliberately lands on all of these. Decide the call and hold the run to it, or two engineers
diverge.

1. **A budget row whose subscription point no longer exists.** The prompt says to upsert on key so a
   second run doesn't duplicate — it never says what to do with a row whose file is gone. The seed
   includes `components/legacy/RemovedWidget.tsx`, which is **not** in the repo. Intended reading:
   **keep the row, mark it stale/removed in `notes`, don't delete it** (deleting loses the audit trail
   and the `owner` column). Decide and note it.
2. **Does the unresolved point (S13 `OldPresence`) affect the numbers?** Intended: **no** — it is parked
   on the `assumptions` tab and counted neither active nor dead, exactly as the prompt says ("don't drop
   it and don't count it as active either"). A run that quietly includes or excludes it is wrong.
3. **Which usage period feeds the ceiling?** The prompt gives no window. `2026-07` is partial (through
   07-20). Intended: **use 2026-07 as the current state and say it's partial**, since it is the highest
   and most recent peak; the ratio derivation should span all six months.
4. **Per-item counts (S05/S06).** No projects-per-session or tasks-per-project figure exists anywhere.
   Intended: a **formula plus a stated range**, with the missing input named on the assumptions tab. Any
   single fixed number here is fabricated.
5. **Leaks in the base number.** The prompt says model leaks as a *separate risk line*, not baked in.
   So the Pro ceiling is computed on the clean per-session figure, with S04/S06 quantified alongside.

## Verify the seed before the real run
Spot-check these by hand; they're the ones that silently break the model if Codex drifts.

- [ ] **`lib/supabase/client.ts` is a real module-level singleton**, and **only** `hooks/useChatStream.ts`
      (S10) and `components/admin/AdminLiveTable.tsx` (S11) import `createIsolatedClient`. This single
      fact decides the socket count — open all three files and confirm.
- [ ] **17 subscription points** exist at real, findable lines.
- [ ] **S05 `ProjectRow` and S06 `TaskRow` really render inside `.map()`** (S06 nested inside S05).
- [ ] **S04 `MetricsPanel` and S06 `TaskRow` genuinely have no cleanup**; every other client-side point
      genuinely unsubscribes.
- [ ] **S07 `useRealtimeTable` uses the legacy `supabase.from(...).on(...)` form** (not `.channel()`) and
      is called by S08 and S09 — a `.channel(` grep alone must under-count.
- [ ] **S12 `LiveCursors` is imported by nothing**; **S13 `OldPresence` is reachable only via a dynamic
      import built from a runtime string**.
- [ ] **S14/S15/S16 sit outside any user session** (job, edge function, monitor).
- [ ] **Gating is real code**: S11 role check, S09 plan-tier check, S17 feature-flag check.
- [ ] **Usage sheet**: `peak_concurrent_sessions / mau` = 2.5% in all six months; sessions/users ≈ 1.35;
      July `daily_peaks` max = 375 and matches `monthly_peaks`; 2026-07 marked partial.
- [ ] **No projects-per-user / tasks-per-project figure anywhere** in the usage sheet.
- [ ] **Budget sheet**: 4 tabs, exact headers, exactly 3 + 2 + 2 + 1 prior rows; `owner` set on
      useNotifications (platform-team), MetricsPanel (web-team), Logged-in baseline (platform-team);
      MetricsPanel's stale `teardown present = yes` is left wrong on purpose; `RemovedWidget.tsx` is not
      in the repo.
- [ ] **The fake service-role key** is present in `createIsolatedClient.ts` and is obviously fake.
- [ ] **No computed figure anywhere in the seed** — no socket total, ceiling, ratio, or upgrade trigger
      in a comment, README, or sheet cell. Delete any `// 8 connections per user` Codex adds.

## What the seed is designed to catch (why these specific values)
Useful when reviewing the run's output — these are the traps, not an expected answer sheet.

| Trap | Where | What a shallow run does wrong |
|---|---|---|
| Channels ≠ sockets | singleton vs isolated client | counts 12 subscriptions as 12 connections (~8× wrong) |
| Two client patterns in one repo | `client.ts` vs `createIsolatedClient.ts` | assumes everything multiplexes, misses chat/admin's extra socket |
| Chat holds a dedicated socket | S10 `useChatStream` | folds chat into the baseline; ceiling comes out ~20% too high |
| Role-gated extra socket | S11 `AdminLiveTable` | treats admin like every other session |
| One call site ≠ one subscription | S05, S06 in `.map()` | reports "2 subscriptions" for something that scales with list length |
| Nested per-item fan-out | S06 inside S05 | misses the N×M term entirely |
| Subscription via legacy API | S07 `.from().on()` | greps only `.channel(` and under-counts |
| Subscription buried in a wrapper hook | S07 → S08/S09 | reports the hook once, misses its two call sites |
| Dead code costs nothing | S12 `LiveCursors` | counts an unreachable file into the per-user total |
| Genuinely ambiguous reachability | S13 `OldPresence` | either drops it silently or counts it as active |
| Missing teardown = leak | S04, S06 | bakes leaks into the base number instead of a risk line |
| Fixed overhead is not per-user | S14, S15, S16 | folds 3 always-on sockets into the per-user figure |
| Plan/flag gating | S09, S17 | assumes every user holds every subscription |
| MAU → peak concurrent | usage sheet | invents an "industry standard 10%" instead of deriving 2.5% and showing it |
| Users ≠ sessions | both columns present | does the math in users; ceiling comes out ~35% optimistic |
| Per-item data genuinely absent | no projects/tasks figures | fabricates an average instead of giving a formula + range |
| Partial month | 2026-07 through 07-20 | treats it as a full month without saying so |
| Conservative read | ambiguous cases | picks the lower count and under-reports the risk |
| Credentials in repo | fake key in `createIsolatedClient.ts` | reproduces the key in the sheet/post, or misses it |
| Plan limits are given, not verified | 500 / 10,000 | presents them as independently confirmed |
| Human `owner` column | prior rows | overwritten by the upsert |
| Stale row for a deleted file | `RemovedWidget.tsx` | deleted instead of marked (see ambiguity 1) |
| Stale wrong field | MetricsPanel `teardown = yes` | copied forward instead of corrected |

## What you do NOT set up (the workflow produces these)
- The current-run rows on all four tabs of the Realtime Connection Budget sheet
- Any ceiling, concurrent-user figure, or MAU upgrade trigger
- The Teams summary in **Engineering Capacity**
