---
title: Herdr 安装与使用
description: 安装 Herdr，管理终端工作区与 pane，并按明确目标观察 Agent 状态。
---

# Herdr 安装与使用

安装资料核验日期：2026-10-22；功能资料核验日期：2026-10-28。官方资料：[安装](https://herdr.dev/docs/install/)、[Agent 自动化](https://herdr.dev/docs/agent-automation/)、[CLI 参考](https://herdr.dev/docs/cli-reference/)。Windows 原生支持和功能仍有平台差异。作者未安装、启动或控制 Herdr，也未实测下文的 Hermes 组合。先完成对应平台准备并熟悉一款 Harness；本页先学习普通终端布局，多 Agent 协作作为可选进阶。

## Herdr 是什么

Herdr 是面向 AI Agent，尤其是 Claude Code、Codex 等编码代理的终端多路复用器（Agent Multiplexer）。可以把它理解为“为 AI Agent 重新设计的 tmux”：它保留终端分屏和后台会话，同时认识受支持的 Agent，显示状态并提供可由脚本或 Agent 使用的编排接口。它由后台会话服务和终端客户端组成，通过 workspace、tab 和 pane 组织任务。其他 CLI 仍可在普通 pane 运行，但会作为普通终端显示。参见[官方项目](https://github.com/herdrdev/herdr)和[支持的 Agent](https://herdr.dev/docs/agents/)。

### Agent 状态一眼看全

侧栏把 pane 的 Agent 状态汇总到 tab 和 workspace：`working` 表示正在工作，`blocked` 表示识别到需要处理的审批或提问，`idle` 和 `done` 表示可接收输入，其中 `done` 标记尚未查看的完成状态。这样可以快速找到需要注意的任务。状态是识别结果而非成功证明：`unknown` 不等于完成，未识别的提示也可能显示为 `idle`；仍需查看输出和实际产物。

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

正常按 `Ctrl+B` 再按 `Q` 分离客户端，后台 Herdr server、pane 和原进程继续运行；稍后运行 `herdr` 重新连接，即可回到同一批进程。关闭客户端或 SSH 连接与关闭运行服务器的机器是不同的事情：主机休眠期间任务可能暂停，关机后原进程不会继续运行。

服务重启后，[会话恢复](https://herdr.dev/docs/session-state/)可重建保存的布局和工作目录，但不会保留原 shell、测试或服务进程。已安装且满足版本条件的 Agent integration 可让受支持 Agent 重新启动并恢复其原生会话，例如先查看 `herdr integration status`，再按需使用 `herdr integration install codex` 或 `herdr integration install claude`。恢复会话也不保证被中断的任务自动完成；应检查结果再决定是否继续。

## 受管理环境中的控制操作

以下是读者在 Herdr pane 内操作的命令，不是本站写作 Agent 执行过的命令。确认运行环境后只做只读发现：

```bash
if test "${HERDR_ENV:-}" = 1; then
    herdr agent list
    herdr pane current --current
else
    printf '%s\n' '请先进入 Herdr pane'
fi
```

若检查失败，说明当前 shell 不在受管理 pane 内；不要从外部尝试控制焦点会话。只从列表输出复制真实 Agent 名称/ID，不推测 ID。具体控制语法先查看 `herdr agent --help`。

### CLI 参考：pane 与 Agent

在受管理 pane 内先运行 `herdr pane --help` 和 `herdr agent --help`，再根据列表中的真实目标替换下表的占位符。大多数控制命令返回 JSON，`read` 返回终端文本。pane 是终端位置；Agent 是其中被识别的进程，名称只在当前 Agent 存活期间有效。

| 操作 | 命令示例 | 用途 |
| --- | --- | --- |
| 列出目标 | `herdr pane list` / `herdr agent list` | 查实际 pane ID、Agent 名称和状态 |
| 向终端输入文字 | `herdr pane send-text <pane-id> "hello"` | 原样输入，不自动回车；适用于明确知道当前前台程序的 pane |
| 运行终端命令 | `herdr pane run <pane-id> "git status --short"` | 在目标终端输入命令并提交；先确认是可用 shell |
| 启动 Agent | `herdr agent start reviewer --kind codex --pane <pane-id>` | 在已有空闲 shell pane 启动 Codex，成功后返回就绪状态 |
| 向 Agent 发任务 | `herdr agent prompt reviewer "只读检查当前 diff"` | 向已识别的 Agent 发送并提交任务 |
| 查看状态和输出 | `herdr agent get reviewer` / `herdr agent read reviewer --source recent-unwrapped --lines 120` | 读取状态和最近输出，核对任务结果 |

`agent start` 不创建 pane；`pane run` 和 `pane send-text` 面向终端当前前台程序，而 `agent prompt` 面向被识别的 Agent。向等待审批的界面发送原始输入可能触发意外操作，因此先读取目标状态和画面。

### 添加 SSH 机器

Herdr 可将已保存的 SSH 机器和本机工作区汇总在一个界面。先在交互终端确认 `ssh workbox` 能连接预先配置的 SSH 主机，再运行 `herdr machine add workbox --label "Build machine"`；按提示选择远端会话。安装或替换远端组件可能需要确认，替换运行中的服务会结束其 pane 进程。查看 `herdr machine list` 和 `herdr machine status "Build machine"`。详见[连接机器](https://herdr.dev/docs/connecting-machines/)。

每台机器有独立的 server 和 ID。切换界面中的机器不会改变已有 pane 内 CLI 的默认目标；使用下面的全局参数明确路由，并始终从该机器的返回结果选择目标：

```bash
herdr --machine "Build machine" pane list
herdr --machine "Build machine" agent list
herdr --machine "Build machine" agent prompt <remote-agent-name> "只读检查当前 diff" --wait --timeout 120000
```

这里的名称必须是已启用的机器配置标签或 ID；远端服务须已运行、版本兼容，且 SSH 可非交互认证。连接失败不回退到本机，也不能证明此前的写入未发生；重试前先检查远端状态。

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

Herdr 的 [Agent 原生编排](https://herdr.dev/docs/agent-automation/)让运行在受管理 pane 的 Agent 使用同一套 CLI 或 socket API 创建 pane、启动其他 Agent、委派任务、等待状态并收集结果。它管理真实终端进程；是否启动协作者、分配什么任务以及写入范围仍由用户和当前任务决定。创建 pane 后要从响应读取 ID，`agent start` 只接受已存在的空闲 shell pane。

## 通过 Hermes 企业微信控制 Herdr

下面展示组合用法：企业微信消息 → Hermes 网关与 Agent → Hermes `terminal` 工具 → Herdr CLI → 本机或已保存的 SSH 机器。WeCom 本身不直接执行 shell；Hermes 根据消息调用工具。示例为读者配置路线，尚未在本文作者环境中实测。

### 准备与验证

1. 在本机完成 [Hermes 的 WeCom 配置](../harnesses/hermes.md)，创建企业微信 AI Bot，配置允许的私聊用户；禁用不需要的群聊或限制群组及发送者。核对 [WeCom 官方文档](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/wecom)：其默认策略可能开放。不要将 Secret 发到聊天或项目文件。
2. 在同一用户、同一台机器的 Herdr 受管理 pane 中启动 `hermes gateway`，并确认终端后端是 `local`（`hermes config get terminal.backend`）；本例的 Herdr CLI、机器配置和 SSH 凭据均在该本机用户下。服务安装方式或 Docker/SSH 后端可能改变用户、环境和可访问的 socket，不能直接套用本例。
3. 在企业微信中先让 Hermes **通过 terminal 工具**执行只读检查：`test "${HERDR_ENV:-}" = 1 && herdr agent list`。只有工具输出确认环境与预期 Agent 后才继续；若变量、PATH、socket 或身份不匹配，停止并调整启动环境，不要手动伪造变量。定时任务是独立会话，也要在任务中再次检查。
4. 如控制远端，先按上节在同一用户下交互添加 `Build machine`，并在网关的执行环境中验证 `herdr --machine "Build machine" agent list`；确保 SSH 认证不依赖无人值守时的交互提示。

### 即时发送与恢复任务

先在企业微信发给 Hermes 以下请求，其中 `reviewer` 是在本机 `herdr agent list` 中确认的 Agent 名称，使用前替换为实际值：

```text
请用 terminal 工具先检查 HERDR_ENV=1，再运行 herdr agent list 和 herdr agent get reviewer。确认 reviewer 是我的练习 Agent 且处于可接收输入的状态后，执行一次：
herdr agent prompt reviewer "只读检查当前项目的 git diff，列出风险，不要修改文件。" --wait --timeout 120000
然后读取 herdr agent read reviewer --source recent-unwrapped --lines 120，向我报告状态和结果；若阻塞或超时，先报告，不要重复发送或替我批准。
```

若目标在 SSH 机器，先从该机器的列表确认名称；两台机器可有同名 Agent。例如在企业微信请求 Hermes 执行远端 `herdr --machine "Build machine" agent list` 和 `herdr --machine "Build machine" agent get reviewer`，确认后发送：

```bash
herdr --machine "Build machine" agent prompt reviewer "只读检查当前项目的 git diff，不要修改文件。" --wait --timeout 120000
herdr --machine "Build machine" agent read reviewer --source recent-unwrapped --lines 120
```

该请求用于向仍在运行的 Agent 继续派发任务；若服务重启后 Agent 未恢复，则先检查布局、integration、原生会话 ID 和对应 Agent 的恢复方式。比如已确认空闲 shell pane 和 Codex 会话 ID 后，可请 Hermes 执行以下命令恢复会话，再检查 Agent 状态并单独发送后续任务：

```bash
herdr --machine "Build machine" agent start reviewer --kind codex --pane <远端空闲-pane-id> -- resume <Codex-会话-id>
```

占位符须替换成用户确认的真实值；本机调用去掉 `--machine "Build machine"`。`reviewer` 是新 Agent 名称，确认没有重名。恢复对话不等于自动重跑被中断的任务。

### 企业微信定时启动任务

先确认网关持续运行且目标 Agent 已就绪。在企业微信中用自然语言让 Hermes 创建一次性 Cron 任务，例如：

```text
请创建一个 30 分钟后执行一次的 Cron 任务，结果送回当前企业微信会话。任务执行时通过 terminal 工具先检查 HERDR_ENV=1，并查看本机 herdr agent list 和 herdr agent get reviewer；只有确认 reviewer 是我的练习 Agent 且可接收输入时，才执行一次 herdr agent prompt reviewer "只读检查当前项目的 git diff 并总结风险，不要修改文件。" --wait --timeout 120000。随后读取 reviewer 的最近输出并报告；如目标不存在、阻塞或超时，报告情况，不要重试或批准操作。
```

远程任务同样将每条 Herdr 控制命令改用 `herdr --machine "Build machine"`，并先确认远端目标。使用 `/cron list` 查看任务，必要时 `/cron pause <job_id>` 或 `/cron remove <job_id>`；`/cron resume <job_id>` 恢复的是调度，不是恢复 Agent 会话。Cron 在网关中按周期触发并使用新 Agent 会话，结果可返回来源会话；停机、权限、SSH、模型或目标状态都可能导致任务失败，查看 [Cron 文档](https://hermes-agent.nousresearch.com/docs/user-guide/features/cron)和运行记录，不要假定任务已完成或恰好执行一次。

## 超时、阻塞与维护

关闭窗口可 detach，后台 server 和 pane 继续运行；运行 `herdr` 可重新 attach。机器重启后的 pane/session 恢复条件以当前持久化文档为准。先检查状态和输出，再决定是否重试。Herdr 当前 Windows 原生版本不支持 direct terminal attach、live server handoff 等 Unix 特定能力；见[Windows 支持说明](https://herdr.dev/docs/windows-beta/)。
