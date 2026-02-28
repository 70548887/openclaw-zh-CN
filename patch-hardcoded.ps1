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
    "Gateway Dashboard" = "网关仪表板"
    # Cron page translations
    "disconnected (1006): no reason" = "已断开连接 (1006): 无原因"
    "Enabled" = "已启用"
    "Yes" = "是"
    "Jobs" = "任务"
    "Next wake" = "下次唤醒"
    "n/a" = "无"
    "Refresh" = "刷新"
    "All scheduled jobs stored in the gateway." = "网关中存储的所有计划任务。"
    "Search jobs" = "搜索任务"
    "Name, description, or agent" = "名称、描述或代理"
    "All" = "全部"
    "Sort" = "排序"
    "Next run" = "下次运行"
    "Direction" = "方向"
    "Ascending" = "升序"
    "No matching jobs." = "没有匹配的任务。"
    "Run history" = "运行历史"
    "Latest runs across all jobs." = "所有任务的最新运行。"
    "Search runs" = "搜索运行记录"
    "Summary, error, or job" = "摘要、错误或任务"
    "Newest first" = "最新优先"
    "Status" = "状态"
    "All statuses" = "所有状态"
    "Delivery" = "交付"
    "All delivery" = "所有交付方式"
    "No matching runs." = "没有匹配的运行记录。"
    "New Job" = "新建任务"
    "Create a scheduled wakeup or agent run." = "创建计划唤醒或代理运行。"
    "* Required" = "* 必填"
    "Basics" = "基本信息"
    "Name it, choose the assistant, and set enabled state." = "命名、选择助手并设置启用状态。"
    "Name *required" = "名称 *必填"
    "Morning brief" = "早间简报"
    "Description" = "描述"
    "Optional context for this job" = "此任务的可选上下文"
    "Agent ID" = "代理 ID"
    "main or ops" = "main 或 ops"
    "Start typing to pick a known agent, or enter a custom one." = "开始输入以选择已知代理，或输入自定义代理。"
    "Schedule" = "计划"
    "Control when this job runs." = "控制此任务的运行时间。"
    "Every" = "每"
    "Every *required" = "每 *必填"
    "Unit" = "单位"
    "Minutes" = "分钟"
    "Execution" = "执行"
    "Choose when to wake, and what this job should do." = "选择唤醒时间和此任务应执行的操作。"
    "Session" = "会话"
    "Isolated" = "隔离"
    "Main posts a system event. Isolated runs a dedicated agent turn." = "主会话发布系统事件。隔离运行专用代理回合。"
    "Wake mode" = "唤醒模式"
    "Now" = "立即"
    "Now triggers immediately. Next heartbeat waits for the next cycle." = "立即立即触发。下次心跳等待下一个周期。"
    "What should run?" = "应运行什么？"
    "Run assistant task (isolated)" = "运行助手任务（隔离）"
    "Starts an assistant run in its own session using your prompt." = "使用您的提示在自己的会话中启动助手运行。"
    "Timeout (seconds)" = "超时（秒）"
    "Optional, e.g. 90" = "可选，例如 90"
    "Optional. Leave blank to use the gateway default timeout behavior for this run." = "可选。留空以使用网关默认超时行为。"
    "Assistant task prompt *required" = "助手任务提示 *必填"
    "Result delivery" = "结果交付"
    "Announce summary (default)" = "宣布摘要（默认）"
    "Announce posts a summary to chat. None keeps execution internal." = "宣布将摘要发布到聊天。无则保持内部执行。"
    "Channel" = "频道"
    "last" = "上次"
    "Choose which connected channel receives the summary." = "选择哪个连接的频道接收摘要。"
    "To" = "发送至"
    "+1555... or chat id" = "+1555... 或聊天 ID"
    "Optional recipient override (chat id, phone, or user id)." = "可选的收件人覆盖（聊天 ID、电话或用户 ID）。"
    "Advanced" = "高级"
    "Add job" = "添加任务"
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
