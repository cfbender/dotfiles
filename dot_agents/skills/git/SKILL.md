---
name: git
description: Safe git operations. Avoids editor-opening commands that hang the agent, blocks destructive actions without confirmation, and enforces safe push semantics. Use when running any git command — commit, tag, merge, rebase, push, reset, or branch manipulation.
---

# Skill: git

## Core rule: never invoke a command that opens an editor

The agent has no interactive TTY. Any git command that drops into `$EDITOR` (vim, nano, etc.) will hang until timeout. Always supply the message inline.

| Hangs (don't do)            | Use instead                                       |
| --------------------------- | ------------------------------------------------- |
| `git commit`                | `git commit -m "msg"`                             |
| `git commit --amend`        | `git commit --amend -m "msg"` or `--no-edit`      |
| `git tag -a v1.0`           | `git tag -a v1.0 -m "msg"`                        |
| `git tag -s v1.0`           | `git tag -s v1.0 -m "msg"`                        |
| `git merge <branch>`        | `git merge <branch> -m "msg"` or `--no-edit`      |
| `git rebase -i`             | Never. Interactive rebase is unsupported.         |
| `git revert <sha>`          | `git revert <sha> --no-edit` or `-m "msg"`        |
| `git pull` (with merge)     | `git pull --no-edit` or `--ff-only`               |

If a message would otherwise span multiple lines, pass it via repeated `-m` flags or a heredoc through `-F -`:

```sh
git commit -F - <<'EOF'
Subject line

Body paragraph explaining the change.
EOF
```

## Destructive operations: confirm first

Never run these without explicit user confirmation in the current turn:

- `git push --force` — use `--force-with-lease` instead, and still confirm
- `git push --force-with-lease` — confirm, even though it's safer
- `git reset --hard` — confirm, especially with uncommitted changes
- `git clean -fd` / `-fdx` — confirm
- `git branch -D <branch>` — confirm if branch is unmerged
- `git tag -d` / `git push --delete` — confirm
- `git checkout <path>` / `git restore` over uncommitted changes — confirm
- `git filter-branch`, `git filter-repo`, `git reflog expire` — confirm
- Anything with `--no-verify` (skipping hooks) — confirm

Never force-push to `main` or `master`. Warn the user even if they ask.

## Push semantics

- Default to `git push` for the current branch.
- For force pushes, always use `--force-with-lease` (refuses to overwrite remote work you haven't seen). Never plain `--force`.
- Never push unless the user explicitly asks. Committing locally and pushing are separate decisions.

## Commit hygiene

- Don't commit unless the user asked.
- Never commit files that look like secrets (`.env`, `credentials.json`, key files). Warn if the user requests it.
- Don't run `git config` to mutate user identity or signing settings.
- Don't bypass hooks (`--no-verify`, `--no-gpg-sign`) unless the user explicitly requests it.
- Use conventional commits when creating commit messages

## Amend rules

Only `git commit --amend` when ALL are true:

1. The user asked for an amend, OR a hook auto-modified files in the commit you just created.
2. HEAD was created by the agent in this conversation (`git log -1 --format='%an %ae'` to verify).
3. The commit has not been pushed (`git status` should not say "Your branch is ahead").

If a commit failed or was rejected by a hook, do not amend — fix and create a new commit.

## Quick reference

```sh
# Annotated tag with message inline
git tag -a v1.2.3 -m "Release 1.2.3"

# Signed tag, no editor
git tag -s v1.2.3 -m "Release 1.2.3"

# Commit with multi-line message via stdin
git commit -F - <<'EOF'
Short subject

Longer body.
EOF

# Safe force push
git push --force-with-lease origin <branch>

# Merge without opening editor
git merge feature/x --no-edit
```
