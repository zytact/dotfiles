# Windows twin of cliproxyapi-render-config.
# Renders ~\cliproxyapi\config.yaml from the dotfiles template and the secrets in ~\.secrets
# (same `export NAME=value` lines as the Linux ~/.secrets).
# Usage: cliproxyapi-render-config.ps1 [output-path]
param([string]$Target = "$HOME\cliproxyapi\config.yaml")
$ErrorActionPreference = 'Stop'

$secrets = @{}
$secretsFile = "$HOME\.secrets"
if (Test-Path $secretsFile) {
    foreach ($line in Get-Content $secretsFile) {
        if ($line -match '^\s*(?:export\s+)?(CLIPROXY_[A-Z_]+)=(.*)$') {
            $secrets[$Matches[1]] = $Matches[2].Trim().Trim('"').Trim("'")
        }
    }
}

$template = Join-Path $PSScriptRoot 'config.yaml.template'
$out = Get-Content -Raw $template
foreach ($name in 'CLIPROXY_API_KEY', 'CLIPROXY_MANAGEMENT_KEY') {
    $value = $secrets[$name] ?? [Environment]::GetEnvironmentVariable($name)
    if (-not $value) { throw "set $name in ~\.secrets" }
    $out = $out.Replace("__${name}__", $value)
}
if ($out.Contains('__CLIPROXY_')) { throw 'unreplaced placeholder left in template' }

New-Item -ItemType Directory -Force (Split-Path $Target) | Out-Null
[IO.File]::WriteAllText($Target, $out)
# Owner-only, the Windows equivalent of 0600.
icacls $Target /inheritance:r /grant:r "${env:USERNAME}:F" | Out-Null
"wrote $Target"
