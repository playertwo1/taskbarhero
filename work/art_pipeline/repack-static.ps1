param(
  [Parameter(Mandatory)][string]$InputImage,
  [Parameter(Mandatory)][string]$OutputImage,
  [Parameter(Mandatory)][int]$Width,
  [Parameter(Mandatory)][int]$Height,
  [Parameter(Mandatory)][string]$Palette,
  [Parameter(Mandatory)][string]$TempName,
  [string]$Crop = ''
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path '.').Path
$temp = Join-Path $root "work\art_pipeline\$TempName"
New-Item -ItemType Directory -Force -Path $temp | Out-Null
$paletteFile = Join-Path $temp 'palette.gpl'
$scaled = Join-Path $temp 'scaled.png'
$indexed = Join-Path $temp 'indexed.aseprite'
$final = Join-Path $root $OutputImage
$indexedExport = Join-Path $temp 'exported.png'
$aseprite = Join-Path $root 'Aseprite\Aseprite.exe'
$ffmpeg = (Get-Command ffmpeg).Source
$colors = $Palette.Split(',')
$paletteLines = @('GIMP Palette', "Name: PH_${TempName}_TY40", 'Columns: 16', '#', '0 0 0 transparent index')
foreach ($hex in $colors) {
  $hex = $hex.Trim()
  $paletteLines += '{0} {1} {2} {3}' -f [Convert]::ToInt32($hex.Substring(1,2),16),[Convert]::ToInt32($hex.Substring(3,2),16),[Convert]::ToInt32($hex.Substring(5,2),16),$hex
}
Set-Content -LiteralPath $paletteFile -Value $paletteLines -Encoding utf8
$cropFilter = if ($Crop) { "crop=$Crop," } else { '' }
& $ffmpeg -y -i $InputImage -vf "${cropFilter}scale=${Width}:${Height}:flags=lanczos,format=rgba" -frames:v 1 -update 1 $scaled 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Falha ao dimensionar a camada.' }
& $aseprite -b $scaled --palette $paletteFile --color-mode indexed --save-as $indexed 2>$null | Out-Null
for ($i=0; $i -lt 40 -and -not (Test-Path $indexed); $i++) { Start-Sleep -Milliseconds 100 }
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $indexed)) { throw 'Falha ao quantizar a camada.' }
& $aseprite -b $indexed --sheet $indexedExport 2>$null | Out-Null
for ($i=0; $i -lt 40 -and -not (Test-Path $indexedExport); $i++) { Start-Sleep -Milliseconds 100 }
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $indexedExport)) { throw 'Falha ao exportar a camada.' }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $final) | Out-Null
Copy-Item -LiteralPath $indexedExport -Destination $final -Force
Write-Output $final
