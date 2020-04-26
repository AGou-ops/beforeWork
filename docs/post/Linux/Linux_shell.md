> **This is Linux_shell StudyNote.**

# Tips

* 使用`sh -x test.sh `可以查看shell的执行步骤，使用`sh -n test.sh`可以简单检查shell的语法错误
* `nohup`将命令放于后台执行，例如：` nohup sh test.sh &`，执行命令的同时，在家目录会生成一个nohup.out的文件来接收返回结果，所以可以使用`tail -f nohup.out`来实时查看输出内容

 # 调用外部命令

  * ```shell
    `command`或者使用$(command)
    # 算数运算
    $(( ))  # 用于整数运算，包括加减乘除，引用变量时可不加`$`符号
    ((num++/--))  # 可以用来进行自增或者自减操作
    ```

 # 使用变量
  * ```shell
    $变量名称	或者使用	${变量名称}
    ```
    
  * 设置变量为只读`readonly 变量名称`

  * 一般在shell中变量会被声明成全局变量，使用`local`关键字可以将变量定义为局部变量，如果函数内外存在同名变量，则函数内部的变量将会覆盖外部变量

 # echo
  * echo可加多个变量参数,如:`echo $str1 $str2`

  * 原样输出字符串，不进行转义或取变量(用单引号)`echo '$name\"'`==>$name\"

  * echo最好使用双引号

  * echo输出`ANSI`带颜色或者特效的文字，参考https://www.jianshu.com/p/d1b4f554e6f1

      * >语法格式：
        >
        >```bash
        >echo -e "\033[3mSome things you want to print out.\033[0m"  
        >```
        >
        >`3x`为表示**前景颜色**的一组数字，x取值为0到7，分别代表的颜色如下：
        >`30`表示黑色
        >`31`表示红色
        >`32`表示绿色
        >`33`表示黄色
        >`34`表示蓝色
        >`35`表示紫色
        >`36`表示浅蓝色
        >`37`表示灰色
        >`033[0m`为ANSI控制码，表示结束输出有颜色的字符
        >
        >---
        >
        >`4x`，常用的**背景颜色**也共8种，`x`取值为0到7。常用背景色如下：
        >`40`表示背景为黑色
        >`41`表示背景为红色
        >`42`表示背景为绿色
        >`43`表示背景为黄色
        >`44`表示背景为蓝色
        >`45`表示背景为紫色
        >`46`表示背景为浅蓝色
        >`47`表示背景为灰白色
        >
        >
        >
        >混合使用示例
        >
        >```bash
        >echo -e "\033[47;31mHELLO\033[0m"
        >```
        >
        >---
        >
        >  其它常用的ANSI控制码
        >
        >`\033[1m`让输出的字符高亮显式
        >`\033[3m`输出斜体字
        >`\033[4m`给输出的字符加上下划线
        >`\033[5m`让输出的字符闪烁显式
        >`\033[7m`设置反显效果，即把背景色和字体颜色反过来显示

 # printf
  * ```shell
    printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
    #  输出:郭靖     男      66.12
    
    # 格式替代符
    `%-10s`,`-`代表左对齐(没有则是右对齐),`10s`代表10个宽度字符,`.2`代表保留两位小数
    `%c`后加字符串(第一个)或者字符
    ```

# exec[(参考地址)](https://blog.csdn.net/qq_31186123/article/details/82190776)

* shell的内建命令exec将并不启动新的shell，而是用要被执行命令替换当前的shell进程，并且将老进程的环境清理掉，而且exec命令后的其它命令将不再执行，不过，要注意一个例外，当exec命令来对文件描述符操作的时候，就不会替换shell，而且操作完成后，还会继续执行接下来的命令。

* 在shell中的两种用法

  * ```bash
    1.  exec 命令 ;命令代替shell程序，命令退出，shell 退出；比如 exec ls
    2.  exec 文件重定向，可以将文件的重定向就看为是shell程序的文件重定向 比如 exec 5>/home/suofeiya/test_dir/test; # 位置在/dev/fd中
    cat /home/suofeiya/test_dir/test
    exec 5>&-	# 取消设备5
    ```

