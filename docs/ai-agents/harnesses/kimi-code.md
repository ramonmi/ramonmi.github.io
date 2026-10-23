---
title: Kimi Code CLI
description: 安装当前 Kimi Code CLI，完成终端任务并理解旧版 CLI 迁移边界。
---

# Kimi Code CLI

本文介绍当前 Kimi Code CLI，不把已归档的 Python Kimi CLI 当新版。核验日期：2026-10-22；作者未安装或登录。请从 [Kimi Code 官方文档](https://moonshotai.github.io/kimi-code/en/guides/getting-started.html)和[官方仓库](https://github.com/MoonshotAI/kimi-code)核对当前发行。先完成[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

当前 CLI 是 TypeScript/npm 发布、运行在 Node.js 上的终端 TUI Agent；推荐安装脚本不要求预装 Node。历史 Python kimi-cli 已归档，迁移时先备份，不假定会话和授权自动兼容。

## 安装前检查

官方安装脚本不要求预装 Node.js；Windows 原生步骤用 PowerShell 7，且需先安装 Git for Windows。npm 备选路线需要 Node.js 22.19.0 或更新版本。检查旧 `kimi` 命令来源，避免误用旧 Python CLI。

## 安装与验证

### 官方安装器

推荐使用官方安装脚本，无需预先安装 Node.js：

=== "Windows：PowerShell 7"
    ```powershell
    irm https://code.kimi.com/kimi-code/install.ps1 | iex
    kimi --version
    Get-Command kimi
    ```

=== "WSL / macOS / Linux：Bash"
    ```bash
    curl -fsSL https://code.kimi.com/kimi-code/install.sh | bash
    kimi --version
    command -v kimi
    ```

安装脚本下载当前 release、校验 checksum 并将 `kimi` 放入 PATH。

### npm 安装

与 Claude Code 一样，npm 是可选安装方式。先准备 Node.js 22.19.0 或更新版与 npm；Windows 可按[环境准备页](../getting-started/windows.md)使用 nvm-windows 管理 Node.js。以下命令可在 Git Bash、PowerShell 7 或对应平台的终端中运行：

```bash
node --version
npm --version
npm install -g @moonshot-ai/kimi-code
kimi --version
kimi --help
```

安装后重新打开终端：Git Bash/WSL/macOS/Linux 用 `command -v kimi`，PowerShell 7 用 `Get-Command kimi` 检查命令来源。npm 路线可用 `npm install -g @moonshot-ai/kimi-code@latest` 更新，用 `npm uninstall -g @moonshot-ai/kimi-code` 卸载。

两种安装方式都需要为 Windows 准备 Git for Windows；自定义路径时设置 `KIMI_SHELL_PATH` 指向 `bash.exe` 的绝对路径。不要把 Claude Code 的 `CLAUDE_CODE_GIT_BASH_PATH` 变量用于 Kimi。切换 Node.js 版本后重新检查命令来源，避免同时调用旧版 Python CLI 或另一安装渠道的 `kimi`。

## 登录与模型接入

首次启动后在 TUI 输入 `/login`，选择 Kimi Code OAuth 设备码登录，或输入 Kimi Platform API Key。退出认证用 `/logout`。其他 provider 按[官方 provider 文档](https://moonshotai.github.io/kimi-code/en/configuration/providers.html)配置到 `~/.kimi-code/config.toml`；不要把密钥纳入版本控制。

## 第一次运行

![Kimi Code CLI 官方交互演示](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/kimi-intro.gif){ loading=lazy width="700" }

*来源：[Kimi Code 官方 README](https://github.com/MoonshotAI/kimi-code/blob/main/README.md)。动图是官方 CLI 操作演示，具体界面可能随版本变化。*

进入 `agent-lab` 后运行 `kimi`。先 `/login` 登录，再让它只读总结目录，然后提交 P07 文档任务。只读操作默认执行，写文件或运行 shell 命令前会请求确认。用 `/help` 查看命令，按 `/exit` 退出；回到普通终端检查 diff。

## 日常操作

使用清楚的目标和范围；工具模式、快捷键和 shell 操作以当前官方指南/界面提示为准。每轮执行后都确认实际文件而非只看响应。

## 会话与上下文

使用 `/sessions` 选择历史会话，`kimi -c` 继续上次会话，`/new` 开新会话，`/compact` 压缩上下文。数据默认位于 `~/.kimi-code/`，可用 `KIMI_CODE_HOME` 迁移整个数据根目录。迁移旧用户按[迁移指南](https://moonshotai.github.io/kimi-code/en/guides/migration)操作。

## 项目配置与指令

配置文件在 `~/.kimi-code/config.toml`；项目规则文件格式和查找方式见当前官方配置文档。不要把旧版 Python CLI 配置或通用 `AGENTS.md` 假定为自动加载；用只读确认和小任务验证实际范围。

## 权限与命令执行

确认 shell 选择、项目根目录和每类命令确认机制。Git Bash 路径配置只决定启动哪个 shell，不等于文件沙箱。拒绝无关写入，必要时将任务限制到练习仓库。

## 扩展与进阶

仅按当前文档启用 Skills、MCP 或插件；确认是核心功能、可选服务还是外部扩展，并记录停用方法。ACP/IDE 集成见官方集成文档，不扩展为 IDE 教程。

## 非交互使用

单次 prompt 可用 `kimi -p "Take a look at this project's directory structure"`。脚本化前核对当前 CLI reference 中退出码和授权提示；旧版 Python CLI 参数不可照搬到新版。

## 完整实战、维护与排障

完成 P07 任务。迁移按“备份旧数据—安装新版—重新认证—验证项目任务—再处理旧安装”顺序。命令冲突查 PATH；登录失败区分账号和网络；MCP 授权问题不要通过删除全部状态目录解决。参考：[Kimi Code 文档](https://moonshotai.github.io/kimi-code/en/guides/getting-started.html)、[迁移指南](https://moonshotai.github.io/kimi-code/en/guides/migration)、[官方仓库](https://github.com/MoonshotAI/kimi-code)。
