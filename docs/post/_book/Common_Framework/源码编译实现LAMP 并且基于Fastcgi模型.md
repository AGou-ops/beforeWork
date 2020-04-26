准备3台设备：

- apache : 192.168.30.7
- php: 192.168.30.17
- mysql / mariadb : 192.168.30.27

编译顺序：通常是 apache > mysql > php

准备安装包

```bash
http
httpd-2.4.33.tar.bz2
apr-1.6.3.tar.gz
apr-util-1.6.1.tar.gz

mysql
mariadb-10.2.15-linux-x86_64.tar.gz

php
php-7.1.18.tar.bz2

blog
wordpress-4.9.4-zh_cn.tar.gz

#安装编译包组
yum groupinstall Development

#创建账户，用于未来apache和php使用
groupadd -r -g 80 apache
useradd -r -s /sbin/nologin -g 80 -u 80 apache
```

### 编译apache

```bash
#安装apache依赖包
yum install pcre-devel openssl-devel expat-devel

tar xvf httpd-2.4.33.tar.bz2
tar xvf apr-1.6.3.tar.gz
tar xvf apr-util-1.6.1.tar.gz

mv apr-1.6.3 httpd-2.4.33/srclib/apr
mv apr-util-1.6.1 httpd-2.4.33/srclib/apr-util

cd httpd-2.4.33

./configure --prefix=/app/httpd24 \
--enable-so \ 
--enable-ssl \
--enable-cgi \
--enable-rewrite \
--with-zlib \
--with-pcre \
--with-included-apr \
--enable-modules=most \
--enable-mpms-shared=all \
--with-mpm=prefork

make -j 4 && make install

echo PATH=/app/httpd24/bin:$PATH > /etc/profile.d/lamp.sh
. /etc/profile.d/lamp.sh

#设置服务使用apache账户密码
vim /app/http.conf


#启动服务
apachectl 
```

### 二进制安装mysql

```bash
tar xvf mariadb-10.2.15-linux-x86_64.tar.gz -C /usr/local

cd /usr/local
ln -s mariadb-10.2.15-linux-x86_64/ mysql

useradd -r mysql -s /sbin/nologin 

chown -R mysql.mysql mysql

mkdir /data/mysqldb -pv

chown mysql.mysql /data/mysql/

vim /etc/profile.d/lamp.sh
PATH=/usr/local/mysql/bin:/app/httpd24/bin:$PATH > /etc/profile.d/lamp.sh

.  /etc/profile.d/lamp.sh

cd /usr/local/mysql/
./scripts/mysql_install_db --datadir=/data/mysqldb --user=mysql

cp support-files/my-huge.cnf /etc/my.cnf
cp support-files/mysql.server /etc/init.d/mysqld

vim /etc/my.cnf
datadir=/data/mysqldb
innodb_file_per_table
log_bin

chkconfig --add mysqld
service mysqld start

create database wpdb;
grant all on wpdb.* to wpuser@'192.168.30.%' identified by 'centos'; 
flush privileges;
```

### 编译php 7.1.7 基于 fastcgi 模式

php编译后需要自己准备ini 配置文件

```bash
#安装php依赖包
yum install libxml2-devel bzip2-devel libmcrypt-devel (epel)

tar xvf php-7.1.7.tar.bz2
cd php-7.1.7/

#设置编译项
./configure --prefix=/app/php \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-openssl \
--with-pdo-mysql=mysqlnd \
--enable-mbstring \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--enable-sockets \
--enable-fpm \
--with-config-file-path=/etc \
--with-config-file-scan-dir=/etc/php.d \
--enable-maintainer-zts \
--disable-fileinfo

make -j 4 && make install

--enable-fpm \ 表示以 fastcgi模式来编译安装

vim /etc/profile.d/lamp.sh
PATH=/app/php/bin:/usr/local/mysql/bin:/app/httpd24/bin:$PATH > /etc/profile.d/lamp.sh

.  /etc/profile.d/lamp.sh


#准备配置文件
cd /root/srcs/php-7.1.18/
cp php.ini-production /etc/php.ini

#准备启动脚本
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm
chkconfig php-fpm on

cd /app/php/etc
cp php-fpm.conf.default php-fpm.conf
cp php-fpm.d/www.conf.default php-fpm.d/www.conf

#设置服务使用apache账户密码
vim /app/etc/php-fpm.d/www.conf

service php-fpm start
```

### 编辑apache 配置 使其支持 php

```bash
vim /app/httpd24/conf/httpd.conf 
取消下面两行的注释 激活fcgi模块
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
修改下面行
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

addType application/x-httpd-php .php
AddType application/x-httpd-php-source .phps
ProxyRequests Off
ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/app/httpd24/htdocs/$1
```

>来自：https://www.cnblogs.com/ddz-linux/p/10699449.html