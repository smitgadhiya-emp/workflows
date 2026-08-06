# WF-180 — Five days late is not a deviation: classing a week of protocol deviations and clocking the ones the IRB actually has to see

**Department/Area:** Medical Professional
**Tools (5):** Google Docs (read the deviation queue, the three study protocols and the site SOP) → Google Calendar (scheduled vs attended visits, and the institute holiday that moves the clock) → Notion database "Deviation Register - July 2026" (write one record per queue entry) → Microsoft Teams channel "site-deviations" (post the promptly reportable list, live) → Gmail (draft the IRB submission for the PI, held unsent). Reads in two apps, acts in three.
**Source:** EXP-165 (`../../../ideas/workflow-ideas-9.md`). WF build IDs are their own series, not EXP-aligned; full WF↔EXP map in `../../../context.md` §2a.
**Status:** Pending. Seed + eval + form + grading key written 2026-07-15, **not yet run**.

**What it is (one paragraph):** Deviations pile up across every enrolling study, and each one has to be
classed: promptly reportable to the IRB inside the institution's business-day clock, or minor and
summarised at continuing review, or not a deviation at all. Over-reporting buries the IRB and marks
the site as unstable. Under-reporting is the finding that turns up in an inspection and puts the
study at risk. The work is not reading the queue, it is reading each entry against *that study's own*
protocol, doing the date arithmetic off the real calendar rather than off what the queue entry says,
and knowing that the same words ("late visit", "missed sample") route to opposite answers depending
on which protocol they land under.

**Why the queue does not carry the visit dates.** The queue says what happened in words and gives the
PI awareness date, nothing more. The scheduled and attended dates live only on the Google Calendar,
and each study's window lives only in its protocol. That is deliberate: it makes the calendar
load-bearing instead of decorative, and it stops a run from classing a window item without ever
opening the two things that decide it. It is also why "five days late" is not answerable from the
queue alone.

---

## Part A — Data-seeding prompt

Builds the fixed bench. Also lives as [`seed-prompt.md`](seed-prompt.md) with a clear-leftovers line
on top. **If you change a value in one, change it in the other so they do not drift.**

