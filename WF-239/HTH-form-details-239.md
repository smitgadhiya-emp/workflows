Model - A 

Session Id : 019f8354-b26a-76f0-ab6c-77c0609a4b29

1. Overall task success — 3/7

Everything landed: sixteen sheet rows, thirteen Linear issues, one Teams post after Linear and Sheets, self-audit shown. And the log work is exact, every request count and distinct-origin count matches, including correctly dropping the seventh origin that only appears outside the window. But the two numbers I actually care about are shaky. It reports three wildcard-on-authenticated routes and leaves out GET /api/admin/export, which emits * and whose own data score in the same row says it returns account emails, spend and login data. And it marked thirteen of fifteen routes Unresolved, which guts an audit whose entire value is the resolved effective policy. On top of that it opened gap tickets on both routes that have no gap.

2. Task accuracy, ignoring speed — 4/7

The mechanical side is genuinely strong. Every traffic count and origin count ties to the logs, both dead origins found and traced to all three routes that still allow them, every reach and data tier correct, all score arithmetic correct, CODEOWNERS resolved properly including the last-wins overlap that puts the users service on users-team rather than express-team, and all four upsert cases held with both human owner/status pairs preserved. It also did real layer work rather than grepping: it traced that the sessions router mounts before the global cors() so OPTIONS falls through to the later middleware, and it went and checked Next.js header precedence instead of guessing. Where it goes wrong is judgment. The admin export call is a probable false negative that costs that route twenty points and moves it down the ranking. /api/newsletter, whose handler allows exactly the one origin that appears in its logs, got tagged split-config override and a ticket. And it treated "no Nginx location for this service" as unresolvable ambiguity, when the absence of a location block is itself a determinate fact about what Nginx contributes.

3. Efficiency — 4/7

End-to-end time (minutes): ~19 

Wrong actions / recovery: One stop, one steer. I'll give it credit here, the stop was exactly what I asked for. 

It named Linear specifically, confirmed the other three systems were reachable, and made zero writes rather than doing a partial run. That is the behavior in the brief. What I'd push back on is that it declared Linear unreachable on connector availability alone and never tested the signed-in browser session it then used for every single Linear action afterwards. Once moving, the seventeen-minute pass was well sequenced with no thrashing.

4. Writing quality — 3/7

The sheet's hard columns are good, and they're the ones that matter. "Configured policy per layer" and "winning layer per header" actually do the work instead of restating config, and the resolved-policy column explains the browser verdict rather than just listing headers, so the orders row tells me the wildcard plus credentials is rejected and that a surviving duplicate upstream header may independently invalidate it. That's the analysis I wanted. Everything around it is rough. The Teams summary is one unbroken paragraph, no bullets, no line breaks, nothing bold, em dashes throughout, and the top ten runs inline so I have to parse it by eye. The header row has no fill and no bold across seventeen columns, so I'm counting across to work out which column I'm reading.

5. Instruction following — 4/7

The exact scoring constants applied and shown as an addition I can redo, the window respected with out-of-window rows excluded, joined on route plus method, all four upsert cases correct including marking the removed legacy route Resolved rather than deleting it, traffic-unknown flagged instead of dropped, CODEOWNERS last-wins honored, one Teams post after both systems, self-audit shown, and it stopped and named the unreachable system exactly as instructed. Broken in three places. /api/products scored 25 and still carries a Linear link, when I said only routes at 45 or more get issues. /api/login has "none" in its own gap-types cell and still got an issue titled as a CORS gap. And the wildcard-on-authenticated count, which I told it is the first thing I'll be asked about, is missing a route that emits * on authenticated data.

6. Collaboration, autonomy, and verification — 4/7

Steering needed: One intervention, and the halt behind it was correct behavior rather than a failure.

Additional editing before I'd use it: Re-examine the admin export classification, close two tickets, and decide whether thirteen routes are really unresolvable.

