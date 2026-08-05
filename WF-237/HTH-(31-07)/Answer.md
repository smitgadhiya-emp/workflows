
Model - A - gpt-5.6-cat with Extra High intelligence

Session Id : 019fd1c3-4c52-7f03-85b2-3dbec658d032

1. Overall task success - 3/7

The version work is right. It read the pins off the manifest and lockfiles exactly, Node 18.19.0, Express 4.18.2, React 18.2.0, MongoDB server 5.0, driver 5.9.2, Mongoose 7.6.13 and jsonwebtoken 9.0.2, bounded the window at 36 questions with the four out-of-window rows excluded, and caught the trap that decides whether this corpus is worth anything: the driver's versioned doc URLs now redirect to current, so it refused them as version evidence and moved to the immutable 5.9 API site and the v5.9.2 tag. The corpus PR is open against main through a fork after a genuine permissions block, human notes survived, Teams went out once, and the audit is written into the PR. Two things pull it down. Only 3 questions reached the Gaps tab where 5 belong, so the ones where the official docs genuinely give nothing, the $in ceiling, token storage and production pool sizing, got answers instead of the honest gap I said I would rather have. And the code-contradiction count landed at 14 against the 5 that are in the code, inflated by three findings taken from an internal auth runbook, which is not what "our code disagrees with the docs" measures. 26min 36s is also a long route to that.

2. Task accuracy, ignoring speed - 3/7

Pins, window boundaries and conflict verdicts are all correct: Express 4 needs catch and next(err), React 18.2 has no form Actions, MongoDB 5.0 forbids a sharded $lookup with 5.1 as the boundary, Node 18 has no --env-file, driver 5 is promise-only. The errors are in the two deliverables the request weights most heavily. Three gaps against five means Q23, Q25 and Q27 were answered when the docs give no hard number, no position and no workload figure respectively, which is padding a weak answer to look confident. And the contradiction count is nearly three times the real one, with the extras coming from a policy document rather than published documentation, so the headline figure a reader carries away does not measure what was asked. It also filed the tangled Mongo-backed session question as a gap when it was answerable once untangled into its Express, Node crypto and MongoDB parts.

3. Efficiency - 3/7

End-to-end time (minutes): 26min 36s.

Wrong actions / recovery: One. The first push was rejected because the active GitHub account has read-only access to the upstream repo. It checked the other authenticated identities and published through a fork without stalling.

Research and corpus writing ran clean. The drag is self-inflicted rework at the end. Having already written the corpus and applied the row outcomes, it went back to Drive for an internal auth runbook, revised its contradiction count from 11 to 14, and then had to reopen Q16, Q25, Q35, the corpus and the gap rationale to match. That is a full pass over finished outputs, and it is most of why this ran nearly a third longer than the work needs.

4. Writing quality - 3/7

The PR body is properly sectioned into what changed, why, impact and validation, and it reads well. The channel post is the problem and it is the artifact the team actually sees. The five counts are jammed onto a single line separated by bullet characters with no line breaks, the version conflicts follow in the same run-on style, and the two links and the audit note trail off the end of the same block. Nothing is emphasised, so there is no entry point at all. Em dashes throughout.

5. Instruction following - 3/7

Met: manifest and lockfile read first, repo code treated as input, Chrome research against official sources, version claims backed by evidence with unverifiable ones refused rather than guessed, both sides of each genuine conflict kept with the pinned behaviour first, the window bounded inclusively, prior-run rows updated rather than duplicated with human notes intact, the two existing gap rows updated by id, a PR against main rather than a push, one Teams post at the end, and the audit shown. Three misses. The confidence bar let three thin-coverage questions through as answers instead of gaps, which is the specific behaviour the request warns against. The contradiction count mixes docs conflicts with internal-policy deviations, so it does not answer the question that was asked. And the summary is not readable at a glance.

6. Collaboration, autonomy, and verification - 4/7

Steering needed (how often / how severe): None. It ran the full job across four systems unattended, including diagnosing the read-only push failure and finding a publishable path on its own.

