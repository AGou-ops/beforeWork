> **This is Linux服务器 StudyNote.**

#  查看服务器端口(端口占用检测.md)

	netstat -tunlp|grep [服务]	# t:tcp	u:udp	n:仅显示地址,而不显示主机名,可加速查询速度	l:Listen	p:显示建立相关链接的程序名	
	nmap localhost	# 扫描本机所启用的端口,默认只扫描TCP
	nmap -sTU localhost	# s:scan	T:tcp	u:udp	其他参数:-sP:以ping方式扫描	-sO:以ip协议进行扫描	-PT:使用TCP里面的ping	-PI:使用ping(带有ICMP数据包)来进行扫描
* netcat命令

	lsof -i:[端口号port]	# 查看当前用户的端口所对应的相关信息,不加:<port>扫描全部


#  使用ssh无密码登录其他远程主机

*  使用ssh-keygen命令来生成私钥和公钥

  ```bash
  ssh-keygen (-t rsa/dsa) 默认为rsa加密方式
  # 生成的公钥私钥放置于家目录的.ssh目录当中
  ```

* 将生成的公钥文件上传并附加到远程服务器的信任文件当中去

  ```bash
  # Ubuntu 系统下是known_hosts
  cat id_rsa.pub >> known_hosts
  # 然而在CentOS系统下文件是authorized_keys
  cat id_rsa.pub >> authorized_keys
  ```

*  使用scp上床到远程服务器上，或者使用`ssh-copy-id -i /root/.ssh/id_rsa.pub centos`自动上传到远程服务器的相应文件当中去

# CentOS最小化安装中使用gnome桌面以及配置VNC进行远程桌面连接（[其他桌面环境](https://www.bnxb.com/linuxserver/27457.html)）

* ```bash
  # 获取当前默认选项
  systemctl get-default
  # 如果返回值为:multi-user.target 命令行输入下面指令切入到图形界面:
  systemctl set-default graphical.target
  # 如果需要改回命令行模式,输入如下指令
  systemctl set-default multi-user.target
  ```

* ```bash
  # 或者设置防火墙规则，这里为了方便起见
  systemctl stop firewalld
  yum update
  yum groupinstall "GNOME Desktop" "X Window System" "Desktop" 
  yum install tigervnc-server tigervnc vnc vnc-server
  # 拷贝配置文件到相应目录。并按照配置文件说明修改相关内容
  cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
  ```

* ```bash
  vncpasswd # 对当前用户的vnc设置密码，或者第一次运行vncserver :1
  vim /etc/libvirt/qemu.conf # 修改配置文件
  # 去掉以下两行的注释
  vnc_password = "123456"
  vnc_listen = "0.0.0.0"
  ```

* ```bash
  # 重新加载systemd
  systemctl daemon-reload
  # 启用vnc到指定接口
  vncserver :1
  # 最后使用vnc viewer客户端进行连接即可
  ```

#  nginx安装与使用(环境CentOS7)

## 使用源码安装


* ​	安装编译工具及库文件
  
  ```bash
  yum -y install make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel
  ```


* 编译安装PCRE库

  * ```bash
    cd /usr/local/src
    wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.43.tar.gz
    tar -zxvf pcre-8.37.tar.gz
    cd pcre-8.43
    ./configure
    make
    make install
    ```

* 安装zlib库

  * ```bash
    cd /usr/local/src
    wget http://zlib.net/zlib-1.2.11.tar.gz
    tar -zxvf zlib-1.2.11.tar.gz
    cd zlib-1.2.8
    ./configure
    make
    make install
    ```

* 安装ssl

  * ```bash
    cd /usr/local/src
    wget https://www.openssl.org/source/openssl-1.0.2s.tar.gz
    tar -zxvf openssl-1.0.2s.tar.gz
    ```

