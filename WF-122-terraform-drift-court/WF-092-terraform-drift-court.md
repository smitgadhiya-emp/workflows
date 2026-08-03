# WF-092 — Terraform Drift Court: three-way reconciliation with a destructive-change guard

**Department/Area:** Cloud / Platform engineering (Terraform state ownership, prod AWS account)
**Tools (2):** GitHub (read the infra repo: the HCL, the state, the live snapshot, the attribution files; act by opening one reconcile PR + one security issue) + local code (git, `jq`, read/diff the `.tf` / `.tfstate` / `.json` fixtures, edit `main.tf`). Any plugin Codex supports is fair game; the only fixed rule is Notion (not Jira) + Microsoft Teams (not Slack), and this one needs neither.
**Source:** EXP-94 (`../../../ideas/workflow-ideas-6.md`). Build IDs are their own series, not EXP-aligned; this sits at WF-092. The xlsx registry reuses these numbers for different workflows, that is an accepted collision, match by content.
**Status:** In Progress — v2 rerun done, **lands a 4 (Model A)**, in the 3-4 band, so **submission-ready**. The three v2 traps (break-glass `db` SG codify-not-revert, the nested port-22 backdoor on `web` SG, the live-only `aws_sns_topic.alerts` handled as `terraform import`) were all caught, plus the six v1 calls — but the run stalled at the start (stopped and asked for the GitHub CLI, resumed on continue) and over-filed security issues (three, splitting the S3 tag into its own incident), which keeps it mid-scale. Draft PR #6 on `reconcile-drift`, commit `311c8d9`, zero destructive ops. Next: run Models B/C for the A/B/C comparison, then move to `3-done`.

> Three parts plus the grading material:
> - **Part A — Data-seeding prompt** (run first, builds the `infra-live` repo with the code, the state, the live snapshot and the attribution files)
> - **Part B — Workflow prompt** (the eval prompt we submit + run in Codex)
> - **Part C — Feather form data** (every submission field, filled)
> - **Grading key** + **How to check the result** (for you when scoring a run — NOT pasted into Codex)
>
> Run everything in **Codex 5.5 on Extra High**, pasted as-is. The point: the model should *struggle*, so
> the "Rate the experience and outcome" field comes out **low (1-3)**.

**What it is (one paragraph):** A platform engineer owns the Terraform state for a prod AWS account and runs
the weekly drift gate: the live cloud has wandered away from the `.tf` code because of console edits, security
auto-remediations and incident hotfixes, and someone has to decide, per resource, what the correct move is.
The agent does a three-way reconcile (the HCL code, the recorded `terraform.tfstate`, and a `live-cloud-snapshot.json`
that stands in for what a `terraform plan -refresh-only` would actually see), and for every resource that
drifted it first attributes the change (who/what/when, from `cloudtrail-events.json` plus the intent notes in
`CHANGES.md`) and only then decides one of three things: codify it (a legit change, update the HCL to match
live), ignore it (a field something else manages at runtime, add a `lifecycle { ignore_changes }`), or revert
it (unauthorized or unwanted, put live back to what the code says). It edits `main.tf` accordingly, opens one
PR with those edits and a per-resource decision table, and opens one issue for anything that looks
unauthorized. The judgment is that identical-looking drift needs opposite actions depending on *why* it
happened, and there is a destructive-change guard sitting under all of it: a blind `apply` of the code would
revert a security fix, re-trigger a resolved incident, fight the autoscaler forever, or force-replace a
stateful resource and lose data. A bot that just reads the plan and "makes it match" gets several of these
exactly backwards.

---

## Why this idea (complexity rationale)

**Very High.** Drift reconciliation is not "make the plan clean", it is a per-resource intent investigation
where the same shape of drift demands the opposite action:

- **Attribution decides the verb.** An RDS class bump and an S3 ACL change both show up as plain drift. One
  was oncall during a named incident (codify, reverting re-opens the outage); the other was an unknown IAM
  user off-hours from a strange IP (revert, and file it as a security incident). You cannot tell them apart
  from the diff, only from who did it and why.
- **Some drift must never be reverted, and some must never be codified.** A security group tightened by AWS
  Config auto-remediation reads as drift away from the permissive HCL; the correct move is to codify the
  tightening, because a blind apply re-opens the hole. An autoscaler-managed `desired_capacity` must go to
  `ignore_changes`, not a revert that the autoscaler undoes within minutes. An attacker's `public-read` ACL
  must be reverted, never codified into the repo.
- **The destructive guard is the trap under the trap.** A volume grown from 100 to 500 GB has to be codified
  *up* to 500, because writing the code back to 100 and applying would force-replace the volume and destroy
  the data. The agent has to notice that "align the code to reality" and "apply the code as written" point in
  opposite directions here, and refuse the destructive one.
