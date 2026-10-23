---
title: Codex CLI
description: 安装并使用 OpenAI Codex CLI，完成本地代码与文档任务。
---

# Codex CLI

核验日期：2026-10-22。官方资料入口：[Codex CLI quickstart](https://developers.openai.com/codex/cli/)、[Windows 部署与安装](https://learn.chatgpt.com/docs/enterprise/windows-deployment)。作者仅核对在线资料，未安装、登录或调用模型。先完成[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

Codex CLI 是在终端中使用的 OpenAI 编码 Agent。官方提供 macOS/Linux shell 安装脚本，以及 Windows PowerShell 安装器和 npm 包；Windows 也可使用原生 Codex 桌面应用或 WSL。CLI 与桌面应用分别选择操作环境。

## 安装前检查

Windows PowerShell 安装器无需 Node.js；若选 npm，需要先安装 Node/npm。准备 Git 和目标项目目录，先检查 `Get-Command codex` 或 `command -v codex`，避免多个发行方式冲突。ChatGPT 登录与 API Key 是不同授权方式。

## 安装与验证

macOS/Linux 和 WSL 中使用官方安装脚本；Windows 原生在 PowerShell 7 运行 PowerShell 安装器：

=== "Windows：PowerShell 7"
    ```powershell
    irm https://chatgpt.com/codex/install.ps1 | iex
    codex --version
    Get-Command codex
    ```

=== "WSL / macOS / Linux"
    ```bash
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
    codex --version
    command -v codex
    ```

若已通过 nvm 管理 Node.js，也可 `npm install -g @openai/codex`。不要重复安装；用命令路径确认当前来源。安装器可再次运行以更新；npm 安装通过 npm 更新。

安装后查看帮助：

```bash
codex --version
command -v codex
codex --help
```

Windows PowerShell 安装器支持原生 CLI；若选择 WSL，则在 WSL 内独立安装并从 Linux 项目目录运行。不要把 Windows 与 WSL 配置视为共用。升级和卸载按原安装渠道办理。

## 登录与模型接入

![Codex CLI 中选择模型与推理强度的界面](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/codex-model-picker.png){ loading=lazy width="900" }

*官方界面示例。图中模型名称和可用性对应截图时的版本与账号状态；请以当前 Codex 的 `/model` 选项和官方文档为准。*

在项目目录运行 `codex`，按提示用 ChatGPT 登录或选择可用的其他认证方式。也可按官方说明用 API Key；不同认证方式计费/授权范围不同。不要把密钥写入仓库。模型列表由当前版本和账号可用性决定。

接入 DeepSeek 等其他提供商时，先核对客户端与服务端的 API 格式。具体步骤见[模型 API 协议与接入](../tools/api-protocols.md)；当前 Codex 的 `wire_api` 使用 `responses`，不要直接套用旧版 `chat` 配置。

## 第一次运行

从练习仓库根目录运行 `codex`。先请求只读解释项目，再要求修改 `notes/workflow.md`。按界面提示审阅工具动作并执行小任务；用终端 `git status --short` 和 `git diff -- "notes/workflow.md"` 验收。用界面提供的退出方式结束；中断任务不代表已撤销部分文件修改。

## 日常操作

提示里明确目标、范围、不可做事项和完成条件。可先要求计划，再逐步授权编辑；文件引用、斜杠命令和快捷键以当前 CLI 帮助/官方指南为准。每轮后查看真实文件和 diff。

## 会话与上下文

按官方会话恢复说明查看当前版本支持的继续/恢复命令；不要从旧版本复制参数。交接到新会话时给出目标、已改文件、验证证据、未完成项和下一步。对话历史不等于项目文件状态。

## 项目配置与指令

Codex 支持读取 `AGENTS.md`，也可用 `/init` 生成起始说明；配置格式见[官方配置文档](https://developers.openai.com/codex/config/)。从项目根确认规则并核对子目录范围。模板见[项目指令与 AGENTS.md](../workflows/project-instructions.md)。

## 权限与命令执行

Codex 的审批和沙箱选项以官方安全文档及当前启动模式为准。批准一次命令不等于获得系统级隔离；理解当前工作目录、读写范围和命令副作用。Windows、WSL 的文件系统和 shell 边界分别核验。

## 扩展与进阶

按当前官方文档配置支持的 Skills、MCP 或插件。先使用单个、可解释的扩展，确认其配置位置和启动生效方式；停用时移除对应配置并重启会话。跨工具格式不保证兼容，通用概览见[扩展专题](../workflows/extensions.md)。

## 非交互使用

使用 `codex exec` 进入非交互模式。先用 `codex exec --help` 核对当前选项，再在独立练习仓库运行；明确工作目录、审批参数和输出，记录退出码并检查真实 diff。参考[官方非交互文档](https://developers.openai.com/codex/cli/#non-interactive-mode)。

## 完整实战、维护与排障

按 P07 完成共用练习，额外要求 Agent 仅修正一处缺漏，检查第二次 diff。找不到命令先查安装渠道和 PATH；登录失败分别核对账号、网络与认证选项；权限不符先缩小任务，不要直接切到宽松模式。官方参考：[CLI 文档](https://developers.openai.com/codex/cli/)、[配置参考](https://developers.openai.com/codex/config-reference/)、[安全](https://developers.openai.com/codex/security/)。
