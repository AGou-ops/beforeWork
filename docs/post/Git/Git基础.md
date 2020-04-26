> **This is Git命令 StudyNote.**

#  基础设置

**全局配置文件：`~/.gitconfig`**

设置全局登录信息：

```bash
git config --global user.name "YOURUSERNAME" 
git config --global user.email "YOUREMAIL"
```

如果只想对当前项目设置登录信息的话，去掉`--global`参数即可

设置无密码SSH-KEY登录：

```bash
# 在用户家目录的.ssh目录中生成id_rsa和id_rsa.pub这两个文件
ssh-keygen -t rsa -C "youremail@example.com"

* 接下来打开Github的相关配置页导入`id_rsa.pub`文件内容

# 检查是否可用
ssh -T git@github.com
```

配置别名：

```bash
# 将status起个别名为st，此时就可以使用git st来查看工作区状态了
git config --global alias.st status
git config --global alias.lone 'log --oneline'
```

# Git版本管理

## 版本回退

### git reset

1. 使用`git log`可以查看当前提交情况：

```bash
➜  git git:(master) git log                                          
commit dadac050104f374d34d7257779ab958e86a578cb (HEAD -> master)
Author: AGou-ops <suofeiyaxx@gmail.com>
Date:   Wed Dec 4 18:45:58 2019 +0800

    INIT test file with 4..

commit 5826c364bbbd7976bd7ab23e77256a8c44db37e6
Author: AGou-ops <suofeiyaxx@gmail.com>
Date:   Wed Dec 4 18:45:15 2019 +0800

    INIT test file with 1..2..3
```

如果觉得输出结果太乱太杂可以加上`--pretty-oneline`参数或者短`commit hash`前七位的`--oneline`参数：

```bash
➜  git git:(master) git log --pretty=oneline                          
dadac050104f374d34d7257779ab958e86a578cb (HEAD -> master) INIT test file with 4..
5826c364bbbd7976bd7ab23e77256a8c44db37e6 INIT test file with 1..2..3
➜  git git:(master) git log --oneline                                  
5826c36 (HEAD -> master) INIT test file with 1..2..3
# 或者使用文字图形化界面来显示
➜  git git:(master) git log --graph
```

2.  现在我想将版本回退到`INIT`版本，可以使用：

```bash
➜  git git:(master) git reset --hard HEAD^                              
HEAD is now at 5826c36 INIT test file with 1..2..3
* 注意：一个脱字符`^`代表回退一个版本，回退两个版本使用`HEAD^^`即可
```

当然可以使用` HEAD~n`来回退一个或者多个版本，其中`n`表示回退的版本数

**但我觉得比较好用的是使用`commit hash-id`号来进行版本的精确回退或者前进**

3. `git reflog`命令可以记住你每一次的提交和版本切换请求：

```bash
➜  git git:(master) git reflog          
5826c36 (HEAD -> master) HEAD@{0}: reset: moving to HEAD^
dadac05 HEAD@{1}: commit: INIT test file with 4..
5826c36 (HEAD -> master) HEAD@{2}: commit (initial): INIT test file with 1..2..3
```

>拓展参考资料：
>
>`git log`详解：https://blog.csdn.net/jjlovefj/article/details/86476925
>
>`git log` 官方文档：https://git-scm.com/docs/git-log
>
>`git reset`的三种模式：https://www.jianshu.com/p/c2ec5f06cf1a

### git revert

`git revert`是用于“反做”某一个版本，以达到撤销该版本的修改的目的。

**适用场景：**如果我们想撤销之前的某一版本，但是又想保留该目标版本后面的版本，记录下这整个版本变动流程，就可以用这种方法，这正是和`reset`不同的地方.

比如，我们commit了三个版本（版本一、版本二、 版本三），突然发现版本二不行（如：有bug），想要撤销版本二，但又不想影响撤销版本三的提交，就可以用 git revert 命令来反做版本二，生成新的版本四，这个版本四里会保留版本三的东西，但撤销了版本二的东西，在这里将问题简化如下：

1. 提交三次，对应版本分别为`version 1..2..3`

```bash
➜  test02 git:(master) git log --oneline   
74c4ae3 (HEAD -> master, tag: v3.0) publish version 3
46ed99f (tag: v2.0) publish version 2
4bb0e96 (tag: v1.0) publish version 1
```

