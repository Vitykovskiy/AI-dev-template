# External Libraries

## Purpose

This file defines how the agent works with external libraries, frameworks, and SDKs.

## Rules

- Do not rely on memory, guesses, or "typical API".
- Check local repository docs first.
- Check real usage examples in the codebase next.
- Check official documentation after that.
- If confirmation is missing, mark uncertainty explicitly.
- Do not invent API.
- Do not use unconfirmed methods, parameters, or options.
- Do not apply version-sensitive patterns without checking the current version.

## Required Verification

Before changing code, verify:

- signatures;
- types;
- method names;
- supported options;
- lifecycle or initialization rules;
- version limitations.

## Allowed Sources Of Truth

Use one of the following:

- local docs in this repository;
- official documentation available to the agent;
- an existing working example in the codebase.

## Missing Documentation Rule

If no confirmed source of truth is available:

- do not make risky blind changes;
- leave a note about the missing confirmation;
- prefer the safest minimal change if possible.
