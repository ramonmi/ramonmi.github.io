---
title: Skills、MCP 与扩展
description: 比较 prompts、Skills、MCP、RAG、memory、plugins 与 hooks，并用 Zotero 说明 MCP 和 Skill 的区别。
---

# Skills、MCP 与扩展

本页面向已完成[项目指令与 AGENTS.md](project-instructions.md)基础配置、准备增加可复用流程或外部能力的读者。先区分这些机制各自解决的问题，再按客户端支持情况选择。下文的产品能力核验日期为 **2026-10-23**；没有逐款安装或连接实测，具体格式、加载路径、权限与当前支持状态以链接的官方资料为准。

## 先判断需要哪类能力

这些机制可以配合使用，但处于不同层次。Prompt 提供当前任务要求；项目指令提供长期协作约束；Skill 教 Agent 如何重复完成某类工作；MCP 连接外部工具和数据；RAG 与 memory 处理“需要哪些知识”；plugin 是客户端扩展的打包方式；hook 在指定事件发生时自动执行动作。

| 机制 | 主要解决的问题 | 擅长什么；什么时候用 | 边界与常见组合 |
| --- | --- | --- | --- |
| Prompt（提示词） | 这一次要做什么、范围和结果格式是什么？ | 当前任务的目标、约束、示例和输出要求；临时任务通常直接写 prompt，重复任务可保存成模板 | 内容进入当前模型上下文，不自动提供新工具，也不保证跨会话保存；可引用项目指令、调用 Skill 或使用 MCP 工具 |
| 项目指令 | 在这个仓库里始终遵守哪些规则？ | 代码约定、目录边界、验证方法和协作偏好；规则需要每次项目任务都生效时使用 | 由客户端读取指定文件，支持范围和优先级因工具而异；不等于任务 prompt，也不会自动安装工具。见[项目指令专题](project-instructions.md) |
| Skill | 如何按固定步骤完成一类任务？ | 可复用流程、检查清单、领域知识和按需参考资料；同一任务反复出现或需要稳定步骤时使用 | 主要提供 Agent 可读取的说明和资源；Skill 本身不一定执行代码、提供权限隔离或连接服务。它可以指导 Agent 使用 shell、MCP 或其他工具 |
| MCP | 如何用统一协议把客户端接到外部工具或数据源？ | 需要让 Agent 搜索资料库、调用业务 API、操作开发工具或访问资源时使用 | MCP 定义客户端与服务器之间的交互方式，不是某个特定 Zotero/数据库，也不是模型 API；具体服务器可以有读写能力，权限取决于服务器、客户端和认证配置 |
| RAG（检索增强生成） | 怎样让回答基于一组可检索的外部资料？ | 文档量大、内容会更新、需要基于证据回答并能追溯来源时使用；系统先检索相关片段，再将其交给模型生成回答 | 是一种检索与生成的应用模式，不是协议或记忆格式。通常需要数据切分、索引/搜索和引用处理；可经 MCP 暴露检索工具，也可内置在应用或插件里 |
| Memory（记忆） | 哪些信息应在不同任务或会话间保留下来？ | 稳定偏好、项目事实、用户确认过的决定或持续任务状态；需要减少重复交代时使用 | 实现可能是文件、数据库、摘要或产品内存储；必须考虑时效、来源、隐私、纠错和删除。它不等于完整聊天记录，也不适合代替对大型资料库的 RAG 检索 |
| Plugin（插件） | 怎样按某客户端支持的方式安装和分发一组扩展？ | 希望打包多个能力、集中安装升级，或扩展应用界面和工作流时使用 | 是客户端定义的扩展/分发载体，不是跨产品统一标准；可能包含工具、Skills、hooks、MCP 配置或 UI，但具体组成因产品而异 |
| Hook（钩子） | 在某个生命周期事件发生时，怎样自动执行固定动作？ | 在工具调用前后验证、会话开始时加载上下文、任务结束时格式化或通知等可重复自动化 | 由事件触发，行为通常由脚本/程序决定；不等同于 prompt，也未必是插件。需检查触发条件、输入输出、错误处理和副作用 |

这些机制通常组合工作：项目指令约束所有任务，prompt 描述当前目标，Skill 提供流程；Skill 可引导 Agent 调用 MCP 工具，MCP 工具背后可使用 RAG 检索；memory 保存少量长期有效的信息；plugin 可以按某客户端的格式打包其中几项，hook 则在确定的生命周期自动运行。

## 按任务选择

