解决方法一：

```bash
apt-get -o Acquire::ForceIPv4=true update
```

解决方法二：

```bash
# 禁用ipv6
# 编辑/etc/sysctl.d/99-sysctl.conf文件
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

#保存配置后，执行下面的命令可以加载上面的配置：
sudo sysctl -p

#可以查看/proc/sys/net/ipv6/conf/all/disable_ipv6是否为1，来确定修改的内核配置是否生效：
 cat /proc/sys/net/ipv6/conf/all/disable_ipv6
```



