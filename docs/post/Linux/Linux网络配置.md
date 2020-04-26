> **This is Linux网络配置 StudyNote**.

# IP、netmask、gateway、DNSserver配置方式

##  1）静态指定

* > ifcfg 系列：
  >
  > ​						`ifconfig`：用来配置IP、NETMASK
  >
  > ​						`route`：配置路由
  >
  > ​						`netstat`：网络状态以及统计数据查看
  >
  > iproute 系列：
  >
  > ​						ip OBJECT：
  >
  > ​									`addr`：网络地址和子网掩码
  >
  > ​									`link`：网络接口
  >
  > ​									`route`：路由
  >
  > ​						`ss`：网络状态以及统计数据查看
  >
  > 对于CentOS7：nm（Network Manager）系列：
  >
  > ​						`nmtui`：文本窗口工具
  >
  > ​				   	`nmcli`：命令行工具
  >
  > ​						**注意：**	DNS服务指定文件`/etc/resolv.conf`，本地主机名配置文件`/etc/sysconfig/network`	
  >

## 2）动态分配

DHCP服务器

# ABC类网络私网地址

私有网络ip范围：

| 类别 | IP范围           | 网络数量 |
| ---- | ---------------- | -------- |
| A    | 10.x.x.x/8       | 1        |
| B    | 172.16-32.x.x/16 | 16       |
| C    | 192.168.x.x/24   | 255      |