Additional editing before I'd use it: Moderate, about 30min. Move the three thin-coverage questions into the gaps tab, split the contradiction count back to the code-versus-docs set, untangle the session question into an answer, and rewrite the post.

The self-audit is genuine: 36 of 36 rows terminating exactly once, all 29 corpus entries carrying version evidence and sources, every local cross-link resolving, human notes checked, and it held the Teams post until the PR URL and the sheet counts were rechecked together. Refusing the redirecting driver docs rather than taking the easy citation is the same instinct and it is the right one. The gap is that when the internal runbook surfaced it folded three policy deviations into a count the request defines against the docs, and nothing in the audit asked whether that belonged. The audit confirmed the number was internally consistent, not that it was measuring the right thing.

7. Citation quality - 4/7

The evidence discipline on the driver documentation is the strong part and it is exactly the trap the request sets. It followed the redirect behaviour far enough to establish that those pages cannot support a version claim, ruled them out, and cited the immutable API site and the tagged release instead. Every corpus entry carries an applies-to, its version evidence and its sources, and version-unverified is used where nothing could be established. The seam: three of the fourteen contradictions cite an internal auth guide, so a reader following the headline number to its source lands on something that is not documentation, and the post presents all fourteen as a single figure with no distinction drawn.

8. GUI action correctness - 4/7

The Chrome work produced a genuinely useful finding rather than just fetching pages: it followed the driver docs through their redirects until it could prove they were unversioned, and treated that as disqualifying evidence. It also ran a rendered pass over the sheet after the answer writes and reported wrap formatting checked. No wrong targets and nothing stuck. Weakness: the research spanned several separate Chrome passes with re-reads between them rather than one sweep per technology, which is part of why the browser phase stretched.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - B - gpt-5.6-fish with Extra High intelligence

Session Id : 019fd1f4-4993-7862-bef3-e65b0441f02d

1. Overall task success - 4/7

Pins read exactly off the manifest and workspace lockfiles, the window bounded at 36 with all four out-of-window rows preserved untouched, the redirecting driver docs caught and excluded as version evidence, and the corpus PR opened against upstream main through a fork after the push was refused for read-only access. It went further than the brief on making the run repeatable: 19 corpus files, 204 internal links validated, and a script that hard-asserts the file count, the 36 rows, each terminal state and the contradiction count, exiting non-zero if any of them move. Four gaps against the five that belong is close, though the $in ceiling question still got an answer where the docs give no number. The contradiction count reads 10 against the 5 that are in the code. The channel post is the weak artifact, a solid block with no headers anywhere.

2. Task accuracy, ignoring speed - 4/7

The version work is correct throughout and the conflicts are called for the pin rather than for what is newest, including the 5.1 sharded $lookup boundary, the 20.6 env-file boundary, the Node 22 ESM require boundary and the React 19 Actions boundary. Terminal states reconcile cleanly at 26 answered, 6 consolidated and 4 gaps. Two errors. The contradiction count is doubled: all five real ones are there and named by mechanism, but so are extras that inflate the number the request asks for by name. And six consolidations is one or two beyond what the duplicate clusters support, which means a question that warranted its own answer is pointing at another row. The four gaps miss the $in ceiling, where the docs give nothing at all.

3. Efficiency - 4/7

End-to-end time (minutes): 19min 32s.

Wrong actions / recovery: One. The push was refused for read-only access on the upstream repo. It checked every configured GitHub identity and the connected app before concluding a fork was the only path, then used the fork it already owned.

Steady with no rework on the analysis. Research, corpus, sheet, PR, audit and post each ran once and nothing was revisited. The drag is corpus volume: 19 files and 204 internal links for four technologies plus auth and data-access is more surface than the brief asks for, and more to keep consistent the next time this runs.

4. Writing quality - 2/7

The PR body is sectioned properly and reads well. The channel post does not. After the title line, everything runs as one unbroken block: the four counts, the reconciliation arithmetic, five version conflicts, the code-audit summary, both links and the closing audit note, with no headers, no line breaks and no emphasis anywhere. The numbers I would actually read are buried mid-paragraph behind two clauses. Em dashes throughout. This is a summary meant to be skimmed by a team and it has to be read start to finish to extract anything.

