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

### slide 图片定位

```html
<img src="a.jpg" width = "200" style="position:absolute;right:100px;top:320px;"/>
```

### 图片居中

```html
<img align="center" src="">
```

和缩放不兼容？（加上width后居中失效）

### 表格字号（缩放）

```html
<style scoped>
table {
  font-size: 20px;
}
</style>
```
