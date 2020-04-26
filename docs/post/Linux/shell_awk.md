> **This is shell_awk StudyNote.**

# 基本格式

* ```bash
  awk 动作 文件名
  awk 'BEGIN{}/pattern(REGEX)/{commmand}END{}'
  # 示例1
  awk '{print $0}' test  # $0代表当前行，因此上面命令的执行结果，就是把每一行原样打印出来
  # 示例2
  echo 'this is a test' | awk '{print $0}'  # 使用标准输出
  # 示例3
  awk 'BEGIN{NF=":"}{print $2}' filename	# 使用BEGIN对文件进行预处理
  ```
  
* ```bash
  $1、$2、$3代表第一个字段、第二个字段、第三个字段等等，其默认分隔符为空格或者是TAB
  awk -F ':' '{ print $1,$2 }'  # 使用-F 选项可以自定义分隔符
  # 多个字段之间使用逗号分开或者空格分开，效果不一样。
  ```
# 模式匹配

* ```bash
  # 两种模式匹配方式
  # 第一种，使用正则表达式
  awk '/[REGEX]/{print $0}' test
  # 第二种，使用关系运算符，>,<,<=,>=,==,~(匹配regex),!~(不匹配regex的行信息)
  # 逻辑运算符，与或非，&&,||,!
  awk '$3>50{print $0}' test  # 输出第三个字段长度大于50的所有行信息
  awk '$3=="test"{print $0}' test  # 输出第三个字段和test相同的所有行信息
  awk '$3~/[0-9]{3}/{print $0}' test # 输出第三个字段符合正则的所有行信息
  awk '$3<29&&$2>213{print $0}' test 
  ```

#  变量

* `$ + 数字`表示某个字段，变量`NF`表示当前行有多少个字段，因此`$NF`(Number Field)就代表最后一个字段

  * ```bash
    awk '{print NF, $(NF-1)}' test
    3 java
    3 python
    4 feiya
    ```

* 变量`NR`(Number row)表示当前处理的是第几行，类似还有`FNR`

  * ```bash
    awk -F/FS ':' '{print NR ") " $1}' test  # 若要将字符原样输出需要加入双引号
    1) 001 hello ja提供了一些内置函数，方便对原始数据的处理。
    2) 004 hello suo feiya
    ```

* 其他内置变量

  * ```bash
    FNR(file number field): 单独输出每个文件的行号
    FILENAME：当前文件名
    	awk '{print FILENAME}'
    FS(field separator)：字段分隔符，默认是空格和制表符，也可以是空格和tab的混合。
    RS(row sepatator)：行分隔符，用于分割每一行，默认是换行符。
    	awk 'BEGIN{RS="---"}{print $0}' FILENAME
    OFS(output FS)：输出字段的分隔符，用于打印时分隔字段，默认为空格。
    ORS(output RS)：输出记录的分隔符，用于打印时分隔记录，默认为换行符。
    OFMT：数字输出的格式，默认为％.6g。
    ARGC:命令行参数个数
    ARGV:命令行参数数组
    ```
    
# array

* `awk` 中的数组与`shell`中的数组有些许不同

* awk数组写法

  * ```bash
    # awk中的数组元素可以不连续
    awk 'BEGIN{array[0]="suofeiya";array[1]="hello";array[2]="world";print array[0]}'
    # awk数组可以使用键值对
    awk 'BEGIN{array["hello"]="suofeiya";print array["hello"]}'
    ```

* ```bash
  # 遍历数组
  for(a in array)
  	print array[a]
  ```

* 可以使用`if index in array[index]`来判断是否存在相应的元素

#  格式化输出printf

* ```bash
  # 格式符
  %f 浮点数
  %x 16进制数字
  %o 8进制数
  %e 使用科学计数法
  %c 打印单个字符的ASCII码
  # 左右对齐
  -  左对齐
  +  右对齐
  \# 显示在八进制前面加上0，十六进制前面加上0x 
  ```

* ```bash
  # 基本使用方法
  awk '{printf "%-10s  %-20s\n",$1,$3}' test
  awk '{printf "%#x",$1}' test
  ```

# 函数

* 简单举例

  * ```bash
    # 使用awk内置函数toupper()将内容转换为大写
    awk '{print toupper($0 }' test
    ```

* 其他内置函数

  * ```bash
    tolower()：字符转为小写
    length()：返回字符串长度
    substr()：返回子字符串
    sin()：正弦
    cos()：余弦
    sqrt()：平方根
    rand()：返回一个0-1之间的随机数
    ```

  * 完整函数手册：<https://www.gnu.org/software/gawk/manual/html_node/Built_002din.html#Built_002din>

# 条件

* 格式：` awk '条件 动作' 文件名`

  * ```bash
    # print命令前面是一个正则表达式，只输出包含awk的行
    awk '/awk/ {print $0}' test
    ```

  * ```shell
    # 只输出奇数行内容
    awk 'NR % 2 == 1 {print $0}' test
    # 输出第二行以后的内容
    awk 'NR > 2 {print $0}' test
    ```


# if语句

* ```bash
  awk '{if ($1 > "m") print $1}' test
  awk '{if ($1 > "m") print $1; else print "---"}' test
  ```

# 选项

* `-v`引入外部变量，多个变量之间要多次使用`-v`参数

  * ```bash
    var1="hello world"
    var2=123
    awk -v var1="$var1" -v var2=$var2 'BEGIN{print var1 var2}'
    ```

* `-f`引入外部含有`awk`的命令文件

* `-F`指定文件分隔符

# 其他

* 使用`print`打印多个变量时，中间使用逗号和空格分开不同，前者会自动将output加上空格，后者不会

# 例子

* ```bash
  awk '{print NR,$0}' test			# 打印文件行号
   awk '/9/{print $0}' test 			# 模式匹配
	awk '{print "'\''"$0"'\''"}' test			# 在每一行的行首和行尾添加单引号
  awk '($2 >=9000){print $1, "high"}' test
  cat del2 | awk -F 'len:' 'BEGIN {sum=0} {sum += $2} END {print sum}' 
  awk 'END{print NR}' filename			# 打印总文件行数
  awk -F: 'BEGIN{print "username","bash_type"} {print $1,$NF}[9/9]
  print "===END==="}' passwd
  
   cat test | awk -F '/+' '{print $2}' | sort | uniq -c   			# 统计重复内容出现的次数
   cat test | awk -F '/+' '{h[$2]++} END{for (i in h) print i,h[i]} ' 	# 方法二
  
  ```
  
* 

# 参考链接

- [An Awk tutorial by Example](https://gregable.com/2010/09/why-you-should-know-just-little-awk.html), Greg Grothaus
- [30 Examples for Awk Command in Text Processing](https://likegeeks.com/awk-command/), Mokhtar Ebrahim