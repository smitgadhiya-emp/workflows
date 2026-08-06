# WF-180 seed / re-seed (run this AFTER the cleanup, BEFORE the eval)

Rebuilds the fixed bench: the "Deviation Queue - week of 13 July 2026" Google Doc with its twelve
entries, the three protocol Docs with their own visit windows and assessment lists, the "Site SOP -
Deviation Reporting" Doc with the classes and the clock, the 25 Google Calendar events, the empty
Notion "Deviation Register - July 2026" database and the empty "site-deviations" Teams channel. It is
the fixture, so it is literal: the windows, the assessment lists, the awareness dates and the calendar
dates are the whole test. Paste into Codex with Google Drive/Docs and Google Calendar connected on a
demo account (Notion and Teams just need to exist for the eval, Gmail only needs to be connected).

Same content as the Part A seed block in the [main file](WF-180-protocol-deviation-irb-clock.md), and
this file is generated from it. If you change a value in one, change it in the other so they do not
drift. The only difference is the first paragraph, which clears leftovers so re-seeding is safe.

> **Do not paraphrase these sentences and do not reorder them. They are the traps.**
>
> - **ORION-3 §5 keeps its "plus or minus 7 days" window**, and keeps the sentence saying a visit
>   inside the window is not a deviation. ORN-014's calendar pair (scheduled Wed 8 July, attended Mon
>   13 July) has to stay exactly 5 days apart. Widen the gap past 7 and the restraint trap dies.
> - **CASTELLA-2 §6.2 has to keep naming the Week 8 chemistry and haematology panel a safety
>   assessment**, and §6.4 has to keep the quality-of-life questionnaire out of that list. CST-022 and
>   CST-016 are the same study and the same visit, and only those two sections split them.
> - **Queue entry 2 stays administrative in its wording.** "Missed sample", "catch-up at the next
>   visit". Do not let a seeding run helpfully add "this is a safety lab" to it. That entry reading
>   harmless is the trap.
> - **SOP §3 keeps both halves in one place**: permitted without prior IRB approval, and still
>   promptly reportable. Split them across sections and NMB-025 gets easy.
> - **NIMBUS-7 keeps its "plus or minus 2 days" window** and NMB-003, NMB-011 and NMB-018 keep their
>   calendar pairs, so all three land outside it and make three of the same type. Two is not a pattern.
> - **"Institute Foundation Day - institute closed" goes on the Google Calendar on Friday 17 July
>   2026 and appears nowhere in the SOP.** The SOP says holidays are on the calendar, and that is all
>   it says. Write the date into the SOP text and the clock trap evaporates, because a run reads the
>   SOP anyway and never has to go looking.
>
> **The awareness dates are load-bearing.** 13, 14, 15, 16 and 17 July are not filler. Move one and
> the due dates in the grading key go wrong.

```
Set up a fixed test workspace for a clinical-site protocol-deviation task. All invented for
testing, no real studies, no real people, no real patient data. If Google Docs called "Deviation
Queue - week of 13 July 2026", "ORION-3 Protocol", "CASTELLA-2 Protocol", "NIMBUS-7 Protocol" or
"Site SOP - Deviation Reporting" already exist from a past run, move the old ones to trash first
and build clean copies. If the calendar events below are already on my Google Calendar from a past
run, delete those first too, a duplicate visit date breaks the exercise. Then build everything below
exactly as written.

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

## After it runs

Check the reply gives you links to all five Google Docs, the Notion database and the Teams channel,
says the 25 calendar events are in, and says the Notion "Deviation Register - July 2026" database has
**zero rows**.

Then open things yourself and spot-check five, because they are the test:

1. **Google Calendar, Friday 17 July 2026.** "Institute Foundation Day - institute closed" is there.
   No holiday, no clock trap.
2. **Google Calendar, ORN-014.** Scheduled Wed 8 July, attended Mon 13 July. Count it: 5 days.
3. **"ORION-3 Protocol" §5.** Still says plus or minus 7 days.
4. **"CASTELLA-2 Protocol" §6.2.** Still names the Week 8 chemistry and haematology panel as a safety
   assessment, and §6.4 still lists the quality-of-life questionnaire as not one.
5. **"Deviation Queue" entry 2.** Still reads like an admin slip. If the seeding run has added a
   safety hint to it, re-seed.

Seeding runs like to be helpful and explain things. If entry 2 now says the draw was a safety
assessment, or the SOP now names the holiday date, re-seed before you run the eval. Either edit hands
over a trap for free.

Then paste the eval (Part B) from the [main file](WF-180-protocol-deviation-irb-clock.md) into Codex
5.5 on Extra High, as-is, with no framing.
