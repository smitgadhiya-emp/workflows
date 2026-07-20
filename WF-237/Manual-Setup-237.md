# WF-237 — Manual Setup (do these yourself, before anything runs)

Things Codex can't bootstrap on its own (OAuth logins, GitHub org, Teams creation, browser control).
Do these first, then run the Codex seed prompt, then confirm the workflow prompt matches what Codex
reports, then run the workflow.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **GitHub** (with permission to create repos under `sahidempiricinfotech-dotcom`)
- [ ] **Google Drive / Sheets**
- [ ] **Microsoft Teams**
- [ ] **Chrome / browser control** — the *workflow* reads the live MongoDB / Express / React / Node
      docs in a real browser. The **seed** does not need it, but the run does, so confirm it works
      before the real run or the corpus step dies on step one.

> Unlike the WF-200 / WF-206 seeds, there is **no mock data source to build here.** The docs are the
> real live websites; the workflow reads them at run time. The seed only creates the repo (version
> source of truth), the questions Sheet, and the Teams channel.

## 2. GitHub — one repo
- [ ] Repo **sahidempiricinfotech-dotcom/mern-docs-assistant** exists, or Codex can create it.
- [ ] Confirm **`main` is the default branch** (Settings → Branches).
- [ ] Confirm the connector can **open a pull request** — the corpus lands as a PR against `main`, not
      a push, so PR creation has to work.
- [ ] Confirm the connector can **read package.json / lockfiles** repo-wide — the whole run is anchored
      on the pinned versions.

## 3. Microsoft Teams — team + channel
- [ ] Confirm team **Workflow test** exists (reuse from WF-092/109/138/200/206) and that the channel
      **docs assistant** exists under it — create the channel if it isn't there yet.

> This was the blocker on WF-138 (team not visible to the connected account). Check it **before** the
> run — the Teams post is the last step and the prompt says post *once, at the end*, so a channel that
> doesn't exist wastes a whole run.

## 4. Google Drive — folder for the questions Sheet
- [ ] Create the folder **Engineering / Docs Assistant**. Codex puts the **Dev Questions Log** Sheet
      there (tabs Questions and Knowledge Gaps).
- [ ] Leave the Questions tab's answer columns empty except on the two seeded prior-run rows, and the
      Gaps tab with only the two seeded prior gap rows. Everything else is the workflow's output.

---

