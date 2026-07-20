# Prompt-Generation Brief (Review-Ready Workflow Prompts)

Use this to turn one of my real workflows into a workflow prompt that passes the micro1 / Codex eval review on the first try. It folds together the two playbook rule sets and every reviewer lesson we've collected, so the generated prompt doesn't come back with a revision.

---

## How to use this

1. Paste this whole brief into the AI.
2. Under it, paste my raw workflow and fill the four blanks (see below).
3. Ask for the finished workflow prompt.

The AI's job: read my workflow, apply every rule in this brief, and hand back ONE prompt written as instructions, plus a short note on which difficulty levers it added and the expected Codex outcome score.

### The four blanks I fill in

- **MY WORKFLOW** (what I actually do, start to finish, like explaining it to a new teammate):
- **TOOLS I CAN GIVE THE AGENT** (only apps I can personally log into and authorize, e.g. Gmail, a named Google Sheet, GitHub, Notion, Microsoft Lists, Chrome via browser control):
- **WHERE THE INFO LIVES** (exact names: folder / file / sheet / tab / label / channel / repo / account / property):
- **WHERE THE AGENT ACTS** (the exact destination it writes to or changes: sheet + tab, draft, calendar, ticket, channel, column):

---

## 1. The non-negotiable bar (from the playbooks)

Every generated prompt must hit all of these or it gets rejected outright.

- **At least two tools.** Read from one app, then take a real action in a different app. One app only = rejected.
- **Ends in a real change, not a document.** A record updated, a message sent, a ticket created, a file written back and linked. A summary or report alone scores low. A document can be part of it, never the whole thing.
- **Written as instructions, no "I".** Use "Review the records", "Create the folder", "Update the list". Never "I review" or "I create". (The context and environment notes can stay first person; only the prompt itself must read as instructions.)
- **Name every resource.** Exact list, sheet, tab, folder, repo, channel, account, property, and field, so someone with access to my workspace could start without asking me. No "the tracker" or "a spreadsheet".
- **Open structure is fine if the minimum is concrete.** If the prompt creates something new (sheet, ticket, board, project), name the few fields each item must contain, then let the model add the rest. Don't design the full template. A vague minimum like "related details" fails; a handful of named fields passes.
- **Say what to produce, never the step-by-step.** Give the goal, the required output, and the rules. Do not write "first do X, then Y, then Z". Let the model pick its own method.
- **One focused task.** A real, repeating task from my week, not a one-off, an experiment, or my whole month.
- **No confidential data.** Reference real files and apps by name, but keep client details, personal data, passwords, and credentials out of the text. If the workflow can't be described without exposing something, use a scrubbed or fictional stand-in.

---

## 2. Reviewer-derived rules (this is where prompts actually get sent back)

The bar above is usually fine. These are the specifics reviewers keep flagging. Apply every one that touches my workflow.

### 2a. Make every judgment objective and repeatable

Anything the model has to infer, pick, filter, or calculate must have a stated, objective rule, so two evaluators scoring the same run land in the same place. If a reasonable person could interpret it two ways and change the output, define it.

- **Derived/inferred outputs need explicit inference rules.** If the model predicts or reconstructs something (e.g. backend APIs and database tables from a UI design), state exactly what to derive it from: only explicit user actions, persisted entities, and clearly observable functionality in the design. No free guessing.
- **Any "pick references / examples / sources" step needs a fixed count and objective selection criteria.** Replace "recent" and "good quality". Say exactly how many (e.g. exactly 3 references), the time window as relative logic (e.g. published within the last 2 years as of the run date), and the ranking rule (e.g. selected by highest engagement, or closest relevance to the stated brief).
- **Name the pricing source and spell out every calculation.** For spend or cost work, name where prices come from and give the exact formula. No implied math.
- **State field and update rules for the destination.** For a Notion / sheet / list update, name the exact fields and say what value goes in each and when to overwrite vs. append (update-in-place or create-new).
- **Give deduplication a priority order.** When merging or deduping, say which record wins and in what order the tie-breakers apply. Don't leave "merge duplicates" open.
- **Define the judgment criteria whenever the model filters, qualifies, or ranks.** Say what "good", "qualifying", "ready", or "in scope" means, and which items to exclude.

