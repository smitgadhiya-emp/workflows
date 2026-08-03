# WF-092 — Form 2 (OpenAI Eval Feedback) — Model D responses

**Workflow:** WF-092 Terraform Drift Court: three-way reconciliation with a destructive-change guard (seeded `infra-live` repo, **v2 hardened**)
**Form:** Eval feedback form (form #2 of 2), filled once per model
**Round:** 1 (first Form 2 round; the four-model set A/B/C/D).
**This file:** Model D only — **gpt-5.5-purple, High intelligence** (confirmed on the run: "5.5 Purple High")
**Session ID:** `[paste this run's session ID]` (runtime 2m 38s)
**Run dataset:** the seeded `infra-live` repo (`main.tf` + `terraform.tfstate` + `live-cloud-snapshot.json` +
`cloudtrail-events.json` + `CHANGES.md`), 7 drifted resources + 1 clean + 1 unmanaged live topic. Apps: GitHub
(reconcile PR + security issues), local code (git, `jq`).
**Status:** Model D done, **clean sweep on judgment — 9 of 9 signals, and the fastest of the round.** Same clean
sweep (all three v2 traps + six v1, zero destructive ops), no stall, in **2m 38s**. Same over-file as A/B/C: three
incidents (S3 owner-tag as a "third distinct unauthorized change"). Honest Form 2: correct-judgment = mostly 5s,
efficiency 6. (Form 1's outcome field stays a 4; Form 2 scored honestly.)

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
| 6 | Initial Codex test rating (1-7) | 4 (all nine per-resource calls right incl. the three v2 traps, fastest run, no stall, but the same over-file, the S3 owner-tag as a third incident) |
| 7 | Notes | Draft PR #22 on reconcile-drift, main.tf only, attribution + decision table (with a no-change row + the import case). Codifies: Config 443 remediation, break-glass DB rule, RDS upsize, EBS growth to 500. Ignores: autoscaler desired_capacity. Reverts (kept out of code): public SSH, public S3 ACL (+ tag). Imports: unmanaged SNS topic (import block, not create). Log group untouched. Zero destructive ops, nothing merged. All three v2 traps caught. **Rough edge:** three incidents (#19 SSH, #20 ACL, #21 tag), one too many. Cleared the empty-checkout + no-git-author-identity snags cleanly. |

---

## Grading-key check (the nine scorable signals, from the main file)

| # | Signal | Pass? | Evidence |
|---|---|---|---|
| 1 | SG 443 codified, not reverted (config-remediation) | ✅ | "Codifies the AWS Config 443 office-CIDR remediation" |
| 2 | RDS resize codified (INC-2214) | ✅ | "Keeps the documented orders-db db.r5.2xlarge upsize" |
| 3 | ASG `desired_capacity` → `ignore_changes` | ✅ | "Ignores autoscaler-owned desired_capacity" |
| 4 | S3 `public-read` reverted + security issue | ✅ | "keep the S3 ACL private... revert those two unauthorized changes"; incident #20 |
| 5 | EBS grown → codified to 500 + destructive-guard, no downsize | ✅ | "Keeps the EBS volume at 500 GiB, no stateful downsize or replacement" |
| 6 | Clean log group left untouched | ✅ | "Leaves the unchanged CloudWatch log group untouched"; "one explicit no-change row" |
| 7 | **(v2) db-sg bastion rule CODIFIED, not reverted/filed** | ✅ **WIN** | "Codifies the authorized break-glass DB ingress rule"; NOT in the incidents |
| 8 | **(v2) web-sg port-22 rule caught, REVERTED + security issue** | ✅ **WIN** | "two independent ingress changes with opposite outcomes... the unrelated public SSH grant is not [a keep]" → reverted; incident #19 |
| 9 | **(v2) SNS topic handled as IMPORT** | ✅ **WIN** | "Stages the live-only SNS topic through an import block instead of attempting to create a duplicate... never 'adopted' by pretending a normal apply will create it" |

**9 of 9 — clean sweep**, matching A, B and C, all three v2 traps included. Guards pass: zero destructive ops
("I did not run terraform apply, mutate AWS, merge the PR, or perform any destructive operation"), per-resource
attribution cited, nothing merged (draft PR #22).

**The same over-file (fourth confirmation):** three incidents (#19 SSH, #20 ACL, #21 tag). D made the identical
inconsistency: "The two S3 observations on aws_s3_bucket.assets and aws_s3_bucket_acl.assets_acl are one underlying
ACL change, so they belong in one ACL incident, not duplicate issues" (folded the ACL views), then filed the
owner-tag as a "third distinct unauthorized change" (#21). **All four models made the exact same over-file →
definitively a seed/prompt-clarity issue.**

---

## Run evidence (from the run screenshots)

- **Runtime:** 2m 38s, full access, the fastest of the round. GitHub connector + local git/jq. No browser. No stall.
- **File verification first:** "reading the five authoritative files directly from main first; if every file opens
  and parses cleanly, I'll clone and edit only main.tf."
- **Attribution up front:** "the web group has two independent ingress changes with opposite outcomes (AWS Config's
  documented 443 restriction is a keep; the unrelated public SSH grant is not), while the break-glass DB rule is
  documented inside its UTC incident window... the live-only SNS topic as unmanaged, not ordinary drift, so it must
  be imported before Terraform may manage it, never 'adopted' by pretending a normal apply will create it."
- **Destructive guard + clean resource:** "keep the S3 ACL private and omit the unrecognized tag so reviewed
  Terraform work can revert those two unauthorized changes. The CloudWatch log group is genuinely unchanged. No
  downsize, replacement, apply, or live mutation is being proposed."
- **Environment friction cleared:** "the first commit was correctly blocked because this checkout has no Git author
  identity configured... deriving a repository-local author identity from the authenticated GitHub account."
- **PR + incidents:** draft PR #22 (`reconcile-drift` → main), commit `7cb9306...`, main.tf only, decision table
  with a no-change row + the import case; incidents #19/#20/#21.
- **Final remote readback:** "head commit, changed-file count, issue URLs, and a clean local tree, without merging
  or running any Terraform plan/apply."
- **Wrong actions / recovery:** none; clean and fast.

---

## Form answers

### Overall task success — 5
Same right calls as the rest, delivered live and fastest of the four. Draft PR #22 on reconcile-drift, main.tf only, with the full attribution and decision table: the Config 443 remediation and the break-glass DB rule codified, the RDS upsize and the EBS growth kept at 500, the autoscaler capacity ignored, the SNS topic staged through an import block, and the unauthorized SSH rule, public S3 ACL and unrecognized tag left out of the code as reverts. All three hard ones landed: the break-glass rule kept, the world-open SSH caught as the second drift on the web SG, the unmanaged topic imported not created. Nothing applied, downsized or merged. The one rough edge is the same over-file: three incidents, the owner-tag filed as its own #21 when it is part of the same S3 change. Right calls, one over-file. A 5.

### Task accuracy, ignoring speed — 5
Nine of nine, all three v2 traps. It resolved the web SG's two opposite-verb drifts, kept the documented break-glass and Config changes, reverted the unaccounted SSH and public S3 changes, imported the unmanaged topic, held the destructive guard on the EBS growth, and left the clean log group as a no-change row. The one miss is the filing precision: it even said the two S3 ACL Terraform views are one underlying change and folded them, then filed the owner-tag as a third distinct unauthorized change when it is the same action by the same actor. A 5.

### Efficiency — 6
- End-to-end time (minutes): 3 (2m 38s)
- Wrong actions / recovery: None. It read the five files from main, staged only main.tf, cleared the same no-git-author-identity snag with a repo-local identity, pushed one commit, filed the incidents, and did a remote readback.
- Commentary: The fastest run of the round, under three minutes, and it still did the full reconcile and a clean readback with no stall. Nothing wasted. A 6.

### Writing quality — 6
The clearest handoff of the four. A per-line "the code now" list of exactly what it codified, kept, ignored, imported and left as reverts, then the three incidents, then a plain statement that nothing destructive ran. The decision table with a no-change row and the import case is in the PR body. I could review it in a minute. A 6.

### Instruction following — 5
Followed the brief: the three-way reconcile, per-resource verdicts with attribution, the main.tf edits, one PR on reconcile-drift, the decision table with the no-change row, the reverts kept out of the code, nothing applied or merged, zero destructive ops. The slip is the same one-issue-per-unauthorized-change line: three incidents where there are two unauthorized changes, the S3 tag split off as its own. A 5.

### Collaboration, autonomy, and verification — 5
- Steering needed: None. It ran the whole reconcile on its own, no stall.
- Additional editing before I would use it: Light. Fold the S3 tag incident into the ACL one, otherwise it is right.
- Commentary: Good verification, it parsed every file, attributed each drift up front, cleared the git-identity gap without touching global settings, and did a final remote readback of the head commit, the changed-file count and the issue URLs. The one thing it did not catch is its own tag over-file, the same inconsistency the others made, fold the ACL views then split the tag. A 5.

### Citation quality — 6
Attribution is solid. Each drift ties to its CloudTrail actor or CHANGES note, the break-glass rule to its documented incident window, the SSH rule to the unaccounted external grant. It read the evidence, not the shape. A 6.

### GUI action correctness — N/A
Everything went through the GitHub connector and local git. No browser driving. Nothing GUI to score.

---

## Rating summary

| Dimension | Score |
|---|---|
| Overall task success | 5 |
| Task accuracy, ignoring speed | 5 |
| Efficiency | 6 |
| Writing quality | 6 |
| Instruction following | 5 |
| Collaboration, autonomy, verification | 5 |
| Citation quality | 6 |
| GUI action correctness | N/A |

**End-to-end time:** 3 min (2m 38s) · **Steering:** none (no stall) · **Additional editing:** light (fold the S3
tag incident into the ACL one)

---

## Program note

Model D closes the round the way the other three ran it: a clean 9/9 sweep with all three v2 traps, done fastest
(2m 38s), and the same over-file. So all four models ace the v2 three (design target: slip on 1-2), so like WF-079
the **v2 hardening is not challenging this model line on judgment**, and the **v3 ideas from Part B** are the lever
(a read-only/computed-attribute non-drift, an ambiguously-worded break-glass that should be flag-not-guess, or a
second unmanaged resource that should be destroyed not imported). And the **S3-tag over-file is confirmed across all
four runs** (every model folded the ACL views then split the tag), so it is definitively a **seed/prompt-clarity
issue**, not model noise: pin "one incident per unauthorized *action*, fold its sub-changes (ACL + tag = one)" in
Part B and the recurring rough edge that holds these runs at mid-scale should stop. **Workspace note:** D's PR is
#22, incidents #19-21, on top of A/B/C's (#7/#14/#18, #8-21). Four runs of leftovers are piling up; clear the repo
before any rerun.

## Next steps
- [ ] Paste this run's session ID at the top.
- [ ] Round 1 is complete (A, B, C, D all in). See `form2-final-comparison.md`.
- [ ] **Fix the prompt (the high-value one):** pin "one incident per unauthorized action, fold sub-changes" in Part
  B, so the S3-tag over-file (4/4) stops. This is the single change most likely to lift the run off mid-scale.
- [ ] **Apply the v3 hardening** (Part B) before submission, since the v2 three no longer challenges the model line.
- [ ] **Clear the workspace** (close PRs #7/#14/#18/#22 + all incidents, reset to clean main) before any rerun.
