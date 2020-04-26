>**This is Linux网络客户端工具 StudyNote.**

*   wget命令

    *   ```bash
        wget -o example.html https://www.example.com 		# 将网页保存为本地网页文件
        wget -O https://www.example.com/index.html		# 将网页保存为本地网页文件，并将 URL 的最后部分当作文件名
        # 其他选项
		-b			# 启用后台下载
        -q			# 启用静默下载
        -c			# 启用续传
        --limit-rate SPEED			# 限速
        # 常用选项
        wget -O - -q URL			# 不下载文件，只将其打印在终端
        ```
    
    *   详情参见：http://www.ruanyifeng.com/blog/2019/09/curl-reference.html
    
*   curl命令

    *   ```bash
        curl -o [local_dir] remote_url  # 指定远端文件目录和本地文件目录
        curl "https://www.{baidu,douban}.com" -o "site_#1.txt"  #  后面的#1代表前面的参数
        
        #  FTP文件上传
        curl -T local_files ftp://user:passwd@remote_ip:port/data
        #  或者使用curl -T local_files user:passwd ftp://remote_ip:port/data
        
        # 其他选项
        -A/--user-agent			# 设置用户代理标识
        --basic			# 使用HTTP基本认证
        --tcp-nodelay			# 使用TCP_NODELAY选项
        -e/--referer <来源网站>			# 设置来源网站
        --cacert <FILE>			# 设置ssl证书
        --compressed			# 要求返回压缩格式
        -H/--header <line>			# 设置首部信息
        --limit-rate <speed>			# 限速
        -u/--user <user[:passwd]>			# 设置传输服务器的账号和密码
        -0			# 使用HTTP1.0协议
        ```
        
    *   详情参见：http://www.ruanyifeng.com/blog/2019/09/curl-reference.html

* ping命令

  * ```bash
    # ping - send ICMP ECHO_REQUEST to network hosts
    # ICMP: Internet Control Message Protocol
    # 参数：
    -c \# 			# 发送的ping包个数
    -w \#			# ping命令超时时长
    -W \# 			# 一次ping操作中，等待对方响应的超时时长
    -s \# 			# 指明ping包报文大小
    ```

* hping命令

  * ```bash
    # 常用参数：
    --fast
    --faster
    --flood
    ```

  * 详情参见：https://github.com/antirez/hping

* lftp命令

  * 

* lftpget命令

  * 

