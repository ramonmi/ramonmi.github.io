---
title: 术语与命令速查
description: 区分 Agent 术语和操作位置，快速找到跨平台环境检查命令。
---

# 术语与命令速查

## 术语表

| 术语 | 含义 |
| --- | --- |
| Agent | 根据任务读取上下文、调用工具、观察反馈并继续工作的程序或角色 |
| Harness | 协调模型、上下文、工具、会话、权限与界面的运行框架 |
| Provider | 提供模型推理/API的服务方 |
| Context | 当前任务中模型可访问的信息集合 |
| Session | 一段交互历史及其工具状态；保存格式因产品而异 |
| Sandbox | 对文件/进程访问的限制机制；不等于提示词约束 |
| Approval | 执行动作前由用户确认 |
| Skill | 可复用任务流程或专业说明，格式依工具而异 |
| MCP | 连接模型客户端与外部工具/资源的协议 |
| Hook | 生命周期某阶段触发的自动命令 |
| Plugin | 扩展宿主能力的组件，格式不通用 |

## 操作应该在哪里输入

系统命令输入普通 shell；斜杠命令输入对应 TUI；快捷键由当前界面捕获；配置项写入官方指定文件。不要把示例命令输入错误位置。

## 常用环境检查

| 目的 | Git Bash / WSL / macOS / Linux | PowerShell 7 |
| --- | --- | --- |
| 当前目录 | `pwd` | `Get-Location` |
| 命令来源 | `command -v tool` | `Get-Command tool` |
| Python解释器 | `python -c "import sys; print(sys.executable)"` | 同左 |
| Node与npm | `node --version && npm --version` | `node --version; npm --version` |
| Git状态 | `git status --short` | 同左 |

Windows 和 WSL 的 HOME、PATH、凭据相互独立。路径含空格请加引号。

## 按主题跳转

安装环境见[Windows](../getting-started/windows.md)、[WSL](../getting-started/wsl.md)、[macOS/Linux](../getting-started/macos-linux.md)、[Python 环境](../getting-started/python-environments.md)；工具命令以各自教程和当前 `--help` 为准；恢复会话、扩展和自动化请参阅[相关专题](../workflows/automation.md)。