The verification was real and it checked the right things on paper: route coverage, sheet-key uniqueness, threshold links, and specifically that every route it called wildcard-on-authenticated has both * and credentialed traffic evidence, which is the false-positive check I asked for by name. It also flagged the Linear assignee limitation honestly rather than inventing a team mapping. The problem is every check asked "did I apply my rule" rather than "is my rule producing a sensible answer." It confirmed twelve routes at 45-plus all have links without noticing one of those twelve has no gap at all, and it confirmed three wildcard routes without ever asking whether a fourth qualified.

7. Citation quality — 5/7

Best dimension here. Every row carries file and line for every layer that touched CORS, the configured policy written out per layer, which layer won each individual header, the score as a visible sum, the origins with per-origin counts, and a confidence value with a stated reason. The commit is pinned in the summary. Two things I specifically want to credit: it wrote "Policy not available" rather than inventing a weight for a gap type my scoring table doesn't cover, and it wrote "Nginx contribution not available" rather than assuming a contribution it couldn't see. That's the right instinct. Held at 5 because the confidence column reads "Low" on thirteen rows with near-identical boilerplate, so it tells me nothing about which reads to actually distrust, and because the admin export row asserts authentication isn't evidenced while the same row's data score says it returns login data.

8. GUI action correctness — 4/7

Clean browser work throughout the Linear side: confirmed the workspace and team, reconciled against the existing issues rather than duplicating, updated two, created nine, refreshed the closed one, and discovered the assignee limitation through the interface instead of assuming a mapping. It also ran a rendered sheet QA pass. No stalls, no misread page states, no retries. The gap is upstream of all of it, this is the path it should have checked before declaring the system unreachable.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - B 

Session Id : 019f837c-75df-7593-9ac3-ca26ad1c469a

1. Overall task success — 3/7

The plumbing is clean and in places better than the alternative: exactly ten open Linear issues matching the ten routes at 45 or above, the pre-existing closed Products issue correctly left closed instead of reopened for a route scoring 25, both human owner/status pairs preserved, and the removed legacy route retained as Resolved with the run date. Then the headline. It reports zero wildcard-on-authenticated routes. I defined that category, I told it that wildcard plus credentials is browser-rejected and those routes are broken as well as unsafe, and I said it is the first number I will be asked about. Its own summary concedes that the role route emits wildcard plus credentials at Express and it still didn't count it. It also dropped POST /api/orders, which I named in the brief as the exact win condition, from the top of the ranking to fourth at 55, behind a profile route with a dead whitelist entry.

2. Task accuracy, ignoring speed — 3/7

The underlying technical work is the deepest of any run here and I want to be specific about it, because it's real. It established that Nginx add_header appends rather than replaces, so the upstream Express ACAO survives alongside the Nginx one and the browser receives duplicates. It refused to infer Next.js header merging from a version range with no lockfile, built an isolated copy, and tested 14.2.5 directly, which correctly resolved that the /api/products wildcard is overwritten by the later generic rule while middleware on /api/profile replaces rather than duplicates. That is exactly the rigor I wanted. What it did with the result is the problem. Finding that wildcard-plus-credentials produces a duplicate the browser rejects is a reason to report those routes as broken as well as unsafe, which is what I asked for. It is not a reason to zero out the category. Reclassifying them instead as silently-blocked inflates that count to five routes and leaves the headline route carrying ten points of policy risk for a preflight mismatch, when the config it flags is a hand-written * on a credentialed path.

3. Efficiency — 4/7

End-to-end time (minutes): ~18 

Wrong actions / recovery: One stop, one steer. The stop was correct behavior and it did more homework than the alternative before making it

Testing for a Linear CLI and a credential in the environment before concluding, though it still never tried the browser session it later used for everything. The working pass carried two genuine research detours, a spec lookup on the header rules and a throwaway install to test Next.js behavior, which cost minutes but bought actual answers rather than assumptions. No thrashing anywhere.

4. Writing quality — 2/7

