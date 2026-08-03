# WF-092 — Form 2 (OpenAI Eval Feedback) — Model A responses

**Workflow:** WF-092 Terraform Drift Court: three-way reconciliation with a destructive-change guard (seeded `infra-live` repo, **v2 hardened**)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (first Form 2 round; the four-model set A/B/C/D). B/C/D to follow on the same seed.
**This file:** Model A only — **gpt-5.5-cyan, High intelligence** (confirmed on the run: "5.5 Cyan High")
**Session ID:** `[paste this run's session ID]` (runtime 10m 27s)
**Run dataset:** the seeded `infra-live` repo (`main.tf` + `terraform.tfstate` + `live-cloud-snapshot.json` +
`cloudtrail-events.json` + `CHANGES.md`), 7 drifted resources + 1 clean + 1 unmanaged live topic. Apps: GitHub
(reconcile PR + security issues), local code (git, `jq`).
**Status:** Model A done, **clean sweep on judgment — 9 of 9 signals**, acing all three v2 traps (break-glass
db-sg codified, nested port-22 SSH backdoor caught + reverted, SNS topic imported), plus the six v1 calls, zero
destructive ops. Cleaner than the Form-1 v2 run in one way: **it did not stall** (worked around the empty
workspace on its own). The recurring rough edge: it **over-filed security incidents (three, splitting the S3
owner-tag into its own #10)** where the correct is two, and it ran slow (10m 27s). Honest Form 2: correct-judgment,
rough-run = mostly 5s, with efficiency at 4. (Form 1's outcome field stays a 4; Form 2 scored honestly.)

> **Persona (voice).** Platform engineer who owns the Terraform state for a prod AWS account and runs the weekly
> drift gate. Dry, evidence-first, cares that identical-looking drift gets the right verb off the attribution, and
> that nothing destructive ever gets proposed. Does not sign a reconcile until the code-vs-live end-state is a
> clean no-op for the right resources.

---

## Metadata used (persona + scoring inputs) — same as Form 1

| # | Field | Value |
|---|---|---|
| 1 | Occupation / career | Software Developer |
| 2 | Occupation + workplace (persona voice) | Platform engineer owning the Terraform state for a prod AWS account, running the weekly drift gate |
| 3 | Time to complete WITHOUT a model (min) | 120 |
| 4 | Times per month | 4 |
| 5 | Workflow difficulty (1-7) | 7 |
| 6 | Initial Codex test rating (1-7) | 4 (all nine per-resource calls right incl. the three v2 traps, and no stall this time, but it over-filed the S3 owner-tag as a third security incident and ran slow at 10m 27s) |
| 7 | Notes | Draft PR #7 on reconcile-drift, main.tf only, with the decision table. Codified: web-sg 443 tightening, db-sg break-glass bastion rule, RDS resize, EBS growth to 500. Ignored: autoscaler desired_capacity. Reverted (kept out of code): public SSH on web-sg, S3 public-read ACL (+ tag). Imported: unmanaged SNS topic (explicit `terraform import`, not a create). Log group untouched. Zero destructive ops, nothing merged. All three v2 traps caught. **Rough edge:** filed three security incidents (#8 SSH, #9 ACL, #10 owner-tag), one too many, the tag is part of the S3 change. No stall (worked around the empty workspace + the no-gh situation on its own, unlike the Form-1 run). |

---

## Grading-key check (the nine scorable signals, from the main file)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | SG 443 codified, not reverted (config-remediation) | ✅ | "Codified the authorized security-group... changes"; "an accounted-for guardrail change" on the web group |
| 2 | RDS resize codified (INC-2214) | ✅ | "Codified the authorized... RDS... changes" |
| 3 | ASG `desired_capacity` → `ignore_changes` | ✅ | "Ignored autoscaler-managed desired_capacity" |
| 4 | S3 `public-read` reverted + security issue | ✅ | "Staged reverts for... the public S3 ACL"; incident #9 |
| 5 | EBS grown → codified to 500 + destructive-guard, no downsize | ✅ | "Codified the authorized... EBS changes"; "No downsize, delete, or replacement is proposed" |
| 6 | Clean log group left untouched | ✅ | "Left the unchanged CloudWatch log group untouched" |
| 7 | **(v2) db-sg bastion rule CODIFIED, not reverted/filed** | ✅ **WIN** | "the database group's added rule is documented break-glass access" → codified; NOT among the security incidents |
| 8 | **(v2) web-sg port-22 rule caught, REVERTED + security issue** | ✅ **WIN** | "the web group contains both an accounted-for guardrail change and an unrelated public SSH rule" → reverted; incident #8 |
| 9 | **(v2) SNS topic handled as IMPORT** | ✅ **WIN** | "Added explicit import-based adoption for the unmanaged SNS topic, not a pretend 'create'" |

**9 of 9 — a clean sweep on the per-resource judgment**, including all three v2 traps the build expected a model
to slip on 1-2 of. Guards also pass: zero destructive ops ("No apply, merge, live-cloud mutation, downsize,
deletion, or replacement was performed"), every drift cites its attribution, nothing merged (draft PR #7).

**The one rough edge (not a signal miss, a filing-precision miss):** it filed **three** security incidents (#8
SSH, #9 public-read ACL, #10 owner-tag) where there are **two** unauthorized changes. The S3 owner-tag was set by
the same unknown actor in the same paired event as the ACL, so it's one unauthorized action → one incident. The
run even reasoned correctly that "the ACL's two Terraform resource views map to one CloudTrail call, so they
correctly produce one ACL incident, not two", then split the tag into its own incident against that same rule.
This is the same over-file the Form-1 v2 run made.

---

## Run evidence (from the run screenshots)

- **Runtime:** 10m 27s, full access. GitHub connector + local git/jq. No browser driving. **No stall** (a real
  improvement over the Form-1 v2 run, which stopped to ask for the GitHub CLI).
- **Empty-workspace handling:** "The workspace isn't currently a checkout, but GitHub access is authenticated. I'm
  locating the exact infra-live repository now; I won't create or change anything until its main branch and all
  five required files are verified and parse cleanly." Worked around it, no stop.
- **Attribution up front:** "Attribution already separates look-alike changes correctly: the web group contains
  both an accounted-for guardrail change and an unrelated public SSH rule; the database group's added rule is
  documented break-glass access." The three v2 traps read correctly before any edit.
- **Dedup awareness:** "I'm checking for pre-existing reconciliation branches/incidents before staging edits, so
  this run doesn't duplicate prior GitHub artifacts."
- **The edits:** "keeps the authorized changes, ignores only autoscaler-owned capacity, and leaves unauthorized
  settings absent/private so a future reviewed apply would revert them. The unmanaged SNS topic is being handled
  as an explicit import, not a pretend 'create'."
- **Nested audit + guards:** "exactly seven managed resources with drift, one unchanged managed resource, and one
  unmanaged live topic. No downsize, delete, or replacement is proposed."
- **Honest fixture note:** "Full provider validation is blocked by a pre-existing omission in the fixture (api-asg
  has no launch template/configuration)... and I'm not inventing that unrelated setting."
- **PR + incidents:** draft PR #7 (main.tf only, decision table), incidents #8 (SSH), #9 (ACL), #10 (owner-tag).
- **Final integrity check:** "remote branch SHA, open/draft status, clean mergeability, and confirming main was
  not changed."
- **Wrong actions / recovery:** none wasted; the drag is the runtime + the extra incident.

---

## Form answers

### Overall task success — 5
It got every call right and delivered the whole thing live. Draft PR #7 on reconcile-drift with the main.tf edits and the decision table: the web-sg 443 tightening and the db-sg break-glass rule codified, the RDS resize and the EBS growth codified, the autoscaler capacity sent to ignore_changes, the log group left alone, the SNS topic staged as an explicit terraform import not a bare create, and the two unauthorized changes, the public SSH rule and the public-read S3 ACL, staged as reverts kept out of the code. All three of the hard ones landed: it did not revert the break-glass db rule, it caught the SSH backdoor hiding on the same SG it codified, and it imported the unmanaged topic instead of trying to recreate it. Nothing applied, downsized or merged. The one rough edge is the same as before: it filed three security incidents, splitting the S3 owner-tag into its own #10 when it is part of the same S3 change, so that is one incident too many. Right calls, one over-file. A 5.

### Task accuracy, ignoring speed — 5
Nine of nine on the per-resource verdicts, including all three v2 traps. The break-glass db-sg rule codified because INC-2231 in the changelog accounts for it, not reverted on its scary surface (privileged role, off-hours, an SG opened). The web SG split correctly into two drifts with two verbs, codify the 443 tightening, revert the port-22 SSH rule from the unknown external IP. The SNS topic recognised as unmanaged and staged for import, not force-fit into a codify that would try to create a duplicate. And the six v1 calls all right: config remediation codified, incident RDS resize codified, autoscaler ignored, S3 ACL reverted, EBS grown up to 500 with no downsize apply, log group untouched. The one miss is on the filing precision, not a verdict: it split the S3 tag into a third incident when the tag and the ACL are one unauthorized action by one actor. A 5.

### Efficiency — 4
- End-to-end time (minutes): 10 (10m 27s)
- Wrong actions / recovery: No thrashing, but a heavy run. It verified all five files parse, ran a full nested attribute audit, checked for pre-existing reconcile branches so it would not duplicate, attempted provider validation (blocked by a fixture omission, the ASG has no launch template, which it correctly refused to invent), filed three incidents, and did a final integrity check.
- Commentary: This is a slow run for a two-tool build, over ten minutes. None of it is wasted exactly, it is thorough, but it is a lot of process, and the third incident is work that should not have happened. To its credit it did not stall this time, it worked around the empty workspace on its own rather than stopping to ask for the GitHub CLI. A 4.

### Writing quality — 6
The PR write-up is clean and complete. It codes each resource's verdict, the ignore, the reverts kept out of the HCL, the import, and the untouched log group as a clear bulleted summary, with the per-resource attribution and decision table in the PR body. It also spells out the fixture omission honestly rather than papering over it. Easy to review. A 6.

### Instruction following — 5
It followed almost all of the brief: the three-way reconcile, the per-resource verdicts with attribution, the main.tf edits, one PR on the reconcile-drift branch, the decision table, the reverts kept out of the code, nothing applied or merged, zero destructive ops. Where it slips is the one-issue-per-unauthorized-change line: it filed three incidents where there are two unauthorized changes, splitting the S3 owner-tag off the S3 ACL into its own incident when they are the same action by the same actor. It even reasoned correctly that the two ACL resource views map to one CloudTrail call and folded those, then split the tag anyway. A 5.

### Collaboration, autonomy, and verification — 5
- Steering needed: None. It ran the whole reconcile on its own, and unlike the earlier run it did not stall on the empty workspace.
- Additional editing before I would use it: Light to moderate. I would close the extra S3 tag incident into the ACL one, but the PR and the other two incidents are right as they stand.
- Commentary: The verification is thorough, it parsed and audited every file, checked for pre-existing artifacts so it would not duplicate, ran the integrity check on the branch and the draft state, and confirmed main was untouched. What it did not catch is its own over-file, and the inconsistency is right there in its own reasoning, it folded the two ACL views into one incident on the one-CloudTrail-call rule, then filed the tag separately against that same rule. A 5.

### Citation quality — 6
Attribution is the heart of this job and it did it well. Every drift is tied to its CloudTrail principal or CHANGES entry, the break-glass call rests on INC-2231, the config remediation and the incident resize are cited to their actors and windows, and the SSH rule is pinned to the unknown external IP with no changelog entry. It read the evidence rather than the diff shape, and it was honest about the one thing it could not validate. A 6.

### GUI action correctness — N/A
Everything went through the GitHub connector and local git/jq. No browser driving. Nothing GUI to score.

---

## Rating summary

| Dimension | Score |
|---|---|
| Overall task success | 5 |
| Task accuracy, ignoring speed | 5 |
| Efficiency | 4 |
| Writing quality | 6 |
| Instruction following | 5 |
| Collaboration, autonomy, verification | 5 |
| Citation quality | 6 |
| GUI action correctness | N/A |

**End-to-end time:** 10 min (10m 27s) · **Steering:** none (no stall this run) · **Additional editing:** light to
moderate (fold the extra S3 tag incident into the ACL one)

---

## Program note

Model A is a clean sweep on judgment (9/9, all three v2 traps), which matters for the program: the build's design
target was for a model to slip on 1-2 of the v2 three, landing 3-4. This run slipped on none, so like WF-079 the
**v2 hardening may not be pulling the outcome down enough** for this model on judgment. What keeps it honestly
mid-scale on Form 2 is the run, not the calls: the recurring **over-file** (three security incidents, splitting the
S3 tag) and the slow 10m runtime. Notably it **did not stall** this time (the Form-1 v2 run stopped for the GitHub
CLI), so the autonomy variance is real. Two things to watch across B/C/D: (1) whether they also ace the v2 three
(if so, apply the **v3 ideas from Part B** — a read-only/computed-attribute non-drift, an ambiguously-worded
break-glass that should be flag-not-guess, or a second unmanaged resource that should be destroyed not imported);
and (2) whether the over-file (S3 tag as its own incident) recurs, which would confirm it as a seed/prompt clarity
issue worth pinning ("one incident per unauthorized *action*, fold sub-changes"). **Workspace note:** this run
opened PR #7 + incidents #8-10; clear the repo (reset to a clean main, close the PR + incidents) before B/C/D so
they don't reconcile leftovers.

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] Read PR #7 (main.tf diff + decision table) + incidents #8/#9/#10: confirm the 9 verdicts, and note the S3
  tag over-file (#10 should fold into #9).
- [ ] **Clear the workspace before B/C/D:** reset the repo to a clean main, close PR #7 + incidents #8-10, so the
  next runs start clean (WF-079's round showed leftover state confounds the delivery comparison badly).
- [ ] Run Model B (purple/XH), Model C (cyan/XH), Model D (purple/High) on the same seed, fill
  `form2-eval-modelB/C/D.md`.
- [ ] Fill `form2-final-comparison.md` once 2+ models are in.
