---
name: subagents
description: invoke this skill when the user asks you to use subagents
---

# Subagents

Each subagent is headless, has its own context window, cannot see the parent conversation, cannot ask the user, and cannot spawn subagents or workflows. Give every child a self-contained prompt with paths, constraints, and the expected report.

## Pi Harness

**Harness:** `pi`
**Prompt nicknames:** “pi”, “pi agent”, “pi subagent”
**Best default:** Use when the user does not request another harness. It inherits the parent model and thinking level when `model` or `reasoning_effort` is omitted.

Do not use models from the Anthropic provider even if one appears in the model list.

Pi can use any model shown by `pi --list-models`. Prefer `provider/model-id`; a bare model id only works when unambiguous. Common picks in this environment:

| Model                            | Recommended effort |
| -------------------------------- | ------------------ |
| inherited parent model (default) | inherited          |
| `openai-codex/gpt-5.6-sol`       | `low`             |
| `openai-codex/gpt-5.6-terra`     | `high`             |
| `openai-codex/gpt-5.6-luna`     | `max`             |
| `opencode/deepseek-v4-flash-free`       | `high`           |

**Reasoning efforts:** `off`, `minimal`, `low`, `medium`, `high`, `xhigh`, `max`. These map directly to pi thinking levels. The subagents UI shows the effective level used by the child session.

## Claude Code Harness

**Harness:** `claude`
**Prompt nicknames:** “claude”, “Claude Code”, “claude agent”, “claude subagent”, "cc"
**Best default:** use the latest opus model on low reasoning. Do not default to anything else, if the user does not specify, use opus.

| Model hint | Model               | Recommended effort |
| ---------- | ------------------- | ------------------ |
| `opus`    | latest Claude Opus | `low`             |
| `sonnet`    | latest Claude sonnet | `medium`             |

**Reasoning efforts:** `off`, `minimal`, `low`, `medium`, `high`, `xhigh`, `max`. The extension uses Claude's native adaptive-thinking effort control: `off` disables thinking, `minimal` maps to Claude's lowest native level (`low`), and `low` through `max` map directly. The subagents UI reports Claude's effective per-turn effort after any model-specific downgrade.

Requires Claude Code to be installed and authenticated.

## Codex Harness

**Harness:** `codex`
**Prompt nicknames:** “codex”, “Codex CLI”, “codex agent”, “codex subagent”
**Best default:** `gpt-5.6-terra` with `high` effort for coding work. Do not use anything other than sol unless the user specifically asks for it.

| Model           | Recommended effort |
| --------------- | ------------------ |
| `gpt-5.6-sol`   | `low`             |
| `gpt-5.6-terra` | `high`             |
| `gpt-5.6-luna`  | `max`             |

**Reasoning efforts accepted by the extension:** `off`, `minimal`, `low`, `medium`, `high`, `xhigh`, `max`. Codex maps these to the nearest effort supported by the selected model; `off`/`minimal` become `minimal`, while `max` becomes the highest extension-supported Codex effort. The subagents UI shows the effective mapped level.

Requires the Codex CLI to be installed and authenticated.

## Spawn and Manage

Call `subagent_spawn` with a complete `prompt`, short `name`, chosen `harness`, and optional `working_dir`, `model`, and `reasoning_effort`. At most four subagents run concurrently.

- `subagent_check({ id })`: peek without blocking.
- `subagent_list()`: list all runs.
- `subagent_wait({ ids })`: block only when results are required to proceed.
- `subagent_cancel({ ids })`: stop runs while preserving partial transcripts.
- `/subagents`: inspect or take over a run interactively.

Results return automatically. After spawning, continue useful parent work instead of immediately waiting.
