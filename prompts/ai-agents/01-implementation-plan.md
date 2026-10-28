# AI Agents 栏目实施计划

## 目标与读者

读者应能从环境准备开始，安装并配置九款 Harness 中的一款，完成可检查的任务，掌握会话、项目指令、扩展和维护方法，再根据需要迁移到其他工具。

默认读者会使用电脑，但不默认熟悉终端、Git、API Key 或模型提供商。基础概念集中讲解，九款 Harness 共享平台环境教程，通过相对链接引用，避免重复相同的环境步骤。

Windows 环境准备在同一页讲清 Git Bash 与 PowerShell 7 的安装、验证和分工，并说明 Windows PowerShell 5.1、Windows Terminal 的区别。日常操作以 Git Bash 为主。工具不支持某条路线时，说明官方支持状况，并提供可行路线。macOS 与 Ubuntu LTS 提供完整的安装、认证入口和验证步骤；不将 Ubuntu 命令标成通用 Linux 命令。

P03 将 `rg`（ripgrep）和 `fd` 的介绍与安装放在同一节；Windows 安装路线使用 Scoop，先安装 Scoop，再用 Scoop 安装两款工具。PATH 独立成节，说明 Windows 用户/系统环境变量与进程环境的继承关系，以及 Git Bash 如何从 Windows 环境获取并转换 PATH；不把 Git Bash 中的 `$PATH` 与 Windows 设置界面中的 `Path` 说成完全相同的表示。P04 Ubuntu 基础工具安装包含 `fd-find`，解释 Ubuntu 包名与 `fdfind` 命令名，并给出可选 `ln -s` 命令别名的做法。P05 同时覆盖 macOS 和 Linux 的 Git、ripgrep、fd 安装与验证，并区分 Homebrew 和 Ubuntu/Debian 包名。

## 交付范围

核心规划由 `prompts/ai-agents/` 下的七份 Markdown 文件组成：入口、计划、大纲、来源、规范、提示词、验收清单。正文、`zensical.toml` 导航和首页入口已接入；协议页与配图已完成，图片上传状态和地址见配图清单。

正文共 27 页。页面路径、ID 和标题以 [详细内容大纲](02-content-outline.md) 的页面清单为准。工具篇每篇均覆盖从安装到使用和维护的完整流程；工具独有能力按官方支持情况展开。

PowerShell 7 合并进 Windows 环境准备（P03），AGENTS.md 撰写实战合并进项目指令与上下文管理（P21），不重复开页。九款 Harness 排在 P08–P16；CC Switch 配置管理（P17）、模型 API 协议与接入（P18）、Herdr 终端协作（P19）各自保留一页。

全栏目按学习依赖连续编号：概念与平台环境 → Node.js/npm 和 Python 环境 → 第一次任务与 Harness → 配套工具（CC Switch 配置切换 → API 协议与 DeepSeek 接入 → Herdr 终端组织，可跳过）→ 日常工作流 → 项目指令 → 扩展 → 选择与迁移 → 自动化与协作 → 参考维护。Herdr 的基础布局不依赖自动化知识，多 Agent 部分先读 P24 再返回实践。选择与迁移页也从栏目首页提供直达入口，方便尚未选工具的读者跳读。

WorkBuddy 单独介绍桌面工作流，Hermes 作为第九款 Harness 介绍学习闭环和消息网关；其他桌面应用、IDE 集成、消息平台部署和远程服务不另开页面。依赖、主题、CI 配置不因写作任务而升级。

## 运行时环境的组织

Node.js 与 npm 放入各平台环境准备页：Windows 原生使用官方 nvm-windows 路线，WSL/macOS/Linux 使用 nvm-sh。先检查现有 Node 安装与 PATH，再介绍安装、选择适用 LTS、切换、验证与全局包差异。nvm 管理 Node.js 版本，npm 随所选 Node.js 提供；单独升级 npm 不是默认步骤。两种 nvm 的安装、命令和权限分别核验。

