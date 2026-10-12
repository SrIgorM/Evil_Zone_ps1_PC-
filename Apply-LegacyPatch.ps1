param([Parameter(Mandatory=$true)][string]$SourceRoot)
$ErrorActionPreference='Stop'
$source=(Resolve-Path -LiteralPath $SourceRoot).Path
$kit=Split-Path $PSScriptRoot -Parent
$expected=Get-Content (Join-Path $kit 'patches\source-files.json') -Raw | ConvertFrom-Json
foreach($entry in $expected.PSObject.Properties){
 $file=Join-Path $source $entry.Name
 if(-not (Test-Path -LiteralPath $file -PathType Leaf)){throw "Arquivo ausente: $($entry.Name)"}
 if((Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.Value.before_sha256){throw "Base divergente: $($entry.Name). Use uma copia da base correspondente; nada foi aplicado."}
}
$patch=Join-Path $kit 'patches\legacy-v3.patch'
& git -C $source apply --check -- $patch
if($LASTEXITCODE -ne 0){throw 'Verificacao do patch falhou; nada foi aplicado'}
& git -C $source apply -- $patch
if($LASTEXITCODE -ne 0){throw 'Aplicacao falhou; examine a copia de trabalho'}
foreach($entry in $expected.PSObject.Properties){
 if((Get-FileHash -LiteralPath (Join-Path $source $entry.Name)).Hash.ToLowerInvariant() -ne $entry.Value.after_sha256){throw "Hash final divergente: $($entry.Name)"}
}
Write-Host 'Legacy v3 aplicada e hashes finais conferidos.'
