# 命令笔记

## 系统相关



## 日志相关



## 安全相关

- `w -u`：查询当前当前用户和所运行的程序等信息，类似命令`whoami`或者`who am i`；
- `last`：显示用户最近登录信息。如果没有指定任何参数，则显示所有用户的历史信息。在默认情况下，这些所显示的信息将来源于` /var/log/wtmp `文件；
- `lastlog`：用于查看系统中每个用户最后的登录时间，指定用户使用`-u`选项，指定最近几天的记录，使用`-t`选项；

## 工作效率

- `fc`：用于编辑最后一条命令并保存之后自动执行该命令，应用场景，运行了一大段命令但因为一个符号或者字母输错导致命令失败，快速编辑；
- `disown -a `：将任务从"后台任务"列表(jobs命令的返回结果)之中移除,阻止当前 shell 在终止登录会话时向每个指定作业发送 HUP 信号（为啥我Ubuntu18不能用？）；
- `Ctrl + X + E`终端快捷键：打开编辑器输入命令并自动执行该命令，应用场景，一次运行多条长命令（若果运行时发生报错或者其他问题，需要在`/etc/bashrc`中添加变量`EDITOR=vim`即可）；
- `命令前加空格`：隐藏所运行的命令，使其不被记录到历史命令中（6，一直没发现）；
- `!!`：调用最近一次命令（感觉没什么乱用）；
- 