5. Instruction following - 4/7

Met throughout: manifest and lockfile first, repo code read as input, Chrome research against official documentation, changelogs, tagged READMEs and dated Stack Overflow pages, unversioned redirects refused as evidence, both sides of each conflict kept with the pinned behaviour first and upgrade deltas recorded, the window bounded inclusively with the out-of-window rows preserved, prior answers updated with human notes kept, gap rows updated by id, a PR targeting main rather than a push, a single Teams post at the end, and an audit shown and machine-checked. Misses: the contradiction count conflates code-versus-docs conflicts with other defects so it does not answer what was asked, at least one consolidation is over-applied, and the summary fails the readability a channel post needs.

6. Collaboration, autonomy, and verification - 5/7

Steering needed (how often / how severe): None across 19min, including diagnosing the permissions problem properly rather than assuming it, checking all configured accounts and the connected GitHub app before falling back to a fork.

Additional editing before I'd use it: Moderate, about 25min. Split the contradiction count back to the docs set, re-check the two extra consolidations, move the $in question to gaps, and rewrite the post with headers.

The verification is where this run invests most, and it invests well. Rather than asserting the reconciliation it wrote a validator that fails the run if the file count, the 36 question rows, any of the three terminal-state totals or the contradiction count drift, and then ran it. It validated all 204 internal links, read the sheet back independently, and confirmed every corpus file cited by an answer exists in the PR. That is the reproducibility the request opens by demanding, built rather than claimed. The gap is that a validator locks in whatever numbers it was handed, so an inflated contradiction count and an over-applied consolidation pass it exactly as cleanly as correct ones would.

7. Citation quality - 4/7

Version claims carry tagged or explicitly version-scoped evidence, the redirecting driver documentation is named and excluded rather than quietly cited, version-unverified is used where nothing could be established, and Stack Overflow pages are dated rather than taken on votes. The corpus records archived-versus-current doc limitations, which is the distinction that makes a version tag checkable. The seam: the ten contradictions are presented as a single figure covering docs conflicts and general defects together, so a reader cannot get the number that answers "where does our code disagree with the docs" without opening the file and separating them by hand.

8. GUI action correctness - 4/7

The Chrome research was systematic and it produced the redirect finding, following the driver's supposedly versioned pages far enough to establish they resolve to current. It went back through Chrome for the final pre-post audit as well, and there were no wrong targets or stuck pages. The weakness is what it did not do on screen: there is no rendered pass over the sheet after the answer writes, so the workbook went out confirmed by value readback without anyone looking at how it displays.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Model - C - gpt-5.6-dog with Extra High intelligence

Session Id : 019fd20c-13e0-7de1-80d8-42decef0a33a

1. Overall task success - 4/7

The disposition work holds up under checking. 26 answered, 5 consolidated and 5 gaps, with the gaps landing on the questions where the official docs genuinely give nothing, and it published the duplicate mapping so every consolidation can be verified rather than trusted. All three human notes survived by name, G-001 and G-002 were updated in place with three new gap rows added, and when Priya's note asked for an internal runbook link it said it could not locate one rather than inventing it. Its Stack Overflow handling is what the request asks for and rarely gets: it dated the 2019 Suspense answer, established it was written against CRA and the old package rather than the pinned React 18.2 stack, rejected it, recorded the rejection, and kept the question as a gap instead of promoting it on votes. Against that: eight contradictions against the five in the code, a corpus at ten files that is thin for the surface it covers, and two stops before it could finish.

2. Task accuracy, ignoring speed - 4/7

Pins exact, window right, and the conflicts called for the pin with the 5.1 sharded $lookup boundary, the 20.6 env-file boundary, the Node 22 ESM require boundary and the React 19 Actions boundary all named. The terminal split matches what the log actually contains, five gaps rather than fewer, and all five map to real rows G-001 through G-005 covering the RTL and Suspense stack, token transport, refresh rotation, measured pool capacity and session storage. Two errors. Eight contradiction records where five exist in the code, so the headline is inflated even though the extras are real defects. And Q34 was consolidated into Q16 when it is a vague, code-specific question that warranted its own answer against auth.js, though because Q16's answer names the decode bug the finding still reaches a reader. The $in ceiling question was answered rather than gapped.

