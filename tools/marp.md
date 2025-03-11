# Marp

https://marp.app/

基于 Markdown 生成 slides

## HTML cheet sheet

### 图片并排

https://www.w3schools.com/howto/howto_css_images_side_by_side.asp

fixed size

```html
<style>
.column {
  float: left;
  width: 49%;
  padding: 5px;
}

/* Clear floats after image containers */
.row::after {
  content: "";
  clear: both;
  display: table;
}
</style>

<div class="row">
  <div class="column">
    <img src="" style="width:100%">
  </div>
  <div class="column">
    <img src="" style="width:100%">
  </div>
</div>
```

flex

```html
<style>
.row {
  display: flex;
}
.column {
  flex: ;  /* don't know why, works in marp */
  padding: 5px;
}
</style>
```

### slide 图片

绝对位置+位于底层

```html
<img src="a.jpg" width = "200" style="position:absolute;right:100px;top:320px;z-index:-1;">
```

绝对位置+居中+位于底层

```html
<img src="a.jpg" style="position:absolute;top:50px;left:50%;transform:translateX(-50%);z-index:-1;">
```

### 公式block居左

正常 `$$math$$` 是居中的，下面可以让它左对齐

```css
<style scoped>
mjx-container.MathJax[display="true"] {
  display: inline-block !important;
}
</style>
```
### 字号（缩放）

scoped: 只对本页slide有效

```html
<style scoped>
table {
  font-size: 20px;
}
</style>

<style scoped>
ul, ol {
  font-size: 20px;
}
</style>
```

### 文本定位

也可以用于任意 markdown 语法，例如 table

```html
<h1 style="position:absolute;top:10px;left:100px"> Title </h1>
<div style="position:absolute;top:10px;left:100px"> text </div>
<div style="width:50%"> text </div>
```
## My [Front-matter](https://marpit.marp.app/directives?id=front-matter)

```yaml
---
marp: true
style: |
    blockquote {
        border-top: 0.1em dashed #555;
        border-left: none;
        font-size: 60%;
        margin-top: auto;  /* put to bottom */
    }
    section {
        align-content: unsafe center;
    }
paginate: true
headingDivider: 1  # heading level 1 is ---
math: mathjax
---
```

## 图片

https://marpit.marp.app/image-syntax

```markdown
![bg right](./link.png)
```

https://stackoverflow.com/questions/47216198/get-marp-to-center-some-content-horizontally-and-vertically

## 脚注

不会有官方支持： https://github.com/marp-team/marp/discussions/150 ，但是这个讨论中提供了 workaround：用引用块（`>`）+自定义样式

在 marp 的 md 文档开头（Front-matter）加入 `blockquote` 的 CSS style，全局 blockquote 都会变成这种样式。

> 小 trick：如果一页里只有一张 bg 图 `![bg](...) ` （即无正文），这时引用块会居中，而不是置于底部。可以用 `<br>` 作为占位符，填充正文，从而让引用块置底。

## Tips

https://www.hashbangcode.com/article/seven-tips-getting-most-out-marp

## vscode 插件

https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode

## 其他竞品

#### slidev

https://sli.dev/

体验：
- 项目太庞大了（当然好处是更精细的 html/css，以及丰富的 npm 库，但是我都用 markdown 生成 slide 了，需要搞这么复杂吗）
- 可以远程（启 http 服务器）（npm 的好处之一）