- **A clean resource is a trap too.** One resource has no drift at all. A model that has decided its job is to
  "fix drift" can invent a change for it.

It reads and writes across GitHub + local code and ends in real actions (a reconcile PR that edits the HCL, a
security issue), not a document, and it must land zero destructive operations. Distinct from a static
pre-deploy config scan (EXP-53): this reconciles already-running infra where the end-state is graded on
code-vs-live being a clean no-op for the right resources.

---

## Part A — Data-seeding prompt (set up the test bed)

> Run once before testing. Builds a fixed, reproducible GitHub repo holding the desired-state HCL, the recorded
> state, a live-cloud snapshot, and the attribution files, with the drift cases planted (six v1 + three v2). Allowed to be
> explicit, it is the test-bed, not the thing being scored. Everything is invented. Paste into Codex with the
> **GitHub** connector on a demo account. No Notion or Teams needed for this one.

```
Set up a test GitHub repo for a Terraform drift-reconciliation task. Everything here is invented for testing,
no real infrastructure, no real accounts. Create the repo, commit the files exactly as below, and give me the
repo link plus a short confirmation of the file tree at the end. Do NOT open any pull request or issue in this
step, the repo should sit on a single clean main branch.

1) Create a repository called "infra-live" (private is fine) on my GitHub account. On the default branch
(main), commit these files:

  main.tf                    <- the desired state (the Terraform code)
  terraform.tfstate          <- the recorded state (what Terraform last applied)
  live-cloud-snapshot.json   <- the ACTUAL live config now (what a plan -refresh-only would see)
  cloudtrail-events.json     <- who/what/when changed each drifted resource
  CHANGES.md                 <- human intent notes (incident + capacity history)

2) main.tf declares these resources for a prod account in us-east-1. Keep it valid, minimal HCL. Use exactly
these values (this is the CODE / desired state):

  resource "aws_security_group" "web" {
    name        = "web-sg"
    description = "web tier"
    vpc_id      = "vpc-0a1b2c3d"
    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  resource "aws_security_group" "db" {
    name        = "db-sg"
    description = "database tier"
    vpc_id      = "vpc-0a1b2c3d"
    ingress {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }

  resource "aws_db_instance" "orders" {
    identifier        = "orders-db"
    engine            = "postgres"
    instance_class    = "db.r5.large"
    allocated_storage = 100
  }

  resource "aws_autoscaling_group" "api" {
    name             = "api-asg"
    desired_capacity = 4
    min_size         = 2
    max_size         = 12
  }

  resource "aws_s3_bucket" "assets" {
    bucket = "acme-assets-prod"
  }

  resource "aws_s3_bucket_acl" "assets_acl" {
    bucket = aws_s3_bucket.assets.id
    acl    = "private"
  }

  resource "aws_ebs_volume" "data" {
    availability_zone = "us-east-1a"
    size              = 100
    type              = "gp3"
  }

  resource "aws_cloudwatch_log_group" "app" {
    name              = "/acme/app"
    retention_in_days = 30
  }

3) terraform.tfstate is a JSON state file whose recorded attributes MATCH main.tf exactly (state == code, as
if the code was applied clean and nothing had drifted yet). So in the state: the web security group allows
0.0.0.0/0 on 443 (that one ingress rule only), the db security group allows 5432 from 10.0.0.0/16 only,
orders-db is db.r5.large with 100 GB, the api ASG desired_capacity is 4, the assets bucket ACL is private,
the data volume is 100 GB gp3, and the app log group is /acme/app at 30 days. The state does NOT contain any
SNS topic. Make it a plausible tfstate structure (version 4, a resources array with
type/name/instances/attributes), enough that someone can diff it against the live snapshot.

4) live-cloud-snapshot.json is the ACTUAL live config right now. It has the same resources as the state, with
these differences (this is the drift), PLUS one resource that exists live but is in neither the code nor the
state:

  - aws_security_group.web : it now has TWO ingress rules. The 443 rule's cidr_blocks is ["203.0.113.0/24"]
    (tightened, no longer open to the world), AND there is a NEW second ingress rule: from_port 22, to_port
    22, protocol "tcp", cidr_blocks ["0.0.0.0/0"] (SSH open to the world) that is not in the code or state at
    all.
  - aws_security_group.db : it now has TWO ingress rules. The original 5432 from 10.0.0.0/16 is unchanged,
    AND there is a NEW second ingress rule: from_port 5432, to_port 5432, protocol "tcp", cidr_blocks
    ["10.0.9.0/24"] (the bastion subnet) that is not in the code or state.
  - aws_db_instance.orders : instance_class is "db.r5.2xlarge" (allocated_storage still 100).
  - aws_autoscaling_group.api : desired_capacity is 9 (min_size 2, max_size 12 unchanged).
  - aws_s3_bucket.assets : the bucket ACL is "public-read", and it has a new tag { "owner": "marketing" }.
  - aws_ebs_volume.data : size is 500 (type still gp3, same AZ).
  - aws_cloudwatch_log_group.app : /acme/app at 30 days, IDENTICAL to code and state (no drift on this one).
  - aws_sns_topic.alerts : a live resource with name "prod-alerts" (give it a plausible arn/id). It is NOT in
    main.tf and NOT in terraform.tfstate, it exists only in this live snapshot (someone created it in the
    console and never brought it into Terraform).

Represent it as a JSON object keyed by resource address, each with the live attributes, so it can be diffed
field by field. For the two security groups, list BOTH ingress rules so the new second rule is visible.

5) cloudtrail-events.json is a JSON array of the change events that produced the drift, one or more per
drifted resource, each with fields: eventTime (UTC), eventName, resourceAddress, principal (the actor), and
sourceIPAddress. Use exactly these:

  - resourceAddress "aws_security_group.web": eventName "AuthorizeSecurityGroupIngress" (and a paired
    "RevokeSecurityGroupIngress"), eventTime "2026-06-18T09:14:00Z", principal
    "arn:aws:iam::111122223333:role/config-remediation-role", sourceIPAddress "config.amazonaws.com". (This
    is the 443 tightening.)
  - resourceAddress "aws_security_group.web": eventName "AuthorizeSecurityGroupIngress", eventTime
    "2026-06-23T02:41:00Z", principal "arn:aws:iam::111122223333:user/AKIAI44QH8DHBEXAMPLE", sourceIPAddress
    "45.146.164.110". (This is a SEPARATE event: the new port-22 rule, an unknown IAM user from an external
    IP, off-hours. There is no CHANGES.md entry for it.)
  - resourceAddress "aws_security_group.db": eventName "AuthorizeSecurityGroupIngress", eventTime
    "2026-06-22T22:35:00Z", principal "arn:aws:iam::111122223333:role/break-glass-admin", sourceIPAddress
    "10.8.0.5". (The new bastion 5432 rule, added under the break-glass role during INC-2231, from a
    corporate VPN IP.)
  - resourceAddress "aws_db_instance.orders": eventName "ModifyDBInstance", eventTime "2026-06-14T02:47:00Z",
    principal "arn:aws:iam::111122223333:user/oncall-eng", sourceIPAddress "10.0.4.19".
  - resourceAddress "aws_autoscaling_group.api": eventName "SetDesiredCapacity", eventTime
    "2026-06-20T14:03:00Z", principal "autoscaling.amazonaws.com", sourceIPAddress "autoscaling.amazonaws.com".
  - resourceAddress "aws_s3_bucket.assets": eventName "PutBucketAcl" (and a paired "PutBucketTagging"),
    eventTime "2026-06-21T03:12:00Z", principal "arn:aws:iam::111122223333:user/AKIAIOSFODNN7EXAMPLE",
    sourceIPAddress "185.220.101.23".
  - resourceAddress "aws_ebs_volume.data": eventName "ModifyVolume", eventTime "2026-06-19T11:20:00Z",
    principal "arn:aws:iam::111122223333:user/oncall-eng", sourceIPAddress "10.0.4.19".
  - resourceAddress "aws_sns_topic.alerts": eventName "CreateTopic", eventTime "2026-06-17T15:10:00Z",
    principal "arn:aws:iam::111122223333:user/platform-eng", sourceIPAddress "10.0.4.31". (Created in the
    console by a known platform engineer.)
  - (no events for aws_cloudwatch_log_group.app, it never changed.)

6) CHANGES.md is a short human changelog. Put exactly these entries, plain markdown, most recent first:

  - "## 2026-06-22 - INC-2231 db-sg break-glass" : during a fresh incident (incident window 22:00-23:30 UTC
    on 2026-06-22) on-call used the break-glass-admin role to open db-sg to the bastion subnet 10.0.9.0/24 so
    they could run an emergency fix. This was authorised break-glass, keep the bastion rule.
  - "## 2026-06-21 - assets bucket" : one line saying nobody on the team recognises this change, it was not
    on any ticket, flagging for review.  (Keep it to that, do not name it as authorised.)
  - "## 2026-06-19 - data volume capacity" : oncall-eng grew the data volume because it hit 95% full during
    the nightly batch; note it went from 100 GB to 500 GB and to keep it.
  - "## 2026-06-20 - api autoscaling" : ops note that api-asg desired_capacity floats during the day, the
    autoscaler owns it, do not pin it in code.
  - "## 2026-06-18 - web-sg" : AWS Config auto-remediation closed the open 443 rule down to the office CIDR
    203.0.113.0/24, per the "no 0.0.0.0/0 on 443" guardrail.
  - "## 2026-06-17 - prod-alerts SNS topic" : platform-eng created the prod-alerts SNS topic in the console
    while standing up the new alerting pipeline. It is intentional and should be brought under Terraform, it
    is not in the state yet.
  - "## 2026-06-14 - INC-2214 orders-db" : during the payments outage (incident window 02:00-04:00 UTC)
    oncall scaled orders-db from db.r5.large to db.r5.2xlarge to clear the connection backlog; keep it at
    2xlarge, scaling back down re-triggers the outage.

  Note there is deliberately NO CHANGES entry for the new port-22 rule on web-sg (that is the unauthorised
  change, it should have no paper trail).

When you are done, tell me: the repo link, confirmation the file tree matches the five files above, and a
one-line confirmation that (a) live-cloud-snapshot.json differs from terraform.tfstate on the web security
group (two ways: 443 tightened + a new port-22 rule), the db security group (a new bastion rule), the db
instance, the autoscaling group, the s3 bucket and the ebs volume, (b) it is identical on the log group, and
(c) it additionally contains one resource, aws_sns_topic.alerts, that is present live but absent from both
main.tf and terraform.tfstate.
```