I said keep it skimmable and no full table dump. What I got is longer and denser than the previous run's: every gap count, all ten ranked routes with their gaps and issue keys, the actions, and the entire self-audit, all in one unbroken paragraph with bullet characters sitting inline, em dashes throughout, and nothing bold or headed anywhere. More information than the alternative and harder to read, which is the wrong trade for a channel post. The sheet header is unstyled the same way, no fill and no bold across the grid. It also quietly added an eighteenth column to a schema where I specified seventeen exactly.

5. Instruction following — 3/7

The window and join applied correctly, idempotency handled properly including the judgment to leave the closed Products issue closed rather than reopen it for a below-threshold route, both human owner/status pairs preserved, the removed route retained rather than deleted, traffic-unknown kept in scope, CODEOWNERS last-match resolved and the assignee limitation flagged honestly instead of assigning the wrong person, one post after Linear and Sheets, self-audit shown, and it stopped and named the unreachable system as instructed. Broken in three places. It reports zero wildcard-on-authenticated against a definition I wrote out. It opened a ticket titled as a CORS gap on /api/login while its own summary line for that route says the application CORS is consistent. And it changed the column schema I specified.

6. Collaboration, autonomy, and verification — 4/7

Steering needed: One intervention, behind a stop I'd asked for.

Additional editing before I'd use it: Restore the wildcard-on-authenticated classification, re-rank off that, and drop the login ticket.

The verification method here is the best on this workflow and it isn't close. It didn't reason about framework behavior from memory or from a semver range, it went to the specs for the Nginx inheritance rule and the Fetch CORS check, then built an isolated copy to test the actual Next.js merge order, then cross-checked its conclusions against both. It also refused to assign issues to the only available person and carried that exception into the self-audit rather than burying it. What it never did was step outside its own frame. The self-audit confirmed no duplicate keys, no duplicate issues, matching counts, nothing dropped, and never asked the obvious question: it was about to tell me I have zero wildcard-on-authenticated routes in a codebase where three handlers hand-write Access-Control-Allow-Origin: *. That is the moment to stop and check the premise, not the arithmetic.

7. Citation quality — 5/7

Genuinely strong. It cites the rules it relied on rather than asserting behavior, the Nginx inheritance rule, the Fetch CORS check, the Next.js header override order, and pins the commit. Rows carry per-layer file and line, per-header winners, visible score breakdowns, and confidence. It is precise about what it could not see, naming the missing Nginx route mapping and the absent runtime variables per row rather than glossing. The thing that costs it: all of that careful evidence is marshalled in support of a classification that contradicts the definition I handed it.

8. GUI action correctness — 4/7

Clean browser work on the Linear side. It verified the session and the team, enumerated the existing route-keyed issues before creating anything, updated two in place, created eight, correctly left the closed one closed, and discovered the assignee limitation by opening the picker rather than assuming. It also did a rendered readback on the sheet. No stalls, no misread states, no retries. Same upstream gap as before, this is the path it should have tested before declaring the system unreachable.



=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - C 

Session Id : 019f8394-f32c-7121-b99b-d4d11128a44a

1. Overall task success — 4/7

It got itself to Linear without a rescue. It found no connector and no CLI, decided the browser was a legitimate documented fallback, verified the CORS team was reachable there, and carried on. That's the exact blocker that cost me a turn on both other attempts. It also produced the most complete sheet and the best-written issues of the batch. Then the same two structural problems land. It reports zero confirmed wildcard-on-authenticated on a codebase where three handlers hand-write Access-Control-Allow-Origin: *, and it marks thirteen of fifteen routes Unresolved. And GET /api/admin/export, an authenticated admin export with a hand-set wildcard, came out at 30 with no ticket, which means the route with no traffic to make it visible is now invisible.

2. Task accuracy, ignoring speed — 3/7

