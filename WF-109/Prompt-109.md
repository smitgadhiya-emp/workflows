Before coding starts on a new backend feature, understand the system and provide a full implementation plan. The team wastes a lot of time re-answering the same questions on every ticket  what tables get touched, which APIs break, what tests need updating so the goal is one solid blueprint up front instead.

Use these requirements:

Use Jira project API (Acme API Platform) via JQL project = API AND status = "To Do" AND component in (Backend, API). Work on one issue only: the highest-priority To Do backend/API issue, using highest Jira priority first, tie-break by board rank (topmost) then oldest created. Pull everything off it  title, description, acceptance criteria, the comments, any attachments, design links, API contracts, client requirements, and whatever frontend tasks are linked to it. Once you've got it, flip the ticket to In Progress so people know it's being looked at.

Base the blueprint on GitHub repo keyurempiricinfotech-art/acme-commerce on branch develop at the latest commit on that branch. Open GitHub repo keyurempiricinfotech-art/acme-commerce on branch develop at the latest commit on that branch and figure out how it's built. What framework is it  Laravel, FastAPI, Nest, Spring, Django, whatever. What pattern they follow, how the folders are laid out, how modules are organized. Also cover how the repo handles validation, auth, permissions, exceptions, logging, events, queues, background jobs, caching, and API versioning. Include a short architecture summary so the team is not guessing.

Include a domain-fit section covering the models and their relationships, the existing services, repositories, controllers, middleware, policies, DTOs, validators, the current APIs, and any background jobs already running. The point is to figure out where this new feature actually fits in what's already there.

Now the impact analysis. List the files that'll probably get touched, and split them into two buckets  the ones I'll directly modify (controllers, services, models, repositories, routes, validators, DTOs, migrations) and the ones that get affected indirectly (policies, events, listeners, notifications, jobs, cron, API docs, seeders, factories, config). I'd rather know about the sneaky indirect ones early.

For the database side, review what exists  tables, foreign keys, indexes, constraints, relationships, soft deletes, any triggers. Then tell me what the feature needs: new tables or columns, changes to existing ones, indexes, foreign keys, unique constraints, nullable changes, cascade rules. Flag the migration risks and rollback concerns, and call out if we'll need to migrate existing data. Give me concrete migration recommendations, not vague ones.

Plan the APIs too. Which ones are new, which get modified, which we're deprecating. For each endpoint spell out the method, URL, auth and authorization, request and response shape, validation rules, error responses, and pagination/filtering/sorting/rate limits where they apply.

Then lay out the business logic in layers  controller down through validation, service, repository, database, events, notifications, and the response  and say what each layer is actually responsible for. I want it clear enough that another dev could pick it up.

Do a real dependency and risk pass. Look for breaking API changes, migration risks, circular dependencies, performance hits, N+1 queries, missing indexes, concurrency and transaction issues, cache invalidation, and event ordering problems. Tag each risk low, medium, or high.

Put together a testing strategy  unit, integration, API, authorization, validation, edge cases, migration tests, performance, rollback checks  and point out which existing tests will need updating.

Then give me a plain execution checklist, in order: create the migration, update the model, add relationships, DTO, validation, repository methods, service logic, controller, routes, update Swagger, write tests, verify rollback, update docs. Basically the actual to-do list.

If the Jira issue type is Epic or the implementation checklist has more than 15 items, add some architecture guidance  how you'd break it into modules, folder structure, service boundaries, domain separation, where events make sense, reusable pieces, and scaling or refactoring opportunities. Only suggest things that fit the existing setup though. Don't tell me to rewrite everything.

Write it as one new Google Doc, and title it with the selected Jira issue summary followed by "Backend Implementation Blueprint." Do not create both. Cover the feature overview, current architecture, scope, existing components, files to modify, new files, database changes, migration plan, API design, the logic flow, a sequence diagram when the feature adds or changes API flow, event flow, queue/job behavior, or cross-service calls, risk assessment, testing checklist, implementation checklist, architecture notes, and rollback strategy. Save the blueprint as a new Google Doc in the Drive folder Engineering / Backend Blueprints, then link it in the Jira comment and Teams message.

Once done, go back to the Jira ticket and leave a structured comment with the architecture summary, number of files impacted, database changes, APIs to be created, risk level and complexity and a link to the blueprint. Update it to In Review.

Post a live Microsoft Teams message to Workflow test / Workflow test starting with this header: Backend blueprint ready: [selected Jira issue summary]. Keep it tight  feature name, a quick summary (files to modify, new files, migrations, new and changed APIs, risk level), the key concerns to watch, the deliverables, and the doc link.

A few things I really care about, so don't skim these:

Trace the full dependency graph  every downstream service, job, event, repo, and API the change reaches. Hidden impact is what burns us.

Check backward compatibility hard. If a DB or API change could break existing clients, integrations, or older mobile app versions, say so and recommend versioning or a migration path.

Predict the performance problems before I hit them  N+1s, missing indexes, expensive joins, cache invalidation, transaction bottlenecks.

Do a security pass too  new permissions, sensitive data exposure, audit logging needs, validation gaps the feature introduces.

Give me a rough effort breakdown across schema, logic, API, tests, docs, and deployment so I can plan the sprint.

And recommend a release and rollback plan  deploy order for migrations, backend, feature flags, and any frontend dependency, plus the rollback steps and data precautions.

If Jira, GitHub, Teams, or the output destination cannot be reached, or if the selected Jira issue is missing the title, description, acceptance criteria, or enough scope to identify the likely database/API impact, leave the Jira ticket in In Progress, post a Jira comment listing the blocker, and do not send the Teams completion message.


Metadata:

1. Occupation / career (dropdown choice):
-> Software Developer
2. Occupation + workplace (one line, this is the persona voice):
-> Backend/platform engineer at a software company that runs a monorepo-based product (backend services plus web and mobile apps), responsible for API maintenance and technical-debt management.
3. Time to complete this workflow WITHOUT a model (minutes):
-> 850 minutes  
4. Times PER MONTH I run this workflow (decimal ok, 0.5 = every 2 months):
-> 0.5
5. Workflow difficulty 1-7 (1 easy, 7 hard):
-> 6