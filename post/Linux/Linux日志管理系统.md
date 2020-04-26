# Linux日志管理系统

## 系统常用日志

* `/var/log/message`：系统信息日志，包含错误信息等
* `/var/log/secure`：系统登录日志
* `/var/log/cron` ：定时任务日志
* `/var/log/maillog`：邮件日志
* `/var/log/boot.log`：系统启动日志

日志类型分类（facility）：

| 标识                  | 说明                                     |
| --------------------- | ---------------------------------------- |
| auth                  | pam产生的日志                            |
| authpriv              | ssh,ftp等登陆服务的验证信息              |
| cron                  | 时间任务相关                             |
| kern                  | 内核                                     |
| lpr                   | 打印                                     |
| mail                  | 邮件                                     |
| mark（syslog)-rsyslog | 服务内部的信息，时间标示                 |
| news                  | 新闻组                                   |
| user                  | 用户程序产生的相关信息                   |
| uucp                  | unix to unix copy,unix主机之间相关的通讯 |
| local 1～7            | 自定义的日志设备                         |

日志优先级别（priority）：

| 级别    | 说明                                                 |
| ------- | ---------------------------------------------------- |
| debug   | 有调式信息的，日志信息最多                           |
| info    | 一般信息的日志，最常用                               |
| notice  | 最具有重要性的普通条件信息                           |
| warning | 警告级别                                             |
| err     | 错误级别，组织某个功能或者模块不能正常工作的信息     |
| crit    | 严重级别，组织整个系统或者整个软件不能正常工作的信息 |
| alert   | 需要立刻修改的信息                                   |
| emerg   | 内核崩溃等严重信息                                   |
| none    | 什么都不记录                                         |

## 日志管理系统rsyslog

程序相关：

* 主程序：`rsyslogd`
*  主配置文件：`/etc/rsyslog.conf`，`/etc/rsyslog.d/*.conf`
*  服务脚本（centos6）：`/etc/rc.d/init.d/rsyslog`
*  Unit File（centos7）：`/usr/lib/systemd/system/rsyslog.service`

### 配置文件rsyslog.conf

rsyslog的配置文件主要分为三个模块：

* `MODULES`：模块加载
* `GLOBAL DIRECTIVES`：定义全局环境，格式模板
* `RULES`：定义了记录日志的设施以及等级等信息

#### MODULES

加载`imtcp`和`imudp`模块，即可将rsyslogd作为日志服务器端

```bash
# .../etc/rsyslog.conf
# Provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514

# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
# ...
```

保存退出，重启rsyslog服务`systemctl resart rsyslog`即可

#### RULES

定义格式：`facility.priority    Target`

Target可以保存至：

- 文件：记录日志事件于指定的文件中;通常应该位于/var/log目录下;文件路径之前的"-"表示异步写入;
- 用户：将日志事件通知给指定的用户;是通过将信息发送给登录到系统上的用户的终端进行的;
- 日志服务器：@host,把日志送往指定的服务器主机;
- host ：即日志服务器地址,监听在tcp或udp协议的514端口以提供服务; 管道： | COMMAND

例子：

1. ```bash
   # Log all the mail messages in one place.
   mail.*                                                  -/var/log/maillog
   ```

将mail的所有级别日志级别异步存储到`/var/log/maillog`中去

2. ```bash
   # Everybody gets emergency messages
   *.emerg                                                 :omusrmsg:*
   ```

将所有软件产生的`emerg`级别的信息显示给用户，`om`表示输出模块，`usrmsg`表示用户信息，`*`代表所有用户

3. ```bash
   *.info;mail.none;authpriv.none;cron.none                @172.16.122.132
   ```

将日志存储于远程主机172.16.122.132中，而不保存到本地日志文件中

### 将日志保存到mysql中

1. 安装`rsyslog-mysql`包

```bash
yum install -y rsyslog-mysql
```

```bash
[root@localhost ~]\# rpm -ql rsyslog-mysql
/usr/lib64/rsyslog/ommysql.so
/usr/share/doc/rsyslog-8.24.0/mysql-createDB.sql
```

使用rpm查询包产生的文件信息可以看出，一个是输出mysql模块文件，另一个是用于创建数据库表的数据库文件

2. 导入数据库脚本

```bash
mysql < /usr/share/doc/rsyslog-8.24.0/mysql-createDB.sql
```

3. 查看数据库表结构

```mysql
mysql> use Syslog;
mysql> SHOW TABLES;
+------------------------+
| Tables_in_Syslog       |
+------------------------+
| SystemEvents           |
| SystemEventsProperties |
+------------------------+
# 查看SystemEvents表结构
mysql> DESC SystemEvents;
mysql> DESC SystemEventsProperties;
```

4. 授予用户权限

```mysql
mysql> GRANT ALL ON Syslog.* TO 'rsyslog'@'172.16.122.%' IDENTIFIED BY 'rsyslog';
mysql> FLUSH PRIVILEGES;
```

5. 编辑rsyslog配置文件

```bash
####
# 启用模块
$ModLoad ommysql
# 编辑规则
*.info;mail.none;authpriv.none;cron.none	:ommysql:172.16.122.132,Syslog,rsyslog,rsyslog		# 从左往右代表的是所使用的模块，主机地址，数据库名，用户名，密码
####
```

重启mysql即可

### 图形化web管理(loganalyzer)

>官方站点：https://loganalyzer.adiscon.com/

1. 安装LNMP

```bash
yum install -y httpd php php-mysql php-gd
```

2. 将loganalyzer上传或者下载到服务器目录中

```bash
mkdir /var/www/html/loganalyzer
wget http://download.adiscon.com/loganalyzer/loganalyzer-4.1.8.tar.gz
tar xf loganalyzer-4.1.8.tar.gz
cp -r loganalyzer-4.1.8/src /var/www/html/loganalyzer
cd /var/www/html/loganalyzer
chmod +x *.sh
./configure.sh			# 脚本很简单（下面的secure.sh也是如此），手动执行也可以
```

3. 使用浏览器进行安装操作：http://localhost/loganalyzer
4. web安装完之后执行`./secure.sh`即可