The evidence work is the most thorough here. Every row spells out the configured policy per layer, the winner per header, an explicit reason for what it couldn't resolve, and a score breakdown labelled "partial" so I can see the number is incomplete. It also refused to guess the status route's data class from the route name when the backend source is missing and scored only the components it actually had, which is exactly right. Where it fails is systematic. Because the checked-in Nginx has no location for most services, it declines to score wildcard policy risk at all: 45 points gone on orders and on the role handler that emits * plus credentials, 35 gone on public config, and admin export knocked down to 30 and off the ticket list. The absence of an Nginx location block is a fact about what Nginx contributes, not an unknown. Treating it as an unknown deflates the whole ranking until a dead whitelist entry on a profile route is my number one exposure.

3. Efficiency — 4/7

End-to-end time (minutes): 30

Wrong actions / recovery: No stops, no steers, and one recovery that matters. 

It hit the missing Linear connector, checked for a CLI, found none, and went to the browser itself. I'd rather have thirty unattended minutes than nineteen plus a turn of mine. What costs it is that thirty is still the longest run on this job, and a real slice of it went into writing per-row narrative that repeats the same "the checked-in Nginx front door has no matching location/proxy_pass" paragraph verbatim on thirteen rows.

4. Writing quality — 3/7

The sheet is the best-documented artifact on this workflow, and the Linear issues are better still. The checkout issue has the audit basis with commit and window, the gaps as bullets, an effective-versus-intended section, the layer resolution with file and line per layer, the winners, the preflight verdict, and the score as visible arithmetic. That is the issue I want landing in a team's backlog. The Teams post is the third wall in a row: hyphens and em dashes running inline with no line breaks, nothing bold, no headings, and sections colliding so "1 prior route retained as Resolved" runs straight into "Gap counts" mid-line. The sheet header is unstyled the same as the others.

5. Instruction following — 4/7

Window and join correct, all four upsert cases intact with both human owner/status pairs preserved and the removed legacy route retained as Resolved, traffic-unknown kept in scope, idempotency clean with the Done Products issue correctly left alone rather than reopened for a route scoring 25, CODEOWNERS resolved with the missing-assignee limitation disclosed instead of assigned to the wrong person, one post after both systems, self-audit shown, and every required system reached without my help. Broken: zero wildcard-on-authenticated against a definition I wrote out and named as my first question. It knowingly left /api/login with no Linear link when my rule says 45 or above gets one. And it added an eighteenth column to a schema I specified with seventeen.

6. Collaboration, autonomy, and verification — 5/7

Steering needed: None. The only run here that didn't cost me a turn.

Additional editing before I'd use it: Restore the wildcard-on-authenticated classification and re-rank off it. The rest I'd use as-is.

Two moments earn this score. First, the Linear fallback, where it made the call the other two wouldn't. Second, and better: at the very end it noticed /api/login scores exactly 45 purely from auth-data exposure and reach while its policy is completely clean, worked out that opening an issue titled "CORS gap on POST /api/login" would be a lie, chose sheet-only, and then told me flatly that this does not satisfy the stricter reading of my own rule. That is the judgment I wanted and neither other attempt made it, they both just opened the ticket. What holds it at a 5 is the familiar blind spot: the self-audit checked coverage, uniqueness, ordering and link integrity and never once asked whether "zero wildcard-on-authenticated" is a defensible sentence to hand a security reviewer.

7. Citation quality — 5/7

Best on the job. Per-layer file and line on every row, the configured policy written out rather than summarized, the winner named per individual header, origins with per-origin counts, and score breakdowns explicitly labelled partial where components are missing, which is a small thing that tells me a lot. It validated framework behavior rather than asserting it and pinned the commit in the sheet, the issues, and the summary. Two deductions: the Unresolved explanation is copy-pasted verbatim across thirteen rows so that column stops carrying per-route information, and all of this careful sourcing sits underneath a classification that contradicts the definition I handed it.

8. GUI action correctness — 5/7

