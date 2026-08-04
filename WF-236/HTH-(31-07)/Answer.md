
Model - A - gpt-5.6-cat with Extra High intelligence

Session Id : 019fcc35-fff3-7743-94d6-676854fa5455

1. Overall task success - 3/7

The catalog is complete, the tracker reconciles on file id with the human owner cells intact, and the freshness work is right down to both boundary files and the Sales Playbook's recent-date-but-unrevised note. But the index was never built in this run. It opened the collection, found it already holding 50 chunks and 8 routing domains, decided every version was unchanged and wrote nothing, so the replace-on-change behaviour the whole task turns on was never exercised and the index it reported is not its own work. On top of that it dropped the Checkout V2 spec out of the index because the file states no date, when that file is readable and only its date is missing, and it reported nothing at all in the inaccessible bucket. It also called two confirmed gaps where one holds up, promoting the office-coffee question from a no-domain-match to a documented absence.

2. Task accuracy, ignoring speed - 3/7

The ledger arithmetic ties, 14 indexed plus 4 unparsed plus 0 inaccessible plus 2 out of scope against 20 found, and the shortcut file was correctly counted once with the shorter path as its home. Staleness is handled exactly: four sources before the 2026-04-17 cutoff, the file dated on the cutoff treated as fresh and the one dated a day earlier treated as stale, and the Sales Playbook flagged as content-stale despite a recent stated date. Three errors sit on top of that. Checkout V2 was excluded from the index rather than indexed with a no-stated-date flag, which drops indexed to 14 and converts an answerable question into unknown coverage. Nothing was placed in the inaccessible bucket. And the second confirmed gap was called on a question that routed to the whole corpus with no domain match, on a topic a readable Finance budget workbook is the natural home for, where the request requires ruling out a routing miss before anything becomes a gap. Zero chunks were written, so none of the index state it reported is attributable to this run.

3. Efficiency - 4/7

End-to-end time (minutes): 13min across 2 turns, 1m 19s to the preflight stop and 11m 53s after it.

Wrong actions / recovery: One. A tracker screenshot capture failed twice before it switched to a connector-level formatting check instead of retrying the same call. The preflight stop was instructed rather than a wrong turn.

Steady progress with no dead ends on the analysis. The drag is front-loaded skill reading: it stopped to read the Slides extraction guidance, then the Docs routing guidance, then the PDF guidance as separate steps before touching the corpus, which is three interruptions to decide how to read four file types. Reasonable pace for the work otherwise.

4. Writing quality - 4/7

The Blind Spots block leads the post with a warning marker and one line per file, which is what the request asks for, and the reconciliation below is broken into readable lines by topic. Flaws: em dashes run through the entire message, the blind spot section opens with the count line "4 files are unparsed; inaccessible files: 0" so the first thing a reader meets is a tally rather than the file names that matter, and the Checkout V2 line says it was excluded from MongoDB without saying its text was readable, which is the detail that would let someone judge the call.

5. Instruction following - 3/7

The preflight was run all-or-nothing and it stopped on the one unreachable target and named it exactly, which is what I asked for. The walk covered every subfolder, per-type parsing kept sections, tabs, slide numbers and pages, the shortcut was indexed once, stated dates were used instead of Drive timestamps, the tracker was updated in place on file id, owner cells were left alone, and the post went up for real with the blind spots first. Four misses. A readable file was kept out of the index over a missing date. The inaccessible bucket is empty. A confirmed gap was called without the ruling-out step the request spells out. And no chunk was written, so building the index in MongoDB was met by inheriting an index rather than producing one.

6. Collaboration, autonomy, and verification - 3/7

Steering needed (how often / how severe): One, and it was correct. It stopped at the preflight because no MongoDB path was callable and named that as the single blocker, which is exactly the behaviour the request asks for. Nothing after that needed me.

