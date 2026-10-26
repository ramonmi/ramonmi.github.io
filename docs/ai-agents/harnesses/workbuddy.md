---
title: WorkBuddy
description: 安装腾讯 WorkBuddy 桌面工作台，在授权的工作目录中完成并检查任务。
---

# WorkBuddy

核验日期：2026-10-26。本文依据 [WorkBuddy 官方产品指南](https://www.workbuddy.cn/docs/workbuddy/From-Beginner-to-Expert-Guide/Product-Guide)、[Windows 安装指南](https://www.workbuddy.cn/docs/workbuddy/From-Beginner-to-Expert-Guide/Installation-Win-Guide)和[第一个任务指南](https://www.workbuddy.cn/docs/workbuddy/FirstTask)编写；作者未安装或登录。WorkBuddy 是腾讯推出的桌面 AI Agent 工作台，可在用户选择的工作空间中处理本地文件，也能生成文档、表格和演示文稿。先完成[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

WorkBuddy 将对话式 Agent、工作空间与文件任务放在桌面应用中。可以从整理资料、起草文档、分析表格等有明确输入和验收结果的小任务开始。本文介绍桌面应用；WorkBuddy CLI 是单独的产品入口，请勿照搬其他 Harness 的 shell 命令、斜杠命令或配置文件路径。

## 安装前检查

官方 Windows 安装指南要求 Windows 10 及以上、x64；Windows 7/8/8.1 不受支持，ARM64 以当前版本说明为准。官方文档也提供 macOS、统信 UOS 和银河麒麟安装指南。下载前打开[官方文档中心](https://www.workbuddy.cn/docs/workbuddy)，核对对应系统的最新要求和安装步骤。准备可用的登录账号和网络连接，并创建一个不含私密数据的练习目录。

## 安装与验证

1. 打开 [WorkBuddy 官方产品页](https://www.workbuddy.cn/)，选择与系统匹配的安装包；Windows 安装细节见[官方 Windows 指南](https://www.workbuddy.cn/docs/workbuddy/From-Beginner-to-Expert-Guide/Installation-Win-Guide)。
2. 按安装向导完成安装并启动应用。
3. 点击登录。Windows 指南列出微信扫码、手机号、邮箱和 SSO 等方式；个人与企业账号的登录入口可能不同，以当前登录页和组织策略为准。
4. 浏览器显示登录成功后返回客户端，确认主界面可用。版本更新可按官方指南在头像菜单中选择“检查更新”。

## 第一次运行

![WorkBuddy 界面示意图](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/workbuddy-shot.png){ loading=lazy width="900" }

点击“新建任务”，选择专用练习目录作为工作空间，并确认输入框下方显示“默认权限”。先让 WorkBuddy 只读列出目录中的文件并概括内容，确认它使用了预期的工作空间；再提出一个范围有限的任务，例如：

> 阅读 `notes/` 中的公开练习材料，只在当前练习目录新建 `summary.md`，概括三条要点。不要改动或删除其他文件；完成后列出改动并说明如何检查。

确认工作空间和任务边界后再执行写入。官方默认权限以工作空间为边界，遇到越界或高风险操作时会请求确认；首次练习保持默认权限，不必开启“允许完全访问”。完成后在结果面板查看产物，并用对应应用打开核对；如处理的是 Git 仓库，再检查 `git status --short` 和 diff。不要只凭对话中的“已完成”判断成功。详见[默认权限与安全沙箱](https://www.workbuddy.cn/docs/workbuddy/From-Beginner-to-Expert-Guide/Function-Description/Permission-Modes)。

## 日常操作

给出输入文件、允许写入的位置、输出格式和验收条件。先拆成只读检查，再执行有限写入；需要修改已有文件时，点名目标并要求保留其他内容。生成 Office 文件后用相应应用打开检查排版、公式或图表。

## 会话与上下文

把一个主题或交付目标放在单独会话中，并在长任务阶段结束时记录已完成内容、未完成事项和目标文件。会话历史、工作区文件和长期记忆是不同的数据；其保存位置、保留期限和跨会话行为以当前版本官方说明及界面为准。清理或迁移前先确认会话与文件的存储范围。

## 项目配置与指令

从简单任务开始，观察 WorkBuddy 如何读取当前目录及其项目说明文件。不要假设它会自动加载 `AGENTS.md`、`CLAUDE.md` 或其他 Harness 的规则；先查官方文档，再用只读任务验证。通用项目规则模板见[项目指令专题](../workflows/project-instructions.md)。

## 权限与文件操作

为每项任务使用独立工作空间；重要资料先复制到可恢复的练习目录。默认权限可在工作空间内执行常规文件任务，并对越界或高风险动作请求确认。仔细核对确认内容、目标路径和影响范围；不确定时取消操作，让 WorkBuddy 先列出文件清单或生成预览。官方说明“允许完全访问”会降低包括文件、命令和网络在内操作的确认频率，并影响当前客户端的所有任务，入门阶段不要开启。

## 扩展与进阶

先完成本地文件任务，再按官方文档了解模型切换、MCP Server 与 Skills 等扩展能力。启用前确认所需账号、权限和数据流向；仅使用可信来源，并按官方说明管理和停用扩展。

## 非交互使用

本文按桌面交互工作流介绍 WorkBuddy。官方导航中另有 WorkBuddy CLI 入口；若要在脚本或 CI 中调用，请转到该 CLI 的官方文档核对安装、参数和授权方式，不要把桌面操作或其他 Harness 的命令当作批处理接口。

## 完整实战、维护与排障

在测试目录完成 P07 文档任务并检查最终文件。应用无法启动时核对系统要求和安装来源；登录失败时确认账号、组织权限与网络；找不到文件时确认当前工作区和目录授权。升级、卸载和数据备份按[官方文档](https://www.workbuddy.cn/docs/workbuddy)执行，不要为排障直接删除应用数据目录。