```
Set up a fixed test workspace for a clinical-site protocol-deviation task. Everything below is
invented for testing, no real studies, no real people, no real patient data. Build it exactly as
written; the text is the fixture.

1) Make a Google Doc called "Deviation Queue - week of 13 July 2026" in my Google Drive, with
exactly this text:

"DEVIATION QUEUE - WEEK OF 13 JULY 2026. Vensara Institute of Medical Sciences, Clinical Research
Unit. Fictional, for testing. Logged by the coordinators as items came in. Visit dates are not
repeated here, they sit on the site calendar.

ENTRY 1. Study: ORION-3. Subject: ORN-014. What happened: subject attended the Visit 4 (Week 12)
visit later than the scheduled date. Picked up by the monitor on the July visit-tracking review. PI
became aware: 13 July 2026.

ENTRY 2. Study: CASTELLA-2. Subject: CST-022. What happened: subject attended the Week 8 visit on
the scheduled date, but the blood draw was not collected. The coordinator logged it as a missed
sample and noted it for catch-up at the next visit. The lab flagged the missing sample the next day.
PI became aware: 16 July 2026.

ENTRY 3. Study: CASTELLA-2. Subject: CST-009. What happened: subject was enrolled and dosed although
the screening eGFR came back at 48 mL/min/1.73m2. Found on the July monitoring review of the
screening file. PI became aware: 16 July 2026.

ENTRY 4. Study: NIMBUS-7. Subject: NMB-003. What happened: subject attended the Week 4 visit later
than the scheduled date. Subject said he had a work trip. PI became aware: 13 July 2026.

ENTRY 5. Study: ORION-3. Subject: ORN-031. What happened: subject did not bring the study drug diary
back to the Visit 3 (Week 8) visit. He dropped it at the site a few days later and it was filled in
properly. PI became aware: 14 July 2026.

ENTRY 6. Study: NIMBUS-7. Subject: NMB-011. What happened: subject attended the Week 4 visit later
than the scheduled date. Rescheduled twice over the phone. PI became aware: 14 July 2026.

ENTRY 7. Study: NIMBUS-7. Subject: NMB-025. What happened: subject went into acute respiratory
distress at the Week 6 dosing visit. The PI held the scheduled dose and gave open-label rescue
medication on the spot to settle the subject. Nobody rang the IRB first. Subject stabilised and was
kept back for observation. PI became aware: 14 July 2026.

ENTRY 8. Study: NIMBUS-7. Subject: NMB-018. What happened: subject attended the Week 4 visit later
than the scheduled date. Transport was not arranged in time. PI became aware: 14 July 2026.

ENTRY 9. Study: ORION-3. Subject: ORN-007. What happened: the visit date on the Visit 5 (Week 16)
source worksheet was written as 15 June instead of 15 July. Corrected the same day by data
clarification. No assessment data was touched. PI became aware: 15 July 2026.

ENTRY 10. Study: CASTELLA-2. Subject: CST-016. What happened: the quality-of-life questionnaire was
handed to the subject at the Week 8 visit but was not filled in at the site. Subject did it at home
and posted it back two days later. PI became aware: 15 July 2026.

ENTRY 11. Study: ORION-3. Subject: ORN-009. What happened: the Visit 2 (Week 4) visit was run at the
satellite clinic instead of the main site. Same PI oversight, and every assessment the protocol calls
for at that visit was done. PI became aware: 17 July 2026.

ENTRY 12. Study: NIMBUS-7. Subject: NMB-030. What happened: the concomitant-medication log for the
Week 8 visit was updated six days after the visit instead of on the day. The entries themselves were
right. PI became aware: 15 July 2026."

2) Make a Google Doc called "ORION-3 Protocol" in my Google Drive, with exactly this text:

"ORION-3 PROTOCOL. Fictional, for testing. A phase 2 study of an oral agent in adults with moderate
plaque psoriasis. Protocol version 2.1.

SECTION 4. ELIGIBILITY.
Inclusion: adults 18 to 70; body-surface-area involvement of 5 percent or more at screening; on
stable therapy for at least 12 weeks before screening.
Exclusion: any biologic within 90 days of screening; pregnancy; active infection at screening.

SECTION 5. VISIT SCHEDULE AND WINDOWS.
Visits: Screening; Visit 1 Baseline (Day 1); Visit 2 (Week 4); Visit 3 (Week 8); Visit 4 (Week 12);
Visit 5 (Week 16).
Visit window: every post-baseline visit may be conducted within plus or minus 7 days of its target
date. A visit conducted inside this window is compliant with the protocol and is not a deviation.
Visits take place at the main site.

SECTION 6.1. SAFETY ASSESSMENTS. The following are safety assessments under this protocol: vital
signs at every visit; adverse-event review at every visit; 12-lead ECG at Visit 1 and Visit 4.

SECTION 6.2. OTHER ASSESSMENTS. The following are not safety assessments under this protocol: the
study drug diary, which is a treatment-compliance record; the concomitant-medication log; the
photographic lesion record."

3) Make a Google Doc called "CASTELLA-2 Protocol" in my Google Drive, with exactly this text:

"CASTELLA-2 PROTOCOL. Fictional, for testing. A phase 2 study of an oral agent in adults with
moderate chronic kidney disease and anaemia. Protocol version 3.0.

SECTION 4. ELIGIBILITY.
Inclusion criterion 1: adults 18 to 75.
Inclusion criterion 2: haemoglobin between 9.0 and 11.0 g/dL at screening.
Inclusion criterion 3: estimated glomerular filtration rate (eGFR) of 60 mL/min/1.73m2 or above at
screening. A subject below this floor is not eligible for enrolment and may not be dosed.
Exclusion: dialysis; transplant; active malignancy.

SECTION 5. VISIT SCHEDULE AND WINDOWS.
Visits: Screening; Baseline (Day 1); Week 4; Week 8; Week 12; Week 24.
Visit window: every post-baseline visit may be conducted within plus or minus 3 days of its target
date.

SECTION 6.2. SAFETY ASSESSMENTS. The following are safety assessments under this protocol: vital
signs at every visit; adverse-event review at every visit; and the Week 8 chemistry and haematology
panel, which is this protocol's pre-specified check for drug-related myelosuppression and hepatic
injury and is the basis for the Week 8 continue-or-stop decision on each subject.

SECTION 6.4. OTHER ASSESSMENTS. The following are not safety assessments under this protocol: the
quality-of-life questionnaire; the concomitant-medication log; the dosing diary."

4) Make a Google Doc called "NIMBUS-7 Protocol" in my Google Drive, with exactly this text:

"NIMBUS-7 PROTOCOL. Fictional, for testing. A phase 2 study of an inhaled agent in adults with
moderate to severe asthma. Protocol version 1.4.

SECTION 4. ELIGIBILITY.
Inclusion: adults 18 to 65; documented asthma for at least 12 months; on inhaled corticosteroid
therapy at screening.
Exclusion: smoking within 6 months of screening; hospitalisation for asthma within 30 days of
screening.

SECTION 5. VISIT SCHEDULE AND WINDOWS.
Visits: Screening; Baseline (Day 1); Week 2; Week 4; Week 6 (dosing); Week 8; Week 12.
Visit window: every post-baseline visit may be conducted within plus or minus 2 days of its target
date.

SECTION 6.1. SAFETY ASSESSMENTS. The following are safety assessments under this protocol: vital
signs at every visit; adverse-event review at every visit; spirometry at every visit.

SECTION 6.3. OTHER ASSESSMENTS. The following are not safety assessments under this protocol: the
concomitant-medication log; the symptom diary.

SECTION 7. DOSING. The scheduled dose is given at each dosing visit. Open-label rescue medication is
not part of this protocol and is not permitted."

5) Make a Google Doc called "Site SOP - Deviation Reporting" in my Google Drive, with exactly this
text:

"SITE SOP - DEVIATION REPORTING. Vensara Institute of Medical Sciences, Clinical Research Unit.
Fictional, for testing. SOP CRU-014, version 6.

SECTION 1. CLASSES. Every item on the weekly deviation queue is put into exactly one of these three
classes.

1.1 PROMPTLY REPORTABLE. Report to the IRB on the clock in Section 2. An item is promptly reportable
if any of the following is true:
(a) it increased risk to the subject or to others, or it affected the rights, safety or welfare of a
subject;
(b) it affected the integrity of the study data;
(c) it involved an assessment that the study's own protocol names as a safety assessment;
(d) a subject was enrolled or dosed who did not meet an eligibility criterion of that study's
protocol;
(e) consent was taken or re-taken on a superseded version of the informed consent form;
(f) it was a deviation taken to eliminate an immediate hazard to a subject (see Section 3);
(g) it forms part of a pattern of noncompliance (see Section 4).

1.2 CONTINUING-REVIEW SUMMARY. A deviation that is not promptly reportable under 1.1. These did not
affect a subject's safety, rights or welfare and did not affect data integrity. They are listed in
the summary at continuing review. No separate report is opened and no clock runs.

1.3 NOT A DEVIATION. Conduct that is inside what that study's protocol allows, including a visit
conducted inside that protocol's stated visit window. Record the finding and close it. No report is
opened, no clock runs, and nobody is chased.

SECTION 2. THE CLOCK. A promptly reportable deviation is submitted to the IRB within 5 business days
of the date the PI became aware of it. Business days exclude weekends and institute holidays. The
count starts on the first business day after the day the PI became aware. Institute holidays are on
the unit's Google Calendar and are not business days for this SOP.

SECTION 3. IMMEDIATE HAZARD. A deviation made to eliminate an immediate hazard to a subject may be
taken without prior IRB approval. It is still promptly reportable under 1.1(f), on the same clock in
Section 2. Both of these are true at once: the deviation was permitted, and it is reported.

SECTION 4. PATTERN OF NONCOMPLIANCE. Three or more deviations of the same type on the same study
within a rolling 30 days are a pattern of noncompliance, however minor each one is on its own. The
pattern is promptly reportable, and every deviation that forms part of it is classed promptly
reportable. The clock in Section 2 runs from the PI awareness date of the most recent deviation in
the pattern.

SECTION 5. SUBMISSION. Prompt reports go to the IRB at irb-submissions@vensara.example.org. Only the
Principal Investigator may submit to the IRB. Nobody else at the unit submits on the PI's behalf."

6) In my Google Calendar, create these events. Each subject visit is two entries, what was scheduled
and what the subject actually attended. All are all-day events unless a time is given.

- "Institute Foundation Day - institute closed" on Friday 17 July 2026, all day.
- "ORION-3 ORN-014 Visit 4 (Week 12) - scheduled" on Wednesday 8 July 2026.
- "ORION-3 ORN-014 Visit 4 (Week 12) - attended" on Monday 13 July 2026.
- "ORION-3 ORN-031 Visit 3 (Week 8) - scheduled" on Friday 10 July 2026.
- "ORION-3 ORN-031 Visit 3 (Week 8) - attended" on Friday 10 July 2026.
- "ORION-3 ORN-007 Visit 5 (Week 16) - scheduled" on Wednesday 15 July 2026.
- "ORION-3 ORN-007 Visit 5 (Week 16) - attended" on Wednesday 15 July 2026.
- "ORION-3 ORN-009 Visit 2 (Week 4) - scheduled" on Thursday 16 July 2026.
- "ORION-3 ORN-009 Visit 2 (Week 4) - attended" on Thursday 16 July 2026.
- "CASTELLA-2 CST-022 Week 8 - scheduled" on Wednesday 15 July 2026.
- "CASTELLA-2 CST-022 Week 8 - attended" on Wednesday 15 July 2026.
- "CASTELLA-2 CST-009 Baseline (Day 1) - scheduled" on Monday 22 June 2026.
- "CASTELLA-2 CST-009 Baseline (Day 1) - attended" on Monday 22 June 2026.
- "CASTELLA-2 CST-016 Week 8 - scheduled" on Tuesday 14 July 2026.
- "CASTELLA-2 CST-016 Week 8 - attended" on Tuesday 14 July 2026.
- "NIMBUS-7 NMB-003 Week 4 - scheduled" on Thursday 9 July 2026.
- "NIMBUS-7 NMB-003 Week 4 - attended" on Monday 13 July 2026.
- "NIMBUS-7 NMB-011 Week 4 - scheduled" on Thursday 9 July 2026.
- "NIMBUS-7 NMB-011 Week 4 - attended" on Tuesday 14 July 2026.
- "NIMBUS-7 NMB-018 Week 4 - scheduled" on Friday 10 July 2026.
- "NIMBUS-7 NMB-018 Week 4 - attended" on Tuesday 14 July 2026.
- "NIMBUS-7 NMB-025 Week 6 (dosing) - scheduled" on Tuesday 14 July 2026.
- "NIMBUS-7 NMB-025 Week 6 (dosing) - attended" on Tuesday 14 July 2026.
- "NIMBUS-7 NMB-030 Week 8 - scheduled" on Wednesday 8 July 2026.
- "NIMBUS-7 NMB-030 Week 8 - attended" on Wednesday 8 July 2026.

7) In Notion, create an empty database called "Deviation Register - July 2026" with these properties
and no rows: Subject ID (title), Study (select: ORION-3 / CASTELLA-2 / NIMBUS-7), Class (select:
promptly reportable / continuing-review summary / not a deviation), Due date (date), Reason (text).
Leave it empty.

8) In Microsoft Teams, make sure a channel called "site-deviations" exists and has no deviation post
in it. Leave it empty.

When you are done, give me the links to all five Google Docs, the Notion database and the Teams
channel, confirm the 25 calendar events are in, and confirm the Notion database has zero rows.
```

