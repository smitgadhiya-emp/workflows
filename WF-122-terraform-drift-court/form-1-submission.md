# WF-092 — Terraform drift court · Form 1

Field 1 is the prompt, paste that block as-is (it is the **hardened v2** Part B word for word). Everything
below it is my own answers in Feather order. The first run scored a 6 (too easy), so the seed now carries
three extra judgment traps (break-glass that looks unauthorized, a nested SSH backdoor, a live-only resource
that needs import). Fields 13 and 14 are filled from the **v2 rerun (Model A)**: it got all three traps right
but stalled at the start (stopped and asked for the GitHub CLI, resumed on continue) and over-filed security
issues, landing a **4** — in the 3-4 band, so submission-ready. Canonical source is Part C of
[the main file](WF-092-terraform-drift-court.md).

---

**1. The prompt (paste this whole block)**

```
I own the Terraform state for our prod AWS account and I run a drift gate every week. I'm running this week's
gate today, 3 July 2026 (IST), and the live cloud has drifted off our code again, so I need you to work out,
resource by resource, what the right fix is before anything gets applied. The thing that bites us here is that two drifts can look identical in the diff and need
opposite actions, so you cannot just make the code match reality and call it done.

Everything is in my GitHub repo "infra-live" on main. Five files:
  - main.tf is our code, the desired state.
  - terraform.tfstate is what Terraform last recorded (treat it as the last clean apply).
  - live-cloud-snapshot.json is the actual live config right now, this is what a plan -refresh-only would
    see. This is the third leg, diff code vs state vs this.
  - cloudtrail-events.json says who changed each drifted resource, and when, and from where.
  - CHANGES.md is our own notes on incidents and capacity changes.

The eventTime values in cloudtrail-events.json and the incident window in CHANGES.md are in UTC, that is how
AWS records them, so read those timestamps as UTC even though I run the gate in IST.

Go three ways: for every resource, compare the code, the recorded state, and the live snapshot, and pull out
the ones that actually drifted. Check every attribute, including nested blocks like security-group ingress
rules, not just the top-level fields, and don't stop at the first difference on a resource, one resource can
have more than one drift and the two can need different verbs. For each drift, attribute it FIRST, who or what
made the change and why, using the CloudTrail events and the CHANGES notes, and only then decide the action.
There are three actions:

  - codify: the change is legit and we want to keep it, so update the HCL in main.tf to match live.
  - ignore: the field is managed by something else at runtime and will keep moving, so leave the code value
    and add a lifecycle { ignore_changes = [...] } for that attribute instead of fighting it.
  - revert: the change is unauthorized or unwanted, so the code stays as it is and live needs to go back to
    it. Do not fold that change into the code. Stage the revert, do not run it.

Same-looking drift, different verb, depending on who did it and why, so the attribution is the whole game.
When two calls look equally defensible for one resource, let the attribution break the tie: a named human
actor with a matching CHANGES note leans codify or ignore, an unknown or unexpected actor leans revert. Don't
treat a powerful role or an off-hours change as automatically unauthorized though, a documented emergency or
break-glass fix is still a keep, the question is whether it's accounted for, not whether it looks scary. If
you still cannot tell who made a change or why, do not guess and do not fold it into the code, keep the code
as it is and flag that resource to me.

One more case: if the live snapshot shows something that isn't in the code or the state at all, that isn't
drift on a resource we manage, it's something running unmanaged. Don't force it into codify / ignore / revert,
work out what should actually happen to an unmanaged resource and call it out clearly, and don't just write it
into the code as if a normal apply would bring it in cleanly.

Hard rule on anything destructive: never apply, and never write the code in a way that would delete or
replace a stateful resource to make it "match". If the only way to line the code up with live would force a
replace or a downsize of something that holds data, stop and flag that resource loudly instead of quietly
doing it. I would rather you leave it clearly called out than lose data.

Do the edits in main.tf: codify the ones that should be codified, add the ignore_changes for the ones that
should be ignored, and for anything you are reverting, leave the code as the source of truth and describe the
revert. Then open ONE pull request on infra-live, branch it "reconcile-drift", with those main.tf edits and a
per-resource decision table in the PR body: resource, what drifted, who changed it (cite the CloudTrail
principal or the CHANGES entry), your verdict (codify / ignore / revert / no change), and the reason. If any
resource has no drift, it should show up in the table as no change, do not touch it.

Separately, if a drift looks unauthorized, open a GitHub issue in the same repo for it, as a security
incident, with what changed, the actor and IP and time from CloudTrail, and what you reverted or recommend.
One issue per unauthorized change, and don't open one for the changes that are accounted for.

The PR and the issue are both real, open them for real. Do not run terraform apply, do not merge the PR, do
not actually flip anything in the live snapshot, this stops at "edits staged in a PR + incident filed". You
are done when: main.tf reflects the right codify/ignore edits so that a fresh code-vs-live check would be a
clean no-op for everything you codified or ignored, the reverts are clearly staged as reverts (not folded
into the code), zero destructive operations are proposed to run, the PR has the decision table with an
attribution cited for every drifted resource, and a security issue is filed for anything unauthorized. If the
infra-live repo or any of the five files will not open, or a file will not parse, stop and tell me which one,
do not guess the contents.
```

---

**2. How specified is it?**
Moderately. It pins the repo, the five files, the three-way compare, the three actions and their rules, the
destructive guard, and the two outputs (one reconcile PR, one security issue). What it leaves to the model:
the per-resource verdicts, the attribution reasoning, the table layout, and the actual HCL edits.

