---
title: Hermes Agent
description: 使用 NousResearch Hermes Agent 完成本地任务，了解其平台和可选服务。
---

# Hermes Agent

核验日期：2026-10-22；本页按官方[快速开始](https://hermes-agent.nousresearch.com/docs/getting-started/quickstart)、[安装](https://hermes-agent.nousresearch.com/docs/getting-started/installation)和[平台支持](https://hermes-agent.nousresearch.com/docs/getting-started/platform-support)编写。作者未安装或调用模型。先读[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

本文指 NousResearch 的 Hermes Agent。区分终端使用与消息平台、定时任务等可选服务；不要为首次本地文档练习配置聊天账号。

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

## 项目配置与指令

使用官方文档确认配置和项目规则文件名称、加载顺序与作用域。不要假设 Hermes 自动读取 `AGENTS.md`；先用只读任务询问，再以小改动核验。通用模板见[项目指令专题](../workflows/project-instructions.md)。

## 权限与命令执行

用 `hermes setup terminal` 配置终端后端；`hermes config get terminal.backend` 查看当前值。`local` 在本机执行命令，不提供隔离；Docker/SSH 等后端需要各自依赖和配置。先确认工具命令实际运行在哪里、工作目录和挂载范围，再选择后端，不要把“已启用 sandbox”当作无需审阅权限。

## 扩展与进阶

先完成 CLI 闭环。Skills、plugins 和 MCP 按官方配置逐项启用；接消息渠道用 `hermes gateway setup`，运行前检查 `hermes gateway status`。cron 和其他常驻能力放到后续再配置。先读官方说明并知道查看日志与停用的方法，不在首次练习连接私人账号。

## 非交互使用

官方 CLI 提供单问题入口 `hermes chat -q "..."`，用于脚本时核对退出码、输出和授权模式；先在读者自己的测试项目验证。不要把 dashboard/gateway 服务启动命令当成单次批处理。

## 完整实战、维护与排障

完成 P07，再可选测试一个本地 Skill。安装异常先检查官方依赖和版本；模型错误分开核对凭据与端点；不要为修复路径问题删除会话目录。参考：[官方仓库](https://github.com/NousResearch/hermes-agent)及其中 README。
