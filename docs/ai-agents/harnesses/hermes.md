---
title: Hermes Agent
description: 使用 NousResearch Hermes Agent 完成本地任务，了解其平台和可选服务。
---

# Hermes Agent

安装资料核验日期：2026-10-22；功能资料核验日期：2026-10-28。本页依据官方[快速开始](https://hermes-agent.nousresearch.com/docs/getting-started/quickstart)、[安装](https://hermes-agent.nousresearch.com/docs/getting-started/installation)和下文所链接的功能文档编写。作者未安装或调用模型。先读[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

本文指 NousResearch 的 Hermes Agent。区分终端使用与消息平台、定时任务等可选服务；不要为首次本地文档练习配置聊天账号。

Hermes 的特色是把任务经验沉淀为可复用的技能，并结合跨会话记忆、子 Agent 委派、定时任务和消息网关，服务于需要持续开展的工作。

## 安装前检查

官方当前将 Windows 10/11 x86_64、aarch64，macOS Apple Silicon，Linux 和 WSL2 列为 Tier 1。Windows 另有签名 MSIX 桌面包，要求 Windows 11 22H2 或更新版；macOS 桌面包面向 Apple Silicon。CLI-only 安装使用 PowerShell 脚本或 POSIX shell 脚本。安装前核对现有 `hermes` 命令来源与系统架构。

## 安装与验证

选择一种安装路线。Windows 桌面路线从 [Hermes 官方网站](https://hermes-agent.nousresearch.com/)下载 `.appinstaller`，用 Windows App Installer 安装签名 MSIX；只需要 CLI 时使用官方脚本：

=== "Windows 原生：PowerShell 7"
    ```powershell
    iex (irm https://hermes-agent.nousresearch.com/install.ps1)
    ```

=== "WSL / macOS / Linux：Bash"
    ```bash
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
    ```

安装完成后重开终端，运行 `hermes --help` 和 `hermes doctor`。首次配置可运行 `hermes setup`；选择 Nous Portal 时运行 `hermes setup --portal` 并完成浏览器登录。也可运行 `hermes model` 选择其他 provider。桌面包、Windows 脚本和 POSIX 脚本的更新方式不同，按[更新与卸载指南](https://hermes-agent.nousresearch.com/docs/getting-started/updating-uninstalling)处理。Windows CLI 默认用户数据在 `%LOCALAPPDATA%\\hermes`；WSL/Linux/macOS 默认在 `~/.hermes`，不要共用数据目录。

## 登录与模型接入

![Hermes CLI 交互界面的布局示意图](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/hermes-cli-layout.svg){ loading=lazy width="900" }

*来源：[Hermes 官方 CLI 指南](https://hermes-agent.nousresearch.com/docs/user-guide/cli)。这是布局示意图，不是某一版本的运行截图。*

首次配置可运行 `hermes setup` 并按提示选择 Quick Setup、Full Setup 或 Blank Slate。快速路线 `hermes setup --portal` 会配置 Nous provider 与 Tool Gateway；其他 provider 通过 `hermes model` 交互配置。确认账号订阅与 API Key 的授权差别；密钥保存在工具配置，不写入项目文件。

## 第一次运行

在 `agent-lab` 根目录运行 `hermes` 进入交互界面；用 `hermes --help` 查看当前 CLI。先完成一次普通对话，确认 provider 可用，再请求只读总结并按 P07 修改文档。退出后检查磁盘文件和 diff。快速恢复工具包括 `hermes doctor`、`hermes model`、`hermes setup`、`hermes sessions list` 和 `hermes --continue`。

## 日常操作

将文档路径、可执行动作和验收标准说具体。要求 Agent 解释改动后检查文件，而不是把自然语言回答当成功证据。长任务拆成可恢复的步骤。

## 会话与上下文

恢复最近会话可用 `hermes --continue`，查看记录可用 `hermes sessions list`。Hermes 也提供 memory/Skills 机制；查看官方[用户指南](https://hermes-agent.nousresearch.com/docs/using-hermes)确认当前行为。记忆不等于自动读取所有历史。检查数据目录后再清理或备份。

### 分层、选择性与跨会话记忆

Hermes 将不同用途的信息分层保存：[持久记忆](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory)中的 `MEMORY.md` 保存环境、项目约定和经验，`USER.md` 保存用户偏好；两者容量有限，由 Agent 选择、增删和修订，随新会话加载。会话开始时注入的是快照，当前会话中新写入的记忆要到新会话才进入该快照；可以检查文件确认实际写入。

需要细节时，Agent 可以通过 `session_search` 检索过去的会话；[Skills](https://hermes-agent.nousresearch.com/docs/user-guide/features/skills) 则按需加载可复用的操作知识。这些机制共同支持跨会话延续，但不会把所有历史对话自动塞进每次上下文。记忆按 profile 区分，查看、备份或清理前先确认当前 profile 和数据目录。

## 项目配置与指令

使用官方文档确认配置和项目规则文件名称、加载顺序与作用域。不要假设 Hermes 自动读取 `AGENTS.md`；先用只读任务询问，再以小改动核验。通用模板见[项目指令专题](../workflows/project-instructions.md)。

## 权限与命令执行

用 `hermes setup terminal` 配置终端后端；`hermes config get terminal.backend` 查看当前值。`local` 在本机执行命令，不提供隔离；Docker/SSH 等后端需要各自依赖和配置。先确认工具命令实际运行在哪里、工作目录和挂载范围，再选择后端，不要把“已启用 sandbox”当作无需审阅权限。

## 扩展与进阶

先完成 CLI 闭环。Skills、plugins 和 MCP 按官方配置逐项启用；接消息渠道用 `hermes gateway setup`，运行前检查 `hermes gateway status`。cron 和其他常驻能力放到后续再配置。先读官方说明并知道查看日志与停用的方法，不在首次练习连接私人账号。

### 自进化学习闭环

Hermes 可从复杂任务中提炼经验，自动创建 Skill，并在后续使用中修订它，形成“执行任务 → 保存经验 → 按需调用 → 根据结果改进”的循环。Skill 的主体是 `SKILL.md` 操作指南，也可包含参考资料和脚本代码；不是每次任务都会自动生成代码。技能保存在当前 profile 的 skills 目录，可被 Agent 修改，使用前应检查新建或修改的指令和脚本。也可以通过 `/learn` 从资料创建技能。详见[技能系统](https://hermes-agent.nousresearch.com/docs/user-guide/features/skills)和[官方项目介绍](https://github.com/NousResearch/hermes-agent)。

### 自动化与多 Agent 并行

主 Agent 可通过 `delegate_task` 将独立子任务交给子 Agent 并行处理，再汇总结果；适合把资料检索、代码审查等可分割工作分别委派，并在交付前检查结果。`execute_code` 可通过代码调用工具，把多步操作组织为批处理；其执行环境由终端后端决定。详见[工具与工具集](https://hermes-agent.nousresearch.com/docs/user-guide/features/tools)。

内置 [Cron 调度](https://hermes-agent.nousresearch.com/docs/user-guide/features/cron)支持一次性或周期性任务、暂停和恢复，以及将结果发送到文件或配置好的消息平台。例如在聊天中输入 `/cron add "every 2h" "检查测试目录并总结变化"`，再查看任务状态；定时执行需要调度进程保持运行，并应事先确认工作目录、权限和输出目标。

### 工具、MCP 与企业微信

Hermes 内置丰富的原生工具，覆盖文件读写、网页搜索和浏览器、终端、代码执行、记忆与委派；Docker 是可配置的终端执行后端。工具和启用状态会随版本、平台及配置变化：官方当前文档使用“40+”概述，具体数量以本地 `hermes tools` 和[工具参考](https://hermes-agent.nousresearch.com/docs/user-guide/features/tools)为准。通过 [MCP](https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp) 还可连接外部服务器扩展工具。

消息网关支持多个平台，例如 Telegram、Discord、Slack 和企业微信。以[企业微信 WeCom](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/wecom) 为例：准备企业微信组织账号和 AI Bot，运行 `hermes gateway setup` 选择 WeCom，按向导扫码或输入 Bot ID 和 Secret，并设置允许使用的用户与群组；然后运行 `hermes gateway`，在获准的会话中发消息验证。该适配器通过 WebSocket 连接，无需公开回调地址；默认访问策略可能为开放，使用前应明确收紧私聊与群聊策略。密钥仅保存在受保护的配置中，定时任务也可向配置的目标会话投递结果。

## 非交互使用

官方 CLI 提供单问题入口 `hermes chat -q "..."`，用于脚本时核对退出码、输出和授权模式；先在读者自己的测试项目验证。不要把 dashboard/gateway 服务启动命令当成单次批处理。

## 完整实战、维护与排障

完成 P07，再可选测试一个本地 Skill。安装异常先检查官方依赖和版本；模型错误分开核对凭据与端点；不要为修复路径问题删除会话目录。参考：[官方仓库](https://github.com/NousResearch/hermes-agent)及其中 README。
