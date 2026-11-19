# AGENTS

Dotfiles managed with [chezmoi](https://www.chezmoi.io). `.chezmoiroot` points at `home/`, the source state. Everything outside `home/` is reference or build material and is not deployed. The one exception is `teach/LEARNER.md`, the teach skill's learner profile. `TEACH_LEARNER` points at it, so it is read and written in place and synced through git. On the MSI laptop, WSL points at the Windows clone's copy, so the laptop edits one file.

## Working here

- Deployed files are copies. Edit the source under `home/`, then `chezmoi apply`. If a live file changed, pull it back with `chezmoi add <target>`.
- Before `chezmoi apply`, check `chezmoi status`. An `M` in the first column means the live file changed since the last apply, and applying would overwrite it.
- Symlinks are `symlink_<name>` files whose content is the link target, relative to the deployed directory.
- Track config only. Runtime state, caches, credentials and history stay out.
- Per-machine differences go in `home/.chezmoiignore`, which is templated: WSL and Windows skip Linux desktop tools, Fedora skips WSL- and Windows-only ones, and Windows also skips zsh, `xdg-open` and systemd. Use `.tmpl` files for smaller differences, and shell guards (`[ -f ... ]`, `command -v`) for optional tools.
- There is no build, test or lint. Check with `chezmoi diff`, `chezmoi status` and `chezmoi apply -n -v`.

## Machines

Three environments share this repo at `~/dotfiles`: native Windows and WSL (Ubuntu) on the MSI laptop, both in active use, and Fedora, reachable with `ssh arnab@fedora`. WSL and Windows have separate clones. Fedora commits on its own, such as is-dl variants from scheduled runs. After pushing from one machine, sync the others yourself, over ssh for Fedora and `wsl.exe` for WSL: `git pull --rebase`, then `chezmoi apply`. Do not hand this step to the user.

MCP servers are machine-specific and untracked. They live in `~/.claude.json` and `~/.config/opencode/opencode.json`. Shared OpenCode settings go in the tracked `opencode.jsonc`, which OpenCode merges with `opencode.json`. It ignores `config.json`. OpenCode runs a background `opencode serve` that caches config, so run `opencode reload` after any config change, including before `opencode debug config`. For about 5 seconds after the service starts, `opencode mcp list` reports "No MCP servers configured", so wait before trusting it.

## Shell and agents

- PATH and exports live in `home/dot_config/shell/env.sh`, sourced by `.zshenv` and `.bashrc`. `.zshrc` is for interactive use only.
- On Linux and WSL, agents run commands in bash. Claude Code gets it through `SHELL` in the `env` of `claude/settings.json`, which also fixes the shell it reports. Codex gets it through a handoff in `.zshenv`, since Codex always uses the login shell. On Windows, agents use PowerShell and keep Git Bash for bash scripts. Claude Code's Bash tool is always Git Bash there, whatever `SHELL` says.
- `~/.claude/settings.json` is a symlink to `claude/settings.json` in this repo, because Claude Code rewrites it. Its key-order churn is safe to commit.

## Skills

Skills are installed with `npx skills` from `zytact/skills` and other GitHub repos. `~/.agents/.skill-lock.json` names each skill's source. Each install lands in `~/.agents/skills/` (read by OpenCode and Codex), with symlinks in `~/.claude/skills/` for Claude Code and `~/.gemini/config/skills/` for Antigravity. After `npx skills add` or `update`, run `chezmoi add ~/.agents ~/.claude/skills ~/.gemini/config/skills` and commit.

Skills from `zytact/skills` are Arnab's own, and their copies under `home/dot_agents/skills/` are install output that the next update overwrites. To change one, edit it in `zytact/skills`, cloned at `~/Projects/skills` on every machine: pull, commit, push, then `npx skills update -g -y <skill>` from WSL or Fedora and the `chezmoi add` above. Pull the clone and the dotfiles on the other machines too.

Skills run on Linux, WSL and Windows. A skill gives one set of commands, and its scripts branch inside on the platform (`process.platform`, `WSL_DISTRO_NAME`). Detail only one platform needs goes in a sibling file, and SKILL.md gives it one line saying when to read it, so other platforms never load it.

Some skills are machine-specific: `agent-desktop` runs on WSL and Windows, `compress-videos` is WSL only and `computer-use-linux` is Fedora only, enforced by `.chezmoiignore`. `~/.agents/.skill-lock.json` is shared and lists all of them, so `npx skills update` may install the other machine's skills too. Afterwards, delete it from `~/.agents/skills/` and `~/.claude/skills/` on the wrong machine.

## Antigravity

The Antigravity CLI (`agy`) runs on WSL and Windows. Its global rules file `~/.gemini/config/AGENTS.md` links to `~/.claude/CLAUDE.md`. Skills reach it through `~/.gemini/config/skills/`, which `npx skills` fills with per-skill links because `antigravity-cli` is in the lock's `lastSelectedAgents`. T3 runs agy with its own `GEMINI_HOME` and links in only that skills folder and `~/.gemini/antigravity-cli/skills`, so `skills.json` and `rules.json` manifests never reach T3. It does not link `AGENTS.md`, so each machine has an untracked symlink from `~/.t3/userdata/providers/antigravity/<id>/config/AGENTS.md` to `~/.claude/CLAUDE.md`. If T3 recreates that profile, add the link again. On Windows, make it with `pwsh`, because Windows PowerShell 5.1 needs admin for symlinks even in Developer Mode. Skills with `disable-model-invocation: true` stay hidden from the model, as in Claude Code. Antigravity has only preset color schemes and no custom themes. Its default, `terminal`, takes the terminal's T3 Clawd colors, so `~/.gemini/antigravity-cli/settings.json` stays untracked. agy replaces that file on every save, which breaks a symlink.

## Computer use

WSL and Windows drive the Windows desktop with the `agent-desktop` CLI. The Windows binary lives in `C:\Users\arnab\.local\bin\agent-desktop\`, which the PowerShell profile puts on PATH and WSL links from `~/.local/bin/agent-desktop`. Neither is tracked. To update it, extract the `x86_64-pc-windows-msvc` archive from the GitHub releases of `vercel-labs/agent-desktop` into that folder. Fedora uses the `computer-use-linux` MCP server, because agent-desktop has no mouse input on Wayland.

## CLIProxyAPI

Fedora and Windows (MSI) each run their own CLIProxyAPI, which pools Claude subscription accounts behind one API key. Each has its own accounts in `~/.cli-proxy-api`. Never copy them between machines, because both proxies would then refresh the same OAuth tokens. The MSI proxy used to run inside WSL. Its accounts moved to Windows on 2026-11-15, WSL's `cliproxyapi.service` is disabled, and the old WSL auth dir was renamed to `~/.cli-proxy-api.moved-to-windows`. Never re-enable the WSL service or restore that folder.

- Fedora: a `systemctl --user` service, `cliproxyapi.service`, deployed by chezmoi. The binary lives in `~/cliproxyapi/<version>/`, linked from `~/.local/bin/cli-proxy-api`, untracked. To upgrade, extract the `linux_amd64` release archive into a new version folder, repoint the link, and restart the service.
- Windows: a logon scheduled task, `CLIProxyAPI`, registered by `cliproxyapi/install-windows-task.ps1`. It runs `conhost --headless` so no window shows. The binary lives in `C:\Users\arnab\cliproxyapi\<version>\`, reached through the junction `cliproxyapi\current`, untracked. Stopping the task does not stop the proxy, so restart by re-running `install-windows-task.ps1`, which kills the process and starts the task. Windows runs Arnab's fork, `zytact/clepsydra-proxy`, which serves his panel fork `zytact/clepsydra` at `management.html`. Its binary keeps the upstream name. To upgrade, extract the `windows_amd64` archive from the `zytact/clepsydra-proxy` releases into a new version folder, repoint the junction (`New-Item -ItemType Junction`), and re-run the script. Logs are in `~\.cli-proxy-api\logs\main.log`.
- Config: edit `cliproxyapi/config.yaml.template`, then render it on each machine: `cliproxyapi/cliproxyapi-render-config` on Fedora, `cliproxyapi/cliproxyapi-render-config.ps1` on Windows. Both fill in `CLIPROXY_API_KEY` and `CLIPROXY_MANAGEMENT_KEY` from `~/.secrets` (on Windows, `C:\Users\arnab\.secrets`) and write `~/cliproxyapi/config.yaml`, which the proxy hot-reloads. Changes to `server.host` or `server.port` need a restart. The template uses the v8 layout. Check `config.example.yaml` in `router-for-me/CLIProxyAPI` before adding keys.
- Network: the proxy binds `127.0.0.1:8317`. On Windows, clients use `http://127.0.0.1:8317`. WSL uses NAT networking, so it cannot reach that address. Windows runs `tailscale serve --bg --tcp=8317 tcp://127.0.0.1:8317`, so WSL uses `http://100.92.119.26:8317`. On Fedora, `tailscale serve --tcp=8317` also exposes it at `100.127.35.14:8317`. Use the Tailscale IP, because MagicDNS is unreliable. The management page is `http://100.127.35.14:8317/management.html` (on Windows, `http://127.0.0.1:8317/management.html`).
- Accounts: the user adds each one with `cli-proxy-api --config ~/cliproxyapi/config.yaml --claude-login` on the machine whose proxy should use it. On Windows, that is `~\cliproxyapi\current\cli-proxy-api.exe`. There is no Codex account.
- Clients: Fedora's shell sets `ANTHROPIC_BASE_URL` and `ANTHROPIC_AUTH_TOKEN` in `env.sh`. T3 ignores the shell env, so the proxy is set per provider instance in T3's UI: on Fedora it is the default Claude instance, on MSI it is a separate "Claude (proxy)" instance pointed at `http://127.0.0.1:8317`. The user enters the token in the UI as a sensitive value. Never write it into T3's `settings.json`.

## Agent session backups

`backup-agent-sessions` uploads raw Claude Code, Codex and OpenCode sessions to a restic repo in the R2 bucket `agent-sessions`. A daily T3 scheduled task runs it on each machine: WSL (restic host `MSI`) and Windows (host `MSI-windows`, set by the script because both report the hostname `MSI`) at 22:00, Fedora (host `fedora`) at 03:00. On Linux, restic is the static binary from its GitHub releases in `~/.local/bin`, untracked. On Windows it comes from winget, and the script runs in Git Bash. Credentials are in `~/.secrets`, and restic needs the R2 keys as `AWS_*`. To read the repo:

```bash
. ~/.secrets; export AWS_ACCESS_KEY_ID=$R2_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$R2_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=auto
restic snapshots
restic restore latest --host fedora --target <dir>
```

The repo keeps every snapshot forever. Never run `restic forget` or `restic prune`.

## New machine

`chezmoi init --source ~/dotfiles --apply <repo-url>` (after `git clone <repo-url> ~/dotfiles` if preferred). Then set `sourceDir = "~/dotfiles"` in `~/.config/chezmoi/chezmoi.toml`, which is untracked, and create `~/.secrets` by hand.

## Windows

- chezmoi, starship, fastfetch, restic, Poppler and the CLI tools come from winget. tectonic is the release zip in `~\.local\bin\tectonic`. Symlinks need Developer Mode, which is on.
- `run_onchange_after_windows-env.ps1` sets user environment variables, which T3 and its scheduled runs see too. `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME` and `XDG_CACHE_HOME` give the Linux layout under `~`, and PATH gains the opencode, agent-desktop, tectonic and is-dl folders. is-dl, nvim, lazygit and gh follow XDG, so gh reads `~\.config\gh`. Running processes keep their old environment, so restart T3 and terminals after changing it.
- is-dl is installed by hand from its release `is-dl.tgz`: `npm install --prefix ~\.local\share\is-dl\versions\<version>`, `playwright install chromium` from there, and a junction `current` to that folder. Its `install.sh` needs symlinks and a bash launcher. job-apply runs on Windows; its state and is-dl data moved from WSL on 2026-11-15.
- Line endings: Git for Windows sets `core.autocrlf=true` system-wide, which checks out CRLF and breaks bash scripts. The tracked `.gitconfig` turns it off for every clone, and `.gitattributes` forces LF in this repo.
- The PowerShell 7 profile is `home/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`. It loads every `export NAME=value` line of `~\.secrets` (a copy of the WSL one) into `$env:`, starts starship, then fastfetch.
- Bash is Git Bash, which reads the deployed `.bashrc` and so `env.sh` and `~/.secrets`. `C:\Program Files\Git\bin` heads the Machine PATH, set by hand and not tracked, so plain `bash` in PowerShell is Git Bash rather than WSL's launcher in `System32`. Agent shells run `pwsh -NoProfile`, so the profile cannot do this. Without it, every bare `bash` boots WSL.
- opencode v2 comes from `curl -fsSL https://opencode.ai/v2/install | bash -s -- --no-modify-path`, run in Git Bash. It installs to `~\.opencode\bin`, which `env.sh` and the env script put on PATH.
- T3 themes: `t3code/` holds the tracked copies. Arnab installs them himself through T3's theme picker. Never run `t3 theme set`: a theme it publishes has no remove button in the picker and can only be removed with `t3 theme clear` plus deleting `~/.t3/userdata/themes/<id>.json`. Write colors as `rgba(0,0,0,.7)`, because T3 drops rules that use `rgb(0 0 0/.7)`.

## Windows Terminal

`run_onchange_after_windows-terminal.ps1` (on Windows) and `.sh` (on WSL) copy `.chezmoitemplates/windows-terminal-settings.json` into Windows Terminal's settings folder. Edit the template, never the live copy, which Windows Terminal reformats. `chezmoi apply --include=scripts` runs only the script.

## Windows-side wezterm (WSL)

`C:\Users\arnab\.wezterm.lua` does `dofile` on `\\wsl.localhost\Ubuntu\home\arnab\dotfiles\home\dot_config\wezterm\wezterm.lua`. The config sets the WSL domain and font size when running on Windows.
