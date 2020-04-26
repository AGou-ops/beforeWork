> **This is SElinux StudyNote.**

![SElinux工作原理](/home/suofeiya/myGitbook/images/selinux%E5%B7%A5%E4%BD%9C%E5%8E%9F%E7%90%86.png)

selinux 的全称是Security Enhance Linux，即为安全加强的Linux

# selinux状态查看与配置

* selinux的配置文件位置：`/etc/selinux/config`,它还有个链接在`/etc/sysconfig/selinux

* selinux三种状态：

  * >`enforcing`-是强制模式系统，它受selinux保护。就是违反了策略你就无法继续操作下去。
    >
    >`permissive`-是提示模式系统不会受到selinux保护，只是收到警告信息。permissive就是selinux有效，但是即使你违反了策略的话它让你继续操作，但是把你违反的内容记录下来（警告信息）
    >
    >`disabled`-禁用selinux

* 查询selinux工作状态：①`sestatus`显示有关详细信息②根据`selinuxenabled`命令回传值判断是否开启，0表示开启，1表示关闭（可以使用`echo $?`）③使用`getenforce`查看

* 变更selinux工作状态（临时）：`setenforce`命令设定selinux运行状态，1开启（Enforce），0关闭（Permissive），同时可以使用`getenforce`查看已修改的状态信息

#  查看文件安全上下文以及相关命令

* 查看文件上下文：`ls -lZ FILENAME`
* 查看进程上下文：`ps auxZ | grep PROGRESS`
* 查看用户上下文：`id -Z`

# SElinux日志查看及相关工具

* selinux的日志文件位置：`/var/log/audit/audit.log `

* >查看工具：
  >
  >1. `audit2why`和`audit2allow`：所属软件包为`policycoreutils-python.x86_64`
  >
  >使用方法：`audit2why </var/log/audit/audit.log`
  >
  >2. `setroubleshoot`：所属软件包为`setroubleshoot-server.x86_64`
  >
  >使用方法：`tail /var/log/messages  | grep  setroubleshoot`

# 解决SElinux资源类别错误导致文件无法访问(httpd)

* 根据日志记录的错误可以使用`sealert -l ERR_CODE`来查看详情

* 可以用sesearch【--allow】【-s 主体类别】【-t 目标类别】【-b】查询详细规则

  * sesearch命令由下列软件包提供`setools-console.x86_64`

  * >找出目标资源类别为httpd_sys_content_t的相关信息：`sesearch --allow -t httpd_sys_content_t`
    >
    >找出主体类别为httpd_t可以访问的那些资源相关信息：`sesearch -s httpd_t --allow`

* 修改文件上下文

  * 一种是通过restorerecon（ restore context) 修复继承当前目录默认的上下文；一种是通过chcon(change context) 修改当前的上下文

    * >（1）使用restorerecon（ restore context) 修复继承当前目录默认的上下文
      >
      >分两步实现:
      >
      >​          首先为/var/www/html 这个目录下的所有文件添加默认标签类型：
      >
      >`semanage fcontext  -a  -thttpd_sys_content_t  '/var/www/html(/.*)?'`
      >
      >因为html目录的默认标签类型就是httpd_sys_content_t，所以此步可以省略
      >
      >​          然后用新的标签类型标注已有文件：
      >
      >`restorecon -Rv /var/www/html/`， 之后httpd就可以访问该目录下的文件了
      >
      >（2）使用chcon (change context) 修改当前的上下文
      >
      >`chcon -t httpd_sys_content_t /var/html/index.html`
      >
      >>其他`chcon`参数：
      >>
      >>  -t type 类型
      >>  -R recursive 递归
      >>  -u user 用户
      >>  -r role  角色
      >
      >或者使用`chcon --reference /var/html/hello.html /var/html/index.html`

# 查看修改有哪些SElinux布尔值

* 查看当前系统所有的布尔值：`getsebool -a`
* 修改某一个布尔值：`setsebool [-P] value on|off`，其中`-P`表示永久有效