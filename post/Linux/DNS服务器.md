>**This is DNS服务器 StudyNote.**

# DNS资源纪录(Resource Record)

* 资源记录，简称rr，常用的七大记录类型是：`SOA`,`A`,`AAAA`,`PTR`,`MX`,`CNMAE`和`NS`

  * >（1）`SOA`：名叫起始授权机构记录，SOA记录说明了在众多NS记录里那一台才是主要的服务器
    >
    >（2）`A`：记录除了进行域名**IPv4**对应以外，还有一个高级用法，可以作为低成本的负载均衡的解决方案，同一站点可以创建多个A记录，对应多台物理服务器的IP地址，可以实现基本的流量均衡
    >
    >（3）`AAAA`：和`A`记录类似，但采用`IPv6`地址来记录
    >
    >（4）`PTR`：PTR记录也被称为指针记录，PTR记录是A记录的逆向记录，作用是把IP地址解析为域名
    >
    >（5）`MX`：全称是邮件交换记录，在使用邮件服务器的时候，MX记录是无可或缺的。优先级：0-99，数字越小优先级越高
    >
    >（6）`CNMAE`：别名记录
    >
    >（7）`NS`：NS记录和SOA记录是任何一个DNS区域都不可或缺的两条记录，NS记录也叫名称服务器记录，用于说明这个区域有哪些DNS服务器负责解析

* 个别常用rr的配置文件语法

  * >* SOA
    >
    >```
    >ZONE_NAME   IN  SOA     nameserver.example.com.  example.email.com. (
    >20191010            ; serial number 区域数据库的序列号，更新时使用
    >3600 <2H>        ; refresh   [1h] 表示slave dns服务器找master dns服务器更新区域数据文件的时间间隔
    >600 <10M>         ; retry   [10m] 表示slave dns服务器找master dns服务器更新区域数据文件时，如果联系不上master，则等待多久再重试联系，该值一般比refresh时间短，否则该值表示的重试就失去了意义
    >86400 <1W>        ; expire  [1d] 表示slave dns服务器上的区域数据文件多久过期
    >3600 <1D>  )       ; min TTL   [1h] 表示客户端找dns服务器解析时，否定答案的缓存时间长度
    >```
    >
    >* NS
    >
    >```shell
    >example.com. TTL IN NS ns.example.com.
    >```
    >
    >* PTR
    >
    >```shell
    >4.3.2.1.in-addr.arpa.  IN PTR example.com.
    >```
    >
    >* CNAME
    >
    >```shell
    >web.example.com. IN CNAME www.example.com.
    >```
    >
    >* MX
    >
    >```shell
    >example.com.	IN 	MX	10	mx1.example.com.
    >```
    >
    >---
    >
    >注意：
    >
    >（1）TTL可以从全局配置继承
    >
    >（2）@表示当前区域名称
    >
    >（3）相邻的两条记录其ZONE_NAME相同时，可以省略
    >
    >（4）对于正向解析区域来说，各个MX或者NS等类型记录的值应该为`FQDN`，并且此FQDN应该有一个A记录

#  BIND(Berkeley Internet Name Domain)

* BIND所含程序包

  * >bind-libs：被bind程序和bind-utils包所用到库文件
    >
    >bind-utils：bind客户端程序集，例如`dig`，`host`和`nslookup`等
    >
    >>扩展：`dig`，`host`，`nslookup`的简单使用
    >>
    >>​			`dig`：专用于测试dns系统，因此不会去查询本地hosts文件
    >>
    >>​						格式及选项：`dig [-t PR_TYPE] domain_name [@server] [options]`，`-X`反向解析测试
    >>
    >>​										`+[no]trace`:跟踪解析过程
    >>
    >>​										`+[no]recurse`:进行递归解析
    >>
    >>```bash
    >>dig -X 1.1.1.1			# 反向解析IP
    >>    dig -t afxr www.baidu.com @127.0.0.1
    >>```
    >>
    >>​			`host`：格式`host [-t PR_TYPE] name SERVER_IP`
    >>
    >>​			`nslookup`：用于查询DNS的记录，查询域名解析是否正常
    >>
    >>​						格式及选项：`nslookup domain [dns-server] `
    >>
    >>```bash
    >># 交互式模式的简单使用
    >>server IP			# 以指定IP为DNS服务器进行查询
    >>set q=PR_TYPE		# 要查询的资源类型记录
    >>name			# 要查询的名称
    >>```
    >>
    >>---
    >>
    >>bind内置的`rndc`(named服务控制)命令：
    >>
    >>​						`rndc status`
    >>
    >>​						`rndc flush`			
    >
    >bind：提供dns服务程序
    >
    >bind-chroot：将bind运行于jail环境之下