2. 因为某些原因我不想要版本二`v2.0`，此时，就可以通过`revert`版本二来实现，这里使用`-n`参数加上`commit id`

```bash
➜  test02 git:(master) git revert -n 46ed99f  
```

反做时，可能会有冲突发生，那么就需要手动解决冲突

3. 提交修改

```bash
➜  test02 git:(master)  git add .
➜  test02 git:(master)  git commit -m "remove version 2"
```

至此，`revert`就完成了.

## 管理修改

撤销工作区的修改有两种方式：

* 一种是自文件修改后还没有被放到暂存区，撤销修改就回到和版本库一模一样的状态
* 另一种是文件已经添加到暂存区后，又作了修改，撤销修改就回到添加到暂存区后的状态

```bash
git checkout -- test
* 需要注意的是：`--`不可少，且前后都要有空格
```

删除文件：

```bash
# 如果你确定删除本地工作区的某个文件，可以直接使用rm命令来删除
rm hello
# 如果你只想删除仓库中的某个或者某些文件，可以使用以下命令
➜  git git:(master) git rm hello                                        
rm 'hello'
# 查看当前状态
➜  git git:(master) ✗ git status                                        
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        deleted:    hello
```

# Git分支管理

## 创建查看切换合并删除分支

创建一个`dev`分支，并切换至`dev`分支

```bash
git checkout -b dev
# 这条命令相当于
git branch dev
git checkout dev

# 新版本的可以使用switch来创建切换分支
# 创建并切换至dev分支
git switch -c dev
```

查看分支

```bash
# 查看当前分支
git branch
# 查看所有分支
git branch -a
```

修改完当前分支切换为主分支或者其他分区

```bash
git checkout master
# 或者使用switch切换分支
git switch dev
```

合并`dev`分支上的修改

```bash
git merge dev
```

删除`dev`分支

```bash
git branch -d dev
```

强制删除分支

```bash
* 使用场景之一：为产品添加一个新功能，新功能分支进行到一半突然被告知要取消该功能的开发，此时该分支还未合并到主分支，需要进行删除，而使用`-d`删除分支会报错从而无法删除，所以此时就需要强制删除分支
git branch -D dev
```

## 分支管理策略

通常，合并分支时，如果可能，Git会用`Fast forward`模式，但这种模式下，删除分支后，会丢掉分支信息。如果要强制禁用`Fast forward`模式，Git就会在merge时生成一个新的commit，这样，从分支历史上就可以看出分支信息

例如：在`dev`分支上做了些许修改，然后切换至`master`分支合并`dev`

```bash
git merge --no-ff -m "merge with no-ff" dev
```

查看分支情况

```bash
➜  test git:(master) git log --graph --pretty=oneline --abbrev-commit                                                        
*   8c19649 (HEAD -> master) merge with no-ff
|\
| * 17ae26b (fun2) some change in README on fun2 branch
|/
*   e5e20a0 fix conflict
|\
| * 1f22afc changes in README
* | 913ffd6 changes in README
|/
* 0bef827 Add branch_dev
* f377044 (origin/master, origin/HEAD) Add README
```

可以明显看到一次合并分支的提交

## BUG分支

在Git中，每个bug都可以通过一个新的临时分支来修复，修复后，合并分支，然后将临时分支删除。

当你开发时临时接到一个修复bug分支的任务时，此时你会创建一个`issue-01`分支来修复它，但是此时你在当前分支上的任务还未提交。

```bash
➜  test git:(fun2) ✗ git status 
On branch fun2
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   branch_dev

no changes added to commit (use "git add" and/or "git commit -a")
```

这时，你就可以使用Git的`stash`功能来暂停并隐藏当前分支上的工作：

```bash
➜  test git:(fun2) ✗ git stash 
Saved working directory and index state WIP on fun2: 17ae26b some change in README on fun2 branch
```

可以看到当前工作区的修改已经被隐藏了起来

接下来，就可以愉快的修复BUG了：

```bash
# 确定在那个分支上修复BUg
git checkout master
# 创建BUG分支
git checkout -b issue-01

# 修复BUG
...
# 提交修复BUG的修改
...
# 切换到master主分支完成合并
git merge --no-ff -m "merged fix bug 01" issue-01
```

