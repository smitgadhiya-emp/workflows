Model - A 

Sesstion ID :  019f7f0e-061e-7b01-9b1e-d018362c65e0

1. Overall task success — 4/7

Most of this is right and two things I specifically warned about went wrong. It cataloged all 20 files, kept the shortcut file as one id instead of two rows, wrote 47 chunks, built 7 routing domains, answered all 15 questions, and the ledger actually ties. The staleness work is the best part: every flag is correct, both boundary cases landed right (Benefits Summary on 2026-04-17 fresh, Expense Policy on 2026-04-16 stale), and it caught the Sales Playbook wrinkle where the stated date is 2026-07-05 but the body says content unchanged since 2025-11. Where it fails is the blind spots. It reports "0 are inaccessible" in bold at the top of the Teams post, when Remote Work Policy is the one file the workspace account cannot actually read, and it filed that as unparsed instead. And it refused to index Feature Spec: Checkout V2 at all because the file states no update date, so a perfectly readable document became a blind spot and Q7 dropped a confidence band. 14 files indexed where it should be 15. 

2. Task accuracy, ignoring speed — 4/7

The reconciliation holds: 20 found equals 14 indexed plus 4 unparsed plus 0 inaccessible plus 2 out of scope, the catalog chunk counts sum to exactly the 47 in Mongo, and the shortcut file is not double counted. Per type parsing is real, not flattened, chunks carry section, tab, slide and page markers, and the no stated date files are marked "unknown, no stated date" rather than back-filled from the Drive timestamp, which is exactly what I asked. Confidence spread came out 6 High, 4 Medium, 5 Low, and the 6 High are the right 6. The Medium and Low counts are off by one, and it traces straight back to Checkout V2 not being indexed. Two accuracy problems then: that file should be indexed with its date field flagged, not dropped for having incomplete metadata, and Remote Work Policy belongs in the inaccessible bucket. Both feed the same downstream number, so my unknown coverage list has an entry on it that should not be there.

3. Efficiency — 4/7

End to end time (minutes): 22 

One, and it was avoidable. It quit 83 seconds in saying MongoDB was unreachable because no connector existed, when my prompt says in the first paragraph to use the existing Chrome session if it helps. It never opened Chrome before declaring the system unavailable. Once I pointed at it, the Atlas preflight passed on the first try.

After the restart it moved in a straight line, inventory, parse, reconcile, index, tracker, post, with no thrashing and no dead ends. Twenty two minutes against a ten hour manual build is the whole reason I want this working. But stopping on a system the prompt told it how to reach is not a judgment call, it just did not read to the end before quitting.

4. Writing quality — 4/7

The Teams post is genuinely well built. Blind spots at the top with a warning marker, each one named with the file and the reason, then the summary numbers underneath, and the tracker link at the bottom. That is exactly the shape I asked for and it is skimmable. Two problems. Em dashes in nearly every line, which does not read like me. And the sheet is unstyled, the header row on the catalog tab is plain text with no bold and no fill, so with 11 columns and 20 rows I have to keep counting across to work out which column I am in. The content is fine, the presentation of the artifact I actually live in is not.

5. Instruction following — 4/7

Good on most of it: walked every subfolder, cataloged all four types, counted the two out of scope files so the numbers add up, read stated dates from the right places (Last-Updated lines, slide 1 notes, the _meta tab), edited the tracker in place on file id, and left the human owner values alone, eng-backend-team and product-team both survived. Three misses. I said if a file is unchanged since a previous run, leave its chunks alone, and it went in and rewrote the retained API Authentication chunks to add provenance fields. I said an inaccessible file gets counted as inaccessible and it reported zero. And it treated the complete metadata rule as a reason to drop a whole document rather than to flag one missing field, which is the opposite of the intent, since I would rather have the content with a loud "no stated date" than nothing at all.

6. Collaboration, autonomy, and verification — 3/7

Steering needed: One, and it was the annoying kind. Not an ambiguous problem, it just did not try the path the prompt named before handing the task back to me.

