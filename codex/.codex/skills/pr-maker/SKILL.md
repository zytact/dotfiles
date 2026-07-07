---
name: pr-maker
description: Use when asked to use Pi CLI to turn local repo work into a pull request, especially when the user wants model opencode/deepseek-v4-flash-free:high, wants Pi to review scope, draft branch and commit names, or write PR text.
---

# PR Maker

Use installed Pi CLI, not pi.dev UI.

## Workflow

1. Confirm repo path, base branch, PR goal, and excluded files.
2. Check local state with `git status --short` and `git diff --stat`.
3. If useful, also collect `git diff --cached` or `git diff origin/<base>...HEAD`.
4. Keep scope tight. Do not mix unrelated dirty files into the PR.
5. Ask Pi with exact CLI form:

```bash
pi -p --model opencode/deepseek-v4-flash-free:high 'Make a PR from the uncommitted changes in this repo.'
```

6. In the prompt, give Pi:
   - repo path
   - base branch
   - PR goal
   - allowed scope
   - excluded files
   - pasted status and diff summary
   - optional pasted full diff
7. Require Pi to:
   - review scope
   - say which files belong in the PR
   - propose branch name in prefix kebab-case
   - propose one Conventional Commit message
   - propose PR title
   - propose PR body
   - flag risks, test gaps, and unclear files
8. Review Pi output. Reject vague scope, mixed commits, or invented facts.
9. Create branch if needed. Stage only intended files. Commit. Push.
10. Open PR using the validated Pi title/body.
11. Pi should return the PR url.

## Prompt Frame

```text
Review this repo change for a focused PR.
Base branch: <base>
Goal: <goal>
Allowed scope: <files/features>
Exclude: <files/dirs>

Status:
<paste git status --short>

Diff stat:
<paste git diff --stat>

Optional full diff:
<paste git diff --cached or git diff origin/<base>...HEAD>

Return only:
1. scope review
2. branch name
3. conventional commit message
4. PR title
5. PR body
6. risks and test gaps

Do not invent changes. Keep branch/commit/PR names concise.
```

## Rules

- Always use `pi -p --model opencode/deepseek-v4-flash-free:high '<prompt here>'`.
- Make Pi help produce the PR itself, not just summarize code.
- Rewrite Pi output to match actual diff, tests run, and real risks.
- Do not treat the PR as ready until scope and text are verified.
- Do not use pi as a reviewer. 
