# Internal Libraries

## Purpose

This file defines how the agent works with internal shared libraries, shared packages, and reusable modules.

## Rules

- Do not assume internal library API from naming alone.
- Prefer repository docs for the shared library first.
- Then inspect real usage in the codebase.
- Treat existing working consumers as stronger evidence than guesswork.
- If the API contract is still unclear, mark uncertainty and avoid risky changes.

## Required Verification

Before changing code that depends on a shared library, verify:

- exported types;
- public signatures;
- required initialization or provider pattern;
- supported props, options, or config shape;
- version or package boundary constraints.

## Source Of Truth

Use one of the following:

- local docs for the shared library;
- the library source code and its exported types;
- an existing working example in the codebase.

## Missing Confirmation Rule

If the internal contract is not confirmed:

- do not invent API;
- do not use unconfirmed exports;
- leave a note about the missing source of truth;
- prefer the safest minimal change if possible.
