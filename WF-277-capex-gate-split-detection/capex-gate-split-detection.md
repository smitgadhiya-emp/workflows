# WF-184 — Two requests, one project: adjudicating the capital gate when the amount in the box is not the amount that counts

**Department/Area:** Management Analyst
**Tools (4):** Google Sheets (read the request register, the approved-project ledger and the replacement envelope) + Google Docs (read the delegation-of-authority policy and the business cases) → Notion database "Capex Gate Decisions" (write one row per request) → Microsoft Teams channel "capital-planning" (post the committee agenda, live). Reads in two apps, acts in two.
**Source:** EXP-169 (`../../../ideas/workflow-ideas-10.md`). WF build IDs are their own series, not EXP-aligned; full WF↔EXP map in `../../../context.md` §2a.
**Status:** Pending — written 2026-07-15, hardened 2026-07-17 for the reverted 1-3 aim (all three authored levers pulled, a Section 5.5 second-order dependency and a like-for-like mirror added), **not yet run**.

**What it is (one paragraph):** Every quarter a pile of capital requests turns up with business cases
attached, and somebody has to decide which approver each one actually needs before the committee
sits. The mechanical half is easy: read the amount, read the threshold, route it. The hard half is
that the amount in the box is often not the amount that counts, and the request is not always one
request. A lease written up as a purchase looks like a department-head item until you add the term
up. A payback that clears the hurdle can clear it on a saving another approved project already
booked, so the two cannot both be true. And a project that would need the board can be cut in half
and submitted twice, six weeks apart, with each half sitting comfortably under the threshold. That
last one is the reason the splitting clause is in the policy at all, and no per-request pass finds
it. Meanwhile the pressure runs the other way too: send everything up and the gate stops meaning
anything.

**Why Cube is not in this build.** EXP-169 named Cube as the anchor, holding the approved project
ledger and the booked benefits, which is what a claimed benefit gets checked against. Cube is a real
native connector (`../../../codex-plugins-reference.md`, Finance) but it is not in the always-on
core, so it needs an Install, and that is the smaller problem. The bigger one is that it is a system
of record. Making it carry this fixture means a real connected Cube account with seeded financial
data sitting in it and write access to that data, and we have neither. The booked benefit on AP-118
*is* the planted trap, and it is not ours to plant inside somebody else's financial model. Naming
Cube would make a run dead-end on tooling instead of judgment and pollute the score. That is not
hypothetical: `../../../context.md` records **WF-095 and WF-096** running partial on missing
connectors, where the acts went to a Sheet fallback and the value calls could not be seen, and batch
9 lost two anchors the same way, **Brex** out of WF-182 and **Midpage** out of WF-179, both for
exactly this reason. So the approved project ledger and the booked benefits are seeded as tabs on
the same Google Sheet as the register. Nothing else moves: the ledger, the benefit each approved
project booked and the place it lands all still exist, they just sit in a Sheet. What Cube would
have added is a real query surface over a real model, which would have tested whether a run can go
find a booked benefit nobody handed it, and that is a genuine loss. What it would have cost is the
run. **Flagged as a flaw in EXP-169's tool list.**

---

## Part A — Data-seeding prompt

Builds the fixed bench. Also lives as [`seed-prompt.md`](seed-prompt.md) with a clear-leftovers line
on top. **If you change a value in one, change it in the other so they do not drift.**

