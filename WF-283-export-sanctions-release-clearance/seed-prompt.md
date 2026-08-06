# WF-189 seed / re-seed (run this AFTER the cleanup, BEFORE the eval)

Rebuilds the fixed bench: the "Halgrave Release Clearance - Q3 2026 Cycle" Google Sheet with its
8-row "Release Manifest", 10-row "Customers", 21-row "Ownership" and 6-row "Repo Grants" tabs, the
four rulebook Google Docs (the control policy, the restricted party list and ownership rules, the
repo access rules, the code review notes), the eight GitHub repositories with their exact visibility,
the empty Notion "Halgrave Clearance Register" database and the empty "release-clearance" Teams
channel. It is the fixture, so it is literal: the ownership percentages, the registration numbers,
the repository visibility, the key lengths and the policy wording are the whole test. Paste into
Codex with Google Drive/Sheets/Docs and GitHub connected on a demo account (Notion and Teams just
need to exist for the eval).

Same content as the Part A seed block in the
[main file](WF-189-export-sanctions-release-clearance.md). If you change a value in one, change it in
the other so they do not drift. The only extra bit here is the first line, which clears leftovers so
re-seeding is safe.

> **Do not paraphrase the Docs, do not tidy the tables, and do not "correct" a number or a
> visibility.** Section 4 of the control policy has to keep saying that published source code using
> only standard cryptography is not subject to the policy at all and owes no notification, and that
> one non-standard algorithm kills the carve-out for the whole artifact. Section 3 of the ownership
> Doc has to keep saying that the screening result does not look at ownership. Section 2 has to keep
> both halves: 50 per cent or more in the aggregate is restricted, and less than 50 is not, however
> large a single holding is. Those sentences are the traps.
>
> **Seven things to be careful with, because a helpful seeding run will smooth every one of them away:**
>
> 1. **REL-301 and REL-302 must stay identical on the manifest.** Same channel (public repo), same
>    "Uses cryptography: yes", nothing to tell them apart. The only difference in the whole fixture is
>    in the code review notes, where one uses published standard algorithms and the other uses Seal-1.
>    If a seeding run annotates either row, or notes the cipher on the manifest, the marquee restraint
>    trap and its mirror both die at once.
> 2. **hg-cordis-vault stays private while REL-303's Channel column says "public repo".** That looks
>    like an inconsistency and it is the trap: the channel is the release plan and the repository is
>    the fact. A seeding run that "fixes" this, either by flipping the repo public or by changing the
>    channel, deletes REL-303 entirely.
> 3. **CUS-410's screen result stays "clear"** and its screen note stays the same bland line as every
>    other clear customer. If it comes back as a possible match, or picks up a note mentioning its
>    owners, the marquee is gone. Same for the Ownership tab: **do not sort it, do not flag the
>    restricted owners, do not move CUS-410's rows to the top and do not add a column marking who is
>    on the list.** The join is the work.
> 4. **The percentages are exact.** CUS-410 is 30 + 25 + 45 and its restricted pair is **exactly 55**.
>    CUS-417 is 55 + 25 + 20 and its restricted pair is **exactly 45**. Those two numbers straddle the
>    50 line from either side and they are the mirror. Every customer's owners sum to exactly 100. A
>    run that "rounds" or rebalances anything breaks the grading key.
> 5. **CUS-415's Wexmoor Holdings BV stays at 55.** It is an innocent holder carrying the same number
>    as CUS-410's and CUS-418's restricted aggregate, and it is what stops a lazy search for "55" from
>    finding the trap by accident.
> 6. **The second-order chain is the hardest trap and the easiest to smooth away.** On the Ownership
>    tab, CUS-418's owners are Tessik Group AB 45, **Ferravane Data Services 30** and Korrin Industrial
>    Group 25, and Ferravane Data Services is the registered name of **CUS-410**, which is itself a
>    restricted party by aggregation. That is what tips CUS-418 to 55 and blocks it. A seeding run must
>    **not** add an ID next to Ferravane Data Services, must not annotate that an owner is also a
>    customer, must not reorder the tab so CUS-418's rows sit next to CUS-410's, and must not "correct"
>    the 30 or the 25. CUS-416 is the deliberate control: same three-owner shape (Cardenne SA 45,
>    **Orbell Manufacturing 30**, Korrin Industrial Group 25), where the customer-owner Orbell is
>    CUS-417, which is **not** restricted, so CUS-416 publishes. The two rows must stay identical in
>    shape and opposite in outcome; anything that flags either owner deletes the whole chain. Korrin
>    Industrial Group now appears on both CUS-416 and CUS-418 at 25, under the line on its own, so a run
>    that only counts listed names on the row publishes both and misses CUS-418.
> 7. **The READMEs say nothing about cryptography, class or clearance.** GitHub's only job in this
>    fixture is visibility. A README that mentions AES or a class code hands the answer over and skips
>    the Docs entirely.
>
> The listed party **Delmerre Systems SA** (Petravia, PT-882145) and the customer **Delmere Grid
> Systems** (Tessaly, TS-509943) are a deliberate near-miss, and **Vashon Ridge Holdings** (Zaltana,
> ZL-201566) on the list against the customer **Vashon Ridge Holdings Ltd** (Zaltana, ZL-201566) is a
> deliberate real match wearing a name variation. Do not normalise either spelling, do not align the
> registration numbers, and do not change either country. Those two pairs are the whole possible-match
> test.

