---
title: 日常开发工作流
description: 将 Agent 任务拆解为范围明确、可检查的开发工作。
---

# 日常开发工作流

目标：把 Agent 用在可复现的开发任务上，并以真实代码和验证结果判断完成。先完成[第一个任务](../getting-started/first-task.md)并熟悉一款[Harness](../harnesses/codex.md)。

## 开始前建立基线

![项目工作区与 Git 仓库元数据目录的关系](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/git-workspace.png){ loading=lazy width="900" }

*示意图说明工作区文件与 `.git` 仓库元数据的区别。操作 Agent 前先确认当前目录属于预期仓库。*

先确认仓库、分支、未提交改动和任务目标：

```bash
pwd
git status --short
git branch --show-current
git diff
```

已有改动先归属清楚；不要让 Agent 覆盖你正在编辑的文件。大任务在独立分支或 worktree 工作，保持可回滚基线。

## 让 Agent 理解项目

先让工具只读查看入口文档、相关目录和规则文件，再要求它汇报理解、假设和待确认问题。提示模板：

> 先检查项目入口、与任务有关的文件和项目指令。不要修改文件。请给出相关文件路径、当前行为、你仍不确定的内容和建议计划。

核对它引用的路径是真实存在的，必要时补充背景。

## 把需求写成可完成任务

任务由背景、目标、范围、约束、验收组成。文档模板：“在 X 文件为 Y 读者补充 Z；保留 A；只修改列出的文件；验收为 B。”修复模板：“给出复现命令与失败结果；定位原因；只改必要文件；复跑指定检查并报告实际结果。”功能模板：“描述用户可见行为、边界情况、允许触及目录和完成标准。”

## 修复一个可复现问题

在独立的 `agent-code-lab` 建立 Node 项目。以下文件由读者创建：

```js
// src/sum.mjs
export function sum(values) {
  return values.reduce((total, value) => total + value);
}
```

```js
// test/sum.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { sum } from '../src/sum.mjs';

test('empty list is zero', () => assert.equal(sum([]), 0));
test('adds multiple numbers', () => assert.equal(sum([1, 2, 3]), 6));
test('adds negative numbers', () => assert.equal(sum([-2, 5]), 3));
```

确认所选 Node 版本支持内置测试运行器，再用 `node --test "test/sum.test.mjs"` 观察空数组失败。请 Agent 修复并报告实际复跑结果；你自己再运行测试和查看 diff。不要把 Agent 声称的输出当作验证。

## 增加功能与测试

先约定预期行为，再讨论是否增加测试。测试应覆盖边界和正常路径，避免无关改动。对简单文档修改不应为了形式增加应用测试；以项目已有验证流程为准。

## 重构与代码审查

要求保持外部行为，先圈定模块，再分小步重构。审阅时区分确定缺陷、维护风险、风格建议和未经验证的推测；让 Agent 指出证据路径、影响范围和最小修复。

## 审阅、提交与撤销

![工作区、暂存区、本地仓库与远程仓库之间的常见 Git 操作](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/git-workflow.png){ loading=lazy width="900" }

*Git 流程示意图。撤销类命令可能丢弃改动，执行前检查目标文件和当前 diff。*

检查 `git diff --check`、`git diff`、`git status --short` 和项目适用的验证。确认文件后由你选择提交范围。遵循项目 Conventional Commits 约定。撤销前确认影响范围；不要用 `git reset --hard` 清除未知改动。

## 失败后怎样继续

记录完整错误、执行目录、版本和已尝试步骤，脱敏密钥后提供给 Agent。把任务缩小到可重现环节。交接写明目标、改动文件、实际验证及结果、未完成项。自动化另见[自动化与多 Agent](automation.md)。