```
Set up a fixed test workspace for a capital appropriation screening task. Everything below is
invented for testing, no real company, no real people, no real money. Build it exactly as written;
the text and the numbers are the fixture.

1) Make a Google Sheet called "Ashgrove Capital Requests - July 2026 Committee" in my Google Drive,
with three tabs.

Tab one, named "Requests", with these headers in row 1: Request ID | Title | Sponsor | Department |
Amount submitted ($) | Structure | Submitted | Business case | Claimed payback (months). Then
exactly these eleven rows, in this order:

CAR-2027 | Halford stores mezzanine and tool crib fit-out | Arun Bhatt | Halford Operations | 38000 | Purchase | 2026-05-05 | Not attached | 21
CAR-2028 | Halford Line 3 vision inspection retrofit | Devika Raman | Halford Operations | 480000 | Purchase | 2026-06-02 | Attached | 30
CAR-2029 | Halford Line 2 labeller replacement | Meera Nair | Halford Operations | 135000 | Purchase | 2026-06-11 | Attached | 34
CAR-2030 | Torrance compressed-air compressor replacement | Sandra Okafor | Torrance Operations | 265000 | Purchase | 2026-06-16 | Attached | 29
CAR-2031 | Halford despatch automated packing cell | Meera Nair | Halford Operations | 420000 | Purchase | 2026-06-19 | Attached | 24
CAR-2032 | Torrance roof-mounted solar array | Sandra Okafor | Torrance Operations | 900000 | Purchase | 2026-06-23 | Attached | 34
CAR-2033 | Halford Line 1 safety interlock upgrade | Arun Bhatt | Halford Operations | 98000 | Purchase | 2026-06-26 | Attached | 47
CAR-2034 | Halford scrap aluminium recovery unit | Nikhil Roy | Group Engineering | 310000 | Purchase | 2026-06-30 | Attached | 27
CAR-2035 | Torrance new extrusion line | Sandra Okafor | Torrance Operations | 1850000 | Purchase | 2026-07-03 | Attached | 34
CAR-2036 | Halford intra-plant materials handling fleet | Arun Bhatt | Halford Operations | 95000 | Purchase | 2026-07-07 | Attached | 6
CAR-2037 | Halford Line 3 reject handling and conveyor rework | Devika Raman | Halford Operations | 520000 | Purchase | 2026-07-14 | Attached | 30

Tab two, named "Approved Projects", with these headers in row 1: Project ID | Title | Sponsor |
Location / asset | Approved | Approved by | Capital ($) | Benefit booked ($/yr) | What the benefit
covers. Then exactly these five rows:

AP-112 | Halford Line 5 guarding refresh | Vikram Shah | Halford Line 5 | 2025-11-14 | Department head | 74000 | 0 | Safety compliance, no financial benefit booked
AP-115 | Torrance boiler replacement | Rohit Desai | Torrance utilities | 2026-01-23 | Investment committee | 290000 | 96000 | Fuel saving on the Torrance steam load
AP-118 | Halford despatch conveyor and labelling automation | Rohit Desai | Halford despatch | 2026-04-17 | Investment committee | 610000 | 180000 | Removes four packing roles at Halford despatch, roles close September 2026
AP-121 | Halford Line 5 drive replacement | Priya Menon | Halford Line 5 | 2026-05-08 | Department head | 88000 | 31000 | Reduced unplanned downtime on Line 5
AP-124 | Torrance warehouse racking | Priya Menon | Torrance warehouse | 2026-06-02 | Investment committee | 155000 | 44000 | Storage density, ends third-party overflow storage

Tab three, named "Replacement Envelope". Put a two-column block at the top with headers Item | Value
in row 1 and these three rows under it:

Envelope approved by the board for FY2027 ($) | 2000000
Drawn against the envelope to 14 July 2026 ($) | 1240000
Headroom remaining ($) | 760000

Leave row 6 blank. Then in row 7 put the headers Asset on the FY2027 Asset Replacement Schedule |
Plant | Condition, and under them exactly these five rows:

Halford Line 2 labeller | Halford | End of life FY2027, manufacturer spares discontinued
Halford Line 4 case erector | Halford | End of life FY2027
Torrance forklift charger bank | Torrance | End of life FY2027
Torrance compressed-air compressors | Torrance | End of life FY2027, 2009 fixed-speed units
Halford Line 1 pallet wrapper | Halford | End of life FY2028

2) Make a Google Doc called "Ashgrove Delegation of Authority - Capital Requests" in my Google
Drive, with exactly this text:

"ASHGROVE INDUSTRIES - DELEGATION OF AUTHORITY, CAPITAL APPROPRIATION REQUESTS. Fictional, for
testing. Effective 1 April 2026, applies for FY2027. This policy is the authoritative rulebook for
this exercise: apply it as written and do not import approval practice from anywhere else.

SECTION 1. SCOPE, AND WHAT THE PLANNING GROUP DOES
Every capital appropriation request (CAR) raised against an Ashgrove plant, line or asset is
screened by the corporate planning group before it reaches an approver. The planning group works out
the approval tier each request needs, works out whether the request clears the gate, records the
call with its reason, and routes the request to whoever holds the authority. The planning group does
not approve, fund or reject anything, and it does not decide whether a project is a good idea. The
approver decides.

SECTION 2. APPROVAL TIERS
Total commitment up to and including $99,999: the sponsoring department head approves.
Total commitment from $100,000 up to and including $749,999: the investment committee approves.
Total commitment of $750,000 and above: the board approves.

Tiers are set by the total commitment of the request. Urgency, safety content, regulatory interest,
strategic importance and the sponsor's seniority do not change the tier, and a sponsor asking for a
higher forum does not change it either.

Department heads for FY2027:
Halford Operations - Sunil Kapadia
Torrance Operations - Gerald Whitlock
Group Engineering - Ravi Anand

SECTION 3. TOTAL COMMITMENT
Total commitment is what Ashgrove is on the hook for, not the figure the sponsor puts in the amount
box. For an outright purchase it is the purchase price. For a lease, a rental, a hire agreement, an
instalment plan or any other multi-year commitment, however the request is labelled and whatever the
sponsor has called it, total commitment is the sum of every payment across the full term plus any
end-of-term purchase or transfer option. A request presented as a purchase is tested on the
structure its business case actually describes.

SECTION 4. THE SINGLE PROJECT RULE
Two or more requests are treated as one project, and tested against the combined total commitment,
where both of these hold:
(a) they are submitted by the same sponsor within twelve months of each other, and
(b) they relate to the same asset, the same production line, or the same named programme.

Requests from one sponsor at the same plant are not one project merely because they share a plant.
They are one project when they share the asset, the line or the programme.

Where the single project rule applies, the combined total commitment sets the tier for every request
in the group, and the group goes to that approver as one item, not as separate items.

A project that has already been approved and sits on the approved project ledger is not reopened by
this rule.

SECTION 5. BUSINESS CASE AND THE PAYBACK HURDLE
5.1 A business case is required for any request whose total commitment is $100,000 or more. Below
$100,000 no business case is required and the planning group does not ask for one. A sponsor who
attaches one anyway below that figure has volunteered it: it does not change the tier, and the
planning group does not adjudicate it.
5.2 A business case must show the capital cost, the annual net benefit and the payback in months.
5.3 The payback hurdle is 36 months. Payback is the total commitment divided by the annual net
benefit, expressed in months. A case whose recomputed payback exceeds 36 months does not clear the
gate.
5.4 The payback on the register is the sponsor's claimed figure and is not relied on. The planning
group recomputes payback from the capital cost and the annual net benefit in the business case, and
the recomputed figure is the one that counts.
5.5 A business case supporting a total commitment of $750,000 or more must also carry an independent
cost estimate for the capital, prepared outside the sponsoring department. A case without one is
returned to the sponsor and is not adjudicated on merit. It comes back when the independent estimate
is attached.

SECTION 6. BENEFITS ALREADY BOOKED
6.1 A benefit an approved project has already booked to the FY2027 plan may not be claimed again by
a later request. The approved project ledger records what each approved project booked, what the
benefit covers and where it lands.
6.2 Where a claimed benefit duplicates a benefit already booked, that part of the claimed benefit is
struck from the case and the payback is recomputed on what is left. The two cannot both be true and
the earlier approval holds.

SECTION 7. THE ASSUMPTION CONTINGENCY RULE
Where a business case's annual net benefit depends wholly or mainly on an assumed change in a price,
a rate, an exchange rate or a volume, the case must carry a contingency plan naming what Ashgrove
does if the assumption does not hold. A case missing the contingency plan is returned to the sponsor
and is not adjudicated on merit. The planning group does not form a view on whether the assumption
is reasonable, and does not fail the case on its payback. The case comes back when the contingency
plan is attached.

SECTION 8. THE ASSET REPLACEMENT ENVELOPE
The board pre-approved an Asset Replacement Envelope of $2,000,000 for FY2027. It covers like-for-
like replacement of assets named on the FY2027 Asset Replacement Schedule. A request that is a
like-for-like replacement of an asset on that schedule, and that fits inside the envelope's
remaining headroom, fast-tracks: the sponsoring department head approves it, no full business case
is required, and it does not take investment committee or board time whatever its value.

Like-for-like means the same function and broadly the same specification. An upgrade, a capacity
increase, a change of function or a change of structure is not like-for-like. An asset that is not
named on the FY2027 Asset Replacement Schedule is not covered by the envelope, whatever condition it
is in. Anything the envelope does not cover is adjudicated under Sections 2 to 7 in the ordinary
way."

3) Make a second Google Doc called "Ashgrove Capital Requests - Business Cases (July 2026)" in my
Google Drive, with exactly this text:

"ASHGROVE INDUSTRIES - CAPITAL APPROPRIATION BUSINESS CASES, JULY 2026 COMMITTEE. Fictional, for
testing. One section per request. This Doc is the authoritative record of what each sponsor
submitted: treat the numbers and the text below as what is on file, and do not supply a case that is
not here.

--- CAR-2027 Halford stores mezzanine and tool crib fit-out
No business case attached. Sponsor Arun Bhatt notes: 'Mezzanine deck and a lockable tool crib over
the Halford stores dock, so the maintenance kits stop living on the floor. $38,000 all in.'

--- CAR-2028 Halford Line 3 vision inspection retrofit
Sponsor: Devika Raman. Capital cost: $480,000. Annual net benefit: $192,000. Claimed payback: 30
months.
Case: 'A camera and lighting station at the Line 3 discharge, reading label position and seal
integrity before the palletiser. Line 3 sends more product back from customers than the other four
lines put together. The $192,000 is the returns credit and the rework labour we stop paying, costed
on twelve months of Line 3 volume to 31 May 2026. Install over two shutdown weekends, no line
stoppage.'

--- CAR-2029 Halford Line 2 labeller replacement
Sponsor: Meera Nair. Capital cost: $135,000. Annual net benefit: $48,000. Claimed payback: 34
months.
Case: 'The Line 2 labeller is on the FY2027 Asset Replacement Schedule and it is at end of life. The
manufacturer stopped making the spares in 2024 and we are down to one scavenged head. This is a
like-for-like swap for the direct successor model: same function, same line speed, same footprint,
same operator interface. No capacity change, no new capability. The $48,000 is the labeller downtime
and the scavenged-spares premium we stop paying.'

--- CAR-2030 Torrance compressed-air compressor replacement
Sponsor: Sandra Okafor. Capital cost: $265,000. Annual net benefit: $110,000. Claimed payback: 29
months.
Case: 'Three fixed-speed compressors from 2009 come out. Two variable-speed units and a new ring
main go in, plus a leak survey and remediation across the Torrance site. Bigger duty, better
turndown, about a third off the compressed-air energy bill. The $110,000 is the metered energy
saving at the FY2026 tariff.'

--- CAR-2031 Halford despatch automated packing cell
Sponsor: Meera Nair. Capital cost: $420,000. Annual net benefit: $210,000. Claimed payback: 24
months.
Case: 'An automated packing cell on the Halford despatch floor: carton erect, pack, void fill and
seal in one pass. The $210,000 breaks down as $180,000 from taking out four packing roles at Halford
despatch, and $30,000 from lower film and carton waste. The four roles are the packing bench
headcount on the despatch floor. The $420,000 is Halewell Consulting's independent estimate for the
cell and the floor works.'

--- CAR-2032 Torrance roof-mounted solar array
Sponsor: Sandra Okafor. Capital cost: $900,000. Annual net benefit: $180,000. Claimed payback: 34
months.
Case: 'A 1.4 MW roof-mounted array across the Torrance production and warehouse roofs. The $180,000
is the grid import we stop buying, at the FY2026 tariff, on modelled generation. Roof survey is
done, the deck takes the load with no strengthening. Costing is an independent cost estimate from
Calderwood Renewables, priced in April.'

--- CAR-2033 Halford Line 1 safety interlock upgrade
Sponsor: Arun Bhatt. Capital cost: $98,000. Annual net benefit: $25,000. Claimed payback: 47 months.
Case: 'This is the highest open item on the Halford site risk register and it has been sitting there
two years. The plant safety regulator raised the Line 1 guarding interlocks at the last inspection
and asked what we were doing about it. If somebody gets hurt on Line 1, this is the item that gets
read out. I am asking for this to go to the board at the September meeting so it has visibility at
the top of the house, and I want it treated as the priority in the book. The $25,000 is the
unplanned stoppage we stop having once the interlocks stop nuisance-tripping. I have attached a full
case even though I am told it may not need one.'

--- CAR-2034 Halford scrap aluminium recovery unit
Sponsor: Nikhil Roy. Capital cost: $310,000. Annual net benefit: $140,000. Claimed payback: 27
months.
Case: 'A recovery and briquetting unit in the Halford metals yard, so our aluminium swarf goes out
as clean briquettes instead of mixed scrap. The whole of the $140,000 is the uplift from the assumed
18 per cent rise in the clean scrap aluminium resale price across FY2027, which is where the trade
forecasters have it. Briquette volume is the FY2026 swarf tonnage.'

--- CAR-2035 Torrance new extrusion line
Sponsor: Sandra Okafor. Capital cost: $1,850,000. Annual net benefit: $650,000. Claimed payback: 34
months.
Case: 'A fourth extrusion line in the Torrance extrusion hall. We are turning away profile work we
could take and buying in about $4m of profile a year. The $650,000 is the in-sourced margin on the
volume Torrance sales has already quoted and lost on lead time. The hall has the bay and the
substation takes the load. The $1,850,000 is Brantwood Projects' independent estimate for the line,
the bay works and the substation tie-in.'

--- CAR-2036 Halford intra-plant materials handling fleet
Sponsor: Arun Bhatt. Capital cost: $95,000. Annual net benefit: $190,000. Claimed payback: 6 months.
Case: 'Fourteen units, forklifts and tow tractors, across the Halford plant. The incumbent fleet is
eleven years old and the maintenance, the hire-in cover when units are down and the downtime run us
$190,000 a year, which is what the $190,000 is. The agreement runs five years at $95,000 a year,
with a $60,000 purchase option at the end of the term, and the fleet transfers to Ashgrove if we
take it. I have put $95,000 in the amount box as the capital cost, and attached this for
completeness even though I am told it sits under the department head limit.'

--- CAR-2037 Halford Line 3 reject handling and conveyor rework
Sponsor: Devika Raman. Capital cost: $520,000. Annual net benefit: $208,000. Claimed payback: 30
months.
Case: 'Reject handling and a conveyor rework on the Line 3 discharge end: a reject diverter, a
recirculation loop and about sixty metres of new conveyor. Line 3 rejects by hand into a cage today
and the line stops while it happens. The $208,000 is the Line 3 stoppage time we stop losing, costed
on twelve months of Line 3 volume to 31 May 2026. Install over three shutdown weekends.'"

4) In Notion, create an empty database called "Capex Gate Decisions" with these properties and no
rows: Request (title), Sponsor (text), Approval tier (select: department head / investment committee
/ board), Gate verdict (select: proceed / fast-track / return to sponsor / fail), Reason (text).
Leave it empty.

5) In Microsoft Teams, make sure a channel called "capital-planning" exists and has no agenda post
in it. Leave it empty.

When you are done, give me the links to the Google Sheet, both Google Docs, the Notion database and
the Teams channel, and confirm the Notion database has zero rows.
```

