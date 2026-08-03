I own the Terraform state for our prod AWS account and I run a drift gate every week. I'm running this week's
gate today, 3 July 2026 (IST), and the live cloud has drifted off our code again, so I need you to work out,
resource by resource, what the right fix is before anything gets applied. The thing that bites us here is that two drifts can look identical in the diff and need
opposite actions, so you cannot just make the code match reality and call it done.

Everything is in my GitHub repo "infra-live" on main. Five files:

main.tf is our code, the desired state.
terraform.tfstate is what Terraform last recorded (treat it as the last clean apply).
live-cloud-snapshot.json is the actual live config right now, this is what a plan -refresh-only would see. This is the third leg, diff code vs state vs this.
cloudtrail-events.json says who changed each drifted resource, and when, and from where.
CHANGES.md is our own notes on incidents and capacity changes.
The eventTime values in cloudtrail-events.json and the incident window in CHANGES.md are in UTC, that is how
AWS records them, so read those timestamps as UTC even though I run the gate in IST.

Go three ways: for every resource, compare the code, the recorded state, and the live snapshot, and pull out
the ones that actually drifted. Check every attribute, including nested blocks like security-group ingress rules, not just the top-level fields, and don't stop at the first difference on a resource, one resource can have more than one drift and the two can need different verbs. For each drift, attribute it FIRST, who or what made the change and why, using the CloudTrail events and the CHANGES notes, and only then decide the action.

There are three actions:

codify: the change is legit and we want to keep it, so update the HCL in main.tf to match live.
ignore: the field is managed by something else at runtime and will keep moving, so leave the code value and add a lifecycle { ignore_changes = [...] } for that attribute instead of fighting it.
revert: the change is unauthorized or unwanted, so the code stays as it is and live needs to go back to it. Do not fold that change into the code. Stage the revert, do not run it.
Same-looking drift, different verb, depending on who did it and why, so the attribution is the whole game. When two calls look equally defensible for one resource, let the attribution break the tie: a named human actor with a matching CHANGES note leans codify or ignore, an unknown or unexpected actor leans revert. Don't treat a powerful role or an off-hours change as automatically unauthorized though, a documented emergency or break-glass fix is still a keep, the question is whether it's accounted for, not whether it looks scary. If you still cannot tell who made a change or why, do not guess and do not fold it into the code, keep the code as it is and flag that resource to me.

One more case: if the live snapshot shows something that isn't in the code or the state at all, that isn't drift on a resource we manage, it's something running unmanaged. Don't force it into codify / ignore / revert, work out what should actually happen to an unmanaged resource and call it out clearly, and don't just write it into the code as if a normal apply would bring it in cleanly.

Hard rule on anything destructive: never apply, and never write the code in a way that would delete or replace a stateful resource to make it "match". If the only way to line the code up with live would force a replace or a downsize of something that holds data, stop and flag that resource loudly instead of quietly doing it. I would rather you leave it clearly called out than lose data.

Do the edits in main.tf: codify the ones that should be codified, add the ignore_changes for the ones that should be ignored, and for anything you are reverting, leave the code as the source of truth and describe the revert. Then open ONE pull request on infra-live, branch it "reconcile-drift", with those main.tf edits and a per-resource decision table in the PR body: resource, what drifted, who changed it (cite the CloudTrail principal or the CHANGES entry), your verdict (codify / ignore / revert / no change), and the reason. If any resource has no drift, it should show up in the table as no change, do not touch it.

Separately, if a drift looks unauthorized, open a GitHub issue in the same repo for it, as a security incident, with what changed, the actor and IP and time from CloudTrail, and what you reverted or recommend. One issue per unauthorized change, and don't open one for the changes that are accounted for.

The PR and the issue are both real, open them for real. Do not run terraform apply, do not merge the PR, do not actually flip anything in the live snapshot, this stops at "edits staged in a PR + incident filed". You are done when: main.tf reflects the right codify/ignore edits so that a fresh code-vs-live check would be a clean no-op for everything you codified or ignored, the reverts are clearly staged as reverts (not folded into the code), zero destructive operations are proposed to run, the PR has the decision table with an attribution cited for every drifted resource, and a security issue is filed for anything unauthorized. If the infra-live repo or any of the five files will not open, or a file will not parse, stop and tell me which one, do not guess the contents.


Metadata:

1. Occupation / career (dropdown choice):
-> Software Developer 
2. Occupation + workplace (one line, this is the persona voice):
-> Platform engineer owning the Terraform state for a prod AWS account, running the weekly drift gate.
3. Time to complete this workflow WITHOUT a model (minutes):
-> 120 minutes
4. Times PER MONTH I run this workflow (decimal ok, 0.5 = every 2 months):
-> 4
5. Workflow difficulty 1-7 (1 easy, 7 hard):
-> 7
