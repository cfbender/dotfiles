# Quorum — Multi-Model Planning Discipline Plugin

**Date:** 2026-04-27
**Status:** Approved design
**Target repo:** `~/code/github/quorum` (standalone, to be initialized)
**Consumer:** this chezmoi repo at `/Users/cfb/.local/share/chezmoi`

## 1. Purpose and behavior

Quorum is an opencode plugin that enforces multi-model planning discipline. It
replaces the current `superpowers` plugin in this user's opencode setup.

The flow:

1. On the first user message of a root session, the plugin prepends a small
   bootstrap block telling the orchestrator (the agent model the user is
   talking to) that the `quorum` skill and `quorum_consult` tool are available.
2. When the orchestrator identifies the task as planning or creative work, it
   loads the `quorum` skill and calls `quorum_consult` with a well-formed
   prompt.
3. The plugin fans that prompt out to `N` configured models in parallel via
   opencode's provider stack and returns the labeled responses plus a
   synthesis prompt template.
4. The orchestrator synthesizes the responses into a structured design
   (agreement, key differences, partial coverage, unique insights, blind
   spots, open questions, proposed design), surfaces any material open
   questions to the user via the opencode `question` tool, and presents the
   design for section-by-section approval.
5. On approval, the orchestrator writes the design to a spec file, commits it,
   runs a spec self-review, gates on explicit user approval of the spec, and
   only then transitions to implementation.

Key architectural decision: the orchestrator is itself the fuser. The plugin
does fan-out and template construction only. Synthesis, dialog, and approval
gating live in the orchestrator's own context. Rationale: preserves context
continuity, allows follow-up questions, and matches the existing opencode
subagent pattern where the calling agent owns reasoning over returned data.

## 2. Configuration

Standalone config at `~/.config/opencode/quorum.json`, managed through
chezmoi at `dot_config/opencode/quorum.json`.

```jsonc
{
  "$schema": "https://raw.githubusercontent.com/GITHUB_OWNER/quorum/main/schema.json",
  "models": [
    { "providerID": "openrouter", "modelID": "anthropic/claude-opus-4.7", "label": "opus" },
    { "providerID": "openrouter", "modelID": "openai/gpt-5.4",            "label": "gpt5" },
    { "providerID": "openrouter", "modelID": "google/gemini-3-pro",       "label": "gemini" }
  ],
  "concurrency": 3,
  "timeoutMs": 120000,
  "maxTokens": 4000,
  "reasoningEffort": "high",
  "triggerMode": "auto",
  "specDir": "docs/quorum/specs"
}
```

Field semantics:

- `models`: array of `{providerID, modelID, label}`. Length defines the
  quorum size. `providerID` and `modelID` match the split used by opencode's
  `session.prompt` body shape (e.g., `providerID: "openrouter"`,
  `modelID: "anthropic/claude-opus-4.7"`). The label is a short identifier
  used in synthesis output ("opus said X, gpt5 said Y").
- `concurrency`: maximum number of in-flight model requests. Defaults to the
  size of the `models` array (fire all at once).
- `timeoutMs`: per-model request ceiling. Stragglers are dropped from the
  quorum; the synthesis output notes which were dropped.
- `maxTokens`: per-response cap. Responses that hit the cap are marked
  `truncated: true` in the tool return.
- `reasoningEffort`: passed through when the provider supports reasoning
  controls. Default `"high"` — quorum members should think hard, since
  synthesis quality depends on response quality.
- `triggerMode`: `"auto"` (bootstrap injected, skill self-triggers on planning
  work) | `"manual"` (no bootstrap; user must explicitly invoke) | `"off"`
  (plugin loads but tool is not registered and nothing is injected).
- `specDir`: path, relative to the current working directory, where approved
  designs are written.

