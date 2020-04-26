> This is Docker StudyNote.
# Docker 安装与daemon.json配置

docker RPM源：https://download.docker.com/linux/centos/7/x86_64/stable/Packages/

```bash
# 获取最新的docker
wget -qO- https://getdocker.com/ | sh
# 为普通用户添加docker使用权限,重新登录后生效
sudo usermod -aG docker [用户名称]
# 或者直接使用yum源来进行安装
yum install -y docker
```

docker镜像加速

```bash
# 为docker镜像加速
配置文件地址：/etc/docker/daemon.json
例如：
{
  "registry-mirrors": ["http://hub-mirrorc163com"]
}
```

docker远程管理

```bash
# docker默认情况下，只会生成一个 /var/run/docker.sock 文件来进行本地进程通信，而不会监听任何端口
# 方法一：
# 修改docker的配置文件 /etc/sysconfig/docker 中的 OPTIONS 参数
OPTIONS='... -H unix:///var/run/docker.sock -H 0.0.0.0:5555'

# 方法二：
# 修改/etc/docker/daemon.json文件，添加如下配置
"hosts": ["tcp://0.0.0.0:5555", "unix:///var/run/docker.sock"]

# 重启docker服务
sudo systemctl restart docker.service
# 在远程主机上测试是否成功
sudo docker -H <HOST>:5555 images
```

自定义docker0桥的网络属性信息

```shell
{
	...
"bip":"192.168.10.1/24",			# 初始化docker0桥的ip以及掩码信息，也就是创建新容器是将使用该设置
"dns":["192.168.10.254","223.5.5.5"],		#　初始化dns服务器地址，linux系统上最多可以设置三个dns服务器
"default-gateway": "192.168.1.1",			# 初始化默认的网关
}
```

`daemon.json`详细参数：https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file

# Docker基础

Docker namespace

