---
title: macOS 与 Linux 环境准备
description: 在 macOS 与 Ubuntu LTS 配置 Git、nvm、Node.js 和终端环境。
---

# macOS 与 Linux 环境准备

本页为 macOS 和 Ubuntu LTS 分别提供准备步骤。Linux 发行版的包管理不同，Ubuntu 命令不能照搬到所有 Linux。执行前先确认系统版本与处理器架构。

## 查看 shell 与系统信息

在 macOS Terminal 或 Ubuntu 终端查看系统：

```bash
uname -a
printf '%s\n' "${SHELL}"
printf '%s\n' "${HOME}"
```

macOS 默认 shell 常为 Zsh；Ubuntu 常用 Bash。先确认正在使用的 shell，再编辑对应 profile。

## 安装 Git、ripgrep（rg）与 fd

`rg`（ripgrep）用于递归搜索文本，`fd` 用于按名称查找文件和目录。macOS 可使用 Homebrew 安装三款工具；若尚未安装 Git，也可按 Apple 开发者工具提示安装：

```bash
brew install git ripgrep fd
git --version
rg --version
fd --version
command -v git
command -v rg
command -v fd
```

Ubuntu LTS 使用 apt 安装。Ubuntu/Debian 的 fd 包名是 `fd-find`，命令名是 `fdfind`：

```bash
sudo apt update
sudo apt install git ripgrep fd-find curl ca-certificates build-essential
git --version
rg --version
fdfind --version
command -v git
command -v rg
command -v fdfind
```

如需在 Ubuntu/Debian 中使用文档常见的 `fd` 命令，可参照 [WSL 环境准备](wsl.md)创建 `~/.local/bin/fd` 符号链接；确保目录在 PATH 中并先检查同名目标，避免覆盖已有文件。其他 Linux 发行版应按其官方包管理器安装 Git、ripgrep 和 fd，包名与命令名可能不同。

参考：[ripgrep 安装说明](https://github.com/BurntSushi/ripgrep#installation)、[fd 安装说明](https://github.com/sharkdp/fd#installation)、[Homebrew fd formula](https://formulae.brew.sh/formula/fd)。

## 用 nvm-sh 管理 Node.js 与 npm

按 [nvm-sh v0.40.8 官方说明](https://github.com/nvm-sh/nvm#installing-and-updating)安装，并按当前 shell 选择 Bash 或 Zsh 初始化方式。安装完成后开启新终端并运行：

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
command -v nvm
nvm --version
nvm install --lts
node --version
npm --version
command -v node
command -v npm
```

`nvm install --lts` 安装当前 LTS。nvm-sh 管理 Node.js 版本；所选 Node.js 安装提供 npm。切换 Node 后重新检查全局 CLI 的路径，不把 nvm 与 npx 混为一谈。

遇到先前用 Homebrew、系统包管理器或 Node 官方安装包安装的 Node 时，检查 `command -v node` 和 PATH，按 nvm-sh 文档处理重复安装。不要让多个 Node 安装目录随机决定当前版本。

## 需要 Python 时再准备环境

Harness 本身若以原生二进制提供，可能无需 Python。需要 Python 项目或 MCP 工具时阅读[uv 与 Anaconda3](python-environments.md)，为项目或工具建立独立环境。

## 网络、终端和文件权限

网络登录、终端输入法和剪贴板可能受代理、桌面环境和 Wayland/X11 影响。先记录具体错误与终端位置，再按工具的排障说明处理。系统包安装时使用管理员权限，常规 Agent 日常使用不需要用 root 运行。

## 完成检查

```bash
git --version
node --version
npm --version
pwd
```

如尚未安装 Node.js，可跳过 Node 检查。不要为了通过这一页而安装所有运行时。

### 参考资料

- [Homebrew](https://docs.brew.sh/)、[Ubuntu 文档](https://documentation.ubuntu.com/)
- [nvm-sh](https://github.com/nvm-sh/nvm)、[Node.js](https://nodejs.org/)
