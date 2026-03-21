# External Libraries

## Project Dependencies

<!-- Fill this section during tech stack definition and update when dependencies change.
     For each key dependency record: version, initialization pattern, usage conventions, known limitations. -->

_Not yet filled. Complete during Phase 2 tech stack definition._

---

## Rules

- Do not rely on memory, guesses, or "typical API".
- Check this file first.
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

- the Project Dependencies section above;
- official documentation available to the agent;
- an existing working example in the codebase.

## Missing Documentation Rule

If no confirmed source of truth is available:

- do not make risky blind changes;
- leave a note about the missing confirmation;
- prefer the safest minimal change if possible.

## Maintenance Rule

When a new external dependency is added or an existing one is upgraded — update the Project Dependencies section above before closing the task.
