> 来自：http://blog.itpub.net/9034054/viewspace-2075740/

Apache的主配置文件：/etc/httpd/conf/httpd.conf
默认站点主目录：/var/www/html/
Apache服务器的配置信息全部存储在主配置文件/etc/httpd/conf/httpd.conf中，这个文件中的内容非常多，用wc命令统计一共有1009行，其中大部分是以#开头的注释行。
[root@justin ~]# wc -l /etc/httpd/conf/httpd.conf 
1009 /etc/httpd/conf/httpd.conf 

配置文件包括三部分：

```
[root@justin ~]# grep '\' /etc/httpd/conf/httpd.conf -n 
33:### Section 1: Global Environment 
245:### Section 2: 'Main' server configuration 
973:### Section 3: Virtual Hosts 
```

1）Global Environment---全局环境配置，决定Apache服务器的全局参数
2）Main server configuration---主服务配置，相当于是Apache中的默认Web站点，如果我们的服务器中只有一个站点，那么就只需在这里配置就可以了。
3）Virtual Hosts---虚拟主机，虚拟主机不能与Main Server主服务器共存，当启用了虚拟主机之后，Main Server就不能使用了
\--------------------------------------------------------------------------------
**1）**Global Environment

>44 ServerTokens OS
>在出现错误页的时候是否显示服务器操作系统的名称，ServerTokens Prod为不显示
>
>57 ServerRoot "/etc/httpd"
>用于指定Apache的运行目录，服务启动之后自动将目录改变为当前目录，在后面使用到的所有相对路径都是想对这个目录下
>
>65 PidFile run/httpd.pid
>记录httpd守护进程的pid号码，这是系统识别一个进程的方法，系统中httpd进程可以有多个，但这个PID对应的进程是其他的父进程
>
>70 Timeout 60
>服务器与客户端断开的时间
>
>76 KeepAlive Off
>是否持续连接（因为每次连接都得三次握手，如果是访问量不大，建议打开此项，如果网站访问量比较大关闭此项比较好），修改为：KeepAlive On 表示允许程序性联机
>
>83 MaxKeepAliveRequests 100
>表示一个连接的最大请求数
>
>89 KeepAliveTimeout 15
>断开连接前的时间
>
>102 # 
>103 StartServers    8 
>104 MinSpareServers   5 
>105 MaxSpareServers  20 
>106 ServerLimit    256 
>107 MaxClients    256 
>108 MaxRequestsPerChild  4000 
>109 #
>系统默认的模块，表示为每个访问启动一个进程（即当有多个连接公用一个进程的时候，在同一时刻只能有一个获得服务）。
>StartServer开始服务时启动8个进程，最小空闲5个进程，最多空闲20个进程。
>MaxClient限制同一时刻客户端的最大连接请求数量超过的要进入等候队列。
>MaxRequestsPerChild每个进程生存期内允许服务的最大请求数量，0表示永不结束
>
>118 # 
>119 StartServers     4 
>120 MaxClients     300 
>121 MinSpareThreads   25 
>122 MaxSpareThreads   75 
>123 ThreadsPerChild   25 
>124 MaxRequestsPerChild  0 
>125 #
>为Apache配置线程访问，即每对WEB服务访问启动一个线程，这样对内存占用率比较小。
>ServerLimit服务器允许配置进程数的上限。
>ThreadLimit每个子进程可能配置的线程上限
>StartServers启动两个httpd进程，
>MaxClients同时最多能发起250个访问，超过的要进入队列等待，其大小有ServerLimit和ThreadsPerChild的乘积决定
>ThreadsPerChild每个子进程生存期间常驻执行线程数，子线程建立之后将不再增加
>MaxRequestsPerChild每个进程启动的最大线程数，如达到限制数时进程将结束，如置为0则子线程永不结束
>
>136 Listen 80
>监听的端口，如有多块网卡，默认监听所有网卡
>
>123 150 LoadModule auth_basic_module modules/mod_auth_basic.so 
>...... 
>201 LoadModule version_module modules/mod_version.so
>启动时加载的模块
>
>221 Include conf.d/*.conf
>加载的配置文件
>
>242 User apache 
>243 Group apache
>启动服务后转换的身份，在启动服务时通常以root身份，然后转换身份，这样增加系统安全

2）Main server configuration

>262 ServerAdmin root@localhost
>管理员的邮箱
>
>276 #ServerName www.example.com:80
>默认是不需要指定的，服务器通过名字解析过程来获得自己的名字，但如果解析有问题（如反向解析不正确），或者没有DNS名字，也可以在这里指定IP地址，当这项不正确的时候服务器不能正常启动。前面启动Apache时候提示正在启动 httpd：httpd: apr_sockaddr_info_get() failed forjustin httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1forServerName，解决方法就是启动该项把www.example.com:80修改为自己的域名或者直接修改为localhost
>
>285 UseCanonicalName Off
>如果客户端提供了主机名和端口，Apache将会使用客户端提供的这些信息来构建自引用URL。这些值与用于实现基于域名的虚拟主机的值相同，并且对于同样的客户端可用。CGI变量SERVER_NAME和SERVER_PORT也会由客户端提供的值来构建
>
>292 DocumentRoot "/var/www/html"
>网页文件存放的目录
>
>302 #
>303   Options FollowSymLinks 
>304   AllowOverride None 
>305 #
>对根目录的一个权限的设置
>
>317 # 
>331   Options Indexes FollowSymLinks 
>338   AllowOverride None 
>343   Order allow,deny 
>344   Allow from all 
>346 #
>对/var/www/html目录的一个权限的设置，options中Indexes表示当网页不存在的时候允许索引显示目录中的文件，FollowSymLinks是否允许访问符号链接文件。有的选项有ExecCGI表是否使用CGI，如Options Includes ExecCGI FollowSymLinks表示允许服务器执行CGI及SSI，禁止列出目录。SymLinksOwnerMatch表示当符号链接的文件和目标文件为同一用户拥有时才允许访问。AllowOverrideNone表示不允许这个目录下的访问控制文件来改变这里的配置，这也意味着不用查看这个目录下的访问控制文件，修改为：AllowOverride All 表示允许.htaccess。Order对页面的访问控制顺序后面的一项是默认选项，如allow，deny则默认是deny，Allowfromall表示允许所有的用户，通过和上一项结合可以控制对网站的访问控制
>
>360 # 
>366   UserDir disabled 
>375 #
>是否允许用户访问其家目录，默认是不允许
>
>381 # 
>382 #   AllowOverride FileInfo AuthConfig Limit 
>383 #   Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec 
>384 #   
>385 #     Order allow,deny 
>386 #     Allow from all 
>387 #   
>388 #   
>389 #     Order deny,allow 
>390 #     Deny from all 
>391 #   
>392 #
>如果允许访问用户的家目录中的网页文件，则取消以上注释，并对其中进行修改
>
>402 DirectoryIndex index.html index.html.var
>指定所要访问的主页的默认主页名字，默认首页文件名为index.html
>
>409 AccessFileName .htaccess
>定义每个目录下的访问控制文件名，缺省为.htaccess
>
>415 # 
>416   Order allow,deny 
>417   Deny from all 
>418   Satisfy All 
>419 #
>控制不让web上的用户来查看.htpasswd和.htaccess这两个文件
>
>425 TypesConfig /etc/mime.types
>用于设置保存有不同MIME类型数据的文件名
>
>436 DefaultType text/plain
>默认的网页的类型
>
>443  
>444 #  MIMEMagicFile /usr/share/magic.mime 
>445   MIMEMagicFile conf/magic
>446
>指定判断文件真实MIME类型功能的模块
>
>456 HostnameLookups Off
>当打开此项功能时，在记录日志的时候同时记录主机名，这需要服务器来反向解析域名，增加了服务器的负载，通常不建议开启
>
>466 #EnableMMAP off
>是否允许内存映射：如果httpd在传送过程中需要读取一个文件的内容，它是否可以使用内存映射。如果为on表示如果操作系统支持的话，将使用内存映射。在一些多核处理器的系统上，这可能会降低性能，如果在挂载了NFS的DocumentRoot上如果开启此项功能，可能造成因为分段而造成httpd崩溃
>
>475 #EnableSendfile off
>这个指令控制httpd是否可以使用操作系统内核的sendfile支持来将文件发送到客户端。默认情况下，当处理一个请求并不需要访问文件内部的数据时(比如发送一个静态的文件内容)，如果操作系统支持，Apache将使用sendfile将文件内容直接发送到客户端而并不读取文件
>
>484 ErrorLog logs/error_log
>错误日志存放的位置
>
>491 LogLevel warn
>Apache日志的级别
>
>497 LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined 
>498 LogFormat "%h %l %u %t \"%r\" %>s %b" common 
>499 LogFormat "%{Referer}i -> %U" referer 
>500 LogFormat "%{User-agent}i" agent
>定义了日志的格式，并用不同的代号表示
>
>>各参数解释：
>>
>>`%h`：客户端的IP地址
>>
>>`%I`：Remote User，通常为`-`
>>
>>`%u`：用户是否登录访问，若为非登录访问时，为`-`
>>
>>`%t`：服务器收到请求的时间
>>
>>`%r`：First Line of request，即请求首部，记录了此次访问的方法，以及协议版本等信息
>>
>>`%>s`：响应状态码
>>
>>`%b`：响应报文的大小，单位是字节，不包括响应报文的首部信息
>>
>>`%{Referer}i`：请求报文首部的`referer`值，即从那个页面超链接到当前页面，可以用来友情链接
>>
>>`%{User-Agent}i`：请求报文中的`User-Agent`值，即用户访问标识
>
>513 #CustomLog logs/access_log common 
>526 CustomLog logs/access_log combined
>说明日志记录的位置，这里面使用了相对路径，所以ServerRoot需要指出，日志位置就存放在/etc/httpd/logs
>
>536 ServerSignature On
>定义当客户请求的网页不存在，或者错误的时候是否提示apache的版本的一些信息
>
>551 Alias /icons/ "/var/www/icons/"
>定义一些不在DocumentRoot下的文件，而可以将其映射到网页根目录中，这也是访问其他目录的一种方法，但在声明的时候切记目录后面加”/”
>
>553  
>554   Options Indexes MultiViews FollowSymLinks 
>555   AllowOverride None 
>556   Order allow,deny 
>557   Allow from all 
>558
>定义对/var/www/icons/的权限，修改为 Options MultiViews FollowSymLinks表示不在浏览器上显示树状目录结构
>
>563  
>564   # Location of the WebDAV lock database. 
>565   DAVLockDB /var/lib/dav/lockdb
>566
>对mod_dav_fs.c模块儿的管理
>
>576 ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
>对CGI模块儿的的别名，与Alias相似。
>
>582  
>583   AllowOverride None 
>584   Options None 
>585   Order allow,deny 
>586   Allow from all 
>587
>对/var/www/cgi-bin文件夹的管理，方法同上
>
>\# Redirect old-URI new-URL
>Redirect参数是用来重写URL的，当浏览器访问服务器上的一个已经不存在的资源的时候，服务器返回给浏览器新的URL，告诉浏览器从该URL中获取资源。这主要用于原来存在于服务器上的文档改变位置之后，又需要能够使用老URL能访问到原网页
>
>604 IndexOptions FancyIndexing VersionSort NameWidth=* HTMLTable Charset=UTF-8 
>611 AddIconByEncoding (CMP,/icons/compressed.gif) x-compress x-gzip
>... 
>669 IndexIgnore .??* *~ *# HEADER* README* RCS CVS *,v *,t
>当一个HTTP请求的URL为一个目录的时候，服务器返回这个目录中的索引文件，如果目录中不存在索引文件，并且服务器有许可显示目录文件列表的时候，就会显示这个目录中的文件列表，为了使得这个文件列表能具有可理解性，而不仅仅是一个简单的列表，就需要前这些参数。如果使用了IndexOptionsFancyIndexing选项，可以让服务器针对不同的文件引用不同的图标。如果没有就使用DefaultIcon定义缺省图标。同样，使用AddDescription可以为不同类型的文档介入描述
>
>709 AddLanguage ca .ca 
>...... 
>734 AddLanguage zh-TW .zh-tw
>添加语言
>
>743 LanguagePriority en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv zh-CN zh-TW
>Apache支持的语言
>
>759 AddDefaultCharset UTF-8
>默认支持的语言
>
>765 #AddType application/x-tar .tgz
>支持的应用如果想支持对php的解析添加这样一行
>
>773 #AddEncoding x-compress .Z 
>774 #AddEncoding x-gzip .gz .tgz
>支持对以.Z和.gz.tgz结尾的文件
>
>779 AddType application/x-compress .Z 
>780 AddType application/x-gzip .gz .tgz
>添加对上述两种文件的应用
>
>796 #AddHandler cgi-script .cgi
>修改为：AddHandler cgi-script .cgi .pl 表示允许扩展名为.pl的CGI脚本运行
>
>816 AddType text/html .shtml 
>817 AddOutputFilter INCLUDES .shtml
>添加动态处理类型为server-parsed由服务器预先分析网页内的标记，将标记改为正确的HTML标识
>
>833 #ErrorDocument 404 /missing.html
>当服务器出现404错误的时候，返回missing.html页面
>
>855 Alias /error/ "/var/www/error/"
>赋值别名
>
>857  
>858  
>859   
>860     AllowOverride None 
>861     Options IncludesNoExec 
>862     AddOutputFilter Includes html 
>863     AddHandler type-map var 
>864     Order allow,deny 
>865     Allow from all 
>866     LanguagePriority en es de fr 
>867     ForceLanguagePriority Prefer Fallback 
>868   
>对/var/www/error网页的权限及操作
>
>895 BrowserMatch "Mozilla/2" nokeepalive 
>896 BrowserMatch "MSIE 4\.0b2;" nokeepalive downgrade-1.0 force-response-1.0 
>897 BrowserMatch "RealPlayer 4\.0" force-response-1.0 
>898 BrowserMatch "Java/1\.0" force-response-1.0 
>899 BrowserMatch "JDK/1\.0" force-response-1.0 
>.....
>设置特殊的参数，以保证对老版本浏览器的兼容，并支持新浏览器的特性

**3）Virtual Hosts**

>990 #NameVirtualHost *:80
>如果启用虚拟主机的话，必须将前面的注释去掉，而且，第二部分的内容都可以出现在每个虚拟主机部分。
>
>998 # VirtualHost example: 
>1003 # 
>1004 #   ServerAdmin webmaster@www.linuxidc.com 
>1005 #   DocumentRoot /www/docs/www.linuxidc.com 
>1006 #   ServerName www.linuxidc.com 
>1007 #   ErrorLog logs/www.linuxidc.com-error_log 
>1008 #   CustomLog logs/www.linuxidc.com-access_log common 
>1009 #