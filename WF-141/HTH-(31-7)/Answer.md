Model - A - gpt-5.6-cat with High intelligence

Session Id : 019fc631-c4fc-7171-8cb7-0a51a35fbc8b

1. Overall task success - 3/7

The analysis is right. It read the manifest correctly, ran the exclusions in order, got 1,021 valid samples across 12 classes, and caught the scarf case at 4.9951 percent instead of taking the rounded 5.00 percent at face value. Delivery is where this run falls apart. It worked out that an in-place edit was required and then never performed one, and the report only reached the channel after I deleted the existing post by hand and handed over a signed-in browser session. Four separate stops before anything landed. On top of that, the file sitting on the published post is a leftover CSV that was already in the channel, reused without opening it, so the attachment my team would download was never checked against the numbers in the message. Correct thinking, but I did the blocking work myself and the artifact went out unverified.

2. Task accuracy, ignoring speed - 4/7

The counts are all correct and the ledger ties on every line: 1,070 train rows against 5 leakage, 6 blank, 10 malformed, 8 conflict, 0 unresolved and 1,041 rows rolling up to 1,021 samples. The class distribution matches the manifest exactly and the gap arithmetic off the ceiling of 52 is right for all four short classes. Two real problems. The attachment is a file from an earlier run that it swapped in without reading, so the report's numbers and the CSV's numbers are not tied to each other, and that CSV is the thing anyone checking my work would open first. Second, the collapsed-spelling block reports t-shirt at 190 plus 5 rows while the distribution shows t-shirt at 175 samples, and nothing in the report bridges that 20 row difference. It is the one place in the whole message where a figure does not reconcile against another figure in the same message.

3. Efficiency - 3/7

End-to-end time (minutes): about 12 minutes of model run time across four turns, inside roughly 25 minutes of wall clock once my interventions are counted.

Wrong actions / recovery: Four off-path stops. It opened the browser into a Teams session that was not signed in and stalled on a password prompt, spent a turn explaining Teams plugin capabilities back to me after I told it the plugin was connected, then offered to put the CSV on Drive and link it instead of attaching it. It recovered from each only because I unblocked it.

The analysis itself was a single clean pass, no dead ends and no rework on the data. Everything expensive happened after the numbers were done. Three of the four turns produced no progress on the deliverable at all, and the run stretched across 25 minutes of clock for what is one sheet read, twelve class counts and one post.

4. Writing quality - 4/7

The body is complete and sensibly ordered, the ledger is laid out so I can follow it, and the variant groups are bulleted properly. It is the version I would need to touch least. Still real work before I would let it stand. Em dashes run through the priority list and make each line harder to scan than a colon would. Nothing is emphasised, so the four numbers that matter, HIGH risk and the four short classes, sit in the same weight of text as the source URL. There is no two-line summary at the top, so anyone opening the post reads through location and snapshot detail before reaching the risk call.

5. Instruction following - 4/7

It followed most of the hard constraints exactly: preflight before any math, the ordered exclusion buckets, full-precision threshold calls rather than the rounded display, the exact CSV name and column order, the exact title, the dedup search of the channel, and no sample-level data anywhere in the message. It also refused to create a second post when it believed one already existed, which is the right call and I will credit it. Where it bends: the file it attached is not the CSV it built, and I asked for the class-distribution CSV attached, not a same-named file that happened to be sitting in the channel. It also proposed replacing the attachment with a Drive link, which would have missed the requirement outright had I agreed.

6. Collaboration, autonomy, and verification - 3/7

Steering needed (how often / how severe): Four rounds. Permission to open the browser, a request that I sign in to Teams, a push back after I said the plugin was connected, and a request to substitute a Drive link. One of them only cleared because I deleted a Teams post manually. Two were reasonable given the request tells it to stop when blocked, but the run could not finish without me.

Additional editing before I'd use it: Substantial, maybe twenty minutes. I would confirm the attached file actually holds this run's distribution, reformat the post so the risk call reads first, and strip the em dashes.

Self-checking is uneven. It reconciled the ledger properly and cross-checked its own recomputation against the report already in the channel, which is a genuine check. But it noticed a same-named CSV in the channel, chose it over its own file to protect the filename, and then verified the attachment card rather than the contents. It confirmed the post looked right without confirming the file was right, and that is the one check that mattered here.

7. Citation quality - 4/7