* 安装nginx

  * ```bash
    cd /usr/local/src
    wget http://nginx.org/download/nginx-1.9.9.tar.gz  
    tar -zxvf nginx-1.9.9.tar.gz  
    cd nginx-1.9.9.tar.gz
    
    ./configure --sbin-path=/usr/local/nginx/sbin \
    --with-http_stub_status_module \
    --conf-path=/usr/local/nginx/nginx.conf \
    --pid-path=/usr/local/nginx/nginx.pid \
    --with-http_ssl_module \
    --with-pcre=/usr/local/src/pcre-8.43 \
    --with-zlib=/usr/local/src/zlib-1.2.11 \
    --with-openssl=/usr/local/src/openssl-1.0.2s \
     --prefix=/usr/local/webserver/nginx
    # --with-pcre=/usr/src/pcre-8.34 指的是pcre-8.34 的源码路径。
    # --with-zlib=/usr/src/zlib-1.2.7 指的是zlib-1.2.7 的源码路径。
    #  --prefix指定nginx安装目录
    make
    make install
    ```
  
* Nginx配置及文件
  
  
    * ```bash
       [root@localhost conf]\# /usr/sbin/groupadd www 
       [root@localhost conf]\# /usr/sbin/useradd -g www www
        
        # /usr/local/webserver/nginx/conf/nginx.conf文件内容：
        user www www;
        worker_processes 2; #设置值和CPU核心数一致
        error_log /usr/local/webserver/nginx/logs/nginx_error.log crit; #日志位置和日志级别
        pid /usr/local/webserver/nginx/nginx.pid;
        #Specifies the value for maximum file descriptors that can be opened by this process.
        worker_rlimit_nofile 65535;
        events
        {
          use epoll;
          worker_connections 65535;
        }
        http
        {
        include mime.types;
        default_type application/octet-stream;
        log_format main  '$remote_addr - $remote_user [$time_local] "$request" '
                     '$status $body_bytes_sent "$http_referer" '
                     '"$http_user_agent" $http_x_forwarded_for';
      #charset gb2312;
        server_names_hash_bucket_size 128;
        client_header_buffer_size 32k;
        large_client_header_buffers 4 32k;
        client_max_body_size 8m;
        sendfile on;
        tcp_nopush on;
        keepalive_timeout 60;
        tcp_nodelay on;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        fastcgi_buffer_size 64k;
        fastcgi_buffers 4 64k;
        fastcgi_busy_buffers_size 128k;
        fastcgi_temp_file_write_size 128k;
        gzip on; 
        gzip_min_length 1k;
        gzip_buffers 4 16k;
        gzip_http_version 1.0;
        gzip_comp_level 2;
        gzip_types text/plain application/x-javascript text/css application/xml;
        gzip_vary on;
        #limit_zone crawler $binary_remote_addr 10m;
       #下面是server虚拟主机的配置
       server
        {
          listen 80;#监听端口
          server_name localhost;#域名
          index index.html index.htm index.php;
          root /usr/local/webserver/nginx/html;#站点目录
            location ~ .*\.(php|php5)?$
          {
            #fastcgi_pass unix:/tmp/php-cgi.sock;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
          }
          location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|ico)$
          {
            expires 30d;
        # access_log off;
          }
          location ~ .*\.(js|css)?$
          {
            expires 15d;
         # access_log off;
          }
          access_log off;
        }
      }
      ```
  
* 启动过程中遇到的问题

  * ```bash
    # 在虚拟机centos7上安装nginx之后虚拟机内能访问，真机不能访问，修改iptables配置也不起作用，最后上网查找了资料后才发现centos的防火墙改成了firewall,不再叫iptables,开放端口的方法如下：
    firewall-cmd --zone=public --add-port=80/tcp --permanent
    # 重启防火墙
    systemctl stop firewalld.service  
    systemctl start firewalld.service 
    ```
  
  * ```bash
    #　解决CentOS7出现的”Failed to start firewalld.service”问题
    systemctl unmask firewalld.servic
    #　然后再启动”systemctl start firewalld.service”即可解决问题没有报错。
    ```

##  使用YUM安装

* ```bash
  # 安装gcc环境
  yum install gcc-c++
  # 分别安装pcre，zlib，openssl
  yum install -y pcre pcre-devel
  yum install -y zlib zlib-devel
  yum install -y openssl openssl-devel
  # 安装nginx服务，从官网下载源码进行安装，
  ```

## 基础用法

* 启动：`./nginx`
* 停止：
  * `./nginx -s quit`:此方式停止步骤是待nginx进程处理任务完毕进行停止
  * `./nginx -s stop`:此方式相当于先查出nginx进程id再使用kill命令强制杀掉进程