## What is and isn't reproducible here (worth knowing before you judge the output)
The updated Prompt-237 now **demands reproducibility** of three things — the version tags, the
code-vs-docs verdicts, and the gap set ("same version tags, the same verdicts, and the same gaps. If
your output would move between runs, it's wrong"). The seed makes those deterministic on purpose:
every version trap has exactly one correct pinned-version answer, and each of the five code
contradictions is clear-cut (a removed or changed API), not a judgment call — so two runs should land
in the same place on all three.

What the prompt **still** leaves to the runner is the **routing method** and the **low-confidence bar**
("You decide how that routing works," "Decide what counts as a low-confidence answer, write that rule
down"). No seed can force one answer there. So judge the run on: version accuracy, the five code
verdicts, correct consolidation of the mess set, the gap classification, and idempotency/notes — not
on wording or on the exact routing taxonomy.

Two things to decide before the run, and hold the run to whatever you pick:
1. **The low-confidence bar.** The prompt makes the runner define it. Q25 / Q27 are deliberately on
   the edge (docs give opinion/guidance but no definitive answer). Pick where the line sits, or you
   can't tell a correct gap-classification from a wrong one.
2. **Routing keys.** The prompt leaves routing to the runner but wants it "applied consistently."
   Q21 and Q22 are deliberately ambiguous on tech; Q20 is a routing decoy (auth/express question that
   must not pull React). Decide what "consistent" means so a miss is visible.

## Verify the seed before the real run
Spot-check these by hand; they're the ones that silently break the audit if Codex drifts.

- [ ] **Pins are deliberately old**: `engines.node` `>=18 <19` + `.nvmrc` 18.19.0; Express **4.18.2**;
      React **18.2.0**; `mongo:5.0` in docker-compose; driver **mongodb 5.9** / **mongoose 7.6**.
      Lockfiles resolve to those. **Nothing** on Node 22 / Express 5 / React 19 / MongoDB 7.
- [ ] **No `docs-corpus/` folder** in the repo, and **no seeded answers** in the code.
- [ ] **The five code-vs-docs contradictions exist as real code, none flagged by a comment:**
      C1 `server/src/db.js` (removed mongoose flags + `poolSize` not `maxPoolSize`),
      C2 `server/src/routes/orders.js` (async route, no try/catch, relies on auto-catch),
      C3 `server/src/repositories/userRepo.js` (callback-style driver call),
      C4 `server/src/auth.js` (`decode`/`ignoreExpiration`, never checks `exp`),
      C5 `client/src/components/LiveFeed.jsx` (`useEffect` with no cleanup). Grep the repo for
      `// FIXME` / `// deprecated` / `// TODO` and delete any that announce these — the run must find
      them from the code, not a comment.
- [ ] Questions tab covers all four techs **plus auth and data-access**; at least two `category hint`
      cells blank and at least one **mislabeled**.
- [ ] **Mess set present (Q30–Q36):** Q30 duplicate of Q01, Q32 duplicate of Q16, Q31 near-dup of Q04
      (and surfaces C2), Q33/Q34 vague one-liners (Q34 → C4), Q35 tangles Express-session + Node-crypto
      + Mongo (the cross-tech link case), Q36 tangles Mongo + Node streams + Express.
- [ ] **New columns present**: `code contradiction` and `duplicate of` headers exist in the Questions
      tab and are empty except Q30's `duplicate of` = Q01.
- [ ] **Window edges**: Q28 dated exactly **2026-06-15** and Q29 exactly **2026-07-14** are present
      (must be included); QX1 **2026-06-14**, QX2 **2026-05-30**, QX3 **2026-07-15**, QX4 **2026-08-02**
      are present (must be excluded).
- [ ] **Prior-run state**: Q04 and Q16 have stale answers with human notes in `human notes`; Q30 is
      pre-consolidated into Q01 (`duplicate of` = Q01, `status` = consolidated); Gaps tab has exactly
      G-001 (with a human note) and G-002. No other answers, `duplicate of`, or gap rows exist.
- [ ] **The five gap questions (Q23–Q27)** are genuinely thin in the official docs, and the **five
      conflict questions (Q07–Q11)** each have a real documented pin-vs-newest difference.
- [ ] **No answer, code-contradiction verdict, or corpus content anywhere in the seed** except the two
      deliberately-stale prior-run answers (Q04/Q16) and the seeded consolidation (Q30).

## What the seed is designed to catch (why these specific questions)
Useful when reviewing the run's output — these are the traps, not an answer key.

| Trap | Where | What a lazy / newest-docs run does wrong |
|---|---|---|
| Global `fetch` experimental on Node 18 | Q01 | reads Node 22 docs, says "just use it" |
| `--env-file` not in Node 18 | Q02 | says "use `--env-file`" — not available for us |
| Driver 5 dropped callbacks | Q03 | copies a callback example from an old SO answer |
| Express 4 doesn't auto-catch async errors | Q04 | reads Express 5 docs, says errors auto-forward |
| `useActionState` / form actions are React 19 | Q05 | answers with a 19 API we don't have |
| `node:test` experimental on Node 18 | Q06 | calls it production-ready |
| `$lookup` on sharded coll blocked on 5.0 | Q07 | reads 7.x docs, says it's allowed |
| default write concern by version | Q08 | states one era without version context |
| `require(ESM)` is 22+ only | Q09 | says it works, it doesn't on 18 |
| stable `use(promise)` is React 19 | Q10 | gives the 19 answer as if current |
| Express 5 path-matching change | Q11 | describes 5.x routing for our 4.x |
| Docs genuinely silent | Q23–Q27 | pads a confident answer instead of a gap row |
| Version conflict | Q07–Q11 | picks a winner instead of keeping both, pinned first |
| Routing decoy | Q20 | pulls React docs into an auth/CORS answer |
| Ambiguous tech | Q21, Q22 | routes inconsistently across reruns |
| Mislabeled `category hint` | (one row) | trusts the hint instead of reading the question |
| Out-of-window rows | QX1–QX4 | answers them instead of excluding |
| Inclusive boundary | Q28, Q29 | drops the edge dates |
| Prior answer + human note | Q04, Q16 | duplicates the row or clobbers the note |
| Prior gap row + human note | G-001, G-002 | duplicates the gap or clobbers the note |
| Stale prior answer is wrong for the pin | Q04 (seeded as Express-5 answer) | leaves it as-is instead of correcting to 4.x |
| **Code contradicts docs (C1)** | `db.js` / Q14 | answers `maxPoolSize` correctly but never notices our code uses dead `poolSize` |
| **Code contradicts docs (C2)** | `orders.js` / Q04, Q31 | explains Express 4 async errors but misses that our own route has the bug |
| **Code contradicts docs (C3)** | `userRepo.js` / Q03 | says "use promises" but misses our callback call is already broken on driver 5 |
| **Code contradicts docs (C4)** | `auth.js` / Q16, Q34 | describes `jwt.verify` but misses our middleware uses `decode` and accepts expired tokens |
| **Code contradicts docs (C5)** | `LiveFeed.jsx` / Q12 | explains StrictMode double-invoke but misses our effect leaks with no cleanup |
| **Duplicate questions** | Q30→Q01, Q32→Q16 | answers twice instead of consolidating with `duplicate of` |
| **Near-duplicate** | Q31→Q04 | treats as new; misses it's the same issue + the C2 symptom |
| **Vague one-liner** | Q33 ("pool size??"), Q34 | dodges or asks to clarify instead of reading the code |
| **Tangled multi-tech** | Q35 (session/crypto/mongo), Q36 (mongo/stream/express) | answers one strand, drops the others |
| **Cross-tech bidirectional link** | Q35 | Express-session and Node-crypto entries don't link both ways |
| **Prior consolidation** | Q30 (seeded `duplicate of` Q01) | re-answers it as fresh or duplicates instead of leaving consolidated |
| **Version tag without evidence** | any conflict entry | tags a "current"-only docs page by guess instead of `version-unverified` |

## What you do NOT set up (the workflow produces these)
- The `docs-corpus/` markdown and the corpus pull request
- The answers, sources, versions, and confidence in the Questions tab (beyond the 2 seeded prior rows)
- The current-run rows in the Knowledge Gaps tab (beyond the 2 seeded prior rows)
- The Teams summary
