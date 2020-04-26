>**This is Linux状态信息 StudyNote.**

#  进程信息查看

## ps命令

>常用选项：
>
>1. `aux`：
>
>   参数`a`为所有与终端相关的进程，`x`为终端无关的进程，`u`为以用户为中心组织进程状态信息查看
>
>   结果列选项参数说明：
>
>   ​	`VSZ`：虚拟内存集
>
>   ​	`RSS`：常驻内存集
>
>   ​	`STAT`
>
>   ​			`R`：running
>
>   ​			`S`：可中断进程
>
>   ​			`D`：不可终端进程	
>
>   ​			`T`：stop
>
>   ​			`Z`：zombie
>
>     
>
>   ​			`+`：前台进程
>
>   ​			`I`：多线程进程
>
>   ​			`N`：低优先级进程
>
>   ​			`<`：高优先级进程
>
>   ​			`s`：session loader
>
>2. `-ef`
>
>   参数`-e`表示显示所有进程，`-f`表示显示详细进程信息
>
>3. `-eFH`
>
>   参数`-F`显示完整格式的进程信息（比`-f`选项多了`C`(CPU利用率)和`PSR`(进程运行于那个CPU之上)），`-H`以层级结构显示
>
>4. `-eo`
>
>   参数`-o`可以自定义要显示的字段列表，以逗号分隔

## pgrep和pkill命令()

>语法：`pgrep [options] pattern`
>
>参数：
>
>`-u UID`：有效的用户，列出指定用户UID下的进程pid
>
>`-t TERMINAL`：与指定终端相关的进程pid
>
>`-l`：显示出进程名称
>
>`-a`：显示出完整的进程名称
>
>`-P`：显示进程的子进程
>
>---
>
>`pkill`：根据进程名，取其pid

## kill和killall命令

>语法：kill [-s signal|-p] [-q sigval] [-a] [--] pid...
>
>常用信号及代码：
>
>​			1）SIGHUP：无需关闭进程而重读配置文件
>
>​			2）SIGINT：终止正在运行的程序，相当于Ctrl+C
>
>​			9）SIGKILL：杀死运行中的进程（强制，是操作系统从内核级别强制杀死一个进程）
>
>​			15）SIGTERM：（操作系统发送一个通知告诉应用主动关闭）
>
>​			18）SIGCONT：继续
>
>​			19）SIGSTOP：停止
>
>常用参数：
>
>​			`-l`：列出当前系统上可用的信号
>
>​			`-s`：可以使用信号名称来终止程序，允许简写和全称
>
>---
>
>killall：kill processes by name
>
>语法：killall [-s, --signal signal] name

## top命令

>1. 排序规则
>
>   `P`：以CPU的占用率来排序
>
>   `M`：以内存的占用率来排序
>
>   `T`：以积累占用CPU的时间来排序
>
>2. 首部信息
>
>   `l`：显示或隐藏启动时间（uptime）和`load average`（显示过去1min，5min，15min的平均负载）
>
>   `t`：显示或隐藏task和cpu的信息
>
>   `m`：显示或者隐藏内存有关信息
>
>3. 其他命令
>
>   `s`：修改刷新时间间隔
>
>   `k`：终止指定进程
>
>4. 启动选项
>
>   `-d`：指定刷新间隔，默认为3秒
>
>   `-b`：以批次方式显示
>
>   `-n #`：显示多少批次
>
>`h`：显示详细帮助

其他类似命令：`glances`（可以远程查看），`htop`（top的升级版本）

## pmap命令

>语法：pmap [options] PID [PID ...]    report memory map of a process
>
>常用参数：
>
>​			`-x`：以详细信息方式查看
>
>**补充**：另外一种查看方式：`cat /proc/PID/maps`

## dstat命令

dstat命令是一个用来替换vmstat、iostat、netstat、nfsstat和ifstat这些命令的工具，是一个全能系统信息统计工具

>**常用选项：**
>
>-c：显示CPU系统占用，用户占用，空闲，等待，中断，软件中断等信息
>-C：当有多个CPU时候，此参数可按需分别显示cpu状态，例：-C 0,1 是显示cpu0和cpu1的信息
>-d：显示磁盘读写数据大小
>-D hda,total：include hda and total
>-n：显示网络状态
>-N eth1,total：有多块网卡时，指定要显示的网卡
>-l：显示系统负载情况
>-m：显示内存使用情况
>-g：显示页面使用情况
>-p：显示进程状态
>-s：显示交换分区使用情况
>-S：类似D/N
>-r：I/O请求情况
>-y：系统状态
>--ipc：显示ipc消息队列，信号等信息
>--socket：用来显示tcp udp端口状态
>-a：此为默认选项，等同于-cdngy
>-v：等同于 -pmgdsc -D total
>--output 文件：此选项也比较有用，可以把状态信息以csv的格式重定向到指定的文件中，以便日后查看例：dstat --output /root/dstat.csv & 此时让程序默默的在后台运行并把结果输出到/root/dstat.csv文件中
>
>---
>
>较为详细信息参见：https://blog.csdn.net/sinat_34789167/article/details/80986709