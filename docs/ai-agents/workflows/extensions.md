---
title: Skills、MCP 与扩展
description: 区分项目指令、Skills、MCP、插件和 hooks，按客户端机制启停扩展。
---

# Skills、MCP 与扩展

本页介绍扩展类别和安全验证方法。各 Harness 的格式、加载路径及支持状态不同；安装前查对应工具官方文档。先读[项目指令与 AGENTS.md](project-instructions.md)。

## 先判断需要哪类扩展

项目规则用于约束协作；Skill 是可复用的任务说明（具体加载机制因工具不同）；MCP 为 Agent 提供外部工具/资源协议；插件可打包多个功能；hook 在特定生命周期触发脚本。不要把它们视为统一插件系统。

## 八款工具的核验方式

| 工具 | 查阅位置 | 注意 |
| --- | --- | --- |
| Codex | [官方文档](https://developers.openai.com/codex/) | 只按当前受支持的 Skills/MCP 说明配置 |
| Claude Code | [官方文档](https://code.claude.com/docs/en/overview) | 核对 Skills、MCP、hooks 与插件的版本 |
| OpenCode | [官方文档](https://opencode.ai/docs/) | 使用对应发行线配置格式 |
| Pi | [官网文档](https://pi.dev/docs/latest/) · [Skills](https://pi.dev/docs/latest/skills) · [MCP](https://pi.dev/docs/latest/mcp) · [Extensions](https://pi.dev/docs/latest/extensions) | 按 Pi 当前版本核对加载目录、配置格式和扩展 API |
| oh-my-pi | [官网文档](https://omp.sh/docs) · [Skills](https://omp.sh/docs/skills) · [MCP](https://omp.sh/docs/mcp) · [Extensions](https://omp.sh/docs/extension-authoring) | 按 omp 文档核对自身配置与兼容范围，不直接套用 Pi 的扩展 |
| DSH | [官方仓库](https://github.com/deepseek-ai/deepseek-harness) | 预览版能力会变 |
| Hermes | [官方仓库](https://github.com/NousResearch/hermes-agent) | 区分本地 Skills 与可选服务 |
| Kimi Code | [官方文档](https://moonshotai.github.io/kimi-code/en/guides/getting-started.html) | 不沿用旧版 CLI 能力描述 |

## 先从本地 Skill 开始

可将一个 Skill 做成目录内说明文件，写明触发场景、输入、步骤和输出；但必须按所用客户端当前格式命名并放到受支持目录。练习内容：检查一个 Markdown 页面中的标题、相对链接和围栏闭合，输出问题位置，不自动修改文件。先手动运行，再通过工具官方机制加载；不支持通用 Skill 时，直接把检查清单作为任务提示。

## 配置 MCP

![MCP 在 AI 应用与数据源、工具之间的连接关系](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/mcp-architecture.png){ loading=lazy width="900" }

*来源：[Model Context Protocol 官方入门文档](https://modelcontextprotocol.io/docs/getting-started/intro)。图示解释 MCP 的连接角色，不代表每个 Harness 都支持相同配置格式。*

只添加可信服务器，核实运行命令、参数、环境变量和权限；测试时避免传入私人资料。先在官方配置入口创建单个服务器，重启客户端，再检查工具列表并执行只读动作。需要密钥时用环境变量/密钥管理器，避免写入版本控制。每个客户端可有不同配置格式。

## 插件与 hooks

安装前读代码来源、发布者、权限和升级机制。hook 可能自动执行本地命令，先理解触发事件和脚本副作用；先在练习仓库验证。停用时禁用入口并重启，再检查子进程和配置残留。

## 排障与验收

扩展未出现时核对路径、格式、客户端版本和重启要求；MCP 连接失败时分开检查可执行文件、环境变量、网络和协议日志。验收：能指出扩展来源、权限、启动机制和停用方式；完成一次只读功能验证后再开放写操作。
