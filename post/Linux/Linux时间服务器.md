# Linux时间服务器(chrony)

>NTP服务器：[https://baike.baidu.com/item/NTP%E6%9C%8D%E5%8A%A1%E5%99%A8/8633994?fr=aladdin](https://baike.baidu.com/item/NTP服务器/8633994?fr=aladdin)
>
>chrony官方站点：https://chrony.tuxfamily.org/
>
>与其它时间同步软件的对比：https://chrony.tuxfamily.org/comparison.html

chrony 是网络时间协议（NTP）的通用实现.

chrony 包含两个程序：`chronyd` 是一个可以在启动时启动的守护程序;`chronyc` 是一个命令行界面程序，用于监视 chronyd 的性能并在运行时更改各种操作参数.

## chrony的安装与配置

```bash
yum -y install chrony
systemctl enable chronyd
systemctl start chronyd
```

#### 默认配置文件

```bash
# 使用 pool.ntp.org 项目中的公共服务器。以server开，理论上想添加多少时间服务器都可以。
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst

# 根据实际时间计算出服务器增减时间的比率，然后记录到一个文件中，在系统重启后为系统做出最佳时间补偿调整。
# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# 如果系统时钟的偏移量大于1秒，则允许系统时钟在前三次更新中步进。
# Allow the system clock to be stepped in the first three updates if its offset is larger than 1 second.
makestep 1.0 3

# 启用实时时钟（RTC）的内核同步。
# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# 通过使用 hwtimestamp 指令启用硬件时间戳
# Enable hardware timestamping on all interfaces that support it.
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust the system clock.
#minsources 2

# 指定 NTP 客户端地址，以允许或拒绝连接到扮演时钟服务器的机器
# Allow NTP client access from local network.
#allow 192.168.0.0/16

* Serve time even if not synchronized to a time source.
server端即使没有从互联网同步到时间，也作为下级的时间服务器
#local stratum 10

# 指定包含 NTP 身份验证密钥的文件。
# Specify file containing keys for NTP authentication.
#keyfile /etc/chrony.keys

# 指定日志文件的目录。
# Specify directory for log files.
logdir /var/log/chrony

# 选择日志文件要记录的信息。
# Select which information is logged.
#log measurements statistics tracking
```

Aliyun官方ntp镜像及配置：https://developer.aliyun.com/mirror/NTP?spm=a2c6h.13651102.0.0.53322f70KNkgwZ

## 使用

ntp的使用参考：https://www.cnblogs.com/jhxxb/p/10579816.html

###  服务器端配置

服务器端配置仅需修改两处即可

```bash
# 自定义上级时间服务器地址
server s1a.time.edu.cn iburst
server ntp.aliyun.com iburst

# 允许NTP客户端可以访问的地址
allow 192.168.8.0/24
```

重启服务`systemctl restart chronyd`即可作为服务器端使用

同步：

```bash
# 查看时间同步状态
timedatectl status
# 开启网络时间同步
timedatectl set-ntp true
```

### 客户端配置

客户端配置也只需修改两处即可

```bash
server 172.16.122.132 iburst
# Allow NTP client access from local network.
allow 172.16.122.132
```

重启服务.

自动同步命令和server端相同

## chronyc命令

可以交互式使用，也可以加参数使用.

查看

```bash
# 查看 ntp_servers
chronyc sources -v
# 查看 ntp_servers 详细状态
chronyc sourcestats -v
# 查看 ntp_servers 是否在线
chronyc activity -v
# 查看 ntp 详细信息
chronyc tracking -v
```

## 其他

### 手动修改本机时间

使用`date`手动调节本地时间（存在误差，不推荐使用×）

```bash
date -s "2019-12-17 14:34:24"
# 或者使用
timedatectl set-time "2019-12-17 14:34:24"
# 将时间写入bios，防止重启后修改的时间无效
hwclock -w
```

使用`ntpdate`命令同步

```bash
# 使用ntpdate命令首先要安装好ntp
ntpdate -dv ntp.aliyun.com			# -d表示开启debug，-v显示详细信息
```

### 设置本机时区

>**相关时区知识：**
>
>GMT(Greenwich Mean Time，格林威治标准时间): 
>是指位于英国伦敦郊区的皇家格林尼治天文台的标准时间，因为本初子午线被定义在通过那里的经线。
>UTC(Universal Time/Temps Cordonné 世界标准时间)
>CST(Central Standard Time 國家標準時間，一說中原標準時間); 中国标准时间（China 
>Standard Time）
>GMT + 8 = UTC + 8 = CST

* 复制相应的时区文件，替换系统时区文件，或者创建链接文件

```bash
# 格式
cp /usr/share/zoneinfo/<主时区>/<次时区 >/etc/localtime
# 例如：在设置中国时区使用亚洲/上海（+8）
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

* 使用`timedatectl`设置

```bash
# timedatectl不加任何参数可以查看本机时间，统一时间，时区等有关信息，等同于timedatectl status
timedatectl

# 查看当前时区
date
date -R			# -R参数可以查看日期和时间 RFC 2822 格式

# 查看本机所有时区
ls /usr/share/zoneinfo
# 或者使用
timedatectl list-timezones

# 设置时区
timedatectl set-timezone Asia/Shanghai

# 开启或关闭 NTP
timedatectl set-ntp true/flase
```

* 使用`tzselect`交互式修改，直接在终端输入即可使用，使其永久生效，方法如下

```bash
####
TZ='Asia/Hong_Kong'; export TZ
####
*  将以上内容添加到家目录下的`.profile`文件中(bash对应加到`.bash_profile`)，然后重新登出登入即可
```

