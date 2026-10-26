---
title: Windows 环境准备：Git Bash 与 PowerShell 7
description: 在 Windows 安装并区分 Git Bash、PowerShell 7、Windows Terminal 和 Node.js 版本管理工具。
---

# Windows 环境准备：Git Bash 与 PowerShell 7

本页建立 Windows 原生终端环境，介绍 Git、ripgrep、PowerShell 7 和 nvm-windows。**日常教程命令以 Git Bash 为主**；PowerShell 示例会标明 shell。每款 Agent 使用什么内部 shell，还要继续看对应工具页。

## 先分清终端和 shell

Windows Terminal 是终端宿主，可以打开不同 shell。Git Bash 提供 Bash 和 Git for Windows 的工具。PowerShell 7 通过 `pwsh` 启动；系统原有的 Windows PowerShell 5.1 通过 `powershell` 启动。它们可并存，装 PowerShell 7 不会替换 5.1。

WSL 是另外一套 Linux 环境，有自己的 Linux 程序、HOME、PATH 和配置。本页的 Windows 原生命令不应直接复制到 WSL。WSL 单独见 [环境准备](wsl.md)。

## 安装 Git for Windows 和 Git Bash

从 [Git for Windows 官方站点](https://gitforwindows.org/)下载适用于 Windows 的安装程序。安装后打开 Git Bash，检查：

```bash
git --version
command -v git
pwd
printf '%s\n' "${HOME}"
```

`command -v git` 显示当前 shell 找到的 Git 路径，`pwd` 显示当前目录。Windows 的 `C:\Users\...` 在 Git Bash 里常显示为 `/c/Users/...`。目录名有空格时始终给路径加引号。

## 安装并验证 PowerShell 7

打开已经安装的 PowerShell 或 CMD，按微软当前说明通过 WinGet 安装稳定版。下面命令是 PowerShell 代码：

```powershell
winget install --id Microsoft.PowerShell --source winget
```

如果 WinGet 不可用，从 [PowerShell 官方安装页](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows)选择适合架构和组织策略的 MSIX 或 MSI 安装程序。根据原安装渠道更新和卸载。不要安装预览版替代稳定版。

在 Windows Terminal 新开一个 PowerShell 7 标签，运行：

```powershell
$PSVersionTable.PSVersion
Get-Command pwsh
Get-Location
```

版本主号应为 `7`。若显示 `5.1`，检查 profile 当前启动的是 `powershell.exe` 还是 `pwsh.exe`。新版和旧版可并存；不用为了使用 7 卸载 Windows 系统组件。

## 配置 Windows Terminal

打开 Windows Terminal 的设置，确认配置文件列表中有 Git Bash、PowerShell 7 和（安装后）WSL。可按个人习惯选择默认 profile。更改默认 profile 只改变打开新标签时使用的 shell，不会改变 Agent 内部执行环境。

如果找不到 PowerShell 7，查看其安装程序是否创建了 Windows Terminal 配置文件，也可以通过微软的 [Terminal 配置说明](https://learn.microsoft.com/windows/terminal/customize-settings/profile-general)了解如何添加 profile。不要将 Git Bash 与 WSL profile 指向同一启动程序。

![Windows Terminal 中打开 PowerShell 标签页的官方演示](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/windows-terminal-tabs.gif){ loading=lazy width="900" }

*来源：[Microsoft Windows Terminal 文档](https://learn.microsoft.com/en-us/windows/terminal/)。此动图演示标签页与 PowerShell 窗口，不代表本机安装状态。*

## 用 nvm-windows 管理 Node.js 与 npm

Node CLI 常要求 Node.js。Windows 原生使用 [nvm-windows 官方安装页](https://nvm-windows.com/)提供的安装器；截至本次核验，当前 CLI 为 v2，命令语法与 v1 有变化。它不同于 macOS、Linux 和 WSL 的 nvm-sh。

安装前先检查已有 Node：

```powershell
Get-Command node,npm -ErrorAction SilentlyContinue
node --version
npm --version
```

若机器已有独立 Node.js，先依照 nvm-windows 官方迁移说明卸载或处理 PATH 冲突。安装当前 nvm-windows 稳定版后，重新打开 PowerShell 7，再运行：

```powershell
nvm --version
nvm list installed
nvm install lts
nvm use lts
node --version
npm --version
Get-Command node,npm
```

也可将 `lts` 换成已确认的主版本（如 `24`）。用 `nvm list installed` 查看本机版本；更完整语法见[nvm-windows 命令文档](https://docs.nvm-windows.com/commands/)。nvm-windows v1 与 v2 命令有差异，不照抄旧版 `nvm list` 示例。nvm 管理 Node.js，npm 随所选 Node 版本提供，不是独立 npm 版本管理器。

切换 Node 版本后，之前装的全局 npm CLI 可能不在新版本的全局包目录中。先检查当前的 `node`、`npm` 和工具路径，再为当前选择的 Node 环境安装所需 CLI。不要通过更新所有全局包来修复一个 PATH 问题。

## 安装 ripgrep 并理解 PATH

本项目的文本搜索示例使用 `rg`。如未安装，按 [ripgrep 官方项目](https://github.com/BurntSushi/ripgrep)选择可信发行方式。确认当前命令来源：

```bash
rg --version
command -v rg
```

PowerShell 7 中可使用 `Get-Command rg`。打开新终端后再次检查 PATH；同名程序有多个版本时，看命令来源比重复安装更有帮助。

Bash 临时环境变量使用 `NAME=value command` 或 `export NAME=value`。PowerShell 7 使用 `$env:NAME = 'value'`。持久化到 shell profile 前说明文件和作用范围。不要在示例中把保留变量 `$HOME`、`$home` 当自定义变量名。

## 按需准备运行时

独立发行的工具可能不需要 Node 或 Python。只按所选 Harness 和插件的官方要求安装运行时。Node CLI 使用上述 nvm-windows；Python 项目环境见 [uv 与 Anaconda3](python-environments.md)。不需要为九款工具一次装齐所有语言环境。

## Shell profile 和脚本安全

PowerShell 7 profile 与 Bash 的 `~/.bashrc` 是不同文件；配置变量前先查当前工具文档。PowerShell 执行策略有用户、进程和机器等作用范围。遇到脚本限制先确认来源与策略，不默认全局设为 `Bypass`。

## 环境检查

| 项目 | Git Bash | PowerShell 7 |
| --- | --- | --- |
| 当前 shell | `printf '%s\n' "$BASH_VERSION"` | `$PSVersionTable.PSVersion` |
| Git | `git --version` | `git --version` |
| Node/npm | `node --version`、`npm --version` | `node --version`、`npm --version` |
| Python（如需要） | `command -v python` | `Get-Command python` |
| 当前目录 | `pwd` | `Get-Location` |

如 Python 来自 Microsoft Store shim、找不到 Python 或来源不是期望环境，先读[环境配置说明](python-environments.md)，不要继续安装依赖。

### 参考资料

- [Git for Windows](https://gitforwindows.org/)
- [PowerShell 7 安装](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows)
- [Windows Terminal profile](https://learn.microsoft.com/windows/terminal/customize-settings/profile-general)
- [nvm-windows](https://github.com/coreybutler/nvm-windows)
- [Node.js](https://nodejs.org/)、[ripgrep](https://github.com/BurntSushi/ripgrep)