Additional editing before I would use it: Index Checkout V2 and rerun Q7, move Remote Work Policy to inaccessible and redo the blind spots section, drop the extra unknown coverage row, style the sheet headers, rewrite the post without the em dashes.

Verification after the restart was decent. It checked the catalog chunk total against Mongo, confirmed 20 catalog rows, confirmed 15 question rows with none dropped, and confirmed the owner assignments survived. What it did not do is question its own classifications, so the two files it put in the wrong bucket sailed through untested, and it never went back to ask why a readable document ended up unindexed.

7. Citation quality — 6/7

Strong. Every chunk in Mongo carries file id, title, type, folder path, stated last updated and a position marker, and the stable id is built from file id plus date plus position, so I can see the idempotency scheme rather than take it on faith. Answers cite their source documents with paths and stated dates, and the catalog names the specific file behind each blind spot. One nit: the retained chunks and the newly written ones have different field shapes, the older ones keep the seeded metadata layout while the new ones carry top level author, created date and staleness fields, so the collection is not uniform and a filter by author will miss part of that document.

8. GUI action correctness — 5/7

It drove Chrome into the Atlas Data Explorer and did real work there, and the end state is correct: knowledge_base holds 47 chunks and 7 routing domain records, the domain docs carry folder paths, document sets and a derived-from note, and the stale component records were replaced rather than duplicated. So the target state landed. What keeps it mid is that the same UI path was the thing it initially declared unreachable, and the mixed document shapes suggest the retained records were updated through a different route than the new ones rather than one consistent import.


=======================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=======================================================================================

Model - B

Session Id : 019f7f3e-a518-76f2-b531-c9f8b7fae28f

1. Overall task success — 4/7

Same shape of result as the last run, built better underneath, and it trips on the same two things. It cataloged all 20 files, wrote 47 chunks, answered all 15 questions, and the ledger reconciles. The routing layer is a clear step up: 8 domains derived from evidence rather than just folder names, including a Security and Privacy domain pulled out of what the Security Best Practices doc actually covers, plus a separate routing policy record that encodes the multi domain and no match rules in the collection itself. That means the GDPR question can genuinely route to two domains instead of being forced into one. Where it fails is the part I said I cared most about. It reports "0 inaccessible" and files Remote Work Policy as unparsed, when that file is permission blocked, not empty. And it refuses to index Feature Spec: Checkout V2 because the file states no update date, so a readable document becomes a blind spot and its question drops a band. 14 indexed where it should be 15.

2. Task accuracy, ignoring speed — 5/7

The numbers hold and the detail work is good. 20 found equals 14 indexed plus 4 unparsed plus 0 inaccessible plus 2 out of scope, the chunk breakdown by type sums to the 47 in Atlas, and every stale flag is right including both boundary cases and the Sales Playbook wrinkle where the stamp says 2026-07-05 but the body says unchanged since 2025-11. The stale flag column carries its reason rather than a bare yes or no, which is what I would have written myself. It also went and checked the Engineering/Backend/Security branch and reported it empty rather than assuming, and it kept the no stated date files as "not stated" instead of back filling from the Drive timestamp. The two bucket errors are what hold it here, and one smaller thing: three of the Sheets rows carry a team name in the author column while everything else carries a person.

3. Efficiency — 4/7

End to end time (minutes): 15 

Wrong actions / recovery: One, and it was avoidable in exactly the same way as the previous run. It stopped 62 seconds in saying MongoDB was unreachable because no connector action was exposed, when the first paragraph of my prompt tells it to use the existing Chrome session. It never opened Chrome before handing the task back. Its stop message was at least honest about not being able to tell absent from inaccessible, but it should not have been at that gate at all.

After the restart it was clean and fast, no thrashing, and it carried on through a context compaction mid run without losing the thread or repeating work. Fifteen minutes for something that costs me a full day is the point of this, and the only lost time is the part I had to unblock.

4. Writing quality — 4/7

