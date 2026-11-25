---
date: 2026-11-25
authors:
  - ramonmi
categories:
  - Windows
  - AI Agents
tags:
  - Windows
  - C盘空间
  - Agent
  - VS Code
  - WSL
  - Docker
  - nvm
  - npm
---

# Agent 时代，如何给 C 盘瘦身

如果系统盘只有 100～200 GB，Windows、开发环境和日常软件很容易挤在一起。最近几年，Codex、Claude、Gemini 等 Agent 工具也会在用户目录和 `AppData` 下保存配置、缓存、会话数据和运行组件。用得越久，C 盘越容易告急。

本文介绍一种适合**个人数据和应用数据目录**的迁移方法：用 `robocopy` 把目录搬到其他磁盘，再在原位置创建目录符号链接。CMD 使用内置命令 `mklink /D`，PowerShell / pwsh 使用 `New-Item -ItemType SymbolicLink`。程序仍访问原路径，数据则存放在目标盘。

这不是把整个 `AppData` 或 Windows 系统目录搬走。我们先列出需要迁移的目录名称，再按 `%USERPROFILE%`、`AppData\Roaming`、`AppData\Local` 等位置分别处理。不同软件版本和安装方式可能使用不同目录，执行前先确认本机实际路径。

<!-- more -->

## 先了解两个命令

### 用 `robocopy` 迁移目录

`robocopy` 是 Windows 自带的文件复制命令，适合复制包含大量文件的目录。中断后可以重跑；配合 `/MOVE`，成功复制的文件会从源目录删除。

下方标签页提供 CMD 与 PowerShell / pwsh 两种写法：

=== "CMD"

    ```cmd
    robocopy "C:\源目录" "D:\目标目录" /E /MOVE /Z /R:1 /W:3 /MT:8 /ETA
    ```

=== "PowerShell / pwsh"

    ```powershell
    & robocopy 'C:\源目录' 'D:\目标目录' /E /MOVE /Z /R:1 /W:3 /MT:8 /ETA
    ```

常用参数：

| 参数 | 作用 |
| --- | --- |
| `/E` | 复制所有子目录，包括空目录 |
| `/MOVE` | 移动文件和目录；成功复制后从源位置删除 |
| `/Z` | 使用可重启模式，适合中断后继续 |
| `/R:1` | 失败时重试 1 次 |
| `/W:3` | 重试间隔 3 秒 |
| `/MT:8` | 使用 8 个线程并行复制文件 |
| `/ETA` | 显示预计剩余时间 |

`/MT` 在 Windows 10 和 Windows 11 的 Robocopy 中可用，不要求专业版或服务器版。线程数可设为 1～128；指定 `/MT` 但省略数字时默认使用 8。本文涉及的配置和缓存目录往往包含许多小文件，`/MT:8` 可以作为起点，但不是必选项，实际耗时也不一定会缩短。若源盘或目标盘是较慢的机械硬盘，或复制时电脑还在执行其他磁盘密集任务，可尝试 `/MT:4` 或去掉 `/MT`；复制单个大文件、磁盘本身已成为瓶颈时，多线程通常帮助有限。

`robocopy` 的退出码不完全遵循“0 成功、非 0 失败”的习惯：微软文档将 8 及以上定义为至少有一次复制失败；低于 8 的结果仍应结合输出检查是否有额外文件或不匹配。不要只看命令窗口最后一行就认为数据已核对完成。

### 创建目录符号链接：CMD 的 `mklink` 与 PowerShell 的 `New-Item`

移动完成后，原目录路径通常已经不存在。`mklink` 是 CMD 内置命令，不能作为 PowerShell 命令直接运行；在 CMD 中用 `mklink /D` 创建目录符号链接，在 PowerShell / pwsh 中用 `New-Item -ItemType SymbolicLink` 创建同类链接。选择对应终端的写法：

Windows 默认要求进程**具有创建符号链接的权限**，通常需要**以管理员身份打开 CMD、Windows PowerShell 或 pwsh**。这一权限规则对 `mklink` 与 PowerShell 的 `New-Item` 都适用。`mklink /J` 是 CMD 创建目录联接点的选项，行为与符号链接有区别，本文在 CMD 示例中统一使用 `/D`。

!!! warning "迁移与创建链接分两个阶段"
    - **阶段一**：在原用户的普通终端中运行 `robocopy` 并核对目标数据。复制/移动这些用户目录通常不需要管理员权限；使用原用户终端也能确保 `%USERPROFILE%`、`%APPDATA%`、`%LOCALAPPDATA%` 指向正确的用户配置。

    - **阶段二**：以管理员身份打开本节对应的 CMD、Windows PowerShell 或 pwsh，再运行创建链接命令。

#### 打开管理员终端

- **CMD/Windows PowerShell/PowerShell 7(pwsh)**：按 `Win+S`，搜索“命令提示符”/`cmd` 或 `Windows PowerShell` 或 `pwsh`，选择“以管理员身份运行”，并在 UAC 弹窗提示中确认。
- **Windows Terminal**：按 `Win+X`，选择“终端(管理员)”；打开配置文件菜单，再选择“命令提示符”或“Windows PowerShell”或“PowerShell 7”。管理员权限会作用于新建的对应 shell 终端。

