>**This is httpd StudyNote.**

#  httpd-MPM模块

![](/home/suofeiya/myGitbook/images/Apache-MPM.png)

修改MPM需要更改`/etc/httpd/conf.modules.d/00-mpm.conf`文件指定的模块

#  httpd配置文件

* 详情参见：[httpd.conf文件详解](httpd.conf文件详解.md)
* 使用`httpd -t`可以检查配置文件语法错误

# httpd基础用法

* `Alias`路径别名

  * >编辑httpd配置文件，定义路径别名，例如
    >
    >```shell
    >Alias /URL/ "/PATH/TO/FILE/"
    ><Directory "/PATH/TO/FILE/">
    >    Options None
    >    AllowOverride None
    >    Require all granted
    ><Directory>
    >```
    >
    >重启服务即可
    >
    >
    >
    >需要注意特别的一点是：
    >
    >​			编辑Alias时，URL地址应该和后面别名的路径写法一致，`Alias /URL/ "/PATH/TO/FILE/"`是一组，或者都不带后面的反斜线`/`，否则回报`404`错误

注意：①`Alias`能够覆盖原设定的index    ②`httpd-2.4`版本下需要对目录进行显式授权，而2.2版本可以直接使用

* 基于用户和组的访问控制（Basic认证）

  * 基于用户的访问控制（文本文件）

    * >1. 使用`htpasswd`命令生成文本格式的密码文件
      >
      >```bash
      ># htpasswd 参数：
      ># -c ：自动创建指定路径下的文件，因此，该文件不存在时使用该命令
      ># -m： 使用md5加密方式加密
      ># -s： 使用sha加密方式加密
      ># -D：删除指定用户
      >htpasswd -c  /PATH/TO/FILE USER_NAME		# 当文件不存在时才使用-c选项
      ># 例如：
      >htpasswd -c passwd/mypasswd suofeiya
      >```
      >
      >2. 定义安全域
      >
      >```shell
      ><Directory "/var/www/test">
      > 	   Options None
      > 	   Allowoverride authconfig
      >	AuthType Basic
      >	AuthName "Weclome!"
      >	AuthUserFile "/var/www/passwd/mypasswd"
      >	Require valid-user
      ></Directory>
      >```
      >
      >3. 重启httpd服务即可

  * 基于组的访问控制

    * >步骤和基于用户认证基本相同
      >
      >所需要增加的选项是：
      >
      >```shell
      >AuthGroupFile "/PATH/TO/GROUP_FILE"			# 组文件
      >Require group GRP_NAME ...		# 组名称
      >```
      >
      >`GROUP_FILE`的格式是：
      >
      >```shell
      >GROUP_NAME: GRP_NAME1 GRP_NAME2 ...
      >```
    
  
* 虚拟主机

  * >1. 基于端口的虚拟主机
    >
    >   ①编辑主配置文件`/etc/httpd/conf/httpd.conf`
    >
    >```shell
    ># 在原有的Listen 80之后添加listen 8888
    >Listen 8888
    >```
    >
    >​			②创建并编辑`/etc/httpd/conf.d/vhost.conf`文件
    >
    >```shell
    ><VirtualHost 172.16.122.128:8888>
    >  DocumentRoot "/var/www/vhost/"
    >  ServerName    v1.com
    ></VirtualHost>
    >```
    >
    >2. 基于IP的虚拟主机
    >
    >   ①为主机网卡再添加一个IP地址
    >
    >```bash
    >ip addr add 172.16.122.129/16 dev ens33
    ># 查看ens33设备的ip情况
    >ip addr show dev ens33
    >```
    >
    >​			②编辑`/etc/httpd/conf.d/vhost.conf`文件
    >
    >```shell
    ><VirtualHost 172.16.122.129>
    >  DocumentRoot "/var/www/html_129/"
    >  ServerName    v_129.com
    ></VirtualHost>
    >```
    >
    >3. 基于域名（FQDN）的虚拟主机
    >
    >   ①编辑hosts文件，添加一条域名解析`172.16.122.128  1.com 2.com`
    >
    >   ②编辑`vhost.conf`文件
    >
    >```shell
    ><VirtualHost 172.16.122.129>
    >  DocumentRoot "/var/www/html2/"
    >  ServerName   2.com
    ></VirtualHost>
    >```
    >
    >注意：①如果需要将主机虚拟化，需要将主配置文件中的`DocumentRoot /var/www/html`注释掉，然后再添加为虚拟主机即可	②当httpd版本为2.2版本时，需要在虚拟主机配置文件之前添加`NameVirtualHost 172.16.122.128:80 `