Additional editing before I'd use it: Moderate, about 30min. Index Checkout V2 with a no-stated-date flag, move the permission-blocked file into the inaccessible bucket, downgrade the second confirmed gap to a routing weakness, and confirm the collection actually reflects this run.

There is real checking here: per-file chunk counts with unique-id and duplicate-count audits, a read-back of the gaps and ledger ranges, a rendered pass over the tracker, and a visual look at the scanned PDF in the browser before labelling it unparsed rather than trusting an empty text return. The gap is that all of it tested the state it found rather than work it had done. It never asked whether a collection it had not written could be trusted as this run's index, and it accepted 8 pre-existing routing domains as the routing layer without deriving them.

7. Citation quality - 4/7

Per-file chunk counts, file ids, versions and duplicate counts are laid out so each file's index state can be checked individually rather than taken from a total, and each routing domain names what it was derived from. Stated dates are used throughout with Drive timestamps explicitly rejected as unreliable, which is the grounding this corpus depends on. Two seams. The Checkout V2 exclusion is presented as a blind spot with no record that its text extracted fine, so the file whose exclusion is most arguable has the thinnest evidence line. And the two confirmed gaps carry no trace of the alternatives being ruled out, which is the step that turns an empty retrieval into a defensible claim of absence.

8. GUI action correctness - 4/7

Sustained browser work with a clear purpose: it reached Atlas through the signed-in session, confirmed the database and both collections, and went back to the browser to look at the scanned PDF directly before calling it unparsed, which is the right instinct on a file whose emptiness is the whole trap. It also did a rendered pass over the tracker tabs. No wrong targets and nothing thrashed. The weakness is two failed screenshot captures on the same tab before it changed approach, and a rendered check that ended up validating a tracker built on a chunk count it had not produced.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - B - gpt-5.6-fish with Extra High intelligence

Session Id : 019fccad-9382-7350-8ca8-8e6f4b9227e0

1. Overall task success - 2/7

The index does not exist. The chunks collection is empty, and the run reported 50 source-attributed chunks along with a specific account of the idempotency work, five unchanged authentication chunks preserved and four obsolete frontend chunks replaced instead of duplicated. None of that happened in the database. What it actually produced was a pair of local JSON import files, and the chunk payload was never loaded. The routing layer did land, and the catalog, the freshness analysis and the owner preservation are all sound, but the tracker, the domains and the channel post all quote a chunk count with nothing behind it. Everything reconciles on paper against an index that is not there, which is the one outcome worse than numbers that visibly fail to add up.

2. Task accuracy, ignoring speed - 2/7

The Drive-side analysis is right: 20 files with the shortcut counted once, four sources before the 2026-04-17 cutoff, both boundary files placed correctly, and the Sales Playbook caught as recently dated but substantively unrevised. It also identified the two idempotency cases correctly in words, naming the five current chunks to keep and the four obsolete ones to replace. But the central figure is false. Fifty chunks reported, none present. Beyond that the same three coverage errors: Checkout V2 excluded from the index despite extracting fine, nothing in the inaccessible bucket, and a second confirmed gap on a question that matched no domain. A ledger that ties to a chunk count that does not exist is more damaging than one that fails openly, because it looks like it was checked.

3. Efficiency - 3/7

End-to-end time (minutes): 12min across 2 turns, 1m 22s to the preflight stop and 10m 55s after it.

Wrong actions / recovery: One, and it is large. The write phase produced two local JSON files totalling roughly 3,300 lines and the chunk payload was never imported, so the single biggest piece of work in the run was discarded.

The path itself was direct with no rework and no dead ends, and the preflight, inventory, extraction and tracker phases each ran once. The problem is where the time went. Building an import payload of that size and then not importing it means a substantial share of the run produced nothing that survives, and no step afterwards noticed.

4. Writing quality - 3/7

