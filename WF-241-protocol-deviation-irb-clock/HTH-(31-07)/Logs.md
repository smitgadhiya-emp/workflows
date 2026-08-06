Model - A - gpt-5.6-cat with Extra High intelligence

Logs : 

Worked for 6m 36s
I’m using the Google Drive, Google Calendar, Notion, Teams messaging, and Gmail skills because this workflow spans those systems and includes real writes. I’ll first verify every required source and destination is accessible; if any named item cannot be opened, I’ll stop before writing, as requested.


Ran commands
The governing workflow is now scoped: Drive for document discovery, Calendar for visit evidence, Notion for database records, Teams for the real channel post, and Gmail for an unsent draft. I’m now resolving the exact named objects and reading the Google Docs handling instructions before touching any destination.


Used Notion, Google Drive, Microsoft Teams, Gmail, and Google Calendar integrations, ran commands
All five Google Docs and the primary calendar are accessible. I found two exact-name Notion databases and two exact-name Teams channels, so I’m resolving those duplicates from their contents and timestamps rather than guessing; the current queue/source set is newly provisioned, while one older channel already contains prior run material. In parallel, I’m pulling each subject’s scheduled and attended calendar events plus institute holidays so the window and due-date arithmetic is evidence-based.


Used Notion, Google Calendar, and Microsoft Teams integrations
The evidence resolves cleanly. The calendar shows a 17 July institute closure; the SOP clock therefore makes the four NIMBUS prompt reports due 22 July and the two CASTELLA prompt reports due 24 July. Classification is 6 promptly reportable, 4 continuing-review summary, and 2 not deviations. The NIMBUS visit-window cases form the SOP’s three-in-30-days pattern, so all three are prompt-reportable on the most recent awareness date’s clock. I’m writing the 12 register rows now, then I’ll verify the row and class counts before posting or drafting.


Used Notion integration
The Notion register is verified at 12 records: 6 prompt, 4 continuing-review, 2 not deviations, with all six prompt due dates present. I’m now making the authorized Teams post to the resolved site-deviations channel and creating—not sending—the PI-ready Gmail draft addressed only to the SOP-listed IRB mailbox.


Used Microsoft Teams and Gmail integrations
Completed and reconciled:

Notion register: 12 records — 6 promptly reportable, 4 continuing-review summary, 2 not deviations.
Prompt due 22 July: NMB-003, NMB-011, NMB-018, NMB-025.
Prompt due 24 July: CST-009, CST-022.
Teams post: posted with those six only, soonest due first.
Gmail draft: addressed solely to irb-submissions@vensara.example.org, verified with the DRAFT label, and not sent.
No queue entry lacked enough information to classify.

Notion’s custom query endpoint was quota-limited, but I verified all records through the database’s native view instead. That endpoint can be retried later or enabled through a Notion plan upgrade.

3:20 PM



O/P : 
Team Message : 
Promptly reportable deviations — week of 13 July 2026
Promptly reportable deviations from the week-of-13-July queue (6), reconciled to the Deviation Register and ordered soonest due first: • NMB-003 — NIMBUS-7 — due 22 July 2026 • NMB-011 — NIMBUS-7 — due 22 July 2026 • NMB-018 — NIMBUS-7 — due 22 July 2026 • NMB-025 — NIMBUS-7 — due 22 July 2026 • CST-009 — CASTELLA-2 — due 24 July 2026 • CST-022 — CASTELLA-2 — due 24 July 2026
Continuing-review-summary items are intentionally excluded. Register prompt-report count: 6.
 

Notion : 

