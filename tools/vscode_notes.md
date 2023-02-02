# VSCode Notes

### 自动保存

文件--自动保存

### im-select

https://www.zhihu.com/question/303850876

### python

有时候更新了环境，但是代码提示没有刷新，这时可以重启 language server 刷新（或者直接 reload 整个 vscode）

- Python: Restart Language Server
- Developer: Reload Window

### Customize C formatting style

[reference](https://zamhuang.medium.com/vscode-how-to-customize-c-s-coding-style-in-vscode-ad16d87e93bf)

modify `C_Cpp.clang_format_fallbackStyle` to `{ BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 0}` (and the original value was `Visual Studio` )

### Remote

偶然间读了下[官方文档](https://code.visualstudio.com/docs/remote/ssh)，收获不小。

local 和 remote 用到的插件是不一样的，一般 UI 类插件在本地、代码类插件在远程

https://code.visualstudio.com/api/advanced-topics/remote-extensions#architecture-and-extension-types

![](https://code.visualstudio.com/assets/api/advanced-topics/remote-extensions/architecture.png)
