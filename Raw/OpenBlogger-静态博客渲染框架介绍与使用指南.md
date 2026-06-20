time: 2026.6.19
tag: 项目
title: OpenBlogger 静态博客渲染框架：介绍与使用指南

# 概述

OpenBlogger 是一个轻量级静态博客渲染引擎。Markdown 写文章，Python 一键生成完整站点。

与 Hexo、Hugo 等传统静态站点生成器的最大区别：**模板自包含**。每一个 HTML 模板都是完整的——CSS 内联在 `<style>` 里，JS 内联在 `<script>` 里，不依赖任何外部样式库或构建工具。一个 Python 脚本 + 六个 HTML 模板 = 一个完整的博客。

```bash
pip install markdown Jinja2 Pygments
git clone --recurse-submodules https://github.com/YHSome/yhsome.github.io.git
双击 控制台.bat → [3] 本地预览
```

# 项目架构

## 两层仓库

OpenBlogger 采用**框架与内容分离**的架构：

| 仓库 | 内容 | 独立维护 |
|------|------|----------|
| `YHSome/OpenBlogger` | 渲染引擎 + 模板 + Viewer 插件 | 框架更新 |
| `YHSome/yhsome.github.io` | 文章 + 图片 + 站点配置 | 内容创作 |

博客仓库通过 **git submodule** 引用框架仓库。更新框架不影响文章，写文章不涉及框架代码。

## 目录结构

```
博客项目/
├── Raw/                     ← 你的 Markdown 文章
├── Image/                   ← 图片和下载资源
├── OpenBlogger/             ← 框架（git submodule）
│   ├── renderer.py          ← 核心渲染引擎
│   ├── cli.py               ← 命令行工具
│   └── Template/Default/    ← 6 个 HTML 模板
├── Plugins/                 ← 博客专属插件
│   └── GitHubProjects/      ← 仓库列表拉取
├── site.json                ← 站点配置
├── Rendered/                ← 构建输出（gitignored）
├── .archive/                ← 历史存档（gitignored）
├── .data/                   ← 运行时缓存（gitignored）
└── 控制台.bat               ← 中控面板
```

## 控制台

双击 `控制台.bat` 进入中控面板：

```
[1] 写文章     → 打开 Raw/ 文件夹
[2] 改配置     → 打开 site.json
[3] 本地预览   → 构建 + 启动服务器 + 浏览器
[4] 仅构建     → 只渲染
[5] 推送源码   → git push main
[6] 部署上线   → 构建 + git subtree push gh-pages
[7] 全部推送   → main + gh-pages
[8] 退出
```

# 写作规范

## 文章格式

每篇文章是一个 `.md` 文件，放在 `Raw/` 目录。文件头部是元数据区，空行后是 Markdown 正文：

```
time: 2026.6.19
tag: 项目
title: OpenBlogger 静态博客渲染框架

正文开始...（Markdown 格式）
```

## 元数据字段

| 字段 | 必填 | 说明 |
|------|------|------|
| `time` | 否 | 发布日期，缺省取当前时间。格式：`2026.6.19` |
| `title` | 否 | 文章标题，缺省取正文第一句（超 20 字截断加省略号） |
| `tag` | 是 | 标签，逗号分隔。如 `tag: 项目, 软件, Python` |
| `author` | 否 | 作者名，缺省取 `site.json` 中的 `author` |

## Markdown 支持

渲染器使用 Python `markdown` 库，启用了以下扩展：

- `extra`：表格、脚注、定义列表、缩写
- `codehilite`：代码语法高亮（Pygments）
- `toc`：自动生成目录
- `sane_lists`：更合理的列表解析
- `smarty`：智能引号、破折号

支持在 Markdown 中直接嵌入原始 HTML（如 `<video>` 标签）。

# 站点配置

`site.json` 位于项目根目录：

```json
{
    "site_title": "我的博客",
    "site_description": "用文字记录思考与生活。",
    "author": "博主",
    "site_url": "https://yhsome.github.io",
    "posts_per_page": 10,
    "date_format": "%Y年%m月%d日",
    "enable_rss": true,
    "enable_sitemap": true,
    "viewer": {
        "enable_counter": true,
        "enable_unique": true,
        "enable_global": true,
        "enable_comment": true,
        "user": "你的TinyWebDB用户名",
        "secret": "你的TinyWebDB密钥"
    }
}
```

## Viewer 配置

Viewer 是内置的访问计数与评论插件，基于 TinyWebDB 云数据库。

