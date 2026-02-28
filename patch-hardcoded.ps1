# OpenClaw Hardcoded Text Patch Script
# Patches hardcoded English text in the main JS file

$ErrorActionPreference = "Stop"

$OpenClawPath = "$env:APPDATA\npm\node_modules\openclaw\dist\control-ui\assets"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  OpenClaw Hardcoded Text Patch" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Find main JS file
$mainJs = Get-ChildItem "$OpenClawPath\index-*.js" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '\.map$' } | Select-Object -First 1

if (-not $mainJs) {
    Write-Host "[ERROR] Main JS file not found" -ForegroundColor Red
    exit 1
}

Write-Host "[INFO] Found: $($mainJs.Name)" -ForegroundColor Green

# Backup
$backupFile = "$($mainJs.FullName).bak"
if (-not (Test-Path $backupFile)) {
    Copy-Item $mainJs.FullName $backupFile -Force
    Write-Host "[BACKUP] Created backup" -ForegroundColor Blue
}

# Read content
$content = Get-Content $mainJs.FullName -Raw -Encoding UTF8

# Replace hardcoded strings
$replacements = @{
    "Message (`u{21A9} to send, Shift+`u{21A9} for line breaks, paste images)" = "消息 (`u{21A9} 发送, Shift+`u{21A9}换, 可粘贴图片)"
    "Add a message or paste more images..." = "添加消息或粘贴更多图片..."
    "Connect to the gateway to start chatting" = "连接网关以开始聊天"
    "Message" = "消息"
}

$changed = $false
foreach ($key in $replacements.Keys) {
    if ($content.Contains($key)) {
        $content = $content.Replace($key, $replacements[$key])
        Write-Host "[PATCH] $key -> $($replacements[$key])" -ForegroundColor Yellow
        $changed = $true
    }
}

if ($changed) {
    # Write back
    [System.IO.File]::WriteAllText($mainJs.FullName, $content, [System.Text.Encoding]::UTF8)
    Write-Host ""
    Write-Host "[SUCCESS] Hardcoded text patched!" -ForegroundColor Green
} else {
    Write-Host "[INFO] No changes needed or already patched" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Please refresh the Dashboard page." -ForegroundColor Cyan
Write-Host ""
