### Useful Commands in server

`w` : Show who is logged on and what they are doing.

### 远程文件同步

`scp` : Secure copy. Copy files between hosts using Secure Copy Protocol over SSH.

`rsync` : Remote (and local) file-copying tool

区别：https://stackoverflow.com/questions/20244585/how-does-scp-differ-from-rsync

总结： `rsync` 更好

最佳实践：TODO

 [vscode 的 sshfs 教程](https://code.visualstudio.com/docs/remote/troubleshooting#_using-sshfs-to-access-files-on-your-remote-host) ：best used for single file edits and uploading/downloading content. If you need to use an application that bulk reads/write to many files at once (like a local source control tool), [rsync](https://code.visualstudio.com/docs/remote/troubleshooting#_using-rsync-to-maintain-a-local-copy-of-your-source-code) is a better choice.

 [vscode 的 rsync 教程](https://code.visualstudio.com/docs/remote/troubleshooting#_using-rsync-to-maintain-a-local-copy-of-your-source-code) ：if you really need to use multi-file or performance intensive local tools.

sshfs -o uid=$UID gpu2:~/data/data_from_63 data_from_63 -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3

https://github.com/libfuse/sshfs

### 查看命令的网络访问

```
strace -fT -s 100 -e trace=network <your command> |& grep "CONNECT"
```

https://unix.stackexchange.com/questions/375387/how-to-trace-networking-activity-of-a-command

- `-s 100` ：最大 string 长度设为 100，默认 32。避免函数参数（特别是长 URL）显示不完整。
- `-e trace=network` ：只监控 socket 系统调用。
- `|&` ：同 `2>&1 |` ，strace 的输出默认在 stderr，重定向到 stdout，为了 grep。fish 里是 `&|`
- `grep "CONNECT"` ：这里只关心访问了哪个 URL，筛选出这个系统调用即可。

### Terminal

`stty -a` : show terminal interface

例如 `intr = ^C;`

https://unix.stackexchange.com/questions/362559/list-of-terminal-generated-signals-eg-ctrl-c-sigint

### Profiling

`prof`(CPU)`nvprof` (GPU)

python: `viztracer`

### CRLF-LF

将当前文件夹下的所有文件从 CRLF 转为 LF

```bash
find . -type f -exec dos2unix {} \;
```

https://stackoverflow.com/questions/7068179/convert-line-endings-for-whole-directory-tree-git

### nohup

可能不太好？输出没了：
https://stackoverflow.com/questions/625409/how-do-i-put-an-already-running-process-under-nohup

这个也不太行
https://github.com/nelhage/reptyr

### zsh

vim mode：
- omz 的 [vi 插件](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vi-mode) 不够好。目前（23/03/01）不支持 `ci"` 这样的操作，且模式prompt有点问题（不知道是不是bug）
- 正在用： https://github.com/jeffreytse/zsh-vi-mode

### tmux

https://github.com/gpakosz/.tmux

坑：需要自己调整一下 local 里的 `tmux_conf_theme_left_separator_XXX`，不然不显示 Powerline 字符。。（见 [Status line separators on windows? · Issue #419 · gpakosz/.tmux (github.com)](https://github.com/gpakosz/.tmux#troubleshooting) ）

- PREFIX w: window preview

Ctrl+a 不好按，于是把 Capslock 换成了 Ctrl（Windows 上用 [PowerToys](https://github.com/microsoft/PowerToys) 换）