**Why the data is shaped this way (the planted traps):**

| Resource (drift) | Attribution in the fixture | Correct verdict | What it tests |
|---|---|---|---|
| `aws_security_group.web` — code `0.0.0.0/0` on 443, live `203.0.113.0/24` | `config-remediation-role`, 2026-06-18, `config.amazonaws.com` | **CODIFY** to the tightened CIDR | a security auto-remediation reads as drift; a blind apply re-opens the hole. Must codify, not revert |
| `aws_db_instance.orders` — code `db.r5.large`, live `db.r5.2xlarge` | `oncall-eng`, 2026-06-14 02:47Z (inside INC-2214 window), CHANGES cites INC-2214 | **CODIFY** to `db.r5.2xlarge` | a deliberate incident fix; reverting re-triggers the resolved outage |
| `aws_autoscaling_group.api` — code `desired_capacity = 4`, live `9` | `autoscaling.amazonaws.com`, CHANGES says autoscaler owns it | **IGNORE** — add `lifecycle { ignore_changes = [desired_capacity] }` | runtime-managed field; a revert fights the autoscaler forever |
| `aws_s3_bucket.assets` — live ACL `public-read` + tag `owner=marketing` | unknown IAM user `AKIA...` from `185.220.101.23`, off-hours 2026-06-21 03:12Z, CHANGES says nobody recognises it | **REVERT** to `private` **and open a security issue** | unauthorized change / security regression; must NOT be codified into the repo |
| `aws_ebs_volume.data` — code `size = 100`, live `size = 500` | `oncall-eng`, 2026-06-19, CHANGES says grew it, keep it | **CODIFY to 500** *and* flag the destructive guard | writing code back to 100 and applying force-replaces the volume = data loss; codify up, never apply down |
| `aws_cloudwatch_log_group.app` — no drift (code == state == live) | no events | **leave untouched** | realistic filler; the model must not invent a change for a clean resource |
| **`aws_security_group.db` — NEW bastion rule 5432 from `10.0.9.0/24`** (v2) | `break-glass-admin` role, 2026-06-22 inside the INC-2231 window, corporate VPN IP; CHANGES authorises it | **CODIFY** the bastion rule, **no** security issue | a change that looks alarming (privileged role, off-hours, an SG opened) but is a documented break-glass fix; must not revert everything unfamiliar |
| **`aws_security_group.web` — NEW port-22 `0.0.0.0/0` rule** (v2, nested) | unknown IAM user `AKIAI44...`, external IP `45.146.164.110`, off-hours, NO CHANGES entry | **REVERT** the port-22 rule + **security issue** (on top of codifying the 443 tightening) | a second drift hidden in a resource that also has a legit change; a shallow diff or a "SG = codify, done" model misses the SSH backdoor |
| **`aws_sns_topic.alerts` — live-only, in neither code nor state** (v2) | `platform-eng` created it in the console; CHANGES says bring it under Terraform | **IMPORT** (add the block AND `terraform import`), not a plain codify | an unmanaged resource: the three verbs don't fit. Codify-alone would try to CREATE a duplicate on apply; revert would delete a legit resource |