---

## Part B — Workflow prompt (the eval prompt, paste as-is)

This is **field 1 of Form 1**. Nothing here names a trap: the rules are in the policy, the numbers
are in the fixture, the answers are in the grading key, and the prompt only says what to produce.

```
Ahead of every investment committee sitting the capital request book lands on my desk to be screened, and the papers do not go out to the committee until that screen is done. The one coming up sits Thursday 23 July 2026 and it is Wednesday 15 July 2026 (IST) as I write this, so there is a clock on this.

The policy that governs all of it is the Google Doc "Ashgrove Delegation of Authority - Capital Requests". It sets the approval tiers, what a business case has to show, the payback hurdle, and how a request gets tested. Work every call from what the policy actually says, not from what a request says about itself. The cases behind the requests are in the Google Doc "Ashgrove Capital Requests - Business Cases (July 2026)". And do not take a sponsor's claimed payback on trust, recompute it from the numbers in their case.

The book itself is the Google Sheet "Ashgrove Capital Requests - July 2026 Committee" and it runs to three tabs. "Requests" is the register, a row per capital appropriation request, with its ID, title, sponsor, department, the amount as submitted, how the sponsor says it is structured, the submission date, whether a business case came with it, and the payback the sponsor claims. "Approved Projects" is the ledger of what has already been approved, with the capital each project took, the benefit each one booked and what that benefit covers. "Replacement Envelope" holds the FY2027 asset replacement envelope, what has been drawn against it, and the schedule of assets it covers.

Every request in the register needs two calls out of you. One is the approval tier it needs under the policy, which is department head, investment committee or board. The other is the gate verdict, and there are four of those. Proceed is when it clears the gate and goes to the tier you named. Fast-track is when the policy lets it skip the ordinary route, and there you say what it goes to instead. Return to sponsor is when something the policy requires by name is missing so it does not get adjudicated on merit, and say what is missing. Fail means it was adjudicated and does not clear, and say what it missed.

The calls go into the Notion database "Capex Gate Decisions", one row per request. Each row needs at least the request ID and title, the sponsor, the approval tier, the gate verdict, and a one-line reason that names the part of the policy you leaned on plus any figure you recomputed. Past those, set the row up whatever way reads back best.

The agenda for the committee goes to the Microsoft Teams channel "capital-planning". Post it live, not a draft. One line per item that needs investment committee or board time, each with the value the approver is being asked to sign off, which of the two it goes to, and the one-line reason. Anything you have settled without the committee stays off the agenda, so give me a count of those at the end of the post instead.

You are not approving anything here, and not funding or rejecting anything either. The planning group records the call and routes it, the approver decides. So no approval gets written anywhere, and the register stays exactly as you found it.

If either Google Doc, the Google Sheet, the Notion database or the Teams channel will not open for you, stop there and name it for me. Do not put your own assumption in place of what the policy says or what a case contains, and if a request is missing something you need before you can call it, mark that row and name the gap.

The screen is off my desk when every request in the register has its Notion row with a tier, a verdict and a reason on it, the Teams agenda carries exactly the items that need committee or board time and its counts match those rows, and the register is sitting as it was.
```

