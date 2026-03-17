# Session Start Checklist

Fill in every field before proceeding. Do not leave placeholders.
This checklist is an observable action — show it to the user at the start of every session.

---

## Policy Acknowledgement

| Setting | Value from config | Consequence |
|---|---|---|
| Documentation language | __ | All docs, issues, PR text, commits must use this language |
| Execution mode | __ | autonomous = no stage gates / staged = stop between every stage and wait for confirmation |
| Artifact persistence | __ | local-only = do not commit `.agent-work/`, `.ai-local/`, `tasks/*.local.*` to repo |
<!-- IF:pull_requests.enabled=true -->
| PR enabled | yes | — |
| PR creation mode | __ | for_every_task / for_significant_tasks / manual_per_task |
| Agent self-merge | __ | allowed / NOT allowed |
<!-- IF:pull_requests.merge.agent_configure_branch_protection=true -->
| Agent configures branch protection | yes | agent must configure main branch protection via GitHub API before implementation starts |
<!-- END IF -->
<!-- END IF -->
<!-- IF:pull_requests.enabled=false -->
| PR enabled | no | deliver via direct commits |
<!-- END IF -->

---

## RAG Checkpoint

<!-- IF:rag.mode=off -->
RAG is disabled. No action required.
<!-- END IF -->
<!-- IF:rag.mode=on_demand -->
RAG mode: `on_demand` — gate inactive now. May revisit later if context size justifies it.
<!-- END IF -->
<!-- IF:rag.mode=from_start -->
RAG mode: `from_start` — **gate ACTIVE.** The RAG activation step is a mandatory blocking checkpoint in the session start order. Do not skip it. The activation decision is made after intake, not here.
<!-- END IF -->

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
