# Codex Prompt — Create WF-237 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (GitHub, Google
Drive/Sheets, Microsoft Teams). **Create every item in the actual app. Do NOT write anything to the
local file system.**

---

You are setting up **mock source data** for a workflow that builds a version-tagged MERN
documentation corpus from the **live official docs**, answers a backlog of dev questions against it
for the versions the team actually runs, files knowledge-gap rows, opens a corpus pull request, and
posts a Teams summary. Your job is ONLY to create the seed data the workflow reads.

**Do NOT run the workflow.** Do NOT build the `docs-corpus/`, do NOT open the corpus PR, do NOT write
any answers into the Questions tab, do NOT add rows to the Knowledge Gaps tab (beyond the two seeded
prior-run rows described below), and do NOT post to Teams. The catalog below tells you what
**questions** to seed and what **versions** to pin — it is your build spec, not output to transcribe.

## Where each source lives (important — this one differs from a normal seed)

- **GitHub, Google Drive/Sheets, Teams** → create real items via the connectors.
- **The MongoDB / Express / React / Node.js documentation** → this is **live external websites**. Do
  **NOT** mock it, snapshot it, or seed it into a sheet. The workflow reads it in Chrome via browser
  control at run time. Your seed only has to make the *questions* answerable against those live docs.
- **The repo must be real code** — its `package.json` and lockfile are the **single source of truth**
  for which versions the team runs, so they must pin real, coherent, deliberately-not-newest versions.
  **The code itself is also an input.** The workflow reads the repo's code and, where a question
  touches something the code already does, checks whether the code actually agrees with the docs for
  the pinned versions. So the repo must contain **deliberate, deterministic code-vs-docs
  contradictions** (spec'd below) — code that is wrong, or right only by accident, for the pin. These
  are seed, not output: the workflow's job is to *find* them, not fix them.

## Anchor values (use everywhere; keep identical across every item)

- GitHub repo: **sahidempiricinfotech-dotcom/mern-docs-assistant**, branch **main** (the default
  branch). If it already exists, update files in place — do not create a second repo.
- Corpus folder (workflow output, do NOT create): `docs-corpus/`
- Google Sheet: **Dev Questions Log**, tabs **Questions** and **Knowledge Gaps**
- Google Drive folder: **Engineering / Docs Assistant**
- Microsoft Teams: team **Workflow test**, channel **docs assistant**
- Question window: **2026-06-15 through 2026-07-14** inclusive, Asia/Kolkata

## The pinned stack — the spine of the whole audit (pin these exactly)

Every version below is **deliberately one or more majors behind what is newest in 2026**, because the
entire point of the workflow is that answers must be correct for what the team *runs*, not for what is
newest. Pin them in real files so the "read package.json and lockfile first" step is genuine:

| Tech | Pin to | Newest in 2026 (the wrong answer) | Where the pin lives |
|---|---|---|---|
| Node.js | **18.19.x** | 22 / 24 | `engines.node` in `package.json` (`">=18 <19"`) **and** `.nvmrc` = `18.19.0` |
| Express | **4.18.2** | 5.x | `dependencies.express` in `server/package.json` |
| React | **18.2.0** | 19.x | `dependencies.react` / `react-dom` in `client/package.json` |
| MongoDB server | **5.0** | 7 / 8 | `docker-compose.yml` → `image: mongo:5.0` |
| MongoDB driver | **mongodb 5.9.x** (or **mongoose 7.6.x**) | mongodb 6.x / mongoose 8.x | `dependencies` in `server/package.json` |

Lockfiles (`package-lock.json`) must pin the exact resolved versions so the lockfile genuinely
corroborates the ranges. A run that reads Node 22 / Express 5 / React 19 / MongoDB 7 docs and answers
from them is **wrong** for this repo — that is the trap the pins create.

## What to create

### 1) GitHub repo `sahidempiricinfotech-dotcom/mern-docs-assistant` (branch `main`)

A compact but believable MERN skeleton — enough that reading it tells you the stack and versions, and
that a few questions map to real code. It must contain **no `docs-corpus/` folder** (that's output).

- **Root `package.json`** — workspaces or a simple root; `engines.node` = `">=18 <19"`; a `README.md`
  stating the stack and versions in prose; `.nvmrc` = `18.19.0`.
- **`docker-compose.yml`** — a `mongo:5.0` service (this is the authoritative MongoDB **server**
  version, since package.json only pins the driver), plus the app service on Node 18.
- **`server/`** — Express **4.18.2** app: an entry (`server/src/app.js`) using `express.json()`, a
  couple of routers, a mongoose (**7.6.x**) / mongodb-driver (**5.9.x**) connection in
  `server/src/db.js`, a JWT auth middleware in `server/src/auth.js` (`jsonwebtoken`), and a
  `server/package.json` + `server/package-lock.json` pinning the versions.
- **`client/`** — React **18.2.0** app (Vite or CRA-style): a few components, a
  `client/package.json` + `client/package-lock.json` pinning React 18.2 / react-dom 18.2. Nothing
  using React 19 APIs (`use()`, `useActionState`, form actions).
- Keep it small — this is a version-source-of-truth and a code anchor, not a full product. Do **not**
  add any answers, corpus notes, or a `docs-corpus/` folder.

#### The deliberate code-vs-docs contradictions (this is the point — build all five as real code)

Each is code that is **wrong or right-only-by-accident for the pinned version**, and each is tied to a
question below so the "does our code agree with the docs" deliverable has a concrete, deterministic
target. Make them look like ordinary legacy drift — the kind of thing that "works right up until it
doesn't" — **never** a comment flagging the bug. The verdict must be unambiguous (the code uses an API
or option that the pinned version removed or changed), so two runs reach the same conclusion.

| id | file | the contradiction | pinned-version truth it violates | tied to |
|----|------|-------------------|----------------------------------|---------|
| **C1** | `server/src/db.js` | passes `useNewUrlParser: true` and `useUnifiedTopology: true` (and `useFindAndModify`) to `mongoose.connect()`, and sets a pool size via the **old** `poolSize` option | mongoose **6+** removed those flags (no-ops) and renamed the option to **`maxPoolSize`** — so on mongoose 7.6 the pool size is silently NOT applied | **Q14** |
| **C2** | `server/src/routes/orders.js` | an `async` route handler that `await`s a DB call and can throw, with **no** try/catch and **no** wrapper — relies on the framework catching the rejection | Express **4** does **not** forward rejected promises to the error handler; on our 4.18 this route **hangs / crashes** the request when the await rejects | **Q04** |
| **C3** | `server/src/repositories/userRepo.js` | a data-access call written in **callback style**, e.g. `collection.findOne(query, (err, doc) => {…})` | driver **5.x dropped callback support** — the call returns a Promise and the callback **never fires**, so this code is broken on the pinned driver | **Q03** |
| **C4** | `server/src/auth.js` | verifies the token with `jwt.decode(token)` (or `jwt.verify(token, secret, { ignoreExpiration: true })`) and never checks `exp` | `jsonwebtoken` docs say `decode` does **not** verify signature or expiry — so this middleware accepts **expired and forged** tokens | **Q16**, **Q34** |
| **C5** | `client/src/components/LiveFeed.jsx` | a `useEffect` that opens a subscription / `setInterval` and returns **no cleanup**, so React 18 StrictMode's dev double-invoke (and every remount) leaks | React 18 docs: effects that subscribe **must** return a cleanup; the leak is exactly why "it runs twice" bites here | **Q12** |

> **Do not annotate answers or bugs anywhere in the repo.** No `// deprecated`, `// FIXME`, `// this
> is wrong for v7` comments. The code just quietly disagrees with the docs; the workflow has to catch
> it by reading the code against the pinned-version docs. A comment announcing the bug defeats the test.

### 2) Google Sheet — "Dev Questions Log" (in the Drive folder), tab **Questions**

Columns, in this order (the left block is seed; the right block are the workflow's output columns —
create the headers but **leave them empty except on the seeded prior-run rows**):

`question id, date logged (IST), asked by, question, category hint, human notes, routed to, answer,
sources, versions covered, confidence, code contradiction, duplicate of, answered date, status`

- `code contradiction` — the workflow fills this when the question touches code that disagrees with
  the docs for our pin (file + the docs entry it violates). Seed leaves it empty.
- `duplicate of` — the workflow fills this with the canonical question id when it consolidates a
  duplicate. `status` then records the terminal state: **answered**, **consolidated**, or **gap**.

Seed **~36 in-window questions** plus the boundary and out-of-window rows below. `category hint` is a
loose human tag (`mongodb` / `express` / `react` / `node` / `auth` / `data-access` / blank) — the
workflow does its own routing, so leave a few blank and make one or two **mislabeled** so a run that
trusts the hint instead of reading the question gets caught. **The log is deliberately messy** (see
the mess set below): duplicates, vague one-liners, and tangled multi-tech questions are the point, not
an accident — do not clean them up.

Build the questions so each exercises a specific behavior. Use these (paraphrase into natural
developer phrasing; keep the intent):

**Version-trap questions — pinned answer differs from newest (the headline set):**
| id | question intent | routes to | why it's a trap |
|---|---|---|---|
| Q01 | "Can I just use the global `fetch()` in our backend?" | node | global `fetch` is **experimental** in Node 18 (emits a warning); stable only in 21+. A Node 22 doc says "yes, just use it." |
| Q02 | "How do I load a `.env` file without the dotenv package?" | node | `--env-file` landed in Node **20.6** — **not** in 18, so the answer for us is "you still need dotenv." |
| Q03 | "Should the Mongo driver calls use callbacks or promises?" | data-access / mongodb | driver **5.x dropped callbacks** — promises/async only. Old SO answers use callbacks. **Ties to C3** — our `userRepo.js` still uses a callback, which is broken on the pin. |
| Q04 | "How do async errors thrown in a route handler get caught?" | express | Express **5** auto-forwards rejected promises; **Express 4 does not** — you must try/catch + `next(err)`. **Ties to C2** — our `orders.js` route relies on auto-catch and hangs on our 4.18. |
| Q05 | "How do I use form actions / `useActionState`?" | react | React **19** feature — **not in 18**. Correct answer: not available on our version, here's the 18-era pattern. |
| Q06 | "Is the built-in `node:test` runner production-ready for us?" | node | stable in Node **20**; **experimental in 18**. |

**Genuine version conflicts — keep both, pinned version first:**
| id | question intent | routes to | the conflict |
|---|---|---|---|
| Q07 | "Can I `$lookup` against a sharded collection?" | mongodb | restriction **lifted in 5.1**; on our **5.0** it's **not allowed**. Keep both, 5.0 first. |
| Q08 | "What's the default write concern?" | mongodb | changed to `w:majority` in 5.0 — state it with version context, note older era. |
| Q09 | "Can I use `require()` to load an ESM module?" | node | `require(ESM)` is experimental in **22+**, **not** in 18. Conflict across eras. |
| Q10 | "How do I fetch data with Suspense?" | react | React 18 has no stable `use(promise)`; **19** does. Keep both, 18 first. |
| Q11 | "Do Express 4 route patterns support optional `:param?` and `*` splats the same way?" | express | path-matching changed in **Express 5**; our 4.x keeps the old behavior. |

**Clean answerable (version-specific but not a conflict) — for the confident-answer count:**
| id | question intent | routes to |
|---|---|---|
| Q12 | "Why does `useEffect` run twice in development?" | react (StrictMode double-invoke, React 18) — **ties to C5**: our `LiveFeed.jsx` effect has no cleanup, so the double-invoke leaks. |
| Q13 | "What's the recommended body parser in Express?" | express (`express.json()`, built in ≥4.16) |
| Q14 | "How do I set the mongoose connection pool size?" | data-access (`maxPoolSize`, mongoose 7 — maps to `server/src/db.js`) — **ties to C1**: our `db.js` uses the removed `poolSize` + dead flags. |
| Q15 | "How should I hash passwords?" | auth (bcrypt/argon2 docs) |
| Q16 | "How do I verify a JWT and handle expiry?" | auth (`jsonwebtoken`) — **ties to C4**: our `auth.js` uses `decode`, never checks `exp`. |
| Q17 | "How do I create a time-series collection?" | mongodb (introduced 5.0 — available on our pin) |
| Q18 | "How do I run a multi-document transaction with the driver?" | data-access / mongodb |
| Q19 | "How do I do an efficient bulk upsert?" | data-access / mongodb |
| Q20 | "How do I set up CORS for credentialed requests?" | express / auth (routing test — must NOT pull React docs) |
| Q21 | "How do I paginate large result sets efficiently?" | mongodb / data-access (ambiguous tech → routing must reason) |
| Q22 | "How do I stream a large HTTP response?" | node / express (ambiguous → route to both slices) |

**Genuine knowledge gaps — official docs thin or silent → must land in the Gaps tab, not a padded answer:**
| id | question intent | routes to | why it's a gap |
|---|---|---|---|
| Q23 | "What's the maximum number of elements I can put in a `$in` array?" | mongodb | docs give no hard number (only BSON 16MB implied) — thin. |
| Q24 | "How do I test a component with a Suspense boundary in React Testing Library?" | react | official React docs are thin; mostly community. |
| Q25 | "Should the JWT live in `localStorage` or an httpOnly cookie?" | auth | official docs are largely silent/opinion — low confidence at best. |
| Q26 | "What's the right way to do refresh-token rotation?" | auth | docs thin/opinionated → gap. |
| Q27 | "What connection-pool size should we run in production?" | data-access | docs give guidance, not a number for our workload → low confidence / partial gap. |

**The mess set — real logs are messy, and untangling it is a graded deliverable. Seed these exactly so
the consolidation / vague-reading / untangling behavior has something to bite on:**
| id | date logged | question (seed verbatim-ish) | the mess | expected handling |
|---|---|---|---|---|
| Q30 | 2026-06-18 | "Do we still need node-fetch or is fetch built in now?" | **exact duplicate of Q01** in different words | consolidate → `duplicate of` = Q01, status **consolidated** |
| Q31 | 2026-06-22 | "Why does my route just hang when the Mongo call fails instead of returning a 500?" | **near-duplicate of Q04** *and* a symptom of **C2** | consolidate → Q04 (and the Q04 answer must name the `orders.js` bug) |
| Q32 | 2026-07-02 | "How do I tell if a JWT is expired?" | **near-duplicate of Q16** | consolidate → Q16 |
| Q33 | 2026-06-25 | "pool size??" | **vague one-liner** — only resolvable by reading `db.js` (C1) and Q14 | read against code, answer as Q14 (or consolidate → Q14) |
| Q34 | 2026-06-28 | "why does login sometimes accept a token that should be expired?" | **vague, code-specific** — points straight at **C4** | answer against `auth.js`, flag the `decode` bug |
| Q35 | 2026-07-05 | "How do I set up signed session cookies and store the sessions in Mongo?" | **tangled: Express session + Node crypto (cookie signing) + MongoDB (session store)** | untangle into the three parts; Express-session entry and Node-crypto entry must **link both ways** |
| Q36 | 2026-07-09 | "How do I stream a CSV of orders from Mongo through Express to the browser?" | **tangled: Mongo cursor + Node streams + Express response** | untangle into parts; overlaps Q22 (streaming) — decide consolidate-vs-distinct and note the call |

> The workflow must **not** ask you to clarify these — it makes the call and records the interpretation
> in the row (in `answer` / `duplicate of`). Consolidation means the answer lives on the canonical row
> and the duplicate points to it, not that the duplicate is deleted.

**Boundary rows (test inclusive window edges) — these are IN and must be answered:**
| id | date logged | note |
|---|---|---|
| Q28 | **2026-06-15** | first day of the window — must be included |
| Q29 | **2026-07-14** | last day of the window — must be included |

**Out-of-window rows (must be EXCLUDED by the run):**
| id | date logged | question intent |
|---|---|---|
| QX1 | **2026-06-14** | one day before the window — "How do I upgrade us to React 19?" |
| QX2 | **2026-05-30** | well before — any question |
| QX3 | **2026-07-15** | one day after the window — any question |
| QX4 | **2026-08-02** | after — any question |

**Prior-run rows (idempotency — the run must UPDATE these, not duplicate, and must PRESERVE the human
note):** fill the output columns on these two seeded questions as if answered by a previous run:
- **Q04** — `answered date` **2026-05-22**, a **stale** answer (e.g. one written as if Express 5 auto-
  catches — deliberately wrong for our pin, so the update is visible), `confidence` = High,
  `routed to` = express, and a **human note** in `human notes`: *"Ravi: we are staying on Express 4
  until the Q4 migration — answer must reflect 4.x."* The run must overwrite the answer and keep this
  note verbatim.
- **Q16** — `answered date` **2026-05-22**, a plausible prior answer, and a **human note**:
  *"Priya: link the internal auth runbook here too."* Must be preserved on update.
- **Q30** — seed it already **consolidated** from a previous run: `duplicate of` = **Q01**, `status` =
  **consolidated**, `answered date` **2026-05-22**, `answer` empty (the answer lives on Q01). *(Tests
  that a rerun keeps it consolidated into Q01 rather than re-answering it as a fresh question or
  duplicating.)*

Make the question text and dates identical across reruns so the key (question id) is stable. Do **not**
fill answers, `code contradiction`, or `duplicate of` on any other rows.

### 3) Google Sheet — same file, tab **Knowledge Gaps**

Columns, in this order:

`gap id, related question id(s), topic, what's missing, frequency, impact, priority, status, notes,
last updated`

Seed **exactly two prior-run gap rows** and nothing else (this run's gaps are output):
1. `gap id` G-001, related **Q24**, topic `react/testing`, `last updated` **2026-05-22**, a stale
   priority, `status` Open, and a **human note**: *"Meera: still no official guidance as of last
   check."* *(Tests update-not-duplicate + note preservation.)*
2. `gap id` G-002, related **Q26**, topic `auth/tokens`, `last updated` **2026-05-22**, `status` Open,
   note empty. *(Tests a clean gap-row update.)*

### 4) Microsoft Teams

Confirm team **Workflow test** and channel **docs assistant** exist; create the channel if it isn't
there. Do not post — the summary is the workflow's output.

## Consistency rules (verify all before reporting done)

1. `package.json` + lockfiles pin **Node 18.19 / Express 4.18.2 / React 18.2 / mongodb-driver 5.9 (or
   mongoose 7.6)**, and `docker-compose.yml` pins **mongo:5.0**. The lockfiles' resolved versions
   match the ranges. Nothing in the repo is on Node 22 / Express 5 / React 19 / MongoDB 7.
2. The repo has **no `docs-corpus/` folder** and **no seeded answers** — the corpus and answers are
   the workflow's output.
3. **All five code-vs-docs contradictions (C1–C5) exist as real code** at the stated files, each
   deterministically wrong for the pin (removed option / dropped callback / decode-not-verify /
   missing cleanup / unhandled async), and each with **no comment** flagging it. Q03→C3, Q04→C2,
   Q12→C5, Q14→C1, Q16/Q34→C4 all map to their file.
4. The **mess set (Q30–Q36)** is present and genuinely messy: Q30/Q32 are duplicates of Q01/Q16,
   Q31 is a near-duplicate of Q04 that also surfaces C2, Q33/Q34 are vague one-liners resolvable only
   against the code, Q35/Q36 tangle three technologies each. Q35 is the cross-tech link case
   (Express session ↔ Node crypto). None of them are pre-consolidated except the seeded Q30.
5. Questions tab has all four techs plus **auth** and **data-access** represented, so routing is a real
   step. At least two `category hint` cells are blank and at least one is **mislabeled**.
6. Exactly the four **out-of-window** rows (QX1–QX4) sit outside 2026-06-15…2026-07-14, and the two
   **boundary** rows (Q28 on 06-15, Q29 on 07-14) sit exactly on the inclusive edges.
7. The five gap-shaped questions (Q23–Q27) are genuinely thin in the official docs — not just
   unanswered-by-laziness — so a run that pads them is visibly wrong.
8. The version-conflict questions (Q07–Q11) each have a **real** documented difference between our pin
   and the newest version, so "keep both, pinned first" has something to keep.
9. Prior-run state exists: Q04 and Q16 have stale answers **with human notes**; Q30 is pre-
   **consolidated** into Q01; the Gaps tab has G-001 and G-002 with G-001 carrying a human note. No
   other answers, `duplicate of`, `code contradiction`, or gap rows exist.
10. **No answer, confidence call, code-contradiction verdict, or corpus content appears anywhere in the
    seed** except the deliberately-stale prior-run answers on Q04/Q16 and the seeded consolidation on
    Q30. The seed poses the questions and plants the wrong code; the workflow does the reasoning.

## When done — report back (so the workflow prompt can be filled to match)

List: the **repo full name + default branch** and confirmation the package.json/lockfiles pin the five
versions and that there is **no `docs-corpus/`**; the **URL of the Dev Questions Log Sheet** and
confirmation both tabs exist with the seeded row counts (in-window incl. the mess set, boundary,
out-of-window, prior-run answered, prior-run consolidated, prior gap rows); confirmation **C1–C5 exist
as real code** at their files; and confirmation the **Teams team/channel** exist. If the repo, the
Sheet, the Teams channel, or a needed connector could not be created, **say so explicitly and name
which** — do not report done with a gap. Finish with a short note confirming the ten consistency rules
hold, especially that the pins are deliberately-not-newest, that all five code contradictions are in
place with no flagging comments, and that no answers/corpus were seeded. Do not create any local files.
