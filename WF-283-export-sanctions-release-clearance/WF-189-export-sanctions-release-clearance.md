# WF-189 — The clean screen is not a clearance: clearing a software release under export and sanctions rules

**Department/Area:** Security
**Tools (5):** Google Sheets (read the release manifest, the customer roster, the ownership table and the repo grant list) + Google Docs (read the four-part rule pack: the control list, the restricted party and ownership rules, the deemed export rules, and the code review notes) + GitHub (read the repos, to see which are actually public and which are private) → Notion database "Halgrave Clearance Register" (write one row per item) → Microsoft Teams channel "release-clearance" (post what is blocked and what is being filed, with both counts, live). Reads in three apps, acts in two.
**Source:** EXP-174 (`../../../ideas/workflow-ideas-11.md`). WF build IDs are their own series, not EXP-aligned; full WF↔EXP map in `../../../context.md` §2a.
**Status:** Pending — seed + eval + form + grading key written 2026-07-16, **not yet run**.

**What it is (one paragraph):** Every release cycle somebody has to say whether each artifact can go
out, whether each customer can receive it, and whether each repo grant is a problem. Over-filing is
not free: a notification you did not owe is a permanent record with the authority saying your
artifact is controlled when it is not, and you do not get to take it back. Under-filing is a
penalty. The work is hard because the answer never lives in the thing that flags it. The manifest
says an artifact uses cryptography and that tells you nothing about whether it is controlled. The
screen comes back clean on a customer that is restricted anyway. A grant request looks like an IT
ticket and is an export decision. Every fact that decides an item sits in a different source from
the one that raised it, and the rule pack is a list of controls with carve-outs where the carve-outs
are the whole job.

**Why there is no screening tool or trade-compliance system named here.** EXP-174 named none, on
purpose, and this build names none either. Codex has no native connector for a restricted-party
screening platform or any trade-compliance system (checked against
`../../../codex-plugins-reference.md`), and naming one would be inventing it. So the screening
*result* is seeded as a column on the customer roster, which is what a compliance engineer actually
works off anyway: the screen runs somewhere else and the export lands in Drive. The difficulty was
never in the screening tool. It is in the rule pack, and the rule pack seeds perfectly as Google
Docs. **This build buys department coverage, not plugin coverage.** Security has one row in the
client registry and every connector here (Sheets, Docs, GitHub, Notion, Teams) is already well used.
That trade is being made knowingly.

**Everything is invented, including the law.** Fictional vendor (Halgrave Systems), fictional
customers, fictional owners, fictional restricted parties, fictional countries, and a fictional
control regime with invented class codes. No real company, no real sanctioned party and no real
country appears anywhere in it. The rule *structure* is real and deliberately so: a control list
keyed on cryptography and key length, a published-source carve-out gated on standard cryptography,
an ownership rule that aggregates at 50 per cent, a deemed-export rule with a residence exemption.
That structure is the rulebook and reading it is the whole test.

**Why the countries and the class codes are invented rather than real.** This is the load-bearing
design call in the build, so it is worth saying plainly. If the classification scheme were real, a
model could answer from memory instead of from the seeded text, and worse, its memory of the real
regime could *contradict* the seeded rule and make the correct answer arguable. The
publicly-available carve-out is the sharp case: the real-world analogue has a notification limb that
this policy does not, so a model reasoning from the real regime would file on REL-301 and be able to
defend it. That would destroy the marquee restraint trap. Inventing the regime makes every answer
traceable to a sentence in a Doc, which is what makes the build both fair and gradeable. Same
argument for the countries: an invented embargo list cannot be answered from memory.

---

## Part A — Data-seeding prompt

Builds the fixed bench. Also lives as [`seed-prompt.md`](seed-prompt.md) with a clear-leftovers line
on top. **If you change a value in one, change it in the other so they do not drift.**

```
Set up a fixed test workspace for a software export clearance task. Everything below is invented for
testing: the company, the customers, the owners, the restricted parties, the countries and the
control regime are all made up, and none of it describes any real company, any real sanctioned party
or any real country's export law. Build it exactly as written; the text and the numbers are the
fixture.

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

---

## Part B — Workflow prompt (the eval prompt, paste as-is)

This is **field 1 of Form 1**. Nothing here names a trap: the carve-out is in the policy Doc, the
aggregation rule is in the ownership Doc, the cryptography is in the code review notes, the
visibility is on GitHub, and the answers are in the grading key. The prompt states the job and names
the sources.

```
When engineering pins a ship date to a release, the clearance work lands on me. I carry trade compliance for the Cordis and Harrier lines at Halgrave Systems, both lines are down for 24 July, and the Q3 cycle has to clear before any of it moves. I'm writing this on Thursday 16 July 2026 (IST), so that's the week I've got.

Everything waiting on me is in one Google Sheet, "Halgrave Release Clearance - Q3 2026 Cycle", spread over four tabs. "Release Manifest" is the artifacts going out this cycle, one row each, with the repository it builds from, which channel it is meant to go out on, whether it uses cryptography, who built it and the target date. "Customers" is the customers waiting on the release, with each one's country, its registration number, and what came back on the restricted party screen. "Ownership" is who owns each of those customers and what share they hold. "Repo Grants" is the source access requests sitting in the queue, with the repository, the grantee, their nationality, any status they hold, and whether the access is already live.