![docker命名空间](https://s2.ax1x.com/2019/11/21/MIm12R.jpg)


docker `inspect`参数列表：

```bash
-f :指定返回值的模板文件，模板风格为`go`语言风格
# 例如：
`docker inspect -f {{.NetworkSettings.IPAddress}} CONTAINER_NAME`层级查找到容器的ip地址

-s :显示总的文件大小
--type :为指定类型返回JSON
```
 docker -event \(类似命令还有docker -logs\)参数列表：
```bash
-f ：根据条件过滤事件
--since ：从指定的时间戳后显示所有事件;
--until ：流水时间显示到指定的时间为止
 --tail : 仅列出最近几条的日志信息  
# 例子：
`docker -event -f "iamges"="hello-world" --since  "对应时间戳"`也可以直接使用时间
```

docker `run`参数：
```bash
`-h`：指定容器的主机名称
`--dns`：指定容器的dns服务器地址
`--dns-search`：dns服务的搜索域
`--add-host 域名:IP`：在容器hosts中添加
`--rm`：容器一旦运行结束即删除
`-e`：向容器中传递一个环境变量，例如：`docker run --name myweb01 --rm -P -e WEB_SERVER_VERSION="nginx-1.5.1" busybox printenv`
```

docker镜像的导入和导出：
```bash
`docker export `
`docker save -o ubuntu > ubuntu.tar`   `docker  load -i ubuntu.tar`
* save 、 load 和 export 、 import区别：
前者保存整个容器，可以单独使用，后者只保存容器层数据
```

`docker rename [原容器名称] [新容器名称]`
`docker rm [容器名称]` 删除一个容器，`docker rmi [镜像名称]`删除镜像
`docker rm -f强制删除 -v $\(docker ps -aq -f status=exited\)`删除所有已经退出的docker
`docker attach [容器id]`进入容器内部
`docker exec -it [短ID] bash`进入相关容器的bash，it参数代表以交互模式打开bash，也可以`docker exec [容器ID或者长短ID] [命令 如：ls /home]`


#  Docker使用第三方平台

以阿里云docker服务为例（来自官方文档）：

>##### 1. 登录阿里云Docker Registry
>
>```bash
> sudo docker login --username=15628960878 registry.cn-beijing.aliyuncs.com
>```
>
>用于登录的用户名为阿里云账号全名，密码为开通服务时设置的密码。
>
>您可以在访问凭证页面修改凭证密码。
>
>##### 2. 从Registry中拉取镜像
>
>```bash
> sudo docker pull registry.cn-beijing.aliyuncs.com/suofeiya/test:[镜像版本号]
>```
>
>##### 3. 将镜像推送到Registry
>
>```bash
> sudo docker login --username=15628960878 registry.cn-beijing.aliyuncs.com
> sudo docker tag [ImageId] registry.cn-beijing.aliyuncs.com/suofeiya/test:[镜像版本号]	#为容器打标
> sudo docker push registry.cn-beijing.aliyuncs.com/suofeiya/test:[镜像版本号]	# 上传镜像
>```
>
>请根据实际镜像信息替换示例中的[ImageId]和[镜像版本号]参数。
>
>##### 4. 选择合适的镜像仓库地址
>
>从ECS推送镜像时，可以选择使用镜像仓库内网地址。推送速度将得到提升并且将不会损耗您的公网流量。
>
>如果您使用的机器位于VPC网络，请使用 registry-vpc.cn-beijing.aliyuncs.com 作为Registry的域名登录，并作为镜像命名空间前缀。
>

#  Docker端口映射

## 创建容器时指定要暴露的端口

（1）暴露指定端口

```bash
docker run --name test -p80:80 busybox
```

​			暴露指定主机的指定端口

```bash
docker run --name test -p 192.168.1.252:80:80 busybox
```

（2）暴露随机端口

```bash
docker run --name test -p80 busybox
```

​			暴露指定主机的随机端口

```bash
docker run --name test -p 192.168.1.252::80 busybox
```

（3）自动检测容器的端口并进行随机暴露

```bash
docker run --name test -P busybox
```
## 容器运行时修改端口映射


（1）停止容器

（2）停止docker服务
```bash
systemctl stop docker
```

（3）修改这个容器的hostconfig.json文件中的端口（如果config.v2.json里面也记录了端口，也要修改）

```bash
cd /var/lib/docker/3b6ef264a040*
vi hostconfig.json
```
如果之前没有端口映射, 应该有这样的一段:

```bash
"PortBindings":{}
```
增加一个映射, 这样写:

```bash
"PortBindings":{"3306/tcp":[{"HostIp":"","HostPort":"3307"}]}
```
前一个数字是容器端口, 后一个是宿主机端口. 
而修改现有端口映射更简单, 把端口号改掉就行.

# Docker网络配置

## Docker默认的四种网络模式

### docker网络模式的查看
使用`docker network ls`来查看docker的网络模式有哪些，查看宿主机的网桥可以使用`brctl show`命令

```bash
[root@node1 ~] \#  docker network ls
NETWORK ID          NAME                DRIVER
7fca4eb8c647        bridge              bridge
9f904ee27bf5        none           	     null
cf03ee007fb4        host                     host
```

使用方法：使用`--network`来指定容器要使用那种网络模式（不指定则默认使用bridge模式来创建容器）

```bash
--net={host|bridge|none}
# ---
--net=container:NAME_OR_ID			# 使用容器共享网络
```


### 修改docker默认的网络设置

删除docker0桥原来的网络地址，并添加自定义的网络
```bash
 systemctl stop docker
 ip link set dev docker0 down
 ip addr del 172.17.42.1/24 dev docker0			# 删除docker0桥网络
 ip addr add 192.168.0.1/24 dev dcoker0
 ip link set dev docker0 up
```

编辑docker服务文件

```bash
# 备份原来的service文件
cp /lib/systemd/system/docker.service /etc/systemd/system/docker.service
# 修改docker服务文件
vim /etc/systemd/system/docker.service
# -----------
\# [Service]
Type=notify
ExecStart=/usr/bin/docker daemon -H fd:// --bip="192.168.0.1/24"
...
# -----------
```

重读服务配置文件并启动docker即可

```bash
systemctl daemon-reload
systemctl start docker
```

## Docker自定义网络

创建自定义桥接网络

```bash
docker network create --driver bridge mybr0
# 或者
docker network create -d bridge --subnet "192.168.1.0/24" --gateway "172.26.0.1" mybr0
```

查看自定义桥的详细信息

```bash
docker network inspect BRI_NAME
```

## 容器rootfs命令

docker commit 参数列表：
```bash
-a :提交的镜像作者
-c :使用Dockerfile指令来创建镜像
-m :提交时的说明文字
-p :在commit时，将容器暂停
例子：
docker commit -a "" -m "" [原镜像名称]  [新镜像名称:verison]      # 将容器a404c6c174a2 保存为新的镜像,并添加提交人信息和说明信息
```

docker cp：

```bash
# 在使用的过程中会进行多个主机与容器之间的数据交换
# 格式：
docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH
# OPTIONS选项：
- -archive/-a 存档模式（复制所有UID/GID信息）
- -follow-link/ -L 始终遵循SRC路径中的符号链接

# 例子：
docker cp /www/suofeiya <容器ID>:/容器中的目标目录
docker cp <容器ID>:/容器中的目标目录 <本机目录>

```

`docker diff ubtuntu\_test`：查看docker容器中所提交的更改
`docker tag [元镜像名:版本] [新镜像名:版本]`：标记镜像并为其添加标注,tag
`docker history`：查看指定镜像的创建历史

#  Docker容器共享数据卷

```bash
# 将宿主机的/container_data共享给容器的/data   ××容器数据卷××
sudo docker run -v ~/container_data:/data -it ubuntu /bin/bash

# ××数据卷容器，也就是包含数据卷的容器××
docker run -itd -v /data --name dvt0 ubuntu
docker run -itd --name dvt1 --volumes-from dvt0 ubuntu
```

#  DOCKERFILE文件以及构建


**FROM**

```bash
* 可以从DockHub中拉取指定镜像(默认)，也可以拉取第三方镜像仓库的镜像，或者直接拉取本地已经制作好的镜像
```


**MAINTAINER** 

```bash
#例子：
MAINTAINER "suofeiya <suofeiyaxx@gmail.com>"
```

**LABEL**

```bash
# 语法：
LABEL <key>=<value> <key>=<value> <key>=<value> ...
# 例子：
LABEL maintainer="suofeiya <suofeiyaxx@gmail.com>"  \ 
comment="something here" \ ...
* 注意： LABEL 值如果中包含空格，需要使用引号和反斜杠
```


**RUN**

```bash
RUN 指令：用于指定** docker build **过程中要运行的命令。
 语法格式：
  RUN <command> 或		# <command>通常是一个shell命令，且以"/bin/sh -c" 来运行它，这意味着此进程在容器中的PID号不为1，不能接收UNIX信号，因此，当使用 docker stop 命令来停止容器时，此进程接收不到SIGTERM信号
  RUN ["<executeable>","<param1>","param2",...]
  RUN ["/bin/bash","-c","<executeable>","param1","param2",...]
         
 例如：
     RUN yum install iproute nginx && yum clean all
```

**CMD**

```bash
CMD 指令：类似于 RUN 指令，用于运行程序，但二者运行的时间点不同；CMD 在** docker run **时运行，而非** docker build **阶段.
CMD 指令的首要目的在于为启动的容器指定默认要运行的程序，程序运行结束，容器也就结束
注意: CMD 指令指定的程序可被** docker run **命令行参数中指定要运行的程序所覆盖。
 语法格式：
 CMD <command> 或
 CMD ["<executeable>","<param1>","<param2>",...] 
 CMD ["<param1>","<param2>",...]  注意：该写法是为 ENTRYPOINT 指令指定的程序提供默认参数
注意：如果 dockerfile 中如果存在多个CMD指令，仅最后一个生效
     
 例如：
         CMD ["/usr/sbin/httpd","-c","/etc/httpd/conf/httpd.conf"]
```

**ENTRYPOINT**

```bash
ENTRYPOINT 指令：类似于 CMD 指令，但其不会被** docker run **的命令行参数指定的指令所覆盖，而且这些命令行参数会被当作参数送给 ENTRYPOINT 指令指定的程序；但是, 如果运行** docker run **时使用了 --entrypoint 选项，此选项的参数可当作要运行的程序覆盖 ENTRYPOINT 指令指定的程序
 语法格式：
 ENTRYPOINT <command> 或
 ENTRYPOINT ["<executeable>","<param1>","<param2>",...]
         
 例如：
     CMD ["-c"]
     ENTRYPOINT ["top","-b"]
注意：一个dockefile中可以有多个 ENTRYPOINT ，但仅有最后以一个ENTRYPOINT生效.
```

>**`ENTRYPOINT` 与 `CMD` 区别？**
>
> 如： `FROM busybox   ENTRYPOINT ["top", "-b"]    CMD ["-c"]`       把可能需要变动的参数写到 CMD 里面。然后你可以在** docker run **里指定参数，这样 CMD 里的参数(这里是-c) 就会被覆盖掉而 ENTRYPOINT 里的不被覆盖。 
>
>**注意**： ENTRYPOINT有两种写法，第二种(shell form)会屏蔽掉 docker run 时后面加的命令和 CMD 里的参数


**EXPOSE**

```bash
EXPOSE [PORT]/[PROTOCOL]		# 暴露端口，可以指定协议(可省略)
```

**ADD**

```bash
# 其中，<src>可以是压缩包类型，也可以是url

* 需要注意的一点：
	  docker 官方建议我们当需要从远程复制文件时，最好使用 curl 或 wget 命令来代替 ADD 命令。原因是，当使用 ADD 命令时，会创建更多的镜像层，当然镜像的 文件大小 也会更大，例如：
# 官方不建议使用的方法
ADD http://example.com/big.tar.xz /usr/src/things/
RUN tar -xJf /usr/src/things/big.tar.xz -C /usr/src/things
RUN make -C /usr/src/things all

# 官方建议的使用方法
# 如果使用下面的命令，不仅镜像的层数减少，而且镜像中也不包含 big.tar.xz 文件
RUN mkdir -p /usr/src/things \
&& curl -SL http://example.com/big.tar.xz \
| tar -xJC /usr/src/things \
&& make -C /usr/src/things all
```

**COPY**

```bash
COPY <src>... <dest>
# 或者
COPY ["<src>" ... "<dest>"]

* 注意：dest目标目录最好使用绝对路径，若要使用相对路径，则需要设置workdir工作目录路，另外如果路径中包含有空格字符，应当使用第二种格式

文件复制准则：
* <src>应当是build上下文中的路径，不能是其父目录或者其他上级目录中的文件
* 如果<src>为目录，则该目录下的所有文件均会被复制，但<src>目录本身不会被复制
* 如果指定了多个<src>目录，或者使用了文件通配符，则<dest>目标目录在文件夹结尾需加入"/"
* 如若<dest>目录在容器中不存在，则build构建时会自动创建，包含其父目录
```

>**`ADD`命令和`COPY`命令的区别？**
>
>* `COPY `命令可以用于 `multistage` 场景下，而ADD命令不可以
>* `ADD`命令可以传入压缩包文件，并自动解压至指定位置，也可以传入URL
>
>---
>
>docker的 `multistage` 场景：同一个`DockerFile`文件中可以存在多个FROM指令，每个`FROM`指令代表stage的开始.
>
>```shell
># 使用无命名的stage，加入以下参数
>--from=0
># 使用命名的stage
>FROM busybox as builder
>...
>FROM centos
>COPY --from builder /PATH/TO/FILE ./
>...
>```
>
>注意：旧版本的 docker 是不支持 `multi-stage` 的，只有 `17.05 `以及之后的版本才开始支持

**VOLUME**

```bash
# 格式：
VOLUME ["<路径1>", "<路径2>"...] 
VOLUME <路径> 
* 注意：通过 VOLUME 指令创建的挂载点，无法指定主机上对应的目录，是自动生成的
```

**USER**

```bash
# 格式：
USER <user>[:<group>] 
USER <UID>[:<GID>]
# 作用：指定运行时的用户名或UID，后续的RUN也会使用指定的用户，当服务不需要管理权限时，可以通过该命令指定运行用户，并且可以在之前创建所需要的用户

* 注意：当要临时获取管理权限时，可以使用gosu，而不推荐使用sudo

```

**WORKDIR**

```bash
# 格式：
WORKDIR /PATH/TO/DIR

* 注意：一个DockerFile中可以指定多个WORKDIR，后续命令如果是相对目录，则会基于之前指定的路径，例如`WORKDiR /dir1 \ WORKDIR dir2 \ WORKDIR dir3 \ RUN pwd`，其结果是`/dir1/dir2/dir3`
```

**ONBUILD**

```bash
# 用于在DockerFile中定义一个触发器，当一个镜像被当做基础镜像，也就是FROM对象时，就会触发base image中的ONBUILD指令所定义的触发器

* 注意：使用包含ONBUILD的指令的DockFIle构建的镜像时，应当使用特殊的标签，例如busybox-onbuild
在ONBUILD命令中使用COPY命令和ADD命令时要注意，如果在构建的上下文中缺少指定的源文件时会报错
```

**ARG**

```bash
# 语法：
ARG NAME[=<default-value>]
# 作用：ARG 指令使用 --build-arg = 标志定义一个变量，用户可以使用 docker build 命令在构建时将该变量传递给构建器。如果用户指定了未在 Dockerfile 中定义的构建参数，则构建会输出告警
* 可以在同一个DockerFile中指定多个 ARG ，ARG可以有默认值，当容器构建时未指定变量的默认值，将使用dockerfile中的默认值
* 注意：ARG 变量定义从 Dockerfile 中定义的行开始生效，而不是从命令行或其它地方的参数使用，简单来说ARG变量定义可以先使用后声明(大概这个意思吧...)，另外，使用ENV 指令定义的环境变量始终覆盖同名的 ARG 指令

# 预定义的ARG，可以直接在DockerFile中使用，而无需相应的ARG指令
HTTP_PROXY,http_proxy,HTTPS_PROXY,https_proxy,FTP_PROXY,ftp_proxy,NO_PROXY,no_proxy
# 如何使用？直接在命令行使用即可
--build-arg <varname>=<value>
```

**ENV**

```bash
# 两种格式
ENV ENV_NAME VARIABLE			# 指定单个环境变量
ENV ENV_NAME="VARIABLE" ...			# 传递多个环境变量
* 通过ENV定义的环境变量，可以在dockerfile被后面的所有指令中使用，但不能被CMD指令使用，也不能被docker run 的命令参数引用，使用ENV 指令定义的环境变量始终覆盖同名的 ARG 指令
* 如果需要在容器运行时使用环境变量，在 docker run 时使用 -e "ENV_NAME=VARIABLE" 即可

* 注意：与 ARG 指令不同，ENV 值始终保留在构建的镜像中
```

**HEALTHCHECK**

```bash
# 两种格式
HEALTHCHECK [OPTIONS] CMD COMMAND
HEALTHCHECK NODE			# 禁止从父镜像继承的HEALTHCHECK生效

* 可用OPTOPNS
--interval=DURATION(default:30s)		# 间隔(s秒、m分钟、h小时)，从容器运行起来开始计时interval秒（或者分钟小时）进行第一次健康检查，随后每间隔interval秒进行一次健康检查；还有一种特例请看timeout解析。
--start-period=DURATION(default:0s)			#  启动时间， 默认 0s， 如果指定这个参数， 则必须大于 0s ；--start-period 为需要启动的容器提供了初始化的时间段， 在这个时间段内如果检查失败， 则不会记录失败次数。 如果在启动时间内成功执行了健康检查， 则容器将被视为已经启动， 如果在启动时间内再次出现检查失败， 则会记录失败次数。
--timeout=DURATION(default:30s)			# 执行command需要时间，比如curl 一个地址，如果超过timeout秒则认为超时是错误的状态，此时每次健康检查的时间是timeout+interval秒。
--retries=N(default:3)			# 连续检查retries次，如果结果都是失败状态，则认为这个容器是unhealth的

* 容器退出状态码
*  0表示正常退出，1表示unhealthy，2表示reserved
# 例子：
HEALTHCHECK --interval=4m --timeout=3s \ 
CMD curl -f http://localhost || exit 1

* 总结：当容器启动之后，首先间隔interval秒然后进行健康检查，如果一个检查所花的时间超过了timeout秒，那么就认为这次检查失败了，如果连续retries次失败，就认为此容器状态为unhealthy

# 使用例子：
HEALTHCHECK –interval=10s –timeout=3s –retries=3 CMD curl http://localhost			#  可能会出现curl这个地址3秒内没响应则认为失败，然后再开始interval的时间进行下次检测，最后显示unhealthy的状态应该是39s
# 获取指定容器的健康状态
docker inspect –format ‘{{json .State.Health.Status}}’ 41f1414fab75

* 注意：当dockfile指定多个 HEALTHCHECK 时，仅对最后一个 HEALTHCHECK 有效
```
DOCKERFILE文件选项，例子：[http://www.ityouknow.com/docker/2018/03/15/docker-dockerfile-command-introduction.html#dockerfile-%E4%BD%BF%E7%94%A8%E7%BB%8F%E9%AA%8C](http://www.ityouknow.com/docker/2018/03/15/docker-dockerfile-command-introduction.html#dockerfile-使用经验)，https://www.jianshu.com/p/cbce69c7a52f

---
docker build用于使用 Dockerfile 创建镜像，下面是参数列表:

```bash
--build-arg=\[\]                 #设置镜像创建时的变量
--cpu-shares                 #设置 cpu 使用权重
--cpu-period                 #限制 CPU CFS周期
--cpu-quota                 #限制 CPU CFS配额
--cpuset-cpus                 #指定使用的CPU id
--cpuset-mems                 #指定使用的内存 id
--disable-content-trust                 #忽略校验，默认开启
-f                 #指定要使用的Dockerfile路径
# 例子：
docker build -f /path/to/a/Dockerfile .
--force-rm                 #设置镜像过程中删除中间容器
--isolation                 #使用容器隔离技术
--label=\[\]                 #设置镜像使用的元数据
-m                 #设置内存最大值
--memory-swap                 #设置Swap的最大值为内存+swap，"-1"表示不限swap
--no-cache                 #创建镜像的过程不使用缓存
--pull                 #尝试去更新镜像的新版本
--quiet, -q                 #安静模式，成功后只输出镜像 ID
--rm                 #设置镜像成功后删除中间容器
--shm-size                 #设置/dev/shm的大小，默认值是64M
--ulimit                 #Ulimit配置
--tag, -t                #镜像的名字及标签，通常 name                #tag 或者 name 格式可以在一次构建中为一个镜像设置多个标签
--network                #默认 default在构建期间设置RUN指令的网络模式
```
## DockerFile构建技巧

### 加速镜像构建

在使用 `COPY` 和 `ADD` 命令时，我们可以通过一些技巧来加速镜像的 build 过程。比如把那些最不容易发生变化的文件的拷贝操作放在较低的镜像层中，这样在重新 build 镜像时就会使用前面 build 产生的缓存，例如：

``` shell
# 构建文件夹中分别有 test.sh x1.sh x2.sh x3.sh 四个文件，其中 test.sh 文件不经常修改，而x1-3.sh经常有变动，所以将 test.sh 单独置于一个镜像层中，且放置于较低的镜像层中
WORKDIR /test
COPY test.sh .
COPY x*.sh ./
# 构建时，当 x*.sh 发生变化而 test.sh 无变化时，重新构建镜像时会跳过 test.sh
```

#  Docker搭建私有仓库

## 使用Registry

1. 拉取docker hub上的`registry`镜像

```bash
docker pull registry
```

2. 建立本地的私有仓库挂载目录，并运行私有仓库的容器

```bash
mkdir -p /data/docker/registry
# 运行私有仓库容器
docker run -itd -p 5000:5000  -v /data/docker/registry:/var/lib/registry --restart=always --name myRegistry registry:latest			# --restart=always意思是当容器异常终止时，立即进行重启操作
```

3. 查看仓库中的镜像

```bash
# 浏览器或者终端查看即可
curl http://172.16.122.132:5000/v2/_catalog
```

4. 修改配置文件，添加私有仓库地址

```bash
# 编辑/etc/docker/damon.json，添加如下内容
{
	  "insecure-registries": ["172.16.122.132:5000"]
}
* 注意：docker在拉取镜像是默认使用的是https，不支持http，需要自行设置.
也可以在docker.service文件中添加运行参数`-–insecure-registry=IP_ADDR`
```

5. 将之前做好的镜像打标签并上传到私有仓库

```bash
docker tag nginx:alpine 172.16.122.132:5000/ngx:v1
```

6. 上传打好标的镜像，并进行查看

```bash
docker push 172.16.122.132:5000/ngx:v1
# 查看registry上的镜像
curl http://172.16.122.132:5000/v2/_catalog
```

7. 列出私有仓库镜像标签

```bash
curl http://172.16.122.132:5000/v2/ngx/tags/list
```

8. 其他主机访问拉取私有仓库地址

```bash
docker pull 172.16.122.132:5000/ngx:v1
* 注意：其他主机访问自建的registry也需要修改`damon.json`，并且使用 docker pull 时不要加上scheme(http://)
```

## 使用Harbor

注意：Harbor依赖于`docker-compose`，需要提前安装好

1. 安装`docker-compose`

```bash
yum install epel-release
yum install -y python-pip
pip install docker-compose
# 查看docker-compose的版本
docker-compose -version
# 安装过程中如果出现错误，安装pip3，然后使用pip3安装docker-compose 

# 或或者，直接使用yum安装算了，免得麻烦
yum install -y docker-compose
```

2. 进入Harbor托管在Github上的Releases，下载离线包或者在线包：[点我直接进入](https://github.com/goharbor/harbor/releases)
3. 解压缩

```bash
[root@node1 ~]\# tar xf harbor-offline-installer-v1.9.3.tgz

[root@node1 harbor]\# ls
harbor.v1.9.3.tar.gz  harbor.yml  install.sh  LICENSE  prepare
```

4. 配置完成之后再当前目录下执行`./install.sh`，Harbor就回根据当前目录下的`harbor.yml`下载或者加载依赖的镜像

```bash
# 编辑yml配置文件的hostname参数
...
hostname: 172.16.122.132
...
[root@node1 harbor]\# ./install.sh

```

5. 启动Harbor，打开浏览器，访问，默认账号是`admin`，密码是`Harbor12345`
6. 打标，登录，上传制作好的镜像

```bash
# 打标
docker tag nginx:alpine 172.16.122.132/test/ngx:alpine
# 登录
docker login http://172.16.122.132/
username:
password:

# push到Harbor
docker push  172.16.122.132/test/ngx:alpine
```



5. 停止Harbor，使用`docker-compose stop`即可

# Docker系统资源限制以及stress验证

>在默认的情况下，docker没有对容器进行硬件资源的限制，当容器负载过高时会尽肯能第占用宿主机资源。在这基础上，docker提供了针对容器的内存，`CPU`，`IO`资源的控制方式。（真正可以控制的只有内存和cpu）
>Docker内存控制`OOME`在linux系统上，如果内核探测到当前宿主机已经没有可用内存使用，那么会抛出一个`OOME(Out Of Memory Exception:内存异常 )`，并且会开启killing去杀掉一些进程。
>一旦发生`OOME`，任何进程都有可能被杀死，包括`docker daemon`在内，为此，docker特地调整了docker daemon的`OOM_Odj`优先级，以免他被杀掉，但容器的优先级并未被调整。经过系统内部复制的计算后，每个系统进程都会有一个`OOM_Score`得分，`OOM_Odj`越高，得分越高，（在`docker run`的时候可以调整`OOM_Odj`）得分最高的优先被`kill`掉，当然，也可以指定一些特定的重要的容器禁止被`OMM`杀掉，在启动容器时使用 `–oom-kill-disable=true`指定
>
>---
>
>FROM:https://www.cnblogs.com/lizhaojun-ops/p/9441624.html

## 内存限制

内存限制部分参数(下述选项中的大多数采用正整数，后跟 `b` / `k` / `m` / `g` 的后缀，代表单位：字节 / 千字节 / 兆字节 / 千兆字节)：

|   选项	   |   描述   |
| :--- | ---- |
|   -m or --memory   |   容器可使用的最大内存， 最小值是 4m   |
|   --memory-swap*   |   允许此容器交换到磁盘的内存量   |
|   --memory-swappiness   |   默认情况下，主机内核可以交换容器使用的匿名页面的百分比，可以设置 --memory-swappiness 的值区间为 0 - 100   |
|   --memory-reservation   |   指定小于 --memory 的软限制，当 Docker 检测到主机上的争用或内存不足时会激活该限制，如果使用 --memory-reservation，则必须将其设置为低于 --memory 才能使其优先。因为它是软限制，所以不保证容器不超过限制   |
|   --kernel-memory   |   容器可以使用的最大内核内存量， 最小值是 `4m`，因为内核内存无法换出，缺乏内核内存的容器可能会阻塞主机资源，这会对主机和其他容器产生副作用   |
|   --oom-kill-disable   |   默认情况, 如果发生内存不足（OOM）错误，内核会终止容器中的进程。 要改变这种行为，使用 --oom-kill-disable 选项。 仅在已设置 -m /  -memory 选项的容器上禁用 OOM killer，如果未设置 -m 标志，则主机可能会耗尽内存，内核可能需要终止主机系统的进程才能释放内存   |

## CPU限制

|   选项	   |   描述   |
| ---- | ---- |
|   --cpus=<value>   |   指定容器可以使用的 CPU 资源量。例如，如果主机有两个CPU并且，设置 --cpus="1.5"，则容器最多可以使用 1.5 个 CPU，这相当于设置 --cpu-period="100000" 和 --cpu-quota="150000"。可在Docker 1.13及更高版本中使用   |
|   --cpu-period=<value>   |   指定 CPU CFS 调度程序周期，该周期与 --cpu-quota 一起使用，默认为100微秒。大多数用户不会更改默认设置，如果使用Docker 1.13 或更高版本，请改用 --cpus   |
|   --cpu-quota=<value>   |   对容器施加 CPU CFS 配额，在受限制之前容器限制为每个 --cpu-period 的微秒数，作为有效上限。如果使用Docker 1.13 或更高版本，请改用 --cpus   |
|   --cpuset-cpus   |   限制容器可以使用的特定 CPU 或核心。如果主机有多个CPU，则容器可以使用的以, 分 隔的列表或 - 分隔的 CPU 范围。第一个CPU 编号为 0，有效值可能是 0-3（使用第一个、第二个、第三个和第四个CPU）或 1,3（使用第二个和第四个CPU）   |
|   --cpu-shares   |   将此值设置为大于或小于默认值 1024，以增加或减少容器的权重，并使其可以访问主机的 CPU 周期的占较大或较小比例。仅在 CPU 周期受限时才会强制执行此操作。当有足够的 CPU 周期时，所有容器都会根据需要使用尽可能多的 CPU。这是一个软限制，--cpu-shares 不会阻止在群集模式下的容器调度。它为可用的 CPU 周期优先考虑容器 CPU 资源。它不保证或保留任何特定的 CPU 访问权限   |

详情查看：https://blog.csdn.net/zisefeizhu/article/details/83536475

# DockerFile构建实例

* 构建tomcat服务

  * ```shell
    FROM centos
    MAINTAINER suofeiya " suofeiyaxx@gmail.com"
    ADD jdk-11.0.4_linux-x64_bin.tar.gz /usr/local
    ENV JAVA_HOME  /usr/local/jdk-11.0.4
    ADD apache-tomcat-9.0.24.tar.gz /usr/local
    WORKDIR /usr/local/apache-tomcat-9.0.24/bin
    EXPOSE 8080
  CMD ["catalina.sh", "run"]
    # 构建容器
    docker run -d -p 8080:8080 --name tomcat tomcat:test
    ###########################################
    tomcat的默认server status等服务允许访问的网段是127.。。
    解决方法：
    	在conf/tomcat-users.xml下添加：
    	<role rolename="manager-gui"/>
    	<role rolename="admin-gui"/>
    	<user username="tomcat" password="s3cret" roles="manager-gui,admin-gui"/>
    	修改./host-manager/META-INF/context.xml和./manager/META-INF/context.xml文件：
    	allow="192.168.1.*" />
    重启tomcat服务即可
    ```

* PHP环境搭建

  * ```shell
    FROM centos:6
    MAINTAINTER suofeiya "suofeiyaxx@gmial.com"
    RUN yum install -y httpd php php-gd php-mysql mysql mysql-server
    ENV MYSQL_ROOT_PASSWORD 123456
    RUN echo "<?php phpinfo()?>"  > /var/www/html/index.php
    ADD start.sh /start.sh
    RUN chmod +x start.sh
    COPY wordpress/*  /var/www/html
    VOLUME ["/var/lib/mysql"]
    CMD /start.sh
    EXPOSE 80 3306
    # start.sh内容
    service httpd start
    service mysqld start
    mysqladmin -uroot password $MYSQL_ROOT_PASSWORD
    tail -f
    ```


#  Docker容器可视化监控中心搭建cadviser+influxdb+grafana

---
*  分别从hub.docker拉取
	* > 1. cadvisor：负责收集容器的随时间变化的数据
	  > 2. influxdb：负责存储时序数据
	  > 3. grafana：负责分析和展示时序数据

* 部署Influxdb服务

  * ```bash
    # 创建镜像并使其后台运行
    docker run -d --name influxdb -p 8086:8086 \
          -v influxdb:/var/lib/influxdb \
          influxdb
    
    # 进入influxdb容器内部，并执行influx命令：
    docker exec -it influxdb influx
    
    # 进入influxdb的shell后创建数据库test和root用户用于本次试验测试
    CREATE DATABASE "test"
    CREATE USER "root" WITH PASSWORD '123456' WITH ALL PRIVILEGES
    SHOW DATABASES  # 验证数据库是否成功创建
    ```

*  部署cAdvisor服务

   *  ```bash
      # 创建镜像并使其后台运行
       docker run -d  \
        --volume=/:/rootfs \
        --volume=/var/run:/var/run \
        --volume=/sys:/sys \
        --volume=/var/lib/docker/:/var/lib/docker \
        --link=influxdb:influxdb   --name cadvisor   google/cadvisor:latest  \
        -storage_driver=influxdb \
        -storage_driver_host=influxdb:8086 \
        -storage_driver_db=test  \
        -storage_driver_user=root  \
       -storage_driver_password=123456  
       
      # 注意：
      #  设置为true之后，容器内的root才拥有真正的root权限，可以看到host上的设备，并且可以执行mount；否者容器内的root只是外部的一个普通用户权限。由于cadvisor需要通过socket访问docker守护进程，在CentOs和RHEL系统中需要这个这个选项。 --volume=/cgroup:/cgroup:ro对于CentOS和RHEL系统的某些版本（比如CentOS6），cgroup的层级挂在/cgroup目录，所以运行cadvisor时需要额外添加–volume=/cgroup:/cgroup:ro选项。
      ```

*  部署Grafana服务

   *  ```bash
      # 创建镜像并使其后台运行
      docker run -d -p 6000:3000 -v ~/grafana:/var/lib/grafana --link=influxdb:influxdb --name grafana grafana/grafana
      ```