Cleanest browser work of the batch and the one that mattered most. It treated Chrome as a deliberate documented fallback for the single system with no connector rather than a workaround, confirmed the team and enumerated the existing route-keyed issues before writing anything, updated two in place, created seven, left the Done issue untouched, and found the assignee limitation by opening the picker instead of assuming. The issue bodies it composed through that interface are the best-structured artifacts produced on this workflow. 




=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - D 

Session Id : 019f83e5-fc53-7161-a493-9b124250669e


1. Overall task success — 5/7

It ran the same duplicate-header analysis the other careful attempts did, and then made the distinction they both missed. Express res.header replaces; Next.js headers() plus a handler appends. So the Next routes really do emit two ACAO values and are browser-invalid, but PUT /api/users/:id/role emits a single * from the handler with credentials surviving from the global cors(), and the logs show 260 credentialed requests against it. That is a genuine wildcard-on-authenticated route, it named it, scored it 82, and ranked it first. It's also the only run besides the first to keep the 35-point wildcard score on public config. The Linear board is the cleanest of the four: eleven open issues matching exactly the eleven routes at 45 or above, nothing open below threshold. Held back by admin export landing at 30 with its issue closed, thirteen rows still Unresolved, a gap ticket on the clean login route, and a summary I still can't skim.

2. Task accuracy, ignoring speed — 5/7

Best of the batch. It didn't reason about Next.js header merging from a version range, it cloned the repo, built it, and read the raw headers, then applied the result with a precision nobody else showed. That's the difference between reporting zero wildcard-on-authenticated routes and reporting the one that's real. The confidence column actually varies and carries meaning: High on the two routes with a complete edge chain, Medium where the app resolves but the Nginx mapping is missing, Low on status. Public config keeps its wildcard score instead of being zeroed for lack of an edge route. Against it: GET /api/admin/export hand-sets a wildcard on an authenticated export and comes out at 30 with a Done issue, so the route I'd most want surfaced is the quietest thing in the deliverable. The seven-route silently-blocked count is also the most aggressive reading of the duplicate thesis, and it opened a gap ticket on a route its own row marks "none in app layer."

3. Efficiency — 5/7

End-to-end time (minutes): ~14.5 

Wrong actions / recovery: One stop, one steer, and the fastest run on this job. 

The stop was the sanctioned kind and it reported all five systems' status cleanly, but like the others it declared Linear unreachable on connector availability without testing the browser session it then used for everything. The runtime verification detour cost minutes and bought the finding that separates this run, so I'll take that trade. It did leave Next.js build and dependency artifacts behind in the cloned directory when cleanup failed, and said so rather than hiding it.

4. Writing quality — 4/7

The sheet is well organized and the added rank and source-commit columns are genuinely useful given the brief is about reproducibility, every row is stamped with the commit it was resolved against. The confidence column gives a reason per row instead of boilerplate. The Teams post is the most informative of the four and still the same wall: bullets inline, em dashes throughout, no line breaks, nothing bold. It does at least carry labeled sections and explicitly explains why checkout and admin export are excluded from the wildcard count, which is exactly the reasoning I'd want if I could actually read it at a glance. Header unstyled like the rest.

5. Instruction following — 5/7

Window and join correct, all four upsert cases intact with both human owner/status pairs preserved and the removed route retained as Resolved, traffic-unknown kept in scope, the threshold applied cleanly with eleven open issues for the eleven qualifying routes and nothing open beneath it, CODEOWNERS resolved with the assignee limitation disclosed rather than mis-assigned, one post after both systems, and a specific self-audit. Two things off. It opened a ticket titled as a CORS gap on /api/login when its own row says there is no app-layer gap. And it restored seven previously deleted Linear issues rather than opening fresh ones, which does avoid duplicate route keys but resurrects things someone deliberately removed. It told me plainly that it had done it.

6. Collaboration, autonomy, and verification — 5/7

Steering needed: One intervention, behind a stop I asked for.

Additional editing before I'd use it: Revisit admin export and drop the login ticket. Everything else I'd use.

