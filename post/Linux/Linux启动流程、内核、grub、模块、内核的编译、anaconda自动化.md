# Linux启动流程

>POST --> Boot Sequence --> bootloader(MBR) --> Kernel --> 加载rootfs --> switchroot --> /sbin/init --> (配置文件：/etc/inittab, /etc/init/\*.conf) --> 根据init配置文件设置默认运行级别 --> 运行系统初始化脚本/etc/rc.d/rc.sysinit，完成系统初始化 --> 开启或关闭用户选定的对应运行级别下所对应的服务 --> 启动终端，打印登录提示符

* 1. POST：**检测各个硬件设备是否存在而且能够正常运行起来**，实现这一自检功能的是主板上
     `CMOS`芯片上的`BIOS`，主要机器一通电，CPU就会自动加载该系统，从而实现硬件的初始化.

* 2. Boot Sequence：**选择要启动的硬件设备以加载MBR**，然后读取该设备MBR里的`bootloader`，该顺序可以在`BIOS`中的`boot`选项卡中设置.

* 3. bootloader(MBR)：提供一个可视化菜单给用户，让用户去**选择要启动的系统或不同的系统内核版本**，然后把用户选择的内核版本加载至RAM中的特定空间，接着在RAM中解压、展开，而后把系统控制权移交给内核.

  * `grub`是`bootloader`中的一种，此外还有`LILO`，此处将对grub进行说明

    * `grub 0.x`又称为`grub legacy`，而`grub 1.x`被称为`grub2`.

    * 为了打破MBR中只有**446Bytes**用于存放bootloader这一限制，grub是通过三个阶段来实现加载内核的.

      >**stage1：**存放于MBR的前446Bytes，用于加载stage1.5阶段，目的是为了**识别并驱动stage2(或者/boot)所在分区的文件系统**；
      >
      >**stage1.5：**存放于MBR之后的扇区，加载stage2所在分区的**文件系统驱动**，让stage1中的bootloader能识别stage2所在分区的文件系统；
      >
      >**stage2：**存放于磁盘分区之上，具体存放于/boot/grub目录之下，主要用于加载内核文件(vmlinuz-VERSION-RELEASE)以及ramdisk这个临时根文件系统(centos5,6中的initrd-VERSION-RELEASE.img或centos7中的initramfs-VERSION-RELEASE.img).

    * grub功能及用途

        >（1）提供菜单并提供交互式接口
        >
        >​		e：编辑模式				c：命令行模式（cli）
        >
        >（2）加载用户选择的操作系统或者内核，允许传递参数给内核，允许隐藏菜单
        >
        >（3）为菜单提供保护机制，为编辑菜单提供保护机制，为启用内核或者操作系统提供认证
      
    * grub的配置文件目录`/boot/grub/grub.conf`链接文件`/etc/grub.conf` -> ../boot/grub/grub.conf
    
        > 配置项参数：
        >
        > ​	default=[index]：设定默认启动的菜单项，菜单项从0开始编号
        >
        > ​	timeout=[num]：设定菜单项等待选择的时间，单位为秒
        >
        > ​	splashimage=`(hd0,0)/grub/splash.xpm.gz`：设定菜单的背景图片，格式较为特殊
        >
        > ​	hiddenmenu：隐藏菜单
        >
        > ​	password [--md5] STRING：菜单编辑认证
        >
        > ​			该md5值可以使用`grub-md5-crypt`命令生成
        >
        > ​	title TITLE：自定义菜单项的标题
        >
        > ​			root (hd#,#)：grub查找stage2以及Kernel文件所在的设备分区
        >
        > ​			kernel /PATH/TO/VMLINUXZ [parameters]：所要启动的内核
        >
        > ​					常用参数：ro（只读方式），root=UUID=xxx（指明/sbin/init所在分区信息），quite
        >
        > ​			initrd /PATH/TO/INITRAMFS：内核所匹配的ramfs文件
        >
        > ​			password [--md5] STRIN：为所要启动的系统或者内核提供认证
        >
        > 手动在grub命令行接口启动服务：
        >
        > ​		grub >  root (hd#,#)
        >
        > ​		grub > kernel /vmlinuz-VERSION-release ro root=/dev/DEVICE
        >
        > ​		grub > initrf /initramfs-VERSION-relaese.img
        >
        > ​		grub > boot
    
    * grub其他
    
        >进入单用户模式：
        >
        >（1）编辑grub菜单（选定要编辑的菜单，然后使用e命令）
        >
        >（2）选定Kernel后附加 1，s，S或者single都可以
        >
        >（3）最后在Kernel所在行，使用b命令
        >
        >*** grub的安装/修复：
        >
        >（1）grub-install，`grub-install --root-directory=ROOT /dev/DISK`
        >
        >（2）grub命令行(按下ESC键进入)：
        >
        >​		grub > root (hd#,#)
        >
        >​		grub > setup (hd#)
        >
        >（3）载入安装光盘，进入救援模式（boot: `linux rescue`）或者直接选定，类似于winpe
        >
        >```bash
        ># 切换根
        >chroot /mnt/sysimage
        ># 执行grub-install命令
        >grub-install --root-directory=/ /dev/sda
        ># 退出重启即可
        >```
        >
        >* 练习时破坏bootloader分区使用的命令：`dd if=/dev/zero of=/dev/sda bs=200 count=1`,`sync`
    
    * `ramdisk`：**ramdisk是用于实现系统初始化的、基于内存的磁盘设备，即加载至内存的某一段空间后把内存当磁盘**使用，并在内存中作为临时根文件系统提供给内核使用，帮助内核挂载真正的根文件系统。而之所以能够帮助内核挂载根文件系统是因为在ramdisk这个临时文件系统的`/lib/modules`目录下有真正的根文件系统所在设备的驱动程序.
    
      * ramdisk文件的管理
    
         >（1）mkinitrd命令，为当前内核重新制作remdisk文件
          >
          >```bash
          >options：  [--preload <module>]  # initramfs所提供要预先装载的模块.
          >   [--with=<module>] # 除了默认的模块还需要装载的模块. 
          >   <initrd-image> <kernel-version>
          >```
          >例子：`mkinitrd /boot/initramfs-${uname -r }.img ${uname -r}`
          >
          >（2）dracut命令
          >
          >例子：`dracut /boot/initramfs-${uname -r}.img ${uname -r}`
  
4. Kernel：**Kernel自身初始化**，其主要作用有：

   1. 探测可识别到的所有硬件设备**bootloader将系统控制权移交给内核，探测bootloader留下的资源等
   2. 加载硬件驱动程序，即加载真正的根文件系统所在设备的驱动程序（*有可能*会借助于ramdisk加载驱动）**内核探测出各项资源后，开启或关闭一些进程
   3. 以只读方式挂载根文件系统；**如果有借助于ramdisk这个临时文件系统（虚根），则在这一步之后会执行根切换，否则不执行根切换
   4. 运行用户空间的第一个应用程序：/sbin/init.**到这里`内核空间`的的启动流程就结束了，而接下来是`用户空间`完成后续的系统启动流程

5. /sbin/init(用户空间的第一个程序)：虽然CentOS 5、CentOS 6以及CentOS 7的init配置 文件各不相同，一般配置文件：/etc/inittab, /etc/init/\*.conf) ，但总体的启动流程是不变的.

  * 根据init的配置文件设置默认运行级别

    * >CentOS 5：初始化程序init是`SysV init`，其配置文件为：`/etc/inittab`
      >
      >CentOS 6：初始化程序init是`upstart`（模仿Ubuntu启动程序），其配置文件为：`/etc/inittab， /etc/init/*.conf`，也就是upstart将配置文件拆分成多个，在/etc/init/目录下以conf结尾的都是upstart风格的配置文件，而/etc/inittab仅用于设置默认运行级别
      >
      >​				`*.conf`文件为upstart风格的配置文件，`rcS.conf`,`rc.conf`,`start.ttys.conf`
      >
      >*CentOS 7：*初始化程序init是`systemd`，其配置文件为：`/usr/lib/system/systemd/, /etc/systemd/system/*`

  * 运行级别（0-6）

    * >​     0：关机模式，shutdown，对应`poweroff.target`
      >
      >​     1：单用户模式(single user)：不需要通过认证，登录进去之后为root用户身份，属于维护模式，对应`rescue.target`
      >
      >​     2：多用户模式(multi user)：会启动网络功能，但不会启动NFS，是维护模式，对应`multi-user.target`
      >
      >​     3：多用户模式(multi user)：为完全功能模式，提供文本界面（minimal install default），对应`multi-user.target`
      >
      >​     4：预留级别，目前无特别使用目的，但习惯上以同3级别功能来使用，对应`multi-user.target`
      >
      >​     5：多用户模式(multi user)：为完全功能模式，提供图形界面，对应`graphical.target`
      >
      >​     6：重启模式，reboot，对应`reboot.target`
      >
      >---
      >
      >获取当前运行级别：`runlevel`或者`who -r`
      >
      >级别之间的切换：`systemctl isolate TYPE.target`或者`init RUNLEVEL`
      >
      >查看当前系统所有运行级别：`systemctl list-units -t target -a`
      >
      >获取系统默认运行级别：`systemctl get-default`
      >
      >修改当前系统默认运行级别：`systemctl set-default TYPE.target`
      >
      >切换紧急救援模式：`systemctl rescue`
      >
      >切换emergency模式：`systemctl emergency`
      >
      >其他常用命令：
      >
      >​			关机：`systemctl poweroff`或者`systemctl halt`
      >
      >​			挂起：`systemctl suspend`
      >
      >​			快照：`systemctl hibernate`
      >
      >​			挂起并快照：`systemctl hybrid-sleep`

* 补充

  * `/etc/inittab`文件

    * >对于CentOS5/6：
      >
      >```
      >每行定义一种action以及与之对应的process：
      >格式：id:runlevel:action:process
      >各字段解释：
      >    id：一个任务的标识符；
      >    runlevel：在哪些级别下启动该任务；格式可以是#,###,也可以为空(表示所有级别)；
      >    action：在什么条件下启动该任务；
      >    process：任务command； 
      >```
      >
      >```
      >action种类：
      >    wait：等待切换至该任务所在的级别时执行一次；
      >    respawn：一旦该任务终止，就会重新启动这个任务；
      >    initdefault：设定默认运行级别；此时process是省略掉的；
      >    sysinit：设定系统初始化方式，这里一般指定为/etc/rc.d/rc.sysinit脚本文件；
      >```
      >
      >例如： `id:3:initdefault:    `//设置默认运行级别，此处设置为3；
      >
      >注意：
      >
      >CentOS 7使用target代替了runlevel，也就是在CentOS 7系列已经没有了运行等级这一概念了。而如果需要设置target则可参考该文件的后两行注释，详情见`/etc/inittab`文件
    
  * 运行系统初始化脚本`/etc/rc.d/rc.sysinit`，完成系统初始化
  
    * > CentOS5/6
      >
      > ​    ①设置主机名；
      >
      > ​    ②设置欢迎信息；
      >
      > ​    ③激活udev和selinux；
      >
      > ​    ④挂载/etc/fstab文件中定义的所有文件系统；
      >
      > ​    ⑤检测根文件系统，以读写方式重新挂载根文件系统；
      >
      > ​    ⑥设置系统时钟；
      >
      > ​    ⑦根据/etc/sysctl.conf文件来设置内核参数；
      >
      > ​    ⑧激活lvm及软raid设备；
      >
      > ​    ⑨激活swap设备；
      >
      > ​    ⑩加载额外设备的驱动程序（因为内核只加载根文件系统所在分区的驱动程序）；
      >
      > ​    ⑪清理操作；
      >
      > 注意：
      >
      > CentOS7中无，欢迎信息文件为`/etc/issue`，文件内容详解https://www.cnblogs.com/cnjavahome/p/8476462.html

---

#  Linux内核

>内核设计体系：单内核和微内核
>
>linux采用的是单内核设计，但其充分借鉴了微内核体系设计的优点，为内核引入了`模块化机制`.
>
>​	内核的组成部分：
>
>​			Kernel：内核核心部分，一般为bzimage压缩镜像格式，位于`/boot`目录，其名称为`vmlinuz-VERSION-release`
>
>​			Kernel object(*.ko文件)：内核对象，即内核模块，一般位于`/lib/modules/VERSION-release`
>
>​			ramdisk文件：CentOS5：`/boot/initrd-VERSION-release`，CentOS6：`/boot/initramfs-VERSION-release`
>
>​	编译内核所用到的标识：
>
>​			[ ]：N
>
>​			<M>：Module
>
>​			[*]：Y 编译进内核			

* 内核信息的获取，使用命令`uname -r`

* 内核模块查看命令：`lsmod`（显示信息来源于`/proc/module`），`modinfo`（例：modinfo [-F] [-n] ipt_REJECT）

* 内核模块的动态装卸载：

  * `modprobe [-r] module_name`，选项`-r`代表卸载模块
  * `insmod [filename] [module options]...`，`filename`表示模块文件的路径；`rmmod [module_name]`，卸载.

* `ldd`命令：ldd [OPTION]... FILE... 打印二进制程序文件的依赖模块
  
  * 使用`ldd [二进制可运行文件绝对路径] | grep -o "/lib[^[:space:]]*"`可以快速查看依赖模块的路径
  
* 内核的简单编译流程：

  * >（1）获取目标主机上硬件设备的相关信息
    >
    >```bash
    ># CPU有关信息
    >cat /proc/info
    >lscpu
    >x86info -a		 # 详细
    ># PCI设备
    >lspci			lsusb			lsblk			
    ># 获取所有硬件设备信息
    >hal-device
    >```
    >
    >（2）根据平台去官网https://www.kernel.org/下载适合的内核
    >
    >（3）准备编译环境，所需包组`Development Tools`，`Server Platform Development`，可能还需要`ncurses-devel`，如需使用窗口界面进行内核编译，还需要`Desktop Platform Development`包组
    >
    >（4）解压内核至`/usr/src`目录，并创建一个软连接`ln -sv linux`
    >
    >（5）配置内核选项，使用tui来配置`make menuconfig`
    >
    >（6）编译，`make [-j #]`，其中#代表线程数，设置该参数可以进行多线程编译
    >
    >> 几种编译模式：
    >>
    >> **支持以更新模式进行配置：在已有的.config文件基础上进行修改配置**
    >>
    >> （a）`make config`：基于命令行遍历的方式去配置内核中的每个选项
    >>
    >> （b）`make menuconfig` ： 基于`cureses`的文本配置窗口
    >>
    >> （c）`make gconfig`：基于`GTK`开发环境的窗口界面，所属包组`桌面平台开发`
    >>
    >> （d）`make xcongfig`：基于`QT`开发环境的窗口界面
    >>
    >> **支持全新配置模式进行配置：**
    >>
    >> （e）`make defconfig`：基于内核为目标平台提供的默认配置进行配置
    >>
    >> （f）`make allnoconfig`：所有选项均不选中
    >>
    >> ------
    >>
    >> 部分编译：
    >>
    >> （1）只编译子目录中的相关代码
    >>
    >> ```bash
    >> cd /usr/src/linux
    >> make PATH/TO/DIR
    >> ```
    >>
    >> （2）只编译某个特定的模块
    >>
    >> ```bash
    >> cd /usr/src/linux
    >> make PATH/TO/DIR/file.ko
    >> ```
    >
    >（7）`make modules_install`，安装内核模块
    >
    >（8）`make install`，安装内核
  
* 内核信息输出的伪文件系统

  * >`/proc `内核信息和统计信息的输出接口，其配置接口为`/proc/sys`
    >
    >>在`/proc/sys`目录中
    >>
    >>​				`net/ipv4/ip_forward`相当于`net.ipv4.ip_forward`
    >
    >参数设置方式：
    >
    >（1）`sysctl`命令：用于查看/proc/sys目录下的参数的值
    >
    >​						查看所有内核参数：`sysctl -a`
    >
    >​						查看单个内核参数：`sysctl VARIABLE`
    >
    >​						修改：`sysctl -w VARIABLE=value`
    >
    >（2）使用文件系统相关命令，`cat`和`echo`
    >
    >​						查看：`cat /proc/sys/PATH/TO/FILE`
    >
    >​						修改：`echo "value" > /proc/sys/PATH/TO/FILE`
    >
    >**注意：**以上两种方式均为当前运行内核有效，重启后无效
    >
    >（3）修改配置文件使其永久有效`/etc/sysctl.conf`和`/etc/sysctl.d/*.conf`
    >
    >​						立即生效的方式：`sysctl -p /PATH/TO/CONF_FILE`

# anaconda自动化安装脚本

---

* CentOS系统安装流程（所使用的安装程序：`anaconda`）：

  * >概括流程：
    >
      >BootLoader --> kernel(initrd(rootfs)) --> anaconda(有tui和gui配置窗口)
      >
      >MBR：`boot.cat`文件
      >
      >Stage2：isolinux/isolinux.bin
      >
      >​			配置文件：isolinux/isolinux.cfg
      >
      >每个对应菜单选项：
      >
      >​			加载内核：isolinux/vmlinuz
      >
      >​			向内核传递参数：append initrd=initrd.img
      >
      >装载根文件系统，并启动anaconda
      >
      >安装阶段：
      >
      >​			对目标磁盘进行分区和格式化操作
      >
      >​			将指定的软件包安装至目标位置
      >
      >​			安装bootloader
      >
      >首次启动：
      >
      >​			iptables
      >
      >​			selinux
      >
      >​			core dump
  
* 安装引导选项（1）：

  * >`text`：将以文本方式进行安装
    >
    >`method`：手动指定安装的方法
    >
    >​			与网络相关的引导选项：`ip`，`netmask`，`gateway`，`dns`
    >
    >例如：
    >
    >```bash
    >linux method ip=192.168.1.43 netmask=255.255.255.0 gateway=192.168.1.1 dns=192.168.1.1
    >```
    >
    >​			远程访问功能相关配置：`vnc`和`vncpassword=YOUR_VNC_PASSWORD`
    >
    >`rescue`：启用紧急救援模式

* 一般使用ISO光盘镜像安装的系统会在用户根目录生成一个名为`anaconda-ks.cfg`的文件，该文件即为kickstart文件

* 安装引导选项（2）：

  * >`ks`：指明kickstart文件的位置
    >
    >>ks=
    >>
    >>​			DVD drirve：ks=cdrom:/PATH/TO/KICKSART_FILE
    >>
    >>​			此外还支持`hard driver`，`http server`，`FTP server`和`nfs server`等
    >
    >`kickstart`文件的参数及格式（详情参见https://anaconda-installer.readthedocs.io/en/latest/index.html）：
    >
    >>（1）命令段：指定各种安装前的配置选项，如键盘类型，语言编码等...
    >>
    >>（2）程序包段：指明要安装的程序包，包组，和一些不需要安装的程序包
    >>
    >>```bash
    >>%package		# start
    >>@group_name		# 包组
    >>package			# 所要安装的包
    >>-package		# 不需要安装的包
    >>%end		# end
    >>```
    >>
    >>（3）脚本段：
    >>
    >>​				`%pre`：安装前所要运行的脚本
    >>
    >>​				`%post`：安装后所要运行的脚本
    >>
    >>---
    >>
    >>其他参见`anaconda-kick部分参数.txt`文件

* 最后使用`ksvalidatorfilename`来检查语法错误

*  **通过网络http服务器中kickstart文件安装**

   *  >（1）挂载光盘镜像，开进进入安装界面
      >
      >（2）按下ESC键进入boot命令行，输入以下命令：
      >
      >```bash
      >linux ip=192.168.1.231 netmask=255.255.255.0 gateway=192.168.1.1 ks=https://192.168.1.1/centos6.x86_64.cfg
      >```
      >
      >即可

* **通过光盘镜像进行引导安装**

  * >（1）挂载光盘，将光盘根目录下的`isolinux`文件复制出来
    >
    >（2）将复制出来的`isolinux`文件夹内的所有文件授予写权限
    >
    >```bash
    >cd isolinux/
    >chmod +w *
    >```
    >
    >（3）将准备好的`anaconda-ks.cfg`文件放在与`isolinux`文件夹同级的目录之下
    >
    >（4）制作光盘镜像
    >
    >```bash
    > mkisofs -R -J -T -v --no-emul-boot --boot-load-size 4 --boot-info-table -V "CentOS 6 x86_64 boot" -c isolinux/boot.cat -b isolinux/isolinux.bin -o  /root/boot.iso   myboot/		# 输出文件boot.iso，isolinux和ks文件置于myboot目录下
    >```
    >
    >（5）打开目标机器并挂载上一步输出的`boot.iso`文件，按下tab键输入以下内容：
    >
    >```bash
    >vmlinuz initrd=initrd.img ks=cdrom:/anaconda-ks.cfg ip=YOUR_IP netmask=YOUR_NETMASK
    >```
    >
    >或者直接修改`isolinux`目录下的`isolinux.cfg`文件，避免手动输入ks仓库地址
    >
    >```shell
    >append initrd=initrd.img ks=cdrom:/anaconda-ks.cfg
    >```
    >
    >然后重新使用第四步中的命令重新生成iso镜像文件即可

# 小练习

---

* 自行创建一个Linux引导系统，并且能够使用

  * >（1）增加一块目标硬盘(虚拟硬盘)
    >
    >（2）进行分区和格式化操作
    >
    >```bash
    >fdisk /dev/sdb
    ># 创建三个分区，依次是boot，swap和根分区
    >kpartx /dev/sdb		# 强制让内核重读分区
    ># 格式化分区
    >mke2fs -t ext4 /dev/sdb1 		# 同理/dev/sdb3
    >mkswap /dev/sdb2 		# 格式化swap分区
    >```
    >
    >（3）分别挂载sdb1和sdb3至`/mnt/boot`和`/mnt/sysroot`
    >
    >（4）在boot目录下安装grub
    >
    >```bash
    >grub-install --root-directory=/mnt /dev/sdb
    >```
    >
    >（5）拷贝vmlinuxz文件和initramfs文件到boot目录
    >
    >```bash
    > cp /boot/vmlinuz-2.6.32-754.el6.x86_64 ../vmlinuz
    >  cp /boot/initramfs-2.6.32-754.el6.x86_64.img initramfs.img
    >```
    >
    >（6）编辑`/grub/grub.conf`文件，内容如下：
    >
    >```shell
    >default=0
    >timeout=5
    >title CentOS6_TEST
    >	root (hd0,0)
    >	kernel /vmlinuz ro root=/dev/sda3 selinux=0 init=/bin/bash 		# 原内核中的seLinux应该先取消
    >	initrd /initramfs.img
    >```
    >
    >（7）为sysroot创建linux文件目录
    >
    >```bash
    >mkdir -pv etc bin sbin lib lib64 dev proc tmp var usr home root sys media mnt
    >```
    >
    >（8）使用ldd命令放入必要二进制文件
    >
    >```bash
    >ldd /bin/bash | grep -o "/lib[^[:space:]]*"
    >cp ××× {相应目录下}
    ># 使用chroot测试
    >```
    >
    >（9）重新装载到目标机器即可使用


