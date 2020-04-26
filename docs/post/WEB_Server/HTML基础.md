>  **This is WEB StudyNote.**

# HTML基础标签

```html
超链接标签
<a href="http://www.w3school.com.cn">This is a link</a>
```

* ### \<br /\> 代表换行

* ### align="center"居中，bgcolor背景颜色

* ###  \<hr /> 创建水平线

* ### <del>二十</del> <ins>十二</ins>

* ### 不建议使用\<s> 和\<strike>	定义删除线文本 \<u>	定义下划线文本

* ### style标签中抛弃了bgcolor，使用了background-color代替

* ### \<pre>预格式文本，用于填充代码

* ### target="_blank"从新窗口打开新的标签，置于a标签中  target="_top覆盖当前页

* ### \<a name="tips">  基本的注意事项 - 有用的提示创建锚（相当于书签）

* ```html
  <code>Computer code</code>
  <br />
  <kbd>Keyboard input</kbd>
  <br />
  <tt>Teletype text</tt>
  <br />
  <samp>Sample text</samp>
  <br />
  <var>Computer variable</var>
  <br />
  ```
  
* ### \<address> 地址标签  此元素通常以*斜体*显示。大多数浏览器会在此元素前后添加折行。

* ### *\<cite>* 此元素通常以*斜体*显示，元素定义*著作的标题*。

* ### 创建图像映射  本例显示如何创建带有可供点击区域的图像地图。其中的每个区域都是一个超级链接

* ```html
<caption>图表标题，置于table和tr之间
  <tr>
  <th>name</th>
  <th>age</th>-------<td>垂直排布<td>
  <th>nickname</th>
  </tr>
  合并单元格
  <th colspan="2">
  增加单元格边距大小
  
  <table border="6" cellspacing="3">
  增加单元格间距大小
   <table border="6" cellspacing="3" cellpadding="10">
     
  列表 <ol start="50" type="A/a/I/i"> start开始索引大小,type分别代表大写，小写，大写罗马，小写罗马数字，不加默认为阿拉伯数字	
  ```
  
* ```html
  鼠标文本悬浮
  <abbr title="etcetera">etc.</abbr>
  <acronym title="World Wide Web">WWW</acronym>
  <dfn>也有类似效果
  ```

* ```html
  <bdo dir="rtl">
              倒序输出文本
  </bdo>
  ```
  
* ```html
  定义数学变量
  <p><var>E = m c<sup>2</sup></var></p>
  ```
  
* ### HTML语意元素
  
  ```html
  HTML5 语义元素
  header	定义文档或节的页眉
  nav	定义导航链接的容器
  section	定义文档中的节
  article	定义独立的自包含文章
  aside	定义内容之外的内容（比如侧栏）
  footer	定义文档或节的页脚
  details	定义额外的细节
  summary	定义 details 元素的标题
  ```
  
* ###  HTML框架
  
* ```html
  <!-- 垂直框架 -->
  <frameset cols="25%,50%,25%" noresize="noresize">
      <frame src="http://www.w3school.com.cn/example/html/frame_a.html">
          <frame src="http://www.w3school.com.cn/example/html/frame_b.html">
              <frame src="http://www.w3school.com.cn/example/html/frame_c.html">
  </frameset>
  <!-- 水平框架 -->
  rows="15%,20%,15%" 
  无法改变窗口大小
  noresize="noresize"
  
  重要提示：不能将 <body></body> 标签与 <frameset></frameset> 标签同时使用！不过，假如你添加包含一段文本的 <noframes> 标签，就必须将这段文字嵌套于 <body></body> 标签内。（在下面的第一个实例中，可以查看它是如何实现的。）
  ```
  
* ###  HTML运行js脚本

* ```html
  <script type="text/javascript">
  document.write("Hello World!")
  </script>
  <noscript>当浏览器不支持js脚本或者禁用时会显示改行文本信息！！！</noscript>
  ```

* ###  \<base target="_blank" />将在新窗口中加载

