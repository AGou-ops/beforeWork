# iptables配置

## 防火墙相关知识

从逻辑上讲，防火墙可以大体分为主机防火墙和网络防火墙：

* 主机防火墙：针对于单个主机进行防护（针对个人）

* 网络防火墙：往往处于网络入口或边缘，针对于网络入口进行防护，服务于防火墙背后的本地局域网（针对于集体）

从物理上讲，防火墙可以分为硬件防火墙和软件防火墙：

* 硬件防火墙：在硬件级别实现部分防火墙功能，另一部分功能基于软件实现，性能高，成本高

* 软件防火墙：应用软件处理逻辑运行于通用硬件平台之上的防火墙，性能低，成本低

## iptables基础

Linux上的iptables实为一个命令行工具，位于用户空间之中，内核空间的`netfilter`安全框架才是真正的防火墙.

iptables并非守护进程，所以并不能算是真正意义上的服务，而应该算是内核提供的功能.

### iptables匹配流程

![来源于网络](https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576642766058&di=8aeb24425e8ea862adb659f1d2a90832&imgtype=0&src=http%3A%2F%2Fimg1.51cto.com%2Fattachment%2F201311%2F183446342.png)

### iptables的四表五链

四表

* Filter表：过滤数据包，防火墙；内核模块：iptables_filter
* NAT表：用于网络地址转换(IP、端口)；内核模块：iptable_nat
* Mangle表：拆解修改重新封装数据包的服务类型、TTL、并且可以配置路由实现QOS；内核模块：iptable_mangle
* Raw表：关闭nat表上的状态跟踪机制；内核模块：iptable_raw

五链（内置链）

* INPUT链：进来的数据包应用此规则链中的规则
* OUTPUT链：外出的数据包应用此规则链中的规则
* FORWARD链：转发数据包时应用此规则链中的规则
* PREROUTING链：对数据包作路由选择前应用此链中的规则
* POSTROUTING链：对数据包作路由选择后应用此链中的规则

:warning:**特别注意：**如果想要Linux主机支持转发功能，则需要开启内核的`IP_FORWARD`功能，临时修改`/proc/sys/net/ipv4/ip_forward`的值为1（默认为0关闭状态），永久修改则需将其添加到`/etc/sysctl.conf`文件当中去（通过该文件修改的内核参数不会立即生效,修改完成后，使用`sysctl -p`命令可以使这些设置立即生效.）。

自定义链：用于内置链的扩展和补充，可实现更灵活的规则管理机制.



