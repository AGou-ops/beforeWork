# Nginx Rewrite 地址重写

Rewrite规则可以实现对url的重写，以及重定向

## 应用场景

-  地址跳转和协议跳转
-  伪静态，利于搜索引擎爬虫和SEO
-  调整用户浏览的URL，看起来规范，利于SEO
- 网站更换新域名
- 根据特殊的变量、目录、客户端信息进行跳转

## 规则优先级

1. 先执行server块的rewrite指令
2. 其次执行location匹配规则
3. 最后执行location中的rewrite

## 全局变量

在`rewrite`过程中，会用到一些全局变量：

```bash
$server_name   		 # 当前用户请求的域名
$request_filename 		# 请求的文件路径名（带网站的主目录/code/images/test.jpg）
$request_uri 		# 当前请求的文件路径（不带网站的主目录/inages/test.jpg）
$scheme		 # 用的协议，比如http或者https
```

## 配置语法

- Syntax： rewrite regex replacement [flag];
- Default：——
- Context：server、location、if

regex：

* `~ `为区分大小写匹配

* `~* `为不区分大小写匹配

* `!~`和`!~*`分别为区分大小写不匹配及不区分大小写不匹配

文件及目录匹配：

* `-f`和`!-f`用来判断是否存在文件

* `-d`和`!-d`用来判断是否存在目录

* `-e`和`!-e`用来判断是否存在文件或目录

* `-x`和`!-x`用来判断文件是否可执行

Flag参数：

| 标记符号  | 说明                                                         |
| --------- | ------------------------------------------------------------ |
| last      | 终止在本location块中处理接收到的URI，并将此处重写的URI作为新的URI使用其他location进行处理。（只是终止当前location的处理）**【如果没有匹配到，会继续向下匹配】** |
| break     | 将此处重写的URI作为一个新的URI在当前location中继续执行，并不会将新的URI转向其他location。【**如果没有匹配到，则不再向下匹配，直接返回结果404】** |
| redirect  | 将重写后的URI返回个客户端，状态码是302，表明临时重定向，主要用在replacement字符串不以“http://”，“ https://”或“ $scheme” 开头；**【地址栏会显示跳转后的地址】** |
| permanent | 将重写的URI返回客户端，状态码为301,指明是永久重定向；**【地址栏会显示跳转后的地址】** |

> `break`与`last`区别举例：
>
> break 只要匹配到规则，则会去本地配置路径的目录中寻找请求的文件；
> 而last只要匹配到规则，会对其所在的server(...)标签重新发起请求。
>
> ```nginx
> server {
>         listen 80;
>         server_name example.com;
>         root /code;
> 
>         location ~ ^/break {
>                 rewrite ^/break /test/ break;
>         }
>         location ~ ^/last {
>                 rewrite ^/last /test/ last;
>         }
>         location /test/ {
>                 default_type application/json;
>                 return 200 "ok";
>         }
> }
> ```
>
> **break请求：** 
>
> 1、首先：会去查找本地的/code/test/index.html;
>
> 2、如果找到了，则返回/code/test/index.html的内容； 
>
> 3、如果没找到该目录则报错404，如果找到该目录没找到对应的文件则403
>
>  **last请求:** 
>
> 1、首先：会去查找本地的/code/test/index.html; 
>
> 2、如果找到了，则返回/code/test/index.html的内容；
>
> 3、如果没找到，会对当前server重新的发起一次请求。example.com/test/ 
>
> 4、如果有location匹配上，则直接返回该location的内容。 
>
> 5、如果也没有location匹配，再返回404;

## 示例集合

在调试环境下，开启rewrite日志对规则的匹配以便观察：

```nginx
/var/log/nginx/error.log notice;

http{
    ...
    rewrite_log on;
    ...
}
```

### 示例一（常用301、302跳转）：

```nginx
# 修改配置文件vhost1.conf
server {
            listen 80;
            server_name   vhost1.com;
    # 301 永久跳转
            rewrite   ^/(.*)     http://www.vhost1.com/$1 permanent;
 }
    server {
        listen       80;
        server_name  www.vhost1.com;
    location / {
        root   /usr/share/nginx/html/vhost1;
        index  index.html index.htm;
    }
    location /aaa {
            # 302 临时跳转，用户访问/aaa/目录其实是访问服务器的bbb目录
    		# rewrite ^/aaa/(.*)$ /bbb/$1 redirect;
    }
    location /ccc {
        # 用户访问vhost1.com/ccc其实是访问agou-ops.top网站
        rewrite (.*) https://agou-ops.top redirect;
    }
    # 用户访问couese-11-22-33.html实际上真实访问的是/course/11/22/33/course_33.html
    location /course {
        # 灵活配法
        alias /course;
        rewrite ^/course-(.*)-(.*)-(.*).html$ /$1/$2/$3/course_$3.html redirect;
        # 固定配法
        # rewrite ^/course-(.*) /11/22/33/course_33.html redirect;
    }
       error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
 }
```