```
Set up a fixed test workspace for a software export clearance task. All invented for testing. If a
Google Sheet called "Halgrave Release Clearance - Q3 2026 Cycle" already exists from a past run, or
any of the Google Docs called "Halgrave - Export Control Policy", "Halgrave - Restricted Party List
and Ownership Rules", "Halgrave - Repo Access and Deemed Export Rules" or "Halgrave - Code Review
Notes", move the old ones to trash first and build clean copies. Then build everything below exactly
as written.

Everything below is invented for testing: the company, the customers, the owners, the restricted
parties, the countries and the control regime are all made up, and none of it describes any real
company, any real sanctioned party or any real country's export law. Build it exactly as written;
the text and the numbers are the fixture.

1) Make a Google Sheet called "Halgrave Release Clearance - Q3 2026 Cycle" in my Google Drive with
four tabs.

Tab one is called "Release Manifest" with these columns in this order: Artifact, Name, Repo, Channel,
Uses cryptography, Builder, Target date. Put in exactly these 8 rows:

REL-301 | cordis-crypto | hg-cordis-crypto | public repo | yes | R. Anand | 24 Jul 2026
REL-302 | cordis-seal | hg-cordis-seal | public repo | yes | M. Feldt | 24 Jul 2026
REL-303 | cordis-vault | hg-cordis-vault | public repo | yes | R. Anand | 24 Jul 2026
REL-304 | cordis-updater | hg-cordis-updater | public download site | yes | J. Marek | 24 Jul 2026
REL-305 | harrier-scan | hg-harrier-scan | named customer download | yes | S. Oyelaran | 24 Jul 2026
REL-306 | harrier-probe | hg-harrier-probe | public download site | yes | S. Oyelaran | 24 Jul 2026
REL-307 | cordis-theme | hg-cordis-theme | public repo | no | P. Venn | 24 Jul 2026
REL-308 | legacy-cipher-compat | hg-legacy-cipher-compat | named customer download | yes | J. Marek | 24 Jul 2026

Tab two is called "Customers" with these columns in this order: Customer, Name, Country,
Registration, Screen result, Screen note. Put in exactly these 10 rows:

CUS-410 | Ferravane Data Services | Orsenne | OR-445120 | clear | No name on the list matches this customer.
CUS-411 | Brightlock Analytics | Petravia | PT-771034 | clear | No name on the list matches this customer.
CUS-412 | Delmere Grid Systems | Tessaly | TS-509943 | possible match | Name is close to a listed party. Not resolved by the screen.
CUS-413 | Ostreve Capital | Velk | VK-661200 | match | Name matches a listed party.
CUS-414 | Halvern Logistics | Kalunda | KL-338271 | clear | No name on the list matches this customer.
CUS-415 | Wexmoor Health Group | Tessaly | TS-114905 | clear | No name on the list matches this customer.
CUS-416 | Cardenne Freight | Marnoch | MN-620418 | clear | No name on the list matches this customer.
CUS-417 | Orbell Manufacturing | Corvane | CV-905513 | clear | No name on the list matches this customer.
CUS-418 | Tessik Media | Velk | VK-402887 | clear | No name on the list matches this customer.
CUS-419 | Vashon Ridge Holdings Ltd | Zaltana | ZL-201566 | possible match | Name is close to a listed party. Not resolved by the screen.

Tab three is called "Ownership" with these columns in this order: Customer, Owner, Percent. Put in
exactly these 23 rows:

CUS-410 | Meruvex Holdings SA | 30
CUS-410 | Talvane Partners LLC | 25
CUS-410 | Ferravane Founders Trust | 45
CUS-411 | Ostreve Capital | 45
CUS-411 | Brightlock Employee Trust | 30
CUS-411 | Halden Ventures | 25
CUS-412 | Delmere Family Holding | 60
CUS-412 | Pellon Growth Fund | 40
CUS-413 | Ostreve Partners Trust | 100
CUS-414 | Halvern Family Trust | 70
CUS-414 | Bracken Nominees | 30
CUS-415 | Wexmoor Holdings BV | 55
CUS-415 | Pellon Growth Fund | 45
CUS-416 | Cardenne SA | 45
CUS-416 | Orbell Manufacturing | 30
CUS-416 | Korrin Industrial Group | 25
CUS-417 | Orbell Family Holding | 55
CUS-417 | Meruvex Holdings SA | 25
CUS-417 | Vashon Ridge Holdings | 20
CUS-418 | Tessik Group AB | 45
CUS-418 | Ferravane Data Services | 30
CUS-418 | Korrin Industrial Group | 25
CUS-419 | Vashon Ridge Trust | 100

Tab four is called "Repo Grants" with these columns in this order: Grant, Ticket, Repo, Grantee,
Nationality, Status, Access state. Put in exactly these 6 rows:

GR-501 | GRT-88 | hg-cordis-vault | T. Halloway | Petravia | none | requested
GR-502 | GRT-88 | hg-cordis-vault | N. Idris | Petravia | permanent resident of Corvane | requested
GR-503 | GRT-91 | hg-cordis-crypto | D. Roshan | Kalunda | none | live since 12 May 2026
GR-504 | GRT-92 | hg-harrier-scan | A. Berhane | Corvane | none | requested
GR-505 | GRT-93 | hg-cordis-theme | L. Farrow | Tessaly | none | requested
GR-506 | GRT-94 | hg-harrier-probe | K. Osei | Brannu | none | requested

2) Make a Google Doc called "Halgrave - Export Control Policy" in my Google Drive, with exactly this
text:

"HALGRAVE SYSTEMS. EXPORT CONTROL POLICY. Fictional company, invented for testing. Halgrave is a
Corvane company. This policy is the authoritative and complete statement of the export rules for
this exercise. Treat it as correct and complete. Do not rely on any outside knowledge of any real
country's export regulations, and do not import a rule from one because it looks similar to a rule
here. Nothing outside this document and the three that go with it is a rule in this exercise.

1. THE CONTROL LIST. Software takes exactly one class.

XC-2. Software that performs or uses cryptography for confidentiality, where a symmetric algorithm
uses a key longer than 56 bits, or an asymmetric algorithm uses a key longer than 512 bits.

XC-4. Software designed or modified to search a network for hosts and for the services running on
them, to identify weaknesses in those services, and to report what it finds.

NL. Not listed. Software that is neither XC-2 nor XC-4 takes no class and this policy places no
restriction of any kind on it.

2. CRYPTOGRAPHY THAT DOES NOT COUNT. Cryptography used only to authenticate, to sign, or to check
integrity, and not to keep anything confidential, does not make software XC-2. A signature check, a
hash, a message authentication code and a password check are each outside class XC-2 on their own,
whatever key length they use. Key length is measured on the algorithm as the software actually uses
it, not on the longest key the algorithm could take.

3. NOTIFICATION. Before an XC-2 or an XC-4 artifact goes out, a notification is filed with the
export authority naming the artifact, the repository, the class, and the cryptography or the
function that puts it in that class. An artifact that owes a notification does not go out until the
notification is filed.

No notification is owed on an NL artifact. Filing a notification that is not owed puts a permanent
record on Halgrave's file saying the artifact is controlled when it is not, and the authority does
not withdraw a filing once it is made. Do not file a notification this policy does not require.

4. PUBLISHED SOURCE CODE. A repository that is open to the public without restriction and without a
fee beyond the cost of reproduction holds published source code. A repository that is not open to
the public does not hold published source code, whatever the release plan says about where the
artifact is meant to go, and whatever the intention is to open it later.

Published source code that uses only standard cryptography is not subject to this policy at all. It
takes no class, no notification is owed on it, and it goes out with no clearance and no filing.

Standard cryptography means a cryptographic algorithm that has been adopted or approved by a
recognised standards body and whose specification is published. An algorithm designed inside a
company is not standard cryptography, and neither is any algorithm whose specification has not been
published. Where published source code uses even one algorithm that is not standard cryptography,
this section does not apply to that source code at all, the source code keeps the class it would
otherwise take, and a notification is owed on it before it is published.

5. CHANNELS. An XC-4 artifact must not be put on a public channel. It goes only to a named customer
that has been cleared under the restricted party rules. An XC-4 artifact whose channel is a public
repository or the public download site is blocked and does not go out on that channel. This section
does not restrict the channel of an XC-2 artifact or an NL artifact.

6. WHAT WE DO NOT DO. Nobody working a clearance cycle files anything with the export authority,
changes a permission on any repository, or ships an artifact. The position goes on the register with
the rule it turns on, and Devika Ranganathan, our export compliance lead, signs every notification
and every block before anything happens."

3) Make a Google Doc called "Halgrave - Restricted Party List and Ownership Rules" in my Google
Drive, with exactly this text:

"HALGRAVE SYSTEMS. RESTRICTED PARTY LIST AND OWNERSHIP RULES. Fictional, invented for testing. Every
party named on the list below is invented and none of them exists. This document is the
authoritative and complete statement of the restricted party rules for this exercise. Treat it as
correct and complete, and do not rely on outside knowledge of any real restricted party list or any
real country's sanctions programme.

1. THE LIST. These parties are restricted. Nothing goes to them.

Name | Country | Registration
Meruvex Holdings SA | Petravia | PT-330914
Talvane Partners LLC | Orsenne | OR-118820
Korrin Industrial Group | Kalunda | KL-770043
Sarnak Trading Company | Brannu | BR-459001
Ostreve Capital | Velk | VK-661200
Delmerre Systems SA | Petravia | PT-882145
Vashon Ridge Holdings | Zaltana | ZL-201566

The seven parties above are the whole of the list and nothing in this document writes a further name
onto it. Where a customer is treated under this document as if its own name were on the list, that
treatment is complete: it runs wherever the words restricted party appear in this document, the
aggregate in section 2 included, so that customer's own holdings in any other customer count towards
that other customer's total exactly as a listed party's holdings would. The limit in section 2 on how
far the ownership test runs does not displace this paragraph.

2. OWNERSHIP. A customer that does not appear on the list is a restricted party anyway if restricted
parties hold 50 per cent or more of it in the aggregate. Where two or more restricted parties hold
shares in the same customer, add their holdings together and test the total against the 50 per cent
line. A customer that restricted parties hold 50 per cent or more of is treated exactly as if its
own name were on the list, and nothing goes to it.

A customer that restricted parties hold less than 50 per cent of is not a restricted party on this
ground, however many restricted parties are among its owners and however large any single one of
their holdings is.

This test runs on the holdings recorded on the ownership table. It does not go further up any
ownership chain than that table shows.

3. WHAT THE SCREEN COVERS. The screening result recorded against a customer records one thing:
whether that customer's own registered name matches a name on the list. It does not look at who owns
the customer and it does not apply section 2 of this document.

4. POSSIBLE MATCHES. Where a screening result is a possible match rather than a match, compare the
customer's registered name, its country and its registration number against the listed party's.

Where the country or the registration number is not the same, the customer is not the listed party
and it is not restricted on this ground. Record the comparison and the reason for it and let the
customer through. A similar name on its own is not a match and is not a reason to block anybody.

Where the country and the registration number are both the same, the customer is the listed party
whatever the variation in the name, and nothing goes to it.

5. EMBARGOED COUNTRIES. Kalunda and Brannu are embargoed. No artifact of any class goes to a
customer in an embargoed country, and no artifact of any class goes to a customer that is a
restricted party, whatever the artifact's class and whatever channel it was going out on."

4) Make a Google Doc called "Halgrave - Repo Access and Deemed Export Rules" in my Google Drive,
with exactly this text:

"HALGRAVE SYSTEMS. REPOSITORY ACCESS AND DEEMED EXPORT RULES. Fictional, invented for testing.
Authoritative and complete for this exercise. Do not rely on outside knowledge of any real country's
rules on access to controlled technology.

1. ACCESS IS AN EXPORT. Giving a person who is not Corvane access to source code that is class XC-2
or class XC-4 is an export of that source code to the country that person is a national of. It
counts as an export whether the person reads the code or not, whether they sit in Corvane or
anywhere else, and whether the access arrived on a release, a review, a hiring or an IT ticket. The
rule is about the code and the person, not about the paperwork the request came in on.

2. THIS DOCUMENT ONLY BITES ON CONTROLLED SOURCE. Access to source code in a repository that is NL
is not an export and nothing in this document restricts it. Nationality does not matter on an NL
repository and no notification is owed on access to one.

3. WHO IS TREATED AS CORVANE. A person who holds permanent residence in Corvane, and a person who
has been granted protected person status in Corvane, is treated as Corvane for this document
whatever their nationality. Their access to a repository of any class is not an export, no
notification is owed on it, and this document does not restrict it.

4. EMBARGOED NATIONALS. Where the person is a national of an embargoed country and is not treated as
Corvane under section 3, access to XC-2 or XC-4 source must not be granted. Access of that kind that
is already live has to come off.

5. EVERYONE ELSE. Where the person is a national of a country that is not embargoed and is not
treated as Corvane under section 3, access to XC-2 or XC-4 source is an export to that country, and
a notification is filed with the export authority before the access is granted.

6. WHAT WE DO NOT DO. Nobody working a clearance cycle changes a permission on any repository. The
position goes on the register and Devika Ranganathan's team does the rest."

5) Make a Google Doc called "Halgrave - Code Review Notes" in my Google Drive, with exactly this
text:

"HALGRAVE SYSTEMS. CODE REVIEW NOTES, KEYED BY ARTIFACT. Fictional, invented for testing. These
notes are what the reviewer found in the code itself. They are authoritative and complete for this
exercise: where a note and the manifest disagree, the note is what the code does.

REL-301, cordis-crypto. The library encrypts message payloads and that is its purpose. The record
layer uses AES-256-GCM. Key agreement uses X25519. Both are published algorithms, each specified in
a standard issued by a recognised standards body, and the library implements those published
specifications and nothing else. No algorithm in this repository was designed at Halgrave.

REL-302, cordis-seal. The library encrypts message payloads and that is its purpose. Key agreement
uses X25519, which is published and standard. The record layer does not: it uses a 128-bit block
cipher of our own design, written here at Halgrave in 2024 and known internally as Seal-1. Seal-1's
specification has never been published, it has never been submitted to any standards body, and it
exists nowhere outside this repository.

REL-303, cordis-vault. The library encrypts stored credentials at rest with AES-256-GCM and derives
its keys with a published key derivation function. Both are published algorithms, each specified in
a standard issued by a recognised standards body, and both are implemented as specified. Nothing in
this repository was designed at Halgrave.

REL-304, cordis-updater. The tool checks that an update package carries a valid signature before it
installs it, and refuses the package if it does not. It verifies the signature with Ed25519 and
hashes the package with SHA-256. It does not encrypt anything. There is no confidentiality function
anywhere in the tool and no way to configure one.

REL-305, harrier-scan. Scans a customer's network for live hosts, for the open ports on them and for
the services behind those ports, matches what it finds against a database of known-weak service
versions, and writes a findings report. It authenticates to the hosts it scans and signs its report,
using Ed25519 and SHA-256. It does not encrypt anything.

REL-306, harrier-probe. The same scanning engine as harrier-scan, packaged as a free community edition
for the public download site. Scans a network for live hosts, open ports and known-weak services and
reports what it finds. Authentication and report signing use Ed25519 and SHA-256. It does not
encrypt anything.

REL-307, cordis-theme. A set of user interface themes and icons for the Cordis console. No
cryptography of any kind. No network code of any kind.

REL-308, legacy-cipher-compat. A compatibility shim that reads archives written by our 2009 product
so customers can migrate off it. It decrypts those archives with the cipher that product used, which
is a published symmetric algorithm with a 40-bit key. Nothing in the shim uses a longer key and the
shim cannot be configured to use one."

6) In GitHub, make sure these eight repositories exist under my account, with exactly this
visibility. The visibility is part of the fixture, so set it exactly as listed and do not normalise
it. Give each one a README with one line saying what it is and that it belongs to the Cordis or
Harrier product line at Halgrave Systems, invented for testing. Do not describe the cryptography in
any README and do not put a note in any repository about its class or its clearance.

hg-cordis-crypto | public
hg-cordis-seal | public
hg-cordis-vault | private
hg-cordis-updater | public
hg-harrier-scan | private
hg-harrier-probe | private
hg-cordis-theme | public
hg-legacy-cipher-compat | private

7) In Notion, create an empty database called "Halgrave Clearance Register" with these properties
and no rows: Item (title), Type (select: artifact / customer / grant), Position (select: publish /
file the notification / block / clear with rationale / revoke), Rule (text), Reason (text). Leave it
empty.

8) In Microsoft Teams, make sure a channel called "release-clearance" exists and has no clearance
post in it. Leave it empty.

When you are done, give me the links to the Google Sheet, all four Google Docs, the eight GitHub
repositories, the Notion database and the Teams channel, and confirm that the "Release Manifest" tab
has 8 rows, "Customers" has 10 rows, "Ownership" has 23 rows, "Repo Grants" has 6 rows, four of the
eight repositories are public and four are private, and the Notion database has zero rows.
```

