# Hexo安装与简单使用

## 安装

```bash
npm install hexo-cli -g
hexo init blog
cd blog
npm install
hexo server

# 添加deploy git支持
 npm install hexo-deployer-git --save
```

##  _config.yml文件配置



详情查阅：https://hexo.io/zh-cn/docs/configuration

## 使用（来自：https://hexo.io/zh-cn/docs/commands）

>## init
>
>```
>$ hexo init [folder]
>```
>
>新建一个网站。如果没有设置 `folder` ，Hexo 默认在目前的文件夹建立网站。
>
>## new
>
>```
>$ hexo new [layout] <title>
>```
>
>新建一篇文章。如果没有设置 `layout` 的话，默认使用 [_config.yml](https://hexo.io/zh-cn/docs/configuration) 中的 `default_layout` 参数代替。如果标题包含空格的话，请使用引号括起来。
>
>```
>$ hexo new "post title with whitespace"
>```
>
>| 参数              | 描述                                          |
>| :---------------- | :-------------------------------------------- |
>| `-p`, `--path`    | 自定义新文章的路径                            |
>| `-r`, `--replace` | 如果存在同名文章，将其替换                    |
>| `-s`, `--slug`    | 文章的 Slug，作为新文章的文件名和发布后的 URL |
>
>默认情况下，Hexo 会使用文章的标题来决定文章文件的路径。对于独立页面来说，Hexo 会创建一个以标题为名字的目录，并在目录中放置一个 `index.md` 文件。你可以使用 `--path` 参数来覆盖上述行为、自行决定文件的目录：
>
>```
>hexo new page --path about/me "About me"
>```
>
>以上命令会创建一个 `source/about/me.md` 文件，同时 Front Matter 中的 title 为 `"About me"`
>
>注意！title 是必须指定的！如果你这么做并不能达到你的目的：
>
>```
>hexo new page --path about/me
>```
>
>此时 Hexo 会创建 `source/_posts/about/me.md`，同时 `me.md` 的 Front Matter 中的 title 为 `"page"`。这是因为在上述命令中，hexo-cli 将 `page` 视为指定文章的标题、并采用默认的 `layout`。
>
>## generate
>
>```
>$ hexo generate
>```
>
>生成静态文件。
>
>| 选项                  | 描述                                                         |
>| :-------------------- | :----------------------------------------------------------- |
>| `-d`, `--deploy`      | 文件生成后立即部署网站                                       |
>| `-w`, `--watch`       | 监视文件变动                                                 |
>| `-b`, `--bail`        | 生成过程中如果发生任何未处理的异常则抛出异常                 |
>| `-f`, `--force`       | 强制重新生成文件 Hexo 引入了差分机制，如果 `public` 目录存在，那么 `hexo g` 只会重新生成改动的文件。 使用该参数的效果接近 `hexo clean && hexo generate` |
>| `-c`, `--concurrency` | 最大同时生成文件的数量，默认无限制                           |
>
>该命令可以简写为
>
>```
>$ hexo g
>```
>
>## publish
>
>```
>$ hexo publish [layout] <filename>
>```
>
>发表草稿。
>
>## server
>
>```
>$ hexo server
>```
>
>启动服务器。默认情况下，访问网址为： `http://localhost:4000/`。
>
>| 选项             | 描述                           |
>| :--------------- | :----------------------------- |
>| `-p`, `--port`   | 重设端口                       |
>| `-s`, `--static` | 只使用静态文件                 |
>| `-l`, `--log`    | 启动日记记录，使用覆盖记录格式 |
>
>## deploy
>
>```
>$ hexo deploy
>```
>
>部署网站。
>
>| 参数               | 描述                     |
>| :----------------- | :----------------------- |
>| `-g`, `--generate` | 部署之前预先生成静态文件 |
>
>该命令可以简写为：
>
>```
>$ hexo d
>```
>
>## render
>
>```
>$ hexo render <file1> [file2] ...
>```
>
>渲染文件。
>
>| 参数             | 描述         |
>| :--------------- | :----------- |
>| `-o`, `--output` | 设置输出路径 |
>
>## migrate
>
>```
>$ hexo migrate <type>
>```
>
>从其他博客系统 [迁移内容](https://hexo.io/zh-cn/docs/migration)。
>
>## clean
>
>```
>$ hexo clean
>```
>
>清除缓存文件 (`db.json`) 和已生成的静态文件 (`public`)。
>
>在某些情况（尤其是更换主题后），如果发现您对站点的更改无论如何也不生效，您可能需要运行该命令。
>
>## list
>
>```
>$ hexo list <type>
>```
>
>列出网站资料。
>
>## version
>
>```
>$ hexo version
>```
>
>显示 Hexo 版本。
>
>## 选项
>
>### 安全模式
>
>```
>$ hexo --safe
>```
>
>在安全模式下，不会载入插件和脚本。当您在安装新插件遭遇问题时，可以尝试以安全模式重新执行。
>
>### 调试模式
>
>```
>$ hexo --debug
>```
>
>在终端中显示调试信息并记录到 `debug.log`。当您碰到问题时，可以尝试用调试模式重新执行一次，并 [提交调试信息到 GitHub](https://github.com/hexojs/hexo/issues/new)。
>
>### 简洁模式
>
>```
>$ hexo --silent
>```
>
>隐藏终端信息。
>
>### 自定义配置文件的路径
>
>```
># 使用 custom.yml 代替默认的 _config.yml$ hexo server --config custom.yml# 使用 custom.yml 和 custom2.json，其中 custom2.json 优先级更高$ hexo generate --config custom.yml,custom2.json,custom3.yml
>```
>
>自定义配置文件的路径，指定这个参数后将不再使用默认的 `_config.yml`。
>你可以使用一个 YAML 或 JSON 文件的路径，也可以使用逗号分隔（无空格）的多个 YAML 或 JSON 文件的路径。例如：
>
>```
># 使用 custom.yml 代替默认的 _config.yml$ hexo server --config custom.yml# 使用 custom.yml, custom2.json 和 custom3.yml，其中 custom3.yml 优先级最高，其次是 custom2.json$ hexo generate --config custom.yml,custom2.json,custom3.yml
>```
>
>当你指定了多个配置文件以后，Hexo 会按顺序将这部分配置文件合并成一个 `_multiconfig.yml`。如果遇到重复的配置，排在后面的文件的配置会覆盖排在前面的文件的配置。这个原则适用于任意数量、任意深度的 YAML 和 JSON 文件。
>
>### 显示草稿
>
>```
>$ hexo --draft
>```
>
>显示 `source/_drafts` 文件夹中的草稿文章。
>
>### 自定义 CWD
>
>```
>$ hexo --cwd /path/to/cwd
>```
>
>自定义当前工作目录（Current working directory）的路径。

# 将 Hexo 部署到 GitHub Pages(https://hexo.io/zh-cn/docs/github-pages)

在本教程中，我们将会使用 [Travis CI](https://travis-ci.com/) 将 Hexo 博客部署到 GitHub Pages 上。Travis CI 对于开源 repository 是免费的，但是这意味着你的站点文件将会是公开的。如果你希望你的站点文件不被公开，请直接前往本文 [Private repository](https://hexo.io/zh-cn/docs/github-pages#Private-repository) 部分。

1. 新建一个 repository。如果你希望你的站点能通过 `<你的 GitHub 用户名>.github.io` 域名访问，你的 repository 应该直接命名为 `<你的 GitHub 用户名>.github.io`。
2. 将你的 Hexo 站点文件夹推送到 repository 中。默认情况下不应该 `public` 目录将不会被推送到 repository 中，你应该检查 `.gitignore` 文件中是否包含 `public` 一行，如果没有请加上。
3. 将 [Travis CI](https://github.com/marketplace/travis-ci) 添加到你的 GitHub 账户中。
4. 前往 GitHub 的 [Applications settings](https://github.com/settings/installations)，配置 Travis CI 权限，使其能够访问你的 repository。
5. 你应该会被重定向到 Travis CI 的页面。如果没有，请 [手动前往](https://travis-ci.com/)。
6. 在浏览器新建一个标签页，前往 GitHub [新建 Personal Access Token](https://github.com/settings/tokens)，只勾选 `repo` 的权限并生成一个新的 Token。Token 生成后请复制并保存好。
7. 回到 Travis CI，前往你的 repository 的设置页面，在 **Environment Variables** 下新建一个环境变量，**Name** 为 `GH_TOKEN`，**Value** 为刚才你在 GitHub 生成的 Token。确保 **DISPLAY VALUE IN BUILD LOG** 保持 **不被勾选** 避免你的 Token 泄漏。点击 **Add** 保存。
8. 在你的 Hexo 站点文件夹中新建一个 `.travis.yml` 文件：

```
sudo: falselanguage: node_jsnode_js:  - 10 # use nodejs v10 LTScache: npmbranches:  only:    - master # build master branch onlyscript:  - hexo generate # generate static filesdeploy:  provider: pages  skip-cleanup: true  github-token: $GH_TOKEN  keep-history: true  on:    branch: master  local-dir: public
```

1. 将 `.travis.yml` 推送到 repository 中。Travis CI 应该会自动开始运行，并将生成的文件推送到同一 repository 下的 `gh-pages` 分支下
2. 在 GitHub 中前往你的 repository 的设置页面，修改 `GitHub Pages` 的部署分支为 `gh-pages`。
3. 前往 `https://<你的 GitHub 用户名>.github.io` 查看你的站点是否可以访问。这可能需要一些时间。

## Project page

如果你更希望你的站点部署在 `<你的 GitHub 用户名>.github.io` 的子目录中，你的 repository 需要直接命名为子目录的名字，这样你的站点可以通过 `https://<你的 GitHub 用户名>.github.io/` 访问。你需要检查你的 Hexo 配置文件，将 `url` 修改为 `https://<你的 GitHub 用户名>.github.io/`、将 `root` 的值修改为 `//`

## Private repository

The following instruction is adapted from [one-command deployment](https://hexo.io/docs/one-command-deployment) page.

1. Install [hexo-deployer-git](https://github.com/hexojs/hexo-deployer-git).

2. Add the following configurations to **_config.yml**, (remove existing lines if any)

   ```
   deploy:  type: git  repo: https://github.com/<username>/<project>  # example, https://github.com/hexojs/hexojs.github.io  branch: gh-pages
   ```

3. Run `hexo clean && hexo deploy`.

4. Check the webpage at *username*.github.io.

#  nexT主题配置与美化

