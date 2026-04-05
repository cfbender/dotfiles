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

**Usage**: Token-optimized shell proxy. All standard commands are rewritten automatically via the Claude Code hook.

Use `rtk ls <dir>` explicitly when you need a compact directory listing.
Never use `find . -type f` or `ls -la -R` to explore a directory — use rtk ls instead.

Example: `rtk ls src/java/org/apache/cassandra/db/`

⚠️ **Name collision**: If `rtk gain` fails, you may have reachingforthejack/rtk (Rust Type Kit) installed instead. Verify with `which rtk`.

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