* 与source的异同点：exec和source都是在父进程中直接执行，但exec这个与source有很大的区别，source是执行shell脚本，而且执行后会返回以前的shell，而exec则是运行完退出当前shell

 # read
  * 可读取多个参数`read 变量1 变量2`
  
  * ```shell
    read -p "请您五秒内输入您的密码(长度限制6):" -n 6 -t 5 -s password
    echo -e "\nyour password is $password"
    -p 输入提示文字
    -n 输入字符长度限制(达到6位，自动结束)
    -t 输入限时
    -s 隐藏输入内容
    ```
    
#  let

* 除了支持`expr`中的加减乘除求余外，还支持**+=，-=，*=，/=，%=**

#  locate

* 生命变量的作用域，只在函数体内有效，例子：`locate name=suofeiya`

# declare & typeset

* declare参数列表

  * ```shell
  -r  将变量设置为只读
  -i  将变量设置为整数
  -a  将变量设置为数组
  -A 将变量设置成关联数组
  -p  显示变量的值
  -f  显示此脚本前定义过的所有函数以及内容
  -F  仅显示此脚本前定义的函数名
  -x  将变量设置为全局变量
    ```

 # string

  * 获取字符串长度`${#str}`
  
  * 查找子字符串`expr index "$str" xy`,查找字符x/y的位置
  
  * 遍历字符串`for str in 'This is a string';do echo $str;done;`
  
  * 截取字符串(字符串切片)
  
    * ```shell
      var=https://suofeiya.pro/mygitbook
      echo ${var#*//}			 # `#`为运算符,删除左边开始到`//`结束的字符,suofeiya.pro
      echo ${var##*/}			 # 删除最后一个`/`之前字符,mygitbook
      echo ${var%/*} 			 # `%/*`从右边开始删除`/`右边字符,https://suofeiya.pro
      echo ${var%%/*}			  # 删除最后一个`/`之后内容
      echo ${var:0:5} 			 # 截取第一个字符之后的五个字符
      echo ${var:0} 			 # 从第一个字符开始到结束
      echo ${var:0-13:3}			  # 其中的`0-7`表示右边算起第七个字符开始,截取3个字符,pro
      # 总结:`#、`## 表示从左边开始删除。一个 # 表示从左边删除到第一个指定的字符；两个 # 表示从左边删除到最后一个指定的字符
      # `%`、`%%` 表示从右边开始删除。一个 % 表示从右边删除到第一个指定的字符；两个 % 表示从左边删除到最后一个指定的字符
      # 删除包括了指定的字符本身
      ```

  * 字符串的查找替换和删除
  
      * ```bash
        
        ```
      # 字符串的查找替换
        ${var/PATTERN/SUBSTI} 		# 查找var所表示的字符串中，第一次被PATTERN所匹配到的字符串，并将其替换为SUBSTI所表示的字符串
        ${var//PATTERN/SUBSTI}		# 查找所有并替换
      
        ${var/#PATTERN/SUBSTI}		# 查找行首为PATTERN所匹配的字符串，并替换
        ${var/%PATTERN/SUBSTI}		# 行尾...
      
        # 字符串的查找和删除
        ${var/PATTERN}		# 查找以PATTERN所匹配的字符串中的第一次匹配，并删除
        ${var//PATTERN}		# 查找所有...
        ${var/#PATTERN}		# 查找行首
      ${var/%PATTERN}		# 行尾
      
      ```
        
      ```
    
* 字符串变量的特殊赋值

  * ```bash
    ${var:-VALUE}		# 如果var为空或者为赋值，则返回VALUE，否则返回var值
    ${var:=VALUE}		# 如果var为空或者为赋值，则返回VALUE，并将VALUE赋值给var，否则返回var值
    ${var:+VALUE}		# 如果var为非空，则返回VALUE，相当于非空时替换
    ${var:?ERROR_INFO}		# 如果var为空或者未赋值，则返回ERROR_INFO错误提示，否则返回var值
    ```

  * 字符大小转换
  
      * ```bash
      	${var^^}		# 将var变量字符串中的所有小写字符转换成大写
        ${var,,}		 # 将var变量字符串中的所有大写字符转换成大写
        ```
    
  * 字符串比较
  
    * ```shell
      `=`,`!=`  两字符串相同,不相同
      `-z` 检测字符串长度是否为0，为0返回 true
      `-n` 与`-z`相反
      `$`  检测字符串是否为空，不为空返回 true
      	a="abcd"
      	[ $a ] 返回 true
      ```

 # array
  * 数组声明：声明索引数组，`declare -a ARRAY_NAME`；声明关联数组，`declare -A ARRAY_NAME`，例如：`ARRAY_NAME([index_name1]="value1" [index_name2]="value2")`
  
  * 数组中元素的赋值方式：
  
  * >（1）一次只赋值一个元素：
    >
    >​			ARRAY_NAME[INDEX]=VALUE
    >
    >（2）一次赋值全部元素：
    >
    >​			ARRAY_NAME={"VALUE1" "VALUE2" ...}
    >
    >（3）只赋值特定元素：
    >
    >​			ARRAY_NAME=([0]="VALUE" [23]="VALUE" ...)
    >
    >注意：bash支持稀疏格式的数组
    >
    >（4）使用read从键盘交互式读入
    >
    >​			read -a ARRAY_NAME
  
  * 读取数组
  
    * ```shell
      # 按照索引获取，不加下标默认只读取第一个元素
      ${array[下标]}
      # 利用@获取数组所有元素
      ${array[@]}  
      # 遍历数组1
      for i in ${my_arry[@]};do echo $i done
      # 遍历数组2
      j=0 while [ $j -lt ${#my_arry[@]} ] do
        echo ${my_arry[$j]}
        let "j++" # 自增,双引号可加可不加,等价于`let j+=1`,还可以`a=$[$a+1]`还可以`j=`expr $j + 1``，还可以使用`((j++))``或者`$((j++))`来实现
      done
      ```

* 数组的切片：`${var:offset:number}`获取字符串的子串，offset表示偏移，number表示偏移量。此外`${var: -length}`，取字符串最右侧的几个字符，注意：`-`号前方有空格

* 数组元素的替换：`${array[*]/old/new}`，加上双斜杠代表全部替换`${array[*]//old/new}`，注意：**只针对数组全部，而不只针对某一个元素**

* 获取数组长度`${#array[@/*]}`,获取单个元素的长度`${#array[下标]}`

* 向非稀疏数组中追加元素`ARRAY_NAME[${ARRAY_NAME[*]}]`

* `unset`清除元素，`unset array[index]`删除某个元素，`unset array`删除整个数组，注意：shell中删除某个元素后，**会保留原来的元素的index下标**

# trap信号捕捉

* 参考：https://blog.csdn.net/sinceNow/article/details/86294081

* 使用格式：`trap 'commands' signal-list`

* 信号说明

  * >HUP(1)　　　　挂起，通常因终端掉线或用户退出而引发
    >INT(2)　　　　中断，通常因按下Ctrl+C组合键而引发
    >QUIT(3)　　退出，通常因按下Ctrl+组合键而引发
    >ABRT(6)　　中止，通常因某些严重的执行错误而引发
    >ALRM(14)　　报警，通常用来处理超时
    >TERM(15)　　终止，通常在系统关机时发送

* 示例脚本

  * ```bash
    # 执行脚本时，使用ctrl+c可以将/tmp/westos下建立的文件都删除掉
    #!/bin/bash
    trap "find /tmp -type f -name "westos_*" | xargs rm -f && exit " 2
     
    while true
    do
        touch /tmp/westos_$(date +%F-%N-%M-%S)
        sleep 2
        ls -l /tmp/westos*
    done
    ```

* 可以将捕捉的动作定义为函数，例如`trap 'mytrap' INT`，其中`mytrap`为函数名称

 # 多行注释
  * ```shell
    :<<EOF
    注释内容...
    注释内容...
    注释内容...
    EOF
    EOF 也可以使用其他符号: 例如,!等
    也可以定义一个不会被调用的函数来写多行注释
    ```

 # 传递参数
  * `$#`传递到shell的参数个数
    
  * `$*`以单一字符串显示所有传向shell的参数情况以`"$1 $2 ..."`显示
    
  * `$@`与`$*`相似,但是输出多个字符串,`for i in "$@";do echo$i done`,`@/*`两者都可以直接获取到
    
  * `$$`shell当前进程ID
    
  * `$!`后台运行的最后一个进程ID
    
  * `$-`显示Shell使用的当前选项，与`set`命令功能相同
    
  * `$?`显示命令最后的退出状态,使用`perror [返回值]`来查看详细退出状态

 # 重定向

* `n >& m`将输出文件 m 和 n 合并
  
* `n <& m`将输入文件 m 和 n 合并
  
* `<< tag`将开始标记 tag 和结束标记 tag 之间的内容作为输入
  
* `command1 < infile > outfile`同时替换输入和输出，执行command1，从文件infile读取内容，然后将输出写入到outfile中。
  
* 文件描述符 0 通常是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）, 例如:将stderr重定向到file使用`command 2 > file`,合并stdout和stderr到file`command > file 2>&1`
  
*  Here Document
  
  * ```bash
      wc -l << EOF
          第一行
          第二行
          https://suofeiya.pro
      EOF
      ```


 # shell中[]的使用

  * 算术比较, 比如一个变量是否为0, `[ $var -eq 0 ]`。
  * 文件属性测试，比如一个文件是否存在，`[ -e $var ]`, 是否是目录，`[ -d $var ]`。
  * 字符串比较, 比如两个字符串是否相同， `[[ $var1 = $var2 ]]`。

 # shell基本运算符

* expr运算符
* ![Screenshot_2019-05-24-16-44-20](/home/suofeiya/myGitbook/images/Screenshot_2019-05-24-16-44-20.png)

* ```shell
    a=10 b=20
    `expr $a + $b` # 结果30,;加减除取余类似,乘法需要转义字符`\*`才能使用
    # 可以使用$(expr $a + $b)代替
    result=$[a+b]  # 注意:不能有空格
    `a=$b`  # 变量b赋值给a
    `[ $a == $b ]` 返回 false。
    ```


  * ```shell
    `-ge` 大于等于	[ $a -ge $b ]
    `-le` 小于等于	[ $a -le $b ]
	```
    
  * ```shell
    # 布尔运算符
    `-o` 或运算,有一个为真则为真
    `-a` 与运算,都为真则为真,`[ $a -lt 20 -a $b -gt 100 ]`
    ```
  * ```shell
    # 逻辑运算符
    `&&` 逻辑`AND`
    `||`  逻辑`OR`
    ```
    * **&&**、**||**、**<** 和 **>** 操作符存在于 **[[ ]]** 条件判断结构中
    * [[]] 运算符只是 [] 运算符的扩充。能够支持 >, < 符号运算不需要转义符，它还是以字符串比较大小。里面支持逻辑运算符：**|| &&** ，不再使用 **-a -o**。
    * 可以使用`((exp1 OP exp2))`代替`[ exp1 OP exp2 ]`
    * **`bc`命令用来进行运算`scale=2`修改小数精度，用法`echo "scale=4;50/9" | bc**`
    
  * 文件测试运算符,来自[菜鸟教程文件测试运算符](https://www.runoob.com/linux/linux-shell-basic-operators.html)
  
  * ```shell
    # 操作符	说明	举例
    -b file	检测文件是否是块设备文件，如果是，则返回 true。	[ -b $file ] 返回 false。
    -c file	检测文件是否是字符设备文件，如果是，则返回 true。	[ -c $file ] 返回 false	。
    -d file	检测文件是否是目录，如果是，则返回 true。	[ -d $file ] 返回 false。
    -f file	检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。	[ -f $file ] 返回 true。
    -g file	检测文件是否设置了 SGID 位，如果是，则返回 true。	[ -g $file ] 返回 false。
    -k file	检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。	[ -k $file ] 返回 false。
    -p file	检测文件是否是有名管道，如果是，则返回 true。	[ -p $file ] 返回 false。
    -u file	检测文件是否设置了 SUID 位，如果是，则返回 true。	[ -u $file ] 返回 false。
    -r file	检测文件是否可读，如果是，则返回 true。	[ -r $file ] 返回 true。
    -w file	检测文件是否可写，如果是，则返回 true。	[ -w $file ] 返回 true。
    -x file	检测文件是否可执行，如果是，则返回 true。	[ -x $file ] 返回 true。
    -s file	检测文件是否为空（文件大小是否大于0），不为空返回 true。	[ -s $file ] 返回 true。
    -e file	检测文件（包括目录）是否存在，如果是，则返回 true。	[ -e $file ] 返回 true。
    ```

 # test

  * 和`if`是好搭档,可以用来进行数值,文件,字符串测试

  * Shell还提供了与( -a )、或( -o )、非( ! )三个逻辑操作符用于将测试条件连接起来，其优先级为："!"最高，"-a"次之，"-o"最低

  * ```shell
    if test -e ./notFile -o -e ./bash
    then
        echo '至少有一个文件存在!'
    else
        echo '两个文件都不存在'
    fi
    ```

 # 流程控制

* if语句

    * ```shell
      if condition1
      then
      	command1
      	command2 ...
      elif condition2
      then
      	command3
      else
      	command4
      if
      
      # 写成一行，适合与terminal终端使用
      if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi
      ```
      

* for语句

    * ```shell
        for var in item1 item2 ...
        do
        	command1
        	command2 ...
        done
        
        # 写成一行，适合与terminal终端使用,注意使用分号分开
        for var in item1 item2 ... ; do command1; command2;...;done;
        ```

    * >for循环的特殊用法：
        >
        >```bash
        >for ((变量初始化;条件判断语句;控制变量的语句)); do
        ># 循环语句
        >done
        >```

* while语句

    * ```shell
        int=1
        while(( $int<=5 ))
        do
            echo $int
            let "int++"
        done
        # 写成一行
        while condition;do command1;done;
        
        # 还可以用来读取键盘信息
        echo "按下^+c退出"
        while read INPUT;do command;done;
        
        # 无限循环的写法
        while :
        do
            command
        done
        # 或者for (( ; ; ))
        ```

    * >while语句的特殊用法：
        >
        >**逐行读取文件信息**
        >
        >```bash
        >while read VARIABLE;do
        ># 循环体
        >done << /PATH/TO/FILE
        >```

* until语句

    * ```shell
        # 直到until满足条件
        a=0
        until [ ! $a -lt 10 ]
        do
           echo $a
           a=`expr $a + 1`
        done
        ```

* case语句

    * ```shell
        case value in
        value1|value2|value3...)
        	command1
        	command2 ...
        	;;
        *)  # 其他值执行该分支
        	command ...
        	;;
        esac
        # 可以配合continue和break使用
        # case支持glob风格的通配符
        # ？任意单个字符	[]范围内任意字符	a|b a或者b
        ```

 # shell函数

*  shell 函数的两种定义方式

* ```shell
  1. function_name ()
  2. function function_name()
  ```

* shell 函数返回值

* ```shell
  # 使用return返回，返回0-255的整数
  return [0-255]  0代表成功，其他值代表失败
  或者使用echo来作为返回值
  ```

  * ```shell
    # 函数的使用和返回值
    functionDemo(){
    	command
    	echo "第一个参数 $1" ...
    	return $()...
    }
    #调用函数
    functionDemo para1 para2 ...
    # 接收返回值
    echo "$?"
    ```
    
#  库文件

* 库文件名的后缀是任意的，但一般使用`.lib`

* 库文件通常没有可执行权限

* 库文件无需和脚本在同级目录，只需在脚本中制定即可

* 库文件的第一行通常使用`#!/bin/echo`，输出警示内容，避免用户执行

* 库文件的引用

  * ```shell
    . /home/suofeiya/test/lib/base_function.lib    
    ```

#  文件搜索

* 常见四种文件搜索命令的使用场景

* ![1559042701316](/home/suofeiya/.config/Typora/typora-user-images/1559042701316.png)

* find

  * ```shell
    # find命令参数
    -print  打印输出，默认选项
    -exec  对搜索结果进一步处理
    	固定格式为 -exec 'command' {} \;
    逻辑运算符，与或非，-a,-o,-not|!
    -perm  按照文件权限进行搜索
    -prune  排除指定目录，通常与-path一同使用
    	例子：find . -path dir1/ -prune -o -path dir2/ -prune -o ...
    -type  按照文件类型进行搜索
    	find /tmp \( -type f -o -type d -o -type l \)  # 注意转义部分
    -mtime  按照文件时间进行搜索
    	-mtime +7 寻找七天之前的文件内容，`-`相反
    	类似还有-amin, -atime, -cmin, -ctime, -mmin
    	
    ```

    

* locate(不同于find，locate在数据库文件中查找，且属于部分查找)

  * ```shell
    具体查看man page
    ```

  * 手动更新命令，`updatedb`

    * 用户更新的文件是`/var/lib/mlocate/mlocate.db`
    * 所使用的配置文件是`/etc/updatedb.conf`

* whereis

  * ```shell
    # whereis 参数列表
    -b  返回二进制文件
    -m  返回帮助文件
    -s  返回source文件
    ```

* which

  * ```shell
    # which 只查找二进制文件
    ```

# 其他

* `dialog`可以实现窗口化变成

#  文件处理三剑客

* grep(文本过滤器,此外还有egrep和fgrep)

  * ```shell
    # 语法规则
    grep/egrep [option] [pattern] [file1] [file2] ...
    stdout | gerp/egerp
    ```

  * ```shell
    # grep 常用参数列表
    -v  匹配非pattern行信息
    -i  忽略大小写
    -n  显示行号
    -r  递归搜索
    -E  支持正则表达式扩展，等同于egrep
    -F  不按照正则表达式规则匹配，匹配原pattern本身表面意思
    -c  只匹配行的总数
    -w  匹配整个单词
    -x  匹配整行信息
    -l  只显示匹配的文件名，而不显示内容
    -s  不显示错误信息
    ```
    
  * 例子：

    * ```bash
      grep -v -E "(^#)|(^$)" test > test2			# 去除文件中以#开头的行和空白行，并输出为新文件
      ```

    * 

* sed( stream editor流编辑器)

  * ```shell
    # 语法规则，来自man page
    sed [OPTION]... {script-only-if-no-other-script} [input-file]...
    # 注意使用单引号
  ```
    
  * ```shell
    # sed 常用pattern模式
    9command  只匹配第九行内容
    8,9command  匹配第八行到第九行的内容
    9,+5command  匹配第九行到第十五行之间的内容
    /pattern1/command  匹配到pattern1的内容
    /pattern1/,/pattern2/command
    9,/pattern1/command
    /pattern1/,9command
    ```

  * ```shell
    # sed 编辑命令，与匹配模式巧妙使用
    p  打印（注意：-n选项和p命令一起使用表示只打印那些发生替换的行）
    a,i  分别表示行后（append）行前（insert）追加（每一行都进行添加）
    r,w  前置表示从外部文件读入，并且在其行后追加，后者代表将匹配的行写入到外部文件当中
    d  删除
    c 把匹配到的行替换为所要替换的文本
    s/old/new/g  修改所有	s/old/new  修改第一个	s/old/new/2g  修改第二个	s/old/new/ig	修改所有并且忽略大小写
    ```
    
  * ```shell
     # sed 选项
    -n  只打印模式匹配行*
    -e  直接在命令行中进行sed编辑，默认选项
    	sed -n -e '/pattern1/p' -e '/pattern2/p' test.txt（多个条件）
    -f  <script文件>或--file=<script文件> 以选项中指定的script文件来处理输入的文本文件
    -r  支持扩展正则表达式
    -i  直接修改文件内容
    ```
    
  * 例子：

     * ```bash
        sed -n '/hello/a sed' test			# 查找hello字符串并在其后面一行添加sed字符串
        sed '5,8c changed' test			
        # 使用扩展正则表达式
        sed -n -r 's/(HELLO=)java/\1sed' test			# 使用正则将前面HELLO=匹配到后面的字符串替换为sed
        ```

     * 

* awk

  * `awk`其实不仅仅是工具软件，还是一种编程语言，所以单独笔记，见`shell_awk.md`