The prose numbers all trace back to the manifest and the ledger reconciles line by line, so a second person can follow how 1,070 rows became 1,021 samples. It also carried the Drive revision timestamp of 2026-07-16 10:41:40 into the report, which is the right audit detail because it shows how the snapshot boundary was established instead of just asserting it. Two weak seams. The t-shirt variant counts do not tie to that class's sample count, so the one cross-check inside the message fails. And the CSV backing the whole distribution is a file it never opened, which puts the auditable artifact a hop away from the run that produced it.

8. GUI action correctness - 3/7

It worked the Teams web interface to reach the right channel and eventually composed and published with the correct title and an attachment card under the exact filename, so the final on-screen state is right. The path there was rough. It opened into a session that was not signed in and stalled on a Microsoft password prompt, which is a dead end on screen, and the composer work only resumed two rounds later once I sorted the session out. Correct end state by a messy route, and the filename collision was handled by picking the existing channel file off the picker, which is the easy click rather than the right one.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - B - gpt-5.6-cat with Extra High intelligence

Session Id : 019fc669-8ff6-7f41-80ed-ffe1099896c4

1. Overall task success - 4/7

It ran the whole thing start to finish without asking me anything and landed a correct, complete report with the CSV it actually built attached. The numbers are right, including the scarf precision trap, and it verified its own file before sending it. But nineteen minutes, and the route was destructive. It attempted the in-place edit the request calls for, tripped a SharePoint rename, went into the channel's shared folder and overwrote a document to force the filename, hit a failed edit state, and ended up leaving the original message as a blank channel item that no longer carried the title. It recovered by posting fresh. The one-report rule technically holds because the blank item does not match the title, but I am left with debris in the channel and a file I did not ask it to overwrite.

2. Task accuracy, ignoring speed - 5/7

This is the strongest part of the run. Every count reconciles, the exclusion buckets are exact at 5, 6, 10, 8 and 0, the roll-up from 1,041 rows to 1,021 samples is right, and the four short classes carry the correct gaps against the ceiling of 52. It handled the scarf case properly and, unlike the report body alone, it checked its own CSV for the twelve class rows, the required column order, the integer total of 1,021 and the four TRUE flags, so the file and the message agree. What keeps this off a higher mark: the collapsed-spelling block reports t-shirt at 190 plus 5 rows while the distribution puts t-shirt at 175 samples, and the 20 row difference is never explained. That is a genuine reconciliation hole in a report whose whole selling point is that it reconciles.

3. Efficiency - 3/7

End-to-end time (minutes): 19 minutes 13 seconds.

Wrong actions / recovery: At least five off-path actions, all after the analysis was already finished. An attachment upload that got renamed, a trip into the channel's file store to overwrite a document, a failed edit, an explicit Retry, and then a full recovery post once the readback showed the original message had gone blank. It recovered from every one of them without help.

The data work was a single clean read and one calculation pass. Everything else was nineteen minutes of wrestling with the delivery step, and roughly two thirds of the run went to recovering from problems it created by insisting on the in-place edit path after the first rename collision. Recovering well does not buy back the time.

4. Writing quality - 4/7

The body is thorough and in the right order, the ledger is legible, and the single-label explanation is clear about why conflicting rows were treated as conflicts rather than multi-label cells. It needs real work anyway. Em dashes run through the priority list. The four headline figures sit as bare unmarked lines with no emphasis, so the HIGH risk call carries no more visual weight than the sheet URL. The variant groups use hyphen bullets while no other section is bulleted, so the formatting is inconsistent within one post, and there is no short summary up top.

5. Instruction following - 3/7

The analysis constraints are met properly: preflight before math, ordered exclusions, true-share thresholds, the exact filename and column order, the exact title, a real post with the attachment, nothing sample-level in the message. Two concrete deviations pull this down. The request says that if exactly one matching report exists, edit it in place and swap the attachment. It abandoned that and created a new top-level post, leaving the original as a blank item in the channel, so the channel state is not what I asked for even though the report is. And it overwrote an existing file in the channel's shared folder to win a filename argument, which I never authorised and which changed data outside the scope of this task.

6. Collaboration, autonomy, and verification - 4/7

Steering needed (how often / how severe): None. It worked through a rename collision, a failed edit and a message it had blanked out, all on its own across nineteen minutes.

Additional editing before I'd use it: Light on the report itself, maybe ten minutes of reformatting. The channel needs more: I would delete the blank item it left behind and check what it overwrote in the shared folder.