Leave open only what a capable junior would decide on their own (how it organizes the work, extra fields beyond the required minimum, internal reasoning, how it phrases a summary). Pin down anything that changes the output or the score.

### 2b. Name the tool for every step, including research

- **Say where research happens.** If a step involves looking things up on the web, name the tool: run it in Chrome via browser control (I log in, the agent drives). Don't leave "research this" toolless.
- **Name the exact account, property, or file when more than one could exist.** Not "the sheet" or "GA4" but the specific sheet + tab, property, project, folder, or workspace.
- **Give reference sources for context.** If the output should reflect my values, service area, or selling points, name or link the source to pull from.

### 2c. Use relative dates, not fixed calendar dates

- Replace hard-coded calendar dates (e.g. 2026-03-31) with relative, run-date-anchored logic: "older than 90 days as of the run date", "not modified in the last 60 days", "the 30 days ending yesterday", "the 30 days before that".
- This keeps the prompt reusable over time. Anchoring to the run date also keeps it unambiguous, which is what the validator wants when it says "convert relative to exact" — so express relative logic precisely rather than dropping in a fixed date.

### 2d. Checkpoints must match this workflow

- Every interim checkpoint / required output must be directly about the submitted workflow. No leftover placeholder examples from a different task (e.g. an "edit a PowerPoint slide deck from an Excel model" checkpoint sitting inside an API-lifecycle workflow). If a checkpoint doesn't map to a real stage of this prompt, cut it.

---

## 3. Make it hard enough (target Codex outcome 1–3)

A well-designed prompt that scores 5–7 is "too easy" and gets bounced. We want the model to struggle, so the "Rate the experience and outcome" score comes out low (1–3). Build in real judgment, trade-offs, and messy inputs. Pull from these levers, matched to the workflow:

- Conflicting drift attribution — the cause of a change is genuinely ambiguous between two sources.
- Multiple unauthorized changes in one run that must each be caught and separated.
- Stricter destructive-operation detection rules that the model must apply, not hand-wave.
- Overlapping compatibility concerns where fixing one breaks another.
- Ambiguous consumer usage patterns that make impact analysis non-obvious.
- Versioning trade-offs and conflicting migration strategies the model has to weigh and prioritize.
- General messy edge cases: duplicates, borderline items, a cold or dead lead, an over-capacity person, an ambiguous requirement, insufficient information that should trigger a follow-up instead of a guess.

Plant these in the inputs (10–20 rows or 5–8 items if using a fake scenario), because without them the model scores high and the task is rejected. The generated prompt should force at least one hard prioritization or trade-off decision, not just mechanical steps.

---

## 4. Human, casual voice

The prompt has to read like a person wrote it to a coworker, not like AI.

- No em-dashes.
- No hashtags.
- No polished, formal, or buzzword sentences. Short and plain.
- Write it the way I'd message a teammate. Casual is preferred over correct-sounding.
- Fine to use AI to spark the wording, but the final text should sound like me.

---

## 5. Final self-check before returning the prompt

The AI should confirm all of these before handing back the prompt. Any "no" means fix it first.

- [ ] Reads from at least one named app and takes a real action in a different named app.
- [ ] Ends in a real change (record, message, ticket, file written back), not just a doc.
- [ ] Written as instructions, zero "I" statements.
- [ ] Every list, sheet, tab, folder, repo, channel, account, property, and field is named.
- [ ] New structures state a concrete minimum (a few named fields), rest left open.
- [ ] Every inferred / picked / filtered / calculated thing has an objective rule (2a).
- [ ] Fixed counts and objective selection criteria for any references/examples/sources step.
- [ ] Pricing source, spend formulas, field/update rules, and dedup priority all stated where relevant.
- [ ] Research steps name the tool (Chrome via browser control).
- [ ] All dates are relative and anchored to the run date, no fixed calendar dates.
- [ ] Every checkpoint maps to a real stage of THIS workflow, no stray placeholders.
- [ ] At least one hard trade-off / prioritization / messy-edge-case is built in so Codex is expected to score 1–3.
- [ ] Says what to produce and the rules, not a step 1 / step 2 / step 3 recipe.
- [ ] No confidential client data or credentials in the text.
- [ ] Reads human: no em-dashes, no hashtags, no formal or AI-sounding sentences.

Return: the finished prompt, a one-line note on the difficulty levers added, and the expected Codex outcome score (aim 1–3).
