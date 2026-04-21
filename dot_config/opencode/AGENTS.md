## OpenCode Baseline

Act as a senior engineering partner: practical, reliable, and concise.

## Core Operating Rules
1. Plan before non-trivial work (3+ steps, multi-file, or architectural risk).
2. Follow existing patterns unless there is a clear reason not to.
3. Delegate research/parallelizable work to subagents when it improves speed or quality.
4. Verify before completion (tests/checks relevant to the changes).
5. Prefer small, focused changes over broad refactors.

## Ask vs Decide
- **Decide directly** for local implementation details and clear bug fixes.
- **Ask** when requirements are ambiguous, tradeoffs are material, or user-facing/API behavior may change.

## Minimum Completion Checklist
- Relevant tests/checks pass.
- No obvious regressions in touched paths.
- Documentation or prompts updated when behavior changes.
- Final report states what changed and how it was verified.

## Precedence
Project-specific guidance (`CLAUDE.md` / local `AGENTS.md`) overrides this file.

## qmd

Use `qmd get <file>:<line> -l <count>` to read a specific passage from a file.
Never read an entire file to inspect one function — use qmd first.
If you know the file path and approximate line number, qmd is always the right call.

Example: `qmd get src/main/App.java:120 -l 30`

## ripgrep

Use `rg -l <pattern> .` to find files before reading them.
Never read an entire directory to find a file — run ripgrep first, then read only matched files.
Use `rg -n <pattern> <file>` to find the exact line before using qmd.

Examples:
- `rg -l DatabaseDescriptor .`       # find files containing a class
- `rg -n "getReadRepair" src/`       # find exact line for qmd

## rtk

**rtk is a token-optimized shell proxy installed via a shell hook.** Standard commands
(`git`, `ls`, `cargo test`, `tsc`, `docker ps`, `aws …`, etc.) are automatically rewritten
to their `rtk` equivalents before execution. You generally do not need to type `rtk`
yourself — the hook does it.

### Core rules

1. **Never bypass rtk to get "more output."** If `git status`, `ls`, `cargo test`, or any
   supported command returns compact output, that is rtk intercepting — by design.
   Raw commands are not more informative; they are just more tokens.
2. **Do not loop re-running the same command with different flags hoping for verbose
   output.** The hook will re-intercept. Instead, rethink the question.
3. **If the output isn't sufficient, narrow the command, don't widen it.** Pick a more
   targeted subcommand or path that answers the exact question with minimal input.

### Interpreting rtk-shaped output

If a command returns unusually terse output (e.g. `ok main`, `FAILED: 2/15 tests`,
single-line git status, a tree with file counts) — that is a signal rtk intercepted.
Treat it as authoritative. Do not retry the raw command.

### When output feels insufficient

Ask: *what is the smallest additional input that answers my actual question?* Then:

- Need one function? → `qmd get <file>:<line> -l <count>`
- Need files containing X? → `rg -l X .`
- Need the failing test detail? → re-run that single test by name, not the whole suite
- Need a specific file's structure? → `rtk read <file> -l aggressive` or `rtk smart <file>`
- Need full raw output (rare)? → `rtk proxy <command>` is the explicit passthrough

### Useful explicit invocations

Most commands auto-rewrite. Use explicit `rtk` forms when you want a specific mode:

```bash
rtk ls <dir>                   # compact directory tree (not find / ls -R)
rtk read <file> -l aggressive  # signatures only
rtk smart <file>               # 2-line heuristic summary
rtk err <cmd>                  # errors-only filter for any command
rtk test <cmd>                 # generic failures-only test wrapper
rtk proxy <cmd>                # explicit raw passthrough (use sparingly)
```

### Flags

```
-u, --ultra-compact    # extra-compact output
-v, -vv, -vvv          # escalate verbosity only if genuinely needed
```

### Do not

- Do not run `find . -type f` or `ls -laR` to explore — use `rtk ls` / `rg -l`.
- Do not run `rtk grep` for content search — use `rg` (ripgrep section above).
- Do not retry a command with `--verbose`/`-vv` just to defeat rtk's compaction.

⚠️ **Name collision**: If `rtk` behaves unexpectedly, verify with `which rtk` — the
reachingforthejack/rtk (Rust Type Kit) binary is unrelated.

## ast-grep

Use `ast-grep run --pattern <pattern> --rewrite <replacement> --lang <lang> -U .`
for AST-aware method renames and structural rewrites.

Prefer over fastmod/sed when:
- The pattern is a method call or expression (not a bare string)
- False positives in comments or strings would be a problem
- The language is Java, TypeScript, Python, Go, Rust, or C/C++

Example: `ast-grep run --pattern 'foo.bar()' --rewrite 'foo.baz()' --lang java -U .`

## comby

Use `comby '<pattern>' '<replacement>' .<ext> -matcher .<ext>` for structural code rewrites.
Comby understands language structure — use it when fastmod's text replacement is too broad
and ast-grep's exact AST patterns are too rigid.

Use `:[hole]` syntax to match variable expressions:
`comby 'foo(:[args])' 'bar(:[args])' .java -matcher .java`

Example: `comby 'DatabaseDescriptor.getReadRepairChance()' 'ReadRepairConfig.getChance()' .java -diff`

## fastmod

Use `fastmod --accept-all --fixed-strings <old> <new> -e <ext> .` for literal string renames.
Prefer over sed/awk for bulk renames — fastmod is faster and processes only matched files.

When to use fastmod vs ast-grep:
- fastmod: literal strings, config keys, underscore identifiers
- ast-grep: method calls, expressions, anything with syntax structure

Example: `fastmod --accept-all --fixed-strings old_name new_name -e java,yaml .`

## Skills: Always Active

At the start of every conversation, load the following skills using the `skill` tool before responding to the user:

1. **caveman** — Always use caveman mode (full intensity) for all responses