3. Efficiency - 3/7

End-to-end time (minutes): about 19min 30s of model run time across 3 turns, 5min 51s, 42s and 12min 55s, inside roughly 25min of clock once my two clearances are counted.

Wrong actions / recovery: None off-path. Both pauses were the stop condition working as written, since Stack Overflow is one of the named research sources and it sat behind a Cloudflare challenge and then a CAPTCHA.

The analysis ran clean with no rework and the corpus, sheet, PR and post each went out once. The cost is the shape of the run. Three turns and two handoffs, and the second stop came 42 seconds into the resumed turn, so a whole turn was spent discovering a second block sitting behind the first. Refusing to work through a CAPTCHA unprompted is the right call, but checking whether the search path was clear during the first handoff would have collapsed both into one interruption.

4. Writing quality - 3/7

The channel post has structure: two paragraph breaks, an opening that carries the reconciliation arithmetic, and the duplicate mapping and gap ids spelled out so the counts can be checked without opening the sheet. That last part is genuinely useful. It still reads as dense prose. The version conflicts, the code findings and the audit each occupy a full paragraph with no headers, no bullets and nothing emphasised, so finding a specific number means reading the paragraph it sits in. Em dashes throughout. The PR body is clear and well organised, though the corpus at ten files is thin for four technologies plus auth and data-access with bidirectional links expected between them.

5. Instruction following - 5/7

Adherence is close throughout and in several places more precise than required. Manifest and lockfiles read first with the workspace lockfiles distinguished from the root shell. Repo code read as input and actually used to resolve the vague one-liners. Research in Chrome against official and tagged sources with the redirecting driver docs excluded. Both sides of each conflict kept with the pinned behaviour first and the upgrade deltas recorded. The window bounded inclusively with QX1 through QX4 untouched. Prior rows updated with Ravi's, Priya's and Meera's notes preserved by name, and the gap rows updated by id rather than duplicated. A PR against main through a fork rather than a push to main. One Teams post at the end. The audit shown with every row's disposition. It also did the thing the request singles out and most runs skip: it stopped and named the unreachable source instead of substituting another one quietly. Misses: eight contradictions against five, and Q34 consolidated where it warranted its own answer.

6. Collaboration, autonomy, and verification - 4/7

Steering needed (how often / how severe): Two, and both were the stop condition doing its job. Stack Overflow is one of the named sources and it was behind a Cloudflare challenge, then a CAPTCHA on the focused search. It refused to bypass either, left the tab open for handoff, and made no corpus, sheet, PR or Teams writes while blocked, which is right on a run that would otherwise publish a corpus built on a source it could not read.

Additional editing before I'd use it: Light, about 15min. Trim the contradiction count to the code-versus-docs set, move the $in question into the gaps tab, and break the post into headed sections.

The verification is thorough where it matters. It reconciled every row's disposition, checked all five gap ids against the tab, confirmed the three human notes survived by name, confirmed the four out-of-window rows were untouched, verified the PR holds all ten cited corpus files, and ran an internal anchor check. The rendered pass caught a real defect, three newly added gap rows inheriting blank-row overflow formatting so their descriptions clipped, and it fixed the style without touching the content. The gap is the same one that runs through this task: nothing asked whether eight contradictions is the number the request wanted, or whether Q34 belonged in a consolidation.

7. Citation quality - 5/7

The Stack Overflow screening is the model of what this request asks for. It dated the 2019 answer, established it was written against CRA and Babel and the old react-testing-library package rather than the pinned React 18.2 and Vite stack, rejected it, and recorded the rejection in the corpus as a version-unverified boundary rather than dropping it silently or letting the vote count carry it. The redirecting driver documentation was excluded on the same principle. Every corpus entry carries linked version evidence or an explicit unverified boundary, and it recorded the exact commit SHA the code was read at, so the code findings are reproducible against a fixed tree rather than against whatever main looks like later. It also declined to invent a runbook link it could not find. The seam: the eight contradiction records are presented as one count without separating the ones that contradict published documentation from the ones that are simply defects.