The verification is strong and, crucially, aimed at the right question. The other careful runs established that duplicates happen and stopped there. This one went on to ask where duplicates don't happen, which is what produced the one correct wildcard finding. Its self-audit then explicitly rechecks that single classification against both the source headers and the credentialed log rows, which is the false-positive check I asked for by name, and it's checking a claim it made rather than one it talked itself out of. It also disclosed the leftover build artifacts instead of quietly leaving them. What keeps it at a 5: it never turned that same scrutiny on admin export, which hand-sets a wildcard on an authenticated export and ends at 30 with a closed ticket, and it opened a gap issue its own data contradicts.

7. Citation quality — 5/7

Per-layer file and line on every row, configured policy written out, winner named per header, visible score breakdowns, and a source-commit column so the sheet dates itself. It verified framework behavior empirically and then recorded the reproducibility caveat in the affected rows ("package range unlocked") rather than presenting a tested result as settled fact. The summary names the actual evidence behind its one wildcard call: handler sets star, global cors leaves credentials true, logs show 260 credentialed requests. Same deduction as the others, the Unresolved reason repeats across rows, and admin export's row asserts it isn't a strict wildcard-on-authenticated without being able to run the credentialed-traffic test it applied elsewhere, because there's no traffic.

8. GUI action correctness — 4/7

Competent browser work: verified the session and team before resuming, updated nine issues in place, created three, restored seven deleted keyed issues rather than duplicating them, marked the below-threshold one Done instead of leaving it open, and found the assignee limitation by opening the picker. No stalls, no misread states. Two things hold it at a 4. The same upstream gap, it should have tested this path before calling the system unreachable. And restoring deleted issues is a state change on things someone chose to remove, which I'd want asked about rather than reported afterwards.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================
=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Ranking: D > C > A > B

Best overall: Model D

Overall Best Model is D. It ran the same duplicate-header analysis as the other careful attempts, then went one step further and asked where the duplicate doesn't apply. Express res.header replaces, Next.js headers() plus a handler appends, so the Next routes genuinely emit an invalid multi-value policy while PUT /api/users/:id/role emits a single * with credentials surviving from the global cors() and 260 credentialed requests in the logs to prove it. That's the one real wildcard-on-authenticated route, it named it, scored it 82, ranked it first, and rechecked it against both the source headers and the log rows. It was also the fastest run and left the tidiest Linear board, eleven open issues matching exactly the eleven routes at 45 or above with nothing open below.

Model C is second on the strength of process rather than answer. It's the only run that never needed me: it found no Linear connector, no CLI, decided the browser was a legitimate fallback, and carried on. It produced the most complete sheet and by far the best-written issues. And it made the single best judgment call of the batch, noticing that /api/login crosses the 45 threshold with a completely clean policy, refusing to open a ticket titled as a gap on a route with no gap, and then telling me flatly that this breaks my own rule. It sits second only because it still reports zero wildcard-on-authenticated and it took thirty minutes to get there.

Model A never did the duplicate-header analysis at all, and paradoxically that left it with the most usable headline. It reports three wildcard-on-authenticated routes, which is the closest anyone got to reality, but it arrived there by not asking the harder question rather than by answering it. It also leaked a Linear link onto a route scoring 25 and left five gap types classified differently from every other run.

Model B did the same rigorous verification as C and D and stopped one step short of the payoff. Having proved the duplicate breaks the browser check, it treated that as grounds to zero the entire wildcard category, ranked a dead-whitelist entry on a profile route above the one I named in the brief as the win condition, and produced the densest summary of the four, closer to the table dump I explicitly asked it not to send.

What made them separate: all four resolved the layers and joined the logs correctly, so the ranking came down to one question, what to do after discovering that Nginx and Next append rather than replace. D used that discovery to sharpen the wildcard finding down to the one route where it genuinely holds; C and B used it to erase the category entirely, and A never got there. Underneath that, C is the only run that got itself past the Linear blocker unaided and the only one that refused to file a ticket its own data contradicted, which is why it outranks a run that happened to report a closer number for weaker reasons.