### Useful Commands in server

`w` : Show who is logged on and what they are doing.

### 远程文件同步

`scp` : Secure copy. Copy files between hosts using Secure Copy Protocol over SSH.

`rsync` : Remote (and local) file-copying tool

区别：https://stackoverflow.com/questions/20244585/how-does-scp-differ-from-rsync

总结： `rsync` 更好

最佳实践：TODO

[vscode的sshfs教程](https://code.visualstudio.com/docs/remote/troubleshooting#_using-sshfs-to-access-files-on-your-remote-host) ：best used for single file edits and uploading/downloading content. If you need to use an application that bulk reads/write to many files at once (like a local source control tool), [rsync](https://code.visualstudio.com/docs/remote/troubleshooting#_using-rsync-to-maintain-a-local-copy-of-your-source-code) is a better choice.

[vscode的rsync教程](https://code.visualstudio.com/docs/remote/troubleshooting#_using-rsync-to-maintain-a-local-copy-of-your-source-code) ：if you really need to use multi-file or performance intensive local tools.

sshfs -o uid=$UID gpu2:~/data/data_from_63 data_from_63 -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3

https://github.com/libfuse/sshfs

### 查看命令的网络访问

```
strace -fT -s 100 -e trace=network <your command> |& grep "CONNECT"
```

https://unix.stackexchange.com/questions/375387/how-to-trace-networking-activity-of-a-command

- `-s 100` ：最大string长度设为100，默认32。避免函数参数（特别是长URL）显示不完整。
- `-e trace=network` ：只监控socket系统调用。
- `|&` ：同 `2>&1 |` ，strace的输出默认在stderr，重定向到stdout，为了grep。fish里是 `&|`
- `grep "CONNECT"` ：这里只关心访问了哪个URL，筛选出这个系统调用即可。

### Terminal

`stty -a` : show terminal interface

例如 `intr = ^C;`

https://unix.stackexchange.com/questions/362559/list-of-terminal-generated-signals-eg-ctrl-c-sigint

### Profiling

`prof` (CPU) `nvprof` (GPU)

`python::viztracer`

### CRLF-LF

将当前文件夹下的所有文件从CRLF转为LF

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
- omz的[vi插件](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vi-mode)不够好。目前（23/03/01）不支持 `ci"` 这样的操作，且模式prompt有点问题（不知道是不是bug）
- 正在用： https://github.com/jeffreytse/zsh-vi-mode