# Dotfiles

My dotfiles. I use [GNU Stow](https://www.gnu.org/software/stow/) to manage them.

Run `stow <package>` from this directory to install a package.

For CLIProxyAPI, `stow cliproxyapi` links `config.yaml.template` and
`cliproxyapi-render-config` into `~/cliproxyapi/`. On a new machine, export
`CLIPROXY_API_KEY` and `CLIPROXY_MANAGEMENT_KEY` in plaintext (e.g. from
`~/.secrets`, which stays outside Git — the proxy hashes the management key on
startup) and run `~/cliproxyapi/cliproxyapi-render-config` to write the live
`config.yaml`. The live config and auth files stay outside Git. The proxy
hot-reloads config changes, so no restart is needed after re-rendering.