* **安装bind**

  * ```bash
    # CentOS7环境下安装
    yum install bind
    ```

  * 官网地址：https://www.isc.org/bind/
  
* 主配置文件：`/etc/named.conf`，bind的解析库文件为`/var/named`目录下后缀名为`.zone`

* `rndc`(remote name domain contoller)：默认监听端口953/tcp，默认只允许本地使用

* **启动bind**：使用`systemctl start named.service`即可

* 配置解析一个正向区域

  * >（1）定义区域
    >
    >​			在主配置文件或者辅助配置文件中设置
    >
    >```shell
    >zone "ZONE_NAME" IN{
    >	type {master|slave|hint|forward}
    >	file "ZONENAME_FILE.zone"
    >}
    >```
    >
    >（2）建立区域数据文件
    >
    >​			在`/var/named`目录下建立相应的区域数据文件，文件名称为`/var/named/ictw.top.zone`
    >
    >```shell
    >$TTL 3600
    >$ORIGIN ictw.top.
    >@	IN	SOA	ns1.ictw.top.	ictw.qq.com. (
    >		20191023
    >		1H
    >		10M
    >		3D
    >		1D )
    >	IN	NS	ns1
    >	IN	MX	10 mx1
    >ns1	IN	A	172.16.122.128
    >mx1	IN	A	172.16.122.129
    >www	IN	A	172.16.122.128
    >web	IN	A	172.16.122.128
    >```
    >
    >（3）权限修改以及语法错误检测
    >
    >```bash
    ># 修改区域数据文件权限
    >chgrp named /var/named/ictw.zone
    >chmod o= /var/named/ictw.zone
    ># 或者复制named.localhost的属性，然后再进行修改
    >cp -a named.localhost ictw.zone
    >
    ># 语法错误检测
    >named-checkzone ZONE_NAME ZONE_FILE			
    >```
    >
    >（4）让dns服务器重读配置文件和区域数据库文件
    >
    >```bash
    >rndc reload
    ># 或者
    >systemctl reload named.service
    >
    ># 查看bind状态
    >rndc status
    >```
    >
    >（5）使用`dig -t axfr ictw.top @127.0.0.1`或者`host -t axfr ictw.top 127.0.0.1`检查是否成功运作

* 配置反向解析区域

  * >（1）编辑`/etc/named.rfc1912.zones`文件添加反向解析区域
    >
    >```shell
    >zone "122.16.172.in-addr.arpa" IN {
    >   type master;
    >   file "122.16.172.zone";
    >};
    >```
    >
    >（2）建立区域数据库文件，文件为`/var/named/122.16.172.zone`
    >
    >```shell
    >$TTL 3600
    >$ORIGIN 122.16.172.in-addr.arpa.
    >@	IN	SOA	ns1.ictw.top.	ictw.qq.com. (
    >		20191023
    >		1H
    >		10M
    >		3D
    >		1D )
    >	IN	NS	ns1.ictw.top.
    >130	IN	PTR	blog.ictw.top.
    >141	IN	PTR	test.ictw.top.
    >```
    >
    >（3）检查配置文件并重读
    >
    >```bash
    >named-checkconf
    >named-chekzone ZONE_NAME FILE_NAME
    >
    >rndc reload
    >```
    >
    >（4）测试
    >
    >```bash
    >dig -x 172.16.122.130 @127.0.0.1
    >```

## **BIND的高级应用**

* **主从DNS**

  * >**在从DNS服务器上**
    >
    >（1）配置一个正向从区域，放置于`/etc/named.rfc1912.zones `
    >
    >```shell
    >zone "ZONE_NAME" IN {
    >	type slave;
    >	file "slaves/ZONE_NAME.zone";
    >	masters { MASTER_IP; };
    >};
    >```
    >
    >（2）配置文件语法检查`named-checkconf`
    >
    >（3）重载配置`rndc reload`
    >
    >**在主DNS服务器上**
    >
    >（1）编辑`/etc/named/ictw.top.zone`文件，添加一个`NS`记录，并指定其IP地址
    >
    >```shell
    >...
    >	IN      NS      ns2
    >ns2     IN      A       172.16.122.132
    >...
    >```
    >
    >（2）修改serial号后，重载配置`rndc reload`即可
    >
    >---
    >
    >反向解析也是如此.

