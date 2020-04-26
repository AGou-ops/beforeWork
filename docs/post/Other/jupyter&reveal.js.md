> **This is jupyter & reveal.js StudyNote.**

* ## jupyter notebook基础操作

### Installation

```bash
# 升级pip
pip3 install --upgrade pip
# 使用pip3安装
pip3 install jupyter
```

### Running

```bash
jupyter notebook # 默认端口8888
```

###  官方文档

> <https://jupyter.readthedocs.io/en/latest/running.html#running>
---
* ##  jupyter lab基础操作
### Installation
```bash
python3 -m pip install jupyterlab
```
### Running
```bash
jupyter lab
```
###  官方文档
> https://jupyterlab.readthedocs.io/en/stable/getting_started/starting.html
---
* ## jupyter-themes基础操作
### Installation

```bash
# 安装 jupyterthemes
pip install jupyterthemes
# 升级到最新版本
pip install --upgrade jupyterthemes
```

### Running

```bash
# list available themes
# onedork | grade3 | oceans16 | chesterish | monokai | solarizedl | solarizedd
jt -l

# select theme...
jt -t chesterish

# restore default theme
# NOTE: Need to delete browser cache after running jt -r
# If this doesn't work, try starting a new notebook session.
jt -r

# toggle toolbar ON and notebook name ON
jt -t grade3 -T -N

# toggle kernel logo.  kernel logo is in same container as name
# toggled with -N.  That means that making the kernel logo visible is
# pointless without also making the name visible
jt -t grade3 -N -kl

# set code font to 'Roboto Mono' 12pt
# (see monospace font table below)
jt -t onedork -f roboto -fs 12

# set code font to Fira Mono, 11.5pt
# 3digit font-sizes get converted into float (115-->11.5)
# 2digit font-sizes > 25 get converted into float (85-->8.5)
jt -t solarizedd -f fira -fs 115

# set font/font-size of markdown (text cells) and notebook (interface)
# see sans-serif & serif font tables below
jt -t oceans16 -tf merriserif -tfs 10 -nf ptsans -nfs 13

# adjust cell width (% screen width) and line height
jt -t chesterish -cellw 90% -lineh 170

# or set the cell width in pixels by leaving off the '%' sign
jt -t solarizedl -cellw 860

# fix the container-margins on the intro page (defaults to 'auto')
jt -t monokai -m 200

# adjust cursor width (in px) and make cursor red
# options: b (blue), o (orange), r (red), p (purple), g (green), x (font color)
jt -t oceans16 -cursc r -cursw 5

# choose alternate prompt layout (narrower/no numbers)
jt -t grade3 -altp

# my two go-to styles
# dark
jt -t onedork -fs 95 -altp -tfs 11 -nfs 115 -cellw 88% -T
# light
jt -t grade3 -fs 95 -altp -tfs 11 -nfs 115 -cellw 88% -T
```

* ###  可用主题

```
Available Themes: 
   chesterish
   grade3
   gruvboxd
   gruvboxl
   monokai
   oceans16
   onedork
   solarizedd
   solarizedl
```



### 官方文档

> <https://github.com/dunovank/jupyter-themes#command-line-examples>