# PowerShell 7 profile for Windows (MSI), deployed by chezmoi. Windows twin of env.sh + .zshrc. Keep tool-specific bits guarded so a missing tool never breaks the shell.

# Secrets: same `export NAME=value` lines as the Linux ~/.secrets.
$secretsFile = "$HOME\.secrets"
if (Test-Path $secretsFile) {
    foreach ($line in Get-Content $secretsFile) {
        if ($line -match '^\s*(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)=(.*)$') {
            Set-Item "env:$($Matches[1])" $Matches[2].Trim().Trim('"').Trim("'")
        }
    }
}
Remove-Variable secretsFile, line -ErrorAction SilentlyContinue

$env:Path = "$HOME\.opencode\bin;$env:Path"
$env:EDITOR = 'nvim'
$env:NVIM_APPNAME = 'lazyvim'
$env:TEACH_HOME = "$HOME\Documents\learning"
$env:TEACH_LEARNER = "$HOME\dotfiles\teach\LEARNER.md"
$env:ENABLE_CLAUDEAI_MCP_SERVERS = 'false'

# Everything below is interactive only.
if (-not [Environment]::UserInteractive -or [Environment]::GetCommandLineArgs() -contains '-NonInteractive') { return }

if (Get-Command starship -ErrorAction SilentlyContinue) {
    $env:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
    Invoke-Expression (&starship init powershell)
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

Set-PSReadLineOption -EditMode Windows -PredictionSource History -PredictionViewStyle InlineView -ErrorAction SilentlyContinue

function cc { claude --dangerously-skip-permissions @args }
function ccr { claude --dangerously-skip-permissions -r @args }
function cx { codex --yolo @args }
if (Get-Command lazygit -ErrorAction SilentlyContinue) { Set-Alias lg lazygit }
if (Get-Command nvim -ErrorAction SilentlyContinue) { Set-Alias vim nvim }

if (Get-Command fastfetch -ErrorAction SilentlyContinue) { fastfetch }
