# EXECUTION PROMPT — Freelancer Profile Optimizer & Lead-Gap Research

> Hand this entire block to Codex as a single, one-time executable instruction. It is self-contained: it defines the mission, the architecture, every task, the automation logic, the scoring model, the outputs, and the acceptance criteria. Execute it end-to-end without asking for further clarification unless a credential or account is missing.

---

## 0. ROLE & MISSION

You are an autonomous build-and-run agent. Build a tool called **Freelancer Profile Optimizer & Lead-Gap Research** that:

1. Uses **browser automation** to log into and scan one or more freelancer profiles on **Upwork and/or Fiverr**.
2. **Extracts** every profile section: headline/title, overview/bio, skills, portfolio/gigs, reviews & ratings, pricing/rates, response time, badges, and completion stats.
3. **Benchmarks** each scanned profile against top-performing profiles in the **same niche/category** (competitor sampling).
4. **Scores** profile health (0–100) per section and overall, using a transparent rubric.
5. **Generates** section-by-section improvement suggestions.
6. **Produces two deliverables**: (a) an interactive **analysis dashboard**, and (b) a structured **research document** (gap analysis + competitor benchmark + prioritized action plan) exported to **Google Docs**.

Build it to run **repeatably for multiple user profiles** ("multi-user profile scan"). Optimize for correctness, resilience to page changes, and clear, actionable output.

---

## 1. TECH STACK (use these defaults unless a better fit exists in the repo)

