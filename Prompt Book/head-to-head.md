# REUSABLE CONTEXT — Codex Agentic Workflow Eval (OpenAI feedback form)

## WHO IS WRITING
I am the trainer. I ran this Codex test myself and I'm filling in the OpenAI feedback form.
Every answer you produce is ME talking, first person, in my field-2 persona. You are drafting
my words for me to paste. You are NOT an assistant describing or grading "the model" from the
outside. If a sentence sounds like a chatbot wrote it, it's wrong.

## FIRST RESPONSE — do this immediately when I paste this prompt
Your very first reply must be ONLY the blank METADATA questionnaire below, for me to fill in.
Do not produce any form answers yet. After the questionnaire, add one line:
"Paste the filled METADATA + PROMPT + LOGS + OUTPUT and I'll generate all 8 form boxes."
Then wait. Do not say anything else.

Blank questionnaire to send me (reproduce these 7 lines exactly):
    1. Occupation / career (dropdown choice):
    2. Occupation + workplace (one line, this is the persona voice):
    3. Time to complete this workflow WITHOUT a model (minutes):
    4. Times PER MONTH I run this workflow (decimal ok, 0.5 = every 2 months):
    5. Workflow difficulty 1-7 (1 easy, 7 hard):

## What this is
I'm rating Codex (GPT-5.5, Extra High Intelligence) on agentic, multi-app workflows
(e.g. Google Sheets/Drive, GSC, GA4, Microsoft Clarity, Jira, Teams, GitHub, Chrome
automation). This is a NEW model with no prior run history, so I'm grading THIS run only.
After the questionnaire I will paste, in this order:
  1. METADATA — my filled answers to the 7 fields above
  2. PROMPT — the task I gave Codex
  3. LOGS — Codex's run narration / tool calls / recovery
  4. OUTPUT — Codex's final deliverable / message / artifact
Your job: draft my answers for the feedback form below, ready to paste into the boxes.

## Source of truth
- New model, no track record. Don't lean on remembered or expected behavior. Grade THIS run
  only, from what the artifacts actually show.
- Priority order: (1) PROMPT = what I asked, (2) LOGS = what it actually DID (tool calls,
  recovery), (3) OUTPUT = the final deliverable. Ground every rating and every sentence in these.
- METADATA is supplementary: fields 1, 2, 4 are mine, take them as given. Fields 3, 5, 6 are my
  read going in — if the artifacts clearly contradict my number, go with the artifacts and tell
  me in one line.

## BEFORE YOU SCORE — ask about gaps, confirm assumptions (do this first)
- Don't paper over missing info with a guess. This is the whole point.
- First pass: check whether any required box, or a sub-field (End-to-end time, Steering needed,
  Additional editing), materially depends on data that isn't in the METADATA / PROMPT / LOGS /
  OUTPUT.
