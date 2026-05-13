# cfb opencode registry

OCX-compatible registry that publishes my OpenCode profiles, skills, and
commands at <https://opencode.cfb.dev>.

## Components

| Type    | Names                                                  |
| ------- | ------------------------------------------------------ |
| profile | `work-or`, `work-direct`, `personal-or`, `personal-zen` |
| skill   | `adaptive-planning`, `git`, `subagents`                |
| command | `remember`, `review`                                   |

Each profile is self-contained: it ships its full merged `opencode.jsonc`,
per-profile config (`ocx.jsonc`, `quorum.json`, `cesium.json`), and all agent
prompts. Profile components declare the skills and commands as dependencies.

## Usage

Add the registry, install a profile, then install the skills and commands:

```sh
ocx registry add https://opencode.cfb.dev --name cfb

ocx profile add work-or --source cfb/work-or --global
ocx add cfb/adaptive-planning cfb/git cfb/subagents cfb/remember cfb/review

ocx oc -p work-or
```

Swap `work-or` for any of the four profiles. Skills and commands install
globally and are shared across all profiles, so step two only needs to run
once per machine.

Swap `work-or` for any of the four profiles.

If `ocx profile add` does not pull in dependencies transitively, install the
skills and commands directly:

```sh
ocx add cfb/adaptive-planning cfb/git cfb/subagents cfb/remember cfb/review
```
