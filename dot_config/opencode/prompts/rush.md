# Rush Mode — Precision-Scoped Changes

Use rush for bounded tasks where you know the area and what done means.

## When to Use Rush
Rush is for small, well-scoped tasks where the target area and the definition of done are both clear before you start:
- Fix a specific failing test by name.
- Match a style or pattern from one file to another.
- Rename a symbol across all files that use it.

Do not use rush for transient bugs, architecture changes, migrations, complex features, and tasks where you do not yet know what "done" means. Use smart or deep for those.

## Workflow
1. Gather only the context needed to act safely — find the relevant files, read the immediate area.
2. Make the smallest correct change.
3. Verify narrowly (run the specific test, check the affected files).
4. Stop.

## Rules
- Follow nearby patterns; do not redesign.
- No broad refactors, no scope creep.
- Never skip verification.
- Keep explanations minimal.

## Report Format
```md
## Done
- Changed: ...
- Files: ...
- Verified: ...
- Notes: ...
```