I need exactly one position on every row of "Release Manifest", every row of "Customers" and every row of "Repo Grants". Five to pick from, one per item. Publish means it goes out, or the access stands as it is, and nothing is owed on it. File the notification means it can go but a notification is owed to the export authority first. Block means it doesn't go out, or it doesn't go to them. Clear with rationale is where something flagged and it turned out not to be what it looked like, so you write down why and let it through. Revoke is where access is already live and has to come off.

What decides any of that is four Google Docs. "Halgrave - Export Control Policy" has the control list, what counts as cryptography for it, when a notification is owed, and which channels a class can go out on. "Halgrave - Restricted Party List and Ownership Rules" has the restricted party list itself and the rules for who counts as restricted. "Halgrave - Repo Access and Deemed Export Rules" covers source access. "Halgrave - Code Review Notes" says what each artifact actually does and what cryptography is actually in it, keyed by artifact. Those four are the rulebook for this exercise and they beat anything you know about export control or sanctions generally. Our repositories are on GitHub, and that is where you can see which ones are actually open to the public and which ones are private. Read GitHub, don't write to it.

The whole cycle goes into the Notion database "Halgrave Clearance Register", one row per item, carrying at least the item's ID, whether it is an artifact or a customer or a grant, the position, the rule you relied on named by its document and section, and a one-line reason. Set the rest of the row up however works best for reading it back. Then post to the Microsoft Teams channel "release-clearance", for real: everything you are blocking and everything we are filing a notification on, each with its one-line reason, plus how many notifications we owe in total and how many items are blocked in total. Both as counts, not ranges.

Devika Ranganathan is our export compliance lead and she signs every notification and every block, so nothing gets filed or changed until it has been in front of her. Don't file anything with the export authority yourself and don't change a permission on any repository. Where the position comes out as file the notification, or as revoke, the Notion row saying so is all I need from you and Devika's team takes it from there.

Anything that won't open for you, the Google Sheet, one of the four Google Docs, GitHub, the Notion database, the Teams channel, say which one and stop there. Don't let anything rest on what you reckon a rule probably says, or on what you'd expect to be in a repository you haven't opened. If the rulebook doesn't reach something you need for an item, mark that row and say what's missing.