---

## Grading key (keep out of Codex)

Eleven requests. **Eight are the test, three are there so the run has somewhere to be right.**
Score per request. **CAR-2028 and CAR-2037 count double and split their two points**, one for the
board tier and one for the return, because the tier is the cheap half now. **CAR-2033 counts double**
as the restraint case, and **CAR-2029 and CAR-2030 count double** as the two halves of the
like-for-like mirror. **16 points available.**

**Rebuilt 2026-07-17, on WF-180's evidence rather than its own.** All three authored levers pulled,
and the marquee re-cut: WF-180's run beat its key on multi-item pattern detection, so a split the run
finds is no longer worth what this key used to pay for it. Finding it now earns the tier and nothing
else. Section 5.5 is what it buys, and it is a rule the pair only meets once the split has already
been resolved.

| # | Request | Tier | Verdict | Why | Weight |
|---|---|---|---|---|---|
| 1 | CAR-2027 stores fit-out | department head | proceed | $38,000, under $100,000. No case required and none attached. A free point, and a quiet restraint check: a run that demands a business case here is already over-reaching. | 1 |
| 2 | **CAR-2028 Line 3 vision** | **board** | **return to sponsor, as one item with CAR-2037** | $480,000 on its own is committee, and on its own it is a clean, approvable request at 30 months. Same sponsor (Devika Raman), same production line (Halford Line 3), 42 days apart, so Section 4 folds it into CAR-2037 at $1,000,000 and the board takes it. **That is only the first half of the call, and it is now the cheap half.** Board tier pulls in 5.5, and neither case carries an independent cost estimate, because neither sponsor ever wrote a board paper. So the project returns unadjudicated and the 30 months never gets tested. **Score the halves separately: 1 for the board tier, 1 for the return.** | **2** |
| 3 | **CAR-2029 Line 2 labeller** | **department head** | **fast-track** | $135,000 would be committee. The labeller is named on the FY2027 Asset Replacement Schedule, the case is like-for-like on its face (same function, same line speed, same footprint, no capacity change, no new capability), and $135,000 fits the $760,000 headroom. Section 8 fast-tracks it to Sunil Kapadia with no full case. **Mirror half.** | **2** |
| 4 | **CAR-2030 compressed-air** | **investment committee** | **proceed** | The other half of the mirror, and on the register it presents just like CAR-2029: titled a replacement, its asset named on the same FY2027 Schedule as end of life, well inside the headroom. It is not like-for-like. Three fixed-speed compressors out for two variable-speed, plus a new ring main and a site-wide leak survey, is an upgrade and a capacity increase, which Section 8's last paragraph excludes by name. So the envelope does not reach it, Sections 2 to 7 do, $265,000 is committee and 29 months clears. **A run that gives CAR-2029 and CAR-2030 the same verdict, either way, never read that paragraph.** | **2** |
| 5 | CAR-2031 packing cell | investment committee | **fail** | Payback recomputes to exactly the claimed 24 months and clears, which is the trap: the arithmetic is honest. $180,000 of the $210,000 is AP-118's booked saving, same four packing roles, same despatch floor. Strike it under Section 6, $30,000 is left, payback is 168 months. Only the ledger catches this. Its case now carries an independent estimate too, which does not save it: an estimate is not a proceed, so a run keying on "estimate present" mis-scores here. | 1 |
| 6 | CAR-2032 solar array | board | **fail** | Board tier, and its case carries Calderwood's independent estimate, so 5.5 is met and it is adjudicated on merit, unlike the split pair. Claims 34 months; $900,000 / $180,000 is 60 months. Section 5.4 recompute governs and 60 exceeds the 36 hurdle. **The 5.5 mirror of the split pair: board tier with an estimate fails on payback, board tier without one returns unadjudicated.** | 1 |
| 7 | **CAR-2033 safety interlock** | **department head** | **proceed** | **The restraint trap, now double-signalled.** $98,000, under $100,000, so department head and no business case required. Two visible reasons to act, both wrong. The case is written hot (top of the risk register two years, the regulator raised it, the sponsor asks for the September board), and Section 2 says none of that moves the tier. And the volunteered case recomputes to 47 months, over the 36 hurdle, so a run that recomputes everything fails it, but 5.1 says a case volunteered under $100,000 is not adjudicated, so the payback is never tested. Route it to Sunil Kapadia and stop. | **2** |
| 8 | CAR-2034 aluminium recovery | investment committee | **return to sponsor** | Payback is 27 months and clears, so on merit it passes, which is the trap. The whole $140,000 rests on an assumed 18% price rise and no contingency plan is attached, so Section 7 returns it unadjudicated. Failing it on merit is wrong, and so is proceeding it. **Gettable.** | 1 |
| 9 | CAR-2035 extrusion line | board | proceed | $1,850,000, payback 34 months, and Brantwood's independent estimate is attached so 5.5 is met. Clean board proceed. It is here so "board" is not a unique flag pointing at the split pair, and so a legitimate board paper that does carry its estimate sits next to the pair that does not. Free point. | 1 |
| 10 | CAR-2036 handling fleet | **investment committee** | proceed | The register says $95,000 and "Purchase", which reads as a department head item, and the sponsor says so out loud. The case describes five years at $95,000 plus a $60,000 end-of-term option, so Section 3 makes total commitment $535,000 and the committee takes it. Payback on $535,000 is 34 months and clears. Under $750,000, so 5.5 does not reach it, and not on the Schedule, so no fast-track. | 1 |
| 11 | **CAR-2037 Line 3 reject handling** | **board** | **return to sponsor, as one item with CAR-2028** | The other half of the split, clean and approvable alone at $520,000 and 30 months. Folded in, the $1,000,000 project is board tier and 5.5 bites: no independent estimate on either half, so it returns unadjudicated. **Score the halves separately: 1 for the board tier, 1 for the return.** | **2** |

