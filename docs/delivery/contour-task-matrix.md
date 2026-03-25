# Contour Task Matrix

Use this file to decompose approved analysis into contour-specific execution tasks.

## Rules

- one row per task
- one task owns one contour
- cross-contour work is split into linked tasks
- dependencies must reference the upstream task names or issue IDs explicitly
- design, deploy, and e2e work are separate rows, not hidden inside implementation rows

## Matrix

| Task | Task type | Owner contour | Depends on | Input artifacts | Expected result |
| --- | --- | --- | --- | --- | --- |
| `<task>` | `business_analysis` | `business-analyst` | `<dependencies>` | `<business context>` | `<result>` |
| `<task>` | `system_analysis` | `system-analyst` | `<dependencies>` | `<intake artifacts>` | `<result>` |
| `<task>` | `design` | `designer` | `<dependencies>` | `<analysis artifacts>` | `<result>` |
| `<task>` | `implementation` | `<designer/frontend/backend/devops/qa-e2e>` | `<dependencies>` | `<analysis and design artifacts>` | `<result>` |
| `<task>` | `deploy` | `devops` | `<dependencies>` | `<rollout artifacts>` | `<result>` |
| `<task>` | `e2e` | `qa-e2e` | `<dependencies>` | `<scenario and acceptance artifacts>` | `<result>` |