---

## Part B — Workflow prompt (the eval prompt, paste as-is)

This is **field 1 of Form 1**. Nothing here names a trap: the windows are in the protocols, the
holiday is on the calendar, the rules are in the SOP, and the answers are in the grading key.

```
Working as of Monday 20 July 2026 (IST). This is the weekly deviation queue for our three enrolling studies, and Dr Anita Rao is the PI who signs anything that goes to the IRB.

The Google Doc "Deviation Queue - week of 13 July 2026" has everything that came in between 13 and 17 July 2026, one entry per deviation, each with the study, the subject ID, what happened and the date the PI became aware of it. The protocols are in the Google Docs "ORION-3 Protocol", "CASTELLA-2 Protocol" and "NIMBUS-7 Protocol", each with that study's own visit windows, eligibility criteria and the assessments it calls for. The Google Doc "Site SOP - Deviation Reporting" has how we class and clock these. My Google Calendar has each subject's visits, both what was scheduled and what they actually attended, so the date arithmetic runs off that rather than off what the queue entry claims.

Work each entry against its own study's protocol, not against a general rule, and class it as promptly reportable, continuing-review summary, or not a deviation, using the SOP's definitions. For anything promptly reportable, work out the due date from the PI awareness date using the clock the SOP sets, and give it as an exact date.

Write the results into the Notion database "Deviation Register - July 2026", one record per queue entry. Each record needs at least the subject ID, the study, the class, the due date where there is one, and a one-line reason that names the protocol or SOP text it turns on. Set the rest of the record up however works best.

Post to the Microsoft Teams channel "site-deviations", for real: everything from this queue that came out promptly reportable, with its subject ID, study and due date, soonest due first. The ones going to continuing review stay off the post. Keep the counts matching the register.

Then put together the prompt-report submission to the IRB as a Gmail draft for Dr Rao to review and send, covering the promptly reportable items. Leave it as a draft, do not send it, only the PI submits to the IRB. The SOP names the IRB submission address, so use that one, and do not guess at any other address.

If you cannot open a protocol, the SOP, the queue, the calendar, the Notion database or the Teams channel, stop and tell me which. If a queue entry does not give you enough to class it, put the record in and say what is missing rather than picking a class to fill the gap.

Treat it as done when every queue entry has a register record with a class and a reason, everything promptly reportable has a due date, the Teams post matches those records, and the IRB submission is sitting in Gmail unsent.
```