The Teams post is the right shape. Blind spots at the top with the marker, each file named with the reason, then the reconciliation line, the chunk split by type, the question spread, gaps, and staleness, with the tracker link at the end. Short enough to actually read. Two things pull it down. The sheet header row is still plain text with no bold and no fill, so on an 11 column catalog I keep counting across to find the column I want, and that is the artifact I spend the most time in. And there are still em dashes through the post, including the title.

5. Instruction following — 4/7

Strong on the routing and cataloging rules: multi domain questions route to both, no match routes to the whole corpus and gets flagged Low, domains say what they were derived from, out of scope types are counted, the tracker is updated in place on file id, and the human owner values survived on both seeded rows. Four misses. It reported zero inaccessible. It dropped a readable file from the index rather than flagging one missing field, which inverts the intent, since I would rather have the content with a loud "no stated date" on it. It did not try the Chrome path the prompt named before stopping. And I said leave the chunks of an unchanged file alone, while it replaced the entire prior collection wholesale. I can see why, the prior records were missing metadata, and the upside is that all 47 chunks now share one schema, but the leave alone behavior is now untested and I asked for it specifically.

6. Collaboration, autonomy, and verification — 4/7

Steering needed: One, the same preventable kind. Nothing ambiguous about it, the prompt named the path it did not try.

Additional editing before I would use it: Index Checkout V2 and rerun its question, move Remote Work Policy into inaccessible and redo the blind spots section, drop the extra unknown coverage row, style the sheet headers, check the author column on the three Sheets rows.

Verification was the better part of this run. It read the tracker back after writing, confirmed the Atlas counts directly in the Data Explorer, checked the deeper folder branch instead of assuming, and explicitly chose to reconcile against the live collection rather than trusting the prior state was correct. What it did not do, same as every run on this task, is go back and challenge its own bucket calls, so the two files in the wrong bucket were never retested.

7. Citation quality — 6/7

Well grounded. Every chunk carries file id, title, author, folder path, document type, stated last updated, position and a staleness note, and the ids are stable and derived from file plus version plus position so the dedup scheme is visible. The routing domains cite their evidence in a derived-from line and list the specific document ids and titles they cover, and several carry an explicit unparsed or out of scope candidate list, which is exactly the linkage I need to defend an unknown coverage call. The answers tab names sources with paths and dates. Only nit is that author column inconsistency, since author is one of the fields I want to filter on later.

8. GUI action correctness — 5/7

It drove Chrome into the Atlas Data Explorer and the end state is correct: 47 documents in chunks, 9 in routing_domains, stale prior records removed rather than left alongside the new ones, and it left the tab open where I could check it. The documents it wrote are uniform, which is easier to query than a half migrated collection. What keeps it mid is that this same UI path was the thing it declared unreachable at the start, so the one GUI decision it made unprompted was the wrong one.



=======================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=======================================================================================

Model - C

Session Id : 019f82fe-da14-7131-a4fc-096420db0c20


1. Overall task success — 3/7

The index it built is the best of the three so far and getting it out of the model cost me two interventions. On substance: 20 files cataloged, 50 chunks, 7 domains, all 15 questions answered, ledger reconciles, and it is the only run to track Sheets per tab the way I asked, which is why it has 50 chunks and the others have 47. It is also the only one to land on 1 confirmed gap rather than inflating the list. Against that, it repeats both errors the other runs made: Remote Work Policy goes into unparsed and it reports "Inaccessible: none. Every discovered file was reachable", when that file is permission blocked, and Feature Spec: Checkout V2 is marked unparsed and excluded from Mongo purely because it states no date, even though the run itself describes it as readable. Then the process cost: it stopped at preflight, I told it to use Chrome, it came back saying the session was signed out, and I had to tell it to look again before it found the authenticated profile. Twenty six minutes and two corrections for a run that should have been unattended.

2. Task accuracy, ignoring speed — 5/7

