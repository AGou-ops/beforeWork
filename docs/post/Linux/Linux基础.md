>  **`This is Linux基础 StudyNote.**

#  基础命令使用

*   `nohup`将命令放于后台执行，常用于脚本类，例如：` nohup sh test.sh &`，执行命令的同时，在家目录会生成一个nohup.out的文件来接收返回结果，所以可以使用`tail -f nohup.out`来实时查看输出内容

*   `screen`命令：

    *   >（1）打开screen：`screen`
        >
        >（2）拆除分解screen：使用快捷键`Ctrl+a，d`
        >
        >（3）列出当前正在运行的screen：`screen -ls`
        >
        >（4）连接至screen：`screen -r SCREEN_ID`
        >
        >（5）关闭当前screen：`exit`

* 解压缩

  * > 1、*.tar 用 tar –xvf 解压
    >
    > 2、*.gz 用 gzip -d或者gunzip 解压
    >
    > 3、*.tar.gz和*.tgz 用 tar –xzf 解压
    >
    > 4、*.bz2 用 bzip2 -d或者用bunzip2 解压
    >
    > 5、*.tar.bz2用tar –xjf 解压
    >
    > 6、*.Z 用 uncompress 解压
    >
    > 7、*.tar.Z 用tar –xZf 解压

*   `scp`命令：加密传输-本地主机-远程主机(具体参见<https://wangchujiang.com/linux-command/c/scp.html>或者man pages)

  * ```bash
    # 从远处复制文件到本地目录
    scp root@centos:/root/anaconda-ks.cfg .
    
    # 上传本地文件到远程机器指定目录
    scp /home/suofeiya/Shell_Study/control_progress_status/prepare.txt root@centps:/root
    # 指定端口 2222
    scp -rp -P 2222 /home/suofeiya/Shell_Study/control_progress_status/prepare.txt root@centps:/root
    
    # 上传本地目录到远程机器指定目录
    scp -r /home/suofeiya/Shell_Study/control_progress_status/test root@centos:/root/test
    ```
  
*   `find`实用命令

    *   ```bash
        find  ./ -perm /002  -exec mv {} {}.bak \;
        #  查找没有属组属主的文件，并一个个询问是否要更改权限
        find ./ -nouser -a -nogroup -ok chmod root:root {} \;
        
        -print0			# 不换行无间隔输出
        ```

*   `xargs`命令

    *   ```bash
        * 常用选项
        -d			# 默认情况下，xargs命令以空格、tab、回车作为参数分隔符，使用-d选项可以指定分割符
        echo "hello#suofeiya#~" | xargs -d '#' echo
        -p			# 强制用户进入交互确认模式，输入y则执行，否则不执行
        echo "hello suofeiya" | xargs -p echo
        ---
        -n			# 选项表示将xargs生成的命令行参数，每次传递几个参数给其后面的命令执行
        echo '11@22@33@44@55@66@77@88@99@00' | xargs -d '@' -n 3 echo
        输出结果：
        11 22 33
        44 55 66
        77 88 99
        00			# 运行四次，每次传递三个参数给echo命令
        ---
        -E			# 该选项指定一个字符串，当xargs解析出多个命令行参数的时候，如果搜索到-E指定的命令行参数，则只会将-E指定的命令行参数之前的参数(不包括-E指定的这个参数)传递给xargs后面的命令
        echo '11 22 33' | xargs -E '33' echo
        输出结果：
        11 22
        * 注意：`-E`只有在xargs不指定`-d`的时候有效，如果指定了`-d`则不起作用。
        ---
        -0			# 表示以 '\0' 为分隔符，一般与find结合使用
        find . -name "*.txt" -print0 | xargs -0 echo		# 等同于-d '\0'
        -I/-i			# -I选项（或者-i）: 用于将参数用{}替代
        echo 'test.txt' | xargs -i  cp  {} /root/
        ```

*   `cat`命令的特殊使用

    *   ```bash
        cat << EOF
        something u want write here.
        EOF
        ```


*   `anacron`定时任务

*   `chroot`切换root目录

*   `hash`命令


    *   ```bash
         # 说明：
            # linux系统下会有一个hash表，当你刚开机时这个hash表为空，每当你执行过一条命令时，hash表会记录下这条命令的路径，就相当于缓存一样。第一次执行命令shell解释器默认的会从PATH路径下寻找该命令的路径，当你第二次使用该命令时，shell解释器首先会查看hash表，没有该命令才会去PATH路径下寻找
            # hash表的作用： 大大提高命令的调用速率
            -l  			# 显示hash表内容
            -r				#  清除hash表
            -d openssl 			#删除表中某一条（删除openssl）
            -t openssl			#  查看openssl命令路径（hash表中没有的话，可以调用which命令）
            -p /usr/bin/openssl aliesopenssl		# 往hash表中添加一条，执行aliesopenssl即执行openssl命令（起别名）
            
            *  注意：hash命令默认在centos中有，Ubuntu没有   
        ```

*   打开关闭交换空间，`swapon` `swapoff`

*   挂载卸载设备

    *   ```bash
        #  查看当前已挂载的设备
        mount
        cat /etc/mtab
        cat /proc/mounts
        
        #  挂载设备
        mount -o loop /PATH/TO/DIR MOUNT_POINT # 挂在本地回环设备，-o指定挂载选项，其中有sync、nosync、atime、noatime、diratime、nodiratime、remont(常用，无需卸载)
        mount -r /dev/cdrom MOUNT_POINT # 挂载只读光盘文件
        
        #  将一个目录绑定至另一个目录
        mount -bind SOURCE_DIR DISTIN_DIR
        
        # 卸载设备
        #  查看设备被那些进程所占用
        lsof MOUNT_POINT
        fuser -v MOUNT_POINT
        fuser -km MOUNT_POINT  #  强行终止正在访问某挂载点的进程 
        ```
    
*   `systemctl`命令

    *   ```bash
        systemctl try-restart NAME.service		# CentOS7条件式重启服务（即当服务运行的时候才会执行重启操作，否则不执行），在CentOS6使用condrestart
        systemctl reload-or-restart NAME.service			# 重载或者重启服务
        systemctl reload-or-try-restart NAME.service			# 重载或者条件式重启服务
        
        systemctl is-active NAME.service			# 查看某服务是否激活与否
        systemctl list-units --type service			# 查看所有已激活的服务
        systemctl list-units -t service -all			# 查看系统上所有的服务，在CentOS6上使用的是chkconfig --list
        systemctl mask|unmask NAME.service			# 允许或者禁止某服务开机启动
        ```

---

#  更新yum源(CentOS 6/7)

* ```bash
  # 下载repo源，建议选择国内源(163，aliyun)
  wget .../*.repo
  # 备份原来的基础源
  mv /etc/yum.repo.d/*.Base.repo *.bak
  # 替换源
  mv ...
  # 执行yum源的更新
  yum clean all	# 清除yum缓存
  yum makeclean	# 重建yum缓存
  yum update
  ```

* ```bash
  # 增加epel源
  wget https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
  rpm -ivh ... # 安装rpm
  # 安装yum-priorities源优先级工具
  yum install yum-priorities
  ```

##  RHEL系后端包管理工具rpm的使用

* >安装：
  >
  >​	rpm -ivh(-i 安装包 -v verbose详细信息 -h hash值来表示进度条每一个#代表2%)PackageName
  >
  >​	--nodeps 忽略依赖性检查	--replacepkgs 重新安装
  >
  >卸载：
  >
  >​	rpm -e(erase) PackageName
  >
  >​	--nodeps
  >
  >升级：
  >
  >​	rpm -Uvh、-Fvh 前者如果之前未安装过则会直接安装该包，后者则不会
  >
  >查询：
  >
  >​	rpm -qa 、-qf、-qi、-qc、-q --scripts(安装之前preinstall安装之后postinstall卸载之前preuninstall卸载之后postuninstall的脚本信息)、-q provides(该包安装后会提供那些服务或者工具)、-q --requires(查询包安装依赖)
  >
  >校验：
  >
  >​	rpm -V
  >
  >	*	导入GPG秘钥文件：rpm --import GPG秘钥文件 
  >	*	rpm -K 用于手动检查包的来源安全性和文件完成性信息，可选选项--nodigest(不检查完整性)--nosignature(不检查来源安全性签名)
  >
  >数据库重建：
  >
  >​	rpm --initdb、--rebuilddb

---



*   `ntsysv`命令：图形化显示所要启动的服务，RHEL系

*   修改`/etc/init/start-ttys.conf`关闭不必要的tty，修改这个位置，即可关闭不必要的tty

  `env ACTIVE_CONSOLES=/dev/tty[1-6]  `

*   `echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf`可以加强对抗syn flood的能力，使用`sysctl -p`生效

* 修改history的记录数量，使用source /etc/profile即可生效

*   安装ntp ，为用户加入`crontab (-e)计划/usr/sbin/ntpdate ntp.api.bz`，可以使用`dig ntp.api.bz `来查看(dig在centos中所属bind-tools包)







