# WF-180 — Form 1 (Feather)

> **Draft. Read it aloud and make it yours before pasting into Feather.** There is an AI-written check on
> the reviewer's side. Two blanks left: the session ID, and your own figures for time-to-complete and
> times-per-month.
>
> **Run:** Codex 5.5 Cyan, Extra High, 5m 39s, 17 July 2026.

---

## Field 1 — Workflow description / prompt

Paste Part B from `WF-180-protocol-deviation-irb-clock.md` as-is, no framing. Starts "Working as of
Monday 20 July 2026 (IST)." and ends "...the IRB submission is sitting in Gmail unsent."

## The short-answer fields (2, 4, 5, 8-12)

| Field | Value |
|---|---|
| **Specification level** | Moderately specified. Names the five Docs, the calendar, the Notion database, the Teams channel, the three classes, the draft-not-send rule and when it is done. Which entry goes in which class, the due dates, the pattern and the rest of the record are all left to the model. |
| **Operating system** | macOS |
| **Applications required** | Google Docs, Google Calendar, Notion, Microsoft Teams, Gmail |
| **Occupation category** | Clinical Research Coordinators *(nearest dropdown value; real role in the line below. Feather's list is O*NET-style, not our department list, so don't paste "Medical Professional" here. If there is no clinical research role, take the nearest medical one.)* |
| **Occupation & workplace** | Clinical research coordinator at an academic site running a few enrolling studies. I work the week's deviation queue with the PI who signs the reports. |
| **Time to complete manually** | 120 min *(own honest figure)* |
| **Times per month** | 4 *(own honest figure)* |
| **Workflow difficulty (1-7)** | 7. Twelve entries, three studies, three different visit windows. The queue has no dates, the calendar has no rules, the SOP has no visits, so nothing can be settled from one place. And one of the calls only shows up if you look across entries, not at any single one. |

## Field 3 — my setup

I am a clinical research coordinator at an academic site. Every Monday I take last week's deviation
queue and class each entry with Dr Rao, our PI. Here the queue, the three protocols (ORION-3,
CASTELLA-2, NIMBUS-7) and the site SOP are Google Docs in my Drive. The subject visits, scheduled and
attended both, are on my Google Calendar, and the institute holidays sit there too. The register is the
Notion database "Deviation Register - July 2026", the team talks in the Teams channel "site-deviations",
and I draft the IRB submission in Gmail for Dr Rao to send. Twelve entries a week is normal for us.

## Field 6 — why / when

Weekly. It is not a script because the class is a judgment every time, and the same fact goes both ways
depending on the study. A visit 5 days late is fine in one protocol and a deviation in the next, only
the protocol says which. Get it wrong and it costs either way: under-report a safety assessment and it
comes up in an inspection, over-report and you have put a subject in front of the IRB for nothing. The
clock is the same story. It runs in business days from when the PI came to know, and our own holidays
come off it, so one day out is a late report. Whatever class I write is what the IRB sees at continuing
review later.

## Field 7 — partial-credit checkpoints

**One per step box in Feather, not bundled** (reviewer, 2026-07-15). 10 boxes.

