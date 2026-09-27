param(
    [Parameter(Mandatory = $true)]
    [string]$PayloadDirectory,
    [string]$Version = "1.0.0",
    [string]$NsisPath = "C:\Program Files (x86)\NSIS\makensis.exe"
)

$ErrorActionPreference = "Stop"
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\.."))
$payloadSource = [System.IO.Path]::GetFullPath($PayloadDirectory)
$releaseDir = Join-Path $repoRoot "release\v$Version"
$portableRoot = Join-Path $releaseDir "portable"
$portableDir = Join-Path $portableRoot "OneBoardLocalFileSort"
$zipPath = Join-Path $releaseDir "OneBoardLocalFileSort-$Version-win-x64.zip"
$setupPath = Join-Path $releaseDir "OneBoardLocalFileSort-Setup-$Version-win-x64.exe"
$launcher = Join-Path $portableDir "OneBoardLocalFileSort.exe"
$expectedReleaseRoot = [System.IO.Path]::GetFullPath((Join-Path $repoRoot "release")) + [System.IO.Path]::DirectorySeparatorChar

if (-not ([System.IO.Path]::GetFullPath($portableRoot) + [System.IO.Path]::DirectorySeparatorChar).StartsWith(
        $expectedReleaseRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to stage outside the repository release directory: $portableRoot"
}

if (-not (Test-Path -LiteralPath $payloadSource -PathType Container)) {
    throw "Payload directory not found: $payloadSource"
}
if (-not (Test-Path -LiteralPath (Join-Path $payloadSource "OneBoardLocalFileSort.exe") -PathType Leaf)) {
    throw "The payload does not contain OneBoardLocalFileSort.exe: $payloadSource"
}
if (-not (Test-Path -LiteralPath $NsisPath -PathType Leaf)) {
    throw "NSIS compiler not found: $NsisPath"
}

New-Item -ItemType Directory -Path $releaseDir -Force | Out-Null
if (Test-Path -LiteralPath $portableRoot) {
    Remove-Item -LiteralPath $portableRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $portableDir -Force | Out-Null
Copy-Item -Path (Join-Path $payloadSource "*") -Destination $portableDir -Recurse -Force

# Test-only helpers are emitted beside the app when the release gate is built
# with -BuildTests.  They are not part of the standalone user payload.  The
# optional OneDrive connector is also omitted from the local-only v1.0.0
# package; ordinary synced/mounted folders remain accessible through the local
# filesystem provider.
foreach ($developmentArtifact in @(
    "aifs_storage_plugin_stub.exe",
    "aifs_onedrive_storage_plugin.exe"
)) {
    $artifactPath = Join-Path $portableDir $developmentArtifact
    if (Test-Path -LiteralPath $artifactPath -PathType Leaf) {
        Remove-Item -LiteralPath $artifactPath -Force
    }
}

Copy-Item -LiteralPath (Join-Path $repoRoot "LICENSE") -Destination $portableDir -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "NOTICE.md") -Destination $portableDir -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "UPSTREAM.md") -Destination $portableDir -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "THIRD_PARTY_NOTICES.md") -Destination $portableDir -Force
Copy-Item -LiteralPath (Join-Path $repoRoot "README.md") -Destination (Join-Path $portableDir "README.txt") -Force

$vcpkgShare = Join-Path $repoRoot "app\build-windows-vcpkg_installed\x64-windows\share"
if (Test-Path -LiteralPath $vcpkgShare -PathType Container) {
    $licenseDir = Join-Path $portableDir "licenses"
    New-Item -ItemType Directory -Path $licenseDir -Force | Out-Null
    Get-ChildItem -LiteralPath $vcpkgShare -Directory | ForEach-Object {
        $copyright = Join-Path $_.FullName "copyright"
        if (Test-Path -LiteralPath $copyright -PathType Leaf) {
            Copy-Item -LiteralPath $copyright -Destination (Join-Path $licenseDir ($_.Name + ".txt")) -Force
        }
    }
}

$forbidden = Get-ChildItem -LiteralPath $portableDir -Recurse -File | Where-Object {
    $_.Extension -in @(".gguf", ".db", ".sqlite", ".log") -or
    $_.Name -match "(?i)(api[-_]?key|token|secret|\.env$)"
}
if ($forbidden) {
    throw "Forbidden user/model/cache material found in release payload: $($forbidden.FullName -join ', ')"
}

if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }
Compress-Archive -LiteralPath $portableDir -DestinationPath $zipPath -CompressionLevel Optimal

if (Test-Path -LiteralPath $setupPath) { Remove-Item -LiteralPath $setupPath -Force }
$nsi = Join-Path $PSScriptRoot "OneBoardLocalFileSort.nsi"
& $NsisPath "/INPUTCHARSET" "UTF8" "/DPAYLOAD_DIR=$portableDir" "/DOUTPUT_FILE=$setupPath" "/DPRODUCT_ICON=$(Join-Path $repoRoot 'branding\OneBoardLocalFileSort.ico')" $nsi
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $setupPath)) {
    throw "NSIS installer build failed."
}

$checksums = @(
    ("{0}  {1}" -f (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToLowerInvariant(), (Split-Path $zipPath -Leaf))
    ("{0}  {1}" -f (Get-FileHash -LiteralPath $setupPath -Algorithm SHA256).Hash.ToLowerInvariant(), (Split-Path $setupPath -Leaf))
    ("{0}  {1}" -f (Get-FileHash -LiteralPath $launcher -Algorithm SHA256).Hash.ToLowerInvariant(), "OneBoardLocalFileSort.exe")
)
Set-Content -LiteralPath (Join-Path $releaseDir "SHA256SUMS.txt") -Value $checksums -Encoding ascii

Get-Item -LiteralPath $zipPath, $setupPath, (Join-Path $releaseDir "SHA256SUMS.txt") |
    Select-Object FullName, Length