=== "CMD"

    ```cmd
    mklink /D "%USERPROFILE%\.codex" "D:\AgentData\UserProfile\.codex"
    ```

=== "PowerShell / pwsh"

    ```powershell
    New-Item -ItemType SymbolicLink `
        -Path (Join-Path $env:USERPROFILE '.codex') `
        -Target 'D:\AgentData\UserProfile\.codex'
    ```

应用访问 `%USERPROFILE%\.codex` 时，Windows 会沿着链接访问 D 盘目录。请区分这两个路径：第一个是链接所在的**原路径**，第二个是真正保存文件的**目标路径**。

## 开始前：确认目录与目标盘

!!! warning "替换示例目标目录"
    以下示例把数据放到 `D:\AgentData`。请改成自己的目标盘和目录；不要照抄示例盘符。

1. 先用资源管理器或磁盘分析工具找出实际占空间的目录。迁移小目录不会明显释放空间。
2. **关闭要迁移的应用和终端，包括仍在后台运行的 Agent、VS Code、浏览器或同步程序。**
3. 确认目标磁盘有足够空间，并且不是即将移除的移动硬盘。
4. 重要数据先备份。首次操作建议只迁移一个目录，验证成功后再继续。
5. 不要移动整个 `%USERPROFILE%`、整个 `AppData`、`WindowsApps` 或其他系统管理目录。

下面的 CMD 示例是在**交互式 CMD 窗口**中执行的。若保存为 `.cmd` 批处理文件，`for` 循环中的 `%N` 要写成 `%%N`。迁移阶段使用原用户的普通终端；创建链接阶段以管理员身份打开本节对应的终端后执行命令。

## 按目录分组迁移

基本步骤对每组都相同：设置源路径、目标路径和目录名称集合；运行 `robocopy`；确认目标目录内容完整；再为每个目录创建链接。如果源目录仍存在，先检查它是否为空；不要直接删除仍含有文件的源目录。

### AI Agent 与 CLI 的用户数据目录速查

下表汇总 AI Agents 页面介绍的 9 个 Harness，以及 Gemini CLI、Antigravity CLI 和 GitHub Copilot CLI 的常见 Windows 用户数据目录。它们是**可选迁移候选项**，不是要求全部搬走；先确认目录实际存在、体积值得迁移，并区分配置、会话、缓存和程序安装文件。修改目录变量时，可把确认过的目录名加入前面对应的 `%USERPROFILE%` 或 `AppData\Local` 分组。

