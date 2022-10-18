# Git Notes

### submodule

git submodule 把它的 `.git` 放在顶层 git 目录的 `.git` 下。 `.gitmodules` 只用于描述子模块如何初始化，完成初始化之后，需要通过git提供的命令来管理、移动、删除子模块，不能简单的修改 `.gitmodules` 或在文件系统中修改目录，否则 git 对子模块的管理会出问题。

https://git-scm.com/book/en/v2/Git-Tools-Submodules

移动：

```bash
git mv old/submod new/submod   # git 1.9.3 or newer
```

删除：

```bash
git rm submod
```

https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule

修改URL

```bash
git config submodule.my-submodule.url otheruser@server:/pathtorepos
```

https://stackoverflow.com/questions/6031494/git-submodules-and-ssh-access

### 文件权限

git只管理文件的可执行bit。git不能管理文件的读写权限。

https://stackoverflow.com/questions/1071241/how-does-git-handle-folder-permission

### remove untracked file

```bash
git clean -f
```

### 传输协议

- `git://github.com` git协议，无加密
- `ssh://git@github.com` 或 `git@github.com` ssh协议
- `https://github.com` https协议

http://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols

### CRLF

https://stackoverflow.com/questions/1967370/git-replacing-lf-with-crlf

如果windows平台（上的IDE等环境）支持LF，可以

```bash
git config --local core.autocrlf input
```

于是，windows上add的文件中的所有CRLF会转换成LF，保持与linux兼容

### 中文文件名

```bash
git config --global core.quotepath off
```

https://stackoverflow.com/questions/22827239/how-to-make-git-properly-display-utf-8-encoded-pathnames-in-the-console-window