* **子域授权**

  * >**在主服务器上**
    >
    >（1）编辑配置文件，添加一个子域，例如
    >
    >```shell
    >...
    >child.ictw.top.	IN	NS	ns2.ictw.top.
    >ns2.ictw.top.	IN	A	172.16.122.132
    >...
    >```
    >
    >在子域服务器上
    >
    >（1）编辑配置文件，添加解析域
    >
    >```shell
    >zone "child.ictw.top" IN {
    >        type master;
    >        file "child.ictw.top.zone";
    >};
    >```
    >
    >（2）编辑域文件`child.ictw.top.zone`
    >
    >```shell
    >$TTL 3600
    >$ORIGIN child.ictw.top.
    >@       IN      SOA     ns1.ictw.top.   ictw.qq.com. (
    >                20191023
    >                1H
    >                10M
    >                3D
    >                1D )
    >        IN      NS      ns1
    >ns1     IN      A       172.16.122.132
    >www     IN      A       172.16.122.123
    >```
    >
    >（3）`rndc reload`，分别在主服务器和子域服务区进行测试
    >
    >```bash
    >dig -t A www.child.ictw.top @127.0.0.1
    >```

  * 定义转发

    * >（1）区域转发：仅转发对某特定区域的解析请求
      >
      >```shell
      >zone "ZONE_NAME" IN {
      >	type forward;
      >	forward {first | only};
      >	forwarders { SERVER_IP; };
      >};
      >```
      >
      >>`first` 和 `only` 转发方式的区别：
      >>
      >>​			前者为首先转发，转发器不响应时，自行会去迭代查询
      >>
      >>​			后者只转发，不会去迭代查询
      >
      >（2）全局转发：将自己无法解析的zone，统统转发给指定dns服务器来解析
      >
      >```shell
      ># 修改指定dns服务器的/etc/named.conf文件，添加以下参数
      >forward only;
      >forwarders { 172.16.122.128; };
      >```

* **bind中的基础安全配置**

  >（1）acl访问控制（写在options选项之前）：
  >
  >```shell
  >acl acl_name {
  >	ip;
  >	net/netmask;
  >};
  >opinions{
  >...
  >}
  >```
  >
  >acl的四个内置参数：
  >
  >​		`none `，`any`，`local`，`localnet`（本机所在网络）
  >
  >（2）访问控制（置于区域数据中）
  >
  >`allow-query {   };`：允许查询的主机，白名单模式
  >
  >`allow-transfer {    };`：允许向那些主机区域进行传送，默认为所有主机，一般配置于从服务器
  >
  >`allow-recursion{   };`(opinions中使用)：允许哪些主机向当前dns服务器发起递归查询请求
  >
  >`allow-update{    };`：用于DDNS，一般禁用该选项，赋予`none`值

* **智能DNS**（BIND View）：内外网分流

  * >格式：
    >
    >```shell
    >view VIEW_NAME {
    >	zone_name{
    >	...
    >	};
    >};
    >```
    >
    >例子：
    >
    >```shell
    ># 内网
    >view Internal {
    >	match-clients { 172.16.122.0/8; };		# 所匹配到的网络
    >	zone "ictw.top" IN {
    >		type master;
    >		file "ictw.top/internal";
    >	};
    >}
    >
    ># 外网
    >view external {
    >	match-clients { any;};
    >	zone "ictw.top" IN {
    >		type master;
    >		file "ictw.top/external";
    >	};
    >}
    >```

#  其他

---

1. 解决一堆`SERVFAIL unexpected RCODE resolving './NS/IN': 199.9.14.201#53`的问题

   >编辑bind的主配置文件`/etc/named.conf`，将`logging`参数修改为
   >
   >```shell
   >logging {
   >        category lame-servers { null; };
   >};
   >```
   >
   >重启named即可

2. `whois`命令的简单使用`whois Domian_name`