# OpenClaw Chinese Language Pack Patch Script
# Usage: .\apply-patch.ps1 [-Force] [-Restore]

param(
    [switch]$Restore,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Path configuration
$OpenClawPath = "$env:APPDATA\npm\node_modules\openclaw\dist\control-ui\assets"
$PatchPath = "$env:USERPROFILE\.openclaw\i18n-patch"
$PatchFile = Join-Path $PatchPath "zh-CN.js"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  OpenClaw Language Pack Patch Tool v1.0" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check OpenClaw installation
if (-not (Test-Path $OpenClawPath)) {
    Write-Host "[ERROR] OpenClaw not found:" -ForegroundColor Red
    Write-Host "        $OpenClawPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please install OpenClaw first:" -ForegroundColor White
    Write-Host "  npm install -g openclaw" -ForegroundColor Gray
    exit 1
}

# Find target language pack file
$targetFiles = Get-ChildItem "$OpenClawPath\zh-CN-*.js" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '\.map$' }

if ($targetFiles.Count -eq 0) {
    Write-Host "[ERROR] Chinese language pack not found" -ForegroundColor Red
    Write-Host "        Please check OpenClaw version" -ForegroundColor Yellow
    exit 1
}

$targetFile = $targetFiles | Select-Object -First 1
$backupFile = "$($targetFile.FullName).bak"

Write-Host "[INFO] Found language pack:" -ForegroundColor Green
Write-Host "       $($targetFile.Name)" -ForegroundColor White
Write-Host ""

# Restore mode
if ($Restore) {
    if (Test-Path $backupFile) {
        Copy-Item $backupFile $targetFile.FullName -Force
        Write-Host "[SUCCESS] Original language pack restored!" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Backup file not found" -ForegroundColor Red
    }
    exit 0
}

# Check patch file
if (-not (Test-Path $PatchFile)) {
    Write-Host "[ERROR] Patch file not found:" -ForegroundColor Red
    Write-Host "        $PatchFile" -ForegroundColor Yellow
    exit 1
}

# Confirm operation
if (-not $Force) {
    Write-Host "[CONFIRM] Apply Chinese language pack patch?" -ForegroundColor Yellow
    Write-Host "          Original file will be backed up" -ForegroundColor Gray
    Write-Host ""
    $confirm = Read-Host "Continue? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "[CANCEL] Operation cancelled" -ForegroundColor Yellow
        exit 0
    }
    Write-Host ""
}

# Backup original file
if (-not (Test-Path $backupFile) -or $Force) {
    Copy-Item $targetFile.FullName $backupFile -Force
    Write-Host "[BACKUP] Original file backed up:" -ForegroundColor Blue
    Write-Host "         $backupFile" -ForegroundColor Gray
} else {
    Write-Host "[SKIP] Backup already exists" -ForegroundColor Gray
}

# Apply patch
Copy-Item $PatchFile $targetFile.FullName -Force

Write-Host ""
Write-Host "[SUCCESS] Chinese language pack applied!" -ForegroundColor Green
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Next Steps:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Refresh OpenClaw Dashboard" -ForegroundColor White
Write-Host "  2. Select Chinese in language settings" -ForegroundColor White
Write-Host ""
Write-Host "  To restore original:" -ForegroundColor Gray
Write-Host "    .\apply-patch.ps1 -Restore" -ForegroundColor Gray
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