- **Language/runtime:** Python 3.11+.
- **Browser automation:** Playwright (Python) — headed mode for first-run login, persistent auth context afterward. Prefer Playwright over Selenium for reliability.
- **Data model:** Pydantic models + local `SQLite` (or JSON files under `/data`) for scraped snapshots.
- **Dashboard:** A single self-contained web dashboard. Use **Streamlit** (fastest) OR a static HTML+JS report generated from a Jinja2 template — pick one and stay consistent. Charts via Plotly.
- **Google Docs export:** Google Docs API + Google Drive API via `google-api-python-client` and OAuth (the user's Google Account).
- **Config:** `.env` for secrets + `config.yaml` for niche keywords, competitor sample size, weights.
- **Package mgmt:** `requirements.txt` (or `pyproject.toml`).

Create a clean repo structure:
```
/optimizer
  /scrapers      (upwork.py, fiverr.py, base.py)
  /analysis      (scoring.py, benchmark.py, suggestions.py)
  /exporters     (google_docs.py, dashboard.py)
  /models        (profile.py, report.py)
  /data          (snapshots, cached HTML)
  config.yaml
  .env.example
  run.py          (single entrypoint / orchestrator)
  README.md
```

---

## 2. CREDENTIALS & ACCOUNTS (handle safely)

- Read credentials ONLY from `.env` / OS keychain — never hardcode. Provide `.env.example` with:
  `UPWORK_EMAIL`, `UPWORK_PASSWORD`, `FIVERR_EMAIL`, `FIVERR_PASSWORD`, `GOOGLE_OAUTH_CLIENT_JSON`, `TARGET_PROFILE_URLS`, `NICHE_KEYWORDS`.
- For login flows requiring 2FA/CAPTCHA, run **headed** and **pause for manual completion**, then persist the authenticated Playwright storage state to `/data/auth/<platform>.json` so subsequent runs reuse the session. Never bypass CAPTCHA programmatically.
- Support **multiple target profiles**: accept a list of profile URLs (own profiles and/or competitor URLs) and iterate.
- Respect platform ToS: throttle requests, add human-like delays, scrape only publicly viewable + own-account data, and store nothing beyond what the report needs.

---

## 3. WORKFLOW — EXECUTE THESE PHASES IN ORDER

### Phase A — Setup & Auth
1. Scaffold the repo structure above and install dependencies.
2. Initialize Playwright, launch browser, log into each configured platform, persist auth state.
3. Validate Google OAuth; obtain a Docs/Drive token; store refresh token.

### Phase B — Extraction (per profile)
For each target profile, navigate and extract into the `Profile` model:
- **headline/title**, **overview/bio** (full text), **skills** (list), **portfolio items / gigs** (title, thumbnail alt, description, media count), **reviews** (count, average rating, recent review text sentiment), **rates/pricing** (hourly or gig tiers), **response time / response rate**, **badges** (Top Rated, Rising Talent, Level Two, etc.), **completion/JSS or order-completion stats**, **languages**, **availability**.
- Save a raw HTML snapshot + parsed JSON snapshot to `/data` with a timestamp. Make selectors resilient (prefer role/text/aria selectors; add fallback selectors and log when a field can't be found rather than crashing).

### Phase C — Competitor Benchmark
1. From `NICHE_KEYWORDS` (or inferred from the user's skills/category), run platform search to collect the **top N** performing profiles/gigs in the same niche (default N=10; configurable). "Top-performing" = highest rating × review volume × Top-Rated/Level badges, sorted by relevance.
2. Extract the same section fields for each competitor into `Profile` models tagged `is_competitor=true`.
3. Compute niche **benchmarks**: median/percentile values for word counts, skill counts, portfolio counts, rating, price range, badge prevalence, keyword frequency in headlines/overviews.

### Phase D — Scoring (transparent rubric)
Score the user's profile per section, 0–100, then a weighted overall score. Default weights (put in `config.yaml`, editable):
| Section | Weight | What high score looks like |
|---|---|---|
| Headline | 15% | Keyword-rich, benefit-driven, matches niche top-performers |
| Overview | 20% | Clear value prop, proof/results, ≥ niche-median length, CTA, keyword coverage |
| Skills | 15% | Full relevant skill set vs. benchmark, no gaps in high-frequency niche skills |
| Portfolio/Gigs | 20% | Count ≥ benchmark, strong media, outcome-focused descriptions |
| Reviews/Rating | 15% | Rating & volume vs. benchmark percentile |
| Rates/Pricing | 10% | Positioned appropriately vs. niche price band |
| Trust signals | 5% | Badges, response rate, completion stats |
Each sub-score must record the raw metric, the benchmark value, and the gap. No black-box numbers — every score is explainable.

### Phase E — Suggestions
For each section produce concrete, rewrite-ready suggestions:
- Show **current vs. recommended** (e.g., rewritten headline options, an improved overview draft, missing skills to add, portfolio gaps to fill, pricing repositioning).
- Base every suggestion on the benchmark gap, not generic advice. Rank suggestions by **impact × ease** into a prioritized action plan (P1/P2/P3).

### Phase F — Deliverable 1: Dashboard
Generate an interactive dashboard showing:
- Overall health score gauge + per-section scores (bar/radar chart).
- User-vs-benchmark comparison charts (skills, portfolio count, rating, price band, keyword coverage).
- A table of prioritized actions with impact/effort.
- Before/after suggested copy for headline & overview.
- Follow good data-viz practice (consistent palette, light/dark friendly, readable). Save/serve locally and print the URL.

### Phase G — Deliverable 2: Research Document (Google Docs)
Create a well-formatted Google Doc titled `Profile Optimization Report — <profile name> — <date>` containing:
1. **Executive summary** (overall score, top 3 wins available).
2. **Gap analysis** (section-by-section: current, benchmark, gap, why it matters).
3. **Competitor benchmark** (table of the N competitors + niche medians).
4. **Section-by-section improvement suggestions** (with rewritten copy).
5. **Prioritized action plan** (P1/P2/P3 with expected impact on leads/callbacks).
6. **Appendix**: raw extracted data + methodology + scoring rubric.
Share/return the Doc URL. If Google auth is unavailable, fall back to exporting a formatted `.docx` + `.md` to `/data/reports/`.

### Phase H — Multi-profile loop & summary
Loop Phases B–G for every configured target profile. At the end, print a run summary: profiles scanned, scores, dashboard URL(s), Google Doc URL(s), and any fields that failed to extract.

---

## 4. RESILIENCE & QUALITY REQUIREMENTS

- **Never hard-fail on one missing field** — log it, mark it `null`, continue.
- Retry navigation/network up to 3× with backoff. Cache raw HTML so re-analysis needs no re-scrape.
- Add `--dry-run` (use cached snapshots, no browser) and `--profiles <urls>` CLI flags to `run.py`.
- Structured logging to console + `/data/run.log`.
- Include a short `README.md`: setup, `.env` config, how to run, how to add niches, ethics/ToS note.

---

## 5. ACCEPTANCE CRITERIA (the run is "done" when ALL are true)

1. `python run.py` executes the full A→H pipeline for at least one real target profile.
2. Every profile section is extracted (or explicitly logged as unavailable).
3. At least N competitor profiles are scraped and benchmark medians computed.
4. Every section has a 0–100 score with a visible raw-metric-vs-benchmark justification.
5. A working dashboard renders with score gauge + comparison charts + action table.
6. A formatted Google Doc (or fallback .docx) report is generated and its URL/path printed.
7. Re-running with `--dry-run` reproduces analysis from cache without opening a browser.
8. Secrets stay in `.env`; no credentials in code or logs.

---

## 6. EXECUTION INSTRUCTION

Build the repo, install dependencies, implement all modules, then **run the full pipeline** on the profile(s) provided in `TARGET_PROFILE_URLS`. If a required credential or account is missing, stop and report exactly which one is needed; otherwise complete autonomously and finish by printing the run summary from Phase H. Do not ask for confirmation between phases.