- **只做一次且范围清楚**：写好 prompt，并明确输入、文件范围和验收结果。
- **同一流程反复做**：抽取成 Skill；若规则需要对仓库每次都生效，放进项目指令。
- **需要 Agent 访问外部应用或执行操作**：查看客户端是否支持 MCP，选择可信服务器并只开放任务所需能力。
- **需要从大量、持续变化的文档中找证据**：评估 RAG 的资料来源、更新频率、检索质量和引用方式。
- **需要跨会话记住少量稳定事实**：使用有明确查看、修改和删除方式的 memory 功能。
- **要把多个扩展作为一个产品单元安装，或要自动响应生命周期事件**：评估该客户端的 plugin 和 hook 机制，先读清它实际会运行什么。

不要只因为名称相似就互换机制：RAG 解决“从资料中找哪些内容作为回答依据”，memory 解决“哪些信息需要留到之后”；MCP 解决系统连接，Skill 解决可复用的操作说明；plugin 的范围由客户端决定，hook 则围绕事件自动运行。

## 九款工具的支持入口

下表列官方能力说明入口，供写作和配置时核对。它不是兼容性承诺：同名能力的格式、作用范围和版本要求可能不同；“扩展”也不意味着一定采用名为 plugin 的系统。请在安装前打开对应工具当前文档，并以页面标明的核验日期判断。

