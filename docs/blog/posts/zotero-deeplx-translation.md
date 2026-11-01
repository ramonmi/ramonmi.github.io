---
title: Zotero DeepLX(API) 翻译服务配置
description: 在 Zotero 翻译插件中配置 DeepLX(API) 服务。
date: 2025-07-27
categories:
  - Zotero
---

# Zotero DeepLX(API) 翻译服务配置

本文记录在 Zotero 翻译插件中选择并配置 DeepLX(API) 服务的过程。

<!-- more -->

## Zotero软件及Translate插件安装

下载 [Zotero](https://www.zotero.org/download/) 并安装，安装成功后打开Zotero软件。

下载 [Translate for Zotero - Github](https://github.com/windingwind/zotero-pdf-translate#install) 插件（或访问 [Zotero 插件商店 | Zotero 中文社区](https://zotero-chinese.com/plugins/) 下载Translate for Zotero插件）。

安装并打开Zotero软件，点击 *工具(Tools)-插件(Plugins)*，将上一步下载得到的 **`.xpi`文件** 拖入 *插件管理器(Plugins Manager)* 即可成功安装。

## LINUX DO DeepLX API配置

### 获取api-key

- [DeepLX已切换至 LINUX DO Connect 认证 - 资源荟萃 - LINUX DO](https://linux.do/t/topic/111737)
    - 注册并登录 [LINUX DO](https://linux.do/) 后点击 <https://connect.linux.do> 获取你的 `<api-key>`，即那一串 `DeepLX Api Key` 字符串。

### 在 Zotero 中配置

- 打开Zotero-设置-翻译，选择服务中的DeepLX(API):round_pushpin:翻译服务（**注意不是选DeepLX服务**），点击 **配置**，将你的接口地址填入 *接口* 并保存即可。
    - 最新的接口地址为：`https://api.deeplx.org/<api-key>/translate`，其中`<api-key>` 需替换为上一步获取的你自己的 `DeepLX Api Key` 字符串

![在 Zotero 翻译设置中选择 DeepLX(API)](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2025/07/20250727_164201.jpeg){ loading=lazy width="900" }

![配置 DeepLX(API) Endpoint](https://cloudflare-imgbed-81c.pages.dev/file/BlogImg/2025/07/20250727_164248.jpeg){ loading=lazy width="900" }

## 使用与验证

- 配置成功后即可使用 Zotero Reader 打开 PDF/Epub/webpage 进行划词翻译。

## See Also

[ Original Post | LINUX DO :lucide-external-link:](https://linux.do/t/topic/819501){ .md-button }