CST-022	promptly reportable	July 24, 2026	CASTELLA-2 §6.2 defines the Week 8 chemistry/haematology panel as a safety assessment; the missed blood draw triggers SOP CRU-014 §1.1(c).	CASTELLA-2
NMB-025	promptly reportable	July 22, 2026	NIMBUS-7 §7 forbids open-label rescue; it was used while holding dose to eliminate an immediate hazard, so SOP CRU-014 §§1.1(f), 3 require prompt reporting.	NIMBUS-7
ORN-009	continuing-review summary		ORION-3 §5 requires main-site visits; the satellite-clinic visit breached that rule but retained PI oversight and all assessments, so SOP CRU-014 §1.2 applies.	ORION-3
NMB-011	promptly reportable	July 22, 2026	NIMBUS-7 §5 allows ±2 days; calendar shows 9 Jul scheduled/14 Jul attended (+5), and with NMB-003/NMB-018 it is a pattern under SOP CRU-014 §§1.1(g), 4.	NIMBUS-7
ORN-007	not a deviation		Calendar shows Visit 5 scheduled and attended 15 Jul within ORION-3 §5; the clerical date error was corrected without assessment-data change, so SOP CRU-014 §1.3 applies.	ORION-3
NMB-003	promptly reportable	July 22, 2026	NIMBUS-7 §5 allows ±2 days; calendar shows 9 Jul scheduled/13 Jul attended (+4), and with NMB-011/NMB-018 it is a pattern under SOP CRU-014 §§1.1(g), 4.	NIMBUS-7
NMB-018	promptly reportable	July 22, 2026	NIMBUS-7 §5 allows ±2 days; calendar shows 10 Jul scheduled/14 Jul attended (+4), and with NMB-003/NMB-011 it is a pattern under SOP CRU-014 §§1.1(g), 4.	NIMBUS-7
ORN-031	continuing-review summary		ORION-3 §6.2 identifies the study-drug diary as non-safety; it was returned complete with no safety or data-integrity impact, so SOP CRU-014 §1.2 applies.	ORION-3
NMB-030	continuing-review summary		NIMBUS-7 §6.3 identifies the concomitant-medication log as non-safety; the delayed update was accurate, so SOP CRU-014 §1.2 applies.	NIMBUS-7
ORN-014	not a deviation		ORION-3 §5 permits post-baseline visits ±7 days; calendar shows 8 Jul scheduled and 13 Jul attended (+5), so SOP CRU-014 §1.3 applies.	ORION-3
CST-016	continuing-review summary		CASTELLA-2 §6.4 identifies quality of life as non-safety; late home completion had no safety or data-integrity impact, so SOP CRU-014 §1.2 applies.	CASTELLA-2
CST-009	promptly reportable	July 24, 2026	CASTELLA-2 §4 requires screening eGFR ≥60 and bars dosing below that floor; eGFR 48 with enrolment/dosing triggers SOP CRU-014 §1.1(d).	CASTELLA-2

Gmail Draft : 
Dear IRB Review Team,

I am reporting six promptly reportable deviations identified at Vensara Institute of Medical Sciences, Clinical Research Unit, from the weekly deviation queue for 13–17 July 2026.

NMB-003 — NIMBUS-7 — due 22 July 2026
The Week 4 visit was scheduled for 9 July 2026 and attended on 13 July 2026, four days late and outside the NIMBUS-7 Protocol §5 ±2-day window. Together with NMB-011 and NMB-018, this is a same-type, same-study pattern within 30 days under SOP CRU-014 §§1.1(g) and 4. The pattern clock runs from the most recent PI awareness date, 14 July 2026.

NMB-011 — NIMBUS-7 — due 22 July 2026
The Week 4 visit was scheduled for 9 July 2026 and attended on 14 July 2026, five days late and outside the NIMBUS-7 Protocol §5 ±2-day window. This item forms part of the pattern described above. PI awareness: 14 July 2026.

NMB-018 — NIMBUS-7 — due 22 July 2026
The Week 4 visit was scheduled for 10 July 2026 and attended on 14 July 2026, four days late and outside the NIMBUS-7 Protocol §5 ±2-day window. This item forms part of the pattern described above. PI awareness: 14 July 2026.

NMB-025 — NIMBUS-7 — due 22 July 2026
At the Week 6 dosing visit on 14 July 2026, the subject developed acute respiratory distress. The scheduled dose was held and open-label rescue medication was administered to eliminate the immediate hazard; the subject stabilized and was observed. NIMBUS-7 Protocol §7 does not permit open-label rescue medication. This is promptly reportable under SOP CRU-014 §§1.1(f) and 3. PI awareness: 14 July 2026.

CST-009 — CASTELLA-2 — due 24 July 2026
The subject was enrolled and dosed after screening eGFR returned at 48 mL/min/1.73 m². CASTELLA-2 Protocol §4 requires eGFR of at least 60 mL/min/1.73 m² and prohibits enrolment or dosing below that floor. This is promptly reportable under SOP CRU-014 §1.1(d). PI awareness: 16 July 2026.

