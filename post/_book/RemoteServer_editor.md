####  使用`vscode`＋`Remote VSCode`插件实现远程在线编辑服务器上的文件

```bash
# 打开vscode安装remote VScode插件
# 在服务器中执行以下命令
sudo wget -O /usr/local/bin/rmate https://raw.github.com/aurora/rmate/master/rmate
sudo chmod a+x /usr/local/bin/rmate
# 返回VScode，打开命令窗口，并执行以下命令：
	>Remote: Start Server
# 然后在vscode的终端中执行以下命令：
ssh -R 52698:localhost:52698 [username@your remote ip]
# 最后执行rmate命令来编辑你想编辑的文件，例如：
rmate /usr/local/websesrver/html/index.html
```



 