搞完之后，就可以回到自己的工作分支继续工作了：

```bash
➜  test git:(fun2) git status                                                                                                         
On branch fun2
nothing to commit, working tree clean
# 列出之前所保存的工作区信息
➜  test git:(fun2) git stash list
stash@{0}: WIP on fun2: 17ae26b some change in README on fun2 branch
```

可以看到工作现场还在，但是需要手动恢复一下，有两种方法：

* 使用`git stash apply`恢复，但是恢复之后，stash的内容并不会被删除，需要手动使用`git stash drop`来删除
* 使用`git stash pop`，恢复的同时把stash内容也顺便删了

## Git Rebase

**应用场景一：**用于合并多次提交记录，也就是每一次功能开发， 对多个 commit 进行合并处理

1. 合并最近3次的提交记录

```bash
 git rebase -i  [startpoint]  [endpoint]
* 注意：其中`-i`的意思是`--interactive`交互式修改，[startpoint]和  [endpoint]指定了一个编辑区间，如果不指定[endpoint]，则默认会使用当前HEAD指针处的commit提交
➜  test01 git:(master) git rebase -i HEAD~3
Successfully rebased and updated refs/heads/master.

# 或者使用以下命令可以达到相同的效果
git rebase -i 0ad1d42
```

2. 这时，会自动进入`vi`编辑模式，然后进行相应修改即可，这里需要注意的一些命令：

```bash
pick：保留该commit（缩写:p）
reword：保留该commit，但我需要修改该commit的注释（缩写:r）
edit：保留该commit, 但我要停下来修改该提交(不仅仅修改注释)（缩写:e）
squash：将该commit和前一个commit合并（缩写:s）
fixup：将该commit和前一个commit合并，但我不要保留该提交的注释信息（缩写:f）
exec：执行shell命令（缩写:x）
drop：我要丢弃该commit（缩写:d）
```

3. 如果你保存时异常退出了或者保存退出是出现了错误，你可以使用`git rebase --edit-todo`来重新修改提交，这时你将一直处于编辑模式中，可以使用`git rebase --continue`回去继续进行编辑操作
4. 使用`git log`查看提交合并后的效果

**应用场景二：**合并分支

使用`merge`来合并分支时会新增一条提交记录，但是有时候我们觉得这样的提交记录并无卵用，这时如果我们想要保持一个清洁的commit环境，就得使用`rebase`了

场景：![](/home/suofeiya/myGitbook/images/git%20rebase01-1575858760087.png)

一个项目，当前你正在开发`feature1`分支，但此时`master`主分支上急有一个BUG需要修复，你的另外一个同事修复完该BUG后进行了一次提交，此时`master`分支已经领先于你当前的`feature1`分支

在`feature`分支上使用`rebase`合并：

```bash
git rebase master
```

`rebase`具体进行的操作：

1. `git` 会把 `feature1` 分支里面的每个 `commit` 取消掉

2. 把上面的操作临时保存成 `patch` 文件，存在 `.git/rebase` 目录下

3. 把 `feature1` 分支更新到最新的 `master` 分支

4. 把上面保存的 `patch` 文件应用到 `feature1` 分支上



-- **取消rebase操作使用`git rebase --abort`** 命令--

 ## 远程分支管理

查看远程库的信息，使用`git remote`，使用`-v`可以显示详细信息

```bash
➜  test git:(master) git remote -v  
origin  https://github.com/AGou-ops/test.git (fetch)
origin  https://github.com/AGou-ops/test.git (push)			# 如果没有push权限，看不到该行内容
```

推送分支

```bash
git push origin [BRANCH_NAME]
```

协同开发`dev`分支

```bash
# 拉取远程分支
git clone https://github.com/AGou-ops/test.git
# 此时只能看到`master`分支
# 如果想要在dev分支上进行开发，就必须创建远程`origin`的`dev`分支
git checkout -b dev origin/dev
# 此时就可以愉快的进行开发了O(∩_∩)O~~
```

拉取指定分支

```bash
git clone -b BRANCH_NAME <REPO>
```

删除远程分支

```bash
git push origin --delete [branchname]
```

# Git标签管理

