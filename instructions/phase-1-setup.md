# Phase 1 — Setup

You are in phase 1. Complete the following steps in order.

## 1. Read Configuration

Read `.ai-dev-template.config.json`. Record the values of all settings.

## 2. Check Environment

Verify that the following are available and working:
- git — installed and current directory is a repository
- gh — installed and authenticated (`gh auth status`)
- repository access on GitHub (push, issues, projects)

If anything is missing — report exactly what is wrong and what needs to be fixed. Do not continue until the problem is resolved.

## 3. Adapt Delivery Instructions

Read `instructions/phase-3-delivery.md`.

Edit it to match the project configuration:
- Remove sections and instructions that do not apply given the current config settings.
- Replace generic descriptions with concrete values (e.g. execution mode, pull request policy).
- Do not use template placeholders — edit the file thoughtfully, as a human would.

## 4. Project Map

If `project_map.enabled = true` in the config:

Create `docs/project-map.md` — a file tree with a brief description of each folder's purpose and each key file. Goal: any agent starting a new session should understand the project structure without scanning the filesystem.

If `project_map.enabled = false` — skip this step.

## 5. Complete Phase

Delete this file: `instructions/phase-1-setup.md`

Commit the changes (adapted `phase-3-delivery.md`, deleted `phase-1-setup.md`, and `docs/project-map.md` if created) following the commit rules from the project config.

Tell the user that setup is complete and requirements gathering will begin in the next session.
