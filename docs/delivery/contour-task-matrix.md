# Contour Task Matrix

Use this file to decompose approved analysis into contour-specific execution tasks.

## Rules

- one row per task
- one task owns one contour
- cross-contour work is split into linked tasks
- deploy and e2e tasks are separate rows after delivery work

## Matrix

| Task | Stage | Contour | Depends on | Input artifacts | Expected result |
| --- | --- | --- | --- | --- | --- |
| `<task>` | `delivery` | `<frontend/backend/devops/etc.>` | `<dependencies>` | `<analysis artifacts>` | `<result>` |
| `<task>` | `deploy` | `devops` | `<dependencies>` | `<rollout artifacts>` | `<result>` |
| `<task>` | `e2e-test` | `qa-e2e` | `<dependencies>` | `<scenario and acceptance artifacts>` | `<result>` |
