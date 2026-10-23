---
title: OpenCode
description: 安装并配置 OpenCode 终端编码 Agent，完成首次项目任务。
---

# OpenCode

核验日期：2026-10-22；本页按官方 v2 文档与下载页撰写。作者仅查阅资料，未安装或调用模型。入口：[v2 文档](https://dev.opencode.ai/v2)、[v2 下载](https://opencode.ai/v2)。v1 与 v2 的包名和配置可能不同，不混用。先完成[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

OpenCode 是可连接多家模型服务的终端编码 Agent。配置和提供商支持以官方文档为准；不要把第三方兼容协议等同于所有模型都可用。

## 安装前检查

Windows 原生使用 npm 安装，先按[Windows 环境准备](../getting-started/windows.md)配置 nvm-windows、Node.js 与 npm。v2 npm 包为 `@opencode/cli`；先检查 `node --version`、`npm --version`、已有 `opencode` 命令来源和模型账号/API。选择 WSL 时，在 WSL 内独立安装。

## 安装与验证

Windows 使用 npm；WSL、macOS 和 Linux 可使用官方安装脚本：

=== "Windows：PowerShell 7"
    ```powershell
    npm install -g @opencode/cli
    opencode --version
    Get-Command opencode
    opencode --help
    ```

=== "Windows：Git Bash"
    ```bash
    npm install -g @opencode/cli
    opencode --version
    command -v opencode
    opencode --help
    ```

=== "WSL / macOS / Linux：Bash"
    ```bash
    curl -fsSL https://opencode.ai/v2/install | bash
    opencode --version
    command -v opencode
    opencode --help
    ```

npm 包通过 postinstall 脚本选择当前平台的原生二进制，不要在安装时禁用该脚本。其他平台也可使用 `npm install -g @opencode/cli`；v1 的 `opencode-ai` 包名不可套用到 v2。使用 nvm 切换 Node.js 版本后，重新检查 `opencode` 的来源；升级和卸载按最初安装渠道办理。

## 登录与模型接入

![OpenCode 官方 README 中的终端交互示例](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/opencode-terminal.png){ loading=lazy width="900" }

*来源：[OpenCode 官方 README](https://github.com/anomalyco/opencode/blob/dev/README.md)。这是官方项目展示图，界面会随版本变化；本页安装命令按 v2 文档。*

启动 TUI 后输入 `/connect` 选择 provider，再完成官方登录或填写 API key。输入 `/models` 选定当前凭据可用的模型。API Key、厂商账号和模型订阅不自动互通；不要提交配置中的密钥。

## 第一次运行

从 `agent-lab` 根目录运行 `opencode`。输入 `/connect` 登录，选择模型后请它只读查看项目，再完成 P07 任务。查看工作目录、工具调用及权限确认，退出按当前 TUI 的 Esc/Ctrl+C 提示操作，再查 diff。

## 日常操作

任务里列明目标路径、限制和验收条件；需要时先请求计划。不要把 TUI 内命令写进系统 shell。修改后检查 `git status` 和具体文件差异，针对差异反馈而非只说“做得更好”。

## 会话与上下文

按[会话文档](https://opencode.ai/docs/sessions/)查看当前支持的恢复、分支或导出方式。保留会话并不保证依赖文件、授权或项目版本不变；新会话用摘要交接。

## 项目配置与指令

v2 的项目规则和配置以[v2 文档](https://dev.opencode.ai/v2)为准。确认当前规则文件和查找顺序；不要因 Codex 或 Claude 使用同名文件就假定自动读取。用只读任务确认实际上下文。

## 权限与命令执行

用 `/permissions` 查看或配置当前工具权限；对 shell、文件编辑等权限按项目逐项设置。明确工作目录和写入范围，审阅工具动作；不要为了消除确认提示而全局放宽。

## 扩展与进阶

按 v2 文档配置 MCP、插件、commands 或 Skills；一次只增加一项并检查配置路径。停用后重启 TUI 验证。见[扩展专题](../workflows/extensions.md)。

## 非交互使用

按当前 v2 CLI 文档核对 `opencode run` 的 prompt、输出格式及退出状态；通过 `opencode run --help` 获取版本内选项。勿从 v1 文档复制旧包名或配置路径。

## 完整实战、维护与排障

完成 P07 后要求补充遗漏，再检查差异。找不到模型时检查连接的提供商、凭据和模型 ID；命令错版时检查 PATH 顺序；规则未加载时确认项目根和规则格式。参考：[安装](https://opencode.ai/docs/installation/)、[提供商](https://opencode.ai/docs/providers/)、[配置](https://opencode.ai/docs/config/)。
