# sudo详解

## su用户切换

基本语法

```bash
su [options...] [-] [user [args...]]
# 直接执行su或者su - 不加其他参数，即表示切换用户至root
```

常用组合：

* `su -l USER_NAME`：其中`-l`(可以使用`-`或者`--login`代替使用)参数表示以登录的方式切换用户，也就是切换用户时会一并切换家目录环境变量等
* `su - USER_NAME -c "COMMAND"`：以该用户单次执行某一个命令

## sudo授权

能够让获得授权的用户以另外一个用户的身份运行指定的命令.

配置文件：`/etc/sudoers`，不建议直接编辑，推荐使用带有语法检测的`visudo`命令来编辑.

错误日志文件：`/var/log/secure`

sudo常用参数：

* `-l`：查看当前用户可以使用的权限
* `-k`：清除先前保存的密码
* `-b`：将所要执行的命令放在后台执行，但将输出结果打印到当前终端上
* `-u`：后面加username或者uid，表示以该用户的身份运行

### 简单配置

1. 让指定用户使用sudo运行指定命令

```bash
# 在配置文件中添加以下内容
####
suofeiya	ALL=(ALL)	/usr/sbin/visudo
####
```

2. 让指定用户组使用sudo运行指定命令

```shell
# 将用户添加到指定用户组
usermod -a -G test suofeiya		# -a(append)表示添加用户到组且不必离开以前的群组，不加-a参数则会使用户离开当前组，仅加入指定组
# 编辑配置文件
####
%test	ALL=(ALL)	ALL
####
```

注意事项：如果这样设置，则普通用户就可以通过`sudo su root`直接切换到root用户而无需输入root密码，所以需要如下设置来避免这种情况.

3. 让用户组或用户无法切换、修改root密码

```bash
# 编辑配置文件
####
%test	ALL=(ALL)	ALL, !/bin/su, !/usr/bin/passwd root
centos	ALL=(root)	/usr/bin/passwd [a-zA-Z]*,!/usr/bin/passwd root			# centos用户可以root的身份更改密码，但禁止更改root的密码
####
```

4. 让用户无需密码使用指定命令

```bash
# 编辑配置文件
####
suofeiya	ALL=(ALL)	NOPASSWD: /usr/sbin/useradd, PASSWD: /bin/su
####
```

5. 让普通用户suofeiya具有`/etc/init.d/network`脚本重启的权限

```bash
# 编辑配置文件
####
suofeiya	ALL=NOPASSWD:/etc/init.d/network restart
####
```

6. 让普通用户suofeiya具有`/etc/init.d/mysqld`和root家目录`test.sh`脚本的所有权限

```bash
# 编辑配置文件
####
suofeiya	ALL=(ALL)	/etc/init.d/mysqld, /root/test.sh
####
```

### 使用别名

```bash
# 编辑配置文件
####
User_Alias USERADMIN=suofeiya, %wheel		# 添加用户别名，该别名用于用户管理员组，用户可以指定多个，别名也可以指定多个
Cmnd_Alias USERCMD=/usr/sbin/visudo, /usr/bin/useradd
# 角色别名
Runas_Alias ROLE = root
USERADMIN	ALL=(ROLE)	USERCMD
####
```