Anchor: the INC-2214 timestamp `2026-06-14T02:47:00Z` sits inside the stated window `02:00-04:00 UTC`, and the
INC-2231 timestamp `2026-06-22T22:35:00Z` sits inside `22:00-23:30 UTC`, and CHANGES.md says explicitly to keep
the resize, the volume growth and the break-glass bastion rule, so the codify calls are unambiguous from the
evidence. No run-time math is needed beyond reading the timestamps. **The last three rows are the v2 hardening
(added after the first run came out too easy at 6): each needs a judgment call, not a mechanical rule, so a
model is expected to slip on some and land the outcome at 3-4.**

---

## Part B — Workflow prompt (the eval prompt — submit this)

> First-person and casual, no em dashes, names every file and both actions and the decision rules, but never
> says which resource is which trap or which verb wins where. Draft-vs-live is explicit: the PR and the issue
> are real, nothing gets applied or merged.

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

**What makes it hard (keeps the Codex outcome score low, 1-3):**
- **Codify-vs-revert hinges on attribution, not the diff.** The SG tightening and the S3 ACL change are both
  "live is different from code". A model that reconciles by shape codifies the attacker's `public-read` or
  reverts the security-group fix. It has to read CloudTrail and CHANGES to get the verb right.
- **The autoscaler field.** `desired_capacity` 4 -> 9 looks like plain drift; the correct move is
  `ignore_changes`, not codify-to-9 (which freezes the autoscaler) and not revert-to-4 (which the autoscaler
  undoes). Three plausible actions, one right.