| 工具 | 可选迁移目录 | 说明 |
| --- | --- | --- |
| [Codex](../../ai-agents/harnesses/codex.md) | `%USERPROFILE%\.codex` | Codex 用户配置、会话等数据；也可通过 `CODEX_HOME` 指定数据根目录。 |
| [Claude Code](../../ai-agents/harnesses/claude-code.md) | `%USERPROFILE%\.claude` | 用户配置和会话数据；可通过 `CLAUDE_CONFIG_DIR` 指定配置目录。 |
| [OpenCode](../../ai-agents/harnesses/opencode.md) | `%USERPROFILE%\.config\opencode`；数据、状态和缓存路径以 `opencode debug paths` 输出为准 | 用户配置目录可直接核对；其他目录会受 XDG 环境变量、发布渠道和版本影响。 |
| [Pi](../../ai-agents/harnesses/pi.md) | `%USERPROFILE%\.pi\agent` | 默认配置和用户数据目录；可用 `PI_CODING_AGENT_DIR` 改写。 |
| [Oh My Pi](../../ai-agents/harnesses/oh-my-pi.md) | `%USERPROFILE%\.omp` | 用户配置和会话等数据；可通过 `PI_CONFIG_DIR` 或 `PI_CODING_AGENT_DIR` 改写部分目录。 |
| [DSH](../../ai-agents/harnesses/dsh.md) | 暂无可确认的稳定用户数据目录 | npm 全局安装位置和 npm 缓存不是 DSH 专属用户数据，不建议据此直接迁移。 |
| [Kimi Code](../../ai-agents/harnesses/kimi-code.md) | `%USERPROFILE%\.kimi-code` | 可用 `KIMI_CODE_HOME` 指定数据根目录。 |
| [WorkBuddy](../../ai-agents/harnesses/workbuddy.md) | 暂无可确认的受支持迁移目录 | 桌面应用数据位置以应用设置或官方文档为准，不要猜测并搬动 `Packages` 下目录。 |
| [Hermes Agent](../../ai-agents/harnesses/hermes.md) | `%LOCALAPPDATA%\hermes` | 原生 Windows 默认数据目录；`HERMES_HOME` 可指定其他位置。 |
| [Gemini CLI](https://geminicli.com/docs/reference/configuration/) | `%USERPROFILE%\.gemini` | Gemini CLI 默认用户数据目录；可用 `GEMINI_CLI_HOME` 指定根目录。若仍在使用 Gemini CLI，可按需迁移。Antigravity CLI 也使用该目录树。 |
| [Antigravity CLI](https://antigravity.google/docs/settings) | `%USERPROFILE%\.gemini\antigravity-cli` | 用户设置和 CLI 数据目录；整个 `.gemini` 目录也包含 Gemini CLI 的用户数据。 |
| [GitHub Copilot CLI](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference) | `%USERPROFILE%\.copilot`；缓存 `%LOCALAPPDATA%\copilot` | 可分别用 `COPILOT_HOME` 和 `COPILOT_CACHE_HOME` 指定位置。此行指 Copilot CLI；VS Code 中 Copilot 扩展的数据随前文 `%APPDATA%\Code` 目录处理。 |

OpenCode、Gemini CLI、Antigravity CLI、Copilot CLI 等工具支持通过环境变量更改部分目录；若选择这种方式，应按各自文档设置并迁移数据，不要同时对同一路径建立符号链接。Gemini CLI 与 Antigravity CLI 的目录存在包含关系：移动整个 `.gemini` 后，不要再把 `antigravity-cli` 子目录重复加入迁移名单。

### 1. `%USERPROFILE%` 下的 Agent 和开发工具目录

占用空间较大的待移动候选项包括 `.codex`、`.claude`、`.agents`、`.config`、`.cache`、`.herdr` 等。下面只列出 Agent 相关的常见项；请按自己电脑上的目录调整名单。

!!! tip "阶段一｜普通用户终端迁移"
    在原用户的普通终端中运行迁移命令，确认目标数据完整后，再进行第二阶段。

=== "CMD"

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    set "GROUP=UserProfile"
    set "SOURCE_ROOT=%USERPROFILE%"
    set "NAMES=.codex .claude .gemini .agents .config .cache"

    for %N in (%NAMES%) do @if exist "%SOURCE_ROOT%\%N\" robocopy "%SOURCE_ROOT%\%N" "%TARGET_ROOT%\%GROUP%\%N" /E /MOVE /Z /R:1 /W:3 /MT:8
    ```

    !!! warning "阶段二｜以管理员身份创建链接"
        “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    set "GROUP=UserProfile"
    set "SOURCE_ROOT=%USERPROFILE%"
    set "NAMES=.codex .claude .gemini .agents .config .cache"

    for %N in (%NAMES%) do @if exist "%TARGET_ROOT%\%GROUP%\%N\" mklink /D "%SOURCE_ROOT%\%N" "%TARGET_ROOT%\%GROUP%\%N"
    ```

=== "PowerShell / pwsh"

    ```powershell
    $targetRoot = 'D:\AgentData'
    $group = 'UserProfile'
    $sourceRoot = $env:USERPROFILE
    $names = @('.codex', '.claude', '.gemini', '.agents', '.config', '.cache')

    foreach ($name in $names) {
        $source = Join-Path $sourceRoot $name
        $target = Join-Path (Join-Path $targetRoot $group) $name
        if (Test-Path -LiteralPath $source) {
            & robocopy $source $target /E /MOVE /Z /R:1 /W:3 /MT:8
            if ($LASTEXITCODE -ge 8) {
                throw "robocopy 失败，退出码：$LASTEXITCODE，源目录：$source"
            }
        }
    }
    ```

    !!! warning "阶段二｜以管理员身份创建链接"
        “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

    ```powershell
    foreach ($name in $names) {
        $source = Join-Path $sourceRoot $name
        $target = Join-Path (Join-Path $targetRoot $group) $name
        if ((Test-Path -LiteralPath $target) -and -not (Test-Path -LiteralPath $source)) {
            New-Item -ItemType SymbolicLink -Path $source -Target $target
        } elseif (Test-Path -LiteralPath $source) {
            throw "原路径仍存在，请确认它为空并手动移除后再创建链接：$source"
        }
    }
    ```

Codex 常用目录是 `.codex`，Claude Code 使用 `.claude`，Gemini CLI 使用 `.gemini`；`.agents` 和 `.config` 可能被多个工具共用。迁移 `.config` 前先检查其中内容，也确认其他工具没有依赖它下面的路径。

### 2. `%USERPROFILE%\AppData\Roaming`

`Roaming` 中常见的是应用配置和用户状态。可选移动文件夹示例包括 `Tencent`、`Kingsoft`、`QQ`、`DingTalk`、`obsidian`、`Codex` 等。它们只是候选目录，不代表每台电脑都存在或都值得迁移。

!!! tip "阶段一｜普通用户终端迁移"
    在原用户的普通终端中运行迁移命令，确认目标数据完整后，再进行第二阶段。

=== "CMD"

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    set "GROUP=AppData\Roaming"
    set "SOURCE_ROOT=%USERPROFILE%\AppData\Roaming"
    set "NAMES=Codex obsidian Tencent Kingsoft"

    for %N in (%NAMES%) do @if exist "%SOURCE_ROOT%\%N\" robocopy "%SOURCE_ROOT%\%N" "%TARGET_ROOT%\%GROUP%\%N" /E /MOVE /Z /R:1 /W:3 /MT:8
    ```

    !!! warning "阶段二｜以管理员身份创建链接"
        “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    set "GROUP=AppData\Roaming"
    set "SOURCE_ROOT=%USERPROFILE%\AppData\Roaming"
    set "NAMES=Codex obsidian Tencent Kingsoft"

    for %N in (%NAMES%) do @if exist "%TARGET_ROOT%\%GROUP%\%N\" mklink /D "%SOURCE_ROOT%\%N" "%TARGET_ROOT%\%GROUP%\%N"
    ```

=== "PowerShell / pwsh"

    ```powershell
    $targetRoot = 'D:\AgentData'
    $group = 'AppData\Roaming'
    $sourceRoot = Join-Path $env:USERPROFILE 'AppData\Roaming'
    $names = @('Codex', 'obsidian', 'Tencent', 'Kingsoft')

    foreach ($name in $names) {
        $source = Join-Path $sourceRoot $name
        $target = Join-Path (Join-Path $targetRoot $group) $name
        if (Test-Path -LiteralPath $source) {
            & robocopy $source $target /E /MOVE /Z /R:1 /W:3 /MT:8
            if ($LASTEXITCODE -ge 8) {
                throw "robocopy 失败，退出码：$LASTEXITCODE，源目录：$source"
            }
        }
    }
    ```

    !!! warning "阶段二｜以管理员身份创建链接"
        “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

    ```powershell
    foreach ($name in $names) {
        $source = Join-Path $sourceRoot $name
        $target = Join-Path (Join-Path $targetRoot $group) $name
        if ((Test-Path -LiteralPath $target) -and -not (Test-Path -LiteralPath $source)) {
            New-Item -ItemType SymbolicLink -Path $source -Target $target
        } elseif (Test-Path -LiteralPath $source) {
            throw "原路径仍存在，请确认它为空并手动移除后再创建链接：$source"
        }
    }
    ```

### 3. `%USERPROFILE%\AppData\Local`

`Local` 常见的是缓存、更新器和体积较大的应用数据。手册中的候选项包括 `pip`、`uv`、浏览器目录、npm 缓存等。浏览器配置目录可能包含登录状态和个人数据，迁移前务必关闭浏览器并做好备份。

#### npm 的全局安装路径与缓存路径 { #npm-path-config }

也可以让 npm 直接把**全局包**和**缓存**写到非系统盘。下面的路径仅为示例，请换成实际目标盘。`npm config set` 会更新当前用户的 npm 配置；设置新路径不会自动搬动已有全局包或缓存。若已准备在下面的目录迁移步骤中移动并链接 `%LOCALAPPDATA%\npm-cache`，不要再同时为同一个缓存设置新路径，选择一种方式即可。

**仅适用于不使用 nvm 管理 Node.js/npm 的安装方式**：设置当前用户的全局包安装前缀和缓存目录，并查看生效值。

=== "CMD"

    ```cmd
    npm config set prefix "D:\AgentData\npm\global" --location=user
    npm config set cache "D:\AgentData\npm\cache" --location=user
    npm config get prefix
    npm config get cache
    npm root -g
    ```

=== "PowerShell / pwsh"

    ```powershell
    npm config set prefix 'D:\AgentData\npm\global' --location=user
    npm config set cache 'D:\AgentData\npm\cache' --location=user
    npm config get prefix
    npm config get cache
    npm root -g
    ```

Windows 下 npm 全局安装的命令入口放在 `prefix` 目录中；如果命令无法直接运行，把所设的 `prefix` 目录加入用户 `PATH`，再新开终端。设置完成后新装的全局包会进入该位置，已有包需按需重新安装。

!!! warning "nvm 用户不要设置 npm prefix"
    如果用 nvm 或 nvm-windows 切换 Node.js/npm 版本，**不要执行上面的 `npm config set prefix ...`**，也不要把全局包固定到一个跨版本共用的目录。让版本管理器保留默认的全局包路径。缓存可以单独迁移，例如只执行 `npm config set cache "D:\AgentData\npm\cache" --location=user`，不会改变全局包的安装前缀。

#### 迁移 Local 中已有的缓存目录

如果希望用符号链接搬迁现有的默认缓存，而不是更改 npm 缓存位置：

- CMD：在下面“迁移”和“创建链接”两段命令中，都把 `set "NAMES=pip uv"` 改为 `set "NAMES=pip uv npm-cache"`。
- PowerShell / pwsh：把 `$names = @('pip', 'uv')` 改为 `$names = @('pip', 'uv', 'npm-cache')`；后续迁移和建链接循环会共用这个变量。

采用符号链接方式时，跳过 [“npm 的全局安装路径与缓存路径”小节](#npm-path-config)中的 `npm config set cache ...` 命令；`prefix` 是全局包安装路径的独立设置，不属于缓存迁移步骤。配置缓存或使用符号链接二选一，避免同时更改同一缓存的位置。

!!! tip "阶段一｜普通用户终端迁移"
    在原用户的普通终端中运行迁移命令，确认目标数据完整后，再进行第二阶段。

=== "CMD"

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    set "GROUP=AppData\Local"
    set "SOURCE_ROOT=%USERPROFILE%\AppData\Local"
    set "NAMES=pip uv"

    for %N in (%NAMES%) do @if exist "%SOURCE_ROOT%\%N\" robocopy "%SOURCE_ROOT%\%N" "%TARGET_ROOT%\%GROUP%\%N" /E /MOVE /Z /R:1 /W:3 /MT:8
    ```

    !!! warning "阶段二｜以管理员身份创建链接"
        “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    set "GROUP=AppData\Local"
    set "SOURCE_ROOT=%USERPROFILE%\AppData\Local"
    set "NAMES=pip uv"

    for %N in (%NAMES%) do @if exist "%TARGET_ROOT%\%GROUP%\%N\" mklink /D "%SOURCE_ROOT%\%N" "%TARGET_ROOT%\%GROUP%\%N"
    ```

=== "PowerShell / pwsh"

    ```powershell
    $targetRoot = 'D:\AgentData'
    $group = 'AppData\Local'
    $sourceRoot = Join-Path $env:USERPROFILE 'AppData\Local'
    $names = @('pip', 'uv')

    foreach ($name in $names) {
        $source = Join-Path $sourceRoot $name
        $target = Join-Path (Join-Path $targetRoot $group) $name
        if (Test-Path -LiteralPath $source) {
            & robocopy $source $target /E /MOVE /Z /R:1 /W:3 /MT:8
            if ($LASTEXITCODE -ge 8) {
                throw "robocopy 失败，退出码：$LASTEXITCODE，源目录：$source"
            }
        }
    }
    ```

    !!! warning "阶段二｜以管理员身份创建链接"
        “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

    ```powershell
    foreach ($name in $names) {
        $source = Join-Path $sourceRoot $name
        $target = Join-Path (Join-Path $targetRoot $group) $name
        if ((Test-Path -LiteralPath $target) -and -not (Test-Path -LiteralPath $source)) {
            New-Item -ItemType SymbolicLink -Path $source -Target $target
        } elseif (Test-Path -LiteralPath $source) {
            throw "原路径仍存在，请确认它为空并手动移除后再创建链接：$source"
        }
    }
    ```

### 4. ChatGPT Desktop 的 Packages 目录单独处理

ChatGPT Desktop 除了 `%LOCALAPPDATA%\OpenAI` 和 `%APPDATA%\Codex`，还可能在 `%LOCALAPPDATA%\Packages` 下有一个名称类似 `OpenAI.Codex_...` 的目录。包目录名带有发行者标识，可能随安装来源或版本变化，先在本机确认准确名称，不要把下面的占位名原样执行。

将准确名称填入变量，然后选择终端执行。

!!! tip "阶段一｜普通用户终端迁移"
    先迁移并检查目标内容，确认无误后再进行第二阶段。

=== "CMD"

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    set "PACKAGE_NAME=OpenAI.Codex_请替换为本机完整目录名"
    set "SOURCE=%LOCALAPPDATA%\Packages\%PACKAGE_NAME%"
    set "TARGET=%TARGET_ROOT%\ChatGPT\Packages\%PACKAGE_NAME%"

    robocopy "%SOURCE%" "%TARGET%" /E /MOVE /Z /R:1 /W:3 /MT:8
    ```

    !!! warning "阶段二｜以管理员身份创建链接"
        “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

    ```cmd
    mklink /D "%SOURCE%" "%TARGET%"
    ```

=== "PowerShell / pwsh"

    ```powershell
    $targetRoot = 'D:\AgentData'
    $packageName = 'OpenAI.Codex_请替换为本机完整目录名'
    $source = Join-Path (Join-Path $env:LOCALAPPDATA 'Packages') $packageName
    $target = Join-Path (Join-Path $targetRoot 'ChatGPT\Packages') $packageName

    & robocopy $source $target /E /MOVE /Z /R:1 /W:3 /MT:8
    if ($LASTEXITCODE -ge 8) {
        throw "robocopy 失败，退出码：$LASTEXITCODE，源目录：$source"
    }
    ```

    !!! warning "阶段二｜以管理员身份创建链接"
        “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

    ```powershell
    New-Item -ItemType SymbolicLink -Path $source -Target $target
    ```

如果创建链接时提示原路径已存在，先检查该路径是否仍是实体目录，确认内容已迁移且目录为空后再处理。移动后先启动 ChatGPT 并检查会话、设置和更新是否正常。手册记录过通过 Windows“已安装的应用”移动 ChatGPT 后应用无法启动的情况，因此这部分应当作为单独尝试，并保留恢复原状的备份。

不要把 `%ProgramFiles%\WindowsApps` 或 `%ProgramData%\Microsoft\Windows\AppRepository` 下的安装文件当作普通用户数据目录来搬动；它们由 Windows 管理，目录名称也可能随应用版本变化。

### 5. VS Code 用户数据和扩展

VS Code 默认把用户数据放在 `%APPDATA%\Code`，扩展放在 `%USERPROFILE%\.vscode\extensions`。**优先建议使用目录符号链接**：迁移后 VS Code 仍访问默认路径，无需修改快捷方式的启动命令。先完全退出 VS Code，再按下面步骤操作。示例目标目录分别对应前文的 `AppData\Roaming` 和 `%USERPROFILE%` 分组。

!!! tip "阶段一｜普通用户终端迁移"
    先迁移目录，并确认目标数据完整后再进行第二阶段。

=== "CMD"

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    if exist "%APPDATA%\Code\" robocopy "%APPDATA%\Code" "%TARGET_ROOT%\AppData\Roaming\Code" /E /MOVE /Z /R:1 /W:3 /MT:8
    if exist "%USERPROFILE%\.vscode\extensions\" robocopy "%USERPROFILE%\.vscode\extensions" "%TARGET_ROOT%\UserProfile\.vscode\extensions" /E /MOVE /Z /R:1 /W:3 /MT:8
    ```

=== "PowerShell / pwsh"

    ```powershell
    $targetRoot = 'D:\AgentData'
    $codeSource = Join-Path $env:APPDATA 'Code'
    $codeTarget = Join-Path $targetRoot 'AppData\Roaming\Code'
    $extensionsSource = Join-Path $env:USERPROFILE '.vscode\extensions'
    $extensionsTarget = Join-Path $targetRoot 'UserProfile\.vscode\extensions'

    foreach ($pair in @(
        @{ Source = $codeSource; Target = $codeTarget },
        @{ Source = $extensionsSource; Target = $extensionsTarget }
    )) {
        if (Test-Path -LiteralPath $pair.Source) {
            & robocopy $pair.Source $pair.Target /E /MOVE /Z /R:1 /W:3 /MT:8
            if ($LASTEXITCODE -ge 8) {
                throw "robocopy 失败，退出码：$LASTEXITCODE，源目录：$($pair.Source)"
            }
        }
    }
    ```

!!! warning "阶段二｜以管理员身份创建链接"
    “以管理员身份运行”打开本节对应的 CMD、Windows PowerShell 或 pwsh，再执行下方创建链接命令。

=== "CMD"

    ```cmd
    set "TARGET_ROOT=D:\AgentData"
    if exist "%TARGET_ROOT%\AppData\Roaming\Code\" mklink /D "%APPDATA%\Code" "%TARGET_ROOT%\AppData\Roaming\Code"
    if exist "%TARGET_ROOT%\UserProfile\.vscode\extensions\" mklink /D "%USERPROFILE%\.vscode\extensions" "%TARGET_ROOT%\UserProfile\.vscode\extensions"
    ```

=== "PowerShell / pwsh"

    ```powershell
    $targetRoot = 'D:\AgentData'
    $codeSource = Join-Path $env:APPDATA 'Code'
    $codeTarget = Join-Path $targetRoot 'AppData\Roaming\Code'
    $extensionsSource = Join-Path $env:USERPROFILE '.vscode\extensions'
    $extensionsTarget = Join-Path $targetRoot 'UserProfile\.vscode\extensions'

    foreach ($pair in @(
        @{ Source = $codeSource; Target = $codeTarget },
        @{ Source = $extensionsSource; Target = $extensionsTarget }
    )) {
        if ((Test-Path -LiteralPath $pair.Target) -and -not (Test-Path -LiteralPath $pair.Source)) {
            New-Item -ItemType SymbolicLink -Path $pair.Source -Target $pair.Target
        } elseif (Test-Path -LiteralPath $pair.Source) {
            throw "原路径仍存在，请确认它为空并手动移除后再创建链接：$($pair.Source)"
        }
    }
    ```

启动 VS Code 并确认用户设置和扩展都正常加载。若不使用符号链接，也可以用 `--user-data-dir` 和 `--extensions-dir` 参数指定新位置；这需要在启动命令中添加参数，快捷方式启动方式也要相应调整：

=== "CMD"

    ```cmd
    code --user-data-dir "D:\AgentData\VSCode\UserData" --extensions-dir "D:\AgentData\VSCode\Extensions"
    ```

=== "PowerShell / pwsh"

    ```powershell
    code --user-data-dir 'D:\AgentData\VSCode\UserData' --extensions-dir 'D:\AgentData\VSCode\Extensions'
    ```

### 6. WSL 发行版数据

WSL 2 发行版的 Linux 文件系统存放在虚拟磁盘中。不要在发行版运行时用资源管理器直接搬动它的 `ext4.vhdx`。优先使用 WSL 提供的迁移命令；较新的 WSL 还支持安装时直接指定位置。执行前用 `wsl --list --verbose` 确认发行版名称，并用 `wsl --version` 检查 WSL 版本。

#### 新安装时指定目录

较新版本支持 `--location`：

=== "CMD"

    ```cmd
    wsl --install -d Ubuntu --location "D:\WSL\Ubuntu"
    ```

=== "PowerShell / pwsh"

    ```powershell
    wsl --install -d Ubuntu --location 'D:\WSL\Ubuntu'
    ```

#### 将已有发行版移动到其他磁盘

如果当前 WSL 版本支持 `wsl --manage <发行版> --move <目标目录>`，可先彻底关闭 WSL，再移动发行版。该方式保留原有发行版注册名称，例如仍叫 `Ubuntu`：

=== "CMD"

    ```cmd
    wsl --list --verbose
    wsl --shutdown
    wsl --manage Ubuntu --move "D:\WSL\Ubuntu"
    wsl --list --verbose
    ```

=== "PowerShell / pwsh"

    ```powershell
    wsl --list --verbose
    wsl --shutdown
    wsl --manage Ubuntu --move 'D:\WSL\Ubuntu'
    wsl --list --verbose
    ```

确认发行版已停止，并检查目标目录和发行版能否正常启动。若 `--manage` 或 `--move` 不受当前版本支持，先运行 `wsl --update`；仍不可用时，可用下面的导出、注销、导入流程。

#### 兼容旧版 WSL：导出后导入到指定目录

导出归档需要额外磁盘空间，先确认目标盘有足够空间。导出成功并确认归档存在后，注销旧发行版，再用**相同名称**导入到新目录。`wsl --unregister` 会删除原发行版数据，不能跳过导出和核验。

=== "CMD"

    ```cmd
    wsl --list --verbose
    wsl --shutdown
    wsl --export Ubuntu "D:\WSL\Ubuntu.tar"
    rem 确认导出成功且归档文件存在后再继续
    wsl --unregister Ubuntu
    wsl --import Ubuntu "D:\WSL\Ubuntu" "D:\WSL\Ubuntu.tar" --version 2
    wsl --list --verbose
    ```

=== "PowerShell / pwsh"

    ```powershell
    wsl --list --verbose
    wsl --shutdown
    wsl --export Ubuntu 'D:\WSL\Ubuntu.tar'
    # 确认导出成功且归档文件存在后再继续
    wsl --unregister Ubuntu
    wsl --import Ubuntu 'D:\WSL\Ubuntu' 'D:\WSL\Ubuntu.tar' --version 2
    wsl --list --verbose
    ```

导入发行版后默认用户可能变成 `root`。如启动后发现用户不对，在该发行版的 `/etc/wsl.conf` 中设置 `[user]` 下的 `default=<Linux用户名>`，再运行 `wsl --shutdown` 重启。

#### 把 WSL swap 文件放到非 C 盘

WSL 2 的 swap 是虚拟机使用的磁盘交换空间，`.wslconfig` 中的 `swapFile` 可指定它的绝对 Windows 路径。这项设置对所有 WSL 2 发行版生效。先在目标盘创建目录，例如 `D:\WSL\Swap`，再选择以下一种方法设置。

**方法一：使用 WSL Settings 图形界面**

1. 从 Windows“开始”菜单打开 **WSL Settings**（适用于 Linux 的 Windows 子系统设置）。
2. 打开 **Advanced settings**，找到 **Swap File Location**。
3. 将位置设为 `D:\WSL\Swap\swap.vhdx`，并保存或应用设置。
4. 关闭 WSL 使配置生效。

WSL Settings 会管理全局 WSL 配置；如果应用版本没有显示 Swap File Location，可改用下方 `.wslconfig` 方法。

**方法二：编辑 `%UserProfile%\.wslconfig`**

`.wslconfig` 放在 Windows 用户目录中，对所有 WSL 2 发行版全局生效。可以先用文本编辑器打开该文件；若它不存在，保存时创建即可。若文件已经有 `[wsl2]` 节，不要再添加第二个同名节，把 `swapFile` 合并到现有节中。下面只修改 swap 文件位置，不改变当前 swap 容量；路径使用绝对路径，并在配置文件中把反斜杠写成双反斜杠：

=== "CMD"

    ```cmd
    notepad "%UserProfile%\.wslconfig"
    ```

=== "PowerShell / pwsh"

    ```powershell
    notepad.exe "$env:USERPROFILE\.wslconfig"
    ```

```ini
[wsl2]
swapFile=D:\\WSL\\Swap\\swap.vhdx
```

保存设置后，在 CMD、PowerShell 或 pwsh 中关闭 WSL，再重新启动发行版：

=== "CMD"

    ```cmd
    wsl --shutdown
    wsl -d Ubuntu
    ```

=== "PowerShell / pwsh"

    ```powershell
    wsl --shutdown
    wsl -d Ubuntu
    ```

`wsl --shutdown` 会关闭所有正在运行的 WSL 发行版。微软建议用 WSL Settings 修改配置；手动配置时，文件位置、格式或路径写错会导致设置不生效。

### 7. Docker Desktop 的镜像与容器数据

使用 WSL 2 后端时，Docker Desktop 会把镜像、容器和相关数据保存在它管理的虚拟磁盘中。手册记录的默认数据位置在 `%UserProfile%\AppData\Local\Docker\wsl`，长期使用可能占用不少 C 盘空间。**通过 Docker Desktop 设置迁移数据盘**，不要在资源管理器中手工移动 Docker 管理的 VHDX，也不要把 Docker 内部发行版当作普通 Ubuntu 发行版迁移。

1. 打开 Docker Desktop，进入 **Settings → Resources → Advanced**。
2. 找到 **Disk image location**，点击 **Browse**，选择其他磁盘上的目录，例如 `D:\DockerData`。
3. 点击 **Apply**；如果当前版本显示 **Apply & Restart**，按界面提示应用并重启。
4. 等待 Docker Desktop 完成数据移动并重新启动。部分版本会在所选位置下创建 `DockerDesktopWSL` 子目录；以当前版本实际目录结构为准，不要手工移动或改名其中的文件。

确认 Docker Desktop 能正常启动，再检查原有容器和镜像是否仍可见：

=== "CMD"

    ```cmd
    docker ps -a
    docker image ls
    ```

=== "PowerShell / pwsh"

    ```powershell
    docker ps -a
    docker image ls
    ```

Docker Desktop 更新或界面版本可能调整设置名称；如果找不到 **Disk image location**，先查阅对应版本的 Docker Desktop 设置文档。目标磁盘需要保持可用，否则 Docker Desktop 将无法访问其镜像和容器数据。

## 验证与回滚

完成一组后，先检查链接和应用。选择当前使用的终端：

=== "CMD"

    ```cmd
    dir "%USERPROFILE%" /AL
    ```

=== "PowerShell / pwsh"

    ```powershell
    Get-ChildItem -Force $env:USERPROFILE |
        Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }
    ```

在资源管理器中打开原目录，确认能看到目标盘中的文件；然后启动相关软件，检查配置、数据和写入操作是否正常。还可以比较迁移前后的目录大小和文件数量。

需要回滚时，先关闭对应应用，再删除原路径上的**链接本身**，不要递归删除目标目录。选择当前使用的终端：

=== "CMD"

    ```cmd
    rmdir "%USERPROFILE%\.codex"
    ```

=== "PowerShell / pwsh"

    ```powershell
    Remove-Item -LiteralPath (Join-Path $env:USERPROFILE '.codex')
    ```

删除链接后，将目标目录移动回原路径，再启动应用并确认数据正常。

执行前确认参数指向的是链接路径，而不是目标路径。PowerShell 的 `Remove-Item` 不要添加 `-Recurse`。迁移完成并稳定运行一段时间后，再清理备份。

## 小结

对 C 盘只有 100～200 GB 的电脑，通常不需要一次性搬走所有目录。先找出真正占空间的 Agent 数据、缓存、VS Code 扩展或 WSL 发行版，再逐组迁移和验证。把目录名称保存在变量里，后续新增工具时只需检查并更新对应分组，减少重复操作和误操作。

参考资料：

- [Microsoft Learn：robocopy](https://learn.microsoft.com/windows-server/administration/windows-commands/robocopy)
- [Microsoft Learn：mklink](https://learn.microsoft.com/windows-server/administration/windows-commands/mklink)
- [Microsoft Learn：PowerShell `New-Item` 符号链接权限](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-item)
- [Microsoft Learn：创建符号链接权限](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/security-policy-settings/create-symbolic-links)
- [Microsoft Learn：CreateSymbolicLink 与非管理员创建选项](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-createsymboliclinkw)
- [Microsoft Learn：WSL 基本命令](https://learn.microsoft.com/windows/wsl/basic-commands)
- [Microsoft Learn：WSL 高级设置与 `.wslconfig`](https://learn.microsoft.com/windows/wsl/wsl-config)
- [Docker Docs：Docker Desktop 设置](https://docs.docker.com/desktop/settings-and-maintenance/settings/)
- [Visual Studio Code：便携模式与数据目录](https://code.visualstudio.com/docs/editor/portable)
- [npm：目录结构、全局 prefix 与缓存](https://docs.npmjs.com/cli/v11/configuring-npm/folders)
- [nvm：npm prefix 与版本管理兼容说明](https://github.com/nvm-sh/nvm#troubleshooting-on-macos)
- [OpenAI Codex CLI：环境变量与数据位置](https://learn.chatgpt.com/docs/config-file/environment-variables)
- [Pi：环境变量](https://docs.pi.dev/latest/environment-variables)
- [Gemini CLI：配置参考](https://geminicli.com/docs/reference/configuration/)
- [Antigravity CLI：设置与数据位置](https://antigravity.google/docs/settings)
- [GitHub Copilot CLI：配置目录参考](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)
- [Anthropic：Claude Code 设置文件](https://code.claude.com/docs/en/settings)
- [Oh My Pi：环境变量与存储目录](https://github.com/can1357/oh-my-pi/blob/main/docs/environment-variables.md)
- [Kimi Code：数据位置](https://moonshotai.github.io/kimi-code/en/configuration/data-locations.html)
- [NousResearch Hermes：用户数据位置](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/switching-to-source.md)