* ###  本文档的\<meta >属性标识了创作者和编辑软件,本文档的 meta 属性描述了该文档和它的关键词

* ````html
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
  <meta name="suofeiya"
  content="http://suofeiya.pro">
  </head>
  ````

* ###  HTML实体

* ```html
  &lt; 或 &#60; &nbsp;
  HTML 实体符号参考手册:
  http://www.w3school.com.cn/tags/html_ref_entities.html
  ```


* ###  \<from>属性列表如下

* ```html
  下面是 <form> 属性的列表：
  
  属性	描述
  accept-charset	规定在被提交表单中使用的字符集（默认：页面字符集）。
  action	规定向何处提交表单的地址（URL）（提交页面）。
  autocomplete	规定浏览器应该自动完成表单（默认：开启）。
  enctype	规定被提交数据的编码（默认：url-encoded）。
  method	规定在提交表单时所用的 HTTP 方法（默认：GET）。
  name	规定识别表单的名称（对于 DOM 使用：document.forms.name）。
  novalidate	规定浏览器不验证表单。
  target	规定 action 属性中地址的目标（默认：_self）。
  ```

* ### \<from>下拉菜单

* ```html
   <select name="cars">
                  <option value="volvo">Volvo</option>
                  <option value="saab">Saab</option>
                  <option value="fiat">Fiat</option>
       			<!-- selected初始化默认选项 -->
                  <option value="audi" selected>Audi</option>
  </select>
  <!-- HTML5中的新式下拉菜单 -->
   <form action="http://www.w3school.com.cn/demo/demo_form.asp">
          <input list="browsers" name="browser">
          <datalist id="browsers">
              <option value="Internet Explorer">
              <option value="Firefox">
              <option value="Chrome">
              <option value="Opera">
              <option value="Safari">
          </datalist>
          <input type="submit">
      </form>
  ```

* ### 单选框

* ```html
  <form>
          <fieldset>
              <legend>单选框</legend>
          <input type="radio" name="sex" value="male" checked>Male
          <br>
          <input type="radio" name="sex" value="female">Female
          </fieldset>
      </form>
  ```

* 

* ###  使用文本域

* ```html
  <textarea name="message" rows="10" cols="30">
  文本域中的初始化内容
  </textarea>
  ```

* ### button按钮事件

* ```html
  <button type="button" onclick="alert('Hello World!')">您触发了按钮事件！</button>
  ```

* ### input输入限制

* ```html
  <form>
    Quantity (between 1 and 5):
    <input type="number" name="quantity" min="1" max="5">
  </form>
  常用的输入限制（其中一些是 HTML5 中新增的）：
  属性	描述
  disabled	规定输入字段应该被禁用。
  max	规定输入字段的最大值。
  maxlength	规定输入字段的最大字符数。
  min	规定输入字段的最小值。
  pattern	规定通过其检查输入值的正则表达式。
  readonly	规定输入字段为只读（无法修改）。
  required	规定输入字段是必需的（必需填写）。
  size	规定输入字段的宽度（以字符计）。
  step	规定输入字段的合法数字间隔。
  value	规定输入字段的默认值。
  autofocus 属性是布尔属性。自动获得焦点。
  multiple 则规定允许用户在 <input> 元素中输入一个以上的值
  pattern pattern 属性规定用于检查 <input> 元素值的正则表达式。
  placeholder="First name" 用于预期提示
  required 必填字段	
  <form action="action_page.php" autocomplete="on"> 浏览器会基于用户之前的输入值自动填写值。
      <form action="action_page.php" novalidate>novalidate 属性属于 <form> 属性。如果设置，则 novalidate 规定在提交表单时不对表单数据进行验证。
  <!--输入字段位于 HTML 表单之外（但仍属表单）：-->
   <form action="action_page.php" id="form1">
     First name: <input type="text" name="fname"><br>
     <input type="submit" value="Submit">
  </form>
  
   Last name: <input type="text" name="lname" form="form1">
          
  <form>
    Birthday:
      请输入 2000-01-01 之后的日期：<br>
    <input type="date" name="bday" min="2000-01-02">
      <input type="submit"> 
  </form>
  
  <form action="action_page.php">
    Select your favorite color:
    <input type="color" name="favcolor" value="#ff0000">
    <input type="submit">
  </form>
  <!-- 滑块类型输入 -->
  <form action="/demo/demo_form.asp" method="get">
    Points:
    <input type="range" name="points" min="0" max="10">
    <input type="submit">
  </form>
  <!-- 其他 -->
  <input type="month"> 允许用户选择月份和年份。
  <input type="week"> 允许用户选择周和年。
  <input type="time"> 允许用户选择时间（无时区）。
  <input type="datetime"> 允许用户选择日期和时间（有时区）。
  <input type="datetime-local"> 允许用户选择日期和时间（无时区）。
  <input type="email"> 用于应该包含电子邮件地址的输入字段。
  <input type="search"> 用于搜索字段（搜索字段的表现类似常规文本字段）。
  <input type="tel"> 用于应该包含电话号码的输入字段。
  <input type="url"> 用于应该包含 URL 地址的输入字段。
  <input type="image" src="/i/eg_submit.jpg" alt="Submit" width="128" height="128"/>把图像定义为提交按钮
  <input type="file" name="img" multiple>用于提交文件，muiliple选择一个以上的文件
  <input type="text" name="fname" placeholder="First name"> 用于预期提示
  ```