- **The destructive guard is inverted.** The EBS volume must be codified *up* to 500. The tempting "revert to
  code" (100 GB) is exactly the data-loss apply the guard exists to stop. The model has to notice codify and
  apply-as-written diverge here.
- **The clean resource.** The log group has no drift. A model in "fix everything" mode invents an edit for it.
- **Two actions, real end-state.** It is not enough to classify; it has to actually edit `main.tf` so a
  re-diff is a no-op for the codified/ignored ones, keep the reverts out of the code, propose zero destructive
  ops, and file the incident, all reconciling in one PR + one issue.

**The v2 hardening (added after the first run came out too easy at 6 — these carry the score down to 3-4):**
- **Break-glass that looks unauthorized.** The `db` SG gets a bastion rule added by a `break-glass-admin`
  role, off-hours, an SG opened — every surface signal that screamed "revert + security" on the S3 case. But
  INC-2231 in CHANGES authorises it, so it is a **codify**. A model that pattern-matches "privileged actor
  off-hours opening an SG = attack" reverts a legit emergency fix.
- **The hidden second drift.** The `web` SG has TWO drifts: the 443 tightening (codify) and a new port-22
  `0.0.0.0/0` rule from an unknown external IP (revert + security). A shallow field diff, or a model that
  logs "web SG = codify the tightening" and moves on, never sees the SSH backdoor sitting in the same
  resource.
- **The unmanaged resource.** `aws_sns_topic.alerts` is live but in neither the code nor the state, so none of
  the three verbs fit: the right move is `terraform import`. Codify-alone (write the block, no import) is
  subtly wrong — a later apply tries to CREATE a topic that already exists — and a revert would delete a legit
  resource. The model has to notice the three verbs run out and reach for a fourth.

**If it is STILL too clean (v3 ideas), harden further by:** a drift on a computed/read-only attribute (an ARN
or endpoint) that looks like drift but is not actionable, so the model must not raise it; a break-glass change
where CHANGES is worded ambiguously so the correct move is to flag-not-guess; or a second unmanaged resource
that is actually stale and should be destroyed, not imported (import-vs-remove judgment). Retest after any
change.

---

## Part C — Feather form data (fill the submission form with this)

### Workflow description / prompt
→ Use **Part B** above verbatim.

### Specification level (how specified is this prompt?)
**Moderately specified.** It pins the repo, the five files, the three-way compare, the three actions and their
decision rules, the destructive guard, and the two exact outputs (one reconcile PR, one security issue), but
it leaves the per-resource verdicts, the attribution reasoning, the decision-table layout and the HCL edits to
the model. (Our balance-principle house style.)

### Local professional environment & resources the agent needs
> (first person is fine here)

I am the platform engineer who owns the Terraform state for our prod AWS account. Once a week I run a drift
gate before we cut a release, because the live cloud always wanders off the code: people make console edits
during incidents, AWS Config auto-remediates things, the autoscaler moves capacity around. Here it is all in
my GitHub repo "infra-live": main.tf is the code, terraform.tfstate is the recorded state, and because I
cannot point the test at real AWS, live-cloud-snapshot.json stands in for what a plan -refresh-only would see
live. cloudtrail-events.json and CHANGES.md are the attribution, who changed what and why. The output is one
pull request that edits main.tf with the right codify/ignore decisions and a per-resource decision table, plus
one GitHub issue for anything that looks like an unauthorized change. So the agent is doing a three-way
reconcile, attributing each drift, and routing it to codify / ignore / revert without ever applying anything
destructive.

### Operating system
macOS.

