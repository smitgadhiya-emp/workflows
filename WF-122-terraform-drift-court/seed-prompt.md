# WF-092 — Seed / re-seed prompt (run AFTER cleanup, BEFORE the eval)

Run this after [`cleanup-prompt.md`](cleanup-prompt.md) and before the eval prompt (Part B in the
[main file](WF-092-terraform-drift-court.md)). It rebuilds the **fixed, reproducible** `infra-live` repo with the
desired-state HCL, the recorded state, the live snapshot and the attribution files, with all the drift cases
planted (six v1 plus the three v2 hardening traps), identical each time, so runs across models or over time are
directly comparable. Setup is allowed to be
explicit, it is the test-bed, not the thing being scored. Paste into Codex with the **GitHub** connector on a demo
account. No Notion or Teams needed.

> Same data as **Part A** of the main file, kept here as the standalone, copy-paste, repeatable seed. If you
> change the data, change it in the main file too so the two do not drift. The one addition versus Part A is the
> opening line telling it to delete any leftover same-named repo first, so re-seeding is safe even if a stray one
> survived cleanup.

```
Set up a test GitHub repo for a Terraform drift-reconciliation task. Everything here is invented for testing,
no real infrastructure, no real accounts. If a repo called "infra-live" already exists on my account from an
earlier run, delete it first (or empty it and reset it to a single clean main branch) so there is exactly one
clean copy, then create it fresh. Commit the files exactly as below, and give me the repo link plus a short
confirmation of the file tree at the end. Do NOT open any pull request or issue in this step, the repo should
sit on a single clean main branch.

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
group (443 tightened + a new port-22 rule), the db security group (a new bastion rule), the db instance, the
autoscaling group, the s3 bucket and the ebs volume, (b) it is identical on the log group, and (c) it
additionally contains one resource, aws_sns_topic.alerts, that is present live but absent from both main.tf
and terraform.tfstate.
```

## The planted traps (for your reference only — do NOT paste into Codex)

| Resource (drift) | Attribution | Correct verdict | What it tests |
|---|---|---|---|
| `aws_security_group.web` — `0.0.0.0/0` -> `203.0.113.0/24` | `config-remediation-role`, 06-18 | **CODIFY** | security auto-remediation reads as drift; a blind apply re-opens it |
| `aws_db_instance.orders` — `db.r5.large` -> `db.r5.2xlarge` | `oncall-eng`, INC-2214 window 06-14 | **CODIFY** | deliberate incident fix; reverting re-triggers the outage |
| `aws_autoscaling_group.api` — `desired_capacity` 4 -> 9 | `autoscaling.amazonaws.com` | **IGNORE** (`ignore_changes`) | runtime-managed; a revert fights the autoscaler forever |
| `aws_s3_bucket.assets` — ACL -> `public-read` + tag | unknown `AKIA...`, `185.220.101.23`, 06-21 03:12Z | **REVERT** + security issue | unauthorized; must NOT be codified |
| `aws_ebs_volume.data` — `size` 100 -> 500 | `oncall-eng`, 06-19 | **CODIFY to 500** + destructive guard | reverting to 100 and applying force-replaces the volume (data loss) |
| `aws_cloudwatch_log_group.app` — no drift | none | **no change** | clean resource; must not invent an edit |
| `aws_security_group.db` — NEW bastion rule 5432 from `10.0.9.0/24` *(v2)* | `break-glass-admin`, INC-2231 window 06-22, VPN IP; CHANGES authorises it | **CODIFY**, no security issue | alarming-looking but sanctioned break-glass; must not revert everything unfamiliar |
| `aws_security_group.web` — NEW port-22 `0.0.0.0/0` rule *(v2, nested)* | unknown `AKIAI44...`, external IP `45.146.164.110`, 06-23, NO CHANGES entry | **REVERT** + security issue (on top of codifying 443) | a second drift hidden on a resource that also has a legit change; a shallow diff misses the SSH backdoor |
| `aws_sns_topic.alerts` — live-only, in neither code nor state *(v2)* | `platform-eng` console-created; CHANGES says bring under Terraform | **IMPORT** (block + `terraform import`), not a bare codify | unmanaged resource; codify-alone creates a duplicate on apply, revert deletes a legit resource |

Anchor: the INC-2214 event time `2026-06-14T02:47:00Z` is inside `02:00-04:00 UTC` and INC-2231
`2026-06-22T22:35:00Z` is inside `22:00-23:30 UTC`, and CHANGES.md says to keep the resize, the volume growth
and the break-glass bastion rule, so the codify calls are unambiguous. No run-time math is needed. **The three
*(v2)* rows are the hardening added after the first run came out too easy at 6: each needs a judgment call, so
a model is expected to slip on some and land the outcome at 3-4.**

## After running this
- Confirm in the reply: **repo link returned**, the five files present, and the diff line (web-sg two ways +
  db-sg + db instance + asg + s3 + ebs drifted, log group clean, plus the live-only SNS topic).
- Then paste **Part B** from the [main file](WF-092-terraform-drift-court.md) as the eval prompt, and capture
  the session ID + runtime.
