# Charles

SSL代理，否则报文内容为unknown+乱码

https://blog.csdn.net/xiaojing0511/article/details/99336783

设置证书

https://www.jianshu.com/p/7d3557abcf53

安卓7.0之后默认不再信任用户CA证书：

https://blog.csdn.net/ShadowySpirits/article/details/79756274

开启Charles后，clash代理失效，重设“System proxy”即可恢复clash，但Charles又会失效，在Charles内`ctrl+shift+p` x 2（重设Windows proxy）恢复

## 微信小程序

token放在本地存储，重新进入小程序不会刷新（重新请求），可以彻底删除小程序相关存储，下次进入小程序时就会刷新。

[小程序pc端怎么删除？ | 微信开放社区 (qq.com)](https://developers.weixin.qq.com/community/develop/doc/000a6666960b70173050aa4cd6c000)

后来发现，在手机上登录一次小程序，就会刷新token，导致电脑上的旧token无效，在电脑上再次登录就会获得新的token