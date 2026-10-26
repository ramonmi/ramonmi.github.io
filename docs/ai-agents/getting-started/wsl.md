---
title: WSL 环境准备
description: 为 WSL 2 用户准备独立的 Linux 工具链、Node.js、Python 和 Agent 工作目录。
---

# WSL 环境准备

WSL 适合希望使用 Linux 工具链或 Windows 原生路线不受支持的用户。本页以 Ubuntu LTS 为例。WSL 与 Windows 原生环境使用不同的 Linux 用户目录、工具和 PATH；装在 Windows 的 Node、Python 或 Agent 不会自动成为 WSL 命令。

## 安装 WSL 2

在需要管理员权限的 PowerShell 7 标签里按微软文档执行安装，并按提示重启：

```powershell
wsl --install
```

若需指定发行版或升级已有实例，先查看 `wsl --help` 和 [微软安装说明](https://learn.microsoft.com/windows/wsl/install)。首次启动 Ubuntu 时建立 Linux 用户和密码。密码输入时终端不会显示字符，这是 Linux 的正常表现。

确认发行版运行在 WSL 2：

```powershell
wsl --list --verbose
```

## 安装 Linux 基础工具

在 Ubuntu 的 WSL 终端内运行 Linux 命令。以下为 Ubuntu 命令，不能复制到 Git Bash 或 PowerShell：

```bash
sudo apt update
sudo apt install git ripgrep fd-find build-essential curl unzip
git --version
rg --version
fdfind --version
```

`sudo` 仅用于本段的系统包安装。按所需工具安装运行时，不为所有 Harness 一次安装 Node、Bun 和 Python。

Ubuntu/Debian 的包名是 `fd-find`，命令名为 `fdfind`。如果希望按上游文档使用 `fd` 命令，可在用户的 `~/.local/bin` 创建符号链接。先确保目录在 PATH 中，并检查是否已有同名文件；以下命令不会覆盖已有文件或链接：

```bash
mkdir -p "${HOME}/.local/bin"
if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
    export PATH="${HOME}/.local/bin:${PATH}"
fi
if [[ -e "${HOME}/.local/bin/fd" || -L "${HOME}/.local/bin/fd" ]]; then
    printf '%s\n' "${HOME}/.local/bin/fd 已存在；请先检查目标，不要覆盖。"
elif ! command -v fdfind >/dev/null 2>&1; then
    printf '%s\n' "找不到 fdfind；请先确认 fd-find 已安装。" >&2
    exit 1
else
    ln -s "$(command -v fdfind)" "${HOME}/.local/bin/fd"
fi
fd --version
```

`export PATH=...` 只影响当前 shell 和之后启动的子进程。若新开终端后仍需使用此目录，可将同一条 PATH 设置加入 Bash 的 `~/.bashrc`，然后重新载入或开启新终端。符号链接保存 `fdfind` 的目标路径；卸载或移动目标程序后需重新检查链接。更多细节见 [fd 官方安装说明](https://github.com/sharkdp/fd#on-ubuntu)。

## 在 WSL 安装 nvm-sh

nvm-sh 是 Linux/macOS 版本管理器，和 Windows 原生 nvm-windows 是不同项目。WSL 内按 [nvm-sh v0.40.8 官方安装器](https://github.com/nvm-sh/nvm#installing-and-updating)安装，不复用 Windows 的 nvm 目录或全局 npm 包。此版本修复了早期版本已披露的安装安全问题。新开 WSL shell 后检查：

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

nvm-sh 通过 shell 初始化脚本加载。若新 shell 找不到 `nvm`，按官方说明检查当前 shell 和 profile，不要同时初始化 Windows nvm-windows。

## 放置项目和理解路径

Linux HOME 是 `/home/<linux-user>`。项目可以放在 WSL 文件系统，也可以从 `/mnt/c/` 等挂载路径访问 Windows 文件。工作目录与构建工具都应属于同一侧：

```bash
pwd
printf '%s\n' "${HOME}"
git status --short
```

如果项目在 Windows 的 `C:\Users\...`，WSL 通常从 `/mnt/c/Users/...` 访问；Git Bash 则常显示 `/c/Users/...`。这些路径不是可互换的。大量 Linux 工具读写时可以将项目克隆在 WSL HOME 下，以减少跨文件系统混用。

![Windows 文件资源管理器中的 Linux 发行版入口](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/wsl-file-explorer.png){ loading=lazy width="900" }

*来源：[Microsoft WSL 文件系统文档](https://learn.microsoft.com/en-us/windows/wsl/filesystems)。发行版列表会随本机安装而不同。*

## Python、Git 身份和凭据

WSL 的 Python 环境按 [uv 与 Anaconda3](python-environments.md)配置。不要复制 Windows 的 `.venv` 到 WSL，也不要在 WSL 命令中激活 Windows Python。

Git 的用户名称和邮箱按个人需要设置。认证凭据取决于 Git 与远程服务配置；WSL 和 Git for Windows 不应被假定共享同一个凭据存储。

## 网络与编辑器

Windows 浏览器能打开网页，不保证 WSL 内命令行自动继承代理。遇到登录回调或 CLI 网络问题，先分别检查进程的网络、DNS 和代理设置，不要关闭 TLS 校验。用 WSL 扩展打开 Linux 目录时，确认终端提示符和 `pwd` 确实位于 WSL。

## 完成检查

```bash
uname -a
pwd
git --version
command -v git
rg --version
fdfind --version
command -v rg
command -v fdfind
```

确认这是 Linux shell，Git 路径位于 WSL 环境，项目目录符合预期。然后阅读[第一个 Agent 任务](first-task.md)，并从[栏目首页](../index.md)选择 Harness。

### 参考资料

- [Microsoft：安装 WSL](https://learn.microsoft.com/windows/wsl/install)
- [Microsoft：WSL 文件系统](https://learn.microsoft.com/windows/wsl/filesystems)
- [nvm-sh](https://github.com/nvm-sh/nvm)、[uv](https://docs.astral.sh/uv/)
