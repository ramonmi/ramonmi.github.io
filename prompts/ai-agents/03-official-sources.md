# 官方资料与核验记录

## 如何使用本清单

编制日期：2026-10-22。以下链接用于后续写作取材，不是一份已完成所有命令核验的参考手册。写作时须重新读取对应版本的官方文档，并补齐本文件末尾的核验记录。

“已读取”仅指本轮读取的正文或 README 片段，不能推导出整站内容、当前精确版本或四个平台均已验证。HTTP 200、仓库存在、文档可读、命令正确和本机实测是不同层次的事实。

取材顺序：官方安装与使用文档 → 官方仓库 README 与文档目录 → 对应版本发行说明。社区资料可补充问题背景，但不能单独确立安装包身份、认证机制或平台支持。版本不明确时先读取发行说明，再选与实际发布版本匹配的文档。

## 九款工具

| 来源 ID | 工具与官方入口 | 本轮核验状态 | 后续必须核对 |
| --- | --- | --- | --- |
| S01 | [Codex CLI 文档](https://developers.openai.com/codex/cli/)、[Windows](https://developers.openai.com/codex/windows/)、[配置](https://developers.openai.com/codex/config-basic/)、[Skills](https://developers.openai.com/codex/skills/) | Windows 页面请求返回 HTTP 403；其他列为候选入口，尚未逐页读取 | 原生 Windows 与 WSL、安装与版本、认证、配置、权限、项目指令、会话、非交互与 MCP |
| S02 | [Claude Code 文档](https://code.claude.com/docs/en/overview)、[安装](https://code.claude.com/docs/en/setup)、[官方仓库](https://github.com/anthropics/claude-code) | 已读取仓库 README 的安装与文档入口；细分文档待核验 | 原生安装与包管理方式、Git Bash 要求、npm 安装的弃用状态、项目指令、权限、扩展与自动化 |
| S03 | [OpenCode 文档](https://opencode.ai/docs/)、[中文入口](https://opencode.ai/docs/zh-cn/)、[v2 入口](https://opencode.ai/v2) | 已读取文档入口，页面展示 v2 提示；具体教程版本尚未选定 | 当前默认版本与对应文档、Windows/WSL、发行包、认证、配置、项目规则、交互模式与扩展 |
| S04 | [Pi 当前项目](https://github.com/earendil-works/pi)、[旧入口](https://github.com/badlogic/pi-mono)、[官方站点](https://pi.dev) | 已读取旧入口的 coding-agent README；正文指向当前组织与包名 | 当前仓库与包名、安装器和 npm 路线、Windows shell、认证、扩展、会话、print/JSON/RPC |
| S05 | [oh-my-pi 仓库](https://github.com/can1357/oh-my-pi)、[官方站点](https://omp.sh)、[coding-agent 文档目录](https://github.com/can1357/oh-my-pi/tree/main/packages/coding-agent) | 已读取根 README 的项目关系与安装片段 | Windows 安装、二进制与运行时路线、Pi 兼容范围、配置、编辑和代码工具、扩展、自动化 |
| S06 | [DeepSeek Harness 仓库](https://github.com/deepseek-ai/deepseek-harness)、[文档站](https://deepseek-harness.github.io/deepseek-harness/)、[中文 README](https://github.com/deepseek-ai/deepseek-harness/blob/master/README.zh.md) | 已读取默认分支 `master` 的 README；确认 DSH 身份、预览状态及 Web UI 启动入口 | 受支持平台、Node.js 要求、CLI/Web UI 的实际关系、模型配置、profile、插件、权限与自动化 |
| S07 | [NousResearch Hermes Agent](https://github.com/NousResearch/hermes-agent) | 2026-10-28 读取 README、技能、记忆、工具、Cron 和 WeCom 官方资料；未本机实测 | 按版本核对工具数、配置和消息渠道；见下方取材要求 |
| S08 | [Kimi Code CLI 仓库](https://github.com/MoonshotAI/kimi-code)、[中文 README](https://github.com/MoonshotAI/kimi-code/blob/main/README.zh-CN.md)、[当前中文文档](https://moonshotai.github.io/kimi-code/zh/)、[旧 Kimi CLI](https://github.com/MoonshotAI/kimi-cli)、[迁移指南](https://moonshotai.github.io/kimi-code/zh/guides/migration) | 已读取新旧仓库 README 片段；确认旧 Python CLI 归档并指向新项目 | 新版安装与认证、Git Bash 路径配置、同名发行包区别、会话迁移范围、扩展与非交互 |
| S29 | [WorkBuddy 官方文档](https://www.workbuddy.cn/docs/workbuddy)、[产品指南](https://www.workbuddy.cn/docs/workbuddy/From-Beginner-to-Expert-Guide/Product-Guide)、[Windows 安装指南](https://www.workbuddy.cn/docs/workbuddy/From-Beginner-to-Expert-Guide/Installation-Win-Guide)、[第一个任务指南](https://www.workbuddy.cn/docs/workbuddy/FirstTask) | 2026-10-26 已读取产品定位、Windows 安装与登录、默认权限和首个任务说明；本机未安装、登录或调用任务 | 核对各平台当前安装包与系统要求、账号/组织授权、CLI 与桌面端边界、项目指令加载、MCP/Skills 支持及数据保存行为 |

### S01：Codex 的取材要求

Codex 具体功能只依据官方 OpenAI 文档。优先使用当前可用的官方文档搜索和读取能力；若遇到访问限制，记录失败方式，尝试同域官方入口。未读到对应说明前不固化模型名、参数、配置键或 Windows 支持结论。

本轮 HTTP 403 仅说明访问受限，不代表文档不存在或 Codex 不支持 Windows。下一次核验日期应使用实际读取日期，不沿用本资料包的编制日期。

### S02：Claude Code 的取材要求

名称统一为 Claude Code CLI，并解释它就是需求中的 Claude CLI。README 已将 npm 安装列为 deprecated；正文优先核对当前推荐安装路线，不将历史教程的 npm 命令自动作为首选。文档系统的路径可能调整，细分功能从安装或概览页进入。

### S03：OpenCode 的取材要求

官方文档入口存在 v2 提示。先确认默认分发版本和对应用户文档，再编写安装、配置与命令。正文应在页首标注版本，不把两个代际的配置混成同一示例。若已选择受支持的稳定版本，不为追赶文档预览而切换到未正式发布版本。

### S04：Pi 的取材要求

本轮读取的 README 指向 `earendil-works/pi`，npm 包为 `@earendil-works/pi-coding-agent`。旧入口可能通过重定向继续可读；后续应采用写作时官方指向的项目和发行包。

README 将子 Agent 和 plan mode 区分为非默认内置能力。写作时核对当前状态，区分核心功能、扩展和社区包，不能把其他 Harness 的功能套用到 Pi。

### S05：oh-my-pi 的取材要求

README 说明与 Pi 的 fork 关系，并列出二进制、Bun 等安装路线。教程独立核对配置、命令和更新方式，不能把 Pi 安装路径或包名直接替换成 oh-my-pi。是否需要 Bun、Node.js 或其他工具，按所选安装方式说明。

### S06：DSH 的取材要求

官方仓库默认分支为 `master`，不能因读取 `main/README.md` 得到 404 就判定仓库不存在。README 明示开发者预览并给出从 npm 启动 Web UI 的方式。

因此 DSH 篇应采用官方现有的界面完成实践；允许包含必要的本地 Web UI 操作，不假设一定存在与其他工具相同的终端聊天界面。profile、插件和命令行自动化需继续读取正式文档后确定。

### S07：Hermes 的取材要求

Hermes 按 NousResearch 官方项目介绍。参考[技能](https://hermes-agent.nousresearch.com/docs/user-guide/features/skills)、[记忆](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory)、[工具](https://hermes-agent.nousresearch.com/docs/user-guide/features/tools)、[Cron](https://hermes-agent.nousresearch.com/docs/user-guide/features/cron)与 [WeCom](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/wecom)。说明技能可含脚本但主体为操作指南，记忆有容量和会话快照边界，WeCom 应配置访问控制；官方当前概述为 40+ 工具，数量随版本与启用情况变化。

### S08：Kimi Code 的取材要求

旧仓库 README 说明 Python Kimi CLI 已归档，并指向 `MoonshotAI/kimi-code`。新 README 说明 Windows 使用 Git for Windows 提供的 Bash。教程应核实当前完整支持范围，并讲清旧命令、同名 PyPI 包与新发行包的区别。

迁移时核查配置、会话、登录凭据、MCP 授权和旧插件分别如何处理，不承诺所有内容自动迁移。

## 平台与基础设施候选来源

以下是后续写作的官方入口索引，本轮未逐页完成内容核验。

| 来源 ID | 官方入口 | 用途 |
| --- | --- | --- |
| S09 | [Git for Windows](https://gitforwindows.org/)、[Git 官方文档](https://git-scm.com/doc) | Git Bash 安装、Git 基础、差异与工作区检查 |
| S10 | [Windows Terminal 文档](https://learn.microsoft.com/windows/terminal/)、[WSL 安装](https://learn.microsoft.com/windows/wsl/install)、[WSL 文件系统](https://learn.microsoft.com/windows/wsl/filesystems) | 区分终端与 shell、WSL 2、跨系统目录 |
| S11 | [Ubuntu 文档](https://documentation.ubuntu.com/)、[Homebrew](https://docs.brew.sh/) | Ubuntu LTS 与 macOS 包管理示例 |
| S12 | [Node.js 下载](https://nodejs.org/en/download)、[Node.js 测试文档](https://nodejs.org/api/test.html)、[npm 文档](https://docs.npmjs.com/) | 按工具需要准备运行时、全局命令与 JavaScript 练习 |
| S13 | [Bun 安装](https://bun.sh/docs/installation)、[uv 文档](https://docs.astral.sh/uv/) | 仅在官方安装方式需要时引用 |
| S14 | [ripgrep 官方仓库](https://github.com/BurntSushi/ripgrep) | 文件搜索与 PATH 验证 |
| S30 | [Scoop 官方站点](https://scoop.sh/)、[Scoop 安装说明](https://github.com/ScoopInstaller/Install#readme) | Windows 用户态包管理器安装步骤、前置条件和 PATH 行为；执行写作时重新核验官方安装命令 |
| S31 | [fd 官方仓库](https://github.com/sharkdp/fd)、[Homebrew formula](https://formulae.brew.sh/formula/fd)、[Ubuntu fd-find 包](https://packages.ubuntu.com/search?keywords=fd-find) | fd 功能、Scoop/Homebrew/apt 包名、Ubuntu `fdfind` 命令名称及官方别名说明 |
| S32 | [Git for Windows FAQ](https://gitforwindows.org/faq.html)、[Git Bash 技术概览](https://github.com/git-for-windows/git/wiki/3.-Technical-overview) | Windows 环境变量向 Git Bash 进程传递、MSYS PATH 转换和路径表示；核对细节后避免将 Windows `Path` 与 Bash `$PATH` 混为一谈 |
| S15 | [MCP 官方文档](https://modelcontextprotocol.io/docs/getting-started/intro)、[官方参考服务器](https://github.com/modelcontextprotocol/servers) | 协议概念、只读文件访问示例，核实版本与读写边界 |
| S16 | [Agent Skills](https://agentskills.io/) | Skill 格式背景；具体 Harness 是否兼容仍依据其文档 |
| S17 | [Zensical 导航](https://zensical.org/docs/setup/navigation/)、[Markdown](https://zensical.org/docs/authoring/markdown/)、[Content tabs](https://zensical.org/docs/authoring/content-tabs/) | 验证导航与 Markdown 呈现，并与当前仓库配置对照 |

MCP 练习优先选官方文件系统参考服务器，限制为独立练习目录，并选择工具提供的只读模式或权限设置。若所选版本没有可证明的只读限制，改用经官方确认的只读工具或资源服务；不得将可写服务描述成只读服务。

## 环境、配置管理与协作来源

新增内容按学习位置进入正文：WorkBuddy 为 P15，Hermes 为第九款 Harness（P16）；PowerShell 7 和 nvm 进入平台准备页，Python 配置为 P06；CC Switch 为 P17，模型 API 协议为 P18，Herdr 为 P19，组成 Harness 之后的可选“配套工具”；AGENTS.md 进入 P21。Herdr 基础布局先学，多 Agent 实践先读 P24。下表状态不等于安装实测。

| 来源 ID | 官方入口 | 本轮读取范围与后续核验 |
| --- | --- | --- |
| S18 | [安装 PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows)、[Windows Terminal 配置](https://learn.microsoft.com/windows/terminal/customize-settings/profile-general) | 已读取安装页关于与 5.1 并存、pwsh 和安装渠道的内容；Terminal 配置与目标发行版本待写作时核验 |
| S19 | [CC Switch 仓库](https://github.com/farion1231/cc-switch)、[发行包](https://github.com/farion1231/cc-switch/releases)、[官方手册目录](https://github.com/farion1231/cc-switch/tree/main/docs/user-manual) | 根 README 部分读取成功后请求超时，手册请求超时；已读项目定位与文档入口，安装和适配细节待核验 |
| S20 | [Herdr 仓库](https://github.com/herdrdev/herdr)、[官方文档](https://herdr.dev/docs/)、[快速开始](https://herdr.dev/docs/quick-start/)、[Windows 指南](https://herdr.dev/docs/windows-beta/)、[Agent 技能说明](https://herdr.dev/docs/agent-skill/) | 已读取 README 的安装、平台和会话概念；细分文档及目标版本 CLI 待核验。本地 herdr 技能只补充作者操作约束 |
| S21 | [AGENTS.md 格式说明](https://agents.md/)、各 Harness 官方指令文档 | 格式入口已收录，实际加载、继承与优先级仍逐客户端核验，不当作所有工具的共同运行保证 |
| S22 | [nvm-windows 原入口](https://github.com/coreybutler/nvm-windows)、[当前项目候选入口](https://github.com/nvm-windows/nvm) | 当前候选 README 请求超时；写作前确认官方重定向、规范仓库、安装包和版本，不假定仓库或 CLI 始终不变 |
| S23 | [nvm-sh 官方仓库](https://github.com/nvm-sh/nvm) | README 请求超时；需核验 macOS/Linux/WSL 的安装和 shell 初始化、适用 Node 版本与更新说明 |
| S24 | [uv 安装](https://docs.astral.sh/uv/getting-started/installation/)、[Python 版本](https://docs.astral.sh/uv/concepts/python-versions/)、[项目指南](https://docs.astral.sh/uv/guides/projects/)、[工具指南](https://docs.astral.sh/uv/guides/tools/) | 已读取项目指南，确认项目、.venv、依赖、锁文件和运行的组织；安装、Python 管理和工具命令逐页待核验 |
| S25 | [Anaconda 安装入口](https://www.anaconda.com/docs/getting-started/installation)、[Conda 环境管理](https://docs.conda.io/projects/conda/en/stable/user-guide/tasks/manage-environments.html)、[Conda 包管理](https://docs.conda.io/projects/conda/en/stable/user-guide/tasks/manage-pkgs.html) | 已读取安装索引及 Conda 环境管理资料；各平台 Anaconda3 安装、shell 初始化和包管理细节待进一步核验 |
| S27 | [54yyyu/zotero-mcp 仓库](https://github.com/54yyyu/zotero-mcp)、[Getting Started](https://github.com/54yyyu/zotero-mcp/blob/main/docs/getting-started.md)、[CLI 与 agent skill](https://github.com/54yyyu/zotero-mcp/blob/main/docs/cli.md)、[Agent 指南](https://github.com/54yyyu/zotero-mcp/blob/main/docs/for-agents.md) | 2026-10-23 核验 MCP server、`zotero-cli` CLI/agent skill 两种接入方式。此来源仅支撑 Zotero 案例，不作为 RAG、memory、plugins 或 hooks 的通用概念依据；未安装、未连接 Zotero |
| S28 | [MCP 入门](https://modelcontextprotocol.io/docs/getting-started/intro)、[Agent Skills 规范](https://agentskills.io/specification)、[RAG 概述](https://learn.microsoft.com/en-us/azure/search/retrieval-augmented-generation-overview)、[Claude Code memory](https://code.claude.com/docs/en/memory)、[Claude Code hooks](https://code.claude.com/docs/en/hooks)、[Claude Code plugins](https://code.claude.com/docs/en/plugins)、[OpenCode plugins](https://opencode.ai/docs/plugins/)、[Codex plugins](https://developers.openai.com/codex/plugins/) | 2026-10-23 已读取 MCP、Agent Skills、RAG、memory、hooks、plugins 的通用资料与产品实现示例；正文应区分通用概念和客户端特定行为，九款工具支持矩阵仍需逐项依其当前官方文档核验 |

> S07 首轮仓库读取曾超时/限流；该状态已由 2026-10-22 后续官方文档复核补充，现以补记为准。S19、S20 等初次读取记录保留为历史，不代表后续没有新增阅读。

### 各专题的取材边界

- PowerShell 7 以稳定版为教程主线，不固定某个未经核对的次版本。区分安装渠道、宿主 profile 和 Agent 内部 shell；不从旧版直接复制全部配置。
- CC Switch 的支持列表和实际功能要按版本与客户端双方资料确认。使用官方提供商或占位配置演示；README 中的赞助、推广和中转服务介绍不作为教程推荐依据。核对导入、写入、备份和恢复的具体对象。
- Herdr 根据当前官方 Windows 支持说明选择原生或 WSL 路线。区分终端进程、Agent 识别状态、分离与服务重启；CLI 控制先核验受管理环境与当前命令帮助，本轮不运行控制命令。
- AGENTS.md 的内容模板与具体 Harness 的加载规则分开核对。目录分层和覆盖行为以该工具文档为准，不因文件存在就判定已生效。
- nvm-windows 与 nvm-sh 是不同项目，分别核验安装、权限、shell 初始化、版本切换和卸载步骤。nvm 管理 Node.js；npm 随所选 Node.js 安装提供，不把它写成独立 npm 管理器。
- uv 优先展示 Python 版本、项目环境、依赖和工具隔离；Anaconda3 独立展示安装和 Conda 环境管理。核查 Windows shell 与 WSL 的差异，不混用同一个环境的解释器和包管理。
- 环境创建、依赖安装与版本切换是读者教程内容；作者本机遵守已有环境注册表，本轮不实际执行安装、创建、升级或删除。

## 逐篇核验记录模板

每篇工具页写作前复制一条记录并填入本节。初始资料包不预填精确发行版本。

```text
页面 ID / 工具：
核验日期：YYYY-MM-DD
官方项目 / 当前规范地址：
目标版本 / 对应文档版本 / 提交标识：
实际读取的页面、章节与链接：
Windows 原生 / Git Bash / WSL / macOS / Ubuntu 支持证据：
安装包名、发布者、安装与版本检查命令：
依赖与最低版本：
认证方式与凭据位置：
用户 / 项目配置文件与优先级：
启动 shell / Agent 内部 shell：
已核验的会话、权限、扩展、非交互能力：
本机运行过的命令与结果（没有则明确写未运行）：
访问限制 / 尚未确认的问题：
正文引用位置：
```

## 待核验事项

- [ ] S01：恢复官方文档读取后确认 Codex 的安装与 Windows 支持细节。
- [ ] S02：读取当前 setup 与平台文档，核实原生安装、Git Bash 和历史 npm 安装的处理。
- [ ] S03：选择与当前正式发行匹配的 OpenCode 文档，不混用 v1/v2。
- [ ] S04：读取 Pi 当前仓库的版本说明及 Windows 详细指南。
- [ ] S05：核实 oh-my-pi 所选安装路线、配置迁移和进阶能力。
- [ ] S06：读取 DSH 用户指南与平台说明，区分 CLI 启动器和实际交互界面。
- [ ] S07：解除超时或限流后确认 Hermes 的官方文档、平台与功能。
- [ ] S08：读取 Kimi Code 当前安装与迁移指南，补齐版本和迁移边界。
- [ ] S09–S17：按章节需要读取对应官方页面；仅列在本表中的链接不算核验完成。

- [ ] S18–S21：核对 PowerShell 7、CC Switch、Herdr 与 AGENTS.md 的正式版本及具体平台/客户端行为。
- [ ] S22–S23：确认 nvm-windows 的当前规范项目入口，分别读取两套 nvm 的官方安装与使用说明。
- [ ] S24–S25：补齐 uv 和 Anaconda3/Conda 的各平台安装、激活、解释器检查、包管理和复现流程。

## WorkBuddy 取材要求

P15 依据 S29 介绍桌面 WorkBuddy 工作流。Windows 安装与登录、默认权限和第一个任务已于 2026-10-26 对照官方指南；平台安装包、账号授权范围、会话数据目录、项目指令加载、桌面端扩展与 CLI 自动化仍需逐项核对。默认权限说明工作空间边界和高风险确认；“允许完全访问”的影响需原文支持，不把用户提示词当权限隔离。图床图片地址和当前可核验的文件元数据见 `page-images.json`；来源信息缺失时明确保留缺口，不推断图片来源或作者。

## 2026-10-22 正文写作核验补记

本次完成首版正文并核对若干官方入口。以下“已打开”仅为文档阅读，不是安装/登录/多平台实测；未列出的功能仍需在后续审校时逐项核对。

### 2026-10-22 后续官方文档复核

| 来源 | 新读取内容 | 正文调整 / 边界 |
| --- | --- | --- |
| Hermes Agent | [当前 quickstart](https://hermes-agent.nousresearch.com/docs/getting-started/quickstart)、[安装](https://hermes-agent.nousresearch.com/docs/getting-started/installation)、[平台支持](https://hermes-agent.nousresearch.com/docs/getting-started/platform-support)、[sessions](https://hermes-agent.nousresearch.com/docs/user-guide/sessions)、[配置](https://hermes-agent.nousresearch.com/docs/user-guide/configuration)、[Windows native](https://hermes-agent.nousresearch.com/docs/user-guide/windows-native) | 更新平台分级、Windows/MSIX 与 CLI 路线、数据目录、会话恢复和 Gateway 命令；安装、认证、桌面应用仍未实测 |
| oh-my-pi | [官网文档](https://omp.sh/docs)、[Skills](https://omp.sh/docs/skills)、[MCP](https://omp.sh/docs/mcp)、[Extensions](https://omp.sh/docs/extension-authoring)、[当前 README](https://github.com/can1357/oh-my-pi)、[PowerShell 安装器](https://github.com/can1357/oh-my-pi/blob/main/scripts/install.ps1)、[Bun 安装](https://bun.sh/docs/installation)、[Homebrew 安装](https://docs.brew.sh/Installation) | 安装器、Homebrew、Bun 分别成节并给出验证命令；核对 Bun 1.3.14 条件与预编译二进制区别，补充运行时/包管理器官方安装链接；未安装 |
| CC Switch | [最新 Releases](https://github.com/farion1231/cc-switch/releases)、[安装手册](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/en/1-getting-started/1.2-installation.md)、[README 支持机制](https://github.com/farion1231/cc-switch/blob/main/README.md) | 确认截至 2026-10-22 最新为 v4.0.18；补充工具适用边界；未安装、未写入客户端配置 |
| Herdr | [安装](https://herdr.dev/docs/install/)、[Windows 支持](https://herdr.dev/docs/windows-beta/) | 确认 Windows 原生为 generally available，记录 stable 默认和平台限制；没有执行安装或会话控制 |

| 来源 | 本次实际核对 | 正文使用范围 / 未完成项 |
| --- | --- | --- |
| Codex | [Codex CLI](https://developers.openai.com/codex/cli/)、[Windows 安装说明](https://learn.chatgpt.com/docs/enterprise/windows-deployment) | 补充安装器、npm、Windows/WSL和 `codex exec` 路径；认证、配置、沙箱和 CLI 精确参数仍需按当前发行文档逐项审校 |
| Claude Code | [官方 setup](https://code.claude.com/docs/en/setup) | 安装器与 npm 分节；Windows 路线使用 Git Bash，补充 `CLAUDE_CODE_GIT_BASH_PATH` 的 settings.json 配置、路径验证和重启步骤；会话、MCP、权限具体命令仍需逐页核对，未安装 |
| OpenCode | [v2 文档](https://opencode.ai/v2/docs/)、[v2 下载](https://opencode.ai/v2) | 正文使用 v2 的 `@opencode/cli` 包名；按用户指定，Windows 路线使用 npm，安装脚本选择平台二进制。不要把文档中的 Windows package managers 限制扩大为所有 npm 安装均不可用；未在本机安装验证 |
| Pi | [Quickstart](https://pi.dev/docs/latest/quickstart)、[Windows](https://pi.dev/docs/latest/windows)、[Skills](https://pi.dev/docs/latest/skills)、[MCP](https://pi.dev/docs/latest/mcp)、[Extensions](https://pi.dev/docs/latest/extensions) | npm 与安装器并列，Windows 推荐 npm；核对 Node.js 22.19+、`--ignore-scripts`、Git Bash 依赖和各渠道更新方式；未运行命令 |
| oh-my-pi | [官方仓库](https://github.com/can1357/oh-my-pi) | README 安装节已复核，安装器/Homebrew/Bun 三条路线均已展开；认证、配置和扩展细节仍待逐项审校，未运行命令 |
| DSH | [官方仓库及 README](https://github.com/deepseek-ai/deepseek-harness)、[npm 包元数据](https://registry.npmjs.org/%40deepseek-ai/dsh/latest)、默认分支用户指南 | npm 元数据确认包提供 `dsh` 可执行命令；按用户要求优先全局安装，再用 `dsh web` 启动，README 的 npx 快速启动保留为备用；Web UI/workspace、默认端口和 headless CLI 区分已写，未安装或启动服务 |
| Hermes | [快速开始](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/getting-started/quickstart.md)、[平台支持](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/getting-started/platform-support.md) | 核对 Windows、WSL、macOS/Linux 安装和 setup/CLI 入口；Skills、memory、gateway 和安全行为需按细分文档审校 |
| Kimi Code | [当前 Getting started](https://moonshotai.github.io/kimi-code/en/guides/getting-started.html)、[迁移指南](https://moonshotai.github.io/kimi-code/en/guides/migration) | npm 安装按 Claude Code 相同结构展开，核对包名、Node.js 22.19.0+、安装器与 Windows Git Bash 依赖，补充命令来源、更新和卸载；会话与扩展命令尚未逐项审校，未安装 |
| CC Switch | [README](https://github.com/farion1231/cc-switch)、[用户手册](https://github.com/farion1231/cc-switch/tree/main/docs/user-manual)、[releases](https://github.com/farion1231/cc-switch/releases) | 核对 v4.0.18 发布入口、桌面资产与按工具支持矩阵；未实际切换配置或验证备份恢复 |
| Herdr | [安装](https://herdr.dev/docs/install/)、[快速开始](https://herdr.dev/docs/quick-start/)、本地 `herdr` skill | 核对 Windows stable 支持声明和安装入口；Herdr 控制命令只写成读者示例，未在本机执行、创建 pane 或发任务 |
| nvm-windows | [官方安装页](https://nvm-windows.com/)、[命令手册](https://docs.nvm-windows.com/commands/) | 核对 v2 项目入口及 v1/v2 命令差别；安装器未下载或运行 |
| nvm-sh | [官方仓库](https://github.com/nvm-sh/nvm) | 核对 v0.40.8 官方安装命令与 `nvm install --lts`；未改动作者环境 |
| uv / Conda | [uv 安装](https://docs.astral.sh/uv/getting-started/installation/)、[Conda 环境文档](https://docs.conda.io/projects/conda/en/stable/user-guide/tasks/manage-environments.html) | Windows 原生按用户指定使用 WinGet 或 PowerShell 安装器，安装后再回 Git Bash 验证；Linux shell 安装器仅用于 WSL/macOS/Linux。项目锁文件、工具隔离和具名 Conda 环境流程已写；Anaconda 初始化细节仍待复核 |

### 当前正文限制

工具篇现已具备页面结构、首装路径、首次任务、项目规则、权限与排障的写作框架。没有逐页读取官方命令参考的能力，不应标记为“已核验”；具体 session、快捷键、permission mode、扩展配置与 non-interactive 参数仍由下一轮审校逐项确认。本文作者未安装任何 Harness、未配置真实凭据、未调用模型，也未运行 Herdr 控制操作。

## S26：模型 API 协议、DeepSeek 接入与临时配图

核验日期：2026-10-22。新增 P18 正文；其余后续页面编号已顺延。以下均为官方资料阅读；未配置真实密钥、未写入本机客户端配置、未发送模型请求。

| 官方资料 | 已核对范围 |
| --- | --- |
| [OpenAI Responses 迁移指南](https://developers.openai.com/api/docs/guides/migrate-to-responses/)、[Codex 配置参考](https://developers.openai.com/codex/config-reference/) | Chat Completions 与 Responses 的结构差异；当前 Codex 的 wire_api 只支持 responses |
| [Anthropic Messages API](https://platform.claude.com/docs/en/api/messages/create) | 消息与内容块、system/max_tokens、认证头及工具调用格式 |
| [DeepSeek Responses](https://api-docs.deepseek.com/zh-cn/guides/responses_api/)、[Codex 集成](https://api-docs.deepseek.com/quick_start/agent_integrations/codex/) | DeepSeek 原生 Responses、Base URL、模型目录与客户端要求；不再将 DeepSeek 一律写成仅 Chat 上游 |
| [DeepSeek Anthropic 兼容](https://api-docs.deepseek.com/zh-cn/guides/anthropic_api)、[Claude Code 集成](https://api-docs.deepseek.com/zh-cn/quick_start/agent_integrations/claude_code) | 专用 /anthropic 地址、Claude Code 认证和模型角色映射 |
| [CC Switch 添加提供商](https://github.com/farion1231/cc-switch-website/blob/main/public/docs/zh/2-providers/2.1-add.md)、[Codex 预设源码](https://github.com/farion1231/cc-switch/blob/v4.0.18/src/config/codexProviderPresets.ts) | 当前 DeepSeek 预设使用原生 Responses；旧供应商卡片仍可能保留旧配置；模型目录与路由格式的区别 |
| [CC Switch 路由服务](https://github.com/farion1231/cc-switch-website/blob/main/public/docs/zh/4-proxy/4.1-service.md)、[DeepSeek 路由教程](https://github.com/farion1231/cc-switch-website/blob/main/public/docs/tutorials/zh/codex-deepseek-routing-guide.md) | Chat 转换的可选路线、本地路由与 Codex 接管；旧截图不作为当前 DeepSeek 必须路由的证据 |

配图原始来源目录：`docs/assets/ai-agents/protocols-temp/`。三张官方 PNG 均已审阅；正文采用表单和接管两张，二者已上传并验证。备用图 `01-codex-providers-require-routing.png` 已由用户从本地和图床删除。图片原始地址、大小、SHA-256、引用页面、图床状态和本地留存情况见 [图片清单](protocol-images.json)。

正文引用的两张图片通过公开访问检查，Markdown 使用对应图床地址；三张图的本地副本均已删除。备用图不再有可用图床地址，也未嵌入正文。

## S27：P22 扩展概念与 Zotero MCP 示例

核验日期：2026-10-23。读取 [项目 README](https://github.com/54yyyu/zotero-mcp)、[Getting Started](https://github.com/54yyyu/zotero-mcp/blob/main/docs/getting-started.md)、[CLI 与 agent skill](https://github.com/54yyyu/zotero-mcp/blob/main/docs/cli.md) 和 [Agent 指南](https://github.com/54yyyu/zotero-mcp/blob/main/docs/for-agents.md)。该项目作为 MCP server 与 `zotero-cli`/Skill 两种接入路线的案例；本节其他概念必须依据通用协议资料和各 Harness 官方文档解释。写作前重新核对最新包名、命令、权限与客户端支持。未安装、未启动服务或访问 Zotero library。
