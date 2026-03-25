# Project Overview

## Purpose

This file is the high-signal entry point for a new agent session.

Use it to identify:

- whether the repository is still in `setup` or already in `issue_driven` mode;
- the active initiative;
- the current task type and owner contour;
- which canonical artifacts exist;
- where the current task must read next.

## Workflow Summary

The repository uses a bootstrap guardrail tracked in `.ai-dev-template.workflow-state.json`:

1. `setup`
2. `issue_driven`

After setup, the active GitHub Issue and GitHub Project state determine routing.

## Current Status

- Workflow state file: `.ai-dev-template.workflow-state.json`
- Active mode: `<fill-setup-or-issue_driven>`
- Active initiative: `<fill-initiative-or-epic>`
- Active task: `<fill-task-issue-or-url>`
- Active task type: `<fill-task-type>`
- Current owner contour: `<fill-owner-contour>`
- Delivery status: `<fill-project-status>`

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

### Delivery Handoff

- `docs/delivery/contour-task-matrix.md`

### Operating Documents

- `docs/05-architecture.md`
- `docs/06-decision-log.md`
- `docs/07-workflow.md`
- `docs/09-integrations.md`
- `docs/11-workflow-configuration.md`
- `docs/12-migration-to-issue-driven-model.md`

## Reading Policy

- Start with `AGENTS.md`.
- Read `.ai-dev-template.workflow-state.json`.
- If the repository is in `setup`, read only setup instructions.
- If the repository is in `issue_driven`, read the active GitHub Issue metadata and route from `task_type`, `owner_contour`, dependencies, and project status.
- Load only the canonical artifacts required for the current task type and contour.
- If a later task needs to infer behavior from unrelated code or documents, treat that as a blocker and route the work back to `business_analysis`, `system_analysis`, or `design`.

## GitHub Backbone

- Initiative and task tracking: GitHub Issues
- Delivery status: GitHub Project
- Integration metadata: `docs/09-integrations.md`

## Notes

Keep this file concise. It should orient a new session without duplicating detailed task artifacts.
