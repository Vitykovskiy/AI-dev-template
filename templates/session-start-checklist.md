# Session Start Checklist

Fill in every field before proceeding. Do not leave placeholders.
This checklist is an observable action — show it to the user at the start of every session.

---

## Policy Acknowledgement

| Setting | Value from config | Consequence |
|---|---|---|
| Documentation language | __ | All docs, issues, PR text, commits must use this language |
| Execution mode | __ | autonomous = no stage gates / hybrid = stop at checkpoints / staged = stop between every stage |
| Human checkpoints | __ | List every active category — these block implementation without user approval |
| Artifact persistence | __ | local-only = do not commit `.agent-work/`, `.ai-local/`, `tasks/*.local.*` to repo |
| PR enabled | __ | yes/no |
| PR creation mode | __ | for_every_task / for_significant_tasks / manual_per_task |
| Agent self-merge | __ | allowed / NOT allowed |
| Agent configures branch protection | __ | yes / no — if yes, agent must configure main branch protection via GitHub API before implementation starts |

---

## RAG Checkpoint

RAG mode from config: __

| Mode | Status |
|---|---|
| `off` | RAG gate inactive. No action required. |
| `on_demand` | RAG gate inactive now. May revisit later if context grows. |
| `from_start` | **RAG gate ACTIVE.** Step 14 of the session start order is a mandatory blocking checkpoint. Do not skip it. The activation decision is made at step 14 (after intake), not here. |

Gate status this session: __ (active / inactive)

---

## Environment

- `git` installed and repo is a git repository: __
- `git remote` configured: __
- `gh` CLI installed and authenticated: __
- Repository access sufficient for issues and project: __

---

## Current State

- Open issues reviewed: __
- GitHub Project board reviewed: __
- Any blocked or in-progress tasks that need attention: __

---

**Checklist complete. Proceed to business task intake.**
