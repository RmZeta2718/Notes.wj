# Marp

https://marp.app/

基于 Markdown 生成 slides

### My [Front-matter](https://marpit.marp.app/directives?id=front-matter)

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
paginate: true
---
```

### 图片

https://marpit.marp.app/image-syntax

```markdown
![bg right](./link.png)
```

https://stackoverflow.com/questions/47216198/get-marp-to-center-some-content-horizontally-and-vertically

### 脚注

不会有官方支持： https://github.com/marp-team/marp/discussions/150 ，但是这个讨论中提供了 workaround：用引用块（`>`）+自定义样式

在 marp 的 md 文档开头（Front-matter）加入 `blockquote` 的 CSS style，全局 blockquote 都会变成这种样式。

> 小 trick：如果一页里只有一张 bg 图 `![bg](...) ` （即无正文），这时引用块会居中，而不是置于底部。可以用 `<br>` 作为占位符，填充正文，从而让引用块置底。

### Tips

https://www.hashbangcode.com/article/seven-tips-getting-most-out-marp

### vscode 插件

https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode

### 其他竞品

#### slidev

https://sli.dev/

体验：
- 项目太庞大了（当然好处是更精细的 html/css，以及丰富的 npm 库，但是我都用 markdown 生成 slide 了，需要搞这么复杂吗）
- 可以远程（启 http 服务器）（npm 的好处之一）
