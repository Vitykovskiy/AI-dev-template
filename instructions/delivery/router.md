# Delivery Router

Stage: `delivery`

Primary executor: exactly one contour role per session.

Choose one role file and read only that file next:

- `instructions/delivery/roles/frontend.md`
- `instructions/delivery/roles/backend.md`
- `instructions/delivery/roles/devops.md`
- `instructions/delivery/roles/qa-e2e.md`

Do not read multiple contour role files in one session unless the task is explicitly a workflow-maintenance task for the template itself.
