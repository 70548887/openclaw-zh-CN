# OpenClaw 中文语言包 (Chinese Language Pack)

为 [OpenClaw](https://github.com/anthropics/claude-code) Dashboard 提供完整的简体中文翻译。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 简介

OpenClaw 官方中文语言包翻译不完整，本项目提供扩展的中文翻译，覆盖率从原始的 ~78 个词条扩展到 ~715 个词条，提升 **817%**。

### 翻译覆盖区域

| 区域 | 说明 |
|------|------|
| common | 通用操作、状态词汇 |
| nav | 导航栏 |
| tabs | 标签页 |
| overview | 概览页面 |
| chat | 聊天功能 |
| channels | 频道管理 (WhatsApp, Telegram, Discord 等) |
| sessions | 会话管理 |
| skills | 技能配置 |
| nodes | 节点管理 |
| cron | 定时任务 |
| config | 配置编辑器 |
| debug | 调试工具 |
| logs | 日志查看 |
| agents | 代理管理 |
| usage | 使用统计 |
| tools | 工具名称 |
| errors | 错误消息 |
| actions | 操作按钮 |

## 安装方法

### 方法一：使用补丁脚本 (推荐)

1. 下载本仓库：
```bash
git clone https://github.com/YOUR_USERNAME/openclaw-zh-CN.git
cd openclaw-zh-CN
```

2. 运行补丁脚本：
```powershell
# Windows PowerShell
.\apply-patch.ps1

# 或跳过确认直接安装
.\apply-patch.ps1 -Force
```

3. 刷新 OpenClaw Dashboard 页面

### 方法二：手动安装

1. 找到 OpenClaw 语言包目录：
```
%APPDATA%\npm\node_modules\openclaw\dist\control-ui\assets\
```

2. 备份原始语言包文件 `zh-CN-*.js`

3. 将本项目的 `zh-CN.js` 复制并重命名覆盖原文件

## 使用说明

### 应用补丁
```powershell
.\apply-patch.ps1
```

### 强制应用（跳过确认）
```powershell
.\apply-patch.ps1 -Force
```

### 恢复原始语言包
```powershell
.\apply-patch.ps1 -Restore
```

## 更新说明

每次 OpenClaw 更新后，语言包会被还原为官方版本。只需重新运行补丁脚本即可恢复中文界面：

```powershell
.\apply-patch.ps1 -Force
```

## 兼容性

- **OpenClaw 版本**: 2026.2.26+
- **操作系统**: Windows 10/11
- **安装方式**: npm 全局安装

## 文件说明

| 文件 | 说明 |
|------|------|
| `zh-CN.js` | 完整的中文语言包 |
| `apply-patch.ps1` | PowerShell 补丁脚本 |
| `README.md` | 本说明文件 |
| `LICENSE` | MIT 许可证 |

## 贡献

欢迎提交 Issue 和 Pull Request 来改进翻译质量或添加缺失的翻译。

### 贡献指南

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/improve-translation`)
3. 提交更改 (`git commit -m 'Improve XXX translation'`)
4. 推送到分支 (`git push origin feature/improve-translation`)
5. 创建 Pull Request

## 许可证

本项目采用 [MIT 许可证](LICENSE)。

## 致谢

- [OpenClaw](https://github.com/anthropics/claude-code) - AI 代理网关
- 所有贡献者

---

**注意**: 本项目为社区维护的非官方语言包，与 Anthropic 官方无关。
