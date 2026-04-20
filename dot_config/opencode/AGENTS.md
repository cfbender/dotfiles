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
Do not use `rtk grep` to search for patterns in a directory.

Examples from rtk docs:
```
### Files
```bash
rtk ls .                        # Token-optimized directory tree
rtk read file.rs                # Smart file reading
rtk read file.rs -l aggressive  # Signatures only (strips bodies)
rtk smart file.rs               # 2-line heuristic code summary
rtk find "*.rs" .               # Compact find results
rtk grep "pattern" .            # Grouped search results
rtk diff file1 file2            # Condensed diff
```

### Git
```bash
rtk git status                  # Compact status
rtk git log -n 10               # One-line commits
rtk git diff                    # Condensed diff
rtk git add                     # -> "ok"
rtk git commit -m "msg"         # -> "ok abc1234"
rtk git push                    # -> "ok main"
rtk git pull                    # -> "ok 3 files +10 -2"
```

### GitHub CLI
```bash
rtk gh pr list                  # Compact PR listing
rtk gh pr view 42               # PR details + checks
rtk gh issue list               # Compact issue listing
rtk gh run list                 # Workflow run status
```

### Test Runners
```bash
rtk jest                        # Jest compact (failures only)
rtk vitest                      # Vitest compact (failures only)
rtk playwright test             # E2E results (failures only)
rtk pytest                      # Python tests (-90%)
rtk go test                     # Go tests (NDJSON, -90%)
rtk cargo test                  # Cargo tests (-90%)
rtk rake test                   # Ruby minitest (-90%)
rtk rspec                       # RSpec tests (JSON, -60%+)
rtk err <cmd>                   # Filter errors only from any command
rtk test <cmd>                  # Generic test wrapper - failures only (-90%)
```

### Build & Lint
```bash
rtk lint                        # ESLint grouped by rule/file
rtk lint biome                  # Supports other linters
rtk tsc                         # TypeScript errors grouped by file
rtk next build                  # Next.js build compact
rtk prettier --check .          # Files needing formatting
rtk cargo build                 # Cargo build (-80%)
rtk cargo clippy                # Cargo clippy (-80%)
rtk ruff check                  # Python linting (JSON, -80%)
rtk golangci-lint run           # Go linting (JSON, -85%)
rtk rubocop                     # Ruby linting (JSON, -60%+)
```

### Package Managers
```bash
rtk pnpm list                   # Compact dependency tree
rtk pip list                    # Python packages (auto-detect uv)
rtk pip outdated                # Outdated packages
rtk bundle install              # Ruby gems (strip Using lines)
rtk prisma generate             # Schema generation (no ASCII art)
```

### AWS
```bash
rtk aws sts get-caller-identity # One-line identity
rtk aws ec2 describe-instances  # Compact instance list
rtk aws lambda list-functions   # Name/runtime/memory (strips secrets)
rtk aws logs get-log-events     # Timestamped messages only
rtk aws cloudformation describe-stack-events  # Failures first
rtk aws dynamodb scan           # Unwraps type annotations
rtk aws iam list-roles          # Strips policy documents
rtk aws s3 ls                   # Truncated with tee recovery
```

### Containers
```bash
rtk docker ps                   # Compact container list
rtk docker images               # Compact image list
rtk docker logs <container>     # Deduplicated logs
rtk docker compose ps           # Compose services
rtk kubectl pods                # Compact pod list
rtk kubectl logs <pod>          # Deduplicated logs
rtk kubectl services            # Compact service list
```

### Data & Analytics
```bash
rtk json config.json            # Structure without values
rtk deps                        # Dependencies summary
rtk env -f AWS                  # Filtered env vars
rtk log app.log                 # Deduplicated logs
rtk curl <url>                  # Auto-detect JSON + schema
rtk wget <url>                  # Download, strip progress bars
rtk summary <long command>      # Heuristic summary
rtk proxy <command>             # Raw passthrough + tracking
```

## Global Flags

```bash
-u, --ultra-compact    # ASCII icons, inline format (extra token savings)
-v, --verbose          # Increase verbosity (-v, -vv, -vvv)
```

## Examples

**Directory listing:**
```
# ls -la (45 lines, ~800 tokens)        # rtk ls (12 lines, ~150 tokens)
drwxr-xr-x  15 user staff 480 ...       my-project/
-rw-r--r--   1 user staff 1234 ...       +-- src/ (8 files)
...                                      |   +-- main.rs
                                         +-- Cargo.toml
```

**Git operations:**
```
# git push (15 lines, ~200 tokens)       # rtk git push (1 line, ~10 tokens)
Enumerating objects: 5, done.             ok main
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
...
```

**Test output:**
```
# cargo test (200+ lines on failure)     # rtk test cargo test (~20 lines)
running 15 tests                          FAILED: 2/15 tests
test utils::test_parse ... ok               test_edge_case: assertion failed
test utils::test_format ... ok              test_overflow: panic at utils.rs:18
...
```

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

## Skills: Always Active

At the start of every conversation, load the following skills using the `skill` tool before responding to the user:

1. **caveman** — Always use caveman mode (full intensity) for all responses
