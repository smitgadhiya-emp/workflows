When engineering pins a ship date to a release, the clearance work lands on me. I carry trade compliance for the Cordis and Harrier lines at Halgrave Systems, both lines are down for 24 July, and the Q3 cycle has to clear before any of it moves. I'm writing this on Thursday 16 July 2026 (IST), so that's the week I've got.

Everything waiting on me is in one Google Sheet, "Halgrave Release Clearance - Q3 2026 Cycle", spread over four tabs. "Release Manifest" is the artifacts going out this cycle, one row each, with the repository it builds from, which channel it is meant to go out on, whether it uses cryptography, who built it and the target date. "Customers" is the customers waiting on the release, with each one's country, its registration number, and what came back on the restricted party screen. "Ownership" is who owns each of those customers and what share they hold. "Repo Grants" is the source access requests sitting in the queue, with the repository, the grantee, their nationality, any status they hold, and whether the access is already live.

I need exactly one position on every row of "Release Manifest", every row of "Customers" and every row of "Repo Grants". Five to pick from, one per item. Publish means it goes out, or the access stands as it is, and nothing is owed on it. File the notification means it can go but a notification is owed to the export authority first. Block means it doesn't go out, or it doesn't go to them. Clear with rationale is where something flagged and it turned out not to be what it looked like, so you write down why and let it through. Revoke is where access is already live and has to come off.

What decides any of that is four Google Docs. "Halgrave - Export Control Policy" has the control list, what counts as cryptography for it, when a notification is owed, and which channels a class can go out on. "Halgrave - Restricted Party List and Ownership Rules" has the restricted party list itself and the rules for who counts as restricted. "Halgrave - Repo Access and Deemed Export Rules" covers source access. "Halgrave - Code Review Notes" says what each artifact actually does and what cryptography is actually in it, keyed by artifact. Those four are the rulebook for this exercise and they beat anything you know about export control or sanctions generally. Our repositories are on GitHub, and that is where you can see which ones are actually open to the public and which ones are private. Read GitHub, don't write to it.

The whole cycle goes into the Notion database "Halgrave Clearance Register", one row per item, carrying at least the item's ID, whether it is an artifact or a customer or a grant, the position, the rule you relied on named by its document and section, and a one-line reason. Set the rest of the row up however works best for reading it back. Then post to the Microsoft Teams channel "release-clearance", for real: everything you are blocking and everything we are filing a notification on, each with its one-line reason, plus how many notifications we owe in total and how many items are blocked in total. Both as counts, not ranges.

Devika Ranganathan is our export compliance lead and she signs every notification and every block, so nothing gets filed or changed until it has been in front of her. Don't file anything with the export authority yourself and don't change a permission on any repository. Where the position comes out as file the notification, or as revoke, the Notion row saying so is all I need from you and Devika's team takes it from there.

Anything that won't open for you, the Google Sheet, one of the four Google Docs, GitHub, the Notion database, the Teams channel, say which one and stop there. Don't let anything rest on what you reckon a rule probably says, or on what you'd expect to be in a repository you haven't opened. If the rulebook doesn't reach something you need for an item, mark that row and say what's missing.

I'll take the cycle as cleared when every artifact, every customer and every grant has a Notion row with a position and a named rule on it, the Teams post carries what's blocked and what we're filing with both counts, and those counts reconcile against the Notion rows.


Metadata:

1. Occupation / career (dropdown choice):
-> Software Developer
2. Occupation + workplace (one line, this is the persona voice):
-> Product-security engineer at a software vendor, carrying trade compliance for two product lines and clearing each release cycle under export and sanctions rules.
3. Time to complete this workflow WITHOUT a model (minutes):
-> 150 minutes  
4. Times PER MONTH I run this workflow (decimal ok, 0.5 = every 2 months):
-> 2
5. Workflow difficulty 1-7 (1 easy, 7 hard):
-> 7