# SSH

Tutorial：https://www.linode.com/docs/guides/use-public-key-authentication-with-ssh/

### 权限

相关文件的权限

https://superuser.com/a/1559867

### 其他

指定key：在 `~/.ssh/config` 中添加

```
IdentityFile /home/myuser/.ssh/keyhello
```

从哪里ssh过来的：

```
echo $SSH_CONNECTION
```

