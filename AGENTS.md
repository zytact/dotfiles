# AGENTS

- Repo purpose: dotfiles managed with [chezmoi](https://www.chezmoi.io). `.chezmoiroot` points at `home/`, which is the chezmoi source state; everything outside `home/` is NOT deployed (reference/build material such as `t3code/`, `vscode/`, `vscode-neovim/`, `japanese/`, `mcphub/`, `anki/`, `cliproxyapi/`, and `claude/settings.json`).
- Source dir is configured in `~/.config/chezmoi/chezmoi.toml` (`sourceDir = "~/dotfiles"`); it is not tracked.
- Deployed files are **copies**, not symlinks. Edit the source (`chezmoi edit <target>` or edit under `home/`), then `chezmoi apply`. If a live file was edited directly, pull it back with `chezmoi add <target>`.
- Naming: a leading `.` becomes `dot_` (`dot_config/nvim` -> `~/.config/nvim`), executable files get `executable_`, symlinks are `symlink_<name>` files whose content is the link target (relative to the deployed dir).
- Per-machine differences: `home/.chezmoiignore` (templated; currently skips desktop-only tools on WSL), plus `.tmpl` files using `.chezmoi.*` data. Keep shell guards (`[ -f ... ]`, `command -v`) for optional tools.
- `~/.claude/settings.json` is a symlink (via `home/dot_claude/symlink_settings.json.tmpl`) to `claude/settings.json` in this repo, because Claude Code rewrites it.
- No build/test/lint workflows are defined; avoid guessing commands. Useful checks: `chezmoi diff`, `chezmoi status`, `chezmoi apply -n -v`.

## Adding a new tool config

1. Copy the files into `home/` with the naming above, or run `chezmoi add ~/.config/<tool>/<file>` (it picks the names).
2. Do not add runtime state, caches, credentials or history; add only config.
3. If it must not deploy on some machine, add its target path to `home/.chezmoiignore`.
4. `chezmoi diff` to review, `chezmoi apply` to deploy, then commit.

## New machine

`chezmoi init --source ~/dotfiles --apply <repo-url>` (after `git clone <repo-url> ~/dotfiles` if preferred), then set `sourceDir` in `~/.config/chezmoi/chezmoi.toml`. Create `~/.secrets` by hand.

## Windows-side wezterm (WSL)

`C:\Users\arnab\.wezterm.lua` does `dofile` on `\\wsl.localhost\Ubuntu\home\arnab\dotfiles\home\dot_config\wezterm\wezterm.lua`. The config sets the WSL domain and font size when running on Windows.