由[iptables匹配流程](#iptables匹配流程)图可以得出四表可以被那些链使用(通过"表"作为操作入口，对规则进行定义)：

* raw：PREROUTING，OUTPUT

* mangle：PREROUTING，INPUT，FORWARD，OUTPUT，POSTROUTING

* nat ：PREROUTING，OUTPUT，POSTROUTING（centos7中还有INPUT，而centos6中没有）

* filter：INPUT，FORWARD，OUTPUT

`OUTPUT`存在与所有表中

### 表优先级

iptables为我们定义了4张"表"，当他们处于同一条"链"时，执行的优先级如下：

优先级次序（由高而低）：`raw --> mangle --> nat --> filter`

### iptables规则

#### 匹配条件

匹配条件分为基本匹配条件和扩展匹配条件

基本匹配条件：源地址Source IP，目标地址 Destination IP

扩展匹配条件：使用的是扩展模块处理，可以使用`rpm -ql iptables | grep *.so$ | less`查看支持的模块

#### 常用target

* **ACCEPT**：允许数据包通过
* **DROP**：直接丢弃数据包，不给任何回应信息，这时候客户端会感觉自己的请求泥牛入海了，过了超时时间才会有反应
* **REJECT**：拒绝数据包通过，必要时会给数据发送端一个响应的信息，客户端刚请求就会收到拒绝的信息
* **SNAT**：源地址转换，解决内网用户用同一个公网地址上网的问题

* **MASQUERADE**：是SNAT的一种特殊形式，适用于动态的、临时会变的ip上

* **DNAT**：目标地址转换

* **REDIRECT**：在本机做端口映射

* **LOG**：在`/var/log/messages`文件中记录日志信息，然后将数据包传递给下一条规则，也就是说除了记录以外不对数据包做任何其他操作，仍然让下一条规则去匹配

`ACCEPT`和`DROP`属于基本处理动作，其他的都属于扩展处理动作.

## iptables规则查询

1. 查询所有规则（默认为filter表）

```bash
iptables -vnL --line-number			# 参数-v表示显示详细信息，-n表示取消域名反解，-L等同于--list表示列出规则， --line-number表示显示规则行号，便于增删改查
Chain INPUT (policy ACCEPT 220 packets, 21736 bytes)		# 以INPUT链为例
 pkts bytes target     prot opt in     out     source               destination         
```

`Chain INPUT (policy ACCEPT 220 packets, 21736 bytes)`括号中`policy`，`packets`和`bytes`的含义：

* `policy`：表示默认策略，`ACCEPT`表示默认接受通过INPUT关卡的所有请求，即“黑名单机制”
* `packets`：表示当前链默认策略匹配到的包的数量
* `bytes`：表示当前链默认策略匹配到的所有包的大小总和

当`packets`和`bytes`达到一定大小时，会显示粗略的大小，如果想要详细显示，则需在查询时增加`-x`选项.



详细信息中各个字段的含义：

* pkts：对应规则匹配到的报文的个数

* bytes：对应匹配到的报文包的大小总和

* target：规则对应的target，往往表示规则对应的"动作"，即规则匹配成功后需要采取的措施
* prot：表示规则对应的协议，是否只针对某些协议应用此规则
* opt：表示规则对应的选项
* in：表示数据包由哪个接口(网卡)流入，我们可以设置通过哪块网卡流入的报文需要匹配当前规则
* out：表示数据包由哪个接口(网卡)流出，我们可以设置通过哪块网卡流出的报文需要匹配当前规则
* source：表示规则对应的源头地址，可以是一个IP，也可以是一个网段
* destination：表示规则对应的目标地址可以是一个IP，也可以是一个网段

2. 查询某个表中的规则或者某个表的某个链

```bash
# 查询nat表所有规则
iptables -t nat -L			# -t表示表类型
# 查询nat表的INPUT链
iptables -t nat -L INPUT
```

## iptables规则管理

### 链管理相关

#### 自定义链

增加自定义链

```bash
iptables -N diy_chain
```

删除自定义链（要求自定义链必须是空的，而且没有被引用【引用计数为0】）

```bash
iptables -X diy_chain
```

重命名自定义链

```bash
iptables -E diy_chain new_chain
```

#### 修改默认策略

对于filter而言，其默认策略有：`ACCEPT`、`DROP`和`REJECT`

```bash
# 将FORWARD链的默认策略改为DROP
iptables -P FORWARD DROP
```

特别地，不要将空的filter表的INPUT链设为DROP，否则当前远程连接会被断开.

### 规则管理相关

#### 增加规则

==基本匹配条件==

来自172.16.122.0/24主机的tcp连接到本地主机都接受

```bash
iptables -A INPUT -s 172.16.122.0/24 -d 172.16.122.135 -p tcp  -j ACCEPT
```

以上的`-s`、`-d`、`-p`都为基本条件的参数，此外还有`-o`（数据报文流出的接口，只能应用于数据报文的流出环节，且只能适用于`FORWARD`、`OUTPUT`和`POSTROUTING`链）和`-i`（数据报文流入的接口，只能应用于数据报文的流入环节，且只能适用于`PREROUTING`、`INPIUT`和`FORWARD`链）

==扩展匹配条件==

* 隐式扩展

![隐式扩展](https://s2.ax1x.com/2019/12/18/Q7sidS.png)

[隐式扩展简单使用-1](#iptables实例)

* 显式扩展（需要使用`-m`选项）

帮助文档：`man iptables-extensions`

![1-2](https://s2.ax1x.com/2019/12/18/Q7R2Os.png)

![3-4](https://s2.ax1x.com/2019/12/18/Q7RWmn.png)

1. `multiport`简单使用

```bash
# 开放22/80/445端口的tcp出入连接
iptables -R INPUT 1 -d 172.16.122.135  -p tcp -m multiport --dports 22,80,445 -j ACCEPT
iptables -R OUTPUT 1  -s 172.16.122.135  -p tcp -m multiport --sports 22,80,445 -j ACCEPT
```

2. `iprange`简单使用

```bash
# 允许172.16.122.130-172.16.122.140地址范围内的所有主机访问可以使用本地tcp连接80端口
iptables -I INPUT 2 -d 172.16.122.135 -p tcp --dport 80 -m iprange --src-range 172.16.122.130-172.16.122.140 -j ACCEPT
iptables -I OUTPUT 2 -s 172.16.122.135 -p tcp --sport 80 -m iprange --dst-range 172.16.122.130-172.16.122.140 -j ACCEPT
```

3. `time`简单使用

```bash
# 允许外部主机访问本地的80端口，但只能在指定时间段进行访问（周一至周五早八点到晚八点）
iptables -I INPUT 2 -d 172.16.122.135 -p tcp --dport 80 -m time --timestart 8:00:00 -timestop 20:00:00 --weekdays 1,2,3,4,5 --kerneltz  -j ACCEPT
iptables -I OUPUT 2 -d 172.16.122.135 -p tcp --sport 80 -m time --timestart 8:00:00 -timestop 20:00:00 --weekdays 1,2,3,4,5 --kerneltz  -j ACCEPT
# kerneltz选项在CentOS 6上无需添加使用，因为CentOS 6 默认会使用内核配置的时区
*除weekdays之外还可以指定一个月中的那几天monthdays --monthdays与 --weekdays可以使用"!"取反，其他选项不能取反
```

4. `string`简单使用

```bash
# 屏蔽网页内容中的fuck敏感词汇
* 网页内容：
hello everyone, my name is fuck.(just kidding~)
iptables -I OUTPUT -m string --algo bm --string "fuck" -j DROP
*  --algo：用于指定匹配算法，可选的算法有bm与kmp，此选项为必须选项，我们不用纠结于选择哪个算法，但是我们必须指定一个，--string：用于指定需要匹配的字符串
```

注意：只能对明文编码的字符串进行使用

5. `connlimit`简单实用

```bash
# 限制mysql并发连接数量
# 限制单个IP的连接数，连接数大于三个则拒绝访问
iptables -A INPUT 2 -d 172.16.122.135 -s 172.16.122.0/24 -p tcp --dport 3306 -m connlimit --connlimit-upto 2 -j ACCEPT
```

6. `limit`简单使用

```bash
# 限制ping请求包的速率，每3秒钟响应一次，并且其阈值为5，简单来说就是前4个icmp包响应正常，到第5个包开始就要每3秒钟响应一次
iptables -A INPUT -d 172.16.122.135 -p icmp --icmp-type 8 -m limit --limit-burst 5 --limit 20/minute -j ACCEPT
iptable -A OUTPUT -s 172.16.122.135 -p icmp --icmp-type 0 -j ACCEPT
```

7. **`state`简单使用**

```bash
# 放行指定端口并且指定包类型为NEW的包可以通过
iptables -A INPUT -d 172.16.122.136 -p tcp -m multiport --sports 22,3306,443,80 -m state --state NEW -j ACCEPT
iptables -I INPUT -d 172.16.122.136 -m state --state ESTABLISHED -j ACCEPT
iptables -I OUTPUT -s 172.16.122.136 -m state --state ESTABLISHED -j ACCEPT
# 自定义默认规则设为DROP
iptables -A INPUT -d 172.16.122.136 -j  REJECT
iptables -A OUTPUT -s 172.16.122.136 -j  REJECT
```

### target处理动作

[target处理动作](#常用target)

自定义处理动作链：

```bash
# 简单使用
# 创建自定义链
iptables -N diy_rules
iptables -A diy_rules -d 172.16.122.136 -p icmp --icmp-type 8 -j ACCEPT
iptables -I diy_rules -d 172.16.122.136 -s 172.16.122.137 -p icmp -j DROP
# 使用自定义链
iptables - A INPUT -d 172.16.122.136 -p icmp -j diy_rules
```

#### REJECT

REJECT动作的常用选项为`--reject-with`，使用`--reject-with`选项，可以设置提示信息，当对方被拒绝时，会提示对方为什么被拒绝.

可用值如下：

icmp-net-unreachable、icmp-host-unreachable、icmp-port-unreachable（default默认值）、icmp-proto-unreachable、icmp-net-prohibited、icmp-host-pro-hibited、icmp-admin-prohibited

```bash
# 将拒绝报文默认的的“端口不可达”，改为“主机不可达”
iptables -A INPUT  -j REJECT --reject-with icmp-host-unreachable
```

#### LOG

LOG动作只负责记录匹配到的报文的相关信息，不负责对报文的其他处理，如果想要对报文进行进一步的处理，可以在之后设置具体规则，进行进一步的处理.

LOG可用选项：

1. `--log-level`：可以指定记录日志的日志级别，可用级别有emerg，alert，crit，error，warning，notice，info，debug（级别由高到低）

2. `--log-prefix`：可以给记录到的相关信息添加"标签"之类的信息，以便区分各种记录到的报文信息，方便在分析时进行过滤

注：`--log-prefix`对应的值不能超过29个字符

```bash
iptable -A INPUT -p tcp --dport 80 -m state --state NEW -j LOG --log-prefix "someone visit our web"
```

#### SNAT和DNAT和MASQUERADE

见[NAT路由](#NAT路由)

#### REDIRECT

可以用作端口映射

```bash
# 当别的机器访问本机的80端口时，报文会被重定向到本机的8080端口上
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
```

### 清除规则相关

格式：`iptables [-t tables] [-FXZ]`

选项与参数：

* -F：清除所有制订的规则

* -X：清除所有用户“自定义”的chain

* -Z：将所有chain的计数与流量统计都归零
* -D：删除规则

```bash
# 清除filter表所有规则
iptables -t filter -F
# 清除filter表的第一条INPUT链流量统计
iptables -Z INPUT 1
# 删除filter表的第一条INPUT链规则
iptables -D INPUT 1
```

:warning:**需要特别注意的是：**直接使用`-F`清空规则时，如果已经配置过默认规则为deny的环境，此步骤将使系统的所有网络访问中断，所以清空之前应当先执行`iptables -P INPUT ACCEPT`再执行`-F`操作。此外，清空规则不可逆转，除非你知道你在做什么，清空之前都应当先备份一份，步骤如下：

`iptables-save`和`iptables-restore`的使用：

```bash
# 将所有规则追加到一个文件
iptables-save -c -t filter > /root/iptables.bak			# 参数-c/--counters表示在输出中包含所有报文和字节计数的当前值，-t/--table <tablename>限制只输出特定表，如果不指定，会输出所有可能的表
# 重载iptables备份文件
iptables-restore < /root/iptables.bak
```

## 网络防火墙

假设有三台主机，一台内网主机，一台作为路由，另一台作为外网主机，关系如下（图有点辣鸡...）：

![](https://s2.ax1x.com/2019/12/19/QbmRO0.png)

实现访问控制（内网访问外网）

```bash
# 关闭内网主机访问外网主机
iptables -A FORWARD -j REJECT
# 允许内网主机对外网发出请求报文
iptables -I FORWARD -s 10.19.194.0/24 -p tcp --dport 80 -j ACCEPT
# 允许内网主机对外网接收请求报文
iptables -I 2 FORWARD -s 172.16.122.0/24 -p tcp --sport 80 -j ACCEPT
```

## NAT路由

以下简单示例借助于[网络防火墙](#网络防火墙)的拓扑结构.

### SNAT

This  target is only valid in the `nat table`, in the `POSTROUTING and INPUT` chains, and `user-defined` chains which are only called from those chains.

使用SNAT内网访问外网实现隐藏内网主机地址

```bash
iptables - t nat -A POSTROUTING -s 10.19.194.0/24 -j SNAT --to-source 172.16.122.138
```

### MASQUERADE

This  target is only valid in the `nat table`, in the `POSTROUTING` chain.  It should only be used with dynamically assigned IP (dialup) connections: **if you have a static IP address, you should use the SNAT target.** 

可以把MASQUERADE理解为动态的、自动化的SNAT，如果没有动态SNAT的需求，没有必要使用MASQUERADE，因为SNAT更加高效

```bash
# 固定网卡
iptables -t nat -I POSTROUTING -s 10.19.194.0/24 -o ens37 -j MASQUERADE
```

### DNAT

This target is only valid in the `nat table`, in the `PREROUTING and OUTPUT `chains, and `user-defined` chains which are  only called  from  those  chains.

让外网主机能够访问内网主机106的web服务

```bash
iptables - t nat -A PREROUTING -d 10.19.194.0/24 -p tcp --dport 80 -j SNAT --to-destination 10.19.194.106
```

## iptables实例

1. 仅允许一部分主机ping当前主机

```bash
# 前提是filter表的INPUT链和OUTPUT链默认策略为DROP
# INPUT链
iptables -A INPUT -s 172.16.122.0/24 -d 172.16.122.135 -p icmp -j ACCEPT
# INPUT链
iptables -A OUTPUT -s 172.16.122.135 -d 172.16.122.0/24 -p icmp -j ACCEPT
```

>扩展：icmp type（常见的0和8）
>
>| **类型TYPE** |用途描述 Description      |
>| ------------ | ---- |
>| 0 | Echo Reply——回显应答（Ping应答） |
>| 8 | Echo request——回显请求（Ping请求） |
>

因此，我们可以借助`icmp type`来实现自己可以ping别人，但别人ping不到自己

```bash
# 默认规则策略为DROP
iptables -I OUTPUT 2 -s 172.16.122.135 -p icmp --icmp-type 8 -j ACCEPT
iptables -I INPUT 2 -d 172.16.122.135 -p icmp --icmp-type 0 -j ACCEPT
```

2. 仅开放本机的ssh服务给指定网络

```bash
# 前提是filter表的INPUT链和OUTPUT链默认策略为DROP
# INPUT链
iptables -A INPUT -s 172.16.122.0/24  -d 172.16.122.135  -p tcp --dport 22 -j ACCEPT
# OUTPUT链
iptables -A OUTPUT -s 172.16.122.135  -d 172.16.122.0/24 -p tcp --sport 22  -j ACCEPT
```

3. iptables默认策略的优化

如果将filter表的`INPUT`或`OUTPUT`链默认策略改为`DROP`白名单模式的话，某一天你不小心使用了`-F`这个危险的选项将规则全部清空了，那这时你就无法远程访问到你的主机了，所以为了解决这个问题，可以使用以下方法：

```bash
# 将INPUT链和OUTPUT链的默认规则改为ACCEPT
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
# 将INPUT链和OUTPUT链的最后一条规则改为禁止
iptables -A INPUT -d 172.16.122.135 -j DROP
iptables -A OUTPUT -s 172.16.122.135 -j DROP
# 如果你的本机有多个ip地址的话，可以使用网卡来写规则
iptables -A INPUT -i ens33 -j DROP
iptables -A OUTPUT -o ens33  -j DROP
```

这样修改的好处有当你不小心清空规则后，还能够连接到远程主机，此外，还可以直接使用本地回环地址而无需新增规则.















参考资料：

https://linux.die.net/man/8/iptables

http://www.zsythink.net/

