<img src="https://s2.ax1x.com/2019/11/21/MIZWm8.png" alt="LAMP" style="zoom:67%;" />

---

# LAMP架构说明以及工作过程

各工具之间的关系图例：

<img src="https://s2.ax1x.com/2019/11/21/MIZf0S.png" alt="LAMP架构说明1" style="zoom: 80%;" />

工作过程：

<img src="/home/suofeiya/myGitbook/images/MIZ2Of.png" alt="LAMP说明2" style="zoom: 75%;" />

# LAMP安装

## 使用模块(Modules)

### 在`CentOS 6`上：

```bash
# 安装httpd，php，php-mysql，mysql-server
yum install -y httpd php php-mysql mysql-server
service httpd start
```

此时，`php`模块就安装到`httpd`中了，可以在根目录进行测试

```bash
vim /var/www/html/index.php
# 增加以下测试内容
<?php
phpinfo();
?>
######
# 打开浏览器或者使用其他方式验证一下即可
```

启用`mysql`

```bash
service mysql start
```

测试`php`连接`mysql`

```bash
# 新建测试页面
vim /var/www/html/php-mysql.php
# 增加以下内容
<?php
	$conn = mysql_connect('127.0.0.1','root','');
	if ($conn)
		echo "OK";
	else
		echo "Fail";
	mysql_close();
?>
######
```

### 在`CentOS 7`上：

```bash
# 安装httpd，php，php-mysql，mariadb-server
yum install -y httpd php php-mysql mariadb-server
systemctl start httpd
systemctl start mariadb
```

连接`php`和`mysql`以及测试程序和CentOS类似.

### 小练习

#### 安装并使用`WordPress`

>  `wordpress`官方站点：https://wordpress.org/

1. 下载完合适的`wordpress`版本后，上传到服务器网站根目录

2. 为`wordpress`添加`mysql`用户账号并创建相关数据库

```mysql
MariaDB [(none)]> GRANT ALL ON wordpress.* TO 'wordpress'@'%' IDENTIFIED BY 'wordpress';
MariaDB [(none)]> CREATE DATABASE wordpress;
* 注意：mysql默认会启用域名反解功能，可能会导致主机无法正常访问到mysql服务端，因此，需要在配置文件中增加一个参数： 在`CentOS 7`中，编辑`/etc/my.cnf`配置文件，加入`skip-name-resolve=ON|1`(跳过主机解析)，接着重启mariadb即可
```

3. 自行修改`wordpress`的安装配置文件

```bash
cp wp-config-sample.php wp-config.php
# 修改相关参数
DB_NAME				# 你的数据库名称
DB_USER				# 数据库用户
DB_PASSWORD			# 数据库用户的密码
DB_HOST				# mysql主机地址
```

4. 打开`wordpress`即可

#### 安装并使用`DZX`(Discuz!)论坛系统

>开源地址：https://gitee.com/ComsenzDiscuz/DiscuzX
>
>官方站点：https://www.discuz.net/
>
>官方应用中心：https://addon.dismall.com/

1. 下载合适的`DZX`版本：https://gitee.com/3dming/DiscuzL/attach_files/277010/download，上传到网站目录
2. 赋予暂时的`acl`权限

```bash
setfacl -R -m  u:apache:rwx /var/www/*
```

3. 编辑配置文件

```bash
vim /etc/httpd/conf.d/fastcgi.conf
####
DirectoryIndex index.php
ProxyRequests Off
ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/var/www/$1 
####
```

4. 打开浏览器执行安装程序
5. 安装结束后，收回`acl`权限

```bash
setfacl -R -b /var/www/*
```

---

**拓展：**`phpwind`（简称：pw）是一个基于`PHP`和`MySQL`的开源社区程序，是国内最受欢迎的通用型论坛程序之一

##  使用php-fpm(FastCGI,作为守护进程:9000)

### 以`CentOS 7`为例，将`httpd`、`php`、`mariadb`置于同一台主机之上

```bash
# 安装所需环境
yum install httpd php-fpm php-mysql mariadb-server -y

# 配置 apache 转发 php
vim /etc/httpd/conf.d/fastcgi.conf
####
DirectoryIndex index.php
ProxyRequests Off
ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/var/www/html/$1 
####
* 另外：可以直接在主机或者虚拟主机<Directory></Directory>中添加以下代码：
​```
ProxyRequests Off
ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/var/www/html/$1
​```
#配置 php 测试连接 mysql,
vim /var/www/html/index.php
####
<?php
	$conn = mysql_connect('127.0.0.1','root','');
	if ($conn)
		echo "OK";
	else
		echo "Fail";
	mysql_close();
?>
####

# 启动服务
systemctl restart httpd
systemctl start mariadb
systemctl start php-fpm
```

### 置于不同主机

WEB服务器(172.16.122.65)

```bash
yum install -y httpd
# 编辑配置文件，与单台主机类似，只是IP地址不同罢了
vim /etc/httpd/conf.d/fastcgi.conf
DirectoryIndex index.php
ProxyRequests Off
ProxyPassMatch ^/(.*\.php)$ fcgi://172.16.122.66:9000/data/www/$1 

* 注意：在HTTPD服务器上必须启用proxy_fcgi_module模块，充当PHP客户端
httpd –M |grep fcgi 
 # 显示：proxy_fcgi_module (shared)则正确
# 或者
cat /etc/httpd/conf.modules.d/00-proxy.conf

systemctl start httpd
```

PHP服务器(172.16.122.66)

```bash
yum install php-fpm php-mysql
#修改绑定端口，让他绑定所有IP
vim /etc/php.fpm.d/www.conf
listen = 9000
#修改允许IP访问的选项
listen.allowed_clients

mkdir -pv /data/www/

vim /data/www/index.php
####
<?php
	$conn = mysql_connect('172.16.122.67','phpuser','phpuser');
	if ($conn)
		echo "OK";
	else
		echo "Fail";
	mysql_close();
?>
####

systemctl start php
```

mysql服务器(172.16.122.67)

```bash
yum install mariadb mariadb-server
# 启动服务
systemctl start mariadb

#执行初始化脚本
mysql_ser_install

#创建php使用的账户
GRANT ALL ON *.* TO phpuser@'172.16.122.%' IDENTIFIED BY 'phpuser';
FLUSH PRIVILEGES;
```

## 编译安装

[源码编译实现LAMP 并且基于Fastcgi模型](源码编译实现LAMP 并且基于Fastcgi模型.md)

## 一键安装包

1. 主页：https://lamp.sh/
   1. 安装步骤说明：https://lamp.sh/install.html
   2. 下载页：https://lamp.sh/download.html

2. 主页：https://lnmp.org/
   1. 安装步骤说明：https://lnmp.org/install.html
   2. 下载页：https://lnmp.org/download.html

3. 主页：http://yumlamp.com/
4. phpstudy for linux一键安装包：http://lamp.phpstudy.net/

