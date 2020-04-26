> **This is Mysql、MariaDB基础 StudyNote.**

# MySQL

>MySQL是一个**关系型数据库管理系统**，由瑞典MySQL AB 公司开发，目前属于 Oracle 旗下产品。
>
>官方站点：https://www.mysql.com/

## 安装与简单使用

安装启动与简单设置

```bash
# 获取官网RPM文件
wget http://repo.mysql.com/[mysql80-community-release-el7-3.noarch.rpm]
# 校验rpm文件
rpm -ivh mysql-community-release-el7-5.noarch.rpm
# 更新下载
yum update
# 安装MySQL服务
yum install mysql-server
# 权限设置
chown mysql:mysql -R /var/lib/mysql

# 初始化Mysql
mysqld --initialize
# 启动mysql服务
systemctl start mysqld

# 关闭mysql服务
systemctl stop mysqld
# 或者
mysqladmin -uroot -p shutdown
```

验证安装及简单使用

```bash
#　查看mysql版本
mysqladmin --version
# 创建root默认密码
mysqladmin -u root password "your_new_passwd";

# 使用
mysql -uroot -p
```

## 用户管理

添加用户实例，用户名为`suofeiya`指定其密码为`suofeiya`，并授予其`SELECT`权限：

```mysql
# 方式一：
mysql> use mysql;
mysql> INSERT INTO user 
          (host, user, password, 
           select_priv) 
           VALUES ('localhost', 'suofeiya', 
           PASSWORD('suofeiya'), 'Y', 'Y', 'Y');
 # 重载授权表
mysql> FLUSH PRIVILEGES;
# 查看
mysql> SELECT host, user, password FROM user WHERE user = 'suofeiya';
* 需要注意的是，`password()`加密函数在mysql8中已被移除，可以使用`MD5()`函数来代替

# 方式二（MySQL8.0之后）：
mysql> CREATE USER 'suofeiya'@'%' IDENTIFIED BY 'suofeiya';
# 授予部分权限
mysql> GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON *.* TO 'suofeiya'@'%';
# 授予所有权限
mysql> GRANT ALL PRIVILEGES ON *.* TO 'suofeiya'@'%';
mysql> FLUSH PRIVILEGES;
# 查看用户权限
mysql> SHOW GRANTS FOR 'suofeiya'@'%';
```

## 查询数据



## 修改数据

## php连接使用mysql

[php-mysql](php-mysql.md)

# MariaDB

>MariaDB数据库管理系统是MySQL的一个分支，主要由开源社区在维护，采用GPL授权许可 MariaDB的目的是完全兼容MySQL，包括API和命令行，使之能轻松成为MySQL的代替品。
>
>官方站点：https://mariadb.org/

## MariaDB安装与简单使用

```bash
yum install -y mariadb-server
# 使用
mysql -uroot -p
```

`MariaDB`主要由两类程序文件：

- Client：`mysql`、`mysqldump`、`mysqladmin`
- Server：`mysqld`、`mysqld_safe`、`mysqld_multi`

# 简单管理工具：phpMyAdmin 

>phpMyAdmin 是一个以PHP为基础，以Web-Base方式架构在网站主机上的MySQL的数据库管理工具，让管理者可用Web接口管理MySQL数据库。
>
>官方站点：https://www.phpmyadmin.net/

为了安全，做些许修改

```bash
# 复制配置文件模板
cp config.sample.inc.php config.inc.php
# 修改模板
vim config.inc.php
# 修改并随意给出字符串即可
$cfg['blowfish_secret'] = 'fGCXVdsf3423432dfds'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
```

# 其他

## Mysql重置密码

如果忘记密码，可以在`/etc/my.cnf`配置文件中加入`skip-grant-tables`来重置密码，步骤如下：

1. 修改配置文件

```bash
vim /etc/my.cnf
####
...
[mysqld]
skip-grant-tables
port=3306
...
####
```

2. 重启mysql服务`systemctl restart mysql`

3. 登录mysql，并修改root密码

```mysql
mysql -uroot -p				# 此时登录无需输入密码，可直接登录成功
# 修改root密码
mysql > use mysql;
mysql> update user set authentication_string=password("newpasswd") where user='root';
mysql> flush privileges;

* 如果还是未修改成功，在password之后加入`,plugin='mysql_native_password'`试试
```

按照此种方法，可以先关闭mysql服务，然后找到mysql的主程序文件，加入`--skip-grant-tables`参数来修改密码，如`./mysqld_safe --skip-grant-tables &`，然后再登录mysql账户修改密码即可

## MySQL命令行神器MyCLI

>官方站点：https://www.mycli.net/

### 安装

在RHEL/CentOS上安装：

```bash
sudo yum install python-pip python-devel -y
sudo pip install mycli
```

在Debian/Ubuntu上安装：

```bash
sudo apt update
sudo apt install -y mycli
```

### 使用

在终端输入`mycli `指令外加与`mysql`连接工具相类似的参数即可，可以使用`mycli --help`来查看帮助.

## SQL在线练习网站

http://sqlfiddle.com/