CST-022 — CASTELLA-2 — due 24 July 2026
The Week 8 blood draw was not collected. CASTELLA-2 Protocol §6.2 defines the Week 8 chemistry and haematology panel as a safety assessment and the basis for the subject’s continue-or-stop decision. This is promptly reportable under SOP CRU-014 §1.1©. PI awareness: 16 July 2026.

The due dates apply SOP CRU-014 §2’s five-business-day clock. The institute was closed on 17 July 2026, which is excluded as an institute holiday.

Please let me know if any additional documentation is required.

Sincerely,

Dr Anita Rao
Principal Investigator
Vensara Institute of Medical Sciences, Clinical Research Unit


My-obs :
- team message is a dance block, not apply any styling and also formating issue, not highlited any points and also use many em dashes throughout the message


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - B - gpt-5.6-fish with Extra High intelligence

Logs : 

Worked for 4m 6s
I’ll first verify access to the deviation queue, all three study protocols, the reporting SOP, the subject-visit calendar, the Notion register, and the Teams channel. Then I’ll reconcile every entry against its study-specific rules, update the register, post only the promptly reportable items to Teams, and prepare—but not send—the IRB email draft.

I’m using the Google Drive and Google Calendar skills to verify the source documents and actual visit dates, the Teams messaging skill for the authorized channel post, and the Gmail skill to create the IRB submission as an unsent draft.


Used Notion, Google Calendar, Google Drive, Gmail, and Microsoft Teams integrations, ran commands
I’ve located the queue, all three protocols, the SOP, the subject-visit calendars, and the Notion register. There are two Teams channels with the exact name “site-deviations,” so I’m checking their existing messages to identify the correct study-reporting channel before posting anything.


Used Notion, Google Drive, Microsoft Teams, and Google Calendar integrations
All required sources are accessible, and the correct Teams channel is the one already containing this study’s deviation updates. I’ve reconciled 12 queue entries: six are promptly reportable, four belong in continuing review, and two are not deviations; the 17 July institute closure changes the five-business-day deadlines.


Used Notion integration
The Notion register now contains all 12 verified records. Six items are due on either 22 or 24 July; the three late NIMBUS-7 visits share the pattern-based clock anchored to 14 July, and the 17 July institute closure has been excluded correctly.


Used Notion, Microsoft Teams, and Gmail integrations
Updated the Notion deviation register: 12 records, comprising 6 promptly reportable, 4 continuing-review, and 2 non-deviations.

Prompt reporting deadlines:

22 July 2026: NMB-003, NMB-011, NMB-018, NMB-025 — NIMBUS-7.
24 July 2026: CST-009, CST-022 — CASTELLA-2.
The 17 July institute closure was excluded from deadline calculations.

Posted the six reportable deviations to Teams.

Created the unsent Gmail draft, addressed to irb-submissions@vensara.example.org, for Dr. Rao’s review and submission.

5:40 PM


O/P : 
Team message : 
Promptly reportable deviations — queue for the week of 13 July 2026 - NMB-003 | NIMBUS-7 | due 22 July 2026 (IST) - NMB-011 | NIMBUS-7 | due 22 July 2026 (IST) - NMB-018 | NIMBUS-7 | due 22 July 2026 (IST) - NMB-025 | NIMBUS-7 | due 22 July 2026 (IST) - CST-009 | CASTELLA-2 | due 24 July 2026 (IST) - CST-022 | CASTELLA-2 | due 24 July 2026 (IST) Prompt-report count in Deviation Register: 6. Continuing-review items are excluded.