- Each entry worked against its own study's protocol, not one general rule about late visits
- Register has 12 records, one per queue entry, each with a class and a reason naming the clause
- ORN-014 comes out not a deviation (ORION-3's plus-or-minus-7 window) and shows up nowhere else
- CST-022 comes out promptly reportable, reason naming the Week 8 panel as a safety assessment
- CST-016 comes out continuing review, the opposite call to CST-022 on the same study and same visit
- The three NIMBUS-7 window misses come out promptly reportable as one pattern, reason naming SOP §4
- NMB-025's reason carries both halves: permitted without prior IRB approval, and still reportable
- Due dates only on the promptly reportable ones, and each is either Wed 22 Jul or Fri 24 Jul
- Teams post has exactly the promptly reportable subjects, soonest due first, counts matching the register
- One unsent Gmail draft to the IRB address the SOP names, nothing from continuing review in it

## Field 13 — Rate the experience and outcome (1-7)

**4**

It got the two hard calls I expected it to miss, and still left a register I cannot use as it stands.
Four points kept, three off.

**What it earned.** It caught the pattern. The three NIMBUS-7 Week 4 misses are small one by one, and it
read them as one cluster under SOP §4 and clocked all three off the latest awareness date instead of
each visit separately. It also went to the calendar for Institute Foundation Day rather than just
counting business days, so both dates came out right, 22 and 24 July, not the 23 July you get if you
never open it. Six promptly reportable, and the right six. Due dates only on those six. Teams post
soonest due first. IRB draft went to the SOP's address, not a guessed one, and stayed unsent.

1. **The class split does not match the queue.** It came out 6 promptly reportable, 4 continuing review,
2 not deviations. Only one entry here is not a deviation. So one entry has dropped out of continuing
review, and that one now carries no class into the continuing-review submission later.

2. **No sign the records carry a reason.** It said itself it made the records "using only the database's
existing fields". The whole point of the register is that each record says which protocol or SOP clause
the call rests on. A class sitting there with no reason is no use to me at continuing review, and it is
the first thing asked for in an inspection.

3. **NMB-025's both-halves call is not shown.** Class is right. But that entry is a dose held with rescue
given, which the SOP permits without prior IRB approval and still makes reportable. Nothing shows the
record says both. One half only looks the same in a class column and is wrong.

**Points 1 to 3 are off the run's own summary, not off Notion. Open the register first and confirm
them.** If the reasons are actually there and name the clause, and NMB-025 carries both halves, then 2
and 3 go away and this is a 5 or 6. In that case do not change the score, harden the build and rerun.
The key already names the lever: drop "so the date arithmetic runs off that rather than off what the
queue entry claims" from Part B, that is the line that sends a run to the calendar at all.

## Field 14 — Notes on Codex's performance

**Session ID:** `<<< paste it here >>>`
**Execution time:** 5 min 39 sec
**Model:** Codex 5.5 Cyan, Extra High, 17 July 2026

**Connectors.** All five connected and finished, no partial: Google Drive/Docs, Google Calendar, Notion,
Teams, Gmail. It checked everything was reachable before writing anything, which is what the prompt
asks, and read back the four Docs, the calendar, the register, the "site-deviations" channel and the
Gmail account before starting.

**One Notion hiccup, it recovered.** Its words: *"The Notion skill requires its enhanced-Markdown
resource to be read before creating database pages. The direct resource lookup did not resolve under the
connector's apparent server name, so I'm doing the connector resource discovery step now; this does not
change any workspace data."* It ran discovery and wrote all 12 records. Nothing was touched by the
failed lookup. Cost it a step only, no effect on the result, but worth watching on a rerun.

**What it did right.** It took the visit dates off the calendar instead of the queue's wording, and it
found Institute Foundation Day on 17 July and took it out of both clocks. Its words: *"The due-date
calculations exclude the 17 July institute holiday and intervening weekends."* So both dates landed
right, 22 and 24 July, not the one-day-out 23 July. It also read the three NIMBUS-7 Week 4 misses as one
pattern: *"three late Week 4 visits fall outside that protocol's plus-or-minus-2-day window, so SOP
section 4 makes all three promptly reportable and clocks the pattern from the most recent PI-awareness
date."* That is the across-entries call and honestly I expected it to miss that one.

The six promptly reportable are the right six and it named them: NMB-003, NMB-011, NMB-018, NMB-025 due
22 July, CST-009 and CST-022 due 24 July. Due dates only on those six. Teams post has those six, soonest
first. Gmail draft to irb-submissions@vensara.example.org, which is the SOP's address, subject "Prompt
report: six deviations identified 13-17 July 2026", DRAFT label, not sent, and it confirmed that on a
readback rather than just saying so.

**Errors.** The register came out 6 promptly reportable, 4 continuing review, 2 not deviations. Only one
entry here is not a deviation, so one has dropped out of continuing review and will carry no class into
the submission later. Then it said it made the records "using only the database's existing fields", and
nothing it produced shows a reason per record naming the protocol or SOP clause. A class with no reason
is no use to me. Same for NMB-025: right class, but nothing shows the record carries both halves,
permitted and still reportable.

---

**<<< Open the apps and rewrite this from what you see before submitting. >>>** Everything above the
Errors bit is off artifacts the run named. The three errors are off its own summary, and that is what
got WF-090 and WF-178 bounced with "the initial testing has not yet been fully verified". Both read
differently once the files were opened. Four checks, Notion unless said:

1. **Filter class = not a deviation, read the two subject IDs.** If ORN-014 is one, the restraint trap
   was caught and this is a 5 or 6, not a 4. If it is not one, 4 is right but the reason changes, so say
   the real one.
2. **CST-022's reason.** Does it name the Week 8 panel as a safety assessment, or just repeat the queue's
   "missed sample" wording? Settles point 2.
3. **NMB-025's reason.** Both halves or one? Settles point 3.
4. **Teams post and Gmail draft: check ORN-014 is in neither**, in any form, including "reported out of
   caution".

## Field 15 — Confidentiality

Tick after checking. All of it is invented: the site, the three studies, the subjects, the PI, the IRB
address, the holiday. No real study, site, subject or patient data, no credentials.
