# Linux Shell 实用命令/系统文件及使用场景

## COMMAND

- `set`在shell中的常用组合: 
  
- `-x`: 用于调试(debug)；
    - `-u`: 如果遇到不存在的变量，Bash 默认忽略它。 使用`-u`选项来避免这种情况。 即遇到未定义的变量。 则异常退出脚本. **等价于`set -o nounset`命令；** 
    
    > 其他写法:
    >
    > ```bash
    > # 写法一
    > command || { echo "command failed"； exit 1； }
    > 
    > # 写法二
    > if ! command； then echo "command failed"； exit 1； fi
    > 
    > # 写法三
    > command
    > if [ "$?" -ne 0 ]； then echo "command failed"； exit 1； fi
    > ```
    
    - `-e`: 脚本只要发生错误，就终止执行。 `set -e`有一个例外情况，就是*不适用于管道命令*。**等价于`set -o errexit`命令；**
    - `-o pipefail`：用于解决`-e`选项无法处理管道命令错误的问题，只要一个子命令失败，整个管道命令就失败，脚本就会终止执行。

> **使用场景：**
>
> 一般shell脚本将以下内容放置到前几行：
>
> ```bash
> set -euxo pipefail
> set -o errexit
> ```

- `#!/usr/bin/env bash`和`#!/bin/bash`区别

> 前者无需在意所运行的解释器在何处(bash), 只要存在于你的`$PATH`环境变量中即可, 根据你的环境寻找并运行默认的版本，具有灵活性.

- `command -v <COMMAND>`: 用于验证某个命令是否存在。 不存在则返回一个非零值.

> **使用场景:** 
>
> shell脚本中判断一个命令是否存在且可执行。 可以使用以下命令：
>
> ```bash
> if [ -x "$(command -v systemctl)" ];then ...
> ```

- `exec > SOMEFILE`: 将脚本输出内容全部输出到指定文件中(除非单独指定)

> **使用场景:**
>
> ```shell
> # 查找某目录中的占用空间最大的几个文件
> du -S /home/suofeiya/mycharts/ | sort -rn | sed '{11,$D};=' | sed 'N; s/\n/ /' | awk 'BEGIN {print "序号\t大小(k)\t文件夹"}{printf $1 ":" "\t" $2 "\t" $3 "\n"}'
> # 将输出存到指定文件
> exec > result.txt
> ```
>

- `exec`: exec 是 bash 的内置命令, 不启用新的shell进程。就像`source`或者`.`一样, 使用`bash`或者`sh`执行命令时, 会另起一个子shell, 子shell会继承父shell的环境变量, 子shell执行完毕之后不影响父shell.

- `trap`: 捕获信号, 通常用途是在shell脚本被中断时完成清理工作

> | 信号名称 | 信号数 | 描述                                                         |
> | :------- | :----: | :----------------------------------------------------------- |
> | SIGINT   |   2    | 程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl+C)时发出。 |
> | SIGQUIT  |   3    | 和SIGINT类似, 但由QUIT字符(通常是Ctrl /)来控制. 进程在因收到SIGQUIT退出时会产生core文件, 在这个意义上类似于一个程序错误信号。 |
> | SIGFPE   |   8    | 在发生致命的算术运算错误时发出. 不仅包括浮点运算错误, 还包括溢出及除数为0等其它所有的算术的错误。 |
> | SIGKILL  |   9    | 用来立即结束程序的运行. 本信号不能被阻塞, 处理和忽略。       |
> | SIGALRM  |   14   | 时钟定时信号, 计算的是实际的时间或时钟时间. alarm函数使用该信号。 SIGTERM |
>
> **使用场景:**
>
> - 脚本退出前执行命令
>
> 脚本在执行时按下`CTRL+c`时，将显示"program exit..."并退出(`CTRL+c`的信号是SIGINT)
>
> ```shell
> trap "echo 'program exit...'; exit 2" SIGINT
> ```
>
> - 忽略信号
>
> 例：脚本运行时忽略 `SIGINT` `SIGQUIT` `SIGFPE`等信号
>
> ```shell
> trap '' 2 3 8
> ```

- `select`: 获取选项

> **使用场景:**
>
> ```shell
> PS3="enter option: "		# 使用select时的提示符
> select option in "option1" "option2" "option3" "option4" "exit"
> do
> 	case $option in
> 	"exit")
> 	break;;
> 	"option1")
> 	break;;
> 	...
> 	*)
> 	...
> 	esca
> done
> ```

- `cat >&1 <<-EOF`: 用于打印多行信息(多用于脚本使用信息)

> **使用场景:**
>
> ```shell
> cat >&1 <<-EOF		# 或者直接使用cat << EOF
> 	first line
> 	second line
> 	third line
> EOF
> ```

## SYSTEM FILES

- `/etc/os-release`：查看系统名称、版本、基于版本、版本代号、帮助信息、系统官方主页等；

> **使用场景：**
>
> 对不同的系统使用不同的命令进行处理：
>
> ```bash
> # 检查·sysctl·命令是否存在且可执行，如果不存在则进行下载安装。
> 	if ! [ -x "$(command -v sysctl)" ]; then
>       echo 'sysctl not installed. Installing it...'
>       distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
>       case $distro in
>         ol | centos)
>           yum install -y procps
>           rm -rf /var/cache/yum;;
>         ubuntu | debian)
>           apt-get update -qq && apt-get install -y --no-install-recommends procps
>           rm -rf /var/lib/apt/lists /var/cache/apt/archives;;
>       esac
>     fi
> ```
>
> 