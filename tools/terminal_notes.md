### Useful Commands in server

`w` : Show who is logged on and what they are doing.

### 远程文件同步

`scp` : Secure copy. Copy files between hosts using Secure Copy Protocol over SSH.

`rsync` : Remote (and local) file-copying tool

区别：https://stackoverflow.com/questions/20244585/how-does-scp-differ-from-rsync

总结： `rsync` 更好

最佳实践：TODO

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