## Bootstrap 响应式框架



## XHTML
* ### XHTML 指的是可扩展超文本标记语言，XHTML 与 HTML 4.01 几乎是相同的

* ### 如何从 HTML 转换到 XHTML

* ```
  1. 向每张页面的第一行添加 XHTML <!DOCTYPE>
  2. 向每张页面的 html 元素添加 xmlns 属性
  3. 把所有元素名改为小写
  4. 关闭所有空元素
  5. 把所有属性名改为小写
  6. 为所有属性值加引号
  ```

* ### 用 \<fieldset\> 组合表单数据

```html
<form action="action_page.php">
<fieldset>
<legend>Personal information:</legend>
First name:<br>
<input type="text" name="firstname" value="Mickey">
<br>
Last name:<br>
<input type="text" name="lastname" value="Mouse">
<br><br>
<input type="submit" value="Submit"></fieldset>
</form> 
```

* ## HTML5

* ```html
  <video width="320" height="240" controls="controls">
    <source src="/i/movie.ogg" type="video/ogg">
    <source src="/i/movie.mp4" type="video/mp4">
  Your browser does not support the video tag.
  </video>
  ```

* ### 新的属性语法

* ```
  HTML5 标准允许 4 中不同的属性语法。
  
  本例演示在 <input> 标签中使用的不同语法：
  
  类型	示例
  Empty	<input type="text" value="John Doe" disabled>
  Unquoted	<input type="text" value=John Doe>
  Double-quoted	<input type="text" value="John Doe">
  Single-quoted	<input type="text" value='John Doe'>
  ```

* ### 新特性

* ```html
  HTML5 的一些最有趣的新特性：
  
  新的语义元素，比如 <header>, <footer>, <article>, and <section>。
  新的表单控件，比如数字、日期、时间、日历和滑块。
  强大的图像支持（借由 <canvas> 和 <svg>）
  强大的多媒体支持（借由 <video> 和 <audio>）
  强大的新 API，比如用本地存储取代 cookie。
  ```

* ### HTML5被删除元素

* ```html
  以下 HTML 4.01 元素已从 HTML5 中删除：
  <acronym>
  <applet>
  <basefont>
  <big>
  <center>
  <dir>
  <font>
  <frame>
  <frameset>
  <noframes>
  <strike>
  <tt>
  ```

* ### 新的语义结构元素

