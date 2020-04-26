# Frp内网穿透
* 使用脚本一键搭建FRPC服务端
    * ```bash
        wget --no-check-certificate https://raw.githubusercontent.com/clangcn/onekey-install-shell/master/frps/install-frps.sh -O ./install-frps.sh

        chmod 700 ./install-frps.sh

        ./install-frps.sh install
        ```

* 安装结束后显示
    * ```bash
Congratulations, frps install completed!
        ==============================================
        You Server IP      : 59.110.139.188
        Bind port          : 5443
        KCP support        : true
        vhost http port    : 80
        vhost https port   : 443
        Dashboard port     : 6443
        token              : 3lapma0Q6loxIysp
        tcp_mux            : true
        Max Pool count     : 50
        Log level          : info
        Log max days       : 3
        Log file           : enable
        ==============================================
        frps Dashboard     : http://59.110.139.188:6443/
        Dashboard user     : suofeiya
        Dashboard password : Frp244
        ==============================================
        ```


* 更新卸载管理命令
    * ```bash
        更新命令:
        ./install-frps.sh update
        卸载命令:
        ./install-frps.sh uninstall
        
        服务器端管理命令:
        服务端程序提供了以下几组功能：
    
        运行程序： /etc/init.d/frps start   
    
        停止程序： /etc/init.d/frps stop
    
        重启程序： /etc/init.d/frps restart
    
        运行状态： /etc/init.d/frps status
    
        配置程序： /etc/init.d/frps config
    
        程序版本： /etc/init.d/frps version
    
        更多帮助请移步官方帮助文件:
        https://github.com/fatedier/frp/blob/master/README_zh.md
        ```

* FRPC客户端配置
    * ```bash
        mkdir frp         #建立文件夹frp
        cd frp            #进入frp文件夹
        wget https://github.com/fatedier/frp/releases/download/v0.29.0/frp_0.29.0_linux_amd64.tar.gz    #下载frp
        vi frpc.ini #修改frpc文件
        ./frpc -c ./frpc.ini #临时启动启动frpc服务端
        nohup ./frpc -c ./frpc.ini & #后台保持启动

        # 设置计划任务开启开机自动启动frpc
        # 计划命令
        /frp/frp_0.29.0_linux_amd64/frpc -c /frp/frp_0.29.0_linux_amd64/frpc.ini
        ```



* FRPC配置文件`frpc.ini`示例
    * ```bash
        [common]
        server_addr = 35.xx.xxx.xx
        server_port = 5443
        token = xxxxxxx
    
        [home]
        type = http 
        local_ip = 10.1.1.8
        local_port = 8123 
        remote_port = 8123 
        use_encryption = true 
        use_compression = true
        custom_domains = home.ictw.top 
        ```



# Golang安装与使用
* ```bash
        1、下载二进制包：go1.4.linux-amd64.tar.gz。

        2、将下载的二进制包解压至 /usr/local目录。

        tar -C /usr/local -xzf go1.4.linux-amd64.tar.gz
        3、将 /usr/local/go/bin 目录添加至PATH环境变量：

        export PATH=$PATH:/usr/local/go/bin
    ```
```
# Gotty的简单使用
* gotty -w bash
* 详情参见:https://github.com/yudai/gotty
```