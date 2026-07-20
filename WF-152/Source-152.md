# WF-152 — Source / Anchor Values

The WF-152 prompt names its resources directly (no `[brackets]`). This file maps each **named
resource in the prompt** to the **actual thing Codex creates/uses**, and records the one source that
had to change from the original prompt.

| Resource named in the prompt | Actual value to use |
|---|---|
| GitHub repo | `smitempiricinfotech-wq/Multi-Audience-Generator` (branch `main`) |
| Last release tag ("the latest release tag on `main`") | `v1.4.0` (stable). Decoy pre-release `v1.5.0-rc.1` exists to be skipped; older `v1.3.0` is already contained |
| PR range | Every PR merged into `main` after `v1.4.0`'s commit, up to the latest `main` commit at run time |
| Computed next version | `v2.0.0` (major bump — the seeded range has breaking changes) |
| `Engineering / Release Notes` (Drive folder) | Google Drive folder `Engineering / Release Notes` (three Docs are outputs) |
| `Workflow test` team | Microsoft Teams team `Workflow test` |
| `Dev Releases` channel | Teams channel `Dev Releases` (technical changelog) |
| `Product Updates` channel | Teams channel `Product Updates` (user-facing update) |
| `Leadership Updates` channel | Teams channel `Leadership Updates` (executive summary) |
| Fallback channel | Teams channel `Workflow test` (used only if a target channel is missing) |
| `CHANGELOG.md` | File at repo root, seeded with `v1.4.0` + `v1.3.0` entries only |

## Adaptation from the original prompt (why it was made)

1. **Repo renamed for relevance + isolation.** The original prompt pointed at
   `keyurempiricinfotech-art/test-repo`, a generic name already used by another workflow (WF-052) for
   an unrelated API-audit backend. To keep the source relevant to *this* flow and avoid two workflows
   fighting over one repo, WF-152 uses its own repo `smitempiricinfotech-wq/Multi-Audience-Generator`.
   The prompt is updated to this repo everywhere it appears (the range read and the `CHANGELOG.md`
   commit/PR target). See [Prompt-152-final.md](Prompt-152-final.md).

Everything else in the prompt already pointed at real, relevant resources (the Drive folder, the
Teams team, and the three audience channels), so no other source needed replacing.

## Runtime values left as-is (computed by the workflow, not pre-set)
- The next version `v2.0.0` and its bump reason — derived from the range (do not pre-create the tag).
- The three doc titles `Release v2.0.0 - Technical Changelog / - User Update / - Executive Summary`
  and their contents.
- The per-PR classification table, the reverted-not-shipped and unclassified-needs-review notes.
- The Teams posts and the "Breaking Changes, Action Required" block.
- The `release-notes/v2.0.0` branch and its changelog PR against `main`.