Running fully unattended through that much friction is the real achievement here and it is why this is not lower. Verification is substantive too: it checked its own CSV against the computation and did a server-side readback confirming one matching post with the right attachment, rather than trusting what the interface showed it. What it did not verify is the state it left behind. It knew the original message had gone blank, said so, and then posted over the top and signed off without cleaning up. It also never reconciled its own variants block against its own class counts.

7. Citation quality - 5/7

Every figure traces back to the manifest, the ledger reconciles line by line, and the Drive revision timestamp is in the report so the snapshot boundary is evidenced rather than asserted. The attachment is the file it built and independently checked, which is what makes the distribution properly auditable instead of just present. The weak seam is the same one that shows up in the accuracy box from a different angle: the t-shirt variant counts of 190 and 5 do not tie to that class's 175 samples in the CSV, so the one figure a reader might cross-check between the two sections does not match.

8. GUI action correctness - 2/7

This is where the run actually went wrong. On screen it triggered a filename rename, navigated into the channel's document store to overwrite a file, hit an Edit failed state, used the Retry control, and ended up wiping the original message's contents so it showed as a blank channel entry. Four recovery cycles in the interface, one destructive edit to a document outside the task, and residue left in the channel. The final post is correct and correctly attached, but the on-screen path caused real damage on the way and the mess is still sitting there.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - C - gpt-5.6-fish with High intelligence

Session Id : 019fc689-5ea7-71c2-be45-0bb3ee7f4bee

1. Overall task success - 4/7

Clean run with no input from me. It preflighted the sheet, the folder, the revision timing, the columns and the channel, found no existing report for the snapshot, did the analysis correctly, and posted with the exact title and the CSV attached. The scarf case at 4.9951 percent is handled right. What holds it at this mark is the attachment. Teams flagged a same-named file already in the channel and it selected that existing copy rather than its own upload, without opening it to confirm the contents matched this run. So the report is right and the file hanging off it was never checked. Seven minutes is also more than this needs for one sheet read, twelve class counts and one post.

2. Task accuracy, ignoring speed - 4/7

The counts are correct throughout. Rows read at 1,070, exclusions at 5, 6, 10, 8 and 0, 1,041 rows collapsing to 1,021 unique samples, twelve classes, and the four short classes with the right gaps against the ceiling of 52. It also reported the duplicate collapse count of 20 explicitly, which makes the roll-up easier to follow. Three real gaps. The attached CSV was never opened, so the distribution in the message and the distribution in the file are not tied together. The collapsed-spelling block reports t-shirt at 190 plus 5 rows against a class the distribution shows at 175 samples, with no explanation of the difference. And the report says nothing about provisional classes at all, which the request asks the post to carry even when the answer is that none are provisional.

3. Efficiency - 4/7

End-to-end time (minutes): 7 minutes 2 seconds.

Wrong actions / recovery: None. No dead ends, no retries, no wrong destinations. It went preflight, analysis, compose, post, readback.

Steady and straight, which is the right shape for this task. The drag is that seven minutes went by for a single sheet read and a single post, and the front half of it was spent standing up three separate tool paths, Drive, Teams and the browser, before any data had been touched. Some preflight is required here, but bringing up the browser path before it knew whether it would be needed was work it did not have to do yet.

4. Writing quality - 4/7

The best-structured body of anything in this batch to my eye: capitalised section headers break the post into dataset and schedule, distribution and risk, ledger, variants, priority list, recommendation and planning note, so I can find what I want without reading the whole thing. Real flaws though. Em dashes appear in the section header and in every priority line. The sample count switches between 1021 and 1,021 in the same message, which looks careless in something going to a team channel. And the HIGH risk call sits at the bottom of the second block rather than at the top, so the single most important line is four sections in.

5. Instruction following - 4/7

It walked the constraints properly: preflight before math, exclusions in the stated order, thresholds on the true share rather than the rounded figure, the exact CSV filename and column order, the exact post title, a search for an existing report before deciding to post new, a real post rather than a draft, and no sample-level data in the message. Two misses. The attached file is a pre-existing channel copy, not the CSV it produced, and I asked for the class-distribution CSV attached. And the provisional-class flag the request specifies for the priority list is simply absent, so a required element of the post is missing.

6. Collaboration, autonomy, and verification - 4/7

