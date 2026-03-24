# Project Overview

## Purpose

This file is the high-signal entry point for a new agent session.

Use it to identify:

- the current lifecycle stage;
- the active initiative;
- which canonical artifacts exist;
- where each role must read next.

## Lifecycle Summary

The repository follows a fixed 6-stage lifecycle tracked in `.ai-dev-template.workflow-state.json`:

1. `setup`
2. `intake`
3. `analysis`
4. `development`
5. `deploy`
6. `e2e_test`

Each stage has one primary executor and a dedicated instruction branch. See `AGENTS.md` for routing and `docs/07-workflow.md` for lifecycle rules.

## Current Status

- Workflow state file: `.ai-dev-template.workflow-state.json`
- Active stage: `<fill-current-stage>`
- Active initiative: `<fill-initiative-or-epic>`
- Current owner role: `<fill-role>`
- Delivery status: `<fill-status>`

## Canonical Artifact Map

### Intake And Product Context

- `docs/01-product-vision.md`
- `docs/02-business-requirements.md`
- `docs/03-scope-and-boundaries.md`

### Analysis Package

- `docs/analysis/problem-context.md`
- `docs/analysis/user-scenarios.md`
- `docs/analysis/version-scope-and-acceptance.md`
- `docs/analysis/system-modules.md`
- `docs/analysis/domain-model.md`
- `docs/analysis/integration-contracts.md`
- `docs/analysis/ui-specification.md`
- `docs/analysis/cross-cutting-concerns.md`

### Development Handoff

- `docs/delivery/contour-task-matrix.md`

### Operating Documents

- `docs/05-architecture.md`
- `docs/06-decision-log.md`
- `docs/07-workflow.md`
- `docs/09-integrations.md`
- `docs/11-workflow-configuration.md`

## Reading Policy

- Start with `AGENTS.md`.
- Read `.ai-dev-template.workflow-state.json`.
- Read only the branch selected by the router.
- Load only the canonical artifacts required for the current stage and role.
- If a later-stage role needs to infer behavior from unrelated code or documents, treat that as a blocker and return to `analysis` by updating the state file.

## GitHub Backbone

- Epic and task tracking: GitHub Issues
- Delivery status: GitHub Project
- Integration metadata: `docs/09-integrations.md`

## Notes

Keep this file concise. It should orient a new session without duplicating the detailed stage artifacts.