8. GUI action correctness - 4/7

Substantial and honest browser work. It reached the official sites and tagged READMEs, hit two separate Stack Overflow blocks and reported both rather than routing around them, and once cleared it screened the search results properly instead of taking the first accepted answer. It also ran a rendered pass over the sheet and caught the clipped gap rows, then re-rendered to confirm the fix. Right targets throughout, nothing thrashed. The weakness is sequencing: the second block was only discovered after resuming, so the on-screen work stalled twice on the same site when one check during the first handoff would have surfaced both.


=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================
=====================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=====================================================================================================


Ranking: C > B > A

Which model is best overall: C

Why the top model is best, and what separates the other models:

The version half of this job came back right across all three, and it is the half that decides whether the corpus is safe to use. Every run read the pins off the manifest and the workspace lockfiles rather than the root shell, and landed on Node 18.19.0, Express 4.18.2, React 18.2.0, MongoDB server 5.0, driver 5.9.2, Mongoose 7.6.13 and jsonwebtoken 9.0.2. Every run answered for those versions rather than for what is newest: Express 4 needs catch and next(err), React 18.2 has no form Actions, MongoDB 5.0 forbids a sharded $lookup with 5.1 as the documented boundary, Node 18 has no --env-file, driver 5 dropped callbacks. Every run bounded the window at 36 questions with the four out-of-window rows left alone, preserved the human notes, hit the same read-only push refusal and resolved it correctly through a fork targeting upstream main rather than pushing to main, and posted once with an audit shown. And all three caught the evidence trap I care most about, that the driver's supposedly versioned doc URLs now redirect to current, and refused them as version evidence rather than citing a page that cannot support the claim.

Where they separate is the two deliverables I said I would spot-check. Every run inflated the code-contradiction count above the five that are actually in the repository, and every run under-filled the Gaps tab against the five questions where the official docs genuinely give nothing.

C is best because it got closest on both and was straightest about its sources. Five gap rows, mapped to G-001 through G-005, on the questions that deserve them, and it published the full duplicate mapping so every consolidation can be checked rather than taken on trust. Its Stack Overflow handling is the thing that separates a real corpus from a pile of bookmarks: it dated the 2019 Suspense answer, established it was written against CRA and the old package rather than the pinned stack, rejected it, recorded the rejection as a version-unverified boundary, and kept the question as a gap instead of letting the vote count carry it. It preserved all three human notes by name, updated the existing gap rows in place, refused to invent a runbook link it could not locate, and recorded the commit SHA its code findings were read at. It also did the thing the request singles out and stopped when Stack Overflow was unreachable rather than substituting another source quietly, which cost me two clearances but is exactly the behaviour I asked for. Its eight contradictions still overstate the five, its corpus is thin at ten files, and the second stop landed 42 seconds into a resumed turn.

B is second and it is the strongest on process. It reached the same result in 19min 32s with no steering and no rework, diagnosed the permissions failure properly by checking every configured identity and the connected app before falling back to a fork, and built something the request explicitly asks for: a validator that hard-asserts the file count, the 36 rows, each terminal state and the contradiction count and fails the run if any of them drift. It validated all 204 internal corpus links and confirmed every cited file exists in the PR. What holds it behind is that the validator locks in whatever numbers it was given, so a doubled contradiction count and an over-applied consolidation pass it as cleanly as correct ones, and its channel post is a single unbroken block with no headers at all, which is the artifact the team reads.

A is third. Its evidence discipline on the driver docs is as good as anyone's and its self-audit is real. But it filled only three gap rows where five belong, so three questions with genuinely thin official coverage got answers instead of the flagged gap I said was worth more, and that is the specific failure mode the request warns about. Its contradiction count reached 14, with three of those pulled from an internal auth runbook rather than from documentation, so the headline number does not measure what was asked. Finding that runbook mid-run also sent it back over finished outputs to rework the corpus, the gap rationale and three answers, which is most of why it took 26min 36s.

If I had to break C and B apart in one line: B proved its numbers were consistent, and C got closer to the numbers being right.