* 为httpd添加`server-status`页面

  * >①编辑`/etc/httpd/conf/httd.conf`文件
    >
    >​			确保`mod_status.so`被加载，如果未被加载需要添加，在默认情况下，2.4.6版本的httpd已默认加载该模块，所以无需重复添加
    >
    >```bash
    >LoadModule status_module modules/mod_status.so
    >```
    >
    >②编辑主机文件或者虚拟主机配置文件，在这里我使用`/etc/httpd/conf.d/vhost.conf`
    >
    >```shell
    ><VirtualHost 172.16.122.128>
    >  DocumentRoot "/var/www/html2/"
    >  ServerName   2.com
    >  <Location /server-status>
    >  SetHandler server-status
    >  <RequireAll>
    >    Require ip 172.16
    >  </RequireAll>
    >  </Location>
    ></VirtualHost>
    >```
    >
    >其中使用`RequireAll`来限制可以访问该路径的ip网络
  
* **配置http支持https**

  * >##### 一、本地生成ssl证书
    >
    >**在CA服务器上**，进入`/etc/pki/CA/`，生成私钥 	
    >
    >```bash
    >(umask 077;openssl genrsa -out private/cakey.pem 2048)
    >```
    >
    >编辑` /etc/pki/tls/openssl.cnf `生成私钥时的默认选项
    >
    >生成自签证书
    >
    >```bash
    >openssl req -new -x509 -key private/cakey.pem -out cacert.pem -days 3650
    >```
    >
    >**在httpd服务器上**，创建`/etc/httpd/ssl`目录以存放ssl证书
    >
    >生成httpd的私钥
    >
    >```bash
    >(umask 077; openssl genrsa 1024 > httpd.key)
    >```
    >
    >生成httpd的自签证书
    >
    >```bash
    >openssl req -new -key httpd.key -out httpd.csr
    >```
    >
    >将生成好的自签证书发送到CA服务器，**在CA服务器上**验证
    >
    >```bash
    >openssl ca -in /tmp/httpd.csr -out /tmp/httpd.crt -days 365
    >```
    >
    >将生成好的证书`httpd.crt`回传给httpd服务器
    >
    >配置httpd支持使用ssl
    >
    >```bash
    >yum install -y mod_ssl
    >```
    >
    >编辑httpd配置文件
    >
    >```shell
    ># 更改或者添加以下内容
    ><VirtualHost 172.16.122.128:443>
    >DocumentRoot "/var/www/html2/"
    >ServerName   2.com:443
    >SSLCertificateFile /etc/httpd/ssl/httpd.crt
    >SSLCertificateKeyFile /etc/httpd/ssl/httpd.key
    ></VirtualHost>
    >```
    >
    >重启服务器即可
    >
    >>测试基于https访问相应的主机：
    >>
    >>```bash
    >>openssl s_client [hostname:port] [-cert FILENAME] [-CApath DIR] [-CAfile FILENAME]
    >># 例如：
    >>openssl s_client -connect 1.com:443 CAfile /tmp/cacert.pem
    >>```
    >
    >##### 二、使用ssl证书
  
* httpd自带的工具程序

  * >`htpasswd`：httpd自带的加密工具
    >
    >`apachectl`：httpd自带的控制脚本，支持start、stop、restart等指令
    >
    >`apxs`：该工具由httpd-devel提供，用于扩展第三方模块
    >
    >​				apxs是apache管理模块的工具，它做的是将mod.c生成mod.so，并使其能被apache加载，使用apxs的前提：`mod_so`已被加载
    >
    >​				详情参见：https://www.2cto.com/shouce/ApacheManual/programs/apxs.html
    >
    >`rotatelogs`：日志滚动工具，用于日志分割
    >
    >`suexec`：当访问某些需要特定权限的资源时，临时切换至指定用户
    >
    >`ab`：apache bench，httpd自带的压力测试工具

* httpd的压力测试工具

  * >`ab`：Apache HTTP server benchmarking tool
    >
    >​			格式：`ab [OPTIONS] URL`
    >
    >​			参数：`-n`请求数量			`-c`模拟并行数量			`-k`以持久连接模式连接进行测试
    >
    >其他第三方压力测试工具：
    >
    >`webbench`，`http_load`，`selge`，`jmeter`，`loadrunner`，`tcpcopy`等