Notion : 
NMB-030	continuing-review summary		NIMBUS-7 Protocol §6.3 identifies the concomitant-medication log as a non-safety assessment; its six-day-late but accurate update is summarized under SOP CRU-014 §1.2.	NIMBUS-7
ORN-014	not a deviation		ORION-3 Protocol §5 permits post-baseline visits within ±7 days; the calendar confirms Visit 4 was scheduled 8 July and attended 13 July (+5 days), so SOP CRU-014 §1.3 applies.	ORION-3
CST-016	continuing-review summary		CASTELLA-2 Protocol §6.4 identifies the quality-of-life questionnaire as a non-safety assessment; late at-home completion without a prompt-report trigger falls under SOP CRU-014 §1.2.	CASTELLA-2
ORN-009	continuing-review summary		ORION-3 Protocol §5 requires visits at the main site; the satellite-clinic visit breached that location requirement without a safety, rights, welfare, or data-integrity trigger, so SOP CRU-014 §1.2 applies.	ORION-3
NMB-025	promptly reportable	July 22, 2026	NIMBUS-7 Protocol §7 prohibits open-label rescue medication; administering rescue and withholding the scheduled dose eliminated an immediate hazard and is reportable under SOP CRU-014 §§1.1(f) and 3.	NIMBUS-7
CST-022	promptly reportable	July 24, 2026	CASTELLA-2 Protocol §6.2 names the Week 8 chemistry/haematology blood panel as a safety assessment and continue-or-stop decision; the missed draw triggers SOP CRU-014 §1.1(c).	CASTELLA-2
NMB-018	promptly reportable	July 22, 2026	NIMBUS-7 Protocol §5 allows only ±2 days; Week 4 was 4 days late and, with NMB-003 and NMB-011, forms the three-deviation pattern reportable under SOP CRU-014 §§1.1(g) and 4.	NIMBUS-7
NMB-011	promptly reportable	July 22, 2026	NIMBUS-7 Protocol §5 allows only ±2 days; Week 4 was 5 days late and, with NMB-003 and NMB-018, forms the three-deviation pattern reportable under SOP CRU-014 §§1.1(g) and 4.	NIMBUS-7
ORN-007	not a deviation		The calendar confirms the ORION-3 Protocol §5 Visit 5 occurred as scheduled on 15 July; the same-day corrected source-date transcription error changed no assessment data, so SOP CRU-014 §1.3 applies.	ORION-3
NMB-003	promptly reportable	July 22, 2026	NIMBUS-7 Protocol §5 allows only ±2 days; Week 4 was 4 days late and, with NMB-011 and NMB-018, forms the three-deviation pattern reportable under SOP CRU-014 §§1.1(g) and 4.	NIMBUS-7
CST-009	promptly reportable	July 24, 2026	CASTELLA-2 Protocol §4 inclusion criterion 3 requires screening eGFR ≥60 mL/min/1.73m²; enrolling and dosing this subject at 48 triggers SOP CRU-014 §1.1(d).	CASTELLA-2
ORN-031	continuing-review summary		ORION-3 Protocol §6.2 identifies the study drug diary as a treatment-compliance record, not a safety assessment; its late but correctly completed return is summarized under SOP CRU-014 §1.2.	ORION-3

Gmail Draft : 
Dear IRB Review Team,

I am submitting prompt notification of six protocol deviations identified in the site’s deviation queue for the week of 13 July 2026, in accordance with Vensara Institute of Medical Sciences SOP CRU-014, version 6. Subject identifiers below are study codes only.

Due 22 July 2026 (IST)

NIMBUS-7: pattern of three out-of-window Week 4 visits

NIMBUS-7 Protocol §5 permits post-baseline visits only within ±2 days of the target date. The following three subjects exceeded that window within the same rolling 30-day period:

- NMB-003: scheduled 9 July 2026; attended 13 July 2026 (+4 days). PI awareness: 13 July 2026.
- NMB-011: scheduled 9 July 2026; attended 14 July 2026 (+5 days). PI awareness: 14 July 2026.
- NMB-018: scheduled 10 July 2026; attended 14 July 2026 (+4 days). PI awareness: 14 July 2026.

Under SOP CRU-014 §§1.1(g) and 4, all three deviations are promptly reportable as a pattern of noncompliance. The reporting clock for each pattern member begins from the most recent pattern PI-awareness date, 14 July 2026. Each is due 22 July 2026.

NIMBUS-7 NMB-025: immediate-hazard intervention at the Week 6 dosing visit

At the attended Week 6 dosing visit on 14 July 2026, the subject developed acute respiratory distress. I withheld the scheduled study dose and administered open-label rescue medication immediately; the subject stabilized and remained under observation. NIMBUS-7 Protocol §7 does not permit open-label rescue medication. SOP CRU-014 §§1.1(f) and 3 permit a deviation necessary to eliminate an immediate hazard without prior IRB approval but require prompt reporting. PI awareness: 14 July 2026. Due 22 July 2026.

