# Git submodule

## 场景

项目中经常使用别人维护的模块，在git中使用子模块的功能能够大大提高开发效率，使用子模块后，不必负责子模块的维护，只需要在必要的时候同步更新子模块即可。

当一个项目需要包含其他支持项目源码时使用的功能，作用是两个项目是独立的，且主项目可以使用另一个支持项目。

## 使用

### 子模块的添加 

添加一个子项目：

```bash
# git submodule add <url> <path>		url为子模块的路径，path为该子模块存储的目录路径
git submodule add https://github.com/AGou-ops/test.git .
# 此时会从远程仓库克隆，使用ls命令查看
➜  main git:(master) ✗ ls                         
test/
```

添加子项目后会出现`.gitmodules`的配置文件

### 子模块的使用

```bash
git submodule init
git submodule update
# 或者使用
git submodule update --init --recursive
```

如果获取的项目包含submodules，pull main project的时候不会同时获取submodules的源码，需要执行本地`.gitmodules`初始化的命令，再同步远端submodule源码。如果希望clone main project的时候包含所有submodules，可以使用下面的命令：

```bash
git clone --recurse-submodules <main_project_url> 		 # 获取主项目和所有子项目源码
```

拉取上传更新子模块：

```shell
git fetch		  # 获取submodule远端源码
git merge origin/<branch_name>  		# 合并submodule远端源码
# 或者直接使用
git pull		  # 获取submodule远端源码合并到当前分支
# 上传子模块使用git push即可

# 更新子模块
# 更新submodule源码，默认更新的branch是master，如果要修改branch，在.gitmodule中设置
git submodule update --remote <submodule_name>  
# 更新所有submodule源码，默认更新.gitmodule中设置的跟踪分支，未设置则跟踪master
git submodule update --remote  
```

子模块配置文件`.gitmodules`内容：

```bash
[submodule <submodule_name>]
    path = <local_directory>
    url = <remote_url>
    branch = <remote_update_branch_name>
```

## 实例submodule应用

本例采用**两个项目**以及**两个子模块库**演示对submodule的操作。

### 环境准备

创建测试所需的本地库：

```bash
mkdir submodule/repos -p && cd submodule/repos
git --git-dir=lib1.git init --bare
git --git-dir=lib2.git init --bare
git --git-dir=project1.git init --bare
git --git-dir=project2.git init --bare
```

创建工作区：

```bash
mkdir  submodule/workspace
```

### 初始化项目

```bash
# 初始化项目1
git clone ../repos/project1.git
cd project1
echo "project1" > project1
git add project1
git commit -m "init project1"

# 初始化项目2
git clone ../repos/project2.git
cd project2
echo "project2" > project2
git add project2
git commit -m "init project2"
```

### 初始化子模块

```bash
# 初始化子模块库1
 git clone ../repos/lib1.git 
 cd lib1
 echo "lib1" > lib1
git add lib1
git commit -m "init lib1"
git push origin master

# 初始化子模块库2 。。。和前面一样，在此就不赘述
```

### 为项目添加子模块库

```bash
cd project1
➜  project1 git:(master) ls                                             15:31:57
project1
# 添加子模块库1
➜  project1 git:(master) git submodule add ~/tmp/submodule/repos/lib1.git/ libs/lib1
Cloning into '/home/suofeiya/tmp/submodule/workspace/project1/libs/lib1'...
done.
# 添加子模块库2
➜  project1 git:(master) git submodule add ~/tmp/submodule/repos/lib2.git/ libs/lib2
Cloning into '/home/suofeiya/tmp/submodule/workspace/project1/libs/lib2'...
done.
# 查看结果
➜  libs git:(master) ✗ ls                                               15:45:21
lib1/  lib2/
```

会发现项目中新增了一个`.gitmodules`文件，该文件用于记录子模块的有关信息：

```bash
➜  project1 git:(master) ✗ cat .gitmodules                              15:55:59
[submodule "libs/lib1"]
        path = libs/lib1
        url = /home/suofeiya/tmp/submodule/repos/lib1.git/
[submodule "libs/lib2"]
        path = libs/lib2
        url = /home/suofeiya/tmp/submodule/repos/lib2.git/
```

现在，将更改提交到仓库中：

```bash
➜  project1 git:(master) ✗ git commit -a -m "add submodules lib1 and lib2"
[master 3ed80fb] add submodules lib1 and lib2
 3 files changed, 8 insertions(+)
 create mode 100644 .gitmodules
 create mode 160000 libs/lib1
 create mode 160000 libs/lib2
# 推送到仓库
➜  project1 git:(master) git push origin master                         16:00:55
Counting objects: 7, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (7/7), 668 bytes | 668.00 KiB/s, done.
Total 7 (delta 0), reused 0 (delta 0)
To /home/suofeiya/tmp/submodule/workspace/project1/../../repos/project1.git
 * [new branch]      master -> master
```

。。。



> 参考cnblog@lsgxeva，并做些许修改