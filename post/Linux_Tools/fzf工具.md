# fzf简介与安装

`fzf`是一个：

* 命令行文本增强工具
* 终端-模糊查找神器
* 作为Vim插件工具

>开源地址： https://github.com/junegunn/fzf

## 安装与升级

使用git安装与升级：

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
# 升级
cd ~/.fzf && git pull && ./install
```

在Debian系操作系统中：

```bash
sudo apt install fzf -y
```

# fzf简单使用

fzf默认会从STDIN读入数据，然后将结果输出到STDOUT

```
find * -type f | fzf > selected
```

上面命令从find的搜索结果中读入，输出到文件selected中

## 终端快捷键

* `Ctrl+T`：查找目录下的所有文件
* `Ctrl+R`：查找历史命令，再次按下`Ctrl+R`可以切换时间排序和相关性排序
* `Alt+C`：列出当前文件夹下的目录，选中条目会自动进入到相应目录