The Blind Spots header is the loudest thing in the artifacts it produced, with an action-required marker and each of the four files on its own line with a reason. After that the post collapses. The file counts, the Mongo state, the routing list, the question split, the coverage split and the freshness note are packed into three dense run-on lines, so the reconciliation a reader most needs to check is the hardest part to pick apart. Em dashes run throughout, and the header repeats the section title that follows it.

5. Instruction following - 2/7

The preflight was all-or-nothing and correctly stopped on the single unreachable target. The catalog covers every subfolder with per-type parsing, the shortcut is counted once, stated dates are used over Drive timestamps, the tracker is updated in place on file id with owner cells preserved, and the post is real with blind spots first. But building the index in MongoDB is the core instruction of this task, and the chunks collection is empty, on a request that says plainly the collection will be checked for duplicates on a second run. There is nothing to re-run against. It also excluded a readable file from the index, left the inaccessible bucket empty, and called a confirmed gap where routing had simply failed to match.

6. Collaboration, autonomy, and verification - 2/7

Steering needed (how often / how severe): One, and it was correct and instructed. It stopped at the preflight naming MongoDB as the only blocker and made no writes before that.

Additional editing before I'd use it: Substantial. The index has to be built from scratch before any of the reported numbers mean anything, then Checkout V2 indexed, the inaccessible bucket filled, and the second gap downgraded. Well over an hour.

This is where the run fails hardest, and not by omitting checks. It reported that the index passed checks for obsolete versions, incomplete metadata, stable ids and existing full-text and filter indexes, and that all 20 catalog rows reconcile. Those checks cannot have run against the chunks collection, because there is nothing in it. It also reported preserving five chunks and replacing four inside an empty collection. A verification pass that returns a pass on data that is absent removes the only signal that would have prompted anyone to look, which is worse than skipping the check.

7. Citation quality - 2/7

The Drive-side grounding holds up: stated dates used rather than Drive timestamps, the recent-date-unrevised case caught and reported, and the routing documents carry a derived_from line naming folders, headers and playbook content plus an explicit routing policy for multi-domain and unmatched questions. That part is traceable. The chunk-level attribution is not. Every claim about source title, file id, author, date, folder path and position marker rests on a collection with no documents in it, so the most heavily described evidence in the run has no artifact to check it against.

8. GUI action correctness - 3/7

It reached Atlas through the signed-in session and confirmed both required collections existed, then used the browser through the tracker and post phases without a wrong target or a stuck dialog. The navigation itself is fine. The weakness is what the on-screen work amounted to: it verified the collections were reachable, and the chunk insert it then described never landed in the one it had just opened, so the browser session confirmed an empty target and moved past it.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - C - gpt-5.6-dog with Extra High intelligence

Session Id : 019fccdf-d0ab-77b0-9ba7-1c406406223c

1. Overall task success - 4/7

The index exists at the end of this run and I can check it. It opened the collection, found 9 documents rather than the 50 a summary view suggested, worked out that five API authentication chunks were current and four Component Library chunks were pinned to 2026-05-01 while the document itself states 2026-06-28, removed the obsolete four, inserted 45, then proved the result: 50 documents, the old-version filter returning nothing, no unexpected ids, no chunk missing a required field, and a second comparison pass that held at 50. The tracker went from 3 seeded rows to 20 keyed on file id with the human owner cells untouched, and all 15 questions carry an answer with a reason on the Low ones. Against that: the readable Checkout V2 spec was excluded from the index because it states no date, nothing was placed in the inaccessible bucket, and a second confirmed gap was called on the office-coffee question that had matched no domain. 17min and three stops.

2. Task accuracy, ignoring speed - 4/7

