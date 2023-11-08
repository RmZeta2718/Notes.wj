# VSCode Notes

### Useful shortcuts

| Command                     | shortcut              |
| --------------------------- | --------------------- |
| Trigger Suggest             | Ctrl+Space            |
| Trigger Parameter Hints     | Ctrl+Shift+Space      |
| Go Forward/Backward         | [Ctrl+]Alt+Left/Right |
| Rename Symbol               | F2                      |
| Go to Next/Previous Problem | F8/Shift+F8           |

> \[\]内的是我修改的快捷键

其他快捷键参考
- https://github.com/VSCodeVim/Vim#-faq
- https://github.com/VSCodeVim/Vim/issues/754#issuecomment-284302205

## python

A good tutorial: https://realpython.com/advanced-visual-studio-code-python

### refresh language server

有时候更新了环境，但是代码提示没有刷新，这时可以重启 language server 刷新（或者直接 reload 整个 vscode）

- Python: Restart Language Server
- Developer: Reload Window

### python formatting

black + isort

isort 默认的 format 很丑陋，加上 README 里的 `"isort.args": ["--profile", "black"]`  之后就正常了。

试图将 shortcut 修改 `Organize Imports` `Shift+Alt+O` ->`Shift+Alt+F` ，结果覆盖了原有的 formatting

自动保存时不会触发 isort，但是会触发 format。因此依赖自动 format 有时会不一致。

```json
    "[python]": {
        "editor.codeActionsOnSave": {
            "source.organizeImports": true
        },
    }
    "editor.formatOnSave": true,
```