Strip the stalls out and the work is careful. Ledger ties at 20 equals 14 plus 4 plus 0 plus 2, the 50 chunk ids are verified unique, and every stale flag is right including Benefits Summary on the cutoff reading fresh, Expense Policy one day earlier reading stale, and the Sales Playbook stamp that says 2026-07-05 while the body says unchanged since 2025-11. Per type parsing is real and the Sheets are split by tab, which none of the other runs did. Author attribution is uniform across all 20 rows and the log shows it explicitly resolving revision attribution so no chunk gets a fabricated author, which is exactly the discipline I want. Two accuracy problems beyond the shared bucket errors. Checkout V2 is labeled unparsed when it parsed fine, so the catalog says something untrue about that file. And 4 unknown coverage entries is too many, an unknown coverage row is supposed to name a blocking file that could plausibly cover the topic.

3. Efficiency — 3/7

End to end time (minutes): 26 

Wrong actions / recovery: Two, and both were on the same dependency. 

It stopped 82 seconds in saying MongoDB was unreachable, when the prompt tells it to use the existing Chrome session. When I pointed at Chrome, it opened one tab, saw a logged out page, and handed the task back again. Only after I told it I could see the session did it check other Chrome profiles and find the authenticated one. The second failure is a partial credit case. Finding that the live Atlas session was in a different Chrome profile is a genuinely subtle recovery and I would not have thought of it either. But it took two rounds to get there, and the first stop should never have happened, because the prompt named the path. Once it started, the actual run was clean and linear with no thrashing.

4. Writing quality — 3/7

The Teams post is the weakest of the runs so far. It is one dense block of text with bullet characters wedged mid sentence, no headings, no separation between the blind spots and the summary, and nothing visually marked. The blind spots are technically first, which is what I asked, but they do not stand out at all, and that section exists precisely so nobody scrolls past it. Em dashes throughout as well. The sheet has the same header problem as the other runs, plain text with no bold or fill, so an 11 column catalog is harder to read than it needs to be. The content is complete and accurate, the delivery is not.

5. Instruction following — 4/7

Good on most of the corpus rules: walked every subfolder including the empty Security branch and reported it rather than assuming, cataloged all four types with precise type labels, counted the two out of scope files, read stated dates from the right places, wrote "Not stated" instead of back filling from the Drive timestamp, kept each Sheet tab separate, updated the tracker in place on file id, and left both human owner values alone. The misses are the familiar ones plus one more. It reported zero inaccessible. It excluded a readable document rather than flagging the one missing field. It did not try the Chrome path the prompt named before stopping. And I said leave the chunks of an unchanged file alone, while it deleted the whole prior set and rewrote 50 fresh ones, so the leave alone behavior was never exercised.

6. Collaboration, autonomy, and verification — 2/7

Steering needed: Two, and the second was the bad kind. The first was the same avoidable preflight stop everything else made. The second had me telling it that it was wrong about the state of my own browser, and it took that push to go look properly. That is two rounds lost before any work started.

Additional editing before I would use it: Move Remote Work Policy to inaccessible and redo the blind spots, index Checkout V2 and fix its parse status, trim the unknown coverage list down to the topics with a real blocker, restyle the sheet headers, and rewrite the Teams post entirely.

Verification once it got going was solid. It confirmed the 50 chunk ids were unique, reconciled the ledger, read the tracker back, preserved owners, and deliberately confirmed the prior collection mixed current and obsolete versions before clearing it rather than deleting blind. But it never revisited its own bucket calls, and it labeled a file unparsed in the same run where it described that file as readable, which a second pass should have caught.

7. Citation quality — 6/7

Strong and specific. Chunks carry file id, title, author, folder path, document type, stated date, version, a position marker and a staleness reason, with stable ids built from file plus version plus position. The routing domains are the best structured of the runs: each one carries its folder paths, document sets, file ids, routing signals, an embedded routing policy, and separate arrays for indexed, unknown coverage and out of scope file ids, so the blind spots are wired into the router itself rather than living only in the report. The answers tab gives each question its source path, stated date, confidence and a reason when confidence is Low, which is exactly what I asked for.

8. GUI action correctness — 4/7