Steering needed (how often / how severe): None. It ran the whole task unattended and posted without asking me anything.

Additional editing before I'd use it: Moderate, roughly fifteen minutes. I would open the attached file to confirm it holds this run's numbers, add the provisional line, fix the 1021 versus 1,021 inconsistency and move the risk call to the top.

It verified a good deal: the sheet and folder, the revision predating the cutoff, the required columns, the channel identity, the absence of a matching report, then a readback after posting confirming exactly one report for the snapshot plus a re-check of the HIGH classification and all four priorities. The hole is specific and it is the one that counts. It spotted a same-named CSV in the channel, deliberately chose it to protect the filename, and never opened it. It verified everything around the attachment and not the attachment itself.

7. Citation quality - 3/7

The numbers in the message trace to the manifest and the ledger reconciles, so the path from 1,070 rows to 1,021 samples is followable. Beyond that the grounding thins out. The snapshot is given as a bare timestamp with nothing showing how the boundary was established, even though it checked the revision history to get there, so a reader has to take the snapshot on trust. The attachment is a file from a previous run that was never read, which means the artifact behind the distribution is not traceable to this run's work. And the t-shirt variant counts do not tie to that class's sample count in the distribution.

8. GUI action correctness - 4/7

It reached the right channel, used the channel's own search to check for an existing report, composed with the exact title and published with the attachment, then read the channel back to confirm a single matching post. No wrong clicks, no wrong destination, correct final state. The real weakness is the choice it made at the filename collision: it took the existing channel file straight off the picker rather than uploading its own and dealing with the naming properly, which is the fastest click available and the one that put an unchecked file on my post.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - D - gpt-5.6-fish with Extra High intelligence

Session Id : 019fc693-4056-7e00-88c0-4a18f1b2ad34

1. Overall task success - 5/7

This one did the job unattended and did the check that actually matters. Analysis correct, 1,021 samples across 12 classes, scarf held at P2 on its true share, exact title, exact filename, real post. When Teams offered it a same-named file already in the channel, it opened that file and compared all 91 cells against its own computation before reusing it, so the CSV on the published post is provably the right distribution and not just the right filename. Two things keep it off a higher mark. It said it would check the final channel state after publishing and then closed out without reporting what it found, so the one-report guarantee rests on its intention rather than a readback. And 9 minutes 34 seconds is slow for one sheet read, twelve class counts and one post.

2. Task accuracy, ignoring speed - 5/7

Correct on everything I can check. Rows read 1,070, exclusions 5, 6, 10, 8 and 0, 1,041 rows deduplicating to 1,021 samples, twelve classes at the right counts, shares off the integer counts, and the four short classes at gaps of 44, 32, 12 and 1 against the ceiling of 52. The scarf edge is called correctly and stated plainly. The cell-level verification of the attachment is what lifts this: the file and the message are demonstrably the same distribution. The real gap is the variants block, which reports t-shirt at 190 plus 5 rows while the distribution shows 175 samples for that class, with nothing bridging the 20 row difference. It also skips the provisional-class statement the request asks the report to carry, so one required element is thin rather than present.

3. Efficiency - 4/7

End-to-end time (minutes): 9 minutes 34 seconds.

Wrong actions / recovery: None off-path. It hit a Teams rate limit early and switched to the browser route rather than retrying into it, which is the right call and not a wrong turn.

Steady progress with no dead ends, and the heavy preflight is what I asked for so I am not docking that. The real drag is that it created work for itself at the end. Having already generated its own CSV, it went and read 91 cells of a file already sitting in the channel to decide whether reusing it was safe, which is careful but is a detour it only needed because it did not upload its own file. Nine and a half minutes for a single read, one calculation pass and one post is on the slow side for the shape of this task.

4. Writing quality - 3/7

The content is right and ordered sensibly, but this is the version I would rework most before letting the ML team read it. The four numbers that matter, valid samples, class count, the below-5-percent figure and the risk call, sit as unmarked plain lines with nothing emphasised. The label variants are wrapped in curly quotes, which reads like a paste artifact rather than a deliberate choice. Hyphen bullets appear in one section and nowhere else. Every priority line is broken up with em dashes. And there is no short summary at the top, so the post opens with location and link detail before it gets anywhere near the finding.

5. Instruction following - 4/7

