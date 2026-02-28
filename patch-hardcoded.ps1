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
    # Skills page translations
    "Bundled, managed, and workspace skills." = "捆绑、管理和工作区技能。"
    "Filter" = "筛选"
    "Search skills" = "搜索技能"
    "Built-in Skills" = "内置技能"
    "Extra Skills" = "额外技能"
    "feishu-doc" = "飞书文档"
    "Feishu document read/write operations. Activate when user mentions Feishu docs, cloud docs, or docx links." = "飞书文档读写操作。当用户提及飞书文档、云文档或 docx 链接时激活。"
    "feishu-drive" = "飞书网盘"
    "Feishu cloud storage file management. Activate when user mentions cloud space, folders, drive." = "飞书云存储文件管理。当用户提及云空间、文件夹、网盘时激活。"
    "feishu-perm" = "飞书权限"
    "Feishu permission management for documents and files. Activate when user mentions sharing, permissions, collaborators." = "飞书文档和文件权限管理。当用户提及共享、权限、协作者时激活。"
    "feishu-wiki" = "飞书知识库"
    "Feishu knowledge base navigation. Activate when user mentions knowledge base, wiki, or wiki links." = "飞书知识库导航。当用户提及知识库、wiki 或 wiki 链接时激活。"
    "eligible" = "符合条件"
    "Disable" = "禁用"
    "Enable" = "启用"
    "Activated" = "已激活"
    "Deactivated" = "已停用"
    # Nodes page translations
    "Exec approvals" = "执行审批"
    "Allowlist and approval policy for exec host=gateway/node." = "exec host=gateway/node 的允许列表和审批策略。"
    "Target" = "目标"
    "Gateway edits local approvals; node edits the selected node." = "网关编辑本地审批；节点编辑选定的节点。"
    "Host" = "主机"
    "Scope" = "范围"
    "Defaults" = "默认值"
    "Security" = "安全"
    "Default security mode." = "默认安全模式。"
    "Deny" = "拒绝"
    "Ask" = "询问"
    "Default prompt policy." = "默认提示策略。"
    "On miss" = "未命中时"
    "Ask fallback" = "询问回退"
    "Applied when the UI prompt is unavailable." = "当 UI 提示不可用时应用。"
    "Fallback" = "回退"
    "Auto-allow skill CLIs" = "自动允许技能 CLI"
    "Allow skill executables listed by the Gateway." = "允许网关列出的技能可执行文件。"
    "Exec node binding" = "执行节点绑定"
    "Pin agents to a specific node when using exec host=node." = "使用 exec host=node 时将代理固定到特定节点。"
    "Default binding" = "默认绑定"
    "Used when agents do not override a node binding." = "当代理不覆盖节点绑定时使用。"
    "Any node" = "任意节点"
    "No nodes with system.run available." = "没有可用 system.run 的节点。"
    "default agent · uses default (any)" = "默认代理 · 使用默认值（任意）"
    "Binding" = "绑定"
    "Use default" = "使用默认值"
    "Devices" = "设备"
    "Pairing requests + role tokens." = "配对请求 + 角色令牌。"
    "Paired" = "已配对"
    "roles" = "角色"
    "scopes" = "范围"
    "Tokens" = "令牌"
    "operator" = "操作员"
    "active" = "活动"
    "Rotate" = "轮换"
    "Revoke" = "撤销"
    "Nodes" = "节点"
    "Paired devices and live links." = "配对设备和实时链接。"
    "No nodes found." = "未找到节点。"
    # Logs page translations
    "Logs" = "日志"
    "Gateway file logs (JSONL)." = "网关文件日志 (JSONL)。"
    "Export visible" = "导出可见"
    "Search logs" = "搜索日志"
    "Auto-follow" = "自动跟随"
    # Config page translations
    "Settings" = "设置"
    "Search settings..." = "搜索设置..."
    "Tag filters:" = "标签筛选："
    "Add tags" = "添加标签"
    "All Settings" = "所有设置"
    "Environment" = "环境"
    "Updates" = "更新"
    "Agents" = "代理"
    "Channels" = "频道"
    "消息s" = "消息"
    "Commands" = "命令"
    "Hooks" = "钩子"
    "Tools" = "工具"
    "Setup Wizard" = "设置向导"
    "Meta" = "元数据"
    "Diagnostics" = "诊断"
    "Logging" = "日志"
    "Browser" = "浏览器"
    "Ui" = "界面"
    "Secrets" = "密钥"
    "Models" = "模型"
    "NodeHost" = "节点主机"
    "Bindings" = "绑定"
    "Broadcast" = "广播"
    "Audio" = "音频"
    "Media" = "媒体"
    "Approvals" = "审批"
    "Web" = "网页"
    "Discovery" = "发现"
    "CanvasHost" = "画布主机"
    "Talk" = "对话"
    "Memory" = "记忆"
    "Plugins" = "插件"
    "Form" = "表单"
    "Raw" = "原始"
    "No changes" = "无更改"
    "Reload" = "重新加载"
    "Apply" = "应用"
    "Update" = "更新"
    "API keys and authentication profiles" = "API 密钥和认证配置文件"
    "Auth Cooldowns" = "认证冷却"
    "Auth Profile Order" = "认证配置顺序"
    "Auth Profiles" = "认证配置"
    "Cooldown/backoff controls for temporary profile suppression after billing-related failures and retry windows. Use these to prevent rapid re-selection of profiles that are still blocked." = "临时配置文件抑制的冷却/退避控制，用于计费相关失败后和重试窗口。使用这些可以防止快速重新选择仍被阻止的配置。"
    "Billing Backoff (hours)" = "计费退避（小时）"
    "Base backoff (hours) when a profile fails due to billing/insufficient credits (default: 5)." = "配置文件因计费/积分不足失败时的基础退避时间（小时）（默认值：5）。"
    "Billing Backoff Overrides" = "计费退避覆盖"
    "Billing Backoff Cap (hours)" = "计费退避上限（小时）"
    "Cap (hours) for billing backoff (default: 24)." = "计费退避上限（小时）（默认值：24）。"
    "Failover Window (hours)" = "故障转移窗口（小时）"
    "Failure window (hours) for backoff counters (default: 24)." = "退避计数器的故障窗口（小时）（默认值：24）。"
    "Form view can't safely edit some fields. Use Raw to avoid losing config entries." = "表单视图无法安全编辑某些字段。使用原始视图以避免丢失配置条目。"
    # Sessions page translations
    "Sessions" = "会话"
    "Active session keys and per-session overrides." = "活动会话密钥和每个会话的覆盖设置。"
    "Active within (minutes)" = "活跃时间（分钟）"
    "Include global" = "包含全局"
    "Include unknown" = "包含未知"
    "Store: (multiple)" = "存储：（多个）"
    "Key" = "密钥"
    "Label" = "标签"
    "Kind" = "类型"
    "Updated" = "更新时间"
    "Thinking" = "思考"
    "Verbose" = "详细"
    "Reasoning" = "推理"
    "Actions" = "操作"
    "direct" = "直接"
    "inherit" = "继承"
    # Instances page translations
    "Connected Instances" = "已连接实例"
    "Presence beacons from the gateway and clients." = "来自网关和客户端的在线信标。"
    "just now" = "刚刚"
    "Last input" = "最后输入"
    "Reason" = "原因"
    "self" = "自身"
    "disconnect" = "断开连接"
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