The index work is right in a way that survives inspection. Chunk ids are built from file id, stated version and position, and every chunk carries the source title, file id, author, created date, stated last-updated date, full folder path, document type, a position object and a link back to the source, with a stale-by-cutoff flag computed against 2026-04-17. Freshness is exact: four sources before the cutoff, the file dated on the cutoff treated as fresh and the one a day earlier treated as stale, and the Sales Playbook flagged as unrevised despite its recent stated date. The shortcut file is counted once. Three errors, all in the coverage call rather than the mechanics. Checkout V2 was kept out of the index when only its date is missing, which also converts an answerable question into unknown coverage. The inaccessible bucket is empty. And the second confirmed gap was called on a topic that routed to the whole corpus with no domain match, where a readable Finance budget workbook is the obvious place it would live and the request requires ruling out a routing miss first.

3. Efficiency - 3/7

End-to-end time (minutes): about 17min of model run time across 4 turns, 1m 14s, 6m 12s, 4m 21s and 5m 20s, inside roughly 35min of clock once my confirmations are counted.

Wrong actions / recovery: One. The first browser connection timed out, and it consulted the connection recovery guidance before retrying rather than hammering the same call.

Progress was steady and nothing was redone. The cost is the shape: four turns and three stops for a job whose analysis takes one pass. The first stop was instructed and the two write confirmations are defensible before deleting from and inserting into a live cloud database, but they stretched the run across 35min of clock. It also read the Docs, Slides and PDF extraction guidance as separate steps mid-run before starting the corpus walk.

4. Writing quality - 3/7

The tracker is the artifact that reads well: the catalog, gap register, ledger and answer rows are all legible, the blind spots are recorded per file with their blockers, and the Low-confidence rows carry their reason. The channel post is the weaker one and it is what the team sees. The blind spots lead, which is right, but all four files are run together inside a single paragraph with their folders and reasons in parentheses, so the section that is supposed to be loud enough to catch in one glance reads as prose. The reconciliation then arrives as another run-on line rather than a list. Em dashes throughout.

5. Instruction following - 4/7

Close adherence on the parts that are easy to fudge. The preflight was all-or-nothing and named the one blocker precisely, and it explicitly refused to treat existing tracker and channel content as proof the current Drive state had been indexed. Per-type parsing kept heading positions, sheet tabs with their header and value structure, slide numbers with notes, and PDF pages. Chunk ids are stable and built from the specified parts, unchanged files were left alone, changed files were replaced rather than appended, and chunks lacking required metadata were not written. Domains were derived from the folder tree and document content with a stated policy for multi-domain routing and a whole-corpus fallback at Low confidence. The tracker was matched on file id with owner cells preserved, all 15 questions answered, and the post is real with blind spots first. Three misses: a readable file kept out of the index over a missing date, an empty inaccessible bucket, and a confirmed gap called before routing was ruled out.

6. Collaboration, autonomy, and verification - 5/7

Steering needed (how often / how severe): Three. The first was the instructed preflight stop on the unreachable database. The other two were confirmations before deleting from and inserting into a live cloud collection, which I would rather be asked about than not, so none of the three were the kind of steer I resent.

Additional editing before I'd use it: Light, about 15min. Index Checkout V2 with a no-stated-date flag, move the second confirmed gap back to a routing weakness, and bullet the blind spots in the post.

The verification is genuinely rigorous and it is what carries this run. It refused the collection view it was shown, checked the real document count and found 9 where a summary suggested 50, audited expected ids and required metadata after inserting rather than trusting the insert, and ran a second comparison pass aimed specifically at rerun safety. When routing_domains came back empty it said plainly that it had not deleted those records and that the earlier view was no longer the live state, rather than papering over the discrepancy or quietly reinserting and moving on. It also held off the tracker and the post while the routing layer was incomplete, instead of publishing numbers it knew were not yet true.

7. Citation quality - 5/7

