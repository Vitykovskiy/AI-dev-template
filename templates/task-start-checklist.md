# Task Start Checklist

Fill in every field before writing any implementation code or making any commit.
This checklist is mandatory. Do not start implementation until it is complete.

---

## Task Identity

- Issue number and title: __
- Task area (frontend / backend / infra / docs / data): __

---

## Human Checkpoint Gate

Does this task touch any of the configured human checkpoint categories?

| Category | Triggered? |
|---|---|
| Architecture changes | yes / no |
| Infrastructure changes | yes / no |
| Schema migrations | yes / no |
| External integrations | yes / no |
| Security-sensitive changes | yes / no |

**If any row is `yes` → stop. Get explicit user approval before continuing.**

User approval received: __ (required if any checkpoint triggered)

---

## PR Classification

Is this task significant?
A task is significant if it changes application or infrastructure code, changes system behavior,
or affects architecture, API, security, migrations, or external integrations.

- Significant: yes / no
- Justification: __

**If significant and `pull_requests.enabled` is `true`:**

- PR required: yes / no
- If no — justification against repository policy: __

**If PR required:**

- Branch name: `__` (must not be `main`)
- Branch created: yes / no
- `draft_first` from config: yes / no → Draft PR opened: yes / no / not applicable
- Commit target confirmed as `__` (not `main`): yes / no

**If PR not required — explicit statement:**

> This task does not require a PR because: __

---

## Delivery Mode Statement

Before the first commit, state explicitly:

> Task `#__` delivery mode: [direct commit to `__` branch] or [PR from `__` to `__`]

---

**Checklist complete. Implementation may begin.**
