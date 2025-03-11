# Git Notes

### submodule

git submodule 把它的 `.git` 放在顶层 git 目录的 `.git` 下。 `.gitmodules` 只用于描述子模块如何初始化，完成初始化之后，需要通过 git 提供的命令来管理、移动、删除子模块，不能简单的修改 `.gitmodules` 或在文件系统中修改目录，否则 git 对子模块的管理会出问题。

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

修改 URL

```bash
git config submodule.my-submodule.url otheruser@server:/pathtorepos
```

https://stackoverflow.com/questions/6031494/git-submodules-and-ssh-access

submodule branch

[How can I specify a branch/tag when adding a Git submodule? - Stack Overflow](https://stackoverflow.com/questions/1777854/how-can-i-specify-a-branch-tag-when-adding-a-git-submodule)

### 文件权限

git 只管理文件的可执行 bit。git 不能管理文件的读写权限。

https://stackoverflow.com/questions/1071241/how-does-git-handle-folder-permission

### remove untracked file

```bash
git clean -f
```

### 传输协议

- `git://github.com` git 协议，无加密
- `ssh://git@github.com` 或 `git@github.com` ssh 协议
- `https://github.com` https 协议

http://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols

### CRLF

https://stackoverflow.com/questions/1967370/git-replacing-lf-with-crlf

如果 windows 平台（上的 IDE 等环境）支持 LF，可以

```bash
git config --local core.autocrlf input
```

于是，windows 上 add 的文件中的所有 CRLF 会转换成 LF，保持与 linux 兼容

### 中文文件名

```bash
git config --global core.quotepath off
```

https://stackoverflow.com/questions/22827239/how-to-make-git-properly-display-utf-8-encoded-pathnames-in-the-console-window

### Signing Commits

GPG 太难用了：[The Handbook to GPG and Git (oliverspryn.com)](https://www.oliverspryn.com/blog/the-handbook-to-gpg-and-git)

git 支持用 ssh 签名 commit：[Git Tips 2: New Stuff in Git (gitbutler.com)](https://blog.gitbutler.com/git-tips-2-new-stuff-in-git/#ssh-commit-signing)

GitHub 上需要重新添加 ssh key，添加时需要将 key type（从 Authentication）改为 Signing

关于下面这个报错，它只是本地无法校验签名，签名仍然存在且生效：[Signing Git Commits with SSH Keys - blog.dbrgn.ch](https://blog.dbrgn.ch/2021/11/16/git-ssh-signatures/)

> error: gpg.ssh.allowedSignersFile needs to be configured and exist for ssh signature verification

### 改 host

> [ineo6/hosts: GitHub 最新 hosts。解决 GitHub 图片无法显示，加速 GitHub 网页浏览。](https://github.com/ineo6/hosts#windows-1)

- Windows: `C:\Windows\System32\drivers\etc\hosts` 属性去掉只读
- Linux: `sudoedit /etc/hosts`

最新地址： https://gitlab.com/ineo6/hosts/-/raw/master/hosts

```text
199.232.69.194   github.global.ssl.fastly.net
140.82.113.3   github.com
185.199.108.153   assets-cdn.github.com
185.199.110.153   documentcloud.github.com
140.82.112.4   gist.github.com
185.199.108.154   help.github.com
140.82.113.9   nodeload.github.com
140.82.114.9   codeload.github.com
185.199.109.133   raw.github.com
140.82.112.18   status.github.com
185.199.108.153   training.github.com
140.82.112.3   www.github.com
185.199.108.154   github.githubassets.com
185.199.111.133   avatars0.githubusercontent.com
185.199.111.133   avatars1.githubusercontent.com
185.199.109.133   avatars2.githubusercontent.com
185.199.109.133   avatars3.githubusercontent.com
```

`ipconfig /flushdns`

## 技巧

[Git Tips and Tricks (gitbutler.com)](https://blog.gitbutler.com/git-tips-and-tricks/)

## Github private fork

[创建公共存储库的私有分支 --- Create a private fork of a public repository (github.com)](https://gist.github.com/0xjac/85097472043b697ab57ba1b1c7530274)

## shallow clone

[Get up to speed with partial clone and shallow clone - The GitHub Blog](https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/)

```bash
gcl --filter=blob:none
```

## blames

查找哪些 tag 包含某个特定 commit（从而找到首个包含该 commit 的 tag）

```bash
git tag --contains <commit_hash>
```
