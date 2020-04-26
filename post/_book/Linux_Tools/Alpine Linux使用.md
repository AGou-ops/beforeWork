# Alpine Linux使用

>官方站点：https://www.alpinelinux.org/

Alpine Linux 是一个社区开发的面向安全应用的轻量级Linux发行版，适合用来做Docker镜像、路由器、防火墙、VPNs、VoIP 盒子 以及服务器的操作系统，基于 uClibc 和 Busybox

## 下载与安装

官方下载站点：https://www.alpinelinux.org/downloads

提供有：STANDARD、EXTENDED、NETBOOT、MINI ROOT FILESYSTEM、VIRTUAL、XEN、RASPBERRY PI和GENERIC ARM版，找一个适合自己的就可以.

1. 虚拟机中安装

创建一个新的虚拟机，载入ISO镜像文件，然后启动进入安装界面，安装界面大致如下（来源于网络）

![](https://upload-images.jianshu.io/upload_images/3275724-9863177794cbaa4c?imageMogr2/auto-orient/strip|imageView2/2/w/736/format/webp)

使用`setup-alpine`命令来安装系统.

然后如果没有特殊需求的话，傻瓜式回车就行了，到格式化磁盘这个位置，使用`sda`/`sys`即可

![](https://upload-images.jianshu.io/upload_images/3275724-db3e28d92328566f?imageMogr2/auto-orient/strip|imageView2/2/w/739/format/webp)

安装完后重启`reboot`即可

## apk包管理

### 镜像源配置

官方镜像源列表：http://dl-cdn.alpinelinux.org/alpine/MIRRORS.txt

国内镜像源：

* 清华TUNA镜像源：https://mirror.tuna.tsinghua.edu.cn/alpine/

* 中科大镜像源：http://mirrors.ustc.edu.cn/alpine/

* 阿里云镜像源：http://mirrors.aliyun.com/alpine/

配置镜像源：

```bash
vi  /etc/apk/repositories
####
# 添加阿里云镜像源
http://mirrors.aliyun.com/alpine/v3.10/main/
http://mirrors.aliyun.com/alpine/v3.10/community/
# 原来的官方镜像源
http://dl-cdn.alpinelinux.org/alpine/v3.10/main
http://dl-cdn.alpinelinux.org/alpine/v3.10/community
####
```

### 基本使用

* `apk update`：更新镜像源列表
* `apk search`：查找可用包

```bash
 apk search 			# 查找所以可用软件包
 apk search -v 			# 查找所以可用软件包及其描述内容
 apk search -v 'openssh*' 			# 通过软件包名称查找软件包
 apk search -v -d 'docker'		 # 通过描述文件查找特定的软件包
```

* `apk add <package_name>`：安装软件
* `apk info`：显示包信息

```bash
 apk info 			# 列出所有已安装的软件包
 apk info -a openssh			 # 显示完整的软件包信息
 apk info --who-owns /usr/bin/ssh			 # 显示指定文件属于的包
```

* `apk upgrade`：升级包

```bash
apk upgrade 			# 升级所有软件
 apk upgrade openssh 			# 升级指定软件
 apk upgrade openssh  vim 			  # 升级多个软件
 apk add --upgrade openssh 			# 指定升级部分软件包
```

* `apk del <package_name>`：卸载软件

## 服务管理

* `rc-update`：主要用于不同运行级增加或者删除服务

```bash
 rc-update add docker boot			 # 设置docker开机自启
 rc-update del docker boot			 # 删除docker开机自启
```

* `rc-status `：主要用于运行级的状态管理

```bash
 rc-status 				# 检查默认运行级别的状态
 rc-status -a			 # 检查所有运行级别的状态
```

* `rc-service`：主用于管理服务的状态

```bash
 rc-service docker start 			# 启动一个服务
 rc-service docker stop 			# 停止一个服务
 rc-service docker restart 			# 重启一个服务
```

## 运行级与关机重启

defaultAlpine Linux可用的运行级：

- sysinit
- boot
- single
- reboot
- shutdown

```bash
# 更改为single运行级别
openrc single
```

关机重启：

* 关机：`poweroff`
* 重启：`reboot