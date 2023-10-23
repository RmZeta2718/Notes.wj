### Useful Commands in server

`w` : Show who is logged on and what they are doing.

### 远程文件同步

`scp` : Secure copy. Copy files between hosts using Secure Copy Protocol over SSH.

`rsync` : Remote (and local) file-copying tool

区别：https://stackoverflow.com/questions/20244585/how-does-scp-differ-from-rsync

总结： `rsync` 更好

最佳实践： [dotfiles_pub/bin/rsync_script at master · RmZeta2718/dotfiles_pub (github.com)](https://github.com/RmZeta2718/dotfiles_pub/blob/master/bin/rsync_script)

 [`rsync -H` preserve hard links](https://unix.stackexchange.com/questions/44247/how-to-copy-directories-with-preserving-hardlinks)
 [`rsync -l`(-a) preserve soft links](https://superuser.com/questions/799354/rsync-and-symbolic-links)

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

### zsh

vim mode：
- omz 的 [vi 插件](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vi-mode) 不够好。目前（23/03/01）不支持 `ci"` 这样的操作，且模式prompt有点问题（不知道是不是bug）
- 正在用： https://github.com/jeffreytse/zsh-vi-mode

主题： [romkatv/powerlevel10k: A Zsh theme (github.com)](https://github.com/romkatv/powerlevel10k)

修改：conda 环境背景色 `POWERLEVEL9K_ANACONDA_BACKGROUND: 4 -> 6` （在我的 Windows Terminal 调色板下，4 看不清）

### tmux

oh-my-tmux: https://github.com/gpakosz/.tmux

坑：需要自己调整一下 local 里的 `tmux_conf_theme_left_separator_XXX`，不然不显示 Powerline 字符。。（见 [Status line separators on windows? · Issue #419 · gpakosz/.tmux (github.com)](https://github.com/gpakosz/.tmux#troubleshooting) ）

- PREFIX w: window preview

~~Ctrl+a 不好按，于是把 Capslock 换成了 Ctrl（Windows 上用 [PowerToys](https://github.com/microsoft/PowerToys) 换）~~ Capslock 换成 Esc 了

~~tmux 版本 2.6（install from src if not available）。试过 tmux3.0a 和 3.3a，窗口名字不会自动改为 cwd，而是显示 zsh。这似乎是符合预期的（`tmux show-window-options -g automatic-rename-format`），不知道怎么改。~~ 在 3.3a 上 `set -g allow-rename on`，可行

> [How to automatically rename tmux windows to the current directory - Stack Overflow](https://stackoverflow.com/questions/28376611/how-to-automatically-rename-tmux-windows-to-the-current-directory/68043814#68043814)

`bind -r` 可以让 PREFIX 连续生效

> [How can I keep the tmux prefix key pressed between commands? - Super User](https://superuser.com/questions/263940/how-can-i-keep-the-tmux-prefix-key-pressed-between-commands)

### vim

没有好用的 ssh+vim 复制方案。替代选项
- 直接在 vscode 里打开
- cat 到终端复制
- （Windows Terminal）按住 shift 拖动选中

> [macos - vim + COPY + mac over SSH - Stack Overflow](https://stackoverflow.com/questions/10694516/vim-copy-mac-over-ssh)

### ssh

Tutorial： https://www.linode.com/docs/guides/use-public-key-authentication-with-ssh/

相关文件的权限： https://superuser.com/a/1559867

debug： `-v`

指定 key：在 `~/.ssh/config` 中添加

```
IdentityFile /home/myuser/.ssh/keyhello
```

从哪里 ssh 过来的：

```
echo $SSH_CONNECTION
```

### shell script

允许编辑正在运行的 shell 脚本（否则修改 script 后，正在运行的 script 会出问题，因为 shell 是一行一行读取文件的，没有一次全部加载进来）

> https://stackoverflow.com/a/2358432

```bash
{
    # ...
    exit
}
```

bash good practice

> https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425

```bash
set -euo pipefail
```

在某个程序完成后，自动开始执行下一个任务。找到正在运行的程序的 pid，通过下面的命令等待其完成，然后在后面添加新的任务。note：等待 bash pid, not python, 因为 bash 可能调用 python 若干次。

> https://stackoverflow.com/a/41613532/17347885

```bash
tail --pid="pid_of_proc" -f /dev/null
```

### nohup

可能不太好？输出没了：
https://stackoverflow.com/questions/625409/how-do-i-put-an-already-running-process-under-nohup

这个也不太行
https://github.com/nelhage/reptyr