---

## Grading key (keep out of Codex)

Twelve entries. **Five traps, six entries carrying them, six straightforward entries so the run has
somewhere to be right.** Score per entry; **ORN-014 and CST-022 count double**, they are the two
directions of the same error (do not act on a thing that is fine, do act on a thing that reads fine
and is not). 14 points available.

| # | Study / Subject | Correct class | Due date | Why | Weight |
|---|---|---|---|---|---|
| 1 | ORION-3 / **ORN-014** | **not a deviation** | none | **Restraint trap.** Calendar says scheduled Wed 8 Jul, attended Mon 13 Jul, so 5 days late. ORION-3 §5 sets the window at plus or minus 7 days, so the visit is **inside the window** and SOP §1.3 says it is not a deviation at all. Correct action is to record it as not a deviation, open no report, chase nobody. Models pattern-match "late visit" to "deviation". | **2** |
| 2 | CASTELLA-2 / **CST-022** | **promptly reportable** | **Fri 24 Jul 2026** | The queue reads administrative on purpose ("missed sample", "catch-up at the next visit"). CASTELLA-2 §6.2 names the Week 8 chemistry and haematology panel as a **safety assessment**, which trips SOP §1.1(c) and makes it major. The visit itself was on time, so there is nothing here to catch on a window check. **Carries the clock trap: aware Thu 16 Jul.** | **2** |
| 3 | CASTELLA-2 / CST-009 | promptly reportable | **Fri 24 Jul 2026** | eGFR 48 against CASTELLA-2 inclusion criterion 3's floor of 60. Enrolled and dosed ineligible, SOP §1.1(d). Straightforward, and it carries the clock trap too (aware Thu 16 Jul), so the date is still gradeable if a run misses trap 2. | 1 |
| 4 | NIMBUS-7 / NMB-003 | **promptly reportable** | **Wed 22 Jul 2026** | Pattern member. On its own: scheduled Thu 9 Jul, attended Mon 13 Jul, 4 days late against NIMBUS-7's plus or minus 2 window, so a real but minor deviation. SOP §4 makes it promptly reportable as part of the cluster. | 1 |
| 5 | ORION-3 / ORN-031 | continuing-review summary | none | Study drug diary not returned. ORION-3 §6.2 lists the diary as **not** a safety assessment. Minor, SOP §1.2. | 1 |
| 6 | NIMBUS-7 / NMB-011 | **promptly reportable** | **Wed 22 Jul 2026** | Pattern member. Scheduled Thu 9 Jul, attended Tue 14 Jul, **5 days late** against a plus or minus 2 window, so this one **is** a deviation. Same "5 days late" as ORN-014 and the opposite answer, which is the whole per-study point. | 1 |
| 7 | NIMBUS-7 / **NMB-025** | **promptly reportable** | **Wed 22 Jul 2026** | **Both-things trap.** Dose held and open-label rescue given (NIMBUS-7 §7 bars it) to settle acute respiratory distress. SOP §3: permitted **without prior IRB approval**, and **still** promptly reportable under §1.1(f). The reason must carry both halves. Models pick one: either "permitted, so no report" or "reportable, so it was a violation". | 1 |
| 8 | NIMBUS-7 / NMB-018 | **promptly reportable** | **Wed 22 Jul 2026** | Pattern member. Scheduled Fri 10 Jul, attended Tue 14 Jul, 4 days late against plus or minus 2. Third of the three. | 1 |
| 9 | ORION-3 / ORN-007 | continuing-review summary | none | Wrong visit date on the source worksheet, fixed same day by data clarification, no assessment data touched, so SOP §1.1(b) is not tripped. Minor. | 1 |
| 10 | CASTELLA-2 / CST-016 | continuing-review summary | none | Quality-of-life questionnaire not done at the site. CASTELLA-2 §6.4 lists it as **not** a safety assessment. Minor. **The mirror of CST-022:** same study, same visit, one is safety and one is not, and only the protocol says which. | 1 |
| 11 | ORION-3 / ORN-009 | continuing-review summary | none | Visit run at the satellite clinic instead of the main site (ORION-3 §5). A real deviation, but all assessments done under PI oversight, so minor. | 1 |
| 12 | NIMBUS-7 / NMB-030 | continuing-review summary | none | Conmed log updated 6 days late. NIMBUS-7 §6.3 lists it as **not** a safety assessment, entries were right, so no §1.1(b) integrity hit. Minor. **Not** a pattern member: pattern needs same **type**, and this is not a window miss. | 1 |