Most of it is met exactly: preflight before math, exclusions in order, thresholds on the full-precision share, the exact CSV filename and column order, the exact title, the duplicate search before posting, a real post with the attachment, no sample-level data anywhere. Three things fall short. The provisional-class flag the request specifies is absent. The report does not state that non-train rows were inspected only for leakage, so the scope of the ledger is left implicit when the request is explicit about it. And the attached file is a pre-existing channel copy rather than the CSV it built, which it did verify cell by cell, but it is still not the artifact this run produced.

6. Collaboration, autonomy, and verification - 4/7

Steering needed (how often / how severe): None. It ran the entire task unattended, including working around a rate-limited Teams path on its own.

Additional editing before I'd use it: Moderate, about fifteen minutes. Mostly formatting: emphasise the risk call, break the headline numbers out, fix the quote characters, drop the em dashes. The numbers I would leave alone.

The 91-cell check on the attachment is the most substantive self-verification in this batch and exactly the right instinct: it refused to put a file on my post without knowing what was in it. The hole is at the close. It announced that it would check the final channel state after publishing and then reported the post as done without reporting that check, so the one-report-per-snapshot condition is unconfirmed. It also never reconciled its own variants counts against its own class counts, which is the internal check that would have surfaced the t-shirt mismatch.

7. Citation quality - 4/7

Every figure traces to the manifest, the ledger reconciles, and the attachment is verified against the computation cell by cell, which is what makes the distribution genuinely auditable rather than merely attached. Two seams. The snapshot appears as a bare timestamp with no revision evidence behind it in the report, even though it checked the revision history to establish the boundary, so the reader cannot see how the cutoff was justified. And the t-shirt variant counts of 190 and 5 do not tie to that class's 175 samples in the distribution.

8. GUI action correctness - 4/7

Right channel, right composer, exact title, exact filename, correct final state, and no wrong clicks or wrong destinations anywhere. It also handled the filename collision deliberately rather than accepting a renamed upload. The weakness is that it went to the channel twice: once during preflight to confirm the composer exposed attachment controls, and again later to actually compose and publish. That doubling back is an extra on-screen round trip for a check it could have folded into the single pass it eventually made.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - E - gpt-5.6-dog with High intelligence

Session Id : 019fc6af-9aa3-7dc0-9041-c52eae2653d0

1. Overall task success - 2/7

The analysis is genuinely precise. It carried the true shares out to four decimals instead of leaning on the rounded display, held scarf at P2 on 4.9951 percent, reconciled every ledger line, and stated outright that no class is provisional because unresolved is zero. Then it stopped. The report was staged in the composer with the CSV attached and it asked me to confirm before pressing Post, so the channel holds nothing for this snapshot and the ML team has no report. I asked for it posted for real, not a draft. The staged message also carries no title line, and I gave the exact title. All the hard thinking was done correctly and none of it reached anyone, which is the outcome I care about.

2. Task accuracy, ignoring speed - 4/7

On the numbers this is right and carefully stated. 1,070 rows read, exclusions at 5, 6, 10, 8 and 0, 1,041 rows rolling up to 1,021 unique samples, twelve classes, gaps of 44, 32, 12 and 1 against the ceiling of 52, and the shares given to four decimals so the threshold calls are checkable rather than asserted. The provisional statement is there, which is easy to skip. Against that, the required post never landed, and completeness in this box covers whether the work was actually carried out and not just computed, so an unsent report is an incomplete task regardless of how good the arithmetic is. The variants block also reports t-shirt at 190 plus 5 rows against 175 samples in the distribution with nothing explaining the gap. The distance between this and the overall mark is not speed, it is that this box credits the analysis being right while the overall box carries the fact that none of it was delivered.

3. Efficiency - 5/7

End-to-end time (minutes): 4 minutes 5 seconds.

Wrong actions / recovery: None. No dead ends, no retries, no wrong destinations.

The tightest-running dimension of this run. Four minutes with no wasted motion, and it deliberately scoped the sheet read to sample_id, label and split rather than pulling the whole manifest, which is the right instinct on a dataset this size and keeps the row-level content out of the output. The only real drag is that it went to the channel in the browser to search for an existing report, left to do the analysis, then came back to the browser a second time to stage the post, so the on-screen work happened in two visits instead of one.

4. Writing quality - 3/7