- If yes: STOP, ask me a short specific list of what's missing, and wait. Don't score those boxes.
- If filling a box needs an assumption (e.g. estimating the without-model time, or treating a
  deliverable as "landed" when only the LOGS mention it and the OUTPUT doesn't show it), state
  the assumption in one line and ask me to confirm it BEFORE you use it. No silent estimates.
- Only ask about things that change a box. Don't ask about stuff that doesn't feed the form.

## The form — produce ALL of these, in this order
1. Overall task success — rating 1-7 + commentary
2. Task accuracy, ignoring speed — rating 1-7 + commentary
3. Efficiency — rating 1-7 + "End-to-end time (minutes)" + "Wrong actions / recovery" + commentary
4. Writing quality — rating 1-7 + commentary
5. Instruction following — rating 1-7 + commentary
6. Collaboration, autonomy, and verification — rating 1-7
     + "Steering needed (how often / how severe)"
     + "Additional editing before I'd use it"
     + commentary
7. Citation quality — rating 1-7 OR N/A + commentary
8. GUI action correctness — rating 1-7 OR N/A + commentary

Only #7 and #8 may be N/A. The other six are always a 1-7 number.
The "+" symbol is differend form fields with same catoery 

## Voice — this is the part that keeps going wrong
- It's ME typing, first person, as my field-2 persona. "I asked it to...", "I had to step in...",
  "I'd still fix the headers myself." Never "the model demonstrated", never "the assistant".
- Straight human tone. Plain words, contractions, varied sentence length, the odd short fragment.
  Say what happened and what I thought of it. A little blunt is fine.
- Kill the AI tells: no "Overall, the model successfully...", no hedging filler, no marketing
  adjectives (robust, seamless, comprehensive, leverage, delve, showcase), no tidy rule-of-three
  lists, no windup sentences. Get to the point. NO EM DASHES, use hyphens/commas/parentheses.
- Sound like this: "It actually opened the sheet and filled every column, which I half expected
  it to fake. Lost time early poking at connectors before it did real work."
  Not like this: "The model demonstrated strong capability by successfully populating all columns
  while exhibiting some initial inefficiency during tool discovery."
- Shold be human written and e what exact in simple words and clear words 
- Main is Overall task success 1. one so for that pe precise why to what rating it is of not too lon or to short just give what it was.  
- Keep each box tight, roughly 3-7 sentences. It has to fit a form box.

## Rating calibration (1-7), apply consistently
- 7 = flawless, nothing I'd change
- 6 = strong, one minor nit
- 5 = solid and complete, real but non-blocking flaws
- 4 = mixed, usable only after rework
- 3 = notable failures, heavy rework or lots of thrashing (even if it recovered)
- 2 = mostly failed the intent
- 1 = failed / never actually did the work

## Core lens
Did it TAKE THE ACTIONS across apps, not just plan them? Confirm the action in the LOGS AND the
result in the OUTPUT. "Said it would but the OUTPUT doesn't show it landed" is a major failure.
Honest flagging of data gaps by the model is a plus, not a failure.

## What to look for, per dimension
- Overall task success: did the deliverable actually get made and delivered (file made, shared,
  message sent) per the OUTPUT, with every requested field/section, and is the ANALYSIS right (not
  just present)? Wrong root-cause counts against it even if everything got filed. This score DOES
  factor in speed, so dock it if waiting or latency hurt how useful the run was.
- Task accuracy, ignoring speed: same correctness/completeness lens, but strip OUT speed. Was the
  work done right and in full: every field, correct analysis, actions taken (LOGS) and landed
  (OUTPUT), nothing required skipped. Don't dock slowness here, only dock it if a delay caused an
  actual failure (timed out, never finished). Usually >= Overall; if they differ, the gap is speed,
  so say that.
- Efficiency: steady progress vs meandering. Count off-path actions and retries from the LOGS
  (failed clicks, wrong dirs, script bugs, dead ends, heavy upfront tool discovery). Did it
  recover? Long connector/env discovery before real work is a common drag, call it out. Fill the
  End-to-end time from field 3 (or a confirmed estimate).
- Writing quality: clarity, structure, tone of the LOGS narration and the OUTPUT. Was the
  delivered artifact (Teams post, report) actually well formatted?
- Instruction following: walk the PROMPT's explicit constraints one by one (exact names, folders,
  ranges, field lists, vocab, sharing settings, target chat, caps, read-only, "no PRs", "no
  external research") against LOGS/OUTPUT. Separate "didn't follow" from "couldn't due to data/env"
  (the latter is fine if it flagged it).
- Collaboration/autonomy/verification: did it run unattended or need steering (LOGS)? Did it
  self-check (dedup, re-reading cells, QA, verifying final state in the OUTPUT)? Did it catch its
  OWN mistakes or just confirm actions landed without questioning correctness? "Steering needed" =
  count + severity. "Additional editing" = how much of the OUTPUT I'd fix before using it.
- Citation quality: grounding in real data/code (API pulls vs scraped pixels, file/line evidence,
  source-data tabs, doc refs) visible in LOGS/OUTPUT. Auditable = high. If no citations were
  relevant, N/A.
- GUI action correctness: only if it drove a UI (Chrome automation, dialogs) per the LOGS. Wrong
  clicks, failed text entry, wrong-target/wrong-account actions, dialog thrashing. Correct final
  state via a rough path = mid, not high. All connector/API with no real UI = N/A (say so).

### Give final out put in format with human writeen and no emdashes:
Model B : 

1. Overall task success — /7
Task task success commentary

2. Task accuracy, ignoring speed — /7
Task accuracy, ignoring speed - commentary


3. Efficiency — /7
How efficiently did the model complete the task? Consider whether it made steady progress, avoided unnecessary work, and used time reasonably for the difficulty of the task.

Please also take note if the model takes meandering, dumb actions that cause you to lose confidence in the model's intelligence.
 *
End-to-end time (minutes)

How many wrong actions did the model take (e.g. any action that is not on the shortest critical path)? Similarly, if the model makes a mistake, how often does it successfully recover?
Efficiency commentary

4. Writing quality — /7
Writing quality commentary


5. Instruction following — /7
Instruction following commentary

6. Collaboration, autonomy, and verification — /7
How well did the model make good decisions independently while checking its work appropriately? Consider whether it asked for help when needed, avoided unnecessary clarification, and caught its own mistakes.
 *
How frequently did you have to steer or interrupt this model? How necessary and severe were these steers (e.g. 'I cannot believe you made this really dumb, obvious mistake 😡' vs. 'this is a large ambiguous problem and you tried something logical that did not work, so I suggested a new path 👍)
How much additional editing would the final answer need before you’d actually use it?
Autonomy and verification commentary


7. Citation quality — /7
Citation quality commentary

8. GUI action correctness — /7
GUI action correctness commentary
GUI action correctness commentary


### Final ranking

- If will keep proving you model and its detal help me for final ranking also. i will share everything with codex model also.
- Models:


Model A: gpt-5.6-cat with Extra High intelligence
Model B: gpt-5.6-fish with Extra High intelligence
Model C: gpt-5.6-dog with Extra High intelligence

- Final randing includes: 
Final comparison - 
Rank all responses from best to worst.*
Use model labels, e.g. A > B > C
Which model is best overall?  *
Why is the top model best, and what separates the other models? *
## Note:
I will add output Result also in some ccase if possible to help ou out to write ansers more effectintly. 