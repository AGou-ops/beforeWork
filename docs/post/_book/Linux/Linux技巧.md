>  **This is Linux技巧StudyNote.**

## 免密码登录远程服务器

```bash
$ ssh-keygen -t rsa -P '' -f ~/.ssh/aliyunserver.key
$ ssh-copy-id -i ~/.ssh/aliyunserver.key.pub root@192.168.182.112 # 这里需要输入密码一次
```

编辑 `~/.ssh/config`

```bash
Host aliyun
  HostName <IP_ADDR>
  User root
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/aliyunserver.key
```

此时，你就可以直接通过`ssh aliyun`而无需账户密码登录.

























































* ###  `curl cheat.sh`	简洁的命令说明

* ```bash
  # 将manpage转换成html或者是pdf格式,以便学习(中文翻译)
  
  # 安装man2html,转换为html,结合whereis和find命令找到manpage位置
  man2html [该命令的manpage文件路径] > [重定向到目标html文件]
  # 使用ps2pdf转换成pdf文件
  man -t [命令名称] | ps2pdf - [文件路径.pdf]
  ```
  
* ###  使用`systemd-analyze blame` 命令来查看Linux系统启动各部分所需要的时间