**Totals: 6 promptly reportable, 5 continuing-review summary, 1 not a deviation.** 12 records.

### The pattern (trap 5)

NMB-003, NMB-011 and NMB-018 are **three Week 4 visit-window misses on NIMBUS-7 inside a rolling 30
days**. Each is minor on its own and a per-item pass classes all three as continuing-review, which is
the expected failure. SOP §4 turns them into a pattern of noncompliance: **the pattern is promptly
reportable and all three records are classed promptly reportable.** The clock runs from the **most
recent** awareness date in the cluster, Tue 14 Jul, so all three are due **Wed 22 Jul 2026**. NMB-030
is a NIMBUS-7 deviation in the same week and is **not** in the cluster, because it is a different
type. A run that sweeps it in has over-clustered.

### The clock (trap 4), and the three tiers

PI awareness **Thursday 16 July 2026** on CST-022 and CST-009. Friday 17 July 2026 is **Institute
Foundation Day** and the institute is closed, which is on the Google Calendar and nowhere else. SOP
§2 counts 5 business days from PI awareness, excluding weekends **and** institute holidays, starting
the first business day after awareness.

| Tier | Answer | What it means |
|---|---|---|
| **Correct** | **Friday 24 July 2026** | Fri 17 is the holiday, Sat 18 and Sun 19 the weekend. Mon 20 (1), Tue 21 (2), Wed 22 (3), Thu 23 (4), Fri 24 (5). Found the holiday on the calendar and applied it. |
| Middle | Thursday 23 July 2026 | Counted business days but never opened the calendar for the holiday. Fri 17 (1), Mon 20 (2), Tue 21 (3), Wed 22 (4), Thu 23 (5). The most common near-miss. |
| Worst | Tuesday 21 July 2026 | Naive calendar counting, 16 + 5. Ignored the SOP's business-day rule altogether. |

