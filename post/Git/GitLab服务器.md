# GitLab环境部署

>GitLab官方下载安装教程：https://packages.gitlab.com/gitlab/gitlab-ce/install

1. 安装GitLab所依赖的包

```bash
 yum install -y curl policycoreutils-python openssh-server openssh-clients
```

2. 开机启用`sshd`

```bash
systemctl enabe sshd
systemctl start sshd
```

3. 使用yum安装`GitLab-ce`

```bash
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
yum install -y gitlab-ce.x86_64
```

# GitLab简单配置

修改GitLab配置文件`/etc/gitlab/gitlab.rb`

```bash
# 找到以下内容进行修改
####
external_url 'http://59.110.139.188'
...
unicorn['port'] = 8080
####
```

# GitLab启动与管理员账户

使GitLab配置生效：

```bash
gitlab-ctl reconfigure
```

开启Gitlab，设置开机启动：

```bash
gitlab-ctl start
systemctl enable gitlab-runsvdir
```

**管理员账户初始化：**

1. 初始化密码，需要使用root身份

```bash
 gitlab-rails console production
```

2. 在弹出的交互式界面中输入`u=User.where(id:1).first`，来查找与切换账号（使用User.all 可以查看所有用户）

```bash
 irb(main):001:0>　 u=User.where(id:1).first 
```

3. 通过`u.password='PASSWD'`来设置密码

```bash
irb(main):002:0> 	u.password='suofeiya'
```

4. 然后通过`u.password_confirmation='PASSWD' `再次确认密码

```bash
u.password_confirmation='suofeiya'
```

5. 最后使用以下命令来进行保存

```bash
irb(main):004:0> u.save!			# 注意最后面的英文感叹号不可少
Enqueued ActionMailer::DeliveryJob (Job ID: 8b588cf2-f718-4770-b154-b1f142384b70) to Sidekiq(mailers) with arguments: "DeviseMailer", "password_change", "deliver_now", #<GlobalID:0x00007f9dfec8b088 @uri=#<URI::GID gid://gitlab/User/1>>
=> true					# 出现true就表示保存成功
# 执行exit指令退出交互式界面
irb(main):005:0> exit
```

# GitLab英文汉化

1. 下载汉化tar包：https://gitlab.com/xhang/gitlab.git，需要注意的一点是应当下载和当前服务器上GitLab英文版相同的版本
2. 解压之后可以通过`cat gitlab-<VERSION>-zh/VERSION`查看中文包的版本
3. 备份原来的英文版

```bash
cp -r /opt/gitlab/embedded/service/gitlab-rails{,.bak}
```

4. 使用汉化包覆盖英文版

```bash
cp -rf gitlab-v10.7.0-zh/* /opt/gitlab/embedded/service/gitlab-rails/
```

5. 最后重新配置GitLab，重启即可

```bash
gitlab-ctl reconfigure
gitlab-ctl restart
```

# GitLab其他

## × GitLab网页端报错502解决方案

