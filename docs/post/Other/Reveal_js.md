> **This Reveal.js StudyNote.**

# 基础结构

```html
<html>
<head>
    <link rel="stylesheet" href="css/reveal.css">
    <!-- 主题切换 -->
    <!-- 提供 11 种主题
    black:黑色背景，白色文字，蓝色链接（默认主题）
    white:白色背景，黑色文本，蓝色链接
    league:灰色背景，白色文本，蓝色链接（reveal.js<3.0.0的默认主题）
    beige:米色背景，黑暗文本，棕色链接
    sky:蓝色背景，薄的黑暗文本，蓝色链接
    night:黑色背景，厚厚的白色文字，橙色链接
    serif:卡布奇诺背景，灰色文本，棕色链接
    simple:白色背景，黑色文本，蓝色链接
    solarized:奶油色背景，深绿色文本，蓝色链接
	-->
    <link rel="stylesheet" href="css/theme/blood.css">
</head>
<body>
    <div class="reveal">
        <div class="slides">
            <section>幻灯片1</section>
            <section>幻灯片2</section>
        </div>
    </div>
    <script src="js/reveal.js"></script>
    <script>
        Reveal.initialize();
    </script>
</body>
</html>
```

#  Reveal.initialize(我觉得还蛮不错的配置)

```javascript
Reveal.initialize({

	// 显示操作控件
	controls: true,

	// 显示帮助
	controlsTutorial: false,

	// 箭头布局，前者代表四周，后者代表右下角显示 
    //"edges" or "bottom-right"
	controlsLayout: 'edges',

	// 向后导航箭头的可见性规则;“褪色”，“隐藏”或“可见”
    //"faded", "hidden","visible"
	controlsBackArrows: 'faded',

	// 显示ppt进度条
	progress: true,

	// 显示当前ppt页码
	slideNumber: true,

	//将当前幻灯片编号添加到URL哈希，以便重新加载
    //页面复制URL将返回到同一张幻灯片
	hash: true,

	// 存入浏览器历史，意味着hash属性为true
	history: false,

	// 激活键盘来进行操作，默认选项
	keyboard: true,

	// 打开ppt全览，默认选项
	overview: true,

	// 幻灯片垂直居中，默认选项
	center: true,

	// 启用触摸选项（移动端，touch操作），默认选项
	touch: true,

	// 循环演示
	loop: false,

	// 反转幻灯片顺序，第一页变成最后一页，不建议使用
	rtl: false,

	// 参考 https://github.com/hakimel/reveal.js/#navigation-mode
    // default	linear（一页页全部显示）	grid	三种
	navigationMode: 'default',

	// 加载随机幻灯片，默认选项
	shuffle: false,

	// 全局打开和关闭片段，默认选项
	fragments: true,

	// Flags whether to include the current fragment in the URL,
	// so that reloading brings you to the same fragment position
    // 和hash类似？？？
	fragmentInURL: false,
    
	// 像所有人显示笔记，默认选项
	showNotes: false,

	// 媒体是否自动播放
    // - null：如果存在data-autoplay，则媒体只会自动播放
	// - true：无论个别设置如何，所有媒体都将自动播放
	// - false：无论个人设置如何，都不会自动播放媒体
	autoPlayMedia: null,

	//用于预加载延迟加载的iframe的全局覆盖
	// - null：在内部加载带有data-src和data-preload的iframe
	// viewDistance，只有data-src的iframe将在可见时加载
	// - true：在viewDistance中加载所有带有data-src的iframe
	// - false：所有带有data-src的iframe只有在可见时才会加载
	preloadIframes: null,

	//自动进入的时间间隔的毫秒数
	//下一张幻灯片，设置为0时禁用，可以覆盖此值
	//在幻灯片上使用data-autoslide属性
	autoSlide: 0,

	// 用户输入后停止自动滑动
	autoSlideStoppable: true,

	// 自动滑动时使用此方法进行导航
	autoSlideMethod: Reveal.navigateNext,

	//指定您认为将花费的平均时间（以秒为单位）
	//展示每张幻灯片。这用于显示一个起搏计时器
	//扬声器视图
	defaultTiming: 120,

	// 通过鼠标滚轮启用幻灯片导航，逐页翻，我反正不建议使用
	mouseWheel: false,

	// 如果不活动则隐藏鼠标
	hideInactiveCursor: true,

	// 隐藏鼠标的时间（单位：ms）
	hideCursorTime: 5000,

	//隐藏移动设备上的地址栏
	hideAddressBar: true,

	//在iframe预览叠加层中打开链接
	//添加`data-preview-link`和`data-preview-link =“false”`来自定义每个链接
	//单独
	previewLinks: false,

	// 翻页风格
    // none/fade/slide/convex/concave/zoom
    //	//无/淡入淡出/滑动/凸出/凹入/缩放
	transition: 'zoom', 

	// 翻页速度
	transitionSpeed: 'default', // default/fast/slow

	// 幻灯片背景的过渡风格
    // none/fade/slide/convex/concave/zoom
	backgroundTransition: 'fade', 

	// 远离当前可见的幻灯片数量
	viewDistance: 3,

	//	视差背景图像
	parallaxBackgroundImage: 'https://s3.amazonaws.com/hakim-static/reveal-js/reveal-parallax-1.jpg', 

	// 视差背景图像大小
	parallaxBackgroundSize: '', // CSS 语法, e.g. "2100px 900px"

    //每张幻灯片移动视差背景的像素数
    // - 除非指定，否则自动计算
    // - 设置为0以禁用沿轴的移动
    // 通俗来讲,就是切换slide背景图片的偏移量
	parallaxBackgroundHorizontal: 200,
	parallaxBackgroundVertical: 50,

	// 幻灯片的显示模式
	display: 'block'

});
```