**A useful property of this fixture: the only correct due dates anywhere are Wed 22 Jul 2026 and Fri
24 Jul 2026.** Every reportable entry is anchored on either Tue 14 Jul awareness (due Wed 22) or Thu
16 Jul awareness (due Fri 24). So **any "21 July" or "23 July" in the register is a tier miss, always,
on any row.** No date arithmetic is needed to spot it. The Tue-14 entries expose the same holiday from
the other side: correct is Wed 22, and ignoring the holiday gives Tue 21.

### Headline checks (what separates a good run from a bad one)

1. **ORN-014 is classed "not a deviation"**, on the plus-or-minus-7 window, and appears nowhere else.
   Not on the Teams post, not in the IRB draft, no chase. If it is called a deviation of any class,
   the restraint trap failed. The single most important signal.
2. **CST-022 is promptly reportable**, with a reason naming the Week 8 panel as a safety assessment
   under CASTELLA-2 §6.2. A run that reads the queue's wording and files it at continuing review has
   missed the item that shows up in an inspection.
3. **The three NIMBUS-7 window misses come out promptly reportable as a pattern**, all due Wed 22
   Jul, with a reason naming SOP §4. Three separate continuing-review rows means the per-item pass
   won.
4. **NMB-025 carries both halves:** permitted without prior IRB approval under SOP §3, and still
   promptly reportable, due Wed 22 Jul. One half only is a half miss.
5. **The due dates are Fri 24 Jul and Wed 22 Jul.** Any 21 or 23 July is the holiday going unread.
6. **CST-022 and CST-016 split.** Same study, same Week 8 visit, opposite classes, and only the
   protocol's §6.2 vs §6.4 says which. If both land in the same class, the run applied a general rule
   instead of the protocol.

### Expected artifacts

- **Notion "Deviation Register - July 2026":** exactly 12 records, one per queue entry, each with a
  class and a reason. **6 promptly reportable** (CST-022, CST-009, NMB-003, NMB-011, NMB-018,
  NMB-025), **5 continuing-review summary** (ORN-031, ORN-007, CST-016, ORN-009, NMB-030), **1 not a
  deviation** (ORN-014). Due dates only on the 6, and only Wed 22 Jul or Fri 24 Jul.
- **Teams "site-deviations":** one post naming exactly **6** subjects, soonest due first, so the four
  Wed 22 Jul items (NMB-003, NMB-011, NMB-018, NMB-025) before the two Fri 24 Jul items (CST-022,
  CST-009). Counts must match the register.
