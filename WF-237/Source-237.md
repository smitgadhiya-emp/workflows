[repo]	sahidempiricinfotech-dotcom/mern-docs-assistant (branch main)
[corpus folder]	docs-corpus/ (workflow OUTPUT — opened as a PR against main, not seeded)
[questions sheet]	"Dev Questions Log" (Drive folder: Engineering / Docs Assistant), tabs Questions and Knowledge Gaps
[team name] > [channel name]	Workflow test > docs assistant
[exact start date]	2026-06-15
[exact end date]	2026-07-14
[timezone]	Asia/Kolkata (IST)
[stack + pinned versions]	MongoDB server 5.0, Express 4.18.2, React 18.2.0, Node.js 18.19.x; driver mongodb 5.9.x / mongoose 7.6.x
[version source of truth]	repo package.json + lockfiles (Node via engines.node + .nvmrc; MongoDB server via docker-compose.yml image: mongo:5.0)
[doc sources]	LIVE official docs read in Chrome via browser control: MongoDB, Express, React, Node.js docs + changelogs/release notes, GitHub READMEs, Stack Overflow tag pages. NOT mocked — no seed for these.

Mock-source note:
This workflow has NO mocked data source. The documentation is the real live web, read at run time via
browser control. The only seeded surfaces are the GitHub repo (which pins the versions every answer
must be correct for), the "Dev Questions Log" Sheet (the backlog), and the Teams channel. The
docs-corpus/ PR, the answers, the gap rows, and the Teams summary are all workflow output.

Deliberately-not-newest pins (the whole point — newest is the wrong answer):
- Node 18.19  (newest 2026: 22 / 24)  -> global fetch experimental, no --env-file, node:test experimental, no require(ESM)
- Express 4.18 (newest: 5.x)          -> no async-error auto-forward, old path-matching
- React 18.2  (newest: 19.x)          -> no use(promise), no useActionState / form actions
- MongoDB 5.0 (newest: 7 / 8)         -> $lookup sharded restriction, write-concern era; driver 5 dropped callbacks

Code-is-an-input note (NEW in the updated prompt):
The repo code is a graded input, not just a version manifest. Five deliberate code-vs-docs
contradictions are planted, each deterministically wrong for the pin and tied to a question:
- C1 server/src/db.js   -> removed mongoose flags + old `poolSize` (should be `maxPoolSize`)  [Q14]
- C2 server/src/routes/orders.js -> async route relies on Express auto-catch; 4.18 hangs       [Q04, Q31]
- C3 server/src/repositories/userRepo.js -> callback-style driver call; driver 5 dropped it    [Q03]
- C4 server/src/auth.js -> jwt.decode / ignoreExpiration, never checks exp; accepts expired     [Q16, Q34]
- C5 client/src/components/LiveFeed.jsx -> useEffect with no cleanup; StrictMode double leaks   [Q12]
The workflow must FIND these and name the file + the docs entry each violates. They are SEED and must
survive Mode A cleanup (they live on main). The Teams summary reports the count of code-vs-docs
disagreements found.

Seeded state the workflow must reconcile with (not workflow output):
- Questions tab: ~36 in-window questions. Q01-Q29 are the structured set (Q28=2026-06-15, Q29=2026-07-14
  are the inclusive edges); Q30-Q36 are the MESS SET (duplicates Q30/Q32, near-dup Q31, vague one-liners
  Q33/Q34, tangled multi-tech Q35/Q36; Q35 is the Express-session<->Node-crypto cross-tech link). Plus
  4 out-of-window rows QX1-QX4 that must be excluded. Terminal state per question is answered /
  consolidated (with `duplicate of` set) / gap.
- Prior-run answers: Q04 and Q16 carry STALE answers with human notes -> UPDATE, notes PRESERVED. Q04's
  stale answer is written as an Express-5 answer on purpose, so a correct run visibly rewrites it to 4.x.
  Q30 is pre-CONSOLIDATED into Q01 (duplicate of=Q01, status=consolidated) -> a rerun must keep it
  consolidated, not re-answer or duplicate.
- Knowledge Gaps tab: 2 prior rows, G-001 (related Q24, with a human note) and G-002 (related Q26) ->
  must be UPDATED not duplicated, G-001's note PRESERVED.
- New Questions-tab columns beyond the first seed: `code contradiction` and `duplicate of` (both workflow
  output, empty at seed except Q30's `duplicate of`).

Reproducibility note (CHANGED in the updated prompt):
The prompt now DEMANDS reproducibility of the version tags, the code-vs-docs verdicts, and the gap set
("If two people ran this... same version tags, same verdicts, same gaps"). The seed makes those
deterministic: every version trap has one correct pinned answer, and every code contradiction is
clear-cut (a removed/changed API), not borderline. What the prompt STILL leaves to the runner is the
routing method and the low-confidence bar ("You decide how that routing works", "Decide what counts as
a low-confidence answer") — so pin those two down before the run, or a routing/confidence miss won't be
attributable. Judge the run on version accuracy, the five code verdicts, consolidation of the mess set,
gap classification, and idempotency/notes.

Verify-after-Codex note:
Repo/sheet names above are what the seed prompt instructs. If Codex creates anything under a different
account or name, replace the values here and in Prompt-237.md with the exact names Codex reports, plus
the real Sheet URL. Confirm the lockfiles actually resolved to the pinned versions — a lockfile that
drifted to Express 5 / React 19 silently destroys every version trap.