Python 单独安排 P06，位于平台准备之后。优先讲 uv 的安装、解释器来源、项目 .venv、依赖与锁文件、uv run/sync、工具环境与复现；随后讲 Anaconda3 安装、Conda base 与具名环境、激活退出、包管理及和 uv 的共存。两者不互相覆盖环境，不要求为全部 Harness 同时安装。解释读者练习与本机作者环境的区别；本轮仍不安装、创建或修改环境。

## 未来导航配置

以下为未来完整 `nav` 候选值。执行阶段保留当时实际存在的 Home、Miscellaneous、About 配置，将 AI Agents 插入 Home 之后；已有栏目后来出现新页面时不可用本示例覆盖它们。

```toml
nav = [
  { "Home" = "index.md" },
  { "AI Agents" = [
    "ai-agents/index.md",
    { "入门与环境" = [
      { "认识 AI Agents 与 Harness" = "ai-agents/getting-started/concepts.md" },
      { "Windows 环境准备：Git Bash 与 PowerShell 7" = "ai-agents/getting-started/windows.md" },
      { "WSL 环境准备" = "ai-agents/getting-started/wsl.md" },
      { "macOS 与 Linux 环境准备" = "ai-agents/getting-started/macos-linux.md" },
      { "Python 环境配置：uv 与 Anaconda3" = "ai-agents/getting-started/python-environments.md" },
      { "完成第一个 Agent 任务" = "ai-agents/getting-started/first-task.md" },
    ]},
    { "Harness" = [
      { "Codex CLI" = "ai-agents/harnesses/codex.md" },
      { "Claude Code CLI" = "ai-agents/harnesses/claude-code.md" },
      { "OpenCode" = "ai-agents/harnesses/opencode.md" },
      { "Pi" = "ai-agents/harnesses/pi.md" },
      { "oh-my-pi" = "ai-agents/harnesses/oh-my-pi.md" },
      { "DSH" = "ai-agents/harnesses/dsh.md" },
      { "Kimi Code CLI" = "ai-agents/harnesses/kimi-code.md" },
      { "WorkBuddy" = "ai-agents/harnesses/workbuddy.md" },
      { "Hermes Agent" = "ai-agents/harnesses/hermes.md" },
    ]},
    { "配套工具" = [
      { "CC Switch 安装与配置" = "ai-agents/tools/cc-switch.md" },
      { "模型 API 协议与接入" = "ai-agents/tools/api-protocols.md" },
      { "Herdr 安装与使用" = "ai-agents/tools/herdr.md" },
    ]},
    { "工作流与协作" = [
      { "日常开发工作流" = "ai-agents/workflows/daily-development.md" },
      { "项目指令、AGENTS.md 与上下文管理" = "ai-agents/workflows/project-instructions.md" },
      { "Skills、MCP 与扩展" = "ai-agents/workflows/extensions.md" },
      { "工具选择与迁移" = "ai-agents/workflows/selection-and-migration.md" },
      { "自动化与多 Agent 协作" = "ai-agents/workflows/automation.md" },
    ]},
    { "参考" = [
      { "常见问题与排障" = "ai-agents/reference/troubleshooting.md" },
      { "术语与命令速查" = "ai-agents/reference/glossary-and-cheatsheet.md" },
      { "版本核验与教程维护" = "ai-agents/reference/maintenance.md" },
    ]},
  ]},
  { "Miscellaneous" = [
    "miscellaneous/index-miscellaneous.md",
    { "Zotero笔记标签页css设置" = "miscellaneous/Zotero-noteTab-wideContentView.md" },
    { "Rime输入统计" = "miscellaneous/Rime-input-count.md" },
    { "Rime保存英文自造词" = "miscellaneous/Rime-ice-en-words.md" },
  ]},
  { "About" = "about-me.md" },
]
```

栏目首页作为章节索引；其余五组直接列出页面，不额外创建分组索引，因此总页数为 27。接入后从站点首页增加一个简短入口，链接 `ai-agents/index.md`。页面编号、大纲排列与导航阅读顺序保持一致；Hermes 排在 WorkBuddy 后作为第九款 Harness。

## 共用实践项目

所有入门与工具篇采用同一个小型 Git 仓库 `agent-lab`，由 P07 给出读者可复制的初始化步骤。示例初始文件为 `README.md`、`notes/workflow.md`、`.gitignore`，不依赖 Python、Node.js 或其他应用框架。