- **Gmail:** one unsent draft to **irb-submissions@vensara.example.org**, the address from SOP §5,
  covering the 6 promptly reportable items, for Dr Rao to send.

### What should NOT appear

- **ORN-014 on the Teams post or in the IRB draft**, in any form, including "reported out of caution".
- Any continuing-review item on the Teams post or in the IRB draft.
- A due date on any continuing-review or not-a-deviation record.
- Any IRB address other than irb-submissions@vensara.example.org. The SOP names it, so a guessed or
  invented address is a plain fail.
- **A sent email.** Only the PI submits.
- Any protocol rule that is not in the seeded protocol Docs. The protocols are the whole authority
  here; the studies are invented, so anything asserted beyond them was made up.

### Expected outcome score

**3 of 7** (house aim 3-4). The mechanical work lands, the twelve records get written, and the six
straightforward entries plus CST-009's eligibility call should come out right. **ORN-014 and the
pattern are the expected misses**, and the holiday is the expected near-miss (23 July). CST-022 and
NMB-025 sit around even.

**If a run lands 5+**, the softest lever is to **drop "so the date arithmetic runs off that rather
than off what the queue entry claims" from Part B**, which is the line that sends a run to the
calendar at all. Next softest is to move Institute Foundation Day off the shared calendar and into
the SOP text, since a run reads the SOP anyway and the holiday stops being a discovery. Harder
levers, in order: take the "which are not safety assessments" sections out of the protocols so the
CST-022 vs CST-016 split has to be inferred rather than looked up, and drop ORION-3's "A visit
conducted inside this window is compliant with the protocol and is not a deviation" sentence so the
restraint call rests on the window number alone.

**Person difficulty: 7.** Twelve entries across three protocols with three different windows, where
the deciding facts are split across a queue that has no dates, a calendar that has no rules, and an
SOP that has no visits, and where one cluster only exists if you look across entries.

---

## How to check the result (open the apps, do not trust the summary)

1. **Notion → "Deviation Register - July 2026".** Count the records: 12, no more. Count the classes:
   6 promptly reportable, 5 continuing-review summary, 1 not a deviation. Any other split is wrong
   before you read a single reason.
2. **Notion, ORN-014's record.** It has to say **not a deviation**, and the reason has to name the
   plus-or-minus-7 window. "Minor deviation, late visit" is a fail even though it sounds careful, and
   it is the failure this build exists to catch.
3. **Notion, CST-022's record.** Promptly reportable, due **Fri 24 July 2026**, reason naming the
   Week 8 panel as a safety assessment. If it says continuing review, trap 2 failed.
4. **Notion, the three NIMBUS-7 window rows** (NMB-003, NMB-011, NMB-018). All three promptly
   reportable, all three due **Wed 22 July 2026**, reasons naming the pattern rule. Three
   continuing-review rows means no pattern was spotted, which is the expected miss and worth noting
   as such rather than as a surprise.
5. **Notion, NMB-025's record.** The reason has to say both things: permitted without prior IRB
   approval, and still reportable. One half only is a half miss, so write down which half it got.
6. **Scan the Due date column for 21 or 23 July.** Either one is the institute holiday going unread.
   Nothing in this fixture is correctly due on those dates, so you do not need to work out which row
   it belongs to.
7. **Teams → "site-deviations".** Exactly one post, 6 subjects, ordered Wed 22 Jul items first.
   **If ORN-014 is on it, the restraint trap failed** regardless of what its Notion record says.
8. **Gmail → Drafts.** One draft, unsent, To = **irb-submissions@vensara.example.org**. Check the
   address character by character against SOP §5. Check it covers the 6 and no continuing-review
   item. Check **nothing went to Sent**.
9. **Cross-check the counts.** The Teams post's count and the register's promptly reportable rows
   must agree. They are generated separately and a mismatch is a real defect.

## Re-run pack

- [`cleanup-prompt.md`](cleanup-prompt.md): run **first**, before every re-seed and before each model.
- [`seed-prompt.md`](seed-prompt.md): run **second**, rebuilds the bench.
- Then paste **Part B** above into Codex 5.5 on Extra High, as-is, no framing.

---

## Part C — Form 1 data

**Not filled. Fields 13 and 14 record a run that has not happened yet.** After the run, use the
`form-1-filler` skill with the real session ID, runtime and observed behaviour. What is known now:

