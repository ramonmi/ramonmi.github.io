---
title: 认识 AI Agents 与 Harness
description: 理解模型、提供商、Agent、Harness、终端、会话与执行权限之间的关系。
---

# 认识 AI Agents 与 Harness

本页解释终端 Agent 如何围绕任务、文件和命令开展工作。读完后，你能判断自己需要准备什么账号、运行环境和权限。

## 从聊天到 Agent

普通聊天主要根据上下文生成回复。编码 Agent 还能调用工具读取文件、搜索代码、编辑文件、运行命令，再依据结果继续处理任务。可把常见过程理解为“接收目标 → 读取上下文 → 调用工具 → 检查反馈 → 再行动”。

这并不表示 Agent 已经了解整台电脑。它能看到哪些文件、能运行哪些命令，以及何时需要确认，都由它所在 Harness、工作目录、配置和平台共同决定。

## 模型、提供商与 Harness

`模型`负责生成和理解内容；`提供商`负责提供模型访问、账号认证和服务接口；`Harness`把模型、文件工具、命令执行、上下文和用户交互组合成可以使用的 Agent。

同一个 Harness 可能连接多个提供商；不同 Harness 也可能使用同一家提供商。配置能够连接服务不代表账号已获得访问权限，也不保证所有模型都能用上相同功能。

## 认识终端

`终端`是输入和显示文本的应用，Windows Terminal、macOS Terminal 等是终端宿主。`Shell`负责解释命令，例如 Bash 和 PowerShell。终端里既可以运行普通系统命令，也可以启动一个 CLI Agent。

CLI 是命令行程序；TUI 是运行在终端里的图形化文本界面。工具界面的 `/help` 可能是 Agent 命令，而在 Agent 外键入 `git status` 则是系统命令。使用文档时先确认命令应输入的位置。

## 理解终端启动环境与 Agent shell

从 Git Bash 输入 `codex`，只说明启动器是从 Git Bash 启动。Agent 实际执行命令时使用哪种 shell，要以该工具和配置的行为为准。部分工具会在 Windows 使用自己的 shell 选择策略，另一些可以切换到 PowerShell。

同理，从 WSL 启动 Agent，通常表示 Agent 访问该 Linux 环境里的文件、工具和 HOME。不要在未确认配置的情况下认为 Windows 与 WSL 共用运行时、登录状态或配置文件。

## 会话、项目说明和记忆

会话保存一段工作的对话与状态。项目说明文件提供重复使用的项目约定；它的文件名和加载规则由 Harness 决定。长期记忆、会话历史和项目规则也不是一回事。

把重要约束写在工具支持的项目说明中，并在任务里引用真正需要的文件。不要将密钥写入项目说明或提示词。

## 登录、订阅与 API

每个提供商的账号和套餐规则不同。Harness 可能支持浏览器登录、API Key 或兼容接口。订阅登录与按 API 使用量计费属于不同的认证和计费路线；不要假定一个订阅能解锁全部工具或所有模型。

在设置前阅读所选工具的认证页。只把密钥输入官方授权的登录界面或安全凭据存储，不提交到 Git 仓库。

## 权限与完成判断

Agent 可以执行的操作受工作目录、工具权限、确认机制和操作系统账号约束。提示词可以解释任务边界，但不能替代系统权限或文件访问隔离。首次使用时关注即将执行的命令和将要修改的文件。

回复“完成”不是验证。检查目标文件、`git status` 和 `git diff`，再按任务需要运行检查，才能确认结果。

## 九款 Harness 怎么选

下面按本栏目介绍的九款工具比较。优缺点是工作方式上的取舍，不代表编码效果排名；同一工具搭配不同模型、账号和项目时，体验也会变化。桌面端情况核验日期：2026-11-10；产品形态可能调整，安装前请查看各工具页链接的官方资料。