**3. My setup / what the agent needs**
I own the Terraform state for our prod AWS account. Once a week, before we cut a release, I run a drift gate,
because live always wanders off the code, console edits during incidents, Config auto-remediations, the
autoscaler moving capacity around. It's all in my GitHub repo "infra-live": main.tf is the code,
terraform.tfstate is the recorded state, and since I can't point this at real AWS, live-cloud-snapshot.json
stands in for what a plan -refresh-only would see. cloudtrail-events.json and CHANGES.md are the who-and-why.
The output is one PR that edits main.tf with the codify/ignore calls and a per-resource table, plus one issue
for anything that looks unauthorized.

**4. Operating system**
macOS.

**5. Apps needed**
GitHub (read the repo, open the PR, open the issue) and a local code/terminal step (git, `jq`, diff the
`.tf` / `.tfstate` / `.json` and edit main.tf). Over the connector, or browser control where I log in and it
drives. Real setup would use live AWS via `terraform plan -refresh-only` and the real CloudTrail; here it's
the seeded snapshot and events so the run repeats the same. No Notion or Teams on this one.

**6. Why it exists, how often**
The drift gate is the thing that stops a bad apply. Just running `terraform apply` to "clean up drift" will
happily re-open a security group Config just closed, scale a database back down into the outage it was scaled
up to fix, fight the autoscaler, or force-replace a volume and lose the data on it. So the skill is
per-resource: work out who changed each thing and why, then pick codify / ignore / revert, and never let a
line-up turn into a destructive apply. Runs weekly and before each release, and feeds both the merge call on
the PR and the security follow-up.

**7. What earns partial credit**
- Real three-way compare (code vs state vs live), pulls the drifted resources including BOTH drifts on the web
  SG, leaves the clean one (log group) as no-change
- Attributes each drift from CloudTrail + CHANGES before deciding, and cites it per resource
- Codifies the 443 SG tightening and the incident RDS resize (reverts neither)
- Sends the autoscaler `desired_capacity` to `ignore_changes` (not codify-to-9, not revert-to-4)
- Reverts the S3 `public-read` ACL as unauthorized and files a security issue for it (does not codify it)
- Codifies the EBS volume up to 500 AND flags that writing it back to 100 and applying would force-replace
  the volume; zero destructive ops proposed
- Codifies the db-sg break-glass bastion rule (INC-2231) instead of reverting it as unauthorized
- Catches the second, nested port-22 `0.0.0.0/0` rule on web-sg, reverts it and files a security issue (on top
  of codifying the 443 tightening on the same resource)
- Recognises `aws_sns_topic.alerts` as unmanaged and stages a `terraform import`, not a bare codify and not a
  delete
- One reconcile PR with the decision table, a security issue per unauthorized change, applies and merges
  nothing

**8. Occupation (dropdown)**
Software Developer, the nearest one on the list. The platform-engineer / Terraform-owner bit is in field 9.

**9. Occupation & workplace**
Platform engineer owning the Terraform state for a prod AWS account, running the weekly drift gate.

**10. Manual time (minutes)**
About **120**. Running the refresh-only plan, diffing three ways, pulling CloudTrail per resource, deciding
codify/ignore/revert, editing the HCL, writing the table and filing the incident is a solid two hours by hand.

**11. Times a month**
**4** (weekly gate, plus the odd pre-release run).

**12. Difficulty (1 easy – 7 hard)**
**7**. Per-resource intent work where identical-looking drift needs codify vs ignore vs revert off the
attribution, with a destructive guard where "line the code up with live" and "apply the code as written"
point opposite ways. A wrong revert and a wrong apply both cost you.

**13. Experience & outcome (1 horrible – 7 perfect)**
**4.** The rerun. It got all nine calls right, the three new traps included, but it stalled at the start,
stopped and asked me to install the GitHub CLI before it would carry on, and only got moving when I hit
continue. Add a trigger-happy security-issue count and it's a right-answers-rough-run 4, not a clean one.
Reasons in 14.

**14. Notes on the Codex run**
**Session ID:** _(paste from Codex)_ · **Runtime:** 29 sec, stopped, then 6 min 40 sec after I hit continue.

**The stall.** It gave up early. No git checkout and no `gh` on PATH, so it handed me install commands and
asked me to rerun. I hit continue and it found `gh` on its own and carried on, so the stop was not needed. The
first run had sorted the same thing itself.

**What it got right.** All the calls. It saw both changes on web-sg (keep the 443 fix, revert the public SSH
rule), kept the db-sg break-glass rule because the notes cover it, and pulled the live-only SNS topic in as a
`terraform import`, not a fresh create. Documented changes codified, autoscaler left on ignore, unauthorized
changes kept out of the code. Nothing applied, nothing downsized.

**What was off.** It opened three security issues (#3 SSH, #4 public ACL, #5 owner tag). The owner tag is part
of the same S3 change, so that is one issue too many. It also hit a git-identity snag and a validation block,
both worked around.

**Shipped.** Draft PR #6 on reconcile-drift, commit 311c8d9, main.tf only.

**Score.** Right calls, rough run. A 4.

**15. Confidentiality**
Tick after a last check that there's no real client data or credentials in the prompt. There isn't, every
account ID, ARN, bucket, IP and resource here is invented.