Provider routing: the plugin uses opencode's internal HTTP client
(`client.session.create` + `client.session.prompt` + `client.session.delete`)
to dispatch model calls through throwaway child sessions. It does not speak
to providers directly. This gives it auth, retry, and multi-provider
support (openrouter, anthropic, github-copilot, ollama, etc.) for free —
any provider configured in `opencode.json` works.

Failure handling:

- A model that fails to resolve or errors out drops from the quorum; the
  synthesis notes its absence.
- If fewer than two models respond successfully, the tool returns an
  abort-signal shape and the skill instructs the orchestrator to fall back to
  single-model design, with a warning to the user.

## 3. Plugin architecture and the `consult` tool

### 3.1 Repository layout

```
quorum/
  package.json
  .opencode/
    plugins/
      quorum.js          # compiled plugin entry point
  skills/
    quorum/
      SKILL.md           # the planning-discipline skill
  src/
    plugin.ts            # plugin entry, hook registration
    consult-tool.ts      # tool definition + fan-out logic
    bootstrap.ts         # first-message injection
    synthesis-prompt.ts  # template renderer for tool return
  schema.json            # JSON schema for quorum.json
  README.md
```

`package.json` exposes the plugin via:

```json
{
  "main": ".opencode/plugins/quorum.js",
  "opencode": { "plugin": ".opencode/plugins/quorum.js" }
}
```

### 3.2 Hooks

The plugin returns a single `Hooks` object combining two surfaces:

