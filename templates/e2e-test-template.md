# E2E Test Template

## Summary

- Task type: `e2e`
- Owner contour: `qa-e2e`
- Initiative: `<epic or parent issue>`
- Parent block task: `<block issue>`
- GitHub Project status: `<Inbox/Ready/In Progress/Blocked/Waiting for Testing/Testing/Waiting for Fix/In Review/Done>`

## Validation Scope

- Environment: `<environment>`
- Scenarios: `<scenario ids>`
- Acceptance source: `<artifact>`

## Dependencies

- `<block_delivery task>`
- `<deploy task if rollout is required>`

## Definition Of Ready

- parent block task is `Waiting for Testing` or `Testing`
- deployment is complete when the validation requires a deployed environment
- scenarios and acceptance criteria are current

## Test Cases

| Case | Scenario | Expected result |
| --- | --- | --- |
| `<case>` | `<scenario>` | `<result>` |

## Definition Of Done

- all critical scenarios pass
- acceptance criteria are satisfied
- blocking defects are recorded and routed correctly
