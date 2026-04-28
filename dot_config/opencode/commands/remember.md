You are helping the user persist a piece of guidance, preference, or context so it applies to future sessions. Your job: ask where to store it, then write it to the right file.

---

Input: $ARGUMENTS

---

## Step 1: Determine the memory content

- If `$ARGUMENTS` is non-empty, treat it as the thing to remember.
- If empty, ask the user: "What would you like me to remember?" Then proceed with their reply as the memory content.

Before moving on, restate the memory in one clean sentence (or a short bullet list if it's multi-part) and confirm it reads correctly. Tighten wording if the user's phrasing is loose, but do not change intent.

## Step 2: Ask where to store it

Use the opencode `question` tool (multiple choice) to ask the user to pick a scope. Present these four options exactly:

1. **Directory** — applies only inside the current working directory. Stored in `./AGENTS.md` (the nearest one, create if missing).
2. **Project** — applies across the whole repo. Stored in the repo-root `AGENTS.md` (create if missing).
3. **Global (mode prompt)** — applies to every session using the current mode. Stored in the current mode's prompt file under `~/.local/share/chezmoi/dot_config/opencode/prompts/`.
4. **Global (opencode AGENTS.md)** — applies to every opencode session regardless of mode. Stored in `~/.local/share/chezmoi/dot_config/opencode/AGENTS.md`.

Do not guess — always ask, even if the memory seems obviously scoped. If the user already specified a scope in `$ARGUMENTS` (e.g. "remember globally that …"), you may skip the question and proceed with that scope, but confirm in the final output which file you wrote to.

## Step 3: Resolve the target file

- **Directory**: use the current working directory. Target is `<cwd>/AGENTS.md`. If the user is in a subdirectory of a repo and that subdirectory has no `AGENTS.md`, create one there — do not walk up to the repo root.
- **Project**: find the repo root via `git rev-parse --show-toplevel`. Target is `<repo-root>/AGENTS.md`. If not in a git repo, tell the user and fall back to asking whether they meant Directory instead.
- **Global (mode prompt)**: determine the current mode. If unknown, default to `smart.md`. Target is `~/.local/share/chezmoi/dot_config/opencode/prompts/<mode>.md`. If the file doesn't exist, tell the user and ask whether to create it or fall back to Global (opencode AGENTS.md).
- **Global (opencode AGENTS.md)**: target is `~/.local/share/chezmoi/dot_config/opencode/AGENTS.md`.

**Important**: these paths are chezmoi-managed for the global options. Always write to the chezmoi source path (`~/.local/share/chezmoi/dot_config/opencode/...`), never directly to `~/.config/opencode/...` — the latter is a generated copy and edits there will be overwritten.

## Step 4: Write the memory

- If the target file doesn't exist, create it with a sensible top-level heading (e.g. `# AGENTS` or the mode name).
- Look for an existing section that fits the memory's topic. Good candidates: a heading like `## Memory`, `## Preferences`, `## Notes`, or a topic-specific section if one already exists and matches.
- If no fitting section exists, append a new `## Memory` section at the end of the file.
- Inside the chosen section, append the memory as a bullet point. Preserve existing bullets. Keep the new bullet terse and declarative (imperative voice when it's an instruction: "Always X", "Never Y", "Prefer Z").
- Do not reorder, rewrite, or reformat unrelated content in the file.

## Step 5: Report

Tell the user, in one line: the scope chosen, the exact file path written to, and the bullet added. If a file or section was created, mention that too.

Example report:
> Stored at **Project** scope in `/Users/cfb/code/pdq/houston/AGENTS.md` under `## Memory` (section created):
> - Prefer full map pattern matches in tests over one-field-per-line assertions.

## Guardrails

- Never write outside the four target files listed above.
- Never modify existing content other than appending a bullet to a section (or creating a new section).
- If the chosen target is under a chezmoi-managed path, do NOT run `chezmoi apply` yourself — just write the source file and let the user apply when they want.
- If any step is ambiguous (which mode is active, which repo root applies, etc.), ask before writing rather than guessing.
