---
title: oh-my-pi
description: 独立安装与使用 oh-my-pi，并区分其与 Pi 的项目及配置。
---

# oh-my-pi

核验日期：2026-10-22。依据[oh-my-pi 官方项目](https://github.com/can1357/oh-my-pi)；作者未安装或运行模型。oh-my-pi 是独立 Pi fork，命令为 `omp`；不能因此推断配置或会话可直接互换。先完成[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

使用前确认仓库当前发布、支持平台及与上游/同名项目关系。项目可能提供预编译二进制或包管理安装；实际终端与界面按当前 README 描述。

## 安装前检查

先选择安装器、Homebrew 或 Bun 中的一条路线，并检查已存在的 `omp` 命令和系统架构。安装器可使用预编译版本，不要求预先准备 Bun/Node 开发环境；Homebrew 适用于 macOS/Linux（包括 WSL）；Bun 路线适用于 Windows、macOS 和 Linux，要求 Bun 1.3.14 或更新版。

## 安装与验证

以下三种方式并列，按当前系统和已有包管理器选择一种。

### 官方安装器

Windows 在 PowerShell 7 中运行；WSL、macOS 和 Linux 使用各自环境中的 shell：

=== "Windows：PowerShell 7"
    ```powershell
    irm https://omp.sh/install.ps1 | iex
    omp --version
    Get-Command omp
    ```

=== "WSL / macOS / Linux：Bash"
    ```bash
    curl -fsSL https://omp.sh/install | sh
    omp --version
    command -v omp
    ```

没有可用的 Bun 时，安装器会下载并校验预编译二进制。如要强制使用二进制或固定版本，按 [README](https://github.com/can1357/oh-my-pi#install) 的 `--binary --ref` 选项操作；PowerShell 使用对应的 `-Binary -Ref` 参数。

### Homebrew 安装（macOS / Linux / WSL）

先按 [Homebrew 官方安装说明](https://docs.brew.sh/Installation)安装并完成 shell 初始化。WSL 用户在 WSL 内安装 Homebrew。确认 `brew` 可用后运行：

```bash
brew --version
brew install can1357/tap/omp
omp --version
command -v omp
```

### Bun 安装（Windows / macOS / Linux）

先按 [Bun 官方安装说明](https://bun.sh/docs/installation)安装 Bun，重新打开终端并确认版本至少为 1.3.14，再安装 oh-my-pi：

=== "Windows：PowerShell 7"
    ```powershell
    bun --version
    bun install -g @oh-my-pi/pi-coding-agent
    omp --version
    Get-Command omp
    ```

=== "Git Bash / WSL / macOS / Linux：Bash"
    ```bash
    bun --version
    bun install -g @oh-my-pi/pi-coding-agent
    omp --version
    command -v omp
    ```

安装完成后核对版本、命令路径与安装输出。若 `omp` 不在 PATH，按 Bun 官方安装说明检查全局可执行目录并重新打开终端。后续维护使用原安装渠道；卸载前备份 `~/.omp/` 或 Windows 对应用户目录中的配置和会话。

## 登录与模型接入

![oh-my-pi 启动画面与模型命令提示](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/omp-models.webp){ loading=lazy width="900" }

*来源：[oh-my-pi 官方仓库](https://github.com/can1357/oh-my-pi)。这是项目界面示例，实际模型列表取决于配置的 provider。*

启动 `omp` 后使用 `/login` 完成 OAuth/API Key 认证，使用 `/model` 查看并切换当前 provider/model。自定义 OpenAI-compatible provider 按 README 的 models 配置格式写入用户配置目录。不要复制 Pi 的 key 或提交包含密钥的文件。

## 第一次运行

在 `agent-lab` 根目录运行 `omp`，确认工作目录后用 `/login` 登录、`/model` 选模型。先请求只读总结，再执行 P07 文档任务。完成后在普通终端检查 diff；退出/中断按 TUI 的 `/help` 提示操作。

## 日常操作

按小步任务给出修改范围、不可改变内容和验收标准。若启用代码分析工具，先核对其依赖和适用语言；文档任务不需安装 LSP 或额外服务。

## 会话与上下文

使用 `/resume` 查看和恢复会话；具体 session 路径与操作按当前 README 核对。升级前备份 `~/.omp/`；没有兼容承诺时，不复用 Pi 的会话数据库。

## 项目配置与指令

oh-my-pi 支持项目级 `AGENTS.md` 规则及其自身扩展目录；准确作用域与加载顺序见当前 README。Pi 的规则目录和插件不要未经核对复制。先用只读任务确认实际加载上下文。

## 权限与命令执行

核对当前审批开关和 shell 工具行为；提示词范围、TUI 确认和 OS 隔离是不同机制。不要因为同为 Pi 系列就把另一产品权限模式移植过来。

## 扩展与进阶

官方项目提供 MCP、Skills、hooks、extensions 和子 Agent 能力；以 [README](https://github.com/can1357/oh-my-pi) 及对应文档为准逐项启用。先加一个扩展验证，再确认禁用方式。项目 README 也列出 Windows 原生支持及其内置 shell；Windows 用户不需要通过 WSL 才能运行。扩展概览见[专题](../workflows/extensions.md)。

## 非交互使用

自动化前确认官方支持的 print/API/RPC 入口、输出格式、退出状态和审批行为。若 README 只说明交互式启动，就不要声称有批处理接口。

## 完整实战、维护与排障

完成 P07 练习后再尝试一个可选代码任务。运行时缺失按官方安装指南处理；旧 Pi 配置冲突时先备份并用干净练习配置诊断。参考：[官方仓库与最新说明](https://github.com/can1357/oh-my-pi)。
