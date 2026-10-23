---
title: DSH（DeepSeek Harness）
description: 安装并使用 DeepSeek Harness，理解本地 Web UI 与启动 CLI 的区别。
---

# DSH（DeepSeek Harness）

核验日期：2026-10-22。依据[DeepSeek 官方 DSH 仓库](https://github.com/deepseek-ai/deepseek-harness)；文档将其标为开发者预览。作者未安装、启动服务或调用模型。先完成[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

DSH 是 DeepSeek Harness 项目。当前仓库说明中的启动 CLI 与本地 Web UI 是不同组成：CLI 可启动应用，不应描述成已确认的 TUI 编码界面。版本和预览状态以官方默认分支为准。

## 安装前检查

npm 全局安装与 npx 路线均需 Node.js。Windows 可先按[环境准备页](../getting-started/windows.md)配置 nvm-windows、Node.js 与 npm；WSL 使用自己一侧的 Node.js。先检查 `node --version` 和 `npm --version`，准备模型凭据；默认 Web UI 地址为本机 `127.0.0.1:3080`。

## 安装与验证

### npm 全局安装（本教程优先）

安装官方包后使用它提供的 `dsh` 命令启动服务：

=== "Windows：PowerShell 7"
    ```powershell
    npm install -g @deepseek-ai/dsh
    Get-Command dsh
    dsh --help
    ```

=== "Git Bash / WSL / macOS / Linux：Bash"
    ```bash
    npm install -g @deepseek-ai/dsh
    command -v dsh
    dsh --help
    ```

确认命令可用后，进入自己的目标项目目录，再启动 Web UI：

```bash
dsh web
```

默认打开本地 Web UI；不自动打开浏览器可运行 `dsh web --no-open`。安装命令只负责安装包，`dsh web` 才会启动服务；停止服务时在启动终端按 Ctrl+C。更新用 `npm install -g @deepseek-ai/dsh@latest`，卸载用 `npm uninstall -g @deepseek-ai/dsh`。nvm 切换 Node.js 版本后，重新检查 `dsh` 的命令来源。

### npx 启动（备用）

不想全局安装时，可在目标项目目录直接运行：

```bash
npx @deepseek-ai/dsh web
```

npx 首次运行可能下载包；不自动打开浏览器可运行 `npx @deepseek-ai/dsh web --no-open`。该方式同样会启动服务，停止时按 Ctrl+C。官方 README 给出 npx 快速启动示例，本教程为持续使用优先展开 npm 全局安装；源码开发是另一条路线。

## 登录与模型接入

在 Web UI 的 Settings → Models 输入 DeepSeek API Key 并保存；官方也说明可配置其他 provider 和自定义 OpenAI-compatible endpoint，按 provider guide 填写。密钥不写入仓库或截图。

![DSH 设置页中的模型提供商配置](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/dsh-models-config.png){ loading=lazy width="900" }

*界面示例展示 Settings → Models、provider API Key 输入区和自定义设置入口。图中密钥栏为空；配置自定义 endpoint 或模型时，按所选 provider 的说明填写。*

## 第一次运行

在 `agent-lab` 目录运行 `dsh web`（备用方式为 `npx @deepseek-ai/dsh web`）。Web UI 选择 **Choose workspace**，添加并选中该项目；选择 workspace 前 composer 不可用。先只读检查，再提交 P07 文档任务。关闭浏览器页面不一定停止服务；在启动终端按 Ctrl+C。

## 日常操作

通过当前 Web UI 观察 Agent/插件动作，限定工作目录并确认写入。完成后从普通终端查看 `git status` 和 diff。界面显示“done”仍需检查真实文件。

## 会话与上下文

会话保存、恢复和跨界面共享能力以当前版本文档为准。分别确认浏览器会话与本地文件状态，保存任务摘要；不承诺 CLI 启动与 Web 会话共用历史。

## 项目配置与指令

核对项目配置/profile 的官方名称、文件位置和作用范围。不要推断其会读取 `AGENTS.md` 或其他 Harness 规则。先用只读任务确认加载行为。

## 权限与命令执行

理解插件在本机进程中的执行范围、项目目录和服务监听地址。默认只本机访问，不把开发服务暴露到公网；权限由当前应用和操作系统共同决定。

## 扩展与进阶

根据 README 配置当前支持的插件并确认其启用/停用方式。先尝试官方维护插件，再考虑开发自定义插件；不可将社区插件能力算作内置功能。

## 非交互使用

一次性任务使用官方单独说明的 `dsh-headless` CLI 应用；具体参数见[CLI 应用文档](https://github.com/deepseek-ai/deepseek-harness/tree/master/apps/cli)。不要把 `dsh web` 当作批处理命令。

## 完整实战、维护与排障

在实际界面完成 P07 文档改动并审查 diff。端口占用先检查进程归属；服务无法访问时核对启动终端、loopback 地址和 workspace。参考：[README](https://github.com/deepseek-ai/deepseek-harness)、[Web UI 使用](https://github.com/deepseek-ai/deepseek-harness/tree/master/docs/user/guide)、[provider 配置](https://github.com/deepseek-ai/deepseek-harness/blob/master/docs/user/guide/providers.md)。