### Headline checks (what separates a good run from a bad one)

1. **CAR-2028 and CAR-2037 both sit at board as one $1,000,000 project, and both return to sponsor.**
   Two calls, not one. Board tier is the cheap half now, a strong model finds the split. The grade is
   in the second half: once it is board tier, Section 5.5 requires an independent cost estimate,
   neither half carries one, so the project returns unadjudicated. A run that calls them "board,
   proceed" found the pattern and stopped one step short. Board on one and committee on the other is
   still a confused run and scores nothing.
2. **CAR-2033 goes to Sunil Kapadia and nothing else happens to it.** $98,000, department head,
   proceed. Not on the Teams agenda, no business case demanded, no board line, and not failed on its
   47-month payback: under $100,000 the volunteered case is not adjudicated, so the payback is never
   tested. A run that fails it on 47 months over-reached exactly as badly as one that escalates it on
   the narrative.
3. **CAR-2029 and CAR-2030 take opposite verdicts.** Both are titled a replacement, both have their
   asset named on the FY2027 Asset Replacement Schedule, both sit inside the headroom. CAR-2029 is
   like-for-like and fast-tracks; CAR-2030 is an upgrade and a capacity increase, which Section 8's
   last paragraph excludes, so it drops to the ordinary route at investment committee. A run that
   gives both the same answer never read that paragraph or never read CAR-2030's case.
