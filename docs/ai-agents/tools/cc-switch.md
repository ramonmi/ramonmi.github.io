---
title: CC Switch 安装与配置
description: 安装 CC Switch 并安全管理受支持 CLI 的服务商配置。
---

# CC Switch 安装与配置

本文指 [farion1231/cc-switch](https://github.com/farion1231/cc-switch) 的桌面工具，不是同名项目。核验日期：2026-10-22；作者未在本机安装、写入配置或使用模型。截至该日期，官方 Releases 最新版为 v4.0.18；后续安装应重新检查[发行页](https://github.com/farion1231/cc-switch/releases)。支持矩阵以[README](https://github.com/farion1231/cc-switch)和[用户手册](https://github.com/farion1231/cc-switch/tree/main/docs/user-manual)为准。先读对应[Harness 认证说明](../harnesses/codex.md)及[Windows](../getting-started/windows.md)、[WSL](../getting-started/wsl.md)环境页。

## CC Switch 的定位

CC Switch 管理部分客户端的提供商与配置；它不发放服务账号、订阅或 API 额度，也不是本栏目每款 Harness 的通用配置器。当前用户手册列出 Claude Code/Desktop、Codex、Gemini CLI、Grok Build、OpenCode、OpenClaw、Hermes、Pi、MiniMax Code 等支持项；不应据此假设 DSH、Kimi Code 或 oh-my-pi 已受支持。不同工具是切换式或共存式管理，详见[按工具支持矩阵](https://github.com/farion1231/cc-switch#supported-features-by-tool)。

## 安装前准备

确认系统架构、客户端版本和真实配置位置；首次启动会导入部分已有客户端配置，但仍先备份目标文件。核对官方 release 发布者与版本，不将真实密钥贴入日志或截图。

## 安装与首次启动

从 [GitHub Releases](https://github.com/farion1231/cc-switch/releases) 下载当前平台资产。Windows 下载 setup 安装包或 portable 版本；macOS/Linux 选择对应发布资产。Linux 桌面依赖依 README 当前说明。启动后检查版本和识别出的应用；不要从非官方镜像下载。

## 认识配置作用域

![CC Switch 的客户端与提供商管理界面](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/cc-switch-main.png){ loading=lazy width="900" }

*来源：[CC Switch 官方截图](https://github.com/farion1231/cc-switch#screenshots)，v4.0.0 界面示例；当前版本布局可能不同。*

确认界面当前选中的客户端，并通过 README 核实它修改哪些文件、数据存在哪里、是否有项目级配置。CC Switch 管理的客户端配置与 CLI 实际读取的配置必须对应同一操作系统用户和环境。

## 添加提供商

打开目标客户端页面，点右上角 “+”，选择 preset 或 Custom Configuration，填写 API Key、endpoint 与模型，再点 Add。preset 会预填部分地址。不要把“兼容某 API 格式”当作所有功能兼容；练习不要输入真实密钥。

需要判断该选 Chat Completions、Responses 还是 Anthropic Messages 时，继续阅读[模型 API 协议与接入](api-protocols.md)。该页以 DeepSeek 为例，分别演示 Codex、Claude Code 的原生接入，以及 CC Switch 的可选协议转换。

## 切换并确认生效

![Codex 客户端中由配置提供的模型列表](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2026/10/codex-switch-model.png){ loading=lazy width="900" }

*界面示例展示经配置后可在 Codex 客户端选择的 provider 模型；列表取决于 CC Switch 配置、客户端版本和账号权限。*

1. 在 CC Switch 选择 provider，点卡片的 Enable；OpenCode、Hermes、Pi 等共存式应用用 Add/Enable 将配置项写入客户端配置。
2. 依软件提示重启 CLI 或终端。Claude Code 支持热更新；Codex 等工具在某些情况下需重启。共存式应用还需在其内部选择模型。
3. 用客户端设置检查当前 endpoint 与 model，再做读者自愿的最小请求。
4. 无法生效时核对配置路径和环境变量是否覆盖设置。

界面显示已选择不等于请求已经走到新服务。若测试会计费，先确认价格和授权。

## Windows 与 WSL 的差异

Windows GUI 与 WSL 有不同 HOME、配置目录和凭据。除非官方文档明确支持 WSL 集成，不要假定 Windows CC Switch 会改写 WSL 内配置。分别在目标环境检查配置路径和 CLI 读取结果。

## 扩展配置管理

Skills、MCP 或其他客户端扩展是否支持统一管理，以官方当前矩阵为准。不同客户端的数据格式和生命周期不同；优先由客户端自身配置扩展，避免两套管理器同时写同一文件。

## 备份、恢复与卸载

备份前确认 README 列出的配置文件、数据库和密钥存储位置；安全保存副本。恢复时先退出客户端，再将备份恢复到原路径，并检查权限。卸载 CC Switch 不必然会还原它改过的客户端文件；需逐项确认。升级前重复备份。

## 常见问题与练习

切换未生效：核对管理模式和客户端配置路径；部分 provider 需本地 routing，是否需要以 provider 的 Needs Routing 标记为准。恢复官方登录时切换回内置官方 provider，再按原客户端重新认证。练习先备份配置，添加无密钥 provider，检查实际文件差异后移除练习项。参考：[快速开始](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/en/1-getting-started/1.4-quickstart.md)、[配置文件说明](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/en/5-faq/5.1-config-files.md)。