1. **`experimental.chat.system.transform`** — pushes the quorum bootstrap
   block onto `output.system` (the system-prompt array). This mirrors how
   the `superpowers` plugin injects its bootstrap and is known to survive
   agent transitions (opencode issue #226). The bootstrap is added on every
   invocation; opencode handles deduplication at the system-prompt level.
2. **`tool.quorum_consult`** — a custom tool registered via the `tool()`
   helper from `@opencode-ai/plugin/tool`. The tool is part of the returned
   hooks object under the `tool` key; opencode's `tool/registry.ts` picks
   it up automatically.

### 3.3 `quorum_consult` tool surface

Defined via `tool()` from `@opencode-ai/plugin/tool`. Args use zod schemas
(`tool.schema`). Returns a JSON-stringified payload (tool return type is
`Promise<string>`).

```ts
import { tool } from "@opencode-ai/plugin/tool"

tool({
  description:
    "Fan out a planning prompt to the configured quorum of models and " +
    "return their responses for synthesis. Use when starting any creative " +
    "or planning work before writing code.",
  args: {
    topic:   tool.schema.string().describe("short label; used for spec filename slug"),
    prompt:  tool.schema.string().describe("the full prompt sent to each quorum member"),
    context: tool.schema.string().optional().describe("optional extra context appended to each member's prompt"),
  },
  async execute(args, ctx) {
    // implementation (§3.4)
    return JSON.stringify(payload)
  },
})
```

The JSON payload returned has the shape:

```ts
{
  responses: Array<{
    label: string,
    providerID: string,
    modelID: string,
    ok: boolean,
    text?: string,
    error?: string,
    elapsedMs: number,
    truncated: boolean,
  }>,
  synthesisPrompt: string, // template wrapping the responses (see §6)
  meta: {
    topic: string,
    startedAt: string,         // ISO timestamp
    droppedModels: string[],   // labels that errored or timed out
  }
}
```

### 3.4 Fan-out semantics

Per configured model, the tool executes a three-step sequence against the
opencode client:

1. `client.session.create({ body: { parentID: ctx.sessionID }, throwOnError: true })`
   — creates a throwaway child session linked to the calling session.
2. `client.session.prompt({ path: { id: childID }, body: { model: { providerID, modelID }, tools: {}, system: "...", parts: [{ type: "text", text: memberPrompt }] }, throwOnError: true })`
   — blocks until the model responds. `tools: {}` disables all tool use so
   the model produces a pure completion. `system` is the per-member system
   prompt (see §6.1).
3. `client.session.delete({ path: { id: childID } })` — cleans up to avoid
   accumulating throwaway sessions in storage.

The text response is extracted by filtering `response.data.parts` for
`type === "text"` and concatenating their `.text` fields.

Orchestration:

- `Promise.all` over the models array, each call wrapped in a
  `Promise.race` against a `setTimeout(config.timeoutMs)` rejection.
- Concurrency limit enforced via a `p-limit`-style limiter when
  `config.concurrency < config.models.length`.
- Each dispatch is logged via `client.app.log` at `service: "quorum"` so it
  appears in opencode's log stream for debugging.
- A timed-out or errored call is recorded in `droppedModels` with the
  label, and its response entry gets `ok: false` with the error string.

### 3.5 Explicit non-responsibilities

The tool does **not**:

- Synthesize model responses. The orchestrator does that.
- Write the spec file. The orchestrator does that, after the user approves the
  synthesis.
- Gate implementation. The gate is enforced by the skill text, not by the
  tool surface.

## 4. The skill (`skills/quorum/SKILL.md`)

### 4.1 Frontmatter

```yaml
---
name: quorum
description: Use before any creative or planning work — new features, components, behavior changes, architectural decisions, or any task where "how should this work?" is not yet answered. Consults multiple models, synthesizes their perspectives, produces a design the user approves before implementation begins.
---
```

### 4.2 Body structure

1. **Hard gate.** Mirrors the pattern used by `brainstorming`:

   > Do NOT write code, scaffold projects, run implementation commands, or
   > invoke implementation skills until you have (a) consulted the quorum,
   > (b) presented a synthesized design, and (c) received explicit user
   > approval. This applies to every planning task regardless of perceived
   > simplicity.

2. **When to invoke.** Planning tasks: new features, components, behavior
   changes, architectural decisions, anything where "how should this work"
   is not yet answered. Not for: pure bug fixes with obvious cause, typo
   fixes, dependency bumps, running existing commands, answering factual
   questions.

3. **Workflow checklist** (each item becomes an orchestrator todo):

   1. Explore project context — files, recent commits, existing patterns.
   2. Ask clarifying questions one at a time until purpose, constraints, and
      success criteria are clear.
   3. Call `quorum_consult` with a well-formed prompt that includes the
      problem, the constraints discovered in step 2, the success criteria,
      and the question "propose an approach."
   4. Read every response in full before synthesizing.
   5. Produce synthesis in the seven-section structure (§4.3).
   5a. **Surface open questions first.** Before presenting the
       proposed-design section, identify questions the quorum raised or left
       unresolved that would materially change the design. Ask them one at a
       time — use the opencode `question` tool when the choice set is
       discrete (A/B/C/D, yes/no, multiple-choice); use plain prose only
       when the question is genuinely open-ended.
   6. Present synthesis section by section, get approval after each.
   7. Write the approved design to `{specDir}/YYYY-MM-DD-{topic}.md`.
   8. Commit the spec.
   9. Run the spec self-review (§7).
   10. Ask the user to review the written spec.
   11. Only after spec approval: begin implementation.

### 4.3 Synthesis structure

The orchestrator produces a synthesis with these sections:

- **Agreement** — points where 2+ members converged. High confidence. Name
  which members agreed.
- **Key differences** — places where members proposed genuinely different
  approaches. Name the member and summarize their position. Do not flatten
  the disagreement.
- **Partial coverage** — aspects only some members addressed. Flag as "worth
  considering" rather than consensus.
- **Unique insights** — a single member saying something the others missed.
  Evaluate on merit; do not discard for being minority.
- **Blind spots** — what no member addressed but the synthesizer notices is
  missing. This is the orchestrator's value-add.
- **Open questions** — decisions the user needs to make, tradeoffs the
  synthesizer cannot resolve alone, assumptions that need confirmation. Each
  annotated with which member(s) raised it or left it implicit.
- **Proposed design** — fused recommendation informed by the above. Not a
  vote count. Not a paraphrase of one member. A synthesis.

### 4.4 Failure modes

- Fewer than 2 models respond → abort quorum, tell user, offer to fall back
  to single-model design.
- All models agree trivially → surface that as a signal; do not pad with fake
  disagreement.
- Models disagree sharply on fundamentals → flag explicitly, present options
  to the user via the `question` tool, let them choose.
- Tool call errors entirely → tell user, offer to proceed single-model or
  retry.

### 4.5 Anti-patterns

- Do not paraphrase model responses into a bland average.
- Do not pick one model's answer and call it the synthesis.
- Do not hide disagreements — surface them.
- Do not skip the consult because "this one's easy" — that is the exact
  rationalization the hard gate exists to block.
- Do not bury open questions inside the proposed-design section. Surface
  them first, answer them, then design.
- Do not ask open questions as plain prose when they have discrete choices.
  Use the `question` tool.

## 5. Bootstrap injection and trigger detection

### 5.1 Injected block

Pushed onto the system-prompt array (`output.system`) via
`experimental.chat.system.transform` when `triggerMode: "auto"`:

```markdown
<quorum-bootstrap>
You have access to the `quorum_consult` tool, which fans a prompt out to
multiple models and returns their responses for you to synthesize.

**When to use it:** before any creative or planning work — new features,
components, behavior changes, architectural decisions, or any task where
"how should this work?" is not yet answered. Load the `quorum` skill for the
full workflow.

**Hard rule:** for planning work, you must consult the quorum, synthesize,
present a design, and receive explicit user approval before writing code or
invoking implementation tools. This applies regardless of perceived
simplicity.

**Not for:** pure bug fixes with obvious cause, typo fixes, dependency
bumps, running existing commands, answering factual questions.

When in doubt whether a task counts as planning: invoke the `quorum` skill
and let it guide you.
</quorum-bootstrap>
```

### 5.2 Session scoping

- Bootstrap is pushed onto the system prompt on every hook invocation; the
  `experimental.chat.system.transform` hook is designed for exactly this
  pattern. opencode handles system-prompt composition — the plugin does not
  need to cache or deduplicate.
- Subagent sessions (those with a `parentID`) inherit the system prompt
  from the orchestrator context. The `quorum_consult` tool's `execute`
  function resolves its root session ID (walking `parentID` chain via
  `client.session.get`, same pattern as `openrouter-session`) and refuses
  to run in subagent sessions, returning an informative error string.
  Quorum is a root-session discipline.

### 5.3 Trigger decision

The orchestrator, not the plugin, decides whether a task is planning work.
The bootstrap states the rule; the skill details the workflow. There is no
keyword sniffing, regex matching, or plugin-side classifier. Rationale: we
already rely on the model to follow skill directives (this is how
`superpowers` works); a plugin-side classifier would be brittle, opaque, and
duplicate judgment the model already performs well.

### 5.4 `triggerMode` values

- `"auto"`: bootstrap pushed onto system prompt, skill self-triggers.
  Default.
- `"manual"`: bootstrap not pushed; tool still registered. The user must
  explicitly invoke quorum (e.g., "use quorum to design this").
- `"off"`: plugin loads but returns an empty hooks object. Tool is not
  registered; no system-prompt injection occurs. Kill switch for quiet
  sessions.

## 6. Synthesis prompt template (returned by the tool)

The plugin renders this template into the `synthesisPrompt` field of the
tool's return value:

```markdown
You have received responses from {N} members of the quorum on the topic:
"{topic}".

Below are their responses, labeled. Read all of them before synthesizing.

{for each response:}
---
## {label} ({modelId})
{if ok:}
{text}
{if !ok:}
[This model did not respond: {error}]
---

Now produce a synthesis with the following structure. Do not skip sections;
if a section is empty, say so explicitly.

### Agreement
Points where 2+ members converged. These are high-confidence. Name which
members agreed.

### Key differences
Places where members proposed genuinely different approaches. Name the
member and summarize their position. Do not flatten the disagreement —
surface it.

### Partial coverage
Aspects only some members addressed. Flag as "worth considering" rather
than consensus.

### Unique insights
A single member saying something the others missed. Evaluate on merit. Do
not discard for being minority.

### Blind spots
What NO member addressed that you notice is missing. This is your value-add
as the synthesizer.

### Open questions
Before proposing a design, list questions whose answers would change the
design — decisions the user needs to make, tradeoffs you cannot resolve
alone, assumptions that need confirmation. For each question, note which
member(s) raised it or left it implicit.

### Proposed design
Your fused recommendation, informed by the above. Not a vote count. Not a
paraphrase of any single member. A synthesis.

**Surfacing open questions to the user:**

Before presenting the proposed-design section, surface the open questions.
Prefer the opencode `question` tool when the question has discrete choices
(multiple-choice, A/B, yes/no). Use plain conversational prose only when
the question is genuinely open-ended and no reasonable choice set exists.

Ask questions one at a time. Do not batch them. Do not hide them inside
the proposed design. The user must answer the questions that materially
shape the design before you present a design section. Lesser questions
(nice-to-knows) can be surfaced alongside the design.

Members that dropped from this quorum: {droppedModels or "none"}.
```

### 6.1 Per-member prompt

The prompt sent to each quorum member when `quorum_consult` dispatches:

```markdown
You are one member of a quorum of models being consulted on a planning
question. Your response will be synthesized alongside responses from other
models.

**Topic:** {topic}

**Question:**
{prompt}

{if context:}
**Additional context:**
{context}

**Instructions for your response:**
- Propose an approach. Do not just restate the problem.
- Be specific about architecture, components, data flow, and tradeoffs.
- If you see multiple viable approaches, name them and recommend one.
- Flag assumptions you are making.
- Flag things you would want to know before committing to an approach.
- Keep response focused. Do not pad. Aim for 400–800 words unless the topic
  genuinely needs more.
- Do not try to coordinate with other members. You cannot see their
  responses.
```

Rationale:

- Announcing the quorum role frees members from exhaustiveness — that is the
  synthesizer's job.
- Asking for a recommendation produces opinions rather than surveys.
- "Flag assumptions" and "flag open questions" gives the synthesizer raw
  material for the Blind spots and Open questions sections.
- Length guidance keeps the token cost predictable.

## 7. Spec writing, approval gate, and implementation transition

### 7.1 Spec location and filename

- Written to `{config.specDir}/YYYY-MM-DD-{topic}.md`.
- `topic` is a kebab-case slug derived from the `quorum_consult` call's
  `topic` argument.
- Default `specDir`: `docs/quorum/specs` (relative to cwd).
- Filename collision: append `-2`, `-3`, etc.

### 7.2 Spec structure

```markdown
# {Topic}

**Date:** YYYY-MM-DD
**Status:** Approved
**Quorum members:** opus, gpt5, gemini (dropped: none)

## Context
{problem, constraints, success criteria as established during clarifying
questions}

## Decisions resolved via open questions
{questions that were asked and how the user answered them — preserves the
"why this not that" record}

## Design
{the approved proposed-design content, section by section}

## Tradeoffs considered
{key differences and partial coverage from synthesis, distilled — what
alternatives were weighed and why we chose this path}

## Out of scope
{what this design explicitly does not cover}

## Open questions deferred
{questions flagged but deemed non-blocking — to revisit during implementation}
```

The "Decisions resolved via open questions" section is the unique artifact
of a quorum-produced spec. A normal design doc shows the chosen path; a
quorum spec also shows which forks were considered and why the chosen one
won.

### 7.3 Commit

The orchestrator commits the spec file with a message like
`Add quorum spec: {topic}`. Single commit, spec file only, no push.

### 7.4 Spec self-review

Same pattern as the `brainstorming` skill's self-review:

1. **Placeholder scan** — no TBD, TODO, or incomplete sections.
2. **Internal consistency** — sections do not contradict each other.
3. **Scope check** — focused enough for one implementation plan.
4. **Ambiguity check** — any requirement readable two ways is resolved
   explicitly.

Fix any issues inline. No re-review loop.

### 7.5 User review gate

After self-review, the orchestrator prompts:

> Spec written and committed to `{path}`. Please review it and let me know
> if you want changes before we move to implementation planning.

Wait for an explicit response. If changes are requested → amend the spec →
re-run self-review → re-prompt. Advance only on approval.

### 7.6 Transition to implementation

On spec approval:

- Orchestrator creates an implementation plan, either inline for simple
  specs or separately in `docs/quorum/plans/YYYY-MM-DD-{topic}-plan.md` for
  complex ones. The orchestrator judges which mode is appropriate.
- Implementation plans do not require another quorum consult. The design
  work is done; execution is bounded.
- Orchestrator proceeds with implementation using TDD, debugging, and
  verification patterns from its own training.
- The hard gate lifts once the spec is approved; from that point forward,
  normal implementation work applies.

### 7.7 Mid-review restart

If the user says "let's throw this out and start over" during spec review,
the orchestrator deletes the spec file and reverts the commit
(`git reset --soft HEAD~1` + remove file), then re-enters the brainstorm
loop at workflow step 2. Re-consult the quorum only if the design itself is
being rethought, not when the disagreement is about spec wording.

### 7.8 User override

The user may explicitly skip consultation ("skip quorum, just design it
yourself"). The orchestrator honors it, notes the override in the resulting
spec's Context section, skips the consult, and proceeds single-model. The
hard gate still applies to spec approval — only the consultation is
skipped.

## 8. Distribution and installation

### 8.1 Repository

Standalone at `~/code/github/quorum`, published as
`github.com/GITHUB_OWNER/quorum`. The `GITHUB_OWNER` placeholder is resolved
at repo-initialization time — the user confirms their GitHub account, and
every occurrence of `GITHUB_OWNER` in the spec, `package.json`, and config
schema URL is replaced with that account name.

### 8.2 Package shape

`package.json`:

```json
{
  "name": "quorum",
  "version": "0.1.0",
  "type": "module",
  "main": ".opencode/plugins/quorum.js",
  "opencode": {
    "plugin": ".opencode/plugins/quorum.js"
  },
  "files": [
    ".opencode/plugins/",
    "skills/",
    "schema.json",
    "README.md"
  ]
}
```

Both `main` and `opencode.plugin` point at the compiled plugin so the
opencode plugin loader finds it regardless of which field it consults.
`skills/` ships alongside the plugin so the plugin can read its own skill
files at runtime, mirroring how `superpowers` operates.

### 8.3 Build

TypeScript source in `src/`, compiled to `.opencode/plugins/quorum.js` as a
single-file ESM bundle. Build tool chosen at implementation time from
`esbuild` or `tsup` — both are acceptable.

The compiled artifact is checked into the repo so that
`git+https://github.com/.../quorum.git` installs work without requiring a
build step on the consumer. This matches how `superpowers` ships.

### 8.4 Chezmoi integration

In `dot_config/opencode/opencode.json.tmpl`:

```jsonc
"plugin": [
  "@tarquinen/opencode-dcp@latest",
  "quorum@git+https://github.com/GITHUB_OWNER/quorum.git"
  // superpowers entry removed
]
```

New file `dot_config/opencode/quorum.json` (or `.jsonc` if comments are
desired) carrying the default config schema from §2.

Removal of superpowers from this repo:

1. Remove the `superpowers@git+...` entry from the plugin array.
2. Remove any superpowers-specific references in
   `dot_config/opencode/AGENTS.md`. The "Skills: Always Active" caveman
   entry is unrelated and stays.
3. Leave the user's separate `~/code/github/superpowers` fork directory
   untouched — that is outside the scope of this work.
4. No other chezmoi changes are required; superpowers' skills were loaded
   dynamically by its plugin, so removing the plugin removes all of them.

### 8.5 Version pinning

For v0.1.0, the git URL resolves to default-branch HEAD. Stability can be
tightened later by pinning to a tag
(`quorum@git+https://github.com/GITHUB_OWNER/quorum.git#v0.1.0`). HEAD-tracking is
acceptable for the initial release.

### 8.6 Activation

After chezmoi changes, the user runs `chezmoi apply` and restarts opencode
(plugins load at session start). The first session with the new plugin
shows the quorum bootstrap block in the first user message.

### 8.7 Out of scope for v0.1.0

- CI and release automation on the quorum repo.
- Publishing to the npm registry (git+https install is sufficient).
- Telemetry and usage metrics.
- A cache for repeated identical consults.
- Multi-user or shared team configuration.

## 9. Testing strategy

### 9.1 Unit tests (in the quorum repo)

Runner: `vitest`.

- **`consult-tool.ts`** with a mocked opencode `client`:
  - Fan-out calls each configured model exactly once.
  - Concurrency limit is honored (5 models with `concurrency: 2` keeps at
    most 2 in flight).
  - Timeout drops a slow model and marks it in `droppedModels`.
  - An error from one model does not fail the others.
  - Fewer than 2 successful responses returns the abort-signal shape.
  - Truncation flag is set correctly when a response hits `maxTokens`.
- **`bootstrap.ts`** with fake message objects:
  - Root session (no `parentID`) receives the prepended block.
  - Subagent session (has `parentID`) does not receive the block.
  - Already-bootstrapped sessions (cache hit) do not get double-bootstrapped.
  - `triggerMode: "manual"` skips injection.
  - `triggerMode: "off"` skips everything.
- **`synthesis-prompt.ts`** with fixture responses that include errors,
  timeouts, and truncations: verify the rendered template has the correct
  sections, dropped-models list, and per-response branching.

### 9.2 Integration test (in the quorum repo)

A single end-to-end test that spins up a fake opencode client, registers
the plugin, fires a `quorum_consult` call against stubbed model backends,
and verifies the full tool-return shape. Not a real opencode session — a
test harness that mimics the plugin API surface.

### 9.3 Manual smoke-test checklist

Documented in the quorum README; the user runs through it once after
install and after version bumps:

1. Open a fresh opencode session; confirm the bootstrap block appears in
   the first user message's visible context.
2. Start a planning request; confirm the orchestrator invokes
   `quorum_consult` rather than jumping to implementation.
3. Confirm N labeled model responses come back.
4. Confirm the orchestrator produces the seven-section synthesis.
5. Confirm open questions are asked via the `question` tool (for discrete
   choices) before the proposed-design section is presented.
6. Confirm the approved design is written to `docs/quorum/specs/...` and
   committed.
7. Trigger a subagent call (e.g., the `search` subagent). Confirm
   `quorum_consult` is not available and does not fire there.
8. Set `triggerMode: "manual"`, start a new session, confirm the bootstrap
   block is absent.
9. Trigger a pure bug fix ("fix typo in README"). Confirm the orchestrator
   does not invoke quorum.
10. Force a failure by configuring one nonexistent model. Confirm graceful
    degradation — other members still respond, the missing one appears in
    `droppedModels`.

### 9.4 Failure-mode regression guards

Each failure mode in §4.4 (fewer than 2 respond, trivial agreement, sharp
disagreement, tool errors) is covered by a unit test with a fixture. These
tests double as executable contract documentation.

### 9.5 Explicitly out of scope for testing

- Quality of any specific model's output.
- Network-level openrouter behavior.
- Whether the orchestrator "correctly" judges a task as planning — that is
  the model's responsibility; we test the tool surface, not the judgment.

### 9.6 CI

Deferred per §8.7. For v0.1 the tests run locally before pushing. A
post-v0.1 improvement is a GitHub Actions workflow running `vitest run` on
pull requests.
