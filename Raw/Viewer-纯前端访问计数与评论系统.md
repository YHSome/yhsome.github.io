time: 2026.6.19
tag: 项目
title: Viewer：纯前端访问计数与评论系统——零后端、零数据库、复制即用

# 缘起

2023 年，刚接触静态博客的时候，最羡慕的就是别人的博客有阅读量统计和评论区。那时候 YHSome 用的是 Hexo + GitHub Pages，纯静态 HTML 托管，没有服务器、没有数据库。传统的评论方案——Disqus、Gitalk、 utterances——要么需要注册第三方服务，要么需要 OAuth 授权，要么样式丑陋无法自定义。

"能不能有一个方案，复制一个 JS 文件、贴一行代码，计数器就能用？"

2026 年，这个想法变成了现实。

# 核心设计

Viewer 基于 **TinyWebDB** 云数据库——一个面向教育场景的轻量级键值存储服务，提供简单的 REST API：

```
POST https://tinywebdb.appinventor.space/api
  user=xxx&secret=xxx&action=get&tag=watch_1
```

所有数据以 `tag` → `value` 的键值对形式存储。Viewer 不关心后端——它只负责在合适的时机调用合适的 API。

# 四个模块

## counter.js —— 单页浏览量

```javascript
getVisitCount()
  → GET watch_{page_id}    // 读取当前计数
  → old + 1                // 自增
  → UPDATE watch_{page_id}  // 写回
  → 返回新数值 → 页面渲染
```

每次刷新计数 +1，简单粗暴。页面编号通过 `<meta name="x-viewer-page-id">` 区分，多页面互不干扰。

## unique.js —— 独立访客数

```javascript
getUniqueCount()
  → 检查 localStorage('viewer_visited_{page_id}')
  → 首次访问? +1 并标记 : 直接返回当前值
```

同一设备只计一次，基于 `localStorage` 判重。比 IP 判重更精准（NAT 下多人同 IP），比 Cookie 持久（不会被清除）。

## global.js —— 全站累计浏览量

和 counter 逻辑一致，但 tag 固定为 `global_watch`，不跟页面编号。所有页面贡献同一个计数器。

## comment.js —— 评论系统

```
loadComments()
  → GET comment_count_{page_id}          // 评论总数
  → 逐条 GET comment_{page_id}_1..N       // 加载每条评论
  → JSON.parse → 渲染到页面

submitComment({name, email, content})
  → 组装 { name, email, content, time }
  → JSON.stringify
  → UPDATE comment_{page_id}_{count+1}
  → UPDATE comment_count_{page_id} = count+1
```

每条评论存为一个独立 tag，值用 JSON 序列化。这样设计的好处是：不需要解析数组、不需要分页逻辑、增删改查都是单条操作。

# 使用方式

在 HTML 中引入：

```html
<meta name="x-viewer-page-id" content="1">
<script>window.ViewerConfig = { user:'xxx', secret:'xxx' }</script>
<script src="counter.js"></script>
<script src="unique.js"></script>
<script src="global.js"></script>
<script src="comment.js"></script>
```

然后调用：

```javascript
getVisitCount().then(n => { el.textContent = n })
Viewer.getUniqueCount().then(r => { el.textContent = r.count })
Viewer.getGlobalCount().then(n => { el.textContent = n })
Viewer.loadComments().then(comments => { render(comments) })
Viewer.submitComment({ name, email, content })
```

# 与 OpenBlogger 的集成

在 OpenBlogger 中，Viewer 作为插件安装在 `Plugins/Viewer/js/`。构建时自动复制到 `Rendered/js/viewer/`。四个模板（首页/目录/标签/文章页）自动加载 JS 文件，页脚自动渲染统计数据，文章页自动渲染评论区。

页面编号由渲染器自动分配，记录在 `.viewer_pages.json` 中，永不重用已删除页面的 ID。全站弹幕联动——遍历所有页面 ID 拉取评论，翻倍拼接后 CSS 循环滚动。

# 安全警告

> **静态网页的源代码对所有访问者可见。**
>
> 任何人按 F12 即可获取 `user` 和 `secret`，从而拥有对该 TinyWebDB 数据库的完全读写权限。
>
> - 不要将密码、密钥等敏感数据存入此 TinyWebDB
> - 不要用同一个 user/secret 存放重要业务数据
> - 此系统仅适合存放无敏感性的公开数据（如访问次数、评论）

# 项目链接

- GitHub: [github.com/YHSome/Viewer](https://github.com/YHSome/Viewer)
- 在线体验: [yhsome.github.io/Viewer](https://yhsome.github.io/Viewer)