Due 24 July 2026 (IST)

CASTELLA-2 CST-009: enrollment and dosing despite ineligible screening eGFR

The subject was enrolled and dosed despite a screening eGFR of 48 mL/min/1.73m². CASTELLA-2 Protocol §4, inclusion criterion 3, requires screening eGFR of at least 60 mL/min/1.73m² and prohibits enrollment or dosing below that threshold. The calendar confirms the baseline dosing visit occurred on 22 June 2026. This is promptly reportable under SOP CRU-014 §1.1(d). PI awareness: 16 July 2026. Due 24 July 2026.

CASTELLA-2 CST-022: missed required Week 8 safety blood panel

The subject attended the scheduled Week 8 visit on 15 July 2026, but the required blood draw was not collected. CASTELLA-2 Protocol §6.2 identifies the Week 8 chemistry/haematology panel as a safety assessment used to assess drug-related myelosuppression and hepatic injury and to decide whether treatment may continue. The omitted safety assessment is promptly reportable under SOP CRU-014 §1.1(c). PI awareness: 16 July 2026. Due 24 July 2026.

All deadlines were calculated under SOP CRU-014 §2 using five business days after the applicable PI-awareness date, excluding the institute closure on 17 July 2026 and the 18–19 July weekend.

Please let me know if the IRB requires additional supporting records or corrective-action information.

Dr Anita Rao
Principal Investigator
Vensara Institute of Medical Sciences
Clinical Research Unit

My-obs :
- team message is a dance block, not apply any styling and also formating issue, not highlited any points and also use many em dashes throughout the message


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - C - gpt-5.6-dog with Extra High intelligence

Logs : 

Worked for 5m 6s
I’ll use the Google Drive, Calendar, Notion, Teams, and Gmail workflows in that order: establish the protocol/SOP evidence and actual visit dates, classify the full queue, write and reconcile the register, then make the live Teams post and leave Dr Rao’s IRB submission as an unsent draft. I’ll stop if any required source or destination cannot be opened.


Used Notion, Google Drive, Microsoft Teams, and Google Calendar integrations, ran commands
The named Google sources and register are discoverable. Teams has two exact site-deviations channel matches in different teams, so I’m reading their channel context before selecting a destination; I won’t guess between them.


Used Notion, Google Drive, and Microsoft Teams integrations
The SOP establishes a five-business-day clock starting after PI awareness, excludes institute holidays, and makes a three-deviation same-type/same-study rolling-30-day pattern promptly reportable from the latest PI awareness date. I’m now grounding the scheduled versus attended dates and holiday exclusions in Calendar, and checking the register’s current rows before writing.


Used Notion and Google Calendar integrations
Calendar confirms ORN-014 was five days after target but inside ORION-3’s ±7-day window. The three NIMBUS-7 Week 4 attendances were four, five, and four days late against that study’s ±2-day window, forming the SOP pattern. The institute was closed on Friday 17 July, so the pattern/immediate-hazard items are due 22 July and the 16 July awareness items are due 24 July. I’m writing the 12-row register now.


Created 12 pages
The register write returned all 12 records: six prompt, four continuing-review summary, and two not deviations. I’m verifying those records, then I’ll make the requested live channel announcement of the six prompt items only and create the IRB-addressed Gmail draft without sending it.


Used Notion, Microsoft Teams, and Gmail integrations
Completed on the requested 20 July 2026 IST assessment basis.

