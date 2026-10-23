---
title: Herdr 安装与使用
description: 安装 Herdr，管理终端工作区与 pane，并按明确目标观察 Agent 状态。
---

# Herdr 安装与使用

核验日期：2026-10-22。官方资料：[安装](https://herdr.dev/docs/install/)、[快速开始](https://herdr.dev/docs/quick-start/)、[Agent 自动化](https://herdr.dev/docs/agents/)。官方当前说明 Windows 原生支持 generally available；功能仍有平台差异。作者未安装、启动或控制 Herdr。先完成对应平台准备并熟悉一款 Harness；本页先学习普通终端布局，多 Agent 协作作为可选进阶。

## Herdr 是什么

Herdr 是后台会话服务和终端客户端，管理 workspace、tab 和 pane，并识别已支持的 Agent。其他 CLI 仍可在普通 pane 运行，但会作为普通终端显示。状态中的 `unknown` 不代表完成。

## 安装与启动

按[官方安装页](https://herdr.dev/docs/install/)安装：

=== "Windows：PowerShell 7"
    ```powershell
    pwsh -ExecutionPolicy Bypass -Command "irm https://herdr.dev/install.ps1 | iex"
    herdr --version
    ```

=== "WSL / macOS / Linux：Bash"
    ```bash
    curl -fsSL https://herdr.dev/install.sh | sh
    herdr --version
    ```

Windows 新安装默认 stable channel；安装目录加入 PATH。安装后开新终端运行 `herdr --help`。作者没有运行安装命令。更新、卸载和 Windows preview/stable 切换以官方指南为准。

## 先用普通终端熟悉布局

![Herdr 中并排显示的工作区、终端和 Agent pane](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/herdr-layout.png){ loading=lazy width="900" }

*来源：[Herdr 官方仓库](https://github.com/herdrdev/herdr)。官方产品界面示例；不同操作系统和版本的布局会有差异。*

在普通终端从项目目录运行 `herdr`，它会启动或连接默认后台会话。先用鼠标点选 pane、tab 和 workspace，拖动边界调整大小；右键菜单可创建 tab/pane。也可按 `herdr --help` 查当前 CLI。确认 Agent 的 pane 在预期 cwd，再运行工具。

## 运行 Harness 并观察状态

在 pane 手动启动已安装的 CLI。Herdr 支持的 Agent 可显示 `idle`、`working`、`blocked`；未支持的 CLI 仍可运行但呈现为终端。若要在服务重启后恢复 Agent 内部会话，按官方说明安装该 Agent 的 Herdr integration。`blocked` 表示审批或提问；`unknown` 不证明完成。结束后检查 Git diff。

## 分离、恢复和关闭

区分关闭 Herdr 界面、分离客户端、停止服务和关闭操作系统。进程能否继续取决于当前运行模式和平台；按官方会话文档确认，不承诺机器重启后进程恢复。关闭前检查 pane 是否有未保存工作。

## 受管理环境中的控制操作

以下是读者在 Herdr pane 内操作的命令，不是本站写作 Agent 执行过的命令。确认运行环境后只做只读发现：

```bash
test "${HERDR_ENV:-}" = 1
herdr agent list
herdr pane current --current
```

若第一条失败，说明当前 shell 不在受管理 pane 内；不要从外部尝试控制焦点会话。只从列表输出复制真实 Agent 名称/ID，不推测 ID。具体控制语法先查看 `herdr agent --help`。

## 提交任务与收集结果

本节为可选进阶。先读[自动化与多 Agent 协作](../workflows/automation.md)中的任务范围、分工和隔离原则，再进行控制练习。

先确认目标为自己的练习 Agent；提交后等待并读取结果：

```bash
herdr agent prompt <agent-name-from-list> "只读检查当前 diff，并报告是否符合任务范围。不要修改文件。" --wait --timeout 120000
herdr agent get <agent-name-from-list>
herdr agent read <agent-name-from-list> --source recent-unwrapped --lines 120
```

分别确认“成功提交”“观察到工作”“任务结束”“需要审批/提问”。若为 blocked，先读取界面并由用户处理；超时或 stalled 不证明任务未送达，不要盲目重复发送。

## 与多 Agent 协作 { #multi-agent-workflow }

从[自动化章节](../workflows/automation.md)复制只读拆分任务；固定各 pane 的 cwd。允许一个 Agent 修改、另一个只读审查；避免多个 Agent 同时写同一文件。需要并行改动时使用隔离 worktree。

## 超时、阻塞与维护

关闭窗口可 detach，后台 server 和 pane 继续运行；运行 `herdr` 可重新 attach。机器重启后的 pane/session 恢复条件以当前持久化文档为准。先检查状态和输出，再决定是否重试。Herdr 当前 Windows 原生版本不支持 direct terminal attach、live server handoff 等 Unix 特定能力；见[Windows 支持说明](https://herdr.dev/docs/windows-beta/)。