* 重启`./nginx -s quit`    `./nginx`

## 其他设置

### 开机自启动

 即在`rc.local`增加启动代码就可以了。

```bash
vi /etc/rc.local
```

增加一行 `/usr/local/nginx/sbin/nginx`
设置执行权限：

```bash
chmod 755 rc.local
```

第二种方法（基于系统服务，所以要先进行下面那个步骤）：

```bash
chkconfig nginx on
```

## 添加为系统服务

```bash
vi /etc/init.d/nginx
```

插入以下内容：

```shell
#! /bin/bash
# chkconfig: - 85 15
PATH=/usr/local/nginx
DESC="nginx daemon"
NAME=nginx
DAEMON=$PATH/sbin/$NAME
CONFIGFILE=$PATH/conf/$NAME.conf
PIDFILE=$PATH/logs/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
set -e
[ -x "$DAEMON" ] || exit 0
do_start() {
$DAEMON -c $CONFIGFILE || echo -n "nginx already running"
}
do_stop() {
$DAEMON -s stop || echo -n "nginx not running"
}
do_reload() {
$DAEMON -s reload || echo -n "nginx can't reload"
}
case "$1" in
start)
echo -n "Starting $DESC: $NAME"
do_start
echo "."
;;
stop)
echo -n "Stopping $DESC: $NAME"
do_stop
echo "."
;;
reload|graceful)
echo -n "Reloading $DESC configuration..."
do_reload
echo "."
;;
restart)
echo -n "Restarting $DESC: $NAME"
do_stop
do_start
echo "."
;;
*)
echo "Usage: $SCRIPTNAME {start|stop|reload|restart}" >&2
exit 3
;;
esac
exit 0
```

设置执行权限

```bash
chmod a+x /etc/init.d/nginx
```

注册成服务

```bash
chkconfig --add nginx
```

# Apache安装与使用（安装环境CentOS7）

## 使用YUM安装

* 安装httpd(apache服务的软件叫做httpd)

  * ```bash
    yum install -y httpd
    ```

* 将Apache服务添加到 开机自启中

  * ```bash
    # 打开apache服务	
    systemctl start httpd
    # 设置开机自启
    systemctl enable httpd
    ```


## 配置文件详情

* 文件存放目录

| 服务目录     | /etc/httpd                 |
| ------------ | -------------------------- |
| 主配置文件   | /etc/httpd/conf/httpd.conf |
| 网站数据目录 | /var/www/html              |
| 访问日志     | /var/log/httpd/access_log  |
| 错误日志     | /var/log/httpd/error_log   |

*  `httpd.conf`中的有用设置

  * ```shell
    #服务器根目录
    ServerRoot "/etc/httpd"
    
    #端口
    #Listen 12.34.56.78:80
    Listen 80
    
    #域名+端口来标识服务器，没有域名用ip也可以
    #ServerName www.example.com:80
    
    #不许访问根目录
    <Directory />
        AllowOverride none
        Require all denied
    </Directory>
    
    # 文档目录
    DocumentRoot "/var/www/html"
    
    # 对 /var/www目录访问限制
    <Directory "/var/www">
        AllowOverride None
        # Allow open access:
        Require all granted
    </Directory>
    
    # 对/var/www/html目录访问限制
    <Directory "/var/www/html">
    　　 Options Indexes FollowSymLinks
    　　 AllowOverride None
     　　Require all granted
    </Directory>
    
    # 默认编码
    AddDefaultCharset UTF-8
    
    #EnableMMAP off
    EnableSendfile on
    
    # include进来其它配置文件
    
    IncludeOptional conf.d/*.conf
    ```

##  Apache的使用

* 使用`systemctl [option] httpd`来停止，重启，开启服务

* 修改 网站数据的主目录

  * ```bash
    # 设置网站数据的主目录
    mkdir /wwwroot/www
    echo "hello suofeiya from new DIR" > /wwwroot/www/index.html
    # 修改DocumentRoot地址为自定义地址
    ```


# DHCP服务

* 期配置文件结尾以分号“;”分开（除{}），注意！
* 