Every chunk is traceable to the thing it came from. The id encodes the file id, the stated version and the position, and the stored fields carry the title, author, both dates, the full folder path, the type, a position object and a link back to the source document, so any answer can be walked back to a specific section, tab, slide or page rather than to a document in general. Stated dates are used throughout and Drive timestamps are explicitly not substituted, including on the file that states none. The routing records name what each domain was derived from down to tab and column names and heading hierarchies, and each carries its routing policy rather than leaving the multi-domain rule implied. The seam: the Checkout V2 exclusion is reported as a blind spot without recording that its text extracted fine, so the one exclusion that is genuinely arguable has the weakest evidence line behind it.

8. GUI action correctness - 4/7

Sustained and purposeful browser work across four turns: reading the collection, filtering on the obsolete version, deleting those documents, inserting the replacement payload, then re-querying to confirm the count, the absent old version, the id set and the metadata completeness, plus a rendered pass over the tracker tabs at the end. It recovered from an initial connection timeout by consulting the recovery path rather than retrying blindly, and it stayed on the right database and collections throughout. The weakness is that the routing_domains view it read early showed 8 documents while the live collection was empty, and it carried that reading forward until a later check contradicted it.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================
=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Ranking: C > A > B

Which model is best overall: C

Why the top model is best, and what separates the other models:

What decides this is not the analysis, it is whether the index got built. All three produced the same catalog, 20 files with the shortcut counted once and two out-of-scope types, and all three got the freshness work right: four sources before the 2026-04-17 cutoff, the file dated exactly on the cutoff treated as fresh, the one dated a day earlier treated as stale, and the Sales Playbook caught as recently dated but substantively unrevised since 2025. All three built eight evidence-derived routing domains including a Security and Privacy domain for the cross-domain question. All three also made the same three coverage errors: the readable Checkout V2 spec excluded from the index because it states no date, nothing placed in the inaccessible bucket, and a second confirmed gap called on the office-coffee question that had matched no domain, where the request is explicit that a routing miss has to be ruled out before anything becomes a documented absence.

C is best because it is the run where the index actually exists and can be inspected. It looked past the summary view, found 9 documents where 50 were implied, correctly identified the five current chunks to leave alone and the four pinned to a superseded date to replace, and then proved the outcome instead of asserting it: 50 documents, the old-version filter empty, no unexpected ids, no chunk short of a required field, and a second pass held at 50 for rerun safety. When the routing collection turned up empty it said outright that it had not deleted anything and that the earlier view was stale, and it held the tracker and the post back until the routing layer was whole rather than publishing numbers it knew were not yet true. Its chunks carry the full metadata the task demands, so an answer can be traced to a section, tab, slide or page. It cost three stops and 35min of clock, its post runs the blind spots together as prose, and it made the same three coverage errors, but it is the only work here I could re-run against tomorrow.

A is second, and it is a near miss rather than a failure. Its catalog, tracker, freshness handling and owner preservation are all sound, it stopped at the preflight exactly as instructed and named the single blocker, and it went and looked at the scanned PDF in the browser before calling it unparsed rather than trusting an empty text return, which is the right instinct on the file the whole blind-spot rule exists for. What holds it back is that it never wrote anything. It found a populated collection, concluded every version was unchanged and left it, so the replace-on-change path was never exercised and the eight routing domains it reported were inherited rather than derived. Its reasoning for doing nothing was internally sound, and it described the outcome honestly as zero chunks rewritten, which is the difference between this and last place.

B is last. Its Drive-side work is as good as anyone's and it identified the two idempotency cases correctly in words, naming the five chunks to keep and the four to replace. But the chunks collection is empty, and the run reported 50 attributed chunks, a completed replacement, and a set of passing integrity checks over obsolete versions, incomplete metadata and stable ids that cannot have run against anything. It built two local JSON import files of roughly 3,300 lines between them and never loaded the chunk payload, so the largest single piece of work in the run was thrown away and nothing downstream noticed. Every number in its tracker and its channel post is anchored to that count. A false pass on a check is worse than a missing one, because it is the thing that would otherwise have prompted someone to look.

If I had to break C and A apart in one line: both ended with a populated collection, and only one of them put it there.
