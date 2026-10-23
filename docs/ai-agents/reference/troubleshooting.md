---
title: 常见问题与排障
description: 按终端、安装、认证、网络、配置和会话层次收集证据。
---

# 常见问题与排障

排障目标是收集最小证据，再定位具体层次。提供日志前去掉 API Key、Cookie、用户名私有目录和项目机密。工具特定步骤见[栏目首页](../index.md)的 Harness 列表。

## 排障前先确认环境

记录操作系统/版本、当前 shell、项目目录、工具版本、命令路径、已做步骤和完整错误。Git Bash 用 `pwd`、`command -v tool`；PowerShell 7 用 `$PSVersionTable.PSVersion`、`Get-Command tool`。

## 安装后找不到命令

重新打开终端，检查安装渠道和 PATH 顺序；确认是否有多个同名版本。Windows PowerShell 用 `Get-Command`，Git Bash/WSL 用 `command -v`。先定位旧安装再修改 PATH。

## PowerShell 与配套工具

确认启动的是 `pwsh`（PowerShell 7）还是 `powershell`（Windows PowerShell 5.1）。检查 Git Bash 路径设置是否被工具读取。Herdr 操作须在受管理会话中；先读状态，不对 unknown pane 发送任务。规则文件未生效时核对工具原生格式和目录范围。

## 登录、模型和网络

分开检查账号授权、模型可用性、API 地址/模型 ID、配额、代理与 TLS。浏览器能访问不证明 CLI 子进程可访问。不要关闭 TLS 验证来“修复”连接问题；按工具官方支持方式检查进程代理变量。

## 路径、编码与权限

路径含空格要加引号；区分 Windows 盘符、Git Bash 路径和 WSL 挂载路径。文件显示乱码时检查终端编码和文件字节，不要先覆盖文件。权限弹窗先读清楚具体动作和目标。

## Windows 与 WSL 混用

分别检查命令来源、HOME、凭据、项目路径和运行时。Windows 中安装的 CLI 不一定能在 WSL 使用；两侧配置与虚拟环境不要默认共享。

## 会话、插件与服务

恢复失败先核对工具版本和会话目录，不删除全部用户状态作为第一步。扩展故障逐个停用。Web 服务连不上时看其启动终端和监听地址；排端口先确认进程归属，不终止无关任务。

## 求助时提供的信息

附工具名称/版本、系统和 shell、最小复现步骤、脱敏错误、期望结果与实际结果。删除密钥、个人目录、私有代码和会话内容后再发到官方问题渠道。
