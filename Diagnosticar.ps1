$ErrorActionPreference='Stop'
Set-Location -LiteralPath $PSScriptRoot
$dir=Join-Path $PSScriptRoot ('diagnosticos\'+(Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $dir -Force | Out-Null
Write-Host 'Jogue ate observar a engasgada e feche o jogo normalmente.'
Write-Host "Os registros ficarao em: $dir"
try {
 $cpu=Get-CimInstance Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed
 $gpu=Get-CimInstance Win32_VideoController | Select-Object Name,DriverVersion,VideoModeDescription
 $os=Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,OSArchitecture,TotalVisibleMemorySize,FreePhysicalMemory
 Add-Type -AssemblyName System.Windows.Forms
 $power=[Windows.Forms.SystemInformation]::PowerStatus
 [pscustomobject]@{CPU=$cpu;GPU=$gpu;OS=$os;PowerLine=$power.PowerLineStatus.ToString();BatteryPercent=$power.BatteryLifePercent*100;ExecutableSHA256=(Get-FileHash '.\EvilZone_Recompiled.exe').Hash} | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $dir 'computador.json') -Encoding UTF8
 & powercfg /getactivescheme | Set-Content (Join-Path $dir 'energia.txt')
} catch { $_.Exception.Message | Set-Content (Join-Path $dir 'coleta-parcial.txt') }
$env:PSX_OVERLAY_AUTOCOMPILE_OFF='1'
$env:PSX_RUNTIME_PERF_DIAG='1'
$env:PSX_RUNTIME_PERF_DIAG_MS='1000'
$env:PSX_FRAME_REPORT_MS='1000'
Remove-Item Env:PSX_LOAD_SLOT -ErrorAction SilentlyContinue
$proc=Start-Process -FilePath (Join-Path $PSScriptRoot 'EvilZone_Recompiled.exe') -ArgumentList '--game "game.toml" --disc "disc\Evil Zone.cue" --memcard-dir "saves"' -WorkingDirectory $PSScriptRoot -WindowStyle Normal -RedirectStandardOutput (Join-Path $dir 'jogo.txt') -RedirectStandardError (Join-Path $dir 'erros.txt') -PassThru
$proc.WaitForExit()
"ExitCode=$($proc.ExitCode)" | Set-Content (Join-Path $dir 'saida.txt')
$proc.Dispose()
Write-Host "Pronto. Registros salvos em $dir"
Write-Host 'Os logs podem conter caminhos locais; nada foi enviado pela internet.'
Read-Host 'Pressione Enter para fechar'
