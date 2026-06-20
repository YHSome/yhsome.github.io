time: 2023.8.19
tag: 项目, 学习
title: 西柚选择者（西柚英语辅助）

**此文章同步保存在以下网站**

[森的神秘空间](https://yhsome.github.io/2023/08/19/xiyouchooser)

[github](https://github.com/YHSome/xiyouchooser/)

# 功能简介

该脚本可以帮助你完成 [西柚英语](https://student.xiyouyingyu.com/) 中烦人的看词选义和看义选词。
[github项目地址/下载地址](https://github.com/YHSome/xiyouchooser/)

# 使用方法

下面是演示视频

<video width="640" controls>
  <source src="https://raw.githubusercontent.com/YHSome/xiyouchooser/main/example.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## 第一步：安装python以及相应库

你需要安装的python库有

```
pytesseract
transformers
pillow
pyautogui
```

> 要安装pytesseract、transformers、pillow和pyautogui这些Python库，可以按照以下步骤进行：
>
> 1. 首先，确保你的计算机上已经安装了Python。你可以从Python官方网站下载并安装最新版本的Python。
> 2. 安装pip：pip是Python的包管理工具，用于安装和管理Python库。如果你还没有安装pip，可以通过以下命令在命令提示符或终端中安装：
> ```
> python -m ensurepip --upgrade
> ```
> 3. 安装pytesseract：
>    - 如果你使用的是Windows操作系统：`pip install pytesseract`
>    - 如果你使用的是Linux操作系统：`pip install pillow pytesseract`
>    - 如果你使用的是MacOS：`pip install pillow pytesseract`
> 4. 安装transformers：`pip install transformers`
> 5. 安装pillow：`pip install pillow`
> 6. 安装pyautogui：`pip install pyautogui`
>
> 这些步骤应该可以帮助你安装所需的Python库。

## 第二步：完成相应配置

打开 `./config.json` ，填写相应配置。以下是配置文件的相关释义
**提示：** 你可以使用 `./快速配置.py` 快速完成配置

> "screensize": 屏幕分辨率【x,y】
> "randompos": A选项的坐标【x,y】
> "nextpos": 选择错误选项时，'下一个'按钮的坐标【x,y】
> "shotrange": 题目单词的范围（注意，只要加粗黑字题目的信息，不要把下一行的音标也框进去了）【左上角x,左上角y,右下角x,右下角y】
> "scanrange": 题目的范围（注意，该范围是严格的，即以a选项的上边框，d选项的下边框为范围）【左上角x,左上角y,右下角x,右下角y】
> "y_dist": 两个选项边框间的间隙宽度【y】
> "botton_dist": 选项按钮的宽度【y】

这个是1600x900分辨率下，谷歌浏览器全屏打开的设置示例

```json
{
  "screensize": [1600,900],
  "randompos": [535,565],
  "nextpos": [1215,825],
  "shotrange": [500,180,970,225],
  "scanrange": [500,470,970,820],
  "y_dist": 15,
  "botton_dist": 55
}
```

这个是1600x900分辨率下，谷歌浏览器（左）半屏打开向右拉到底的设置示例

```json
{
  "screensize": [1600,900],
  "randompos": [350,565],
  "nextpos": [1025,825],
  "shotrange": [300,180,780,225],
  "scanrange": [300,537,780,795],
  "y_dist": 15,
  "botton_dist": 55
}
```

## 第三步：启动程序

你可以用cmd运行，也可以用vscode等ide运行文件

```
python 看词选义v1.1.py
```

或者

```
python 看义选词v1.0.py
```

**注意：首次启动时会从huggingface.com下载翻译模型，需要耐心等待，如果出现服务器拒绝连接的问题，请重新运行程序或选择适合的代理**

# 此脚本的不足

不幸的是，谷歌翻译在2022年9月停止了对中国大陆的翻译服务，所以我们只能采用huggingface提供的本地离线翻译模型。

由于基于本地的图像识别以及翻译模型，识别速度和准确度会随着电脑性能而有所不同。我的便携电脑cpu不太好，识别准确率只有70%左右。

~~谁让我没钱买百度识别和百度翻译的的api呢~~

# 未来的展望

目前只做了两个功能，会考虑以后更多功能的开发