* ![HTML5 è¯­ä¹åç´ ](http://www.w3school.com.cn/i/ct_sem_elements.png)

* ```html
  HTML5 提供的新元素可以构建更好的文档结构：
  
  标签	描述
  <article>	定义文档内的文章。
  <aside>	定义页面内容之外的内容。
  <bdi>	定义与其他文本不同的文本方向。
  <details>	定义用户可查看或隐藏的额外细节。
  <dialog>	定义对话框或窗口。
  <figcaption>	定义 <figure> 元素的标题。
  <figure>	定义自包含内容，比如图示、图表、照片、代码清单等等。
  <footer>	定义文档或节的页脚。
  <header>	定义文档或节的页眉。
  <main>	定义文档的主内容。
  <mark>	定义重要或强调的内容。
  <menuitem>	定义用户能够从弹出菜单调用的命令/菜单项目。
  <meter>	定义已知范围（尺度）内的标量测量。
  <nav>	定义文档内的导航链接。
  <progress>	定义任务进度。
  <rp>	定义在不支持 ruby 注释的浏览器中显示什么。
  <rt>	定义关于字符的解释/发音（用于东亚字体）。
  <ruby>	定义 ruby 注释（用于东亚字体）。
  <section>	定义文档中的节。
  <summary>	定义 <details> 元素的可见标题。
  <time>	定义日期/时间。
  <wbr>	定义可能的折行（line-break）。
  阅读更多有关 HTML5 语义的内容。
  ```

* ### 新的表单元素

* ````html
  标签	描述
  <datalist>	定义输入控件的预定义选项。
  <keygen>	定义键对生成器字段（用于表单）。
  <output>	定义计算结果。
  ````

* ### 新的输入类型

* ```html
  <!-- 新的输入类型 -->	
  color
  date
  datetime
  datetime-local
  email
  month
  number
  range
  search
  tel
  time
  url
  week
  <!-- 新的输入属性 -->
  autocomplete
  autofocus
  form
  formaction
  formenctype
  formmethod
  formnovalidate
  formtarget
  height 和 width
  list
  min 和 max
  multiple
  pattern (regexp)
  placeholder
  required
  step
  ```

* ### HTML5图像

* ```html
  标签	描述
  <canvas>	定义使用 JavaScript 的图像绘制。
  <svg>	定义使用 SVG 的图像绘制。
  ```

* ###  新的媒介元素

* ```html
  标签	描述
  <audio>	定义声音或音乐内容。
  <embed>	定义外部应用程序的容器（比如插件）。
      <embed height="100" width="100" src="song.mp3" />
      <object height="100" width="100" data="song.mp3"></object>
  <source>	定义 <video> 和 <audio> 的来源。
  <track>	定义 <video> 和 <audio> 的轨道。
  <video>	定义视频或影片内容。
  ```

* ##  从 HTML4 迁移至 HTML5

* ```html
  典型的 HTML4	典型的 HTML5
  <div id="header">	<header>
  <div id="menu">		<nav>
  <div id="content">	<section>
  <div id="post">		<article>
  <div id="footer">	<footer>
  
      修改文档类型，从 HTML4 doctype：
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
  "http://www.w3.org/TR/html4/loose.dtd">
      修改为 HTML5 doctype：
  <!DOCTYPE html>
  
      修改编码信息，从 HTML4：
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  改为 HTML5：
  <meta charset="utf-8">
  ```

#  JavaScript

* ### JavaScript 数组

* ```javascript
  var cars=new Array();
  var cars=new Array("Audi","BMW","Volvo");
  var cars=["Audi","BMW","Volvo"];
<!-- 连接两个数组使用concat()方法 -->
  var arr = new Array(3)          
  arr[0] = "George"               
  arr[1] = "John"                 
  arr[2] = "Thomas"               
  var arr2 = new Array(3)         
  arr2[0] = "James"               
  arr2[1] = "Adrew"               
  arr2[2] = "Martin"              
  document.write(arr.concat(arr2))
                                  
  <!--  array遍历的三种方法 -->
  1. for(var x=0;x<array.length;x++)
  2. for x in array
  3. array.join()    <!-- 以逗号进行分割，如若使用自定义分割字符，使用Join("xxx") -->
                                  

  <!-- 对数组进行排序 -->
  array.sort()	<!-- 若是string按照字母表排序，若是数字，从小到大排序 -->
  ```

* ### JavaScript 对象

* ```javascript
  var person={firstname:"Bill", lastname:"Gates", id:5566};
  //对象属性的两种寻址方式
  name=person.lastname;
  name=person["lastname"];
  //同时创建
  person=new Object();
  person.firstname="Bill";
  person.lastname="Gates";
  person.age=56;
  person.eyecolor="blue";
  ```

* ###   JavaScript Math 对象
  
    ```javascript
    <!-- 四舍五入 -->
    document.write(Math.round(0.60) + "<br />")
    <!-- 随机一个0-1之间的实数 -->
    document.write(Math.random())
    <!-- 返回最大最小值 -->
    document.write(Math.max(5,7) + "<br />")
    ```

* ### JavaScript 正则表达式

* ```javascript
  <!-- RegExp 对象有 3 个方法：test()、exec() 以及 compile() -->
  var patt=new RegExp("正则")
  document.write(patt.test("测试字符串"))	<!-- 返回boolean -->
  document.write(patt.exec("测试字符串"))	<!-- 找到返回该string， -->
  <!-- 向 RegExp 对象添加第二个参数，以设定检索 -->
  var patt1=new RegExp("e","g");
  do
  {
  result=patt1.exec("The best things in life are free");
  document.write(result);
  }
  while (result!=null) 	<!-- 输出：eeeenull -->
  <!-- compile() 方法用于改变 RegExp,compile() 既可以改变检索模式，也可以添加或删除第二个参数，返回Boolean -->
  var patt1=new RegExp("e");
  document.write(patt1.test("The best things in life are free"));
  patt1.compile("d");
  document.write(patt1.test("The best things in life are free"));
  ```

* ### JavaScript函数

* ```javascript
  function(参数1,参数2){
  	return x;//返回值
  }
  ```
```
  
* ### 比较运算符 ,三元运算符

* | ===  | 全等（值和类型） | x===5 为 true；x==="5" 为 false |
  | :--- | ---------------- | ------------------------------- |
  |      |                  |                                 |

  * ### greeting=(visitor=="PRES")?"Dear President ":"Dear ";

* ### For/In 循环

* ```javascript
var person={fname:"John",lname:"Doe",age:25};
  for (x in person)
  {
  txt=txt + person[x];
  }
```

* ### JavaScript 标签

* ```javascript
  label:{
  	do something here;
      break label;
  }
  ```

* ### JavaScript可用于表单验证

* ### JavaScript Window

* ```javascript
  <!-- 获取当前窗口的可用高度和宽度 -->
  document.write("可用高度：" + screen.availHeight);
  document.write("可用宽度：" + screen.availWidth);
  <!-- 加载新文档 -->
  window.location.assign("https://suofeiya.pro/")
  <!--  返回上一页和下一页 -->
  window.history.back()
  window.history.forward()
  <!-- window.navigator 对象在编写时可不使用 window 这个前缀 -->
  txt = "<p>Browser CodeName: " + navigator.appCodeName + "</p>";
  txt+= "<p>Browser Name: " + navigator.appName + "</p>";
  txt+= "<p>Browser Version: " + navigator.appVersion + "</p>";
  txt+= "<p>Cookies Enabled: " + navigator.cookieEnabled + "</p>";
  txt+= "<p>Platform: " + navigator.platform + "</p>";
  txt+= "<p>User-agent header: " + navigator.userAgent + "</p>";
  txt+= "<p>User-agent language: " + navigator.systemLanguage + "</p>";
  document.getElementById("example").innerHTML=txt;
  
  ```

* ### JavaScript消息框

* ```javascript
  <!-- 三种消息框 -->
  警告框,确认框,提示框
  <!-- 简单示例 -->
  function disp_alert()                         
  {                                             
  alert("我是警告框！！"+'\n'+"我是警告第二行") 
  }                                             
  
  function show_confirm()          
  {                                
  var r=confirm("Press a button!");
  if (r==true)                     
    {                              
    alert("You pressed OK!");      
    }                              
  else                             
    {                              
    alert("You pressed Cancel!");  
    }                              
  }                                
                                   
  function disp_prompt()                                    
    {                                                       
    var name=prompt("请输入您的名字","Bill Gates")          
    if (name!=null && name!="")                             
      {                                                     
      document.write("你好！" + name + " 今天过得怎么样？") 
      }                                                     
    }                                                       
  
  ```

* ### JavaScript计时

* ```javascript
  var t=setTimeout("alert('5 秒！')",5000) 
  ```

* ### 改变HTML-DOM（HTML DOM 的 document 也是 window 对象的属性之一）

* ```html
  <img id="image" src="/i/eg_tulip.jpg" />
  <script>
  document.getElementById("image").src="/i/shanghai_lupu_bridge.jpg";
  window.document.getElementById("image")
  </script>
  <p>原始图片是郁金香（eg_tulip.jpg），但是已被修改为卢浦大桥（shanghai_lupu_bridge.jpg）。</p>
  <!-- 改变标签style样式 -->
  <p id="p2">Hello World!</p>
  <script>
  document.getElementById("p2").style.color="blue";
  </script>
  ```
  
* ### DOM事件

* ```html
  <h1 onclick="this.innerHTML='谢谢!'">请点击该文本</h1>
  
  向 button 元素分配 onclick 事件：
  <script>
  document.getElementById("myBtn").onclick=function(){displayDate()};
  </script>
  
  onload 和 onunload 事件会在用户进入或离开页面时被触发。
  <body onload="checkCookies()">
      
  onchange 事件常结合对输入字段的验证来使用。离开时触发
  <input type="text" id="fname" onchange="upperCase()">
      
  onmouseover 和 onmouseout 事件可用于在用户的鼠标移至 HTML 元素上方或移出元素时触发函数。
  
  onmousedown, onmouseup 以及 onclick 构成了鼠标点击事件的所有部分。首先当点击鼠标按钮时，会触发 onmousedown 事件，当释放鼠标按钮时，会触发 onmouseup 事件，最后，当完成鼠标点击时，会触发 onclick 事件。
  ```


* ### 创建新的 HTML 元素

* ```html
  <!-- 应用示例,添加元素 -->
  <div id="div1">
  <p id="p1">这是一个段落</p>
  <p id="p2">这是另一个段落</p>
  </div>
  
  <script>
  var para=document.createElement("p");
  var node=document.createTextNode("这是新段落。");
  para.appendChild(node);
  
  var element=document.getElementById("div1");
  element.appendChild(para);
  </script>
  <!-- 从父元素中删除子元素 -->
  parent.removeChild(child);
  ```
```
  
* ###  所有 JavaScript 数字均为 64 位

* ### JavaScript String类型

* ```javascript
  <script type="text/javascript">
  
  var txt="Hello World!"
  
  document.write("<p>Big: " + txt.big() + "</p>")
  document.write("<p>Small: " + txt.small() + "</p>")
  
  document.write("<p>Bold: " + txt.bold() + "</p>")
  document.write("<p>Italic: " + txt.italics() + "</p>")
  
  document.write("<p>Blink: " + txt.blink() + " (does not work in IE)</p>")
  document.write("<p>Fixed: " + txt.fixed() + "</p>")
  document.write("<p>Strike: " + txt.strike() + "</p>")
  
  document.write("<p>Fontcolor: " + txt.fontcolor("Red") + "</p>")
  document.write("<p>Fontsize: " + txt.fontsize(16) + "</p>")
  
  document.write("<p>Lowercase: " + txt.toLowerCase() + "</p>")
  document.write("<p>Uppercase: " + txt.toUpperCase() + "</p>")
  
  document.write("<p>Subscript: " + txt.sub() + "</p>")
  document.write("<p>Superscript: " + txt.sup() + "</p>")
  
  document.write("<p>Link: " + txt.link("http://www.w3school.com.cn") + "</p>")
  <!-- 替换字符串 -->
  document.write(str.replace(/Microsoft/,"W3School"))
  <!-- 查找字符串，找到字符串则返回该字符串，如未找到，则返回null值 -->
  document.write(str.match("world") + "<br />")
  <!-- 查找字符串的索引 -->
  document.write(str.indexOf("World") + "<br />")
  </script>
```

* ###  JavaScript中的   一些属性以及方法

* ```javascript
  document.write(Date())
  <!-- 不能使用Date().getTime()来代替 -->
  var d=new Date();
  document.write("从 1970/01/01 至今已过去 " + d.getTime() + " 毫秒");
  <!-- 自定义设置日期 -->
  var d = new Date()
  d.setFullYear(1992,10,3)
  document.write(d)
  <!-- toUTCString() 将当日的日期（根据 UTC）转换为字符串 -->
  var d = new Date()
  document.write (d.toUTCString())
  <!-- 利用getDay()和数组返回今天是星期几 -->
  var d=new Date()
  var weekday=new Array(7)
  weekday[0]="星期日"
  weekday[1]="星期一"
  weekday[2]="星期二"
  weekday[3]="星期三"
  weekday[4]="星期四"
  weekday[5]="星期五"
  weekday[6]="星期六"
  
  document.write("今天是" + weekday[d.getDay()])
  
  ```

* ### JavaScript 框架

  * JQuery	Prototype 	MooTools

# CSS

* ### 创建css

* ```html
  外部样式表:使用link标签链接外部css文件
  <head><link rel="stylesheet" type="text/css" href="/css/csstest_01.css" ></head>
  内部样式表:
  <head><style type="text/css">.css{...}</style></head>
  内联样式:
  <p style="color: sienna; margin-left: 20px">
  ```
  
* ### css选择器

* ```css
  类名选择器
  .center {text-align: center}
  ID选择器
  #sidebar {...}
  标签选择器
  p strong {...}
  td.fancy {...} fancy类名下的td标签
  属性选择器
  [title]  {...} 带有title属性的才会被选中
  [title=suofeiya] {...} 带有特定title属性的才会被选中
  [title~=hello] {...} 包含关系的title属性才会被选中
  [lang|en]选择 lang {...} 选中属性值以 "en" 开头的元素
  [attribute^/$=value] {...} 选中属性为value开头/结尾的
  [attribute*=value] {...} 选中包含vlue的元素
  ```

* ###  css属性对应

* ```css
  `padding: 20px; 填充内边距,20像素
  background-color: transparent; 背景透明
  background-image: url(image_url); 可以为文本,链接...设置背景图			background-position:center; 还有top、bottom、left、right,还可以使用百分比的值或者像素值来进行设置
  	background-repeat: repeat-y; 背景重复,x/y方向上重复,可直接repeat或者设置no-repeat
  	background-attachment:fixed; 固定背景图片
  	** 可以使用background: #ff0000 url(/i/eg_bg_03.gif) no-repeat fixed center; 语法简洁书写`
  ```

* ```css
  text-indent: 5em; 文本缩进5em,em代表弹性大小,可以继承,使用百分比,如:div {width: 500px;}p {text-indent: 20%;}缩进100个像素
  text-align:center; 文本对齐方式,有5个值,简单的三个是right,left和center,注意center和标签<CENTER>区别是后者会对其整个元素
  word-spacing: 30px; 改变单词之间的间隔,单位px,em
  letter-spacing: 20px; 改变字符之间的间隔
  text-transform: none/uppercase/lowercase/capitalize; 分别是对单词进行不处理,全大写,全小写,首字母大写处理
  text-decoration: none/underline/overline/line-through/blink; 分别进行不处理,下划线,上划线,删除线(类似S/strike标签),闪烁处理,用途:可以用来删除超链接的下划线
  direction: rtl;改变文字方向,从右向左.
  white-space: normal; 处理空白字符,默认使用normal会合并多余的空白字符和换行符,还有另外一个值pre,与上述normal相反,另外nowrap不进行换行,当 white-space 属性设置为 pre-wrap 时，浏览器不仅会保留空白符并保留换行符，还允许自动换行,当 white-space 属性设置为 pre-line 时，浏览器会保留换行符，并允许自动换行，但是会合并空白符，这是与 pre-wrap 值的不同之处,总结,表格:
  ```

* | 值       | 空白符 | 换行符 | 自动换行 |
  | :------- | :----- | :----- | :------- |
  | pre-line | 合并   | 保留   | 允许     |
  | normal   | 合并   | 忽略   | 允许     |
  | nowrap   | 合并   | 忽略   | 不允许   |
  | pre      | 保留   | 保留   | 不允许   |
  | pre-wrap | 保留   | 保留   | 允许     |

* ```css
  body {font-family: sans-serif;} 统一文档所使用的字体,当然可以指定某一标签下的字体样式,此外font-family: Times, TimesNR, 'New Century Schoolbook',Georgia, 'New York'(字体名称带有空格或者特殊符号时要使用单引号引起来), serif;  设置多个字体,可以按照用户实际情况进行顺序查找可用的字体
  font-style:normal/italic/oblique; 分别代表正常,斜体,斜体,italic是一种字体风格,对字体结构进行细微变化,而后者是直接倾斜,但是我觉得看起来没什么卵区别
  font-variant:small-caps; 字体缩小并全转换为大写发生形变
  font-weight:normal(400)/bold(900)/100-900; 粗细程度,可以使用数字代替
  font-size:14px; 控制字体大小,推荐使用em来设置,像素em之间转换关系pixels/16=em ,em是一种弹性大小单位
  ```

* ```css
  链接样式:
  a:link {color:#FF0000;}    /* 未被访问的链接 */
  a:visited {color:#00FF00;} /* 已被访问的链接 */
  a:hover {color:#FF00FF;}   /* 鼠标指针移动到链接上 */
  a:active {color:#0000FF;}  /* 正在被点击的链接 */
  
  注意:a:hover 必须位于 a:link 和 a:visited 之后,a:active 必须位于 a:hover 之后
  background-color:#B2FF99; 还可以同时设置背景颜色,字体,颜色,大小等.
  
  高级链接框例子:
  a:link,a:visited
  {display:block;
  font-weight:bold;
  font-size:14px;
  font-family:Verdana, Arial, Helvetica, sans-serif;
  color:#FFFFFF;
  background-color:#98bf21;
  width:120px;
  text-align:center;
  padding:4px;
  text-decoration:none;}
  a:hover,a:active{background-color:#7A991A;}
  ```

* ### css列表

* ```css
  无序列表:<ul class="disc"><li>
  list-style-type:disc/circle/square/none; 分别代表实心圆,空心圆,实心正方形,无
  有序列表:<ol class="decimal"><li>
  list-style-type:decimal/lower-roman/upper-roman/lower-alpha/upper-alpha;分别1,i,I,a,A
  自定义图片:
  list-style-image: url('image_url')
  
  list-style-position: outside/inside; 分别代列表在外部和内部
  ```

* ### css表格\<table\>\<tr\>\<th\>content

* ```css
  border:1px solid blue; 双线条边框表格,实心,蓝色
  border-collapse:collapse; 合并成单线条表格
  width/height:100%/50px; 宽度,高度
  text-align:right/left/center; 文本对齐
  padding:15px; 表格内间距
  background-color:green;color:white;
  表格标题:
  caption{caption-side:bottom}
  <caption>This is a caption</caption>在table与tr之间插入
  
  轮廓:
  outline:#00ff00 dotted thick;
  outline-style:dotted;outline-color:#00ff00;outline-width:thin;
  ```

* 