4. **Sandra Okafor's three Torrance requests are not combined.** Same sponsor, same plant, all inside
   twelve months, but three different assets, and Section 4 wants the asset, the line or the
   programme. A run that folds them into one item over-applied the rule, the counterweight that stops
   "same sponsor" being a free heuristic.
5. **CAR-2031 fails at 168 months**, with the reason naming AP-118. Not on the claimed 24 months,
   which is arithmetically correct.
6. **CAR-2036's tier is investment committee on $535,000**, not department head on $95,000.
7. **CAR-2034 returns, it does not fail.** Section 7 by name.

### Expected artifacts

- **Notion "Capex Gate Decisions":** exactly 11 rows, one per request, each with a tier, a verdict
  and a reason. Tiers split **3 department head / 4 investment committee / 4 board**. Verdicts split
  **5 proceed / 1 fast-track / 2 fail / 3 return to sponsor**.
- **Teams "capital-planning":** one post, the agenda, **3 items covering 3 requests**: $265,000 to
  the committee (CAR-2030), $1,850,000 to the board (CAR-2035), $535,000 to the committee (CAR-2036).
  Plus a tail count of **8** settled without the committee. The split pair is not here: it returns to
  sponsor, so it is off the agenda and in the tail. **A run that posts a $1,000,000 board line found
  the split but missed 5.5 (4 items). A run that posts CAR-2028 and CAR-2037 as two committee lines
  missed the split entirely (5 items).**
- **The Google Sheet unchanged.** Nothing approved, funded or rejected.

### What should NOT appear