Deviation Register – July 2026: 12 created and individually read back; 6 promptly reportable, 4 continuing-review summary, 2 not deviations.
Live Teams post in site-deviations: all six prompt items, soonest due first; continuing-review items excluded.
Unsent Gmail draft: addressed only to irb-submissions@vensara.example.org, covering all six prompt items. It has the DRAFT label and was not sent. Dr Anita Rao must review, sign, and submit it. The connected Gmail draft currently shows the connected mailbox as its From identity, so the PI should ensure submission uses the appropriate PI-authorized identity.
Entry	Subject	Study	Class	Due date	Decisive reason
1	ORN-014	ORION-3	Not a deviation	—	Calendar target 8 July, attended 13 July: +5, inside ORION-3 §5 ±7-day window; SOP §1.3.
2	CST-022	CASTELLA-2	Promptly reportable	24 July 2026	Missed Week 8 blood draw; Protocol §6.2 makes the chemistry/haematology panel a safety assessment and continue-or-stop check; SOP §1.1(c).
3	CST-009	CASTELLA-2	Promptly reportable	24 July 2026	Screening eGFR 48 was below Protocol §4’s ≥60 eligibility floor, yet the subject was enrolled and dosed; SOP §1.1(d).
4	NMB-003	NIMBUS-7	Promptly reportable	22 July 2026	Week 4 was +4 against Protocol §5’s ±2-day window; one of three same-type late-visit pattern members under SOP §§1.1(g), 4.
5	ORN-031	ORION-3	Continuing-review summary	—	Late return of a properly completed drug diary, a non-safety compliance record under Protocol §6.2; no §1.1 trigger.
6	NMB-011	NIMBUS-7	Promptly reportable	22 July 2026	Week 4 was +5 against ±2; pattern member under SOP §§1.1(g), 4.
7	NMB-025	NIMBUS-7	Promptly reportable	22 July 2026	Scheduled dose held and prohibited open-label rescue given to eliminate acute respiratory hazard; SOP §3 permits action without prior approval but §1.1(f) still requires prompt reporting.
8	NMB-018	NIMBUS-7	Promptly reportable	22 July 2026	Week 4 was +4 against ±2; third pattern member under SOP §§1.1(g), 4.
9	ORN-007	ORION-3	Not a deviation	—	Actual Visit 5 occurred on the 15 July target; the same-day corrected source date typo touched no assessment data; compliant conduct closed under SOP §1.3.
10	CST-016	CASTELLA-2	Continuing-review summary	—	Quality-of-life questionnaire was completed at home afterward; Protocol §6.4 identifies it as non-safety, with no stated SOP §1.1 trigger.
11	ORN-009	ORION-3	Continuing-review summary	—	Satellite-clinic visit breached Protocol §5’s main-site location requirement, but all assessments and PI oversight remained; no stated §1.1 trigger.
12	NMB-030	NIMBUS-7	Continuing-review summary	—	Correct concomitant-medication entries were logged six days late; Protocol §6.3 identifies the log as non-safety, with no stated §1.1 trigger.
The clock excludes the 17 July institute closure shown on Calendar and the 18–19 July weekend. For the NIMBUS-7 pattern, SOP §4 uses the most recent pattern PI awareness date, 14 July, for all three members; the five business days are 15, 16, 20, 21 and 22 July. NMB-025 has the same awareness date and due date. For the two CASTELLA-2 items, awareness was 16 July; the five business days are 20–24 July.

One connector limitation to note: Notion’s Query Data Source action hit the workspace usage limit, so I did not retry it. The register write and individual page fetch/readbacks succeeded. To run an aggregate database query later, retry after the limit resets or ask a workspace owner to upgrade the Notion plan.

4:33 PM


O/P : 
Team message : 
Promptly reportable deviations — week of 13 July 2026 
Promptly reportable deviations from the week-of-13-July queue (6), reconciled to the Deviation Register and ordered soonest due first: • NMB-003 — NIMBUS-7 — due 22 July 2026 • NMB-011 — NIMBUS-7 — due 22 July 2026 • NMB-018 — NIMBUS-7 — due 22 July 2026 • NMB-025 — NIMBUS-7 — due 22 July 2026 • CST-009 — CASTELLA-2 — due 24 July 2026 • CST-022 — CASTELLA-2 — due 24 July 2026 Continuing-review-summary items are intentionally excluded. Register prompt-report count: 6.
 

