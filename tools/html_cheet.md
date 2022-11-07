### 图片并排

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
    <img src="a.jpg" style="width:100%">
  </div>
  <div class="column">
    <img src="b.jpg" style="width:100%">
  </div>
</div>
```
