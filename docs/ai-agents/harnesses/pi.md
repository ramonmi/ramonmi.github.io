---
title: Pi
description: 安装并使用 Pi coding agent，了解核心程序与扩展边界。
---

# Pi

本文的 Pi 指 earendil-works/pi 当前维护的 coding agent 项目，不是同名产品。核验日期：2026-10-22；作者未安装或登录。参考[官方 quickstart](https://pi.dev/docs/latest/quickstart)与[Windows setup](https://pi.dev/docs/latest/windows)。先完成[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

Pi 是可扩展的终端 coding agent。核对当前仓库发布包、支持平台和项目迁移说明；不要沿用历史 npm 包名或假设其配置与 oh-my-pi 兼容。

## 安装前检查

检查旧 `pi` 命令来源。npm 方式需 Node.js 22.19 或更新版；Windows 原生推荐使用 npm，并提前安装 Git for Windows，供 Pi 执行 Bash 命令。选择 WSL 时，在 WSL 内独立安装；官方安装器适用于 macOS/Linux，也可用于 WSL。

## 安装与验证

下面两种方式任选一种。Windows 原生推荐 npm；macOS、Linux 和 WSL 可选择 npm 或官方安装器。

### npm 安装（Windows 推荐）

先准备 Node.js 22.19 或更新版与 npm。Windows 用户可按[环境准备页](../getting-started/windows.md)用 nvm-windows 管理 Node.js；WSL/macOS/Linux 用户使用对应平台的 nvm-sh。

=== "Windows：PowerShell 7"
    ```powershell
    node --version
    npm --version
    npm install -g --ignore-scripts @earendil-works/pi-coding-agent
    pi --version
    Get-Command pi
    pi --help
    ```

=== "Git Bash / WSL / macOS / Linux：Bash"
    ```bash
    node --version
    npm --version
    npm install -g --ignore-scripts @earendil-works/pi-coding-agent
    pi --version
    command -v pi
    pi --help
    ```

`--ignore-scripts` 与当前官方 quickstart 一致；正常 npm 安装不需要依赖包的生命周期脚本。Windows 安装后继续按 [Windows setup](https://pi.dev/docs/latest/windows)确认 Pi 能找到 Git Bash。切换 Node.js 版本后，重新检查 `pi` 的命令来源和全局包安装位置。

### 官方安装器（WSL / macOS / Linux）

在所选 Linux/WSL 或 macOS 环境中运行：

```bash
curl -fsSL https://pi.dev/install.sh | sh
pi --version
command -v pi
pi --help
```

安装器固定依赖版本，升级使用 `pi update`；npm 路线由 npm 管理，可重新运行该路线的安装命令更新。核对命令路径，避免两种渠道安装的同名程序发生冲突。

## 登录与模型接入

![Pi coding agent 的交互终端示例](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/pi-interactive.png){ loading=lazy width="900" }

*来源：[Pi 官方 coding-agent 文档](https://github.com/earendil-works/pi/tree/main/packages/coding-agent/docs)。图中版本信息属于示例，当前命令与功能以官网文档为准。*

在 TUI 输入 `/login`，选择 provider 并按提示登录或存 API key；随后 `/model` 选择可用模型。可用订阅、API key 或本地模型。提供商列表见[官方文档](https://pi.dev/docs/latest/providers)。

## 第一次运行

在 `agent-lab` 启动 `pi`。先让它总结项目，然后输入 P07 修改任务。Pi 会展示文件读取、搜索、命令和编辑动作；它不会在每次工具调用前询问，重要工作应使用 Git/备份并审阅改动。输入 `/help` 查看快捷操作。

## 日常操作

将范围、保留内容要求和验收标准写进提示。每次编辑后核对文件和差异；遇到遗漏时给出具体反馈。工具输出显示完成不代表文件符合要求。

## 会话与上下文

Pi 自动保存会话；退出后在同一工作目录运行 `pi --continue` 继续最近会话，或输入 `/resume` 选择其他会话。跨版本前备份会话与配置；不承诺与 oh-my-pi 兼容。

## 项目配置与指令

Pi 会为工作目录加载 `AGENTS.md`。按[官方指令说明](https://pi.dev/docs/latest/adding-instructions)确认目录范围；此共同文件的存在不意味着其他 Harness 也会自动加载。通用分层模板见[项目指令专题](../workflows/project-instructions.md)。

## 权限与命令执行

Pi 展示工具动作但不会逐项确认工具调用；未经信任的任务应自行使用容器或其他 sandbox。启动前确认工作目录，练习后审查 Git diff；不要把提示词范围当系统隔离。

## 扩展与进阶

Pi 的扩展、主题、模板、Skills 或 package 能力区分核心与外部组件，按当前官方文档安装并验证。代码分析能力可能需要额外语言服务，不作为基础安装前提。新增扩展前备份配置，停用时移除其来源。

## 非交互使用

按官方文档验证 print/JSON、RPC 或 SDK 等入口是否属于当前版本。检查输入方式、输出结构和退出状态；没有证据的参数不要尝试写成教程命令。脚本结果还须由文件和日志确认。

## 完整实战、维护与排障

完成 P07 文档练习，可选新增一个本地提示模板后比较结果。包名或命令迁移时先检查官方仓库 release；登录问题分辨提供商配置与网络；扩展冲突可备份后逐项停用。参考：[Pi 官方仓库](https://github.com/earendil-works/pi)。
