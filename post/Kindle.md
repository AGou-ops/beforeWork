> **This is Kindle-越狱 StudyNote.**

### [Kindle伴侣官网：https://bookfere.com](https://bookfere.com/)
### [Kindle详细介绍以及越狱方法(Kindle ver5.6.5)](https://bookfere.com/post/307.html)
---
**以下内容节选自Kindle伴侣:**
# 越狱操作步骤

越狱操作分为两部分进行。第一部分会用到 jb.zip 文件，第二部分会用到 JailBreak-1.14.N-FW-5.x-hotfix.zip 文件。请按照下面所列步骤一步一步地操作，注意不要有遗漏哦！

## 第一部分

第一部分操作有两种方式，方法一无需联网即可在本地完成，方法二需要在联网状态下进行。可根据你的需要选择。

**方法一（本地模式）：**

1. 用 USB 数据线把 Kindle 连接到电脑，直到出现 Kindle 盘符；
2. 把下载到的 **jb.zip** 解压缩，得到 **jb** 文件夹，把里面的所有文件拷贝到 **Kindle 根目录**下；
3. 从电脑弹出 Kindle。然后点击 Kindle 右上角的菜单键，打开“**体验版网页浏览器**”；
4. 怕强制升级请开启飞行模式。点击地址栏调出键盘，在地址栏中输入 `**file:///mnt/us/index.html**`；
5. 在打开的页面中，点击底部的【I Agree】按钮，切换到另外一个页面；
6. 先点击页面下方的链接 **Stage1**，看到出错页面后点击“**返回按钮**”返回；
7. 再点击页面下方的链接 **Stage2**，当看到顶部状态栏出现“`**Run ;fc-cache in the search bar.**`”时，点击“**搜索按钮**”，并输入“`**;fc-cache**`”（只输入标识为红色的字符，别漏掉分号“；”），回车；
8. 当你看到“`**Jailbreak succeeded!**`”的提示信息，即表示操作成功。

**方法二（联网模式）：**

1. 用 USB 数据线把 Kindle 连接到电脑，直到出现 Kindle 盘符；
2. 把下载到的 **jb.zip** 解压缩，得到 **jb** 文件夹，把里面的 **jb 文件**拷贝到 **Kindle 根目录**下（千万注意！是把 **jb 文件**放到 Kindle 根目录，不是 jb 文件夹哦！）；
3. 从电脑弹出 Kindle。然后点击 Kindle 右上角的菜单键，打开“**体验版网页浏览器**”；
4. 点击地址栏调出键盘，在地址栏中输入网址 `**https://bookfere.com/jb**`，回车；
5. 在打开的页面中，点击底部的【I Agree】按钮，切换到另外一个页面；
6. 先点击页面下方的链接 **Stage1**，看到出错页面后点击“**返回按钮**”返回；
7. 再点击页面下方的链接 **Stage2**，当看到顶部状态栏出现“`**Run ;fc-cache in the search bar.**`”时，点击“**搜索按钮**”，并输入“`**;fc-cache**`”（只输入标识为红色的字符，别漏掉分号“；”），回车；
8. 当你看到“`**Jailbreak succeeded!**`”的提示信息，即表示操作成功。

*** 提示 jailbreak failed 错误，或操作失败了怎么办？**

对于第一部分经常误解的，在这里再提示一下。首先请确认已经把解压 jb.zip 得到的 **jb 文件**（就是解压后文件夹内除三个 html 文件之外的那个 jb 文件）放到了 **Kindle 根目录**（不是 documents 目录，而是和 documents 目录同级别的位置）。如果操作确实没有问题，请重置一下 Kindle 再重试。

另外，对于之前曾越狱成功的 Kindle，如果因为某种原因进行过**重置**操作或者自动/手动升级固件造成越狱失效的。请略过上面第一部分的步骤，直接进行下面的第二部分的步骤即可恢复。

## 第二部分

1. 用 USB 数据线把 Kindle 连接到电脑，直到出现 Kindle 盘符；
2. 解压缩下载到的 ZIP 压缩包 **JailBreak-1.14.N-FW-5.x-hotfix.zip**，得到一个名为 **Update_jailbreak_bridge_1.14.N_install.bin** 的文件；
3. 将此 bin 文件拷贝到 Kindle 磁盘根目录，然后从电脑弹出 Kindle（不要断开 USB 数据线）；
4. 依次在 Kindle 中点击“`菜单 —> 设置 —> 菜单 —> **更新您的 Kindle**`”，等待重启；
5. 重启完毕后你的 Kindle 就已经处于越狱状态了。

**如何判断越狱是否成功？**如果按照以上步骤操作的过程中没有出错即表示越狱成功。或者安装一个 [KUAL](https://bookfere.com/post/311.html#p_1)，如果能正常显示和打开则表示越狱成功。

越狱成功后你就可以安装相关的增强插件（如 [KUAL](https://bookfere.com/post/311.html#p_1)、[Koreader](https://bookfere.com/post/311.html#p_3)）或[更换屏保](https://bookfere.com/post/311.html#p_4)、[替换字体](https://bookfere.com/post/311.html#p_5)等操作了。