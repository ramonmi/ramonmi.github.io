# AI Agents 栏目写作资料包

本资料包用于规划和验收 Ramon's Notes 的 AI Agents 栏目。正文已按 26 页大纲起草，需以 06-acceptance-checklist.md 区分草稿、资料核验、静态审校、构建和部署状态。内容以中文呈现，Windows 日常操作以 Git Bash 为主，兼顾 WSL、macOS 与 Linux。

## 交付边界

规划资料位于 prompts/ai-agents/；26 个正文页面位于 docs/ai-agents/。站点导航顺序为 Home → AI Agents → Miscellaneous → About。

规划资料位于 docs/ 之外，不参与站点构建。正文起草不代表所有产品事实均已核验，也不代表站点已经构建或部署。

## 阅读顺序

1. [实施计划](01-implementation-plan.md)：确定页面、导航、阶段和交付边界。
2. [详细内容大纲](02-content-outline.md)：查看每页的目标、先修知识、二三级标题与验收要求。
3. [官方资料与核验记录](03-official-sources.md)：从官方入口核实身份、版本和命令。
4. [写作与 Zensical 规范](04-writing-rules.md)：统一平台命令、页面结构和语法。
5. [Codex 写作提示词](05-codex-writing-prompt.md)：复制总任务或单章提示词启动写作。
6. [验收清单与进度](06-acceptance-checklist.md)：更新完成状态，执行内容审校与最终验收。

## 如何交给 Codex

完整撰写时，将 [写作提示词](05-codex-writing-prompt.md) 的“完整写作任务”代码块作为任务发给 Codex。该任务覆盖全部 26 页和最终站点接入。

分章撰写时，复制“单章任务”，将页面编号替换为大纲中的 P01–P26，例如 P08 对应 Codex CLI。分章模式只处理指定页面及必要的记录，不提前加入指向未完成页面的站点导航。

页面按最终阅读顺序连续编号：先准备环境、学习 Harness，再按需使用配套工具，随后进入日常工作流、项目指令、扩展、迁移和自动化。PowerShell 7 与 Git Bash 合并在 P03；配套工具依次为 P16 CC Switch、P17 模型 API 协议与接入、P18 Herdr；AGENTS.md 撰写与上下文管理合并在 P20。Python 环境配置为 P06。Herdr 基础布局先学，多 Agent 部分先读 P23 的分工与隔离原则再实践。页面编号、详细大纲和导航顺序一致。

上下文中断后，使用“续写任务”，先读进度和来源记录，再继续下一项。审校时使用“审校任务”。

## 固定约定

| 项目 | 决定 |
| --- | --- |
| 初始编制日期 | 2026-10-22 |
| 正文根目录 | `docs/ai-agents/` |
| 当前页数 | 26 页：栏目首页 1、入门 6、Harness 8、配套工具 3、工作流与协作 5、参考 3 |
| Windows 主线 | 同一页覆盖 Git Bash 与 PowerShell 7 安装、验证和分工，日常示例以 Git Bash 为主 |
| Node.js/npm 管理 | Windows 原生按 nvm-windows，WSL/macOS/Linux 按 nvm-sh；npm 随所选 Node.js 版本提供 |
| Python 环境 | 优先 uv，兼顾 Anaconda3/Conda，解释项目环境、工具环境与解释器来源 |
| WSL 路线 | WSL 2，默认以 Ubuntu LTS 展示完整流程 |
| macOS/Linux | 分别提供操作步骤，Linux 默认以 Ubuntu LTS 展示 |
| 工具范围 | Codex CLI、Claude Code CLI、OpenCode、Pi、oh-my-pi、DSH、Hermes Agent、Kimi Code CLI |
| 配套专题 | CC Switch 配置管理、Herdr 终端组织与协作、AGENTS.md 撰写实战 |
| DSH 身份 | DeepSeek Harness，以官方仓库为依据 |
| 首版平台深度 | Windows 主线详讲；其他平台有独立、可操作的安装和验证流程 |

## 当前完成状态

26 个目标文件已建立，导航和首页入口已接入。工具页仍需逐项按官方当前版本核实安装、认证、配置、会话、扩展和自动化细节；作者未在各平台安装或运行 Harness，也未调用模型。构建与呈现检查见验收清单，不要把草稿状态表述为已发布。

## 协议页配图的临时工作状态

协议页图片来源、哈希、图床地址和本地文件状态见 [图片清单](protocol-images.json)。正文引用的两张截图已上传并验证；备用图 `01-codex-providers-require-routing.png` 已由用户从本地和图床删除，清单保留其历史地址和删除状态。

## 其他页面配图

Windows、WSL、Python 环境、Codex、Claude Code、OpenCode、Pi、oh-my-pi、DSH、Kimi Code、Hermes、CC Switch、Herdr、MCP 和 Git 工作流等页面已补充界面图或示意图。来源、大小、SHA-256、审阅范围、正文引用页和图床地址见 [页面配图清单](page-images.json)。这些图片已上传并验证，正文使用图床链接，本地副本已清理。
