# AGENTS

- Repo purpose: dotfiles managed with GNU Stow; each top-level package directory is a stow target.
- Install all packages with `./setup.sh` (runs `stow` for the known packages listed there).
- Install a single package from repo root with `stow <package>`; keep edits inside that package directory so symlinks map correctly.
- No build/test/lint workflows are defined in this repo; avoid guessing commands.

## Adding a new tool config to dotfiles

To bring a tool's config directory (e.g. `~/.foo`) under version control via Stow:

1. Create the package directory: `mkdir /home/arnab/dotfiles/<tool>`
2. Move the config into it (depends on the tool config path): `mv ~/.<tool> /home/arnab/dotfiles/<tool>/.<tool>`
3. Stow it from the repo root: `cd /home/arnab/dotfiles && stow <tool>`
   - This creates `~/.<tool>` → `dotfiles/<tool>/.<tool>`
4. Add a `.gitignore` inside `dotfiles/<tool>/.<tool>/` to exclude ephemeral or sensitive files (credentials, caches, session state, logs, etc.).
5. Add `stow <tool>` to `setup.sh`.

**Verification**
- `ls -la ~ | grep <tool>` should show `~/.<tool>` as a symlink into dotfiles.
- The config should still be readable at its original path (e.g. `cat ~/.<tool>/settings.json`).
- `git status` inside dotfiles should show only tracked files (no ephemeral noise).
