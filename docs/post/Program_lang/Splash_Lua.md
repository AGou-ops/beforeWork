# Splash\_Lua脚本

## 在docker中启动Splash

```
docker run -p 8050:8050 scrapinghub/splash
```

## Demo1

```
function main(splash,args)
    splash:go("https://www.baidu.com")
    input=splash:select("#kw")
    input:send_text("Splash")
    submit=splash:select("#su")
    submit.mouse_click()
    splash:wait(3)
    return splash:png()
end
```

## Demo2

```
function main(splash,args)
    local treat=require('treat')
  assert(splash:go("http://quotes.toscrape.com/"))
  assert(splash:wait(0.5))
  local texts=splash:select_all(".quote .text")
  local results={}
  for index,text in ipairs(texts) do
    results[index] = text.node.innerHTML
  end
  return treat.as_array(results),splash:png()
end
```



