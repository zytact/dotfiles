---
name: deputy-preset
description: Run the deputy skill with fixed models - astra low as superior, terra medium for implementation and verification, sol medium for code review, luna high for the PR.
disable-model-invocation: true
---

# Deputy Preset

Load the `deputy` skill and obey it end to end. It holds the full workflow: setup, briefing, monitoring, reading the diff, and landing.

This skill only fixes the models and reasoning levels. Everything else comes from `deputy`.

## Model assignments

Use these with no substitutions and do not ask for alternatives:

- Superior model: `astra` with low reasoning.
- Implementation subagents: `terra` with medium reasoning.
- Code review (`code-review` skill): `sol` with medium reasoning.
- Verification subagent: `terra` with medium reasoning.
- PR subagent (`file-pr` skill): `luna` with high reasoning.

Do not ask the user to name the superior. Do not pick a per-unit model by difficulty. When `deputy` says to keep the requested model and reasoning level, these are the requested ones: report and ask first before changing any of them.