Notion : 
NMB-025	promptly reportable	July 22, 2026	NIMBUS-7 Protocol §7 requires the scheduled dose and does not permit open-label rescue; holding dose and giving rescue to eliminate acute respiratory hazard is permitted without prior approval but prompt under SOP CRU-014 §§1.1(f), 3.	NIMBUS-7
CST-016	continuing-review summary		CASTELLA-2 Protocol §6.4 names the quality-of-life questionnaire as a non-safety assessment; completion at home two days after Week 8 has no stated SOP CRU-014 §1.1 trigger and belongs in the §1.2 continuing-review summary.	CASTELLA-2
NMB-018	promptly reportable	July 22, 2026	NIMBUS-7 Protocol §5 allows ±2 days; Calendar shows Week 4 target 10 July and attendance 14 July (+4), one of three same-type late visits, promptly reportable as a pattern under SOP CRU-014 §§1.1(g), 4.	NIMBUS-7
CST-022	promptly reportable	July 24, 2026	CASTELLA-2 Protocol §6.2 identifies the Week 8 chemistry/haematology panel as a safety assessment and continue-or-stop check; its missed blood draw is prompt under SOP CRU-014 §1.1(c).	CASTELLA-2
CST-009	promptly reportable	July 24, 2026	CASTELLA-2 Protocol §4 inclusion criterion 3 requires screening eGFR ≥60 and prohibits enrolment/dosing below it; eGFR 48 with enrolment and dosing is prompt under SOP CRU-014 §1.1(d).	CASTELLA-2
ORN-009	continuing-review summary		ORION-3 Protocol §5 says visits take place at the main site; Visit 2 at the satellite clinic is a location deviation, but all required assessments and PI oversight were maintained and no SOP CRU-014 §1.1 trigger is stated, so §1.2 applies.	ORION-3
ORN-031	continuing-review summary		ORION-3 Protocol §6.2 classifies the study-drug diary as a non-safety treatment-compliance record; late return of the properly completed diary lacks an SOP CRU-014 §1.1 trigger and goes to §1.2 continuing review.	ORION-3
NMB-003	promptly reportable	July 22, 2026	NIMBUS-7 Protocol §5 allows ±2 days; Calendar shows Week 4 target 9 July and attendance 13 July (+4), one of three same-type late visits, promptly reportable as a pattern under SOP CRU-014 §§1.1(g), 4.	NIMBUS-7
NMB-030	continuing-review summary		NIMBUS-7 Protocol §6.3 identifies the concomitant-medication log as a non-safety assessment; its correct entries were updated six days late without a stated SOP CRU-014 §1.1 trigger, so §1.2 continuing review applies.	NIMBUS-7
NMB-011	promptly reportable	July 22, 2026	NIMBUS-7 Protocol §5 allows ±2 days; Calendar shows Week 4 target 9 July and attendance 14 July (+5), one of three same-type late visits, promptly reportable as a pattern under SOP CRU-014 §§1.1(g), 4.	NIMBUS-7
ORN-007	not a deviation		Calendar confirms ORION-3 Visit 5 occurred on its 15 July target within Protocol §5’s ±7-day window; the same-day corrected worksheet date typo changed no assessment data, so SOP CRU-014 §1.3 closes the compliant conduct.	ORION-3
ORN-014	not a deviation		ORION-3 Protocol §5 permits post-baseline visits ±7 days; Calendar shows Visit 4 target 8 July and attendance 13 July (+5), so SOP CRU-014 §1.3 applies.	ORION-3


Gmail Draft : 

To field intentionally left empty: a verified address for Delia Marchetti is required before this draft can go out. Do not send until Yusuf Adeyemi has reviewed and signed off the quarterly audit.Delia,The Q3 renewal audit identifies a change to the Larkfield Plus Annual cancellation-flow save offer before Q4 renewals begin on 1 October 2026. The current 40%-off-three-months offer takes the whole screen when cancellation starts, and the cancellation option is on the next screen.Ostmark: Rules Pack §5.4 requires a link or button that completes cancellation to be displayed continuously and proximately to the retention offer, on the same screen, for as long as the offer is displayed. Moving to a further screen before cancellation is available does not satisfy the provision.Selwick: Rules Pack §7.4 likewise requires the means of completing cancellation to remain continuously and proximately alongside the offer; the consumer must not have to move to a further screen or dismiss the offer to reach it.Please plan a save-offer presentation in which a control that completes cancellation remains visible continuously and proximately beside the offer on the same screen throughout its display. This is an audit finding for Yusuf’s review, not authorization to change the live flow. The last available pre-Q4 release is Monday 24 August 2026; anything missed moves to January. Nothing should be sent to Growth or implemented without Yusuf’s sign-off.The finding and reasons are in the Larkfield Renewal Findings Register and the renewal-audit Teams post.


My-obs :
- team message is a dance block, not apply any styling and also formating issue, not highlited any points and also use many em dashes throughout the message