It drove Chrome into Atlas and the end state is correct, 50 chunks and 7 domain records, obsolete documents deleted rather than left alongside, and the counts verified in the Data Explorer afterward. The problem is the path there. It reported the session as signed out when it was not, because it only checked the tab it opened rather than the profiles available to it, and I had to push twice before it looked properly. Correct final state reached through a rough route, and the one profile check that mattered only happened under instruction.



=======================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=======================================================================================

Model - D

Session Id : 019f8326-0b03-7f03-a275-b2794faba311

1. Overall task success — 3/7

The artifacts are the most useful of the four and it took two corrections from me to get there. It cataloged all 20 files, wrote 50 chunks with Sheets split per tab, built 7 domains, answered all 15 questions, and the ledger reconciles. The catalog is the standout: it added a parse detail column that says per row exactly why a file landed where it did, down to "Image-only one-page scan; extraction returned no text layer. Visual review confirmed pixel labels, not extractable PDF text", and it actually opened that image to confirm rather than trusting the extractor. That is the level of evidence I want behind a blind spot call. Two failures pull it down. It reports "Inaccessible files: 0. Every discovered file was reachable" when Remote Work Policy is permission blocked, same as every other run. And it excluded the readable Checkout V2 spec from the index for having no stated date, then did not carry that blind spot into the gap analysis at all, so a file it blocked from indexing shows up in the blind spots section and then vanishes from the coverage picture. That is the exact "unparsed is unknown coverage, not absent coverage" rule I wrote the prompt around.

2. Task accuracy, ignoring speed — 5/7

Very thorough. 20 equals 14 plus 4 plus 0 plus 2, the 50 chunk ids are verified unique with no missing required metadata, and Sheets are chunked per tab with the cell range recorded, which only half the runs did. Every stale flag is right, including the cutoff boundary in both directions and the Sales Playbook whose header says 2026-07-05 while its maintenance note says content unchanged since 2025-11. It also reports 5 possibly outdated sources rather than 4, splitting out the four with dates before the cutoff from the playbook that is stale by content, which is more honest than a flat count. Authors are uniform and drawn from revision attribution rather than guessed. Two accuracy problems on top of the shared inaccessible error: the Checkout V2 blind spot never reaches the gap tab, and the created date column carries full ISO timestamps instead of dates, which is noise in a column I read at a glance.

3. Efficiency — 3/7

End to end time (minutes): 13

Wrong actions / recovery: Two, both on the same dependency. It stopped at preflight saying MongoDB was unreachable, when the first paragraph of my prompt tells it to use the existing Chrome session. When I pointed at Chrome, it came back saying the only exposed tab was a non-claimable Google sign-in page and asked me to open Atlas, which was already open. Only after I pushed a second time did it work out that two Chrome extension instances were connected and switch to the profile that had the live session.

The diagnosis on that second recovery is the best of any run, it named the actual cause rather than just retrying. But it still took two rounds before any work started, and the first stop should not have happened. Once running, the 11 minutes of real work were clean and linear.

4. Writing quality — 5/7

The best summary of the four. Blind spots at the top with an explicit "do not treat these as absent coverage" line, each file named with its full path and the reason, then a clean inaccessible line, then index results, then questions and gaps, then the tracker link. Real sections, real bullets, and it takes about twenty seconds to read. The catalog is also the most readable of the runs because of the parse detail column. Two problems. Em dashes everywhere in the post. And the sheet header row is still plain text with no bold and no fill, which on a now 13 column catalog is worse than it was on 11.

5. Instruction following — 4/7

Good coverage of the rules: full recursive walk, all four types, out of scope counted, stated dates read from the right places with "not stated" where there is none, Sheets tracked per tab, tracker updated in place on file id with both human owner values preserved, blind spots first in the post, and the routing rules encoded in the collection with multi domain routing on and a defined fallback for unmatched questions. Four misses. Zero inaccessible reported. A readable file dropped from the index rather than flagged on one field. The unparsed bucket not carried through to the gap analysis. And I said leave an unchanged file's chunks alone, while it deleted all six legacy records and rewrote 50, which is a defensible call given the old records failed the metadata contract, but it means that behavior was never demonstrated. It also left a build script behind in the workspace.