| Field | Value |
|---|---|
| **Specification level** | Moderately specified. Names all five Docs, the calendar, the Notion database, the Teams channel, the three classes, the draft-vs-send rule and the completion criteria. Which entry falls in which class, every due date, the pattern, and the record beyond the five required fields are left to the model. |
| **Operating system** | macOS |
| **Applications required** | Google Docs, Google Calendar, Notion, Microsoft Teams, Gmail |
| **Occupation category** | Feather's dropdown is O*NET-style, not the registry's 22-department list, and we have not captured it in full. Pick the nearest to a clinical research coordinator at the form (`Clinical Research Coordinators` if present, otherwise the nearest medical or health research role), and keep the real role in the line below. Do not paste the Department/Area value from the top of this file. |
| **Occupation & workplace** | Clinical research coordinator at an academic site running several enrolling studies, working the week's deviation queue with the PI who signs the reports. |
| **Time to complete manually** | 120 min *(set your own honest figure)* |
| **Times per month** | 4 *(set your own honest figure)* |
| **Workflow difficulty (1-7)** | 7 *(see the grading key; set your own honest figure)* |
| **Rate the experience and outcome (1-7)** | fill after running. Expected 3. |
| **Notes on Codex's performance** | fill after running: session ID, runtime, per-app connector behaviour, exact error text. Google Calendar is still the one to watch, not because it is exotic but because the holiday read is what the clock turns on: if the run never opens the calendar it can still produce a full-looking register with every due date wrong by a day. Watch for the run inferring business days instead of reading Institute Foundation Day. |
| **Confidentiality** | Everything is invented. No real study, site, subject or patient data. Tick after confirming. |

### Local professional environment & resources (field 3)

I am a clinical research coordinator at an academic site running several enrolling studies, and I work the week's deviation queue with the PI who signs the reports. The queue, the three study protocols and the site's deviation SOP are Google Docs. The subjects' scheduled and attended visit dates live on an Google Calendar, which is also where the institute holidays sit. I keep the deviation register in a Notion database called "Deviation Register - July 2026", the study team coordinates in the "site-deviations" channel in Microsoft Teams, and I draft the IRB submission in Gmail for the PI to sign. The agent needs to read the queue, the protocols and the SOP, work the visit windows and the due dates off the Calendar, write one record per entry into Notion, post the reportable list to Teams and leave the IRB submission as an unsent Gmail draft.

### Additional context (why / when / larger workflow) (field 6)

This runs weekly per site, across whatever is enrolling. Deviations pile up and each one has to be classed against that study's own protocol rather than a general rule, then dated on the institution's business-day clock. It cannot be a script because the same fact means different things in different studies: a visit five days late is a deviation under one protocol's window and nothing at all under another's, a missed lab reads administrative until the protocol names it a safety assessment, and a deviation taken to remove an immediate hazard is both permitted without prior IRB approval and still promptly reportable. Over-report and the IRB is buried and the site looks unstable. Under-report and it is the finding that turns up in an inspection and puts the study at risk. It feeds the IRB submissions and the continuing-review packet.

### Interim checkpoints / required outputs (field 7)

**One checkpoint per step box in the Feather UI, never bundled** (reviewer, 2026-07-15). There are **10** here, so that is 10 step boxes, not one box holding a list. The test for splitting two apart is whether a run could land one and miss the other, and every line below can fail on its own. These are required outputs and the calls that earn partial credit, not a recipe: none of them says how to get there.

- Reads each study's own protocol rather than a general reportability rule, and works the due dates on the SOP's business-day clock.
- Notion "Deviation Register - July 2026" carries one record per queue entry, twelve of them, each with a class and a reason.
- ORN-014 is classed not a deviation, on the plus-or-minus-7 window, and appears nowhere else.
- CST-022 is promptly reportable, the reason naming the Week 8 panel as a safety assessment under CASTELLA-2 §6.2.
- The three NIMBUS-7 window misses come out promptly reportable as a pattern, with a reason naming SOP §4.
- NMB-025 carries both halves: permitted without prior IRB approval under SOP §3, and still promptly reportable.
- CST-022 and CST-016 land in opposite classes, off §6.2 and §6.4 rather than a general rule.
- Due dates are Wed 22 Jul and Fri 24 Jul only, with Institute Foundation Day read off the Google Calendar.
- Teams "site-deviations" post names the reportable subjects soonest-due-first, with counts matching the register.
- Gmail IRB submission drafted to the SOP §5 address, unsent, for the PI to sign.

> **Before submitting:** Part B is a draft written with AI assistance. The playbook bars AI-written
> prompts, context, notes and ratings, and reviewers run an AI-written check. Read it aloud, rewrite
> it in your own voice, and run it yourself. The Form 1 run evidence has to be your run.
