# 自定义css设置Zotero笔记标签页内容占满幅宽
## 隐藏首选项编辑器打开方式
1. 打开设置Open Settings
![20260604_203024](https://gist.github.com/user-attachments/assets/02c8397c-37f2-4fcf-b551-6e96f80cb606)
1. 点击**高级**Advanced，点击页面最下方**设置编辑器**Config Editor
![20260604_203048](https://gist.github.com/user-attachments/assets/84d88e1a-7ebe-40d1-a53a-7901dd9247ad)
1. 搜索`extensions.zotero.note.css`首选项，点击编辑
![20260604_203850](https://gist.github.com/user-attachments/assets/abf865ef-d2d9-40f7-af3c-cc0baf9e242a)
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

![20260604_203456_screenshots](https://gist.github.com/user-attachments/assets/9847787a-1cdf-4bea-9cbb-f0d7af5fe7b9)

