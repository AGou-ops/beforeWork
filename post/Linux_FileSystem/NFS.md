>NFS：网络文件系统，英文Network File System(NFS)，是由SUN公司研制的UNIX表示层协议(pressentation layer protocol)，能使使用者访问网络上别处的文件就像在使用自己的计算机一样。NFS是基于`UDP/IP`协议的应用，其实现主要是采用远程过程调用`RPC`机制。
>
>拓展：VFS

# NFS安装方法及相关文件

## NFS的安装与启动配置

```bash
yum install -y nfs-utils
yum install -y rpcbind			# 默认已安装

systemctl start nfs-server nfs-secure-server 			#  nfs-secure-server 为nfs安全传输服务
firewall-cmd --permanent --add-service=nfs			# 配置防火墙放行nfs服务
firewall-cmd  --reload 				# 使其生效
```

安装NFS服务，需要安装两个软件，分别是：

* RPC主程序：`rpcbind`，NFS 其实可以被视为一个 RPC 服务，因为启动任何一个 RPC 服务之前，我们都需要做好 port 的对应 (mapping) 的工作才行，这个工作其实就是『 rpcbind 』这个服务所负责的！也就是说， 在启动任何一个 RPC 服务之前，我们都需要启动 rpcbind 才行！ (在 CentOS 5.x 以前这个软件称为 portmap，在 CentOS 6.x 之后才称为 rpcbind 的！)。

* NFS主程序：`nfs-utils`，就是提供 rpc.nfsd 及 rpc.mountd 这两个 NFS daemons 与其他相关 documents 与说明文件、执行文件等的软件！这个就是 NFS 服务所需要的主要软件。

## NFS的相关文件：

* 主要配置文件：`/etc/exports`，这是 NFS 的主要配置文件了。该文件是空白的，有的系统可能不存在这个文件，主要手动建立。
* NFS 文件系统维护指令：`/usr/sbin/exportfs`，这个是维护 NFS 分享资源的指令，可以利用这个指令重新分享` /etc/exports` 变更的目录资源、将 NFS Server 分享的目录卸除或重新分享。
* 分享资源的登录档：`/var/lib/nfs/*tab，`在 NFS 服务器的登录文件都放置到 /var/lib/nfs/ 目录里面，在该目录下有两个比较重要的登录档， 一个是 etab ，主要记录了 NFS 所分享出来的目录的完整权限设定值；另一个 xtab 则记录曾经链接到此 NFS 服务器的相关客户端数据。
* 客户端查询服务器分享资源的指令：`/usr/sbin/showmount`，这是另一个重要的 NFS 指令。exportfs 是用在 NFS Server 端，而 showmount 则主要用在 Client 端。showmount 可以用来察看 NFS 分享出来的目录资源。

# NFS使用与配置

## NFS的简单使用

服务器端：

```bash
# 创建nfs共享目录
mkdir -pv /data/nfs
# 编辑配置文件`/etc/exports`
####
/data/nfs  172.16.122.0/24(rw)
####
# 重载nfs服务，使配置生效
systemctl reload nfs

# 显示server端挂载文件资源的情况NFS挂载的情况
showmount -a 	
---
* exportfs命令参数:
		-r：重新导出
		-a：所有文件系统
		-v：详细信息
		-u：取消导出文件系统
```

客户端：

```bash
# 需提前安装nfs-utils或者nfs-common(Debian系)
apt install -y nfs-common

# 查看服务器端可用的nfs
showmount -e 172.16.122.133(rw,no_squash) 192.168.0.0/24(ro,root_squash)
# 1. 挂载到本地使用
mount -t nfs 172.16.122.133:/data/nfs /mnt/nfs
# 或者使用
mount.nfs 172.16.122.133:/data/nfs /mnt/nfs

# 2. 使用系统自动挂载的方式
# 编辑`/etc/fstab`，添加以下内容
####
172.16.122.133:/data/nfs  /mnt/nfs       nfs    defaults 0 0
####
mount -a 			# 使fstab生效
```

Windows客户端在   **控制面板–>添加程序和功能–>添加NFS客户端组件**  即可使用.

## NFS配置参数

用于配置NFS服务程序配置文件的参数：

| 参数           | 作用                                                         |
| :------------- | ------------------------------------------------------------ |
| ro             | 只读                                                         |
| rw             | 读写                                                         |
| root_squash    | 当NFS客户端以root管理员访问时，映射为NFS服务器的匿名用户     |
| no_root_squash | 当NFS客户端以root管理员访问时，映射为NFS服务器的root管理员   |
| all_squash     | 无论NFS客户端使用什么账户访问，均映射为NFS服务器的匿名用户   |
| sync           | 同时将数据写入到内存与硬盘中，保证不丢失数据                 |
| async          | 优先将数据保存到内存，然后再写入硬盘；这样效率更高，但可能会丢失数据 |

- **需要特别注意的一点**：在NFS中的文件属组和属组是以`UID`与`GID`区分的，同一NFS工作目录在不同的系统中，显示的用户和组可能不同，这取决于当前用户和组的`ID`，如若该`UID`或者`GID`对应的用户和组不存在，则会直接显示为数字标识.
  	
  	
  	
  	
  	
  	