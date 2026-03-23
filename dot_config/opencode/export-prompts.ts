import { existsSync, mkdirSync, writeFileSync, readFileSync } from "fs";
import { join, resolve } from "path";
import { createSisyphusAgent } from "../src/agents/sisyphus";
import { createHephaestusAgent } from "../src/agents/hephaestus/agent";
import { createOracleAgent, ORACLE_PROMPT_METADATA } from "../src/agents/oracle";
import { createExploreAgent, EXPLORE_PROMPT_METADATA } from "../src/agents/explore";
import { createLibrarianAgent, LIBRARIAN_PROMPT_METADATA } from "../src/agents/librarian";
import type { AvailableAgent } from "../src/agents/dynamic-agent-prompt-builder";

// --- Constants ---

const CHEZMOI_PROMPTS_DIR = join(
  process.env.HOME ?? "~",
  ".local/share/chezmoi/dot_config/opencode/prompts",
);
const OVERRIDES_DIR = join(CHEZMOI_PROMPTS_DIR, "overrides");
const STAGING_DIR = resolve("tmp/exported-prompts");

// --- Subagent context for Sisyphus/Hephaestus ---

const SUBAGENTS: AvailableAgent[] = [
  {
    name: "oracle",
    description:
      "Read-only consultation agent. High-IQ reasoning specialist for debugging hard problems and high-difficulty architecture design.",
    metadata: ORACLE_PROMPT_METADATA,
  },
  {
    name: "search",
    description:
      'Contextual grep for codebases. Answers "Where is X?", "Which file has Y?", "Find the code that does Z". Fire multiple in parallel for broad searches.',
    metadata: EXPLORE_PROMPT_METADATA,
  },
  {
    name: "librarian",
    description:
      "Specialized codebase understanding agent for multi-repository analysis, searching remote codebases, retrieving official documentation, and finding implementation examples.",
    metadata: LIBRARIAN_PROMPT_METADATA,
  },
];

// --- Agent prompt definitions ---

interface AgentDef {
  name: string;
  render: () => string;
}

const AGENTS: AgentDef[] = [
  {
    name: "smart",
    render: () => {
      const config = createSisyphusAgent(
        "claude-opus-4-6",
        SUBAGENTS,
        [],   // availableToolNames
        [],   // availableSkills
        [],   // availableCategories
        false, // useTaskSystem
      );
      return config.prompt;
    },
  },
  {
    name: "deep",
    render: () => {
      const config = createHephaestusAgent(
        "gpt-5.3-codex",
        SUBAGENTS,
        [],   // availableToolNames
        [],   // availableSkills
        [],   // availableCategories
        false, // useTaskSystem
      );
      return config.prompt;
    },
  },
  {
    name: "oracle",
    render: () => {
      // GPT variant (gpt-5.4) as per design
      const config = createOracleAgent("gpt-5.4");
      return config.prompt;
    },
  },
  {
    name: "search",
    render: () => {
      const config = createExploreAgent("any");
      return config.prompt;
    },
  },
  {
    name: "librarian",
    render: () => {
      const config = createLibrarianAgent("any");
      return config.prompt;
    },
  },
];

// --- Override support ---

function readOverride(name: string): string | undefined {
  const overridePath = join(OVERRIDES_DIR, `${name}.md`);
  if (existsSync(overridePath)) {
    return readFileSync(overridePath, "utf-8");
  }
  return undefined;
}

// --- Strip internal codenames ---

const CODENAME_PATTERN = /^.*(?:sisyphus|hephaestus).*\n?/gim;

function stripCodenames(text: string): string {
  return text
    .replace(CODENAME_PATTERN, "")
    .replace(/\n{3,}/g, "\n\n")
    .replace(/^\n+/, "");
}

// --- Compose final content ---

function composePrompt(name: string, rendered: string): string {
  const cleaned = stripCodenames(rendered);
  const override = readOverride(name);
  if (override) {
    return `${cleaned.trimEnd()}\n\n${override.trimEnd()}\n`;
  }
  return `${cleaned.trimEnd()}\n`;
}

