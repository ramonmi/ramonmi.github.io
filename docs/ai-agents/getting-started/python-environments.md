---
title: Python 环境配置：uv 与 Anaconda3
description: 使用 uv 管理 Python 项目和 CLI 工具，并了解 Anaconda3/Conda 的独立环境工作流。
---

# Python 环境配置：uv 与 Anaconda3

本页适用于 Python 项目、MCP 服务或 Python CLI。核验日期：2026-10-22；作者未在本机安装或运行这些命令。先读[Windows](windows.md)、[WSL](wsl.md)或[macOS 与 Linux](macos-linux.md)环境准备页。

## 解释器、环境和包

**解释器**是实际运行程序的 `python` 可执行文件；用 `python -c "import sys; print(sys.executable)"` 确认来源。**环境**把解释器和依赖隔开。uv 管理 Python 版本、项目依赖、锁文件和独立 CLI 工具；Conda 还可管理非 Python 二进制依赖。不要在同一环境交替用 uv 和 Conda 安装、升级依赖。

## 如何选择 uv 或 Anaconda3

新项目和常见 Python CLI 优先 uv：用 `pyproject.toml` 声明依赖、`uv.lock` 固定解析结果、`.venv/` 保存环境。已有 Conda 项目、科学计算包或需要 Conda 二进制渠道时继续用 Conda。仅使用独立二进制 Harness 的读者可以跳过本页。

## 安装与验证 uv