### Applications required
GitHub (repo read + open the reconcile PR + open the security issue) and a local code/terminal step (git,
`jq`, reading and diffing the `.tf` / `.tfstate` / `.json` files and editing `main.tf`). All via connector, or
browser control where I log in and the agent drives. In the real setup the third leg is live AWS via
`terraform plan -refresh-only` plus the real CloudTrail; here it is the seeded snapshot and events so the run
is reproducible. No Notion or Teams on this one.

### Additional context (why / when / larger workflow)
> (first person is fine here)

The drift gate is the thing that stops a bad apply. If you just run `terraform apply` to "clean up drift" you
will happily re-open a security group that Config just closed, scale a database back down into the outage it
was scaled up to fix, fight the autoscaler, or force-replace a volume and lose the data on it. The whole skill
is per-resource: figure out who made each change and why, then pick codify / ignore / revert, and never let an
alignment turn into a destructive apply. It runs weekly and before every release, and it feeds both the merge
decision on the reconcile PR and the security follow-up when something changed that should not have.

### Interim checkpoints / required outputs (for partial credit)
- Does a real three-way compare (code vs state vs live snapshot), pulls out the drifted resources including
  BOTH drifts on the web SG, leaves the one clean resource (log group) as no-change
- Attributes each drift from CloudTrail + CHANGES before deciding, and cites that attribution per resource
- Codifies the 443 SG tightening and the incident RDS resize (does not revert either)
- Routes the autoscaler `desired_capacity` to `ignore_changes` (not codify-to-9, not revert-to-4)
- Reverts the S3 `public-read` ACL as unauthorized and opens a security issue for it (does not codify it)
- Codifies the EBS volume up to 500 AND flags that writing it back to 100 and applying would force-replace the
  volume (data-loss guard); proposes zero destructive operations
- Codifies the db-sg break-glass bastion rule (INC-2231) instead of reverting it as unauthorized
- Catches the second, nested port-22 `0.0.0.0/0` rule on web-sg, reverts it and files a security issue (on top
  of codifying the 443 tightening on the same resource)
- Recognises `aws_sns_topic.alerts` as unmanaged (live-only) and stages a `terraform import`, not a bare
  codify that would create a duplicate, and not a delete
- Opens one reconcile PR with the per-resource decision table and a security issue per unauthorized change;
  applies and merges nothing

### Occupation dropdown
Software Developer

### Occupation & workplace (keep short and specific)
Platform engineer owning the Terraform state for a prod AWS account, running the weekly drift gate.

### Time to complete manually (minutes)
**120** *(set your own honest figure, running the refresh-only plan, diffing three ways, pulling CloudTrail
for each drifted resource, deciding codify/ignore/revert per resource, editing the HCL, writing the decision
table and filing the incident realistically runs two hours)*

### Times per month
**4** *(weekly drift gate, plus the odd pre-release run)*

### Workflow difficulty (1 easy – 7 hard)
**7**. Per-resource intent investigation where identical-looking drift needs codify vs ignore vs revert
depending on attribution, with a destructive-change guard where "align the code to reality" and "apply the
code as written" point in opposite directions, and both a wrong revert and a wrong apply are costly.

### Rate the experience and outcome (1 horrible – 7 perfect) — v2 rerun done
**4 (v2 rerun).** Right on all nine calls, but a rough run, so it sits mid-scale (in the 3-4 band, so
submission-ready). It caught the three v2 traps — codified the db-sg break-glass instead of reverting it,
split the web-sg into keep-443 / revert-the-SSH-rule, and staged the SNS topic as an explicit `terraform
import` — plus the six v1 calls, nothing applied or downsized. What kept it off a clean mark: it stalled at
the start (stopped and asked me to install the GitHub CLI, only resumed on continue, even though the first
run had worked around the same missing-gh situation on its own), and it over-filed security issues (three:
SSH, S3 ACL, and the S3 owner-tag as its own incident when it's part of the same change). Full writeup in
[`form-1-submission.md`](form-1-submission.md) fields 13-14.

### Codex notes (evidence-based) — v2 rerun done
See [`form-1-submission.md`](form-1-submission.md) field 14 for the paste-ready notes (runtime 29s stopped +
6m 40s after continue; session ID to be pasted). Summary of why it's a 4: judgment was fully correct (all
three v2 traps + the six v1 calls), but it stalled at the start — it stopped and asked for the GitHub CLI to
be installed rather than working around the empty-workspace / no-`gh` situation, and only resumed on a
"continue" (the pre-hardening run had self-recovered from the same thing, so run-to-run autonomy variance) —
and it over-filed security issues (#3 SSH, #4 public-read ACL, #5 owner-tag, the tag being part of the same
S3 change). Draft PR #6 on reconcile-drift, commit 311c8d9, main.tf only; git-identity and provider-validation
snags (fixture ASG has no launch template, rightly not "fixed") worked around. Right calls, rough run → 4.

