$ErrorActionPreference = "Stop"

$repo = "henristr/sumcheck"
$bin  = "sumcheck"

$arch = if ([Environment]::Is64BitOperatingSystem) {
    if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "amd64" }
} else {
    Write-Error "32-bit wird nicht unterstützt"
    exit 1
}

$release = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest"
$asset = $release.assets | Where-Object { $_.name -like "*windows_$arch.zip" }

if (-not $asset) {
    Write-Error "Kein passendes Release-Asset gefunden"
    exit 1
}

$tmpZip = "$env:TEMP\$bin.zip"
Invoke-WebRequest $asset.browser_download_url -OutFile $tmpZip

$installDir = "$env:LOCALAPPDATA\Programs\$bin"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Expand-Archive -Path $tmpZip -DestinationPath $installDir -Force
Remove-Item $tmpZip

# Optional: zum PATH hinzufügen
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$installDir", "User")
    Write-Host "PATH aktualisiert. Bitte Terminal neu starten."
}

Write-Host "$bin installiert nach $installDir"
