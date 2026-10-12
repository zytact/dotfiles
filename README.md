# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io). See `AGENTS.md` for the layout and workflow.

- Edit: `chezmoi edit <file>`, then `chezmoi apply`
- Pull live edits back: `chezmoi add <file>`
- Review: `chezmoi diff`, `chezmoi status`
- Update from remote: `git pull` in this repo, then `chezmoi apply`

Only `home/` is deployed. Per-machine skips are in `home/.chezmoiignore`.

CLIProxyAPI (not managed by chezmoi): `cliproxyapi/` holds `config.yaml.template` and
`cliproxyapi-render-config`. Export `CLIPROXY_API_KEY` and `CLIPROXY_MANAGEMENT_KEY` (e.g.
from `~/.secrets`, kept outside Git), copy both files into `~/cliproxyapi/` and run
`~/cliproxyapi/cliproxyapi-render-config`.
