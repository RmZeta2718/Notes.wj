## Cheat Sheet

### checkbox

`ctrl+L` 创建/切换

- [ ] 1

### reload

命令面板输入 `obsi` 选择 **重新加载Obsidian（不保存当前编辑内容）**

已在`命令面板-置顶命令`中置顶

### 重命名（移动）时自动更新链接

需求：文件或heading/block在重命名/移动之后，所有指向原目标的链接也一并重命名。

#### 文件

重命名文件：在Obsidian内重命名文件（右击文件列表修改或在编辑区顶部修改），不要直接在操作系统中修改

移动文件到另一个文件夹：文件列表右键移动，不要直接在操作系统中修改

#### heading/block

重命名heading/block：选中标题后右键修改，不要直接编辑

直接编辑而不是菜单修改的FR也在提了：

https://forum.obsidian.md/t/automatic-inline-update-of-links-to-headers-and-blocks-when-they-are-modified-no-extra-dialog-window/25412

移动heading到另一个文件：用笔记重组（官方插件，[Note Composer](https://help.obsidian.md/Plugins/Note+composer)），但是该插件暂不支持链接更新，FR在提了（22年5月）：https://forum.obsidian.md/t/note-composer-links-to-blocks-and-headers-should-be-updated-when-extracting/37534。就硬等。

### YAML front matter

https://help.obsidian.md/Advanced+topics/YAML+front+matter

### 有序列表标号刷新

Obsidian并不像Typora一样会自动更新有序列表标号。一些work around：

- 选中列表之后，手动取消列表再创建列表会刷新选中的顶层标号，我设置了类Typora的快捷键，所以是 `Ctrl+Shift+[[`（不过深层列表会变成全1，还需要单独选中再刷新）
- 缩进再取消缩进 `tab && shift+tab` 会刷新缩进行之后的同级标号，但如果在紧接在一个深层的无序列表后面，就会变成1

目前还没有实现自动刷新：

https://forum.obsidian.md/t/automatically-keep-numbered-list-ordered-in-editor-adding-removing-swapping/28428

## 设置

一些快捷键采用了Typora风格

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

Obsidian中可以用CSS编写自定义设置

### math.css

编辑器中math块显示为正体而非斜体

### headings.css

为1、2级标题添加下划线（Typora style）

https://forum.obsidian.md/t/need-help-with-ccs-themes/20784/2

~~为3456级标题添加提示（不过我改成了在尾部，降低视觉影响）~~

~~https://forum.obsidian.md/t/display-heading-level-in-margin-of-preview-mode-just-like-in-bear/691/5~~

被Lapel插件替代了

## 插件

### Advanced Tables

为什么不内置？

### Citations

管理论文引用，论文笔记

TODO：my template

文件名：`@{{citekey}}` （不用title，因为有的时候title包含非法字符，不能用于文件名，如冒号）

在front-matter中添加alias=title，方便其他地方提到title时可以提示链接/方便主动创建链接

### obsidian-proxy-github

https://zhuanlan.zhihu.com/p/430538023

### ~~Shortcuts extender~~

~~只用到了 `ctrl+1` 这些headings快捷键，其他快捷键都关掉了~~

很好，v1.0 已内置

### Vimrc Support

为什么不内置？

不论是这个插件还是 **Vim IM Select** 插件，在切换tab的时候都会出问题，所以必须在normal模式下切换tab

windows上vim mode导致Ctrl+C无法复制，解决方案：https://forum.obsidian.md/t/how-to-copy-with-vim-mode/3881/27（但是在insert mode中仍然不能Ctrl+C，因为vim中这是Esc，后来发现：加入 `iunmap <C-c>` 即可）



## TODO

暂不支持或找不到解决方案的需求

### 英语命令面板

https://forum.obsidian.md/t/enable-typing-english-command-names/10109

### vim的map在模式改变后失效

想要将o映射成A\<CR\>，从而触发markdown的自动补全

https://github.com/codemirror/codemirror5/issues/6911

### heading自动link

目前只会提示title的unlinked mention，对heading不支持

https://forum.obsidian.md/t/unlinked-mentions-for-headings-and-paragraphs/26612

### 不再显示某些unlinked mention

https://forum.obsidian.md/t/dismiss-specific-unlinked-mentions/42583
