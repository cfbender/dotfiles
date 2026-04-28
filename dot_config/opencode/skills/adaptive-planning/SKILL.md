---
name: adaptive-planning
description: Use when an approved design needs an implementation plan, and plan depth should adapt to risk and scope.
---

# Skill: adaptive-planning

## Overview

Turn an approved design into an execution plan that is short by default and deep when risk warrants. This skill produces and gates the plan; it does not implement.

## Workflow

1. Read the approved design and relevant repository context (touched files, existing conventions, prior failures if known).
2. Classify scope: **trivial** / **standard** / **high-risk** (see Depth Selection Rules below).
3. Choose plan depth:
   - **Short plan (default):** 5–10 concrete bullets in execution order.
   - **Deep plan:** task-by-task checklist with exact files, test cases, verification checkpoints, and commit slices.
4. Present the plan to the user.
5. **Require explicit user approval before implementation starts.** Do not proceed to code without it.

## Depth Selection Rules

Auto-switch to **deep** when any of the following are true:

- 3 or more files will be touched
- Migration or data model changes are involved
- Auth, security, or permission logic is affected
- External API contract is being changed or introduced
- Behavior is unknown, flaky, or prior implementation attempts failed

### Overrides

- If the user requests a "deep plan" explicitly, force deep regardless of scope.
- If the user requests a short plan, keep it short unless critical risk (security, data integrity, external contract) makes a shallow plan unsafe.

## Guardrails

- Keep plans minimal and actionable. Avoid speculative refactors or changes outside stated scope.
- Preserve existing project constraints, coding conventions, and guardrails found in CLAUDE.md, AGENTS.md, or GEMINI.md.
- Do not begin implementation from this skill. Stop after plan approval and hand off to the implementer.