根据 [editor.codeActionsOnSave not triggered from autosave · Issue #123875 · microsoft/vscode (github.com)](https://github.com/microsoft/vscode/issues/123875) ，这是 feature。
## Customize C formatting style

 [reference](https://zamhuang.medium.com/vscode-how-to-customize-c-s-coding-style-in-vscode-ad16d87e93bf)

modify `C_Cpp.clang_format_fallbackStyle` to `{ BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 0}` (and the original value was `Visual Studio` )

## vim

 [🎩 VSCodeVim tricks!](https://github.com/VSCodeVim/Vim#-vscodevim-tricks) ：`gh` = 鼠标悬停，`gd` = `ctrl + click`

vim fold problem (see README)

```json
    "vim.foldfix": true,
```

解决~~（移除）~~ vim 中复制的问题

```json
    "vim.handleKeys": {
        // https://github.com/VSCodeVim/Vim/issues/1437#issuecomment-318524668
        "<C-c>": false
    },
```

~~easymotion 集成 keybinding~~已被 flash 替代

```json
    "vim.easymotion": true,
    // https://github.com/VSCodeVim/Vim/issues/1481#issuecomment-469573631
    "vim.normalModeKeyBindingsNonRecursive": [
        {
            "before": [ "f" ],
            "after": [ "leader", "leader", "s" ]
        },
        {
            "before": [ "F" ],
            "after": [ "leader", "leader", "2", "s" ]
        }
    ],
    "vim.visualModeKeyBindingsNonRecursive": [
        {
            "before": [ "f" ],
            "after": [ "leader", "leader", "s" ]
        },
        {
            "before": [ "F" ],
            "after": [ "leader", "leader", "2", "s" ]
        }
    ],
```

在著名 [学习网站](https://www.bilibili.com/video/BV1ZH4y1S7jb) 发现了 [CVim](https://marketplace.visualstudio.com/items?itemName=cuixiaorui.cvim) ，支持了flash，比easymotion更好用。

```json
    "vim.flash.enable": true,
```

### im-select

 [VSCodeVim/Vim: Vim for Visual Studio Code (github.com)](https://github.com/VSCodeVim/Vim/#input-method)

https://www.zhihu.com/question/303850876

~~目前似乎不支持 remote 上的切换，只有本地有效~~。
远程使用方法： https://github.com/VSCodeVim/Vim/issues/8324#issuecomment-1604903912

## Remote

偶然间读了下 [官方文档](https://code.visualstudio.com/docs/remote/ssh) ，收获不小。

### 插件

local 和 remote 用到的插件是不一样的，一般 UI 类插件在本地、代码类插件在远程

![](https://code.visualstudio.com/assets/api/advanced-topics/remote-extensions/architecture.png)

 [创建新 remote 时自动安装插件](https://code.visualstudio.com/docs/remote/ssh#_always-installed-extensions)

我的配置：

```json
{
    "remote.SSH.defaultExtensions": [
        "chrisdias.vscode-opennewinstance",
        "christian-kohler.path-intellisense",
        "DavidAnson.vscode-markdownlint",
        "DiogoNolasco.pyinit",
        "eamodio.gitlens",
        "formulahendry.code-runner",
        "foxundermoon.shell-format",
        "Gerrnperl.outline-map",
        "GitHub.copilot",
        "jbockle.jbockle-format-files",
        "mads-hartmann.bash-ide-vscode",
        "mechatroner.rainbow-csv",
        "mhutchie.git-graph",
        "ms-azuretools.vscode-docker",
        "ms-python.black-formatter",
        "ms-python.isort",
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-toolsai.jupyter",
        "redhat.vscode-yaml",
        "streetsidesoftware.code-spell-checker",
        "Thinker.sort-json",
        "timonwong.shellcheck",
        "yzhang.markdown-all-in-one"
    ],
}
```

 [根据文档](https://code.visualstudio.com/docs/remote/ssh#_ssh-hostspecific-settings) remote 的设置默认采用 local 设置（而不是default settings）

### Extension bisect

无意间发现的一个有趣的功能：通过二分查找寻找出问题的 extension。可能永远用不到。

## settings

用 Sort JSON 插件来排序。vscode 没有自带 settings.json 的排序

sort level 设置为 2，避免 sort vim keybinding

### Readonly

经常会不小心修改库文件，23/05 版本起终于可以手动指定只读文件了：Readonly Include 设置项添加 `**/.conda/**`

### Theme

使用默认的 Dark+主题。做了一点小修改：
- Python 的 type alias 变量默认是变量颜色，改成了 type 的颜色。
    - 参考： [Binaryify/OneDark-Pro: Atom's iconic One Dark theme for Visual Studio Code (github.com)](https://github.com/Binaryify/OneDark-Pro#python--pylance-users) （琢磨换主题的时候在README里看到了怎么自己改，于是还是用默认主题了）
    - 后来发现，type alias 可以通过 `from torch import Tensor as Tsr` 的方式绕过去（这样 `Tsr` 就是 class 而不是 type alias variable 了）。
- 函数参数从正体改成斜体（仿照 OneDark）（已删除）
    - 但是这会导致函数调用时的 kwarg 也变成斜体（而且不是全部，只有 pyi 的函数不受影响） [Python Semantic Highlighting of Parameters in Function Calls · Issue #1845 · microsoft/pylance-release (github.com)](https://github.com/microsoft/pylance-release/issues/1845)

```json
{
    "editor.semanticTokenColorCustomizations": {
        "[Default Dark+]": {
            "rules": {
                "*.typeHint:python": "#4EC9B0",
                // "parameter:python": {"fontStyle": "italic"},
            }
        }
    },
}
```

### VS Code file watcher is running out of handles

 [Visual Studio Code is unable to watch for file changes in this large workspace](https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc)

对于工作区之外的 exclude，必须使用绝对路径，而不能用 glob： https://github.com/microsoft/vscode/issues/137872#issuecomment-1373195903

因此将 conda 绝对路径添加到 `files.watcherExclude` 即可

> 当前 conda 在符号链接下，但是必须使用 realpath。可能与 [[#符号链接问题]] 有关

如何查看 watch 的文件： https://github.com/microsoft/vscode/issues/160252#issuecomment-1239461057

## Bugs

### 符号链接问题

如果 workspace 的路径中包含符号链接，Search 会打开绝对路径而非符号链接。

work around：打开绝对路径（`realpath`）

- 不打算修复： [Symbolic links to folders can lead to the same file opened in two tabs · Issue #100533 · microsoft/vscode (github.com)](https://github.com/microsoft/vscode/issues/100533)
- [Add option to always open files at their canonical path · Issue #130082 · microsoft/vscode (github.com)](https://github.com/microsoft/vscode/issues/130082)