// --- Diff support ---

function diffSummary(
  name: string,
  newContent: string,
): { added: number; removed: number; changed: boolean } {
  const chezmoiPath = join(CHEZMOI_PROMPTS_DIR, `${name}.md`);
  if (!existsSync(chezmoiPath)) {
    const lines = newContent.split("\n").length;
    return { added: lines, removed: 0, changed: true };
  }
  const existing = readFileSync(chezmoiPath, "utf-8");
  if (existing === newContent) {
    return { added: 0, removed: 0, changed: false };
  }

  const oldLines = existing.split("\n");
  const newLines = newContent.split("\n");
  // Simple line-count diff (not a real unified diff, just a summary)
  const added = Math.max(0, newLines.length - oldLines.length);
  const removed = Math.max(0, oldLines.length - newLines.length);
  return { added, removed, changed: true };
}

// --- CLI ---

const args = process.argv.slice(2);
const showDiff = args.includes("--diff");
const apply = args.includes("--apply");

// Render all prompts
const rendered = new Map<string, string>();
for (const agent of AGENTS) {
  const raw = agent.render();
  const final = composePrompt(agent.name, raw);
  rendered.set(agent.name, final);
}

// Always write to staging
mkdirSync(STAGING_DIR, { recursive: true });
for (const [name, content] of rendered) {
  writeFileSync(join(STAGING_DIR, `${name}.md`), content);
}

console.log(`\nRendered ${rendered.size} prompts to ${STAGING_DIR}/\n`);

// Print file sizes
for (const [name, content] of rendered) {
  const bytes = Buffer.byteLength(content, "utf-8");
  const kb = (bytes / 1024).toFixed(1);
  console.log(`  ${name}.md  ${kb} KB  (${content.split("\n").length} lines)`);
}

// Diff summary (always shown in default and apply modes)
if (!showDiff) {
  console.log("\nDiff vs chezmoi:");
  let anyChanged = false;
  for (const [name, content] of rendered) {
    const diff = diffSummary(name, content);
    if (diff.changed) {
      anyChanged = true;
      const chezmoiPath = join(CHEZMOI_PROMPTS_DIR, `${name}.md`);
      const existed = existsSync(chezmoiPath);
      if (!existed) {
        console.log(`  ${name}.md  NEW (+${content.split("\n").length} lines)`);
      } else {
        console.log(
          `  ${name}.md  CHANGED (+${diff.added} -${diff.removed} lines)`,
        );
      }
    } else {
      console.log(`  ${name}.md  unchanged`);
    }
  }
  if (!anyChanged) {
    console.log("  All files up to date.");
  }
}

// --diff: full unified diff via Bun shell
if (showDiff) {
  for (const [name] of rendered) {
    const stagedPath = join(STAGING_DIR, `${name}.md`);
    const chezmoiPath = join(CHEZMOI_PROMPTS_DIR, `${name}.md`);
    if (!existsSync(chezmoiPath)) {
      console.log(`\n--- ${name}.md (NEW FILE) ---`);
      console.log(readFileSync(stagedPath, "utf-8"));
      continue;
    }
    const proc = Bun.spawnSync(["diff", "-u", chezmoiPath, stagedPath]);
    const output = proc.stdout.toString();
    if (output) {
      console.log(`\n--- ${name}.md ---`);
      console.log(output);
    } else {
      console.log(`\n--- ${name}.md --- (unchanged)`);
    }
  }
}

// --apply: copy to chezmoi
if (apply) {
  console.log("\nApplying to chezmoi...");
  for (const [name, content] of rendered) {
    const target = join(CHEZMOI_PROMPTS_DIR, `${name}.md`);
    writeFileSync(target, content);
    console.log(`  wrote ${target}`);
  }
  console.log("\nDone. Run `chezmoi apply` to sync to ~/.config/opencode/prompts/");
}