The content is well ordered and the four-decimal precision detail is genuinely useful to me. The message itself needs real work. There is no title on it, which is the first thing anyone scanning a channel looks for and the reason a post gets found later. The headline figures run as bare unmarked lines with nothing emphasised. There are three and four blank line gaps between every section, which stretches the post far longer on screen than the content warrants. And the priority list leans on em dashes where a colon would read cleaner.

5. Instruction following - 2/7

The analysis instructions are met closely, including the ones that are easy to get wrong: exclusions in the stated order, thresholds on the full-precision share, the provisional statement, the exact CSV filename, the ordered priority list, no sample-level data in the output. But it missed the instruction the whole task turns on. I asked for the report posted straight to the channel, for real and not a draft, and it staged it and handed the decision back to me. The staged message also has no title, and the title was specified exactly. Those two together mean the deliverable does not exist in the form I asked for.

6. Collaboration, autonomy, and verification - 2/7

Steering needed (how often / how severe): One, and it was the blocking kind. It reached a fully staged post and stopped to ask permission to publish, on a task where the request already told it to post for real. That is not a judgment call it needed help with, and the run ended with an empty channel.

Additional editing before I'd use it: The last mile is entirely on me. I would have to post it myself, add the title, and close up the spacing. Call it twenty minutes plus the delivery step it left undone.

Checking its own work is solid. It reconciled the ledger, independently confirmed the CSV's twelve rows, integer total of 1,021 and four TRUE flags, and searched the channel for a matching report before concluding this was a new post rather than an edit. Autonomy is the failure. It did every part of the task it could do alone and then declined the one action that made the work count for anything.

7. Citation quality - 4/7

The numbers trace to the manifest, the ledger reconciles line by line, and carrying the true shares to four decimals rather than the rounded display is what makes the threshold calls verifiable instead of claims, which matters more here than anywhere given the scarf case. Two seams. The snapshot is given as a bare timestamp with no revision evidence behind it, even though it confirmed the revision predated the cutoff, so nothing in the message shows why the boundary holds. And the t-shirt variant counts do not tie to that class's sample count in the distribution.

8. GUI action correctness - 3/7

Navigation was correct throughout: right channel, the channel's own search used to look for the exact title, and the composer loaded with the report and the CSV attached under the right filename. No wrong clicks and no wrong destination. But it never finished the interaction. The final on-screen state is an unsent draft sitting in a composer, which is the wrong end state for what I asked, and leaving a staged post open is not a neutral place to stop.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - F - gpt-5.6-dog with Extra High intelligence

Session Id : 019fc6c8-bbb2-7b31-9f32-38df7e1e8973

1. Overall task success - 4/7

It landed properly: right channel, exact title, the CSV attached under the exact filename, and a readback afterwards confirming one active post for the snapshot. The analysis is correct including the scarf case, which it pinned at 4.99510284 percent rather than accepting the 5.00 percent display. When Teams renamed its upload it went and checked the existing exact-name file against its own distribution before reusing it, instead of clicking past the problem. Two things pull it down. It stopped to ask permission to publish, which the request had already given, so the post only happened after a second instruction from me. And the message crams the four figures that matter into one dense paragraph, which is the part the channel actually reads.

2. Task accuracy, ignoring speed - 5/7

Right across the board. 1,070 rows read, exclusions at 5, 6, 10, 8 and 0, 1,041 rows rolling up to 1,021 unique samples, twelve classes at the correct counts, gaps of 44, 32, 12 and 1 against the ceiling of 52, and the scarf share given to eight decimals so the threshold call is checkable rather than asserted. It also confirmed the attached file's twelve-row distribution against its own before letting it go out, so the message and the file agree. The real gap is the variants block: t-shirt is reported at 190 plus 5 rows while the distribution shows 175 samples for that class, and the 20 row difference is never accounted for. In a report whose credibility rests on reconciling, that is the one figure that does not.

3. Efficiency - 4/7

End-to-end time (minutes): about 5 minutes 26 seconds of model run time, 3 minutes 46 seconds before the confirmation stop and 1 minute 40 seconds after it.

Wrong actions / recovery: None off-path. Teams renamed its upload because a same-named file already existed, and it resolved that deliberately by checking the existing file rather than accepting the renamed copy.

Quick and well-sequenced: preflight, one sheet read, CSV, compose, publish, readback. The drag is that it pulled the full A1 to E range when the task only needs sample_id, label and split, so it read the image references and modified timestamps for no reason on a sheet of over eleven hundred rows. The staging and publishing also split across two turns, which meant re-establishing the composer state the second time round rather than carrying one pass through.

