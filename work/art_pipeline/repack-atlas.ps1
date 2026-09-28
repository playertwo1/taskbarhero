param(
  [Parameter(Mandatory)][string]$InputImage,
  [Parameter(Mandatory)][int]$FrameSize,
  [Parameter(Mandatory)][string]$Palette,
  [Parameter(Mandatory)][string]$OutputImage,
  [Parameter(Mandatory)][string]$TempName
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path '.').Path
$temp = Join-Path $root "work\art_pipeline\$TempName"
New-Item -ItemType Directory -Force -Path $temp | Out-Null
$paletteFile = Join-Path $temp 'palette.gpl'
$scaled = Join-Path $temp 'scaled.png'
$indexed = Join-Path $temp 'indexed.aseprite'
$indexedAtlas = Join-Path $temp 'indexed.png'
$aseprite = Join-Path $root 'Aseprite\Aseprite.exe'
$ffmpeg = (Get-Command ffmpeg).Source
$colors = $Palette.Split(',')
function Wait-ForFile([string]$Path) {
  for ($attempt=0; $attempt -lt 40; $attempt++) {
    if (Test-Path -LiteralPath $Path) { return $true }
    Start-Sleep -Milliseconds 100
  }
  return $false
}
$paletteLines = @('GIMP Palette', "Name: PH_${TempName}_TY40", 'Columns: 16', '#', '0 0 0 transparent index')
foreach ($hex in $colors) {
  $hex = $hex.Trim()
  if ($hex -notmatch '^#[0-9A-Fa-f]{6}$') { throw "Cor inválida: $hex" }
  $paletteLines += '{0} {1} {2} {3}' -f [Convert]::ToInt32($hex.Substring(1, 2), 16), [Convert]::ToInt32($hex.Substring(3, 2), 16), [Convert]::ToInt32($hex.Substring(5, 2), 16), $hex
}
Set-Content -LiteralPath $paletteFile -Value $paletteLines -Encoding utf8
$atlas = 4 * $FrameSize
$cellFilters = @()
for ($i=0; $i -lt 16; $i++) {
  $column = $i % 4
  $row = [math]::Floor($i / 4)
  $cellFilters += ("[0:v]crop=w=iw/4:h=ih/4:x=floor(iw*$column/4):y=floor(ih*$row/4),scale=${FrameSize}:${FrameSize}:force_original_aspect_ratio=decrease:flags=lanczos,pad=${FrameSize}:${FrameSize}:(ow-iw)/2:(oh-ih)/2:color=0x00000000,format=rgba[c$i]")
}
$rowFilters = @()
for ($row=0; $row -lt 4; $row++) {
  $cells = (0..3 | ForEach-Object { '[c{0}]' -f ($row*4+$_) }) -join ''
  $rowFilters += ('{0}hstack=inputs=4[r{1}]' -f $cells,$row)
}
$rows = (0..3 | ForEach-Object { '[r{0}]' -f $_ }) -join ''
$atlasGraph = ($cellFilters + $rowFilters + @(("${rows}vstack=inputs=4[out]"))) -join ';'
& $ffmpeg -y -i $InputImage -filter_complex $atlasGraph -map '[out]' -frames:v 1 -update 1 $scaled 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Falha ao ajustar atlas 4x4.' }
& $aseprite -b $scaled --palette $paletteFile --color-mode indexed --save-as $indexed 2>$null | Out-Null
if ($LASTEXITCODE -ne 0 -or -not (Wait-ForFile $indexed)) { throw 'Falha ao quantizar usando TY40.' }
& $aseprite -b $indexed --sheet $indexedAtlas 2>$null | Out-Null
if ($LASTEXITCODE -ne 0 -or -not (Wait-ForFile $indexedAtlas)) { throw 'Falha ao exportar atlas.' }
$filters = @()
for ($i=0; $i -lt 16; $i++) {
  $x = ($i % 4) * $FrameSize
  $y = [math]::Floor($i / 4) * $FrameSize
  $filters += ('[0:v]crop={0}:{0}:{1}:{2},format=rgba[c{3}]' -f $FrameSize,$x,$y,$i)
}
$inputs = (0..15 | ForEach-Object { '[c{0}]' -f $_ }) -join ''
$graph = ($filters + @(("${inputs}hstack=inputs=16[out]"))) -join ';'
$target = Join-Path $root $OutputImage
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
& $ffmpeg -y -i $indexedAtlas -filter_complex $graph -map '[out]' -frames:v 1 -update 1 $target 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Falha ao montar tira horizontal.' }
Write-Output $target