6. Collaboration, autonomy, and verification — 2/7

Steering needed: Two. The first was the avoidable preflight stop every run made. The second had me telling it to check properly when it insisted Atlas was not open, which it was. Two rounds lost before any work started.

Additional editing before I would use it: Move Remote Work Policy into inaccessible and redo the blind spots line, index Checkout V2 or at minimum park its topic as unknown coverage with the file named, style the sheet headers, clean the created date column, strip the em dashes.

Verification is where it earns points back. It confirmed the chunk batch had 50 unique ids and zero missing required fields before inserting, counted the collection afterward, read the tracker back, confirmed the owner values were still attached to the right file ids, and visually inspected the scanned PDF instead of taking the empty extraction at face value. It also noticed the seeded tracker counts did not reconcile and explicitly refused to treat them as truth. What it did not do is reconcile its own blind spot list against its own gap list, which would have caught the Checkout V2 hole immediately.

7. Citation quality — 6/7

Strong. Chunks carry file id, title, author, folder path, document type, stated date, source version, position marker and staleness reason, with stable ids built from file plus version plus position. Domain records carry their folder paths, document sets and a derived-from line, plus the fallback and multi domain flags. The catalog's parse detail column is effectively a citation for every classification, and the answers tab gives each question its route, dated sources, confidence and the reason when confidence is Low. The one thing keeping it off a 7 is that the domains are derived almost entirely from the folder tree, so the "and the documents themselves" half of what I asked shows up thinly.

8. GUI action correctness — 4/7

It drove Chrome into Atlas and the end state is correct: 50 chunks, 7 domain records, the 6 obsolete records deleted rather than left alongside, and counts verified in the Data Explorer afterward. It also used the bulk write surface properly rather than clicking through documents one at a time. What holds it mid is the route in. It reported the Atlas tab as unavailable when it was open and signed in, asked me to do something I had already done, and only found the right profile after being pushed. Correct final state, rough path, and the one unprompted GUI judgment it made was wrong.




=======================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=======================================================================================
=======================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=======================================================================================


Rank all responses : B > D > A > C

Which model is best overall: B


B is first because it did the most complete job with the least of my time. One correction, 15 minutes, a routing layer derived from what the documents actually say rather than just the folder names, including a Security and Privacy domain none of the others found, with the multi domain and no match rules written into the collection. Its stale flags carry their reasoning in the cell, which is what I would have typed myself. Its weak point is the summary, a dense block I would rewrite.

D is second and closest on substance. It has the best catalog of the four, a parse detail line on every row, the only run to visually confirm the scanned PDF instead of trusting the empty extraction, per tab Sheet chunking, and the clearest Teams post. It sits below B because it cost me two rounds of steering, its domains are basically the folder tree, and it left a hole where the blocked Checkout V2 file never reached the gap analysis.

A is third, one correction and a readable post, but the least careful index, Sheets not split per tab and 47 chunks instead of 50. C is last despite building a genuinely good index, per tab chunking and blind spots wired into the router, because it needed two rounds of steering including one where I had to tell it that it was wrong about my own browser, and its summary is an unstructured wall of text.

C is last, and not because the index is bad. It is the only run to land on a single confirmed gap instead of padding the list, it split Sheets per tab, and its router is the best structured of the four, with the blind spot file ids wired into each domain. What sinks it is everything around that: two rounds of steering including one where I had to tell it it was wrong about my own browser, 26 minutes, a Teams post that is an unstructured wall of text, and a catalog that labels Checkout V2 unparsed in the same run where it calls the file readable.

What separates them: All four made the same two calls wrong, reporting zero inaccessible files when one is permission blocked and dropping the readable Checkout V2 spec from the index over a missing date, and all four stopped at preflight instead of trying the Chrome session my prompt names. From there it splits on cost and care: B and A each needed one correction while C and D needed two, and C and D built the better index while B and A were quicker to a usable answer. Nobody demonstrated the leave unchanged chunks alone behavior, since three of them wiped the prior collection outright and the fourth edited it.