- CAR-2033 anywhere on the Teams agenda, a business case demanded for CAR-2033 or CAR-2027, or
  CAR-2033 failed on its 47-month payback.
- CAR-2028 or CAR-2037 marked proceed rather than return, or the $1,000,000 project on the agenda.
- CAR-2029 and CAR-2030 given the same verdict.
- Sandra Okafor's Torrance requests folded into one item.
- CAR-2034 marked fail, or CAR-2031 marked proceed on its 24 months.
- Any edit to the register, any approval or funding written anywhere, any new status column.
- A figure that is not derivable from the seeded numbers. The policy and the cases are
  authoritative by construction, so anything asserted beyond them is invented.

### Expected outcome score

**2 of 7** (aim 1-3, reverted 2026-07-17 from the 3-4 that was landing on 5). The mechanical tier
routing, the recompute, the lease read, the AP-118 double-count, the Section 7 return and the split
tier should all land, because a strong model is now good at exactly those, and it earns the cheap
half of the split. What it should miss are the calls the levers cannot make easy: the second half of
the split (board tier newly triggers 5.5, neither half carries the estimate, so the pair returns and
does not proceed), the restraint case now that its own payback busts the hurdle it is never tested
on, and at least one side of the CAR-2029 vs CAR-2030 mirror. A 3 is plausible if it splits the
mirror right; a 4 would mean it also caught 5.5, which would be a genuinely strong run and a signal
to harden further.

**All three authored levers are already spent in this build.** The register's "Plant / asset" column
is gone, so the Line 3 link now lives only in the two titles and the two business cases. Section 4's
"tested across the whole book" line is gone. CAR-2033 is at $98,000. **If a run still lands 5+**, the
slack left is harder: put a second same-line pair on the book so the split is not the only one and
"find one split" stops being enough; give CAR-2035 an assumed-price benefit so board-tier proceed is
not a free contrast to the returns; or drop Section 8's "an upgrade, a capacity increase" sentence so
the CAR-2029 vs CAR-2030 mirror has to be reasoned from the cases rather than matched to a clause.

**Person difficulty: 7.** Eleven requests, each needing a policy read, a recompute and a ledger
check, under a committee clock, where recognising that the request in front of you is not the unit
the policy tests only starts the call: once it is the board's, a rule applies that did not apply
before, and the same schedule entry fast-tracks one request and not its twin.

---

## How to check the result (open the apps, do not trust the summary)

1. **Notion → "Capex Gate Decisions".** Count the rows: 11, no more. Read Approval tier and Gate
   verdict against the table above. The tiers should come out 3 / 4 / 4 and the verdicts 5 / 1 / 2 /
   3. A count that is off tells you where to look before you read a single reason.
2. **Notion, CAR-2028 and CAR-2037.** Both have to say **board**, and both have to say **return to
   sponsor**, with at least one reason naming the other request, the $1,000,000, and the missing
   independent cost estimate under Section 5.5. Board plus proceed is the pattern found and the second
   step missed. This is the run's whole grade in two cells.
3. **Notion, CAR-2033's row.** Tier department head, verdict proceed, $98,000, and the reason turns on
   the amount setting the tier. Two ways the trap eats the run: a reason like "safety-critical,
   escalated for visibility", or a verdict of fail on the 47-month payback. Under $100,000 the
   volunteered case is not adjudicated, so failing it on payback is as wrong as escalating it.
4. **Notion, CAR-2029 and CAR-2030 side by side.** CAR-2029 department head, fast-track. CAR-2030
   investment committee, proceed. Same verdict on both is the mirror collapsing: CAR-2030 is on the
   Schedule too but it is an upgrade, so Section 8 does not fast-track it. If CAR-2030 reads
   department head or fast-track, the run matched the Schedule and skipped the upgrade carve-out.
5. **Notion, CAR-2031's row.** Verdict fail, and the reason must name **AP-118** and the recomputed
   **168 months**. "Payback too long" without the ledger is a guess that landed, not a pass. The
   independent estimate in its case does not make it a proceed.
6. **Notion, CAR-2032's row.** Verdict fail on the recomputed **60 months**, not return. It carries
   an independent estimate, so 5.5 is met and it is adjudicated, which is what separates it from the
   split pair. A return here means the run read 5.5 but not the estimate.
7. **Notion, CAR-2034's row.** Verdict **return to sponsor**, not fail, with the missing contingency
   plan named. If the reason says the price assumption is unrealistic, the run adjudicated the exact
   thing Section 7 told it not to.
8. **Notion, CAR-2036's row.** Tier investment committee, and the reason has to carry **$535,000**.
   If the row says $95,000 or department head, the lease read as a purchase.
9. **Teams → "capital-planning".** Exactly one post. **Count the agenda items: 3, covering 3
   requests** (CAR-2030, CAR-2035, CAR-2036). Four items with a $1,000,000 board line means the split
   was found but 5.5 missed. Five items means CAR-2028 and CAR-2037 are still separate and the split
   failed. **If CAR-2033 is on it, the restraint trap failed.**
10. **Sandra Okafor's three.** CAR-2030, CAR-2032 and CAR-2035 have to be three separate calls. One
    combined Torrance item means the run over-applied the single project rule.
11. **Google Sheet → "Requests".** Same eleven rows as seeded, nothing edited, no status column bolted
    on, no approvals written.