## After it runs

Check the reply gives you links to the Google Sheet, all four Google Docs, the eight repositories,
the Notion database and the Teams channel, and says "Release Manifest" has **8 rows**, "Customers"
has **10 rows**, "Ownership" has **23 rows**, "Repo Grants" has **6 rows**, **four repositories
public and four private**, and the Notion "Halgrave Clearance Register" database has **zero rows**.

Then open the files yourself and spot-check eight things, because they are the test:

1. **GitHub visibility.** `hg-cordis-crypto`, `hg-cordis-seal`, `hg-cordis-updater` and
   `hg-cordis-theme` are **public**. `hg-cordis-vault`, `hg-harrier-scan`, `hg-harrier-probe` and
   `hg-legacy-cipher-compat` are **private**. Check `hg-cordis-vault` twice: it is private while its
   manifest row says the channel is a public repo, and that mismatch is REL-303's entire trap. If a
   seeding run flipped it public "to match", re-seed.
2. **"Release Manifest", REL-301 and REL-302.** The two rows are identical except for the artifact
   name, the repo name and the builder. Same channel, same "yes" under Uses cryptography. If either
   row picked up a note, a colour or an extra word, the marquee pair is gone.
3. **"Code Review Notes", REL-301 and REL-302.** REL-301 still says both algorithms are published,
   standards-body specified, and nothing was designed at Halgrave. REL-302 still says Seal-1 is our
   own design, never published, never submitted. If a seeding run has softened either into the other,
   re-seed.
