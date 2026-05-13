#!/usr/bin/env node
// Build the cfb opencode registry.
//
// 1. Resolve auto-version from git commit count.
// 2. Sync source files from the chezmoi tree into ./files/:
//      - per-profile dirs: merged opencode.jsonc + ocx.jsonc + quorum.json
//        + cesium.json + prompts/
//      - skills/<name>/SKILL.md
//      - commands/<name>.md
// 3. Generate registry.jsonc declaring all components.
// 4. Run `ocx build . --out dist`.
//
// Source of truth lives at ../dot_config/opencode/.

import fs from "node:fs/promises";
import path from "node:path";
import { execSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(HERE, "..");
const OC_SRC = path.join(REPO_ROOT, "dot_config", "opencode");
const FILES_OUT = path.join(HERE, "files");
const DIST_OUT = path.join(HERE, "dist");
const REGISTRY_OUT = path.join(HERE, "registry.jsonc");

const PROFILES = [
  {
    name: "work-or",
    description: "Work profile (OpenRouter) — opus 4.7 / sonnet 4.6 / gpt-5.5",
  },
  {
    name: "work-direct",
    description: "Work profile (direct providers) — Anthropic & OpenAI APIs",
  },
  {
    name: "personal-or",
    description: "Personal profile (OpenRouter) — sonnet 4.6 / haiku 4.5",
  },
  {
    name: "personal-zen",
    description: "Personal profile (OpenCode Zen / opencode-go) — free tier",
  },
];

const SKILLS = [
  { name: "adaptive-planning", description: "Plan depth that adapts to risk and scope" },
  { name: "git", description: "Safe git operations — avoids editor-opening and destructive commands" },
  { name: "subagents", description: "Adaptive review strictness for subagent execution" },
];

const COMMANDS = [
  { name: "remember", description: "Persist a fact or preference into project memory" },
  { name: "review", description: "Run a review pass over recent changes" },
];

const PROMPTS = ["smart", "rush", "deep", "search", "oracle", "librarian", "carpenter"];

// ----------------------------------------------------------------------------

function stripJsoncComments(src) {
  // Strip // line comments and /* block comments */ — naive but adequate for
  // our hand-authored opencode.jsonc files.
  return src
    .replace(/("(?:[^"\\]|\\.)*")|\/\/[^\n]*|\/\*[\s\S]*?\*\//g, (m, str) => str ?? "")
    .replace(/,(\s*[}\]])/g, "$1");
}

async function readJsonc(file) {
  const raw = await fs.readFile(file, "utf8");
  return JSON.parse(stripJsoncComments(raw));
}

function deepMerge(a, b) {
  if (b === undefined) return a;
  if (a === undefined) return b;
  if (Array.isArray(a) || Array.isArray(b)) return b;
  if (typeof a !== "object" || a === null) return b;
  if (typeof b !== "object" || b === null) return b;
  const out = { ...a };
  for (const k of Object.keys(b)) {
    out[k] = k in a ? deepMerge(a[k], b[k]) : b[k];
  }
  return out;
}

function gitVersion() {
  const count = execSync("git rev-list --count HEAD", { cwd: REPO_ROOT })
    .toString()
    .trim();
  return `1.0.${count}`;
}

// ----------------------------------------------------------------------------

async function syncFiles() {
  await fs.rm(FILES_OUT, { recursive: true, force: true });
  await fs.mkdir(FILES_OUT, { recursive: true });

  const baseConfig = await readJsonc(path.join(OC_SRC, "opencode.jsonc"));

  // Profiles
  for (const { name } of PROFILES) {
    const srcDir = path.join(OC_SRC, "profiles", name);
    const dstDir = path.join(FILES_OUT, "profiles", name);
    await fs.mkdir(path.join(dstDir, "prompts"), { recursive: true });

    // Merge base + profile override → full opencode.jsonc
    const override = await readJsonc(path.join(srcDir, "opencode.jsonc"));
    const merged = deepMerge(baseConfig, override);
    await fs.writeFile(
      path.join(dstDir, "opencode.jsonc"),
      JSON.stringify(merged, null, 2) + "\n",
    );

    // Per-profile static configs (cesium is shared from the global location)
    for (const f of ["ocx.jsonc", "quorum.json"]) {
      await fs.copyFile(path.join(srcDir, f), path.join(dstDir, f));
    }
    await fs.copyFile(
      path.join(OC_SRC, "cesium.json"),
      path.join(dstDir, "cesium.json"),
    );

    // Prompts (shared, copied per profile so each install is self-contained)
    for (const p of PROMPTS) {
      await fs.copyFile(
        path.join(OC_SRC, "prompts", `${p}.md`),
        path.join(dstDir, "prompts", `${p}.md`),
      );
    }
  }

  // Skills
  for (const { name } of SKILLS) {
    const dstDir = path.join(FILES_OUT, "skills", name);
    await fs.mkdir(dstDir, { recursive: true });
    await fs.copyFile(
      path.join(OC_SRC, "skills", name, "SKILL.md"),
      path.join(dstDir, "SKILL.md"),
    );
  }

  // Commands
  const cmdDst = path.join(FILES_OUT, "commands");
  await fs.mkdir(cmdDst, { recursive: true });
  for (const { name } of COMMANDS) {
    await fs.copyFile(
      path.join(OC_SRC, "commands", `${name}.md`),
      path.join(cmdDst, `${name}.md`),
    );
  }
}

// ----------------------------------------------------------------------------

function buildManifest(version) {
  const depNames = [...SKILLS, ...COMMANDS].map((c) => c.name);

  const components = [];

  for (const { name, description } of SKILLS) {
    components.push({
      name,
      type: "skill",
      description,
      files: [
        {
          path: `skills/${name}/SKILL.md`,
          target: `skills/${name}/SKILL.md`,
        },
      ],
    });
  }

  for (const { name, description } of COMMANDS) {
    components.push({
      name,
      type: "command",
      description,
      files: [
        {
          path: `commands/${name}.md`,
          target: `commands/${name}.md`,
        },
      ],
    });
  }

  for (const { name, description } of PROFILES) {
    const files = [
      "opencode.jsonc",
      "ocx.jsonc",
      "quorum.json",
      "cesium.json",
      ...PROMPTS.map((p) => `prompts/${p}.md`),
    ].map((rel) => ({
      path: `profiles/${name}/${rel}`,
      target: rel,
    }));

    components.push({
      name,
      type: "profile",
      description,
      dependencies: depNames,
      files,
    });
  }

  return {
    $schema: "https://ocx.kdco.dev/schemas/v2/registry.json",
    name: "cfb opencode",
    version,
    author: "cfbender",
    components,
  };
}

// ----------------------------------------------------------------------------

async function main() {
  const version = gitVersion();
  console.log(`▶ syncing files (version ${version})`);
  await syncFiles();

  console.log(`▶ generating registry.jsonc`);
  const manifest = buildManifest(version);
  await fs.writeFile(REGISTRY_OUT, JSON.stringify(manifest, null, 2) + "\n");

  console.log(`▶ ocx build`);
  await fs.rm(DIST_OUT, { recursive: true, force: true });
  execSync("npx -y ocx@latest build . --out dist", {
    cwd: HERE,
    stdio: "inherit",
  });

  console.log(`✓ built ${manifest.components.length} components → dist/`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
