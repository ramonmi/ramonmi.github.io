---
title: 完成第一个 Agent 任务
description: 建立安全的文档练习项目，完成修改并核对真实 diff。
---

# 完成第一个 Agent 任务

目标是完成“准备项目—提出小任务—检查实际改动”的闭环。先读[概念](concepts.md)和你的[平台准备页](windows.md)（或 [WSL](wsl.md)、[macOS 与 Linux](macos-linux.md)）。核验日期：2026-10-22；示例命令未在作者本机执行。

## 先看任务和完成标准

练习只修改 Markdown，不需要安装应用依赖或配置 Python。Agent 只在 `notes/workflow.md` 新增“完成标准”，内容恰为三条：只修改目标文档；保留原有内容；通过 diff 确认新增内容。不要让 Agent 自动提交。

## 创建 agent-lab

在所选 shell 中创建独立目录。以下命令和基线提交由读者在自己的练习目录执行：

```bash
mkdir "agent-lab"
cd "agent-lab"
git init
mkdir "notes"
cat > "README.md" <<'EOF'
# agent-lab

练习目标：用 AI Agent 修改一份文档，并人工检查结果。

## 目录

- `notes/workflow.md`：任务工作流练习。

修改前先理解任务；修改后检查 `git diff`。
EOF
cat > "notes/workflow.md" <<'EOF'
# 工作流练习

## 了解任务

阅读目标与约束，再开始修改。

## 检查改动

查看文件和 diff，确认内容符合要求。
EOF
cat > ".gitignore" <<'EOF'
.agent-lab-tmp/
EOF
git add "README.md" "notes/workflow.md" ".gitignore"
git commit -m "📃 docs: create agent-lab baseline"
git status --short
```

预期：提交创建成功且 `git status --short` 无输出。Git 若未设置提交身份，按[Windows 环境页](windows.md)配置；不必公开真实邮箱。

## 选择并安装一款工具

选择[Codex](../harnesses/codex.md)、[Claude Code](../harnesses/claude-code.md)、[OpenCode](../harnesses/opencode.md)、[Pi](../harnesses/pi.md)、[oh-my-pi](../harnesses/oh-my-pi.md)、[DSH](../harnesses/dsh.md)、[Hermes](../harnesses/hermes.md)或[Kimi Code](../harnesses/kimi-code.md)之一，按该页平台、认证和启动步骤操作。本页不提供伪通用启动命令。

## 先读项目，再提出修改

在 `agent-lab` 根目录启动工具。先要求只读查看 `README.md` 和 `notes/workflow.md`，报告计划修改文件和完成标准。自然语言任务示例：

> 只修改 `notes/workflow.md`。先读取现有内容，在末尾新增“完成标准”小节，逐条写入：只修改目标文档、保留原有内容、通过 diff 确认新增内容。不要提交。完成后说明修改文件并告诉我如何检查 diff。

观察工具提出的操作；若路径超出范围、要覆盖文件或执行无关命令，拒绝并缩小任务。斜杠命令和快捷键请按对应工具页操作。

## 检查并反馈

回到普通终端执行：

```bash
git status --short
git diff -- "notes/workflow.md"
```

确认仅目标文件变化、原有两节保留、新节三条齐全。真实文件和 diff 是验收证据，Agent 的回复不是。如果缺项，要求只补缺失内容并再次检查。

## 中断、继续与撤销

用对应工具的停止操作中断；恢复会话或新开会话的方式见各工具页。先检查状态和 diff 再决定下一步。本练习不要使用 `git reset --hard`。确需恢复时，先保存自己的编辑，并确认该文件全部未提交改动都可丢弃，再运行 `git restore -- "notes/workflow.md"`。

## 验收与下一步

验收材料：修改后的文件、符合三条标准的 diff、没有意外文件。之后进入[日常开发工作流](../workflows/daily-development.md)和[项目指令与 AGENTS.md](../workflows/project-instructions.md)。
