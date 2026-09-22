# Dotfiles

My dotfiles. I use [GNU Stow](https://www.gnu.org/software/stow/) to manage them.

Run `stow <package>` from this directory to install a package.

For CLIProxyAPI, `stow cliproxyapi` links a config template into
`~/cliproxyapi/config.dotfiles.example.yaml`. Copy it to `config.yaml` and set a
private API key and management secret when setting up a new machine. The live config and auth files
stay outside Git.