## 创建标签

1. 首先切换到要打标的分支，然后使用`tag`就可以打一个标签

```bash
➜  test01 git:(dev) git checkout master 
Switched to branch 'master'
Your branch is up to date with 'origin/master'.

➜  test01 git:(master) git tag v1.0
```

2. 如果你想要为以前的某个时间点的某个提交打标签的话，只需记住要打标的`commit id`即可

```bash
git tag v0.9 f37704406a57769df47ef8f4128ced31b89726bb			# 长短提交id都可以
```

3. 使用`git tag`来查看所有标签，默认的标签是在最新的commit基础上进行的

**需要注意的一点是**：标签的先后顺序不是以时间排序的，而是按照字母排序的.

4. 使用`git show <TAG_NAME>`来查看标签的详细信息

```bash
➜  test01 git:(master) git show v1.0 
commit f65818b4a8a4f665b2ac9c9598be06971c04f129 (HEAD -> master, tag: v1.0, origin/master, origin/HEAD)
Author: AGou-ops <suofeiyaxx@gmail.com>
Date:   Mon Dec 9 09:34:10 2019 +0800

    add 222 for commit_record

    add 333 for commit_record

    add 111 for commit_record

diff --git a/commit_record b/commit_record
index 5f2f16b..06539be 100644
--- a/commit_record
+++ b/commit_record
@@ -1 +1,6 @@
 1111
+<<<<<<< HEAD
+2222
+3333
+=======
+>>>>>>> 0ad1d42... add 111 for commit_record
```

5. 此外，还可以创建带有说明的标签，用`-a`指定标签名，`-m`指定说明文字

```bash
➜  test01 git:(master) git tag -a v0.91 -m "v0.91" 0bef827

➜  test01 git:(master) git show v0.91                                                                                                    11:13:09
tag v0.91
Tagger: AGou-ops <suofeiyaxx@gmail.com>
Date:   Mon Dec 9 11:13:06 2019 +0800

v0.91			# 这里就是打标时的信息

commit 0bef8272562bb96ba4b5a18196eb43773587f618 (tag: v0.91)
Author: AGou-ops <suofeiyaxx@gmail.com>
Date:   Sun Dec 8 20:39:06 2019 +0800

    Add branch_dev

diff --git a/branch_dev b/branch_dev
new file mode 100644
index 0000000..0ad9642
--- /dev/null
+++ b/branch_dev
@@ -0,0 +1 @@
+some changes on dev branch.
```

## 删除本地或远程标签

删除本地标签：`git tag -d <TAG_NAME>`

推送本地标签到远程仓库：`git push origin <TAG_NAME>`

一次性推送所有本地标签到远程仓库：`git push origin --tags`

如果标签已经推送到远程，先从本地删除，然后在从远程删除：`git push origin :refs/tags/<TAG_NAME>`

# .gitignore文件

>GitHub官方提供的有用的.gitignore模板文件：https://github.com/github/gitignore

`.gitignore`用于忽略特殊文件.

忽略文件的原则是：

1. 忽略操作系统自动生成的文件，比如缩略图等；
2. 忽略编译生成的中间文件、可执行文件等，也就是如果一个文件是通过另一个文件自动生成的，那自动生成的文件就没必要放进版本库，比如Java编译产生的`.class`文件；
3. 忽略你自己的带有敏感信息的配置文件，比如存放口令的配置文件。

你想添加一个文件，但是提示`The following paths are ignored by one of your .gitignore files ...`，如果你确实想要添加该文件到Git中去，那么你就可以使用`-f`强制添加：

```bash
git add -f test.class
```

或者你发现，可能是`.gitignore`写得有问题，需要找出来到底哪个规则写错了，可以用`git check-ignore`命令检查：

```bash
➜  test01 git:(master) ✗ git check-ignore -v ignore.file
.gitignore:1:*.file     ignore.file
```

# Git其他











































### git pull 撤销误操作

本来想把github上的newpbft合并到本地的newpbft分支上，由于没有查看当前分支，直接运用git pull origin newpbft，结果将newpbft合并到了master分支中。
解决方法：  
1、运行git reflog命令查看你的历史变更记录  
2、然后用git reset --hard HEAD@{n}，（n是你要回退到的引用位置）回退。