| Harness | 主要特点与取舍 | 适用场景 | 桌面端 | CLI 与桌面端的配置 / 会话 |
| --- | --- | --- | --- | --- |
| [Codex](../harnesses/codex.md) | OpenAI 账号与模型集成紧密，支持并行任务和工作树；模型选择与使用额度受其服务和套餐约束。 | 已使用 ChatGPT/Codex，想在本地或云端处理编码任务、并行审阅改动。 | 有，Windows、macOS；也支持 CLI | 共用 Codex 用户配置和本地会话数据；CLI 与桌面端可查看、继续相同的本地会话/线程。 |
| [Claude Code](../harnesses/claude-code.md) | 支持终端和图形界面；桌面 Code 工作区支持并行编码会话、查看差异和本地终端，CLI 更适合脚本化与终端工作流。Claude Desktop 还提供 Cowork，可处理本地文件中的多步骤任务。 | 想用 Claude 处理编码任务，同时按偏好选择终端或图形界面；需要在桌面端处理跨文件任务时也可考虑 Cowork。 | 有 [Claude Desktop](https://support.claude.com/en/articles/10065433-install-claude-desktop)，提供 Chat、Cowork 和 [Claude Code 桌面工作区](https://code.claude.com/docs/en/desktop)；支持 macOS、Windows、Linux（Beta）。Claude Code 也可单独使用 CLI。 | Claude Code 桌面工作区与 CLI 共用 Claude Code 配置文件；两端的 session 列表分开，但可从桌面端继续 CLI session，或用 `/desktop` 将 CLI session 打开到桌面端。例外：`claude_desktop_config.json` 中的 MCP 配置不会被独立 CLI 自动读取。Claude Desktop 的 Chat / Cowork 对话历史与 Claude Code sessions 分开。 |
| [OpenCode](../harnesses/opencode.md) | 开源，支持多家模型服务，提供终端、桌面和 IDE 入口；选项灵活，也意味着模型、服务和配置需要自己取舍。 | 想比较模型提供商、使用本地或自选模型，或在不同界面间切换。 | 有，Windows、macOS、Linux | 配置和会话共享范围依客户端版本与存储设置；迁移前核对对应版本文档。 |
| [Pi](../harnesses/pi.md) | 精简、可扩展的终端 Harness；适合按需组合扩展，但默认体验和能力需要用户自己搭建。 | 喜欢轻量终端工作流、定制工具链或把 Agent 嵌入自己的程序。 | 无官方桌面应用；主要使用终端 TUI、CLI/SDK | 主要是 CLI/TUI 与 SDK 工作流。 |
| [oh-my-pi](../harnesses/oh-my-pi.md) | 基于 Pi 的增强分支，提供更多内置功能；相较精简核心，配置与功能面更大，也要留意上游差异。 | 希望保留 Pi 式可定制终端体验，同时需要更多开箱即用能力。 | 无官方桌面应用；主要使用终端界面 | 主要是 CLI/TUI 工作流。 |
| [DSH（DeepSeek Harness）](../harnesses/dsh.md) | DeepSeek 的开源、插件化 Harness，便于研究和组合能力；项目迭代较快，插件和 Profile 配置带来一定学习成本。 | 想使用 DeepSeek 生态、探索插件式 Agent，或接受自行配置和跟进项目变化。 | 有 DSH Desktop，提供 Windows、macOS 客户端；无需命令行即可图形化操作，也可使用内置终端 | 桌面客户端与上游 CLI/Web UI 是不同入口；具体配置和会话互通情况以 DSH Desktop 文档为准。 |
| [Kimi Code](../harnesses/kimi-code.md) | Kimi 官方模型和账号接入直接，CLI 与桌面端并行；若希望接入其他服务，需检查当前支持方式及套餐限制。 | 已使用 Kimi 服务，想在 CLI、IDE 或图形界面中完成编码任务。 | 有，Windows、macOS | CLI 与桌面端的配置、会话互通情况按当前版本文档确认。 |
| [WorkBuddy](../harnesses/workbuddy.md) | 面向桌面任务的图形化 Agent，适合文件、文档等可视化工作；终端开发者的脚本化和可移植性需按具体入口核实。 | 更习惯桌面操作，想从资料整理、文档处理或本机任务开始使用 Agent。 | 有，Windows、macOS；另有 Web 入口 | 桌面应用是主要入口；不同入口间的配置和会话共享以官方说明为准。 |
| [Hermes Agent](../harnesses/hermes.md) | 通用个人 Agent，结合 CLI、桌面/Web 界面、记忆和消息渠道；功能覆盖广，部署与权限边界需要认真配置。 | 想要持续运行的个人助理，或通过消息渠道远程触发多类任务。 | 有，Windows、macOS、Linux；也可使用 CLI/Web Dashboard | CLI、桌面端及 Dashboard 的本地配置和会话是否共用，需按部署方式与官方文档确认。 |

### 按使用习惯快速筛选

- **想少配置、优先用已有账号**：先看 Codex、Claude Code 或 Kimi Code，按自己已有的服务和套餐选择。
- **想自由选择模型或自己搭配**：先看 OpenCode；偏好最小化和自行扩展时看 Pi，想要 Pi 的增强功能时看 oh-my-pi。
- **主要使用桌面图形界面**：比较 Codex、Claude Code、OpenCode、DSH Desktop、Kimi Code、WorkBuddy 和 Hermes。
- **主要使用终端、远程主机或脚本**：看 Claude Code、Pi、oh-my-pi、OpenCode、Kimi Code CLI 或 Hermes CLI。
- **想搭建通用助理或消息入口**：看 Hermes；想试验 DeepSeek 的插件式 Harness，则看 DSH。

先按平台、已有账号、界面偏好和可接受的配置量筛到一两款，再用同一个小任务比较操作过程和文件差异。详细约束见[工具选择与迁移](../workflows/selection-and-migration.md)，各工具的安装和局限见上表对应指南。

## 选择下一步

- Windows 原生用户从 [Git Bash 与 PowerShell 7 环境准备](windows.md)开始。
- WSL 用户阅读 [WSL 环境准备](wsl.md)。
- macOS 和 Linux 用户阅读[对应环境准备](macos-linux.md)。
- 需要项目或工具级 Python 环境时阅读 [uv 与 Anaconda3](python-environments.md)。
- 想比较 Harness 时直接阅读[工具选择与迁移](../workflows/selection-and-migration.md)。
