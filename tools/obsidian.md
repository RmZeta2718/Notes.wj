## Cheat Sheet

### checkbox

`ctrl+L` 创建/切换（切换待办事项状态）

- [ ] 1

### reload

命令面板输入 `obsi` 选择 **重新加载 Obsidian（不保存当前编辑内容）**

已在 `命令面板-置顶命令` 中置顶

### 重命名（移动）时自动更新链接

需求：文件或 heading/block 在重命名/移动之后，所有指向原目标的链接也一并重命名。

#### 文件

重命名文件：在 Obsidian 内重命名文件（右击文件列表修改或在编辑区顶部修改），不要直接在操作系统中修改

移动文件到另一个文件夹：文件列表右键移动，不要直接在操作系统中修改

#### heading/block

重命名 heading/block：选中标题后右键修改，不要直接编辑

直接编辑而不是菜单修改的 FR 也在提了：

https://forum.obsidian.md/t/automatic-inline-update-of-links-to-headers-and-blocks-when-they-are-modified-no-extra-dialog-window/25412

移动 heading 到另一个文件：用笔记重组（官方插件， [Note Composer](https://help.obsidian.md/Plugins/Note+composer) ），但是该插件暂不支持链接更新，FR 在提了（22 年 5 月）：https://forum.obsidian.md/t/note-composer-links-to-blocks-and-headers-should-be-updated-when-extracting/37534。就硬等。

### YAML front matter

https://help.obsidian.md/Advanced+topics/YAML+front+matter

### 有序列表标号刷新

Obsidian 并不像 Typora 一样会自动更新有序列表标号。一些 work around：

- 选中列表之后，手动取消列表再创建列表会刷新选中的顶层标号，我设置了类 Typora 的快捷键，所以是 `Ctrl+Shift+[[`（不过深层列表会变成全 1，还需要单独选中再刷新）
- 缩进再取消缩进 `tab && shift+tab` 会刷新缩进行之后的同级标号，但如果在紧接在一个深层的无序列表后面，就会变成 1

目前还没有实现自动刷新：

https://forum.obsidian.md/t/automatically-keep-numbered-list-ordered-in-editor-adding-removing-swapping/28428

## 设置

一些快捷键采用了 Typora 风格

### 自适应行宽

~~https://gist.github.com/vii33/f2c3a85b64023cefa9df6420730c7531~~

~~<u>.obsidian/snippets/page-width.css</u>~~

~~这玩意为什么不是默认的？折磨人？找了半天 :(~~

对不起，`设置-编辑器-缩减栏宽` 关闭

### 代码字体

`外观-代码字体`：Consolas

### 快捷键

Go to tab： `Alt+number` （类似绝大部分其他软件）

## CSS

Obsidian 中可以用 CSS 编写自定义设置

### math.css

编辑器中 math 块显示为正体而非斜体

### headings.css

为 1、2 级标题添加下划线（Typora style）

https://forum.obsidian.md/t/need-help-with-ccs-themes/20784/2

~~为 3456 级标题添加提示（不过我改成了在尾部，降低视觉影响）~~

~~https://forum.obsidian.md/t/display-heading-level-in-margin-of-preview-mode-just-like-in-bear/691/5~~

被 Lapel 插件替代了

## 插件

[精华插件合集 | obsidian 文档咖啡豆版](https://obsidian.vip/zh/community-plugins/Recommended-plugins.html)

### obsidian-plugin-prettier

快捷键改为： `Alt+Shift+F`（vscode style shortcut）

### Advanced Tables

为什么不内置？

### Citations

管理论文引用，论文笔记

my template：

```markdown
---
aliases:
  - "{{title}}"
  - "{{title}}, {{year}}"
---
# {{title}}

- **Journal**: {{containerTitle}}
- **Author**: {{authorString}}
- **Year**: {{year}}
- **URL**: {{URL}}
- [**Zotero**]({{zoteroSelectURI}})

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
```

文件名：`@{{citekey}}` （不用 title，因为有的时候 title 包含非法字符，不能用于文件名，如冒号）

在 front-matter 中添加 alias=title，方便其他地方提到 title 时可以提示链接/方便主动创建链接，如果论文有别名，如 BERT，可以手动添加额外 alias

### Completr

自动补全

### Copy Document as HTML

应该内置。

复制富文本而非源代码

### Dataview

### Editing Toolbar

支持一个 word 一样的工具栏，还顺手支持了下划线、code block 的命令（obsidian 怎么到现在都没有这些东西啊）

heading 等功能不知道是内部自己实现了还是调用了 obsidian 的命令。配置看起来很奇怪。

### Lapel

仿照 Typora 的标题层级注释

### Latex Suite

支持类 Typora 的浮动实时渲染。snippets 我到是不怎么用

### No Dupe Leaves

啥都不支持的 obsidian，用户体验极差。

防止打开重复的 tab

来自一个 [FR](https://forum.obsidian.md/t/ide-style-navigation-tab-reuse-on-link-opening-tab-management/46671/6) ，在 FR 没有完成之前，以插件的形式存在。

### obsidian-proxy-github

浏览和下载第三方插件可能需要打开这个插件。（最近似乎不需要了）

https://zhuanlan.zhihu.com/p/430538023

### Quiet Outline

更好的大纲页，自动展开到当前位置

### ~~Shortcuts extender~~

~~只用到了 `ctrl+1` 这些 headings 快捷键，其他快捷键都关掉了~~

很好，v1.0 已内置

### Tag Wrangler

Rename a tag

### ~~Underline~~

~~残破不堪的 obsidian，为什么这都要插件？为什么不内置？~~

被 Editing Toolbar 代替

### Vimrc Support

为什么不内置？

这个插件的 im-select 经常失效，所以我还是使用 **Vim IM Select** 插件。

不论是这个插件还是 **Vim IM Select** 插件，在切换 tab 的时候都会出问题，所以必须在 normal 模式下切换 tab

windows 上 vim mode 导致 Ctrl+C 无法复制，解决方案：https://forum.obsidian.md/t/how-to-copy-with-vim-mode/3881/27（但是在 insert mode 中仍然不能 Ctrl+C，因为 vim 中这是 Esc，后来发现：加入 `iunmap <C-c>` 即可）

## TODO

暂不支持或找不到解决方案的需求

### 英语命令面板

https://forum.obsidian.md/t/enable-typing-english-command-names/10109

### vim 的 map 在模式改变后失效

想要将 o 映射成 A\<CR\>，从而触发 markdown 的自动补全

https://github.com/codemirror/codemirror5/issues/6911

### heading 自动 link

目前只会提示 title 的 unlinked mention，对 heading 不支持

https://forum.obsidian.md/t/unlinked-mentions-for-headings-and-paragraphs/26612

### 不再显示某些 unlinked mention

https://forum.obsidian.md/t/dismiss-specific-unlinked-mentions/42583

## Reference

[Obsidian 文档咖啡豆版 | Obsidian Docs by CoffeeBean](https://obsidian.vip/)