统一任务是让 Agent 读取现有文档，在 `notes/workflow.md` 中增加“完成标准”，补充三项可检查要求，然后审阅 `git diff`。读者应观察“先了解项目、确认任务、修改文件、检查结果”的过程，不能把模型回复“完成”当成验收。

P20 再提供独立的 JavaScript 小练习：`src/sum.mjs` 与 `test/sum.test.mjs`，展示错误复现、修复和使用 Node 内置测试的工作流。运行时要求在该节单独说明，不反向增加入门项目的依赖。本轮只规划这些示例，不创建示例源码或执行模型任务。

配套练习在独立目录或复制的练习配置中进行：P03 比较 Git Bash 与 PowerShell 7 的路径、变量和命令来源；P21 为 agent-lab 编写根目录与子目录指令；P17 展示备份后切换配置并恢复，不碰真实密钥；P19 先组织两个普通终端，再以可选例子协调已安装 Agent。所有操作均写成读者练习，本轮不安装软件或控制终端会话。

## 分阶段执行

| 阶段 | 任务 | 完成条件 |
| --- | --- | --- |
| A：资料包 | 建立本目录七份文件，统一页面与来源记录 | 大纲、导航、提示词和清单一致 |
| B：基础正文 | 完成 P02–P07，建立共用练习 | Git Bash、PowerShell 7、nvm、uv/Conda 及 Windows/WSL/macOS/Linux 的边界清楚 |
| C：工具正文 | 依次完成 P08–P16 | 每篇完成安装到实战的闭环，并记录核验依据 |
| D：配套工具与工作流 | 按 P17–P24 顺序完成 | 先介绍配置切换、API 协议与终端组织，再展开日常工作流、项目指令、扩展与协作 |
| E：参考与汇总 | 完成 P25–P27，再完善 P01 | 比较、速查、排障、维护和入口与正文一致 |
| F：接入与验收 | 插入导航、添加首页入口、构建并检查呈现 | 27 页可访问，导航顺序正确，无新增内容问题 |

后续完整写作任务默认授权以上 B–F 阶段和文档构建；单章任务只授权指定章及相关记录。完成一页即更新 [进度表](06-acceptance-checklist.md)，状态不足时准确记录原因，不等待全部完成才记录。

## 事实与质量控制

- 每篇先读取官方资料，再写命令、配置和平台支持；精确版本在写作时确定并记录。
- 核验安装包发布者、项目地址和配置格式，尤其关注同名包、仓库迁移与预览版本。
- 用同一套实践目标展示工具差异，保留各工具实际的界面、命令和权限机制。
- 文档核验与运行实测分开记录；不在本机安装九款 Harness 或调用付费 API 进行验证。
- PowerShell 7、CC Switch、Herdr 也仅核验资料并编写教程，不在本机安装、切换真实提供商配置或操控 Herdr 会话。
- CC Switch 的适用客户端与版本须逐项查证；Herdr 中多个 pane 不等于 Harness 内置多 Agent；AGENTS.md 是否加载须按具体客户端确认。
- 使用现有 Zensical 特性，遵守四空格缩进和相对 Markdown 链接。
- 依赖环境不可用时记录构建阻塞，不能自行创建、升级或修复本机环境。

## 后续验收与交付

正文完成后，按 [验收清单](06-acceptance-checklist.md) 检查事实、链接、导航与呈现。在既有可用环境下运行 `uv run zensical build --clean`，有可用预览条件时检查宽屏、移动宽度和浅深色呈现。

最终交付报告列出完成页面、修改文件、官方资料核验范围、构建结果及未实测的平台。没有实际安装或调用工具时明确记录，不写“所有平台测试通过”。不自动提交、推送或部署。

## 协议页和配图阶段

P18 以 DeepSeek 官方 API 演示 Responses、Anthropic 两条原生接入与可选 Chat 转换，当前 Codex 的 `wire_api` 仅配置 `responses`。配图来源、哈希、本地留存情况及图床地址见 `protocol-images.json`；正文已引用经检查的图床链接。