4. Writing quality - 3/7

The ledger reads cleanly and the variant groups are bulleted properly, but the third block is a wall. Valid samples, class count, the below-5-percent figure and the single-label result are all jammed into one running paragraph, and those are precisely the numbers anyone opening this post is looking for. Every priority line is broken up with four em dashes, which makes each entry harder to parse than a colon would. Nothing is emphasised anywhere, there is no short summary at the top, and the post opens with a paragraph of source and revision detail before it reaches the risk call.

5. Instruction following - 4/7

It walked the constraints properly: preflight before math, exclusions in the stated order, thresholds on the true share, the exact CSV filename and column order, the exact title, a channel search before deciding on a new post, a real post rather than a draft, the provisional statement, the recalculation note, and no sample-level data in the message. Two deviations. I asked for the report posted for real, and it stopped to ask permission first, so publishing needed a second instruction from me. And the attached file is a pre-existing channel copy rather than the CSV it produced, which it did verify against its own numbers, but it is still not the artifact this run built.

6. Collaboration, autonomy, and verification - 3/7

Steering needed (how often / how severe): One. It stopped before uploading and publishing to ask whether it should. Not a severe or dumb steer, and a sensible caution about sending to a channel in general, but the request had already authorised the post, so the delivery could not happen without me saying yes a second time.

Additional editing before I'd use it: About ten minutes. I would break the dense headline paragraph into separate lines, strip the em dashes out of the priority list, and mark the risk call so it reads first. The numbers need nothing.

Verification is the strong half. It reconciled the ledger, checked the existing exact-name file's distribution against its own before reusing it, and did a channel readback confirming one active post with the right attachment. Autonomy is the weak half, and it is the same story as the steering: it got to the last action on a task that had already told it to post, and stopped. It also never reconciled its own variants counts against its own class counts, which is the single internal check that would have caught the t-shirt mismatch.

7. Citation quality - 4/7

Every figure traces to the manifest, the ledger reconciles line by line, and the snapshot basis is evidenced with the Drive revision timestamp of 2026-07-16 10:41:40 rather than asserted, which is the detail that lets someone else confirm the cutoff holds. Giving the scarf share to eight decimals makes the threshold call checkable rather than a claim. Two seams. The t-shirt variant counts do not tie to that class's sample count in the distribution, and the attachment is a channel file it verified but did not produce, so the provenance of the auditable artifact sits one hop from the run.

8. GUI action correctness - 4/7

Right channel, right composer, exact title, and it handled the filename collision the careful way: when Teams renamed the upload it stopped, opened the existing exact-name file, checked its distribution, and only then attached it. Published and read the channel back to confirm the state. No wrong clicks, no wrong destination. The weakness is that the on-screen work happened across two sessions: it staged everything, went idle waiting on me, then came back and had to redo the upload step, so the interface work was done twice over rather than in one clean pass.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================
=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Ranking: D > F > C > B > A > E

Which model is best overall: D



All six got the analysis right, which surprised me. Every run reached 1,021 valid samples across 12 classes, reconciled 1,070 rows read against 5 leakage, 6 blank, 10 malformed, 8 conflict and 0 unresolved, and every one of them caught the scarf trap and held it at P2 on a true share of 4.9951 percent rather than letting the 5.00 percent display decide the bucket. That was the main thing I built this dataset to test and none of them fell for it. They also all reported the three collapsed spelling groups and none of them false-triggered the multi-label stop on the hyphen in t-shirt. So the ranking comes down almost entirely to delivery, verification and how much of my time each one cost. All six share the same reporting flaw as well: the variants section gives t-shirt 190 plus 5 rows while the distribution shows 175 samples for that class, and not one of them reconciled the 20 duplicate rows that explain the difference.

D is first because it is the only run that was both fully unattended and provably correct end to end. When Teams offered it a same-named file that was already in the channel, it opened that file and compared all 91 cells against its own computation before reusing it. That is the difference between a report that says the right thing and a file I can actually trust, and it is the check that decides whether this workflow is worth running unsupervised. It cost me nothing and produced something I would send on. Its weaknesses are real but small: 9 minutes 34 seconds is slow, it said it would check the final channel state and then never reported that check, and the post is the plainest formatted of the batch.

