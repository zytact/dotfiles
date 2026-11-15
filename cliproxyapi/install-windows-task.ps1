# Registers the CLIProxyAPI logon task, the Windows stand-in for cliproxyapi.service.
# Runs ~\cliproxyapi\current\cli-proxy-api.exe (a junction to the version folder) in a
# headless console, restarts it on failure, and (re)starts it now. Safe to re-run, and
# re-running it is also how to restart the proxy.
$ErrorActionPreference = 'Stop'
$exe = "$HOME\cliproxyapi\current\cli-proxy-api.exe"
$config = "$HOME\cliproxyapi\config.yaml"
if (-not (Test-Path $exe)) { throw "missing $exe" }
if (-not (Test-Path $config)) { throw "missing $config, run cliproxyapi-render-config.ps1 first" }

$action = New-ScheduledTaskAction -Execute 'conhost.exe' `
    -Argument "--headless `"$exe`" --config `"$config`"" -WorkingDirectory "$HOME\cliproxyapi"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit ([TimeSpan]::Zero) -RestartCount 999 -RestartInterval (New-TimeSpan -Minutes 1) `
    -MultipleInstances IgnoreNew -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName 'CLIProxyAPI' -Action $action -Trigger $trigger -Settings $settings `
    -Principal $principal -Description 'CLIProxyAPI on 127.0.0.1:8317 (dotfiles/cliproxyapi)' -Force | Out-Null
# Stopping the task only ends conhost, so the proxy itself has to be stopped too.
Stop-ScheduledTask -TaskName 'CLIProxyAPI' -ErrorAction SilentlyContinue
Get-Process cli-proxy-api -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep 1
Start-ScheduledTask -TaskName 'CLIProxyAPI'
'registered and started task CLIProxyAPI'
