---
title: 项目指令、AGENTS.md 与上下文管理
description: 编写项目级 Agent 规则，验证加载范围并管理长任务交接。
---

# 项目指令、AGENTS.md 与上下文管理

本页给出可按项目实际情况修改的规则模板。不要用模板覆盖仓库既有 `AGENTS.md`。跨工具加载支持不同，核验日期：2026-10-22；使用前查所用 Harness 官方指引。先读[日常工作流](daily-development.md)。

## 信息应该放在哪里

当前任务目标写在任务提示；长期项目约定放 README、`AGENTS.md` 或工具原生指令文件；个人偏好放用户级设置；可重复步骤才考虑 Skill。规则文件描述如何协作，不能代替系统权限或环境隔离。

## 指令文件和支持范围

Codex 官方支持 `AGENTS.md`；部分工具使用自己的项目文件或可配置规则入口。Claude Code 以 `CLAUDE.md` 为原生记忆文件；其余工具请核实各自文档。相同文件存在不等于相同加载机制。先查工具篇，再验证根目录、子目录和优先级。

## 写作前收集事实

记录真实技术栈、目录、运行时约束、验证命令、环境限制、文档格式、改动边界和提交习惯。只写已经确认的命令；不知道的标注“先检查”，不要照抄其他机器的路径或环境名称。

## agent-lab 的 AGENTS.md 示例

适合文档练习仓库的简洁根规则：

```markdown
# Project instructions

- Before editing, read the target file and the task requirements.
- Keep changes within the files named by the task.
- Preserve existing content unless the task asks to change it.
- After editing, inspect `git status --short` and `git diff`.
- This repository is a Markdown exercise; do not run application builds or tests.
- Do not commit or push unless the user asks.
```

`notes/AGENTS.md` 可补充：“文档使用 Markdown；新增小节要有清楚标题；修改后核对链接和原文保留。”子目录规则仅在工具确实支持相应查找机制时有效。

## Zensical 站点的 AGENTS.md 模板

将占位内容替换为项目核实事实后再使用：

```markdown
# Project instructions

## Project
- Static documentation site built with Zensical.
- Markdown source lives in `docs/`; navigation is defined in `zensical.toml`.
- Generated site output is not edited by hand.

## Environment
- Use the repository's documented Python and uv environment.
- Before Python commands, verify the active interpreter and environment.
- Never create, remove, or upgrade environments without explicit authorization.

## Editing
- Keep page links relative and point to Markdown source files.
- Use four spaces for nested Markdown blocks.
- Put static assets under the documented assets directory.
- Update navigation when adding a page.

## Verification
- Inspect `git diff --check`, changed files, and links.
- Run the documented Zensical build only when the existing environment is verified.
- Report checks actually run; do not claim unrun checks passed.

## Git
- Follow the repository commit convention.
- Do not commit, push, or deploy unless asked.
```

该模板不替代具体项目的 Python 版本、锁文件策略、Git 规范或本机环境注册表。先读该项目已有说明后再填充。

## 根目录与子目录分层

根规则适合全仓库通用约定；子目录规则仅写局部格式或命令。避免重复复制根规则造成冲突。验证前确认工具支持向上查找、向下覆盖还是只读入口目录；规则优先级按各 Harness 文档说明。

## 验证规则生效

在新会话执行无破坏只读任务，例如“概述本页的文档格式规则并指出来源文件”。核对路径和内容后，再要求只改一个练习文件，检查 diff 是否遵循约定。模型说“已读取”不是唯一证据；实际行为和工具展示的上下文文件更有证明力。

## 控制上下文与长会话

只提供与当前任务相关的文件；长任务分阶段提交可检查结果。压缩上下文或开新会话前保存状态：目标、已改文件、已验证事实、未完成项、下一步。对话记录、项目规则、磁盘改动和 Agent 记忆是不同信息。

## 交接摘要模板

```text
目标：
当前分支与工作目录：
已修改文件：
已完成：
实际验证（命令与结果）：
尚未验证 / 阻塞：
下一步：
注意不要做的操作：
```

## 常见误区与维护

坏例：“把项目做得更好。”改为具体目标、文件范围与验收标准。规则不要堆入密钥、个人目录或经常过期的临时状态。提示词不能代替系统权限；权限机制不能代替 diff 审查。随技术栈变化定期更新规则，并通过小任务检查是否有效。