12. **Cross-check the counts.** The agenda's tail count (8 settled without the committee) and the
    Notion rows have to agree. They are generated separately and a mismatch is a real defect.

## Re-run pack

- [`cleanup-prompt.md`](cleanup-prompt.md) — run **first**, before every re-seed and before each model.
- [`seed-prompt.md`](seed-prompt.md) — run **second**, rebuilds the bench.
- Then paste **Part B** above into Codex 5.5 on Extra High, as-is, no framing.

---

## Part C — Form 1 data

**Not filled. Fields 13 and 14 record a run that has not happened yet.** After the run, use the
`form-1-filler` skill with the real session ID, runtime and observed behaviour. What is known now:

| Field | Value |
|---|---|
| **Specification level** | Moderately specified. Names the Google Sheet and its three tabs, both Google Docs, the Notion database, the Teams channel, the three tiers, the four verdicts, the recompute rule, the nothing-gets-approved rule and the completion criteria. Which request lands where, how the agenda reads and orders, and the whole Notion row beyond the five required fields, are left to the model. |
| **Operating system** | macOS |
| **Applications required** | Google Sheets, Google Docs, Notion, Microsoft Teams |
| **Occupation category** | Feather's dropdown is O*NET-style and we have not captured it in full. Pick the nearest to a corporate planning analyst at the form (`Management Analysts` if present), and keep the real role in the line below. Not the registry's Department value. |
| **Occupation & workplace** | Management analyst in a manufacturer's corporate planning group, screening the capital request book before the investment committee sits. |
| **Time to complete manually** | 180 min *(set your own honest figure)* |
| **Times per month** | 1, the book is quarterly *(set your own honest figure)* |
| **Workflow difficulty (1-7)** | 7 *(see the grading key; set your own honest figure)* |
| **Rate the experience and outcome (1-7)** | fill after running. Expected 2. |
| **Notes on Codex's performance** | fill after running: session ID, runtime, per-app connector behaviour, exact error text. |
| **Confidentiality** | Everything is invented. Tick after confirming. |

### Local professional environment & resources (field 3)

I am a management analyst in a manufacturer's corporate planning group, screening the capital request book before the investment committee sits. The request register, the approved-project ledger and the replacement envelope are tabs on Google Sheets. The delegation-of-authority policy, with its dollar thresholds and its splitting clause, and the business cases themselves are Google Docs. I keep the gate decisions in a Notion database called "Capex Gate Decisions" and the committee agenda goes to the "capital-planning" channel in Microsoft Teams. The agent needs to read the policy and the register, recompute the payback from the submitted numbers rather than the claimed figure, check each claimed benefit against the approved-project ledger, write one row per request into Notion and post the agenda to Teams. Nothing gets approved or funded by the agent.

### Additional context (why / when / larger workflow) (field 6)

This runs quarterly, across the whole request book. Somebody has to decide which approver each request actually needs before the committee sits, and the mechanical half, read the amount and match the threshold, is easy. It cannot be a script because the amount in the box is often not the amount that counts, and the request is not always one request: a lease written up as a purchase tests on total commitment, a payback that clears only because it double-counts a benefit another approved project already booked is not a payback, and two requests six weeks apart on the same production line can be one project split to sit under the board threshold. Send everything up and the gate is meaningless. Wave a split request through and the policy has no credibility left. It feeds the investment committee and the board agenda.

### Interim checkpoints / required outputs (field 7)

**One checkpoint per step box in the Feather UI, never bundled** (reviewer, 2026-07-15). There are **12** here, so that is 12 step boxes, not one box holding a list. The test for splitting two apart is whether a run could land one and miss the other, and every line below can fail on its own. These are required outputs and the calls that earn partial credit, not a recipe: none of them says how to get there.

- Recomputes payback from the submitted numbers rather than the claimed figure, and checks each claimed benefit against the approved-project ledger.
- Notion "Capex Gate Decisions" carries one row per request, eleven of them, each with a tier, a verdict and a reason.
- CAR-2028 and CAR-2037 both sit at board, named as one $1,000,000 project under the splitting clause.
- That $1,000,000 project returns to sponsor because neither half carries the independent cost estimate a board case needs under Section 5.5, so it is not board-and-proceed.
- CAR-2033 goes to Sunil Kapadia and nothing else happens to it: no agenda line, no business case demanded, and not failed on its recomputed 47-month payback.
- CAR-2029 fast-tracks and CAR-2030 does not, the same Asset Replacement Schedule entry splitting on Section 8's upgrade carve-out.
- Sandra Okafor's three Torrance requests are not combined, Section 4 turning on the asset rather than the sponsor.
- CAR-2031 fails at 168 months, the reason naming AP-118's already-booked benefit.
- CAR-2036's tier is investment committee on $535,000 of total commitment, not department head on $95,000.
- CAR-2034 returns to sponsor on Section 7 by name, rather than failing on merit.
- Teams "capital-planning" agenda carries three items covering three requests, plus the tail count of eight settled without the committee.
- The Google Sheet is unchanged and nothing is approved, funded or rejected.

> **Before submitting:** Part B is a draft written with AI assistance. The playbook bars AI-written
> prompts, context, notes and ratings, and reviewers run an AI-written check. Read it aloud, rewrite
> it in your own voice, and run it yourself. The Form 1 run evidence has to be your run.
