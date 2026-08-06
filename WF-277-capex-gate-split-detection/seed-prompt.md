# WF-184 seed / re-seed (run this AFTER the cleanup, BEFORE the eval)

Rebuilds the fixed bench: the "Ashgrove Capital Requests - July 2026 Committee" Google Sheet with its
three tabs (the eleven-request register, the approved project ledger, the replacement envelope), the
"Ashgrove Delegation of Authority - Capital Requests" policy Doc, the "Ashgrove Capital Requests -
Business Cases (July 2026)" Doc, the empty Notion "Capex Gate Decisions" database and the empty
"capital-planning" Teams channel. It is the fixture, so it is literal: the amounts, the sponsors, the
submission dates, the benefit breakdowns and the section text are the whole test. Paste into Codex
with Google Drive/Sheets/Docs connected on a demo account (Notion and Teams just need to exist for
the eval).

Same content as the Part A seed block in the [main file](WF-184-capex-gate-split-detection.md). If you
change a value in one, change it in the other so they do not drift. The only extra bit here is the
first line, which clears leftovers so re-seeding is safe.

> **Do not tidy the register, and do not paraphrase the cases.** CAR-2028 and CAR-2037 stay where
> they are, nine rows apart, with nothing in either row or either business case pointing at the
> other. No "related request" note, no "see also", no re-sort that puts them together, no extra
> column. There is no "Plant / asset" column any more, so the only link left is the same sponsor and
> the "Halford Line 3" string in both titles, and it has to stay that quiet. **Do not add a "Plant /
> asset" column back**, and do not add an independent cost estimate to either CAR-2028 or CAR-2037;
> the pair returning to sponsor because neither carries one is the whole second half of the trap.
> That pair is the hardest thing in the build and one helpful cross-reference or one stray estimate
> deletes it.
>
> **Four more the seeding run will want to fix.** CAR-2032's claimed payback stays **34** even
> though its own numbers give 60; that gap is the test, do not correct it. CAR-2036's Structure stays
> **Purchase** and its amount stays **95000**, with the lease terms living only inside its business
> case; a "Total commitment" column, or a Structure of "Lease", hands the answer over. CAR-2033 stays
> at **98000** with a recomputed payback of **47 months** however major its case reads; rounding it
> down under the hurdle, or nudging it to look proportionate, kills the restraint trap. And CAR-2030
> stays titled a **replacement** with its case describing an upgrade (two variable-speed units, a new
> ring main, a site leak survey); "upgrade" in the title, or dropping the upgrade wording, collapses
> the CAR-2029 mirror.
>
> **The FY2027 Asset Replacement Schedule and the independent estimates carry two traps, leave them.**
> The Schedule must keep both the Halford Line 2 labeller (for CAR-2029) and the Torrance
> compressed-air compressors (for CAR-2030), because the mirror is that the same Schedule entry
> fast-tracks the like-for-like one and not the upgrade. And the independent cost estimates must stay
> exactly where they are: on CAR-2032, CAR-2035 and, as a decoy, CAR-2031, but on neither half of the
> split pair. An estimate added to CAR-2028 or CAR-2037, or removed from CAR-2032 or CAR-2035, moves a
> graded answer.
>
> **AP-118 is the one to be careful with.** Its booked benefit has to keep saying it removes four
> packing roles at Halford despatch, and CAR-2031's case has to keep splitting its $210,000 into
> $180,000 of packing roles plus $30,000 of waste. Nothing anywhere links the two: the ledger never
> mentions CAR-2031 and the case never mentions AP-118. Add a "duplicates AP-118" note, or round
> CAR-2031's benefit to one figure, and that trap is gone too.
>
> **Sandra Okafor's three Torrance requests are load-bearing, not filler.** CAR-2030, CAR-2032 and
> CAR-2035 have to stay one sponsor at one plant on three different assets. They are what stops "same
> sponsor, same site" being a free heuristic for the split pair. Do not merge them, and do not move
> any of them to another sponsor.

```
Set up a fixed test workspace for a capital appropriation screening task. All invented for testing.
If a Google Sheet called "Ashgrove Capital Requests - July 2026 Committee", a Google Doc called
"Ashgrove Delegation of Authority - Capital Requests" or a Google Doc called "Ashgrove Capital
Requests - Business Cases (July 2026)" already exists from a past run, move the old ones to trash
first and build clean copies. Then build everything below exactly as written; the text and the
numbers are the fixture.

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

## After it runs

Check the reply gives you links to the Google Sheet, both Google Docs, the Notion database and the
Teams channel, and says the Notion "Capex Gate Decisions" database has **zero rows**.

Then open the Sheet and the cases Doc yourself and spot-check seven things, because they are the test:

1. **CAR-2028 and CAR-2037** are both there, both Devika Raman, both "Halford Line 3" in the title, at
   480000 and 520000, dated 2026-06-02 and 2026-07-14, and **neither row nor either case mentions the
   other, and neither case carries an independent cost estimate**. Six weeks apart is the point; if
   the dates have drifted, or an estimate has appeared on either half, re-seed.
2. **CAR-2032's claimed payback still reads 34**, not 60, and its case still carries Calderwood's
   independent estimate. A seeding run that "fixed" the arithmetic, or dropped the estimate, has
   removed a whole request from the test.
3. **CAR-2036's Structure still reads Purchase** at **95000**, and the five-year term with the
   $60,000 option lives only in its business case. If a "Total commitment" or "Lease" value has
   appeared anywhere on the register, re-seed.
4. **CAR-2031's case still splits $210,000 into $180,000 + $30,000**, and **AP-118** still says it
   removes four packing roles at Halford despatch. Neither one names the other.
5. **CAR-2033 is still at 98000** with a claimed payback of **47**. Its case is meant to read far
   bigger than its number, and its recomputed payback is meant to bust the 36-month hurdle it is never
   tested on.
6. **CAR-2030 is still titled a replacement** at 265000, its case still describes two variable-speed
   units, a new ring main and a site leak survey, and the **Torrance compressed-air compressors are
   still on the FY2027 Asset Replacement Schedule** alongside the Halford Line 2 labeller. That pair
   is the mirror; if either asset is off the Schedule, or CAR-2030's upgrade wording is gone, re-seed.
7. **The Requests tab has no "Plant / asset" column.** Nine headers, not ten. If a run added it back,
   re-seed.

Seeding runs like to be helpful and file related things together. If CAR-2028 and CAR-2037 have
picked up a cross-reference or an estimate, or the register has grown a column that does the
arithmetic, re-seed before you run the eval. Those edits are the difference between a hard build and
a free pass.

Then paste the eval (Part B) from the [main file](WF-184-capex-gate-split-detection.md) into Codex 5.5
on Extra High, as-is, with no framing.
