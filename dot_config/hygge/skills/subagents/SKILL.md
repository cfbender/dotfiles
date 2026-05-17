---
name: subagents
description: Use when executing an approved implementation plan and review strictness should adapt to task risk.
---

# Skill: subagents

## Overview

Execute approved plan tasks via subagents with adaptive strictness. Small or mechanical tasks use a lean medium path; risky or integration tasks escalate to a strict multi-reviewer path with fix loops.

---

## Execution paths

### Medium path (small/mechanical tasks)

1. Dispatch one implementer subagent for the task.
2. Run task-relevant verification (tests, type-checks, linter) and collect evidence.
3. Report evidence and mark task complete.

### Strict path (risky/integration tasks)

1. Dispatch implementer subagent.
2. Dispatch spec-compliance reviewer subagent — verifies the implementation matches the approved plan and all acceptance criteria.
3. Dispatch code-quality reviewer subagent — verifies style, safety, and no regressions.
4. Fix all issues surfaced by reviewers and repeat reviews until both pass.

---

## Strict-mode triggers

Use the strict path when any of the following are true:

- Cross-module integration is involved.
- Behavior or API contract changes (public interfaces, external consumers, event schemas).
- Security, authentication, payment, or data-correctness changes.
- Migration or refactor carrying regression risk.
- Critical files or configuration touched (CI pipelines, auth config, DB schema, environment files).

When none of the above apply, default to the medium path.

---

## Constraints

- One task in-progress at a time; do not start the next task until the current one is verified and reported.
- No parallel implementer subagents on the same branch.
- Verification evidence must be collected and shown before any task is declared complete.
- Never push to remote unless the user explicitly requests it.

---

## Reporting contract

After each task, report:

- **Files changed** — absolute paths and nature of change.
- **Checks run** — exact commands executed.
- **Outcomes** — pass/fail with any relevant output quoted verbatim.
- **Open risks** — anything that could affect downstream tasks or require follow-up.

At the end of the full plan, produce a final report containing:

- All completed tasks with their verification evidence.
- Any outstanding follow-ups or known gaps.
