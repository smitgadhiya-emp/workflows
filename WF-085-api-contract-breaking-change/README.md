# WF-079 — API Contract Breaking-Change & Consumer-Impact Review (run pack)

**In Progress** on [`../../../BOARD.md`](../../../BOARD.md) — **hardened build (v2); rerun landed a 4** (Model A,
8m 2s), in the reviewer's requested 3-4 band, so **submission-ready**. The first run scored a 6 (too easy), so the
seed now carries four extra judgment traps (shared-enum direction, generic-passthrough ambiguity, the `/v1` freeze
policy, the external-partner migration); the model got those calls right but the run was noisy (over-flagged the v2
`coupon_code` removal, inflated 7-breaking headline) and fought the setup, which lands it at a 4. **Seeded** GitHub build:
one repo with a published OpenAPI contract, seven calling services under `consumers/` plus an external partner
integration, a versioning-policy doc, and an open PR that changes the spec with the traps planted. The agent diffs
the change, classifies each edit breaking-vs-safe, traces which services actually break, posts a PR review, opens
coordination issues, logs to Notion (`API-CHANGES`) and posts a Microsoft Teams (`platform`) digest. Full design,
validation rules and grading live in the main file. Source: EXP-68.

## Files here

| File | What it is |
|---|---|
| [`WF-079-api-contract-breaking-change.md`](WF-079-api-contract-breaking-change.md) | The canonical build: seed design, the Part B eval prompt, the planted-traps table, validation rules, grading, Feather fields |
| [`seed-prompt.md`](seed-prompt.md) | **Reusable seed** — builds the test-bed repo + opens the change PR. Run before each run |
| [`cleanup-prompt.md`](cleanup-prompt.md) | **Reusable reset** — deletes the seeded repo + clears the Notion/Teams output. Run before each re-seed |
| [`form-1-submission.md`](form-1-submission.md) | **Form 1**, clean and paste-ready (Part C in submission voice); field 1 is the hardened v2 prompt; fields 13-14 await the v2 rerun |

## Run order (repeat this loop for each run / each model)

1. **Connect apps** in Codex: GitHub (on a demo account) + Notion + Microsoft Teams, plus a code/terminal step
   for the spec diff (`oasdiff`/`openapi-diff`) and the caller search (ripgrep/AST).
2. **Cleanup** — [`cleanup-prompt.md`](cleanup-prompt.md). Then confirm by hand: no "orders-platform" repo (or
   one reset to a clean main, no PR/issues), **API-CHANGES Notion DB = 0 pages**, Teams platform channel clear.
   **Empty the Notion DB by hand if the connector could not** — the WF-028/WF-045 lesson.
3. **Seed** — [`seed-prompt.md`](seed-prompt.md). Rebuilds the repo, the six consumers, and the open PR.
4. **Run the eval** — paste **Part B** from the main file into Codex 5.5 Extra High, submit. Capture the
   **session ID + runtime**. Run the same prompt in Claude side by side.
5. **Verify + score** — grade against the **Grading key** in the main file (per-change verdict + who breaks +
   counts reconcile), including the v2 signals 9-12. Target outcome **3-4** (bar 1-4); if it's 5+, harden
   further per the v3 ideas in the main file and rerun from step 2.

## What the grader actually does (short list — full detail in the main file)

1. **Breaking-vs-safe spot-check** — required `currency` breaking / optional `notes` safe; enum remove `on_hold`
   breaking for the sender (ops); `debug` removal breaking-but-zero-impact; v2 `coupon_code` removal safe. ·
   2. **Blast radius** — `legacy_status` removal breaks analytics (deprecated-but-used); **partner-webhook** found
   outside `consumers/`; mobile-app NOT flagged (reads only unchanged fields). · 3. **v2 judgment calls** — enum
   add `refunded` breaks the exhaustive response reader (**fraud-check**), not a safe widening; **data-warehouse**
   (generic passthrough) flagged undeterminable/for-review on the rename; the verdict cites the **`/v1` freeze
   policy** (re-cut as `/v2`/additive); **partner-webhook**'s fix is a deprecation window (external). ·
   4. **Structural** — PR review with a per-change verdict, one issue per truly-broken service, Notion entry,
   digest, counts reconcile, nothing merged.

Clean on all of it = too easy -> harden further. We want the outcome **3-4** now that v2 is in.

## Next

**v2 hardened (after the reviewer flagged the first run as too easy at 6); rerun done, landed a 4.** The v2 run
(Model A, 8m 2s) got the four new judgment calls right — shared-enum direction (fraud-check), generic-passthrough
ambiguity (data-warehouse), the `/v1` freeze re-cut, the external-partner window — but the run was noisy
(over-flagged the v2 `coupon_code` removal, led with an inflated 7-breaking headline) and fought the setup, which
lands the experience-and-outcome at a **4** (in the reviewer's 3-4 band). Fields 13-14 filled from that run. Next:
(1) reply to the reviewer that it's re-run and now sits at a 4; (2) run Models B/C on fresh names (re-run pack)
for the A/B/C comparison; (3) when the comparison's in, move to `../../3-done/` (update the `Status:` line + the
[`../../../BOARD.md`](../../../BOARD.md) card). If a reviewer bounces it again as still-too-easy, the v3
discovery/indirection ideas (aliased read → false clear, a vendored forgotten consumer → miss) are in Part B.
