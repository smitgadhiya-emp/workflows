# WF-048 — Software End-of-Life / Tech-Debt Risk Triage (run pack)

**Pending** on [`../../../BOARD.md`](../../../BOARD.md) (built, not yet run). **No-seed / live** — reads the live
endoflife.date API (public JSON, no key); reproducibility comes from the pinned reference date (2025-06-01) + the
named inventory in Part B, not fixtures. Three destination apps: Google Sheets (`Tech Debt Tracker` / `EOL Sweep`)
-> Notion (`TECHDEBT`) -> Microsoft Teams (`platform`). Full design, validation rules and grading live in the main
file.

## Files here

| File | What it is |
|---|---|
| [`WF-048-software-eol-tech-debt-triage.md`](WF-048-software-eol-tech-debt-triage.md) | The canonical build: live-source design, the Part B eval prompt, validation rules, grading, Feather fields |
| [`cleanup-prompt.md`](cleanup-prompt.md) | **Reusable reset** — clears the prior run from the three destination apps. Run before each run |
| [`seed-prompt.md`](seed-prompt.md) | **Setup** — makes sure the three empty destinations exist (no fixture data; live path) |
| [`form-1-submission.md`](form-1-submission.md) | **Form 1**, clean and paste-ready (the first form, submitted when the prompt is created) |

## Run order (repeat this loop for each run / each model)

1. **Connect apps** in Codex: Google Sheets + Notion + Microsoft Teams, plus outbound HTTPS for the endoflife.date
   lookups (or browser control on a demo account).
2. **Cleanup** — [`cleanup-prompt.md`](cleanup-prompt.md). Then confirm by hand: no "Tech Debt Tracker" sheet (or
   one with an empty "EOL Sweep" tab), **TECHDEBT Notion DB = 0 pages**, Teams platform channel clear. **Empty the
   Notion DB by hand if the connector could not** — the WF-028/WF-045 lesson.
3. **Setup** — [`seed-prompt.md`](seed-prompt.md). Makes sure the empty destinations exist. (There's no fixture
   data to seed; the batch is the pinned inventory + reference date in Part B.)
4. **Run the eval** — paste **Part B** from the main file into Codex 5.5 Extra High, submit. Capture the
   **session ID + runtime**. Run the same prompt in Claude side by side.
5. **Verify + score** — grade by looking the same 15 items up against the same reference date (see "Grading / how
   to check" in the main file), then fill fields 13 + 14 of [`form-1-submission.md`](form-1-submission.md). Target
   outcome **1-3** (bar 1-4); if it's 5+, harden (more LTS/ESM ambiguity / bigger inventory) and rerun from step 2.

## What the grader actually does (short list — full detail in the main file)

1. **Status spot-check** — the clearly past-EOL items (old CentOS, oldest Python/Node/PostgreSQL/Django) are
   past-EOL and tiered high/critical; the current LTS versions are "fine" with no entry. Watch for a fully-EOL OS
   or DB softened, or a supported version flagged. · 2. **Active-vs-security nuance** — the items where the two
   dates differ should be "plan", not lumped with fully-EOL nor waved off as supported. · 3. **Structural** —
   every item classified, entries match the needs-upgrade items, counts reconcile, nothing fabricated.

Clean on all of it = too easy (5+) -> harden. We want the outcome **low (1-3)**.

## When it runs

Move the folder to `../../2-in-progress/`, update the `Status:` line in the main file, and refresh the card on
[`../../../BOARD.md`](../../../BOARD.md) (see BOARD's "Moving a card"). Once scored, per-model
`form2-eval-model*.md` files land here alongside these.
