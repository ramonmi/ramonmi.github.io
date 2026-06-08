# 自定义css设置Zotero笔记标签页内容占满幅宽
## 隐藏首选项编辑器打开方式
1. 打开设置Open Settings
![20260604_203024](https://pub-5ab96ca635214cd7a827a11ffc31194a.r2.dev/BlogImg/20260604_203024)
1. 点击**高级**Advanced，点击页面最下方**设置编辑器**Config Editor
![20260604_203048](https://pub-5ab96ca635214cd7a827a11ffc31194a.r2.dev/BlogImg/20260604_203048)
1. 搜索`extensions.zotero.note.css`首选项，点击编辑
![20260604_203850](https://pub-5ab96ca635214cd7a827a11ffc31194a.r2.dev/BlogImg/20260604_203850)
## `extensions.zotero.note.css`首选项设定值

- 编辑`extensions.zotero.note.css`首选项，粘贴以下`css`内容并保存即可

```css linenums="1" title="extensions.zotero.note.css"
[contentViewMode="comfortable"] .primary-editor {
    width: auto !important;
    max-width: none !important;
    min-width: auto !important;
    align-self: stretch !important;
}
[contentViewMode="comfortable"] .drag-handle {
    --drag-handle-max-width-inline-offset: 0px !important;
}
```

![20260604_203456_screenshots](https://pub-5ab96ca635214cd7a827a11ffc31194a.r2.dev/BlogImg/20260604_203456_screenshots)

[See Also (**Github** Gist) :lucide-external-link:](https://gist.github.com/ramonmi/cd02874bdd7aade1522068ba8178cf11){ .md-button }