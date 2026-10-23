---
title: Claude Code CLI
description: 在 Windows、WSL、macOS 和 Linux 安装并使用 Claude Code。
---

# Claude Code CLI

需求中常称“Claude CLI”，本教程使用官方名称 Claude Code。核验日期：2026-10-22。依据：[官方 setup](https://code.claude.com/docs/en/setup)；未在本机安装或登录。先完成[第一个 Agent 任务](../getting-started/first-task.md)。

## 定位与适用场景

Claude Code 是 Anthropic 的终端编码 Agent。官方支持 Windows、WSL、macOS 和 Linux。本教程的 Windows 路线使用 Git for Windows 提供的 Git Bash 执行 Bash 工具命令；安装命令也可从 PowerShell 运行。原生安装器是推荐方式；npm 是可选渠道。

## 安装前检查

原生安装器无需 Node.js；npm 安装要求 Node.js 22+。Windows 原生先安装 Git for Windows，并确认 `bash.exe` 的实际位置；自定义安装目录时需要显式设置路径。检查已有 `claude` 来源，避免混装多个安装渠道；不要使用 `sudo npm install -g`。

## 安装与验证

### 官方安装器

推荐使用原生安装器：

=== "Windows：PowerShell 7"
    ```powershell
    irm https://claude.ai/install.ps1 | iex
    ```

=== "WSL / macOS / Linux：Bash"
    ```bash
    curl -fsSL https://claude.ai/install.sh | bash
    ```

### npm 安装

npm 是可选安装方式。先准备 Node.js 与 npm；Windows 可按[环境准备页](../getting-started/windows.md)使用 nvm-windows 管理 Node.js：

```bash
node --version
npm --version
npm install -g @anthropic-ai/claude-code
claude --version
claude doctor
```

开新终端运行 `claude --version` 和 `claude doctor`。原生安装器自动更新，也可运行 `claude update`；npm 安装用 npm 更新。WSL 在 Linux 侧安装，不需要 Windows 的 Git for Windows。

### Windows：设置 Git Bash 路径

Claude Code 通常能自动找到 Git Bash；自定义安装目录或出现找不到 Bash 的错误时，用 `CLAUDE_CODE_GIT_BASH_PATH` 指定实际的 `bash.exe`。启动 Claude 的终端与其 Bash 工具使用的 shell 是两回事，从 PowerShell 启动也可以使用 Git Bash 执行工具命令。

将下面的 `env` 项合并到 Windows 用户目录的 `.claude/settings.json`（即 `%USERPROFILE%\.claude\settings.json`）。如果文件已有其他配置，保留原有键；路径按自己的安装位置修改，JSON 中的反斜杠写成 `\\`：

```json title=".claude/settings.json"
{
  "env": {
    "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe"
  }
}
```

先在 Git Bash 中检查示例路径是否存在：

```bash
test -x "/c/Program Files/Git/bin/bash.exe" && printf '%s\n' "Git Bash 路径有效"
```

设置后重新启动 Claude Code，并运行 `claude doctor` 检查配置；再在会话中要求它使用 Bash 工具执行 `pwd`，确认实际工作目录。路径中包含空格没有问题；配置值指向可执行文件本身，不要在 JSON 字符串内部再套一层引号。详见[官方 Windows 安装说明](https://code.claude.com/docs/en/setup#install-on-native-windows)。

## 登录与模型接入

![Claude Code 的模型选择列表示例](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/claude-model-picker.png){ loading=lazy width="900" }

*来源：[CC Switch 官方聚合配置教程](https://github.com/farion1231/cc-switch-website/tree/main/public/docs/assets/aggregation-mode)。这是聚合配置下的模型列表示例；实际选项由当前 provider 和凭据决定。*

Claude.ai 免费方案不包含 Claude Code。需要 Pro、Max、Team、Enterprise 或 Console 账号，也可使用官方支持的云服务提供商。运行 `claude` 后按浏览器提示登录；确认账号或 API 计费方式，不把密钥写入仓库。

使用 DeepSeek 的 Anthropic 兼容接口时，通过提供商的 API Key 和专用地址接入，不沿用 Claude 订阅登录态。字段与 CC Switch 操作示例见[模型 API 协议与接入](../tools/api-protocols.md)。

## 第一次运行

在 `agent-lab` 目录执行 `claude`。确认项目目录和权限提示后，先要求只读总结，再执行 P07 的文档修改。按提示审阅文件、shell 和其他工具动作，最后在普通终端检查 status 与 diff。使用 `/exit` 或当前界面提供的退出方式离开；Ctrl+C 用于中断当前输入/任务，之后仍须检查文件。

## 日常操作

在任务中限制目标文件并要求先说明计划。Claude Code 的斜杠命令与 Bash 命令输入位置不同，使用 `/help` 查看当前命令。提交任务后检查真实改动，发现偏差时引用具体文件和差异要求修正。

## 会话与上下文

使用官方支持的继续/恢复会话入口处理长任务；具体参数以 `claude --help` 和当前文档为准。跨会话交接写明目标、文件、已验证事实和待办，不假定新会话自动拥有旧上下文。

## 项目配置与指令

Claude Code 原生项目指令文件为 `CLAUDE.md`，设置/项目配置见[官方记忆文档](https://code.claude.com/docs/en/memory)。它不等于所有工具都自动读取的 `AGENTS.md`。按官方机制在项目说明中引用或维护两种规则，避免重复冲突；跨工具示例见[AGENTS.md 专题](../workflows/project-instructions.md)。

## 权限与命令执行

启动时逐项阅读项目访问和命令确认提示。权限模式、允许规则和沙箱行为按[官方权限文档](https://code.claude.com/docs/en/permissions)及平台说明核实。Git Bash 是启动/命令执行 shell 的配置之一，不构成安全隔离。不要用宽泛自动批准替代审查。

## 扩展与进阶

按官方当前支持范围配置 MCP、Skills、插件或 hooks，注意用户级和项目级来源。新增前阅读配置文件变更；停用时关闭对应集成并重启验证。概览见[扩展专题](../workflows/extensions.md)。

## 非交互使用

脚本入口使用前先核对官方[CLI 参考](https://code.claude.com/docs/en/cli-reference)，尤其输出格式、退出码、权限和认证。适合自动化的例子应固定工作目录、限制输入、保留日志并检查文件差异；不要把交互模式直接后台运行。

## 完整实战、维护与排障

完成 P07 文档任务，要求补齐遗漏后再次看 diff。命令找不到时检查 Node/PATH 和旧安装；Git Bash 不可用时核对 `CLAUDE_CODE_GIT_BASH_PATH`；扩展异常时检查配置路径。官方参考：[安装](https://code.claude.com/docs/en/setup)、[配置](https://code.claude.com/docs/en/settings)、[CLI](https://code.claude.com/docs/en/cli-reference)。