# Reveal.configure

```javascript
// 自动翻页，时间：ms
Reveal.configure({
            autoSlide: 5000,
    		slideNumber: true,	//开启页码
            slideNumber: 'c/t',	//设置页码格式,当前/全部
        });
```

# 懒惰加载（延迟加载意味着reveal.js只会加载最接近当前幻灯片的几张幻灯片的内容）

```html
<section>
  <img data-src="image.png">
  <!-- data-preload会根据viewDistance来进行加载 -->
  <iframe data-src="http://hakim.se" data-preload></iframe>
  <video>
    <source data-src="video.webm" type="video/webm" />
    <source data-src="video.mp4" type="video/mp4" />
  </video>
</section>
```

# section属性

* ```html
  <!-- 设置当前slide的背景颜色或者背景图片 -->
  方法1：添加注释<!-- .slide: data-background="#ff0000" -->
  方法2：<section data-background-color="#ff0000">
  <section data-background-image="http://example.com/image.png">
  ```

* ```html
  <!-- 内嵌一个(可交互式)网页 -->
  <section data-background-iframe="https://suofeiya.pro" data-background-interactive>
  <h2>Iframe</h2>
  </section>
  ```

* ```html
  	// 翻页风格
      // none/fade/slide/convex/concave/zoom
      //	//无/淡入淡出/滑动/凸出/凹入/缩放
  <section data-transition="zoom">
  <section data-transition-speed="fast"> //fast,default,slow
  ```

* ```html
  <!-- 幻灯片之间的切换跳转 -->
  <!-- 设置ID属性 -->
  <section id="some-slide">
  <!-- 跳转 -->
  <a href="#/some-slide">Link</a>
  ```

* ```html
  <!-- 文字浮现方式 -->
  <section>
  	<p class="fragment grow">凸起</p>
  	<p class="fragment shrink">凹陷</p>
  	<p class="fragment fade-out">消失</p>
  	<p class="fragment fade-up">从下方浮现 (同理 down, left and right!)</p>
  	<p class="fragment fade-in-then-out">浮现,下一步后消失</p>
  	<p class="fragment fade-in-then-semi-out">浮现,下一步聚焦模糊</p>
  	<p class="fragment highlight-current-blue">颜色出现一次</p>
  	<p class="fragment highlight-red">高亮-红色</p>
  </section>
  ```

* ```html
  <!-- 代码区块 -->
  <section>
  	<pre>
  			<code class="hljs" data-line-numbers="2,4-5">
                              def main():
                                  print("hello Python")
                               
                              if __name__ == "__main__":
                                  main()
  			</code>
  	</pre>
  </section>
  ```

* ```html
<!-- 插入视频,data-autoplay自动播放 --> 
  <section>
                <p>This video will use up the remaining space on the slide</p>
                  <video data-autoplay class="stretch" src="http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"></video>
              </section>
          </div>
```
  
* 

  # 部分快捷键以及事件

  * ```
    F(fullscreen)全屏 ESC全览	S speaker模式
    ```

  * ```javascript
    # Overview mode
    
    Press »ESC« or »O« keys to toggle the overview mode on and off. While you're in this mode, you can still navigate between slides, as if you were at 1,000 feet above your presentation. The overview mode comes with a few API hooks:
    
    Reveal.addEventListener( 'overviewshown', function( event ) { /* ... */ } );
    Reveal.addEventListener( 'overviewhidden', function( event ) { /* ... */ } );
    
    // Toggle the overview mode programmatically
    Reveal.toggleOverview();
    ```

    