先按[官方安装说明](https://docs.astral.sh/uv/getting-started/installation/)安装，再开新终端检查。Windows 原生优先通过 WinGet 安装，也可在 PowerShell 7 中使用官方 Windows 安装器；安装完成后可回到 Git Bash 使用 uv。以下命令是读者操作，可能下载 uv；不在作者环境执行。

=== "Windows：WinGet"
    在 PowerShell 7 中运行：

    ```powershell
    winget install --id astral-sh.uv --exact --source winget
    uv --version
    Get-Command uv
    ```

=== "Windows：PowerShell 7"
    ```powershell
    pwsh -NoProfile -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
    uv --version
    Get-Command uv
    ```

=== "WSL / macOS / Linux"
    ```bash
    curl -LsSf https://astral.sh/uv/install.sh | sh
    uv --version
    command -v uv
    ```

核对版本和可执行文件路径。Windows 安装完成后，重新打开 Git Bash，运行 `uv --version` 和 `command -v uv`，确认使用的是 Windows 的 uv。若找不到 `uv`，重开终端并检查安装器报告的 PATH，不要重复安装多个副本。WSL 使用上面的 Linux 安装方式，两侧环境独立。

## 用 uv 选择 Python

项目有 `.python-version` 或 `requires-python` 时遵照项目约束；否则查看 `uv python list`。可通过 `uv python pin <版本>` 固定练习项目版本，该命令会修改 `.python-version`。安装解释器的策略见[官方 Python 管理文档](https://docs.astral.sh/uv/concepts/python-versions/)。

## 创建一个 uv 项目环境

在独立练习目录执行。初始化、添加依赖和运行会建立或修改该项目的 `pyproject.toml`、`uv.lock` 与 `.venv`：

```bash
uv init "python-env-lab"
cd "python-env-lab"
uv add "rich"
uv run python -c "import sys, rich; print(sys.executable); print(rich.__version__)"
```

检查声明、锁定记录和解释器路径。把 `pyproject.toml` 与 `uv.lock` 纳入版本控制，不提交 `.venv/`。已有锁文件的环境可用 `uv sync --locked` 复现；此命令要求锁文件已同步。日常用 `uv run <命令>`；它会检查并同步项目环境，可能下载解释器或依赖。

## 手动激活与验证

通常优先用 `uv run`。手动激活前先在项目中完成同步：

=== "Git Bash / WSL / macOS / Linux"
    ```bash
    source .venv/bin/activate
    command -v python
    python -c "import sys; print(sys.executable); print(sys.version)"
    deactivate
    ```

=== "PowerShell 7"
    ```powershell
    .\.venv\Scripts\Activate.ps1
    Get-Command python
    python -c "import sys; print(sys.executable); print(sys.version)"
    deactivate
    ```

Windows Git Bash 的脚本路径是 `.venv/Scripts/activate`。检查 `command -v python`；不要在 Windows 与 WSL 之间复用环境目录。

## 用 uv 管理独立 CLI

`uvx <工具>`（即 `uv tool run`）适合临时运行；长期使用可 `uv tool install <工具>`，并确认 uv 的工具可执行目录在 PATH。用 `uv tool list` 查看，用 `uv tool uninstall <工具>` 卸载。一次性缓存不是项目依赖；不要手动改 uv 创建的工具环境。参见[uv 工具文档](https://docs.astral.sh/uv/concepts/tools/)。

## 安装 Anaconda3 与初始化 Conda

![Anaconda Navigator 的环境列表与包管理界面](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/conda-navigator-envs.png){ loading=lazy width="900" }

*来源：[Anaconda Navigator 环境管理教程](https://www.anaconda.com/docs/tools/anaconda-navigator/tutorials/manage-environments)。此图展示 Conda 环境的图形界面；本页的新项目仍以 uv 命令行为主。*

从 [Anaconda 官方下载页](https://www.anaconda.com/download)选择系统和架构对应的安装包。避免将 Conda 添加到系统全局 PATH；先用 Anaconda Prompt 验证 `conda --version`、`conda info --base`，再按官方说明初始化需要使用的 shell。安装器和渠道会变化，本文不固定个人安装路径。

## 用 Conda 管理环境、依赖与导出

在独立练习目录创建具名环境。下面的 Python 3.12 只是示例，应换成项目支持版本：

```bash
conda create -n "python-env-lab-conda" python=3.12
conda activate "python-env-lab-conda"
python -c "import sys; print(sys.executable); print(sys.version)"
conda install "rich"
python -c "import rich; print(rich.__version__)"
conda env export --from-history > "environment.yml"
conda deactivate
```

恢复可用 `conda env create -f "environment.yml"`，跨平台时检查平台专属依赖。导出 `--from-history` 记录显式请求的包，完整 `conda env export` 会包含平台构建信息，移植性较低。优先由 Conda 管理该环境中的包；确有需要才用目标环境的 `python -m pip`。不要拿 uv 锁文件管理 Conda 环境。

## Windows、WSL 与两种管理器共存

一个项目选一种环境所有者：uv 项目用 `.venv` 和锁文件，Conda 项目用具名环境与环境文件。不要复制 Windows `.venv` 到 WSL，也不要同时激活两类环境。两侧的 HOME、PATH、凭据和解释器不自动共享。

```bash
command -v python
python -c "import sys; print(sys.executable)"
uv python find
conda info --envs
```

MCP 服务或 Python CLI 要在它实际运行的一侧安装依赖。独立二进制 Harness 不需要因“AI 工具”而额外安装 Python。

## 排障、练习与参考

找不到 Python 时，先检查激活状态和解释器路径，不要盲目重装。Conda 无法激活时，先在 Anaconda Prompt 验证，再按官方说明初始化当前 shell。锁文件不一致时，区分复现（`uv sync --locked`）与主动更新。Windows/WSL 混用时分别检查 `command -v`、`where.exe python` 或 `Get-Command python`。

练习：在两个独立目录分别建 uv 项目和 Conda 环境，验证解释器路径、导入依赖、退出后 Python 来源；确认各自的项目文件可用于复现。

参考：[uv 安装](https://docs.astral.sh/uv/getting-started/installation/)、[uv 项目](https://docs.astral.sh/uv/guides/projects/)、[Conda 环境](https://docs.conda.io/projects/conda/en/stable/user-guide/tasks/manage-environments.html)。