| 工具 | Skills / MCP / 扩展的官方入口 | 使用时注意 |
| --- | --- | --- |
| Codex | [Skills](https://developers.openai.com/codex/skills/) · [MCP](https://developers.openai.com/codex/mcp/) · [Plugins 与 plugin hooks](https://developers.openai.com/codex/plugins/) | 官方页面明确有 Skills、MCP 和 plugins；hook 作为 plugin 组件说明。配置与 hook 的运行环境按 CLI/IDE/云端分别核对 |
| Claude Code | [Skills](https://code.claude.com/docs/en/skills) · [MCP](https://code.claude.com/docs/en/mcp) · [Hooks](https://code.claude.com/docs/en/hooks) · [Plugins](https://code.claude.com/docs/en/plugins) · [Memory](https://code.claude.com/docs/en/memory) | 上述机制各有官方页面；hooks 会运行配置的命令，memory 与项目指令也有不同作用，按页面权限边界配置 |
| OpenCode | [Agent Skills](https://opencode.ai/docs/skills/) · [MCP servers](https://opencode.ai/docs/mcp-servers/) · [Plugins / events](https://opencode.ai/docs/plugins/) | 官方页面明确有 Skills、MCP servers 和插件 API/events；具体事件能力按 API 核对 |
| Pi | [Skills](https://pi.dev/docs/latest/skills) · [MCP](https://pi.dev/docs/latest/mcp) · [Extensions / events](https://pi.dev/docs/latest/extensions) | 官方以 extensions 提供扩展点；不要把别的产品的 plugin/hook 配置直接复制过来 |
| oh-my-pi | [Skills](https://omp.sh/docs/skills) · [MCP](https://omp.sh/docs/mcp) · [Hooks](https://omp.sh/docs/hooks) · [Plugins / extensions](https://omp.sh/docs/extension-authoring) | 各机制有专门文档入口；依据 omp 自身文档和版本配置，不假定与 Pi 扩展兼容 |
| DSH | [官方仓库](https://github.com/deepseek-ai/deepseek-harness) · [文档站](https://deepseek-harness.github.io/deepseek-harness/) | 项目称采用 plugin 架构且处于 developer preview；其他机制的支持需逐版本从文档确认，不推断其都兼容 MCP 或 Agent Skills |
| Hermes Agent | [Skills](https://hermes-agent.nousresearch.com/docs/user-guide/skills) · [MCP](https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp) · [Plugins](https://hermes-agent.nousresearch.com/docs/user-guide/features/plugins) · [Hooks](https://hermes-agent.nousresearch.com/docs/user-guide/features/hooks) · [Memory](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory) | 官方分别说明这些功能；Hermes 的 memory provider 也可作为特定插件类型，不能据此推断其他产品实现相同 |
| Kimi Code | [Agent Skills](https://moonshotai.github.io/kimi-code/en/customization/skills.html) · [MCP](https://moonshotai.github.io/kimi-code/en/customization/mcp.html) · [Plugins](https://moonshotai.github.io/kimi-code/en/customization/plugins.html) · [Hooks](https://moonshotai.github.io/kimi-code/en/customization/hooks.html) | 官方分别说明 Skills、MCP、plugins 和 hooks；按版本查触发行为、信任确认与会话生效时机 |
| WorkBuddy | [官方文档](https://www.workbuddy.cn/docs/workbuddy) · [产品指南](https://www.workbuddy.cn/docs/workbuddy/From-Beginner-to-Expert-Guide/Product-Guide) | 桌面端与 CLI 的扩展入口可能不同；以当前 WorkBuddy 文档中的版本、账号和平台要求为准 |

Agent Skills 的开放格式背景可参考 [Agent Skills 规范](https://agentskills.io/)。具体客户端是否支持该格式、如何发现 Skill，仍以客户端文档为准。MCP 协议概念见[官方入门](https://modelcontextprotocol.io/docs/getting-started/intro)；其官方工具目录并不意味着其中每个服务器都适合当前任务。

## 用 Zotero 对照 MCP 与 Skill

[54yyyu/zotero-mcp](https://github.com/54yyyu/zotero-mcp) 同时提供 MCP server 与 `zotero-cli` 工作流，适合用来比较两种接入方式。以下只把它作为 MCP 和 Skill 的具体案例；上文的 RAG、memory、plugins 和 hooks 是通用概念，不依赖这个项目。

| 路线 | Agent 如何接触 Zotero | 适合的情况 |
| --- | --- | --- |
| MCP server | 将服务器按所用客户端的格式注册；客户端连接后发现服务器提供的工具，再通过 MCP 调用 Zotero 查询或操作 | 客户端支持 MCP，但任务环境不适合直接调用 CLI；或希望通过统一协议连接外部工具 |
| `zotero-cli` + Skill | Skill 提供何时使用及如何组织 CLI 调用的说明；Agent 在有 shell 的环境中运行 `zotero-cli` 命令，CLI 再访问 Zotero | Agent 可用 shell，想直接组合命令、JSON 输出和脚本流程；或希望通过 Skill 复用 Zotero 操作步骤 |

这里的 Skill 不是服务器，也不是 CLI：Skill 是 Agent 可读取的操作指南，真正访问 Zotero 的是 `zotero-cli` 程序。MCP 则由服务器提供可发现的工具接口，客户端负责连接和调用。选哪条路线要看 Agent 客户端支持、运行位置和权限配置。

若只做检索，可先用 CLI 搜索标题或主题，再按条目 key 读取元数据、全文或指定页段；MCP 路线则先在客户端查看已发现的工具，再执行等价的只读查询。该服务也提供写入工具，因此先做查询不表示服务器本身受到只读权限限制。需要写入时，先阅读该项目当前授权说明并检查目标条目。项目说明本地写入需要授权，远程访问则需配置 Zotero API 凭据；密钥不得写进 prompt、Skill 文件或仓库。所有具体命令和权限要求以项目当前 [README 与文档](https://github.com/54yyyu/zotero-mcp/tree/main/docs)为准。

## 编写一个本地 Skill

Skill 应写清适用场景、输入、步骤和结果，让 Agent 在触发任务时读取。下面是一个通用 Markdown 检查 Skill 的最小结构示例；只有确认客户端支持该格式并放在它能发现的目录后，才可按 Skill 调用。示例中的检查要求是任务约束，不构成文件系统权限隔离。

```text
markdown-check/
└── SKILL.md
```

```markdown title="SKILL.md"
---
name: markdown-check
description: Check a Markdown file's headings, relative links, and fenced code blocks. Use when asked to review Markdown without editing it.
---

# Markdown check

1. Read only the Markdown file named by the user.
2. Check heading order, relative link targets, and matching code fences.
3. Report each issue with its line number and a short explanation.
4. Do not edit files. If a link target cannot be checked, say so.
```

加载前查看对应客户端的 Skills 文档，确认支持的 frontmatter 字段、发现路径和作用范围。手动复核 Skill 被加载的证据，并给一个明确触发条件。不要只问 Agent“你是否用了 Skill”作为唯一验证。

Zotero 项目中的 `zotero-cli` Skill 则体现另一种常见用法：项目提供 `zotero-mcp install-skill` 安装入口；Skill 告诉 Agent 什么时候调用 `zotero-cli`、如何先搜索再按 key 读取以及如何处理 JSON 结果。Skill 复用流程，CLI 执行命令并访问资料库；安装后的实际位置和客户端支持以[项目说明](https://github.com/54yyyu/zotero-mcp/blob/main/docs/cli.md)为准。

## 接入并验证 MCP

![MCP 在 AI 应用与数据源、工具之间的连接关系](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/mcp-architecture.png){ loading=lazy width="900" }

*来源：[Model Context Protocol 官方入门文档](https://modelcontextprotocol.io/docs/getting-started/intro)。图示展示客户端、服务器与外部数据/工具的连接关系，不代表各产品使用相同配置，也不意味着服务器只读。*

一般接入顺序如下；配置字段、运行方式和授权界面必须查所用客户端及服务器各自的文档。

1. 明确要解决的任务以及需要的最小工具集，先优先选择查询能力。
2. 核验服务器来源、维护者、启动命令、参数、所需凭据、数据流向和可执行的操作。
3. 按客户端官方配置说明添加服务器。不要把一个客户端的 JSON 示例直接复制到另一个客户端。
4. 重启或刷新客户端后，检查服务器连接状态和实际发现的工具名称、说明与权限。
5. 先对非敏感资料执行一次只读查询，核对结果是否来自预期资料源；确认需要写入后，再检查授权范围和目标对象。

不要把 prompt 中的“只读”要求当成技术限制。真正的权限边界来自客户端授权、服务器实现、操作系统账号和资源/API 凭据。凭据用客户端支持的密钥管理方式或环境变量提供，不要提交到 Git。

### Zotero MCP 案例

按 [Zotero MCP 的 Getting Started](https://github.com/54yyyu/zotero-mcp/blob/main/docs/getting-started.md) 查看当前安装路线，再按客户端自己的 MCP 设置页面注册服务。该项目 README 提供了 Claude Desktop 的特定配置例子：

```json
{
  "mcpServers": {
    "zotero": {
      "command": "zotero-mcp",
      "env": { "ZOTERO_LOCAL": "true" }
    }
  }
}
```

这段配置只说明该客户端如何启动本地服务器；配置文件路径、命令搜索路径和字段不能当作其他客户端的通用格式。连接后先检查 MCP 客户端显示的工具列表，选择搜索条目或读取元数据等查询任务验证连接。Zotero 的本地 API 也需按项目文档启用。

如果 Agent 有 shell，也可以按该项目的 [CLI 与 Skill 说明](https://github.com/54yyyu/zotero-mcp/blob/main/docs/cli.md) 使用 `zotero-cli`。两种路线访问的是同一个 Zotero 场景，调用界面和配置方式不同。写操作先阅读 [Agent 使用说明](https://github.com/54yyyu/zotero-mcp/blob/main/docs/for-agents.md)关于本地授权或 Web API 凭据的要求，不要在练习中盲目新增、编辑或删除真实文献。

## Plugins 与 hooks

Plugin 是客户端自己的扩展包格式。有些产品的 plugin 可同时带指令、Skills、命令、MCP 配置、hooks 或界面组件；另一些产品把这些功能分散到不同机制中。安装前查清来源、版本、包含文件、读取的数据、所需权限、更新方式和卸载步骤。

Hook 在产品定义的事件上运行固定动作，例如工具调用前校验参数、任务完成后执行格式检查或发送通知。不同工具的事件名称、同步/异步行为和失败处理不相同。先读实际脚本，确认调用时机、子进程、网络访问和写入范围；在练习项目验证后再扩大作用域。Hook 自动运行也可能造成真实副作用，不能只靠 prompt 限制。

Skills、MCP server、plugin 和 hook 也可能被同一个插件包组合，但概念仍不同：Skill 提供流程说明，MCP server 暴露可调用接口，hook 按事件自动运行，plugin 负责客户端认可的扩展封装。

## 排障、停用与练习

扩展未出现时，依次核对客户端版本、支持的格式、配置路径、作用域和重启要求。Skill 未触发时检查目录、名称、description 与任务是否匹配；MCP 连接失败时分开检查启动命令、运行环境、环境变量、网络和协议日志。Hook 未运行时核对事件匹配、执行权限、超时和返回状态。不要先删除整个配置目录。

停用时使用客户端支持的 disable/remove 入口，或移除对应配置后按要求重启；随后检查子进程、hooks 和扩展配置是否仍在运行。升级前保留可恢复的配置副本，只保留可信来源和当前需要的扩展。

练习时为一个练习仓库加载上述 Markdown Skill，要求它报告标题、链接和代码围栏问题；查看报告中的行号后确认文件未被改动，再停用 Skill。随后比较“命令行中检索 Zotero 条目”和“通过支持 MCP 的客户端连接 Zotero”各自需要的接入方式。真实写入操作不是本练习的一部分。

完成后应能说明：每种机制负责什么、适合何时使用、哪些功能可以组合、具体工具的支持在哪里核验，以及如何验证并停用一个扩展。

## 参考资料

- [Model Context Protocol 官方入门](https://modelcontextprotocol.io/docs/getting-started/intro)
- [Agent Skills 规范](https://agentskills.io/specification)
- [RAG 概述](https://learn.microsoft.com/en-us/azure/search/retrieval-augmented-generation-overview)
- [Claude Code memory](https://code.claude.com/docs/en/memory) · [hooks](https://code.claude.com/docs/en/hooks) · [plugins](https://code.claude.com/docs/en/plugins)
- 各工具的官方能力入口见上表；客户端配置与服务端操作权限需分别核对。
- [Zotero MCP 仓库与文档](https://github.com/54yyyu/zotero-mcp)