I'll take the cycle as cleared when every artifact, every customer and every grant has a Notion row with a position and a named rule on it, the Teams post carries what's blocked and what we're filing with both counts, and those counts reconcile against the Notion rows.
```

---

## Grading key (keep out of Codex)

Twenty-four items. **Twelve carry a planted call; twelve are there so the run has somewhere to be
right.** Score per item; **REL-301, CUS-410 and CUS-418 count double**: the marquee restraint call,
the marquee ownership block, and the second-order chain that sits on top of it. Their mirrors
(REL-302, CUS-417, CUS-416) score 1, the same convention the rest of the build already uses. 27
points available.

### Artifacts (8)

| # | Item | Correct position | Why | Weight |
|---|---|---|---|---|
| 1 | **REL-301** cordis-crypto | **publish**, nothing filed | **Restraint trap, the marquee.** A cryptography library, AES-256-GCM and X25519, going out on a public repo. Everything about it screams "controlled". Policy §4: a public repository holds published source code, and published source code that uses **only standard cryptography** is *not subject to this policy at all*, takes no class and owes no notification. The notes say both algorithms are published, standards-body specified, implemented as specified, and nothing was designed at Halgrave. GitHub confirms the repo is public. So both limbs are met and the correct action is to **file nothing and publish**. A model files "to be safe" and creates the permanent record §3 warns about. | **2** |
| 2 | **REL-302** cordis-seal | **file the notification** | **The mirror, and the discriminator is in the code.** Identical manifest row to REL-301: public repo, uses cryptography, same shape. GitHub says the repo is public, so limb one of §4 is met exactly as it is for REL-301. The notes are the only thing that differs: the record layer is Seal-1, a 128-bit block cipher designed at Halgrave, never published, never submitted anywhere. §4 says standard cryptography means adopted or approved by a recognised standards body *and* published, and that **one** non-standard algorithm kills the carve-out for the whole artifact. X25519 being standard does not save it. So XC-2 stands and a notification is owed. | 1 |
| 3 | **REL-303** cordis-vault | **file the notification** | **The GitHub limb.** Third row of the same shape, and the crypto is clean: AES-256-GCM and a published KDF, standards-body specified, nothing homegrown. It fails on the other limb. The manifest Channel says "public repo" but **GitHub says hg-cordis-vault is private**, and §4 says a repository that is not open to the public does not hold published source code *whatever the release plan says and whatever the intention is to open it later*. So the carve-out does not reach it, XC-2 stands, notification owed. The Channel column is the plan; GitHub is the fact. | 1 |
| 4 | **REL-304** cordis-updater | **publish**, nothing filed | **Manifest says yes, code says no.** "Uses cryptography: yes" on the manifest, and it is true: Ed25519 and SHA-256. §2 says cryptography used only to authenticate, sign or check integrity, and not for confidentiality, does not make software XC-2, whatever key length it uses. The notes say there is no confidentiality function anywhere in the tool and no way to configure one. So NL, and §3 says no notification is owed on an NL artifact. A run that classifies off the manifest column files this one. | 1 |
| 5 | REL-305 harrier-scan | **file the notification** | Clean. A vulnerability scanner: searches a network for hosts and services, identifies weaknesses, reports them. That is §1's XC-4 wording almost verbatim. Channel is a named customer download, which §5 allows. §3: notification owed before it goes. Its Ed25519 signing is a §2 red herring and does not make it XC-2 either way. | 1 |
| 6 | REL-306 harrier-probe | **block** | Clean, and the pair to REL-305. Same engine, so also XC-4. Channel is the public download site, and §5 says an XC-4 artifact must not be put on a public channel and one whose channel is a public repository or the public download site **is blocked**. Same class as REL-305, opposite answer, discriminator is the Channel column. | 1 |
| 7 | REL-307 cordis-theme | **publish**, nothing filed | Clean freebie. Themes and icons, no cryptography of any kind, no network code. NL. The only manifest row with "Uses cryptography: no". | 1 |
| 8 | REL-308 legacy-cipher-compat | **publish**, nothing filed | Clean, and it makes the §1 threshold bite. Real confidentiality encryption, genuinely decrypting archives, "Uses cryptography: yes". But the key is **40-bit** symmetric and §1 puts the XC-2 line at *longer than 56 bits*. 40 is under it, the shim cannot be configured higher, so NL. A run that reads "encryption" and stops files this one. | 1 |

### Customers (10)

| # | Item | Correct position | Why | Weight |
|---|---|---|---|---|
| 9 | **CUS-410** Ferravane Data Services | **block** | **The marquee. The clean screen is the trap.** Screen result is **clear**, and §3 of the ownership Doc says in as many words that the screen records only whether the customer's *own name* matches the list and does not look at ownership. The Ownership tab has Meruvex Holdings SA at **30** and Talvane Partners LLC at **25**, both on the restricted list, **55 per cent between them**. §2 aggregates holdings of two or more restricted parties and treats the customer exactly as if its own name were on the list at 50 per cent or more. So it is blocked, and the reason has to name the aggregate. The clean screen is the only thing arguing the other way and it is the thing §3 disclaims. **This row is also the anchor of the chain: CUS-418 cannot be answered until this one is.** | **2** |
| 10 | **CUS-411** Brightlock Analytics | **publish** | **Over-block bait, single holder.** Screen clear. Ostreve Capital holds **45 per cent** and is on the list. §2: a customer restricted parties hold **less than** 50 per cent of is not restricted on that ground, "however large any single one of their holdings is". 45 is under the line. Blocking this is the error, and it is the error a run makes right after it finally finds the ownership rule. | 1 |
| 11 | **CUS-412** Delmere Grid Systems | **clear with rationale** | **The fuzzy hit.** Screen says **possible match**: "Delmere Grid Systems" against the listed "Delmerre Systems SA". §4 says compare name, country and registration number. Country is **Tessaly** against the listed party's **Petravia**; registration is **TS-509943** against **PT-882145**. Both differ, so it is not the listed party, and §4 says record the comparison and let it through. A similar name on its own is not a reason to block anybody. Ownership is clean. | 1 |
| 12 | CUS-413 Ostreve Capital | **block** | Clean. Screen says **match** and it is right: exact name, and registration **VK-661200** is the list's own entry. §1: nothing goes to a listed party. Velk is not embargoed, so the reason is the list itself and nothing else. This is also the party holding 45 per cent of CUS-411, which is consistent and deliberate. | 1 |
| 13 | CUS-414 Halvern Logistics | **block** | Clean, and the reason matters. Screen clear, ownership clean, nothing restricted about it at all. It is in **Kalunda**, and §5 says Kalunda is embargoed and no artifact of any class goes to a customer in an embargoed country. A run that blocks it for an ownership reason has landed the right answer off the wrong rule. | 1 |
| 14 | CUS-415 Wexmoor Health Group | **publish** | Clean, and the **55 decoy**. Wexmoor Holdings BV holds 55 per cent, which is the number both real aggregates land on (CUS-410 and CUS-418), sitting here on a completely innocent holder who is not on the list. A run pattern-matching the number rather than the list gets this wrong. | 1 |
| 15 | **CUS-416** Cardenne Freight | **publish** | **The chain mirror, the control on CUS-418.** Same cap table shape as CUS-418, owner for owner: an innocent parent at **45**, a customer-owner at **30**, Korrin Industrial Group (listed) at **25**. The customer-owner is **Orbell Manufacturing, which is CUS-417**, whose own restricted holdings come to 45, under the line. So CUS-417 is not a restricted party, its 30 does not count, the aggregate is Korrin's **25** alone, and it publishes. A run that never chains publishes this off arithmetic it never did; a run that chains but reads CUS-417 as restricted because it has two restricted owners gets **55** and blocks it. Read against CUS-418: identical numbers, opposite answers, and the only discriminator is what happened one level down. Scored 1 as the mirror; the load is on CUS-418. | 1 |
| 16 | **CUS-417** Orbell Manufacturing | **publish** | **The aggregation mirror, and the sharpest fair test in the build.** Two restricted parties on the ownership table, exactly like CUS-410: Meruvex Holdings SA at **25** and Vashon Ridge Holdings at **20**. Aggregate is **45**, under the line, so it publishes. Identical shape to the marquee, opposite answer, and the discriminator is arithmetic and nothing else. A run that has learned "two restricted owners means block" fails here; a run that actually applies §2 gets both. **It also carries CUS-416:** get this row wrong and CUS-416 goes with it. | 1 |
| 17 | **CUS-418** Tessik Media | **block** | **The second-order call, and the hardest row in the build.** Screen clear, nothing on the row says anything, and the cap table looks innocent: Tessik Group AB **45**, Ferravane Data Services **30**, Korrin Industrial Group **25**. Korrin is the only listed name and 25 is under the line, so a run that stops there publishes. **Ferravane Data Services is CUS-410**, eight rows up the same tab, and CUS-410 is a restricted party by aggregation. §1's closing paragraph says that treatment is complete and runs inside §2's own aggregate, so Ferravane's 30 counts exactly as a listed party's would: 30 plus 25 is **55** and it blocks. Nothing flags the name, there is no ID on the Owner column, and §2's own "does not go further up any ownership chain" sentence argues against it until you have read §1 past the table. Getting here needs the run to resolve CUS-410 first, notice an owner name is a customer name, and find the precedence. | **2** |
| 18 | **CUS-419** Vashon Ridge Holdings Ltd | **block** | **The mirror of CUS-412.** Same screen result, **possible match**, opposite answer. §4's second limb: country **Zaltana** matches the listed party's Zaltana, registration **ZL-201566** matches the list's ZL-201566. Both the same, so it **is** the listed party "whatever the variation in the name", and the trailing "Ltd" is the variation. Getting 412 and 419 both right is the pair; getting both the same way means the run never opened §4. | 1 |

### Grants (6)

| # | Item | Correct position | Why | Weight |
|---|---|---|---|---|
| 19 | **GR-501** T. Halloway | **file the notification** | **The IT ticket that is an export.** Ticket GRT-88, read access to hg-cordis-vault, which is XC-2 (see REL-303). Grantee is a national of **Petravia**, not embargoed, holds no status. §5 of the deemed export Doc: access to XC-2 source by a non-Corvane national of a non-embargoed country is an export to that country and a notification is filed **before** the access is granted. | 1 |
| 20 | **GR-502** N. Idris | **publish** | **Same ticket, opposite answer.** GRT-88 again, same repository, same nationality (**Petravia**), same access. The only thing that differs is the Status column: **permanent resident of Corvane**. §3 says such a person is treated as Corvane whatever their nationality, their access is not an export, and no notification is owed. Two grantees on one ticket resolving opposite ways is the whole point; a run that dispositions the *ticket* rather than the *grant* cannot get both. | 1 |
| 21 | GR-503 D. Roshan | **revoke** | Clean, and the only revoke in the build. National of **Kalunda**, embargoed, no status, access to hg-cordis-crypto and **already live since 12 May 2026**. §4: access of that kind must not be granted, and access already live has to come off. Note this is the repo whose *artifact* (REL-301) is carved out of the policy entirely, which is not a contradiction: §4 of the control policy carves out the published artifact, and the deemed export Doc keys on the class of the source in the repository. If a run argues REL-301's carve-out makes GR-503 fine, that is a defensible read and a genuine grading judgement call, so see the note below. | 1 |
| 22 | GR-504 A. Berhane | **publish** | Clean. National of **Corvane**, the home country. §1 only bites on a person who is not Corvane. Not an export, nothing owed. | 1 |
| 23 | **GR-505** L. Farrow | **publish** | **Restraint on the grant list.** A foreign national (**Tessaly**, not embargoed, no status) getting source access, which is the exact shape of GR-501. The repository is **hg-cordis-theme**, which is NL (REL-307: no cryptography, no network code). §2: access to an NL repository is not an export, nationality does not matter and no notification is owed. A run applying "foreign national plus repo access equals file" files this one. | 1 |
| 24 | GR-506 K. Osei | **block** | Clean, and the pair to GR-503. National of **Brannu**, embargoed, no status, access to hg-harrier-probe which is XC-4. §4: must not be granted. The difference from GR-503 is the Access state column: this one is **requested**, so it is blocked rather than revoked. | 1 |

### A known soft edge on GR-503, decided deliberately

hg-cordis-crypto is the repository behind REL-301, the carved-out artifact. Control policy §4 says
that artifact "is not subject to this policy at all", and a careful run could argue the source in
that repository therefore has no class, so the deemed export Doc's §4 never bites and GR-503 is fine
as it stands. The intended reading is the other one: §4 of the control policy carves out *published
source code going out*, the repository's contents are what they are, and the access rules key on
class. **Both readings are defensible.** Grade GR-503 on whether the run *named a rule and reasoned*,
not on which way it landed, and do not let it swing the score. It is one point out of 27 and it is
the only place in the build where the rule pack is not airtight. Left in because moving GR-503 to a
different repository would cost the nice detail that the same repo appears on both lists, and because
a run that spots the tension and says so out loud is showing exactly the judgement this workflow is
testing.

### The two counts (this is the objective spine of the grading)

- **Notifications owed = 4.** REL-302, REL-303, REL-305, GR-501.
- **Items blocked = 7.** REL-306, CUS-410, CUS-413, CUS-414, CUS-418, CUS-419, GR-506.
- Publish = 11, clear with rationale = 1 (CUS-412), revoke = 1 (GR-503). The five positions
  reconcile to 24.

**The headline is that of eight artifacts going out under an export regime, only three owe a filing,
and the loudest one on the list owes nothing.** Every likely miss moves one of the two counts to a
different, recognisable number, which is what makes this gradeable without arguing about prose:

| If the run... | Notifications | Blocked |
|---|---|---|
| gets it right | **4** | **7** |
| files on REL-301 (the carve-out, the marquee) | 5 | 7 |
| files on REL-304 (authentication-only crypto) | 5 | 7 |
| files on REL-308 (the 40-bit key) | 5 | 7 |
| files on GR-502 (the permanent resident) | 5 | 7 |
| files on GR-505 (the NL repository) | 5 | 7 |
| misses CUS-418's chain but gets CUS-410 | 4 | 6 |
| misses CUS-410's ownership (CUS-418 goes with it) | 4 | 5 |
| blocks CUS-411 (the 45 per cent single holder) | 4 | 8 |
| blocks CUS-412 (the fuzzy hit) | 4 | 8 |
| blocks CUS-417 (the 45 per cent aggregate) | 4 | 8 |
| blocks CUS-417 and chains it into CUS-416 | 4 | 9 |
| misses CUS-419 (the real match behind the fuzzy hit) | 4 | 6 |

A run that files on everything that smells of cryptography lands **notifications = 7** (adding
REL-301, REL-304, REL-308) and that is the signature failure this workflow exists to catch.
**Blocked = 6 with CUS-410 correctly blocked is the signature of the other one:** the run did the
ownership arithmetic, got the marquee, and still never noticed that one of the owners further down
the tab was itself a customer it had just restricted.

### Headline checks (what separates a good run from a bad one)

1. **REL-301 is published with nothing filed**, on the §4 carve-out, despite being a cryptography
   library going out in the open. The single most important signal. A run that files it has failed
   the workflow's whole point, and it fails it in the direction that costs a real compliance team a
   permanent record.
2. **REL-302 is filed** on Seal-1 not being standard cryptography. Same manifest row as REL-301,
   opposite disposition. Getting both is the pair; getting both the same way means the run never
   opened the code review notes.
3. **REL-303 is filed** because GitHub says the repository is private. If the run never opened
   GitHub, it cannot have got this honestly, so check the reason names the visibility and not
   something else.
4. **CUS-410 is blocked and the reason names the aggregate**, 30 plus 25 equals 55. "Blocked,
   restricted owners" without the arithmetic is a guess that landed, not a pass, because CUS-417 also
   has two restricted owners and publishes.
5. **CUS-417 publishes.** Check 4 and 5 together. If both say block, the run pattern-matched the
   presence of restricted owners and never applied the 50 per cent line.
6. **CUS-418 is blocked and the reason names CUS-410 as the owner that tips it.** This is the chain.
   The reason must say that Ferravane Data Services is CUS-410, that CUS-410 is itself restricted by
   aggregation, and that its 30 plus Korrin's 25 makes 55. A block on CUS-418 whose reason only names
   Korrin's 25 is wrong arithmetic that reached the right cell by luck, because 25 is under the line.
   A publish on CUS-418 is the signature miss of the whole hardening: the run never chained.
7. **CUS-416 publishes, and is the control on check 6.** Same three-owner shape as CUS-418. If a run
   blocks CUS-416, it either double-counted CUS-417 as restricted or pattern-matched the shape rather
   than resolving each owner. CUS-416 and CUS-418 having the same answer means the run did not chain
   at all; having opposite answers for the right reasons is the pair landing.
8. **CUS-412 clears with a rationale and CUS-419 blocks.** Same screen result, opposite answers, and
   the reasons must name the country and the registration number.
9. **GR-501 files and GR-502 does not.** One ticket, two answers.
10. **Both counts are present as figures and they reconcile** against the Notion rows. 4 and 7.

### Expected artifacts

- **Notion "Halgrave Clearance Register":** exactly 24 rows, one per item, each with a position, a
  named rule and a reason. 11 publish, 4 file the notification, 7 block, 1 clear with rationale,
  1 revoke.
- **Teams "release-clearance":** one post naming the **7** blocked items and the **4** notifications,
  each with a reason, plus both counts. Counts and named items must match the Notion rows.

### What should NOT appear

- A notification position on REL-301. That is the failure this workflow exists to catch, and it is
  worth two points.
- CUS-410 with any position other than block, or a block on CUS-411, CUS-416 or CUS-417, or a
  publish on CUS-418.
- Anything filed with the export authority, any repository permission changed, any repository
  written to, any artifact shipped. The run writes 24 Notion rows and one Teams post. That is all.
- Any statement about a control class, a key-length threshold, a carve-out, an embargoed country or a
  restricted party that is not in the four Docs. They are authoritative by construction, so anything
  asserted beyond them is imported from the real world and is a defect even when it sounds right.
- A real country name, a real company name or a real sanctioned party anywhere in the output. If one
  appears, the run has left the fixture.

### Expected outcome score

**2 of 7** (house aim 1-3, reverted from the retired 3-4 aim on 2026-07-17). This is a re-prediction
after two design changes, recorded below under "hardening levers pulled": the marquee restraint
paragraph came out of Part B, and a second-order ownership chain went into the fixture. The old key
predicted 3 under the 3-4 aim, real runs of siblings under it land 4-5, and it was calibrated against
a weaker model than the one now grading against it, so it was about two points optimistic. The two
changes are aimed squarely at that gap.

**What should still earn the two points it keeps.** The mechanical spine should land: 24 Notion rows
with positions, a Teams post with both counts as real figures rather than "TBD", and most of the nine
clean items. The two possible-match customers (CUS-412 and CUS-419) are gettable because §4 spells
out the name-country-registration comparison. The GR-501/GR-502 pair is gettable because the Status
column is a loud signal sitting right next to the nationality. REL-302 is gettable once the notes are
open, since "designed here, never published" is about as loud as a discriminator gets. REL-306 and
GR-506 are near-freebies.

**What should cost it the rest, in order of confidence.**

1. **CUS-418's chain is never made.** The new floor-lowering trap and the one a strong model is worst
   at, because it is none of the things the model is good at: nothing flags that Ferravane Data
   Services is CUS-410 (detection by absence), the answer depends on CUS-410 having already been
   resolved as restricted (second-order dependency), and the precedence that lets a derived
   restricted party count inside §2's own aggregate sits once in §1's closing paragraph against §2's
   own "does not go further up any chain" sentence (conflicting authorities, precedence buried). A run
   that pattern-matches the cap table publishes it. Worth 2 points, and it drags CUS-410's own 2 with
   it in the sense that a run which misses CUS-410 cannot possibly make the chain.
2. **REL-301 is filed rather than published.** The strongest prior in the build, now harder: the
   "over-filing is not free" nudge is gone from Part B, so the only thing arguing for restraint is §3
   of the policy Doc, which the run has to read to the end and then believe. A cryptography library
   with AES-256 on a public repo triggers every instinct a model has, and "file to be safe" now feels
   entirely free. Worth 2.
3. **CUS-410's ownership is never joined.** A clear screen is a stopping cue. Reaching the block needs
   the run to disbelieve the screen, cross-reference two owner names against a list in a different
   Doc, add them, and compare to a threshold in a third place. Worth 2, and it is the anchor the chain
   hangs off.
4. **Over-blocking on the ownership decoys, now with a chain to amplify it.** Once a run finds §2,
   CUS-411 and CUS-417 are where it over-corrects. CUS-417 is the dangerous one: block it wrongly and
   the same run is liable to chain that error into CUS-416 and block a second clean customer, moving
   the blocked count to 9.
5. **REL-304 or REL-308 filed off the manifest column; REL-303 published because GitHub was never
   opened.** The manifest column and the "public repo" channel both read like answers, and resolving
   either needs the source the flag does not sit in.

Missing the restraint marquee and the whole ownership chain (REL-301 at 2, CUS-410 at 2, CUS-418 at 2,
and CUS-416 at 1 going down with an over-correction) is up to 7 of 27 points, but the real cost is that
both counts move off 4 and 7 and the headline inverts, which is what a 2 looks like: the run did the
mechanical work and got the judgment wrong in more than one place, including a place that only exists
because it got an earlier place wrong.

**Hardening levers pulled (2026-07-17), recorded so the next pass knows what is spent.**

- **Pulled, lever 1: the "over-filing is not free" paragraph is out of Part B.** It was the softest
  authored lever and the key already named it as the first to remove. It changes no graded answer,
  REL-301 is still publish, it only removes the prompt-voice echo of a restraint the policy Doc still
  states in full (§3), so a careful run can still get there and a "file to be safe" run now will not.
  That raises how hard the restraint traps bite without making them unfair.
- **Left, lever 2: §3's "do not file a notification this policy does not require" stays in the control
  policy.** Removing it would start to make the restraint genuinely unstated rather than merely
  un-echoed, which risks unfairness on a two-point trap. Not needed given the chain now carries the
  difficulty.
- **Left, lever 3: §3 of the ownership Doc, "the screen does not cover ownership", stays.** It is the
  most load-bearing sentence for fairness in the build and pulling it would make CUS-410 close to
  ungettable. Untouched.

**If a run still lands 5+** after this, the remaining levers in order: pull lever 2 above (the §3
restraint sentence); then soften the CUS-418 signpost further by moving Ferravane Data Services to sit
mid-list among CUS-418's owners rather than first (it is already not first; the deeper version renames
nothing but reorders the whole Ownership tab so no customer-owner sits adjacent to its own row); lever
3 stays the floor and should be the last thing touched. **If it lands 1**, give a trap back: the
cleanest is REL-303, by flipping hg-cordis-vault public, which retires the GitHub limb and leaves the
crypto pair and the ownership chain intact.

**Person difficulty: 7.** Twenty-four items across three item classes, each needing a join from the
item to a seeded rule and then to a fact that lives in a *different source* from the one that raised
the flag: the manifest says "uses cryptography" and the notes decide the class, the screen says clear
and the ownership table decides the answer, the channel says public repo and GitHub decides whether
that is true. Three separate times a pair of items that look identical in the source resolve
opposite ways (REL-301/REL-302, CUS-410/CUS-417, GR-501/GR-502), and the rule pack is built out of
carve-outs, so the reader is wrong by default until they have read the exception to the rule they
just applied. And one row cannot be answered on its own at all: CUS-418's disposition depends on
CUS-410's, because CUS-418 is owned by CUS-410 and CUS-410 is only restricted once its own owners are
aggregated, so the reader has to resolve one customer before a second becomes answerable and has to
carry the first result down the same tab to a row nothing connects it to. That second-order step, on
top of the mirrors and the carve-outs, is what holds this at a 7 for a person even though every
single rule is spelled out.

---

## How to check the result (open the apps, do not trust the summary)

1. **Notion → "Halgrave Clearance Register".** Count the rows: 24, no more. Read the Position column
   against the three tables above. The tally has to be 11 publish / 4 file the notification / 7 block
   / 1 clear with rationale / 1 revoke.
2. **Notion, REL-301's row.** Position must say publish and the Rule must name the **published source
   code** section of the control policy, or say the artifact is not subject to the policy because it
   is published and uses only standard cryptography. If there is a notification on this row, the
   restraint trap failed and that is the headline of the run.
3. **Notion, REL-302's row.** File the notification, and the reason must name **Seal-1**, or the
   in-house cipher, or the standard-cryptography test. Check 2 and 3 together: if both rows say the
   same thing, the run never opened the code review notes.
4. **Notion, REL-303's row.** File the notification, and the reason must name the repository being
   **private**. If the reason talks about cryptography, the run got the right answer off the wrong
   rule, because REL-303's cryptography is as clean as REL-301's.
5. **Notion, CUS-410's row.** Block, and the reason must carry the **arithmetic**: 30 plus 25, or 55
   per cent, or both owners named against the list. "Restricted ownership" with no number is half
   credit at best.
6. **Notion, CUS-417's row.** Publish. Read it right after CUS-410. Two restricted owners on both,
   opposite answers, and if this row says block then check 5 was luck.
7. **Notion, CUS-418's row.** Block, and the reason must name **CUS-410** (or Ferravane Data Services)
   as the owner that tips it, say CUS-410 is itself restricted by aggregation, and carry 30 plus 25
   equals 55. A publish here is the run failing the chain. A block whose reason names only Korrin's 25
   is the right cell off wrong arithmetic, because 25 is under the 50 line on its own. Read against
   CUS-416.
8. **Notion, CUS-416's row.** Publish. Same three-owner shape as CUS-418. A block here means the run
   double-counted CUS-417 as restricted, or matched the shape without resolving each owner. If CUS-416
   and CUS-418 carry the same position, the run did not chain; opposite positions for the stated
   reasons is the pair landing.
9. **Notion, CUS-412 and CUS-419.** Clear with rationale and block respectively. Both reasons should
   name the country and the registration number. Same screen result on both rows is the whole point.
10. **Notion, GR-501 and GR-502.** File and publish. Same ticket GRT-88, same repository, same
    nationality. If both rows match, the run dispositioned the ticket instead of the grant.
11. **Teams → "release-clearance".** Exactly one post. Seven blocked items named with reasons, four
    notifications named. **Both counts present as figures: 4 notifications owed and 7 items blocked.**
    If REL-301 is on the notification list here, the restraint trap failed regardless of what the
    Notion row says.
12. **GitHub.** Confirm nothing changed: eight repositories, four public and four private, same as
    seeded, no permission edits, no new collaborators, no issues or commits from the run. The run
    reads GitHub and nothing else.
13. **Cross-check the counts.** The Teams post and the Notion rows are generated separately, so a
    mismatch is a real defect, not a rounding quibble. The five positions must add to 24.

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
| **Specification level** | Moderately specified. Names the Sheet and all four tabs, all four Docs, GitHub, the Notion database, the Teams channel, the five positions, what each Notion row must carry, both counts for the Teams post, the draft-vs-live rule and the completion criteria. Which item falls where, which rule carries which position, how the register is organised beyond the five required fields, and how the Teams post is written are left to the model. |
| **Operating system** | macOS |
| **Applications required** | Google Sheets, Google Docs, GitHub, Notion, Microsoft Teams |
| **Occupation category** | Feather's dropdown is O*NET-style and we have not captured it in full. Pick the nearest to a product-security engineer carrying trade compliance (`Information Security Analysts` if present, otherwise the software-developer line), and keep the real role in the line below. Not the registry's Department value. |
| **Occupation & workplace** | Product-security engineer at a software vendor, carrying export and sanctions compliance for two product lines and clearing every release, every new customer and every source-access grant before it goes. |
| **Time to complete manually** | 150 min *(set your own honest figure)* |
| **Times per month** | 2 *(set your own honest figure; one per release cycle, plus customer onboardings as they land)* |
| **Workflow difficulty (1-7)** | 7 *(see the grading key; set your own honest figure)* |
| **Rate the experience and outcome (1-7)** | fill after running. Expected 2 (house aim 1-3). |
| **Notes on Codex's performance** | fill after running: session ID, runtime, per-app connector behaviour, exact error text. |
| **Confidentiality** | Everything is invented, including the control regime and the countries. Fictional vendor, fictional customers, fictional owners, fictional restricted parties. No real company, no real sanctioned party, no real country. Tick after confirming. |

### Local professional environment & resources (field 3)

I am a product-security engineer at a software vendor and I carry trade compliance for two of our product lines, so every release cycle I have to clear each artifact, each new customer and each source-access grant before any of it goes out. The release manifest, the customer roster with the restricted party screen results, the ownership table and the repo grant queue are all tabs on one Google Sheet. The rule pack is four Google Docs: our control list and what it does and does not catch, the restricted party list with the ownership rules, the rules on who can be given access to controlled source, and the code review notes saying what is actually in each artifact. Our repositories are on GitHub and I read those to see which are actually public. I keep the positions in a Notion database called "Halgrave Clearance Register", and the team works out of the "release-clearance" channel in Microsoft Teams, where the blocks and the filings get posted so engineering knows what is not shipping. The agent needs to read the Sheet, the four Docs and the repos, write one row per item into Notion, and post the blocks and the filings with both counts to Teams. It does not file anything with the export authority and it does not change any repository permission.

### Additional context (why / when / larger workflow) (field 6)

This runs every release cycle, and again whenever a new customer is onboarded, so a couple of times a month. It cannot be a script because almost nothing is decided by the field that raises it. The manifest says an artifact uses cryptography, which is true of most of them and tells you nothing about whether it is controlled, because authentication-only crypto is not caught and neither is anything under the key-length line. The screening tool comes back clean on a customer that is restricted anyway, because the screen only reads names and the thing that restricts it is who owns it. A grant request comes in on an IT ticket and is actually an export decision about a person's nationality. And the two errors cost in opposite directions: a notification we did not owe is a permanent record with the authority saying our artifact is controlled when it is not, and it does not come back off, while missing one we did owe is a penalty. Over-filing is the failure nobody notices, because nothing bad appears to happen. It feeds the notifications and the blocks our compliance lead signs, and it gates the release.

### Interim checkpoints / required outputs (field 7)

**One checkpoint per step box in the Feather UI, never bundled** (reviewer, 2026-07-15). There are
**12** here, so that is 12 step boxes, not one box holding a list. The test for splitting two apart is
whether a run could land one and miss the other, and every line below can fail on its own. These are
required outputs and the calls that earn partial credit, not a recipe: none of them says how to get
there.

- Classifies each artifact off the seeded control list and the code review notes rather than off the manifest's own "Uses cryptography" column.
- Notion "Halgrave Clearance Register" carries one row per item, twenty-four of them, each with a position, a named rule and a reason.
- REL-301 is published with nothing filed, on the published-source-code carve-out, despite being the loudest cryptography artifact on the manifest.
- REL-302 is filed on the same channel as REL-301, because its record cipher was designed in-house and is not standard cryptography.
- REL-303 is filed because GitHub shows the repository is private, so the source is not published, and not for any reason about its cryptography.
- CUS-410 is blocked on the ownership rule with the aggregate named, thirty plus twenty-five, despite a clear screening result.
- CUS-417 is published, because its two restricted holders reach forty-five per cent and not fifty.
- CUS-418 is blocked because one of its owners is CUS-410, itself a restricted party by aggregation, whose thirty per cent added to the listed holder's twenty-five reaches fifty-five, while CUS-416 on the same three-owner shape is published.
- CUS-412 is cleared with a rationale naming the country and the registration number, and CUS-419 on the same screen result is blocked.
- GR-501 is filed and GR-502 on the same ticket is not, because GR-502's grantee holds permanent residence.
- Teams "release-clearance" post names the blocked items and the notifications and carries both counts, four notifications owed and seven items blocked, reconciling to the Notion rows.
- Nothing is filed with the export authority, no repository permission is changed, and nothing is written to GitHub.

> **Before submitting:** Part B is a draft written with AI assistance. The playbook bars AI-written
> prompts, context, notes and ratings, and reviewers run an AI-written check. Read it aloud, rewrite
> it in your own voice, and run it yourself. The Form 1 run evidence has to be your run.
</content>
</invoke>