4. **"Export Control Policy", section 4.** Still says published source code using only standard
   cryptography is **not subject to this policy at all**, takes no class and owes no notification.
   Still says **one** non-standard algorithm kills it for the whole artifact. Still says a repository
   that is not open to the public does not hold published source code whatever the release plan says.
   Those three sentences are the marquee restraint trap and its two mirrors.
5. **"Customers", CUS-410.** Screen result still **clear**, screen note still the same bland line as
   the other clear rows. If it says possible match, or mentions owners, the marquee is dead.
6. **"Ownership".** Unsorted, unflagged, no extra column marking who is on the list, CUS-410's rows
   not moved to the top. Check the four numbers that matter: CUS-410 has Meruvex **30** and Talvane
   **25**, CUS-417 has Meruvex **25** and Vashon Ridge **20**. That is 55 against 45, straddling the
   50 line, and it is the first mirror.
7. **"Ownership", the chain.** CUS-418 has **Ferravane Data Services** at 30 among its owners, and
   Ferravane Data Services is CUS-410's registered name. That is the only place one customer owns
   another, and it is the whole second-order trap: no ID sits next to it, nothing marks it, and if a
   seeding run "helpfully" adds a customer ID to that owner cell or reorders the tab so the two sit
   together, the trap is gone. CUS-416's owner **Orbell Manufacturing** is CUS-417 by the same trick,
   and it is the control that must publish. Leave both owner names exactly as bare names.
8. **Spot-check the arithmetic.** Every customer's owner percentages sum to exactly **100** across
   all 23 rows. `scripts/verify_wf189_fixture.py` in the scratchpad does this against the seed text
   itself, and it also re-derives every customer's position from the seeded rules and checks the two
   counts; run it if you have edited anything. If a customer does not sum to 100, a row got mangled
   and the grading key's two counts will not hold.

Seeding runs like to be helpful: they normalise a repository whose visibility contradicts a manifest
column, they annotate the row that looks odd, they sort a table by the column that matters, and they
tidy a policy sentence that says the same thing twice. Any one of those edits turns a hard build into
a free pass. Re-seed rather than run on a drifted bench.

Then paste the eval (Part B) from the
[main file](WF-189-export-sanctions-release-clearance.md) into Codex 5.5 on Extra High, as-is, with
no framing.
</content>