###  示例二（域名新旧跳转）：

```nginx
server
{
     listen 80;
     server_name www.old.com;
     rewrite "^/(.*)$" http://www.new.com/$1;
}
```

### 示例三（跳转站外网页）：

```nginx
 server {
        listen       80;
        server_name  vhost2.com;
        location / {
           root   /usr/share/nginx/html/vhost2;
            index  index.html index.htm;
        }
        error_page 404 /404.html;
            location = /40x.html {
        }
        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    if ( $http_host ~* "^(.*)") {
        set $domain $1;
        rewrite ^(.*) http://www.baidu.com break;
    }
 }
```

### 示例四（自动将http跳转到https）：

```nginx
# 方法一
server {
        listen 80;
        server_name www.vhost.com;
        rewrite ^(.*) https://$server_name$1 redirect;
    # 或者
        return 302 https://$server_name$request_uri;
}       

server { 
        listen 443;
        server_namewww.vhost.com;
        ssl on;
}
# 方法二
	location / {
           root /usr/share/nginx/html;
           index index.html;
           if ( $scheme = http ) {
               rewrite  ^/(.*)  https://www.xxx.com/$1 ;    
           }
       }
   # 指定网页跳转https
   location /login {
       root /usr/share/nginx/html;
       index index.html;
       if ( $scheme = http ) {
           rewrite / https://www.xxx.com/login permanent;
       }
       auth_basic "input password";
       auth_basic_user_file /apps/nginx/conf/.htpasswd;
   }
```

### 示例五（判断资源是否存在）：

```nginx
location / {
       root  /usr/share/nginx/html;
       index index.html;
       if ( !-f $request_filename ) {
           rewrite (.*) http://www.xxx.com/index.html;
       }
   }
   # 资源不存在则跳往首页
```

### 示例六（根据用户浏览器跳转指定目录）：

```nginx
# 如果用户使用的是IE浏览器则跳转至nginx-ie目录中去
if ($http_user_agent ~ MSIE) {
    rewrite ^(.*)$  /nginx-ie/$1 break;
}
```

### 示例七（资源防盗链）：

```nginx
location /images {
       root /data/nginx/pc;
       valid_referers none blocked server_names *.example.com example.* www.example.org/galleries/
               ~\.google\.;			 #当访问/images下的资源时，只有指定的这些才可以访问
       if ( $invalid_referer ) {     #如果访问资源的网站不是从上面指定的搜索引擎跳转过来的，则拒绝访问，并且返回状态码403
           return 403;
           rewrite ^/ http://xxx.com/daolian.png;
       }
   }
# ---
location ~* .(gif|jpg|png|swf|flv)$ {
valid_referers none blocked server_names *.example.com example.* www.example.org/galleries/
               ~\.google\.;
if ($invalid_referer) {
return 403;
	}
}
```

### 示例八（多目录转成参数）：

```nginx
# 需求如下所示
abc.domian.com/sort/2 => abc.domian.com/index.php?act=sort&name=abc&id=2

if ($host ~* (.*)\.domain\.com) {
    set $sub_name $1;
    rewrite ^/sort\/(\d+)\/?$ /index.php?act=sort&name=$sub_name&id=$1 last;
}
```

### 示例九（目录对换）：

```nginx
# 需求如下所示
/123456/xxxx -> /xxxx?id=123456

rewrite ^/(\d+)/(.+)/ /$2?id=$1 last;
```

### 示例十（设置某个子目录跳转页面）：

```nginx
location ^~ /baidu {
    rewrite ^.+ http://baidu.com/ last;
    break;
}
```

### 示例十一（域名镜像）：

```nginx
server
{
    listen 80;
    server_name mirror.test.com;
    index index.html index.htm index.php;
    root /opt/lampp/htdocs/www;
    rewrite ^/(.*) http://www.test.com/$1 last;
    access_log off;
}
```

### 示例十二（三级域名跳转）：

```nginx
if ($http_host ~* “^(.*)\.t\.test\.com$”) {
    rewrite ^(.*) http://top.test.com$1;
    break;
}
```

### 示例十三（）：

```nginx

```





## 参考链接

* NGINX内置变量：http://www.cnphp.info/nginx-embedded-variables-lasted-version.html
* ngx_http_rewrite_module：http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite
* ngx_http_referer_module：http://nginx.org/en/docs/http/ngx_http_referer_module.html