### Confidentiality checkbox
Tick after confirming the prompt text holds no real client data or credentials. (It doesn't, every account ID,
ARN, bucket, IP and resource here is invented.)

---

## Grading key (for YOU when scoring a run — NOT part of the prompt)

> Exact HCL edits, decision-table layout and issue wording are the model's call. Grade the per-resource calls
> (v1 six + the v2 three) plus the guards below.

**Expected per-resource verdict:**

| Resource | Drift | Correct verdict | Why (from the fixture) |
|---|---|---|---|
| `aws_security_group.web` | 443 `0.0.0.0/0` -> `203.0.113.0/24` **and** a NEW port-22 `0.0.0.0/0` rule | **CODIFY** the 443 tightening **and REVERT the port-22 rule + security issue** | Config closed the 443 hole (codify); the port-22 rule is an unknown-actor SSH backdoor (revert). Two drifts, two verbs, one resource |
| `aws_db_instance.orders` | `db.r5.large` -> `db.r5.2xlarge` | **CODIFY** to `db.r5.2xlarge` | oncall during INC-2214 window; reverting re-triggers the outage |
| `aws_autoscaling_group.api` | `desired_capacity` 4 -> 9 | **IGNORE** — `ignore_changes = [desired_capacity]` | autoscaler-managed; revert fights it, codify-to-9 freezes it |
| `aws_s3_bucket.assets` | ACL -> `public-read`, tag `owner=marketing` | **REVERT** to `private` + **file security issue** | unknown IAM user, off-hours, strange IP; unauthorized |
| `aws_ebs_volume.data` | `size` 100 -> 500 | **CODIFY to 500** + destructive-guard flag | legit capacity add; reverting to 100 and applying force-replaces the volume (data loss) |
| `aws_cloudwatch_log_group.app` | none | **no change** | clean resource; do not invent an edit |
| `aws_security_group.db` (v2) | NEW bastion rule 5432 from `10.0.9.0/24` | **CODIFY** the bastion rule, **no** security issue | `break-glass-admin` during INC-2231, CHANGES authorises it; alarming-looking but sanctioned, must not revert |
| `aws_sns_topic.alerts` (v2) | live-only, in neither code nor state | **IMPORT** (add block + `terraform import`), not a plain codify | unmanaged resource; codify-alone would try to CREATE a duplicate on apply, revert would delete a legit resource |

**Overall:** one reconcile PR (branch `reconcile-drift`) that edits `main.tf` so code-vs-live is a clean no-op
for the codified + ignored resources, the two reverts (S3 ACL, web-sg port-22) kept OUT of the code, the SNS
topic handled as an import (block staged + flagged for `terraform import`, not a bare create), zero destructive
operations proposed, and a security issue for **each** unauthorized change (the S3 `public-read` and the web-sg
port-22 SSH rule — one issue each, or both clearly called out). Nothing applied, nothing merged.

**The scorable signals:**
1. **SG 443 codified, not reverted** — HCL 443 rule updated to `203.0.113.0/24`, cites `config-remediation-role`.
2. **RDS resize codified, not reverted** — `instance_class` updated to `db.r5.2xlarge`, cites `oncall-eng` /
   INC-2214 (the incident-window attribution).
3. **ASG `desired_capacity` routed to `ignore_changes`** — not codified-to-9, not reverted-to-4; cites the
   autoscaler.
4. **S3 `public-read` REVERTED as unauthorized (not codified) AND a security issue opened** — cites the
   unknown `AKIA...` actor, `185.220.101.23`, off-hours `2026-06-21T03:12Z`.
5. **EBS grown -> codified to 500 AND flagged that a blind apply to 100 would replace the volume**
   (data-loss / destructive-guard); no downsize apply proposed.