去 [tinywebdb.appinventor.space](https://tinywebdb.appinventor.space) 注册账号，把 `user` 和 `secret` 填入配置。不想用的话把 `enable_*` 都设为 `false`。

# 模板系统

6 个模板覆盖了博客的全部页面：

| 模板 | 页面 | 特点 |
|------|------|------|
| `Homepage.html` | 首页 | 三栏布局：标签侧栏 + 文章卡片 + 弹幕 |
| `Directory.html` | 目录 | 搜索 + 标签过滤 + 年月分组 + 日历定位 |
| `Post.html` | 文章 | 三栏：统计/标签 + 正文 + 评论弹幕 |
| `Tag.html` | 标签 | 悬停展开关联文章列表 |
| `Projects.html` | 项目 | GitHub 仓库卡片展示 |
| `Links.html` | 友链 | 旧项目导航 |

所有模板使用 Jinja2 语法，变量由渲染器注入。模板自包含——CSS 全部内联，不依赖外部样式库。

# 构建流程

双击 `控制台.bat` → `[4] 仅构建`，或直接运行 `python -m OpenBlogger.cli build --force`：

```
Step 1: 扫描 Raw/*.md → 解析元数据 + Markdown 正文
Step 2: MD → HTML（代码高亮 + 智能引号 + 表格）
Step 3: 按日期倒序排列
Step 4: 渲染文章页 → posts/xxx.html（每篇独立）
Step 5: 渲染列表页 → index/directory/tags/projects/links
Step 6: 生成 RSS + Sitemap
Step 7: 复制 Image/ → Rendered/images/posts/
Step 8: 复制友链项目 → Rendered/friends/
Step 9: 复制 Viewer JS → Rendered/js/viewer/
Step 10: 保存缓存 + 页面编号
```

增量构建：文件哈希缓存，只重建变更页面。

# 部署

GitHub Pages 部署采用 `git subtree` 策略：

- `main` 分支：完整源代码（文章、图片、配置、框架 submodule）
- `gh-pages` 分支：仅 `Rendered/` 中的 HTML 文件

双击 `控制台.bat` → `[6] 部署上线` 即可一键部署。部署后在仓库 Settings → Pages 中将源设为 `gh-pages` 分支。

# 特色功能

## 深色模式零闪屏

在 `<head>` 最前面插入同步阻塞脚本，在 `<body>` 渲染前就根据 localStorage 或系统偏好确定颜色模式，避免"先白后黑"的闪光弹。

## 页面转场动画

CSS `cubic-bezier(0.22, 0.61, 0.36, 1)` 实现初速为负的加速入场——元素从边缘弹出时先冲过头再弹回。退场时各元素朝最近边缘飞走渐隐。导航拦截 + bfcache 恢复兼容。

## 弹幕评论

首页右侧精选发言——遍历全站所有页面拉取评论，翻倍拼接后 CSS `translateY(-50%)` 无缝循环。文章页弹幕仅展示当前页评论。鼠标悬停暂停滚动。

## 标签体系

每篇文章可打多个标签。侧栏"精选标签"从文章数 ≥2 的标签中随机抽取展示。标签页悬停标签即可展开该标签下所有文章列表。目录页支持标签筛选 + 年月分组 + 日历日期定位。

## 项目展示

通过 GitHub API 自动拉取仓库列表，渲染为项目卡片。有 GitHub Pages 的仓库自动链接到 Pages 地址。友链页面展示旧项目导航。

# 自定义主题

在 `OpenBlogger/Template/` 下新建文件夹（如 `Modern/`），放入你自己的模板文件。构建时指定主题：

```bash
python -m OpenBlogger.cli build --theme Modern
```

模板变量参考各页面默认模板中的 Jinja2 语法。所有 CSS 和 JS 完全由你控制。

# 从 Hexo 迁移

`import_legacy.py` 可以从 Hexo 渲染后的 HTML 逆向提取文章：

```bash
python OpenBlogger/import_legacy.py
```

自动识别标题、日期、正文，`html2text` 转换 HTML → Markdown。标题前缀（如"时评-"、"随笔-"）自动提取为标签。

# 项目链接

- 框架仓库：[github.com/YHSome/OpenBlogger](https://github.com/YHSome/OpenBlogger)
- 演示站点：[yhsome.github.io](https://yhsome.github.io)
- 依赖：Python 3.9+ / markdown / Jinja2 / Pygments
