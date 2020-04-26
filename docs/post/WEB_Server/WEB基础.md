>**This is web基础 StudyNote.**

#  http服务器程序

* `httpd`(Apache)：http://httpd.apache.org/
* `nginx`：http://nginx.org/en/
* `lighttpd`：http://www.lighttpd.net/
* 应用程序服务器：
  * `IIS`(.NET)：https://www.iis.net/
  * `tomcat`(.jsp)：https://tomcat.apache.org/

# 多处理模块(MPM)

# telnet安装与简单使用

* 安装使用`yum install telnet-server telnet -y `即可

* 由于telnet服务也是由xinetd守护的，所以安装完telnet-server，要启动telnet服务就必须重新启动xinetd ，`systemctl restart xinetd`，注意：最小化安装可能没有`xinetd`，所以需要手动安装

* **注意**：安装完telnet和xinetd，重启xinetd默认并不会启动telnet，所以需要手动配置以使用

  * >编辑**/etc/xinetd.d/telnet**服务文件，增加以下内容
    >
    >```shell
    ># default: yes
    >
    ># description: The telnet server servestelnet sessions; it uses \
    >
    >#      unencrypted username/password pairs for authentication.
    >service telnet
    >
    >{
    >  flags           = REUSE
    >  socket_type     = stream
    >  wait            = no
    >  user            = root
    >  server          =/usr/sbin/in.telnetd
    >  log_on_failure  += USERID
    >  disable         = no 
    >}
    >```
    >
    >编辑完成后，重启xinetd即可

  * 设置开机启动`systemctl enable xinetd.service`

* 测试telnet是否正常运行，`netstat -tnl |grep 23 `

* 解决telnet下root登录，密码正确，总提示`Login incorrect`的问题

  * >注释/etc/pam.d/remote的第一行即可

#  HTTP请求方法

| 序号 | 方法    | 描述                                                         |
| :--- | :------ | :----------------------------------------------------------- |
| 1    | GET     | 请求指定的页面信息，并返回实体主体。                         |
| 2    | HEAD    | 类似于 GET 请求，只不过返回的响应中没有具体的内容，用于获取报头 |
| 3    | POST    | 向指定资源提交数据进行处理请求（例如提交表单或者上传文件）。数据被包含在请求体中。POST 请求可能会导致新的资源的建立和/或已有资源的修改。 |
| 4    | PUT     | 从客户端向服务器传送的数据取代指定的文档的内容。             |
| 5    | DELETE  | 请求服务器删除指定的页面。                                   |
| 6    | CONNECT | HTTP/1.1 协议中预留给能够将连接改为管道方式的代理服务器。    |
| 7    | OPTIONS | 允许客户端查看服务器的性能。                                 |
| 8    | TRACE   | 回显服务器收到的请求，主要用于测试或诊断。                   |
| 9    | PATCH   | 是对 PUT 方法的补充，用来对已知资源进行局部更新 。           |

# HTTP响应状态码

HTTP状态码由三个十进制数字组成，第一个十进制数字定义了状态码的类型，后两个数字没有分类的作用。HTTP状态码共分为5种类型：

| 分类 | 分类描述                                       |
| :--- | :--------------------------------------------- |
| 1**  | 信息，服务器收到请求，需要请求者继续执行操作   |
| 2**  | 成功，操作被成功接收并处理                     |
| 3**  | 重定向，需要进一步的操作以完成请求             |
| 4**  | 客户端错误，请求包含语法错误或无法完成请求     |
| 5**  | 服务器错误，服务器在处理请求的过程中发生了错误 |

# 其他

1. 互联网咨询网站：https://www.netcraft.com/
2. 查询一个网站的服务信息（比如网站是运行在什么服务器，用什么web服务器，甚至是网站在哪个机房）：[https://searchdns.netcraft.com](https://searchdns.netcraft.com/)