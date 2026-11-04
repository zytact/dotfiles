# AGENTS

Dotfiles managed with [chezmoi](https://www.chezmoi.io). `.chezmoiroot` points at `home/`, the source state. Everything outside `home/` is reference or build material and is not deployed.

## Working here

- Deployed files are copies. Edit the source under `home/`, then `chezmoi apply`. If a live file changed, pull it back with `chezmoi add <target>`.
- Before `chezmoi apply`, check `chezmoi status`. An `M` in the first column means the live file changed since the last apply, and applying would overwrite it.
- Symlinks are `symlink_<name>` files whose content is the link target, relative to the deployed directory.
- Track config only. Runtime state, caches, credentials and history stay out.
- Per-machine differences go in `home/.chezmoiignore`, which is templated: WSL skips desktop-only tools, other machines skip WSL-only ones. Use `.tmpl` files for smaller differences, and shell guards (`[ -f ... ]`, `command -v`) for optional tools.
- There is no build, test or lint. Check with `chezmoi diff`, `chezmoi status` and `chezmoi apply -n -v`.

## Machines

Two machines share this repo at `~/dotfiles`: WSL (Ubuntu) and Fedora, reachable with `ssh arnab@fedora`. Fedora commits on its own, such as is-dl variants from scheduled runs. After pushing from one machine, sync the other one yourself over ssh: `git pull --rebase`, then `chezmoi apply`. Do not hand this step to the user.

MCP servers are machine-specific and untracked. They live in `~/.claude.json` and `~/.config/opencode/opencode.json`. Shared OpenCode settings go in the tracked `opencode.jsonc`, which OpenCode merges with `opencode.json`. It ignores `config.json`. OpenCode runs a background `opencode serve` that caches config, so run `opencode reload` after any config change, including before `opencode debug config`. For about 5 seconds after the service starts, `opencode mcp list` reports "No MCP servers configured", so wait before trusting it.

## Shell and agents

- PATH and exports live in `home/dot_config/shell/env.sh`, sourced by `.zshenv` and `.bashrc`. `.zshrc` is for interactive use only.
- Agents run commands in bash. Claude Code gets it through `SHELL` in the `env` of `claude/settings.json`, which also fixes the shell it reports. Codex gets it through a handoff in `.zshenv`, since Codex always uses the login shell.
- `~/.claude/settings.json` is a symlink to `claude/settings.json` in this repo, because Claude Code rewrites it. Its key-order churn is safe to commit.

## Skills

Skills are installed with `npx skills` from `zytact/skills`, which is cloned at `~/Projects/skills` on Fedora, plus other GitHub repos. Each install lands in `~/.agents/skills/` (read by OpenCode and Codex), with a symlink in `~/.claude/skills/` for Claude Code. After `npx skills add` or `update`, run `chezmoi add ~/.agents ~/.claude/skills` and commit.

Some skills are machine-specific: `agent-desktop` and `compress-videos` are WSL only and `computer-use-linux` is Fedora only, enforced by `.chezmoiignore`. `~/.agents/.skill-lock.json` is shared and lists all of them, so `npx skills update` may install the other machine's skills too. Afterwards, delete it from `~/.agents/skills/` and `~/.claude/skills/` on the wrong machine.

## Review evals

`review-evals/` holds shadow reviews from the `code-review` skill, which runs DeepSeek next to the normal reviewer to compare the two. Each run directory has DeepSeek's report and the parent model's verified report. It is data, not config, and kept here so both machines' runs end up in one place. Commit new runs as `chore(review-evals): add runs`.

## Computer use

WSL drives Windows with the `agent-desktop` CLI. The Windows binary lives in `C:\Users\arnab\.local\bin\agent-desktop\`, linked from `~/.local/bin/agent-desktop`. Neither is tracked. To update it, extract the `x86_64-pc-windows-msvc` archive from the GitHub releases of `vercel-labs/agent-desktop` into that folder. Fedora uses the `computer-use-linux` MCP server, because agent-desktop has no mouse input on Wayland.

## Agent session backups

`backup-agent-sessions` uploads raw Claude Code, Codex and OpenCode sessions to a restic repo in the R2 bucket `agent-sessions`. A daily T3 scheduled task runs it on each machine: WSL (restic host `MSI`) at 22:00, Fedora (host `fedora`) at 03:00. restic is the static binary from its GitHub releases in `~/.local/bin`, untracked. Credentials are in `~/.secrets`, and restic needs the R2 keys as `AWS_*`. To read the repo:

```bash
. ~/.secrets; export AWS_ACCESS_KEY_ID=$R2_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$R2_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=auto
restic snapshots
restic restore latest --host fedora --target <dir>
```

The repo keeps every snapshot forever. Never run `restic forget` or `restic prune`.

## New machine

`chezmoi init --source ~/dotfiles --apply <repo-url>` (after `git clone <repo-url> ~/dotfiles` if preferred). Then set `sourceDir = "~/dotfiles"` in `~/.config/chezmoi/chezmoi.toml`, which is untracked, and create `~/.secrets` by hand.

## Windows-side wezterm (WSL)

`C:\Users\arnab\.wezterm.lua` does `dofile` on `\\wsl.localhost\Ubuntu\home\arnab\dotfiles\home\dot_config\wezterm\wezterm.lua`. The config sets the WSL domain and font size when running on Windows.