F is very close and faster, and its verification of the reused attachment was nearly as thorough. What separates it from D is autonomy. It got all the way to a staged post with the file ready and then asked whether it should publish, on a request that had already told it to post for real. It only landed because I said yes a second time. Its report is also the least scannable, with the valid sample count, class count, below-5-percent figure and single-label result all crushed into one paragraph. If it had pressed Post on its own it would be first.

C comes next. It ran unattended, went straight through with no wrong turns, and posted in seven minutes with the best-organised message of the six, with real section headers I could navigate. What drops it below F is the attachment: it took the existing same-named channel file straight off the picker and never opened it, so the CSV on my post was unverified. It also left out the provisional-class flag entirely, which the request asks for even when nothing is provisional.

B is fourth, and it is a frustrating one because its analysis and its self-checking are as good as anything here and it needed nothing from me across nineteen minutes. But nineteen minutes is the problem, and so is how it spent them. It pushed the in-place edit path after the first rename collision, overwrote a file in the channel's shared folder to force the filename, hit a failed edit, and ended up blanking the original message so it no longer matched the title, then posted fresh over the top. The report is right and the channel is a mess: a blank item still sitting there and a document changed that I never asked it to touch.

A is fifth. The analysis is as sound as everyone else's, but it needed four rounds of intervention and one of them was me deleting a Teams post by hand so it could proceed. It correctly worked out that an in-place edit was required and then never performed one. It also reused a leftover channel file as the attachment and verified the post card rather than the file contents, so what went out was unchecked. I will credit it for pushing back when I told it the Teams plugin was connected, because it was right about what the plugin could and could not do, but a run that cannot finish without me doing the hard part is not much use at four times a month.

E is last, and it is the sharpest analysis of the six. It carried the true shares to four decimals, answered the provisional question explicitly, reconciled every line, and scoped the sheet read to just the three columns it needed. Then it staged the post and asked permission instead of publishing, so the channel is empty for this snapshot and the ML team got nothing. The staged message does not even carry the title I specified. Precision on the numbers counts for very little when the report never reaches anyone.

If I had to break D and F apart on a single line, it is this: both produced a correct report with a verified attachment, and only one of them did it without me in the loop.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


B, D and F only

Ranking: D > F > B

Which model is best overall: D

Why the top model is best, and what separates the other models:

All three ran the analysis unattended and all three got the numbers right, so none of the separation comes from the maths. 1,021 valid samples across 12 classes, the ledger tying on every line, and scarf held at 4.9951 percent instead of taking the rounded 5.00 percent at face value. All three also share the same reporting gap: the variants section gives t-shirt 190 plus 5 rows against a class the CSV shows at 175 samples, and none of them explains the 20 duplicate rows that account for it.

D is best because it is the only one of the three that published without needing anything from me and can prove the file on the post is the right file. When Teams offered it a same-named CSV already sitting in the channel, it opened that file and compared all 91 cells against its own computation before reusing it. That is the check that separates a report which says the right thing from a report whose attachment I would trust. Nine and a half minutes, no steering, no mess left behind. Its weaknesses are real but small: it announced a final channel-state check after publishing and then closed out without reporting what it found, and its post is the plainest of the three with the headline numbers unmarked.

F is second and close. Same correctness, and it checked the reused channel file's twelve-row distribution before letting it out, so its attachment is trustworthy too. It was the fastest of the three at about five and a half minutes and its digest is the more readable one. What drops it below D is that it got all the way to a staged post with the file attached and then asked whether it should publish, on a request that already told it to post for real, so the delivery took a second instruction from me. Its report also crams the valid sample count, the class count, the below-five-percent figure and the single-label result into one running paragraph, which is the block anyone opening the post reads first.

B is last, and it is the frustrating one. It is the only one of the three that attached the CSV it actually built rather than reusing a file from the channel, and its closing readback is the most thorough of any run I looked at: PR state, issue labels, Notion placement and the exact posted message all re-read from the server. It needed nothing from me across nineteen minutes. But nineteen minutes is the problem, and so is the route. It went after the in-place edit the request calls for, tripped a rename collision, went into the channel's shared folder and overwrote a document to force the filename, hit a failed edit, and ended up blanking the original message so it no longer carried the title. Correct report, and a channel I have to go clean up.

Tie-break between D and F: F is faster and its formatting is better, so on a quiet week I would take it. On a workflow I run four times a month, the one that finishes without me wins, and that is D.
