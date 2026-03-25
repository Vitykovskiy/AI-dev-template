# Glossary

## Business Terms

- Business analysis: structured clarification work that turns a raw request into a fixed business problem statement, user scenarios, scope, and acceptance expectations.
- Epic or initiative: a large outcome that is decomposed into issue-linked operational tasks.
- First version: the narrowest release scope that still produces meaningful business value.

## Technical Terms

- Canonical source of truth: the authoritative repository artifact where project context must be persisted.
- Contour: a delivery boundary with its own owner, such as `designer`, `frontend`, `backend`, `devops`, or `qa-e2e`.
- Definition of done: the issue-level evidence required before a task may be closed.
- Definition of ready: the issue-level conditions that must be true before a task may start.
- Guardrail: a configured mechanism that constrains execution without replacing issue-based routing.
- Workflow state file: `.ai-dev-template.workflow-state.json`, the repository file that stores the bootstrap mode as `setup` or `issue_driven`.

## Working Definitions

- Ready: a task whose dependencies are resolved, canonical inputs exist, and project status allows the owner contour to start.
- Done: delivered for the current task type, persisted in canonical artifacts, reflected in GitHub state, and advanced to the correct project status.
- Initiative complete: all required child tasks are done, deployment succeeded, and e2e validation passed.
- Blocked: cannot continue because of an unresolved dependency, missing access, or missing specification that requires a new or reopened upstream task.
