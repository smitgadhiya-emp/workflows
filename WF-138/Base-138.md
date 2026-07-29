"reads slow query log from PostgreSQL, identifies top 20 slowest queries, traces each query back to its origin: which Node.js repository method, which Python ORM call, which Supabase Edge Function generated it. Posts slow query report with exact source code location across all consuming services - skips the ""which service is killing the database"" investigation entirely.
---
Business Problem

Modern applications often consist of multiple services:

Node.js Backend API
Python Worker Services
Supabase Edge Functions
Background Jobs
Scheduled Cron Jobs
Admin Panel APIs
GraphQL Server
Microservices

All of them access the same PostgreSQL database.

When PostgreSQL reports:

SELECT ...
Execution Time: 6.8 sec

developers usually don't know:

Which API generated it?
Which repository/service executed it?
Which frontend screen triggered it?
Is it a recent regression?
Is it affecting production users?
Which team owns the code?

Finding this often takes hours of investigation across logs and repositories.

This workflow automates the entire root-cause tracing process.

Workflow Trigger

Runs:

Daily
Weekly
Manually after performance incidents
Automatically when PostgreSQL slow-query threshold is exceeded
Platforms
PostgreSQL
GitHub
Jira
Google Sheets
Microsoft Teams
Datadog / New Relic / Grafana (optional)
OpenTelemetry / Jaeger (if available)
Input Sources
PostgreSQL

Collect:

Slow Query Log
pg_stat_statements
Execution Time
Frequency
Rows Returned
Rows Scanned
Planning Time
Buffers
Locks
Query Hash
Database Name
GitHub Repository

Read

Repository Structure
Repository Pattern
Services
Controllers
Models
ORM Queries
SQL Files
Migration Files
Edge Functions
Application Logs

Read

Request IDs
Trace IDs
Correlation IDs
User IDs
API Routes
Service Names
Monitoring Tool

Read

Endpoint Latency
API Frequency
Error Rate
Peak Hours
Step 1 — Collect Slow Queries

Retrieve Top 20 (or configurable) slowest queries.

Collect:

Query Text
Execution Count
Average Duration
Maximum Duration
Minimum Duration
Last Execution Time
Database
User
Query Hash
Step 2 — Normalize SQL

Normalize queries by removing:

Literal values
Dynamic IDs
Timestamps
UUIDs

Convert

WHERE user_id=9812

into

WHERE user_id=?

to group identical query patterns.

Step 3 — Group Similar Queries

Instead of reporting:

SELECT ...

SELECT ...

SELECT ...

group into

User Lookup Query

Executed 18,400 times

Average 2.4 sec
Step 4 — Trace Query Origin

Search every backend repository.

Identify exactly where the SQL originates.

Examples:

Node.js

Find

UserRepository.js

findUserByEmail()
TypeORM
userRepository.find()
Prisma
prisma.user.findMany()
Sequelize
User.findAll()
Knex
knex('orders')
Raw SQL
db.query(...)
Python

Search

SQLAlchemy

Django ORM

psycopg

asyncpg
Supabase

Search

Edge Functions

RPC calls

SQL procedures

Step 5 — Identify Calling API

Trace upward.

Example

Repository

↓

Service

↓

Controller

↓

API Route

Generate

POST /orders/create

↓

OrderService

↓

InventoryRepository

↓

Slow Query
Step 6 — Identify Frontend Consumers

Search frontend projects.

Determine

Checkout Page

↓

calls

↓

POST /orders/create

Now developers know which screen users experience slowness on.

Step 7 — Detect Root Cause

Analyze why the query is slow.

Examples

Missing Index
Sequential Scan

12M rows
N+1 Query
1 query

↓

2,500 child queries
Full Table Scan
No WHERE index
Expensive JOIN
Multiple nested joins
Inefficient ORM
Loading entire objects
Missing Pagination
Returning 150,000 rows
Duplicate Query

Same query executed hundreds of times in one request.

Lock Wait

Blocked by another transaction.

Deadlock Risk

Competing updates detected.

Connection Pool Saturation

Waiting for available DB connections.

Step 8 — Estimate Business Impact

Using monitoring data determine:

API affected
Requests/hour
Users impacted
Revenue impact (if checkout/payment)
Average latency increase
Mobile impact
Peak traffic impact
Step 9 — Prioritize Issues

Priority rules:

Critical

Checkout
Payments
Authentication
High-frequency APIs

5 sec execution

High

Customer-facing APIs
Frequently executed queries

Medium

Internal dashboards
Background workers

Low

Admin utilities
Rare maintenance jobs
Step 10 — Generate Optimization Suggestions

Provide actionable recommendations, such as:

Database
Add missing indexes
Remove unused indexes
Rewrite JOINs
Partition large tables
Archive historical data
Optimize query plan
Update statistics (ANALYZE/VACUUM)
Application
Add pagination
Limit selected columns
Cache frequently requested data
Batch queries
Eliminate N+1 patterns
Optimize ORM eager/lazy loading
Reuse prepared statements
Infrastructure
Increase connection pool size
Tune PostgreSQL parameters
Add read replicas
Move analytics queries to replica
Introduce Redis caching
Step 11 — Create Jira Tickets

Create one ticket per optimization opportunity.

Example

Title

Optimize slow query in OrderRepository.createOrder()

Description includes:

Query Hash
SQL Summary
API Route
Repository
File Path
Line Number
Root Cause
Performance Metrics
Business Impact
Suggested Fix
Priority
Related Monitoring Links

Assign to the appropriate backend team based on code ownership.

Step 12 — Update Performance Tracker

Maintain a Google Sheet named Database Query Performance Tracker.

Columns:

Query ID
Query Hash
SQL Summary
Repository
Service
API Endpoint
Frontend Screen
Source File
Line Number
Average Execution Time
Max Execution Time
Calls/Day
Users Impacted
Root Cause
Recommended Fix
Priority
Jira Ticket
Status
Owner
Last Reviewed
Step 13 — Send Microsoft Teams Summary

Post a grouped report to the engineering channel.

Example:

Database Performance Report

Slow Queries Detected: 20
Critical: 4
High: 7
Medium: 6
Low: 3

Top Impacted APIs

POST /orders/create
GET /products/search
POST /checkout/payment

Top Root Causes

Missing Indexes (5)
N+1 Queries (4)
Full Table Scans (3)
Expensive JOINs (3)
Missing Pagination (2)
Lock Contention (3)

Actions Taken

Jira tickets created
Performance tracker updated
Code owners notified
Deliverables
Database query origin analysis report
Repository-to-query dependency map
API-to-query traceability report
Root cause analysis with optimization guidance
Google Sheets performance tracker updates
Jira optimization tasks
Microsoft Teams engineering summary
Complexity Added

Compared to a basic ""slow query report,"" this workflow adds several advanced capabilities:

Cross-stack code tracing from SQL → ORM → repository → service → controller → API → frontend screen.
Multi-language support (Node.js, Python, Supabase Edge Functions, raw SQL).
Business impact analysis using API traffic and user impact rather than execution time alone.
Automatic root-cause classification (missing indexes, N+1 queries, lock contention, etc.).
Ownership detection by mapping queries to repositories and responsible teams.
End-to-end automation with Jira ticket creation, Google Sheets tracking, and Microsoft Teams notifications, eliminating manual investigation after performance incidents."