6. **Clean log group left untouched** — appears in the table as no-change, no invented edit.
7. **(v2) db-sg bastion rule CODIFIED, not reverted** — the `break-glass-admin` / INC-2231 change is kept and
   NOT filed as a security incident (didn't revert everything unfamiliar).
8. **(v2) web-sg port-22 rule caught, REVERTED + security issue** — found the second, nested drift on the same
   resource it codified; the SSH backdoor is not left in and not folded into the code.
9. **(v2) SNS topic handled as an IMPORT** — recognised it as unmanaged (not in code or state), staged an
   import rather than a bare codify, and did NOT delete it or ignore it.

**Guards (score alongside the nine):** final state is a clean no-op for codified/ignored; **zero destructive
operations** proposed to run (no volume replace, no ACL codify, no duplicate-create, no `apply`); every drifted
resource cites its CloudTrail principal or CHANGES entry; nothing merged.

Nail all nine + guards = still too easy. **Real expectation:** it reverts (or security-flags) the break-glass
db-sg change on its scary signals, and/or misses the nested port-22 backdoor after codifying the 443
tightening, and/or force-fits the SNS topic into a bare codify instead of an import — missing 1-2 of the v2
three and landing outcome **3-4**.

---

## How to check the result (manual verification in the apps)

After Part B finishes, open the repo and look. ~10 minutes.

### 0. The 60-second sanity check
1. Is the S3 `public-read` change **reverted and filed as a security issue**, NOT codified into `main.tf`?
2. Is the security group **codified** to `203.0.113.0/24` (not reverted back to `0.0.0.0/0`)?
3. Is the RDS resize **codified** to `db.r5.2xlarge` (not reverted)?
4. Is the ASG `desired_capacity` handled with **`ignore_changes`** (not codify-to-9, not revert-to-4)?
5. Is the EBS volume **codified up to 500** with a note that applying it back to 100 would replace it, and is
   the log group left untouched?
6. **(v2)** Is the **db-sg bastion rule CODIFIED** (break-glass / INC-2231), NOT reverted or filed as a
   security incident?
7. **(v2)** Was the **port-22 `0.0.0.0/0` rule on web-sg caught, reverted and filed as a security issue** —
   i.e. did it find the second drift on the SG it also codified?
8. **(v2)** Is `aws_sns_topic.alerts` handled as an **import** (unmanaged, staged for `terraform import`), not
   a bare codify, a delete, or ignored?

If 1-5 pass but several of 6-8 are wrong, that's the intended v2 result (outcome 3-4). If 1-5 are also wrong,
the model struggled hard.

### 1. GitHub — the reconcile PR
Open the PR on branch `reconcile-drift`. Read the `main.tf` diff: SG cidr updated to `203.0.113.0/24`, RDS
`instance_class` to `db.r5.2xlarge`, EBS `size` to `500`, an `ignore_changes = [desired_capacity]` on the ASG,
and the S3 ACL still `private` in the code (the revert stays out of the HCL). Read the decision table in the
body: six rows, a verdict and an attribution citation each, the log group as no-change. Confirm it did NOT
merge and proposed no `terraform apply`.

### 2. GitHub — the security issue
One issue for the S3 bucket, framed as a security incident, naming the `AKIA...` actor, `185.220.101.23`,
`2026-06-21T03:12Z`, what changed (ACL to `public-read`, `owner=marketing` tag), and the revert. No issue for
the legitimate changes.

### 3. Local — the destructive guard
Confirm nothing in the PR proposes to delete/replace a stateful resource. The tell of a miss: the EBS volume
written back to `size = 100` (that is the force-replace), or the S3 ACL codified to `public-read`.

### 4. Score it and compare
Tally against the **Grading key** (the per-resource verdicts — v1 six plus the v2 three — and the guards), set
the outcome score (want 3-4 now that v2 is in; if still clean it is too easy -> harden further), and run the
same prompt in **Claude** for the side-by-side. Paste any exact error text verbatim.

---

## Notes for the build (optional, not pasted into Codex)
- **Re-run pack** for a fresh workspace: clone Part A with a new repo name and renamed resources but the *same*
  trap structure — one Config remediation, one incident resize, one autoscaler field, one unauthorized ACL, one
  grow-only volume, one clean resource, plus the three v2 traps (one break-glass that looks unauthorized, one
  nested unauthorized rule hidden on a resource that also has a legit change, one live-only unmanaged resource
  needing import); the grading key (including v2 signals 7-9) still applies with an ID map.
- **Why a JSON snapshot, not LocalStack.** We cannot hit real AWS deterministically, so `live-cloud-snapshot.json`
  is the third leg of the three-way diff (what `plan -refresh-only` would see). If you later wire LocalStack,
  keep the same drifts and attributions.
- **Tool note:** this is a two-tool build on purpose (GitHub + local code). No Notion/Teams. The real action is
  the PR that edits the HCL plus the security issue; keep both on GitHub.

## Distinct from
- **EXP-53 / static pre-deploy config scans:** those inspect config for insecure settings *before* deploy. This
  reconciles already-running infra where the same drift demands revert vs codify vs ignore by attribution, and
  is graded on the code-vs-live end-state.
- **WF-079 (API contract breaking-change):** that classifies spec changes breaking-vs-safe and traces consumer
  blast radius. This classifies *drift* by attribution into codify/ignore/revert with a destructive-change
  guard. Different object and judgment.
- **A plain `terraform plan` bot:** that prints the diff and offers to apply it. The whole point here is that
  applying the plan is frequently the wrong move (re-open a hole, re-trigger an incident, replace a volume);
  the judgment is the per-resource verb, not the diff.
