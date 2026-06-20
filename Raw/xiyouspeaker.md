time: 2023.8.22
tag: 项目, 学习
title: 西柚朗读者（西柚英语辅助）

**此文章同步保存在以下网站**

[森的神秘空间](https://yhsome.github.io/2023/08/23/xiyouspeaker)

[github](https://github.com/YHSome/xiyouspeaker/)

# 功能简介

该脚本可以帮助你完成 [西柚英语](https://student.xiyouyingyu.com/) 中的朗读部分。

西柚朗读者由上一代的西柚选择者改制而来，两者并不兼容

[github项目地址/下载地址](https://github.com/YHSome/xiyouspeaker/)

# 使用方法

下面是演示视频

<video width="640" controls>
  <source src="https://raw.githubusercontent.com/YHSome/xiyouspeaker/main/example.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## 第一步：安装python以及相应库

你需要安装的python库有

```
pyaudio
SpeechRecognition
pyautogui
```

> 1. 首先，确保你的计算机上已经安装了Python。
> 2. 安装pip：
> ```
> python -m ensurepip --upgrade
> ```
> 3. 安装pyaudio：`pip install pyaudio`
>    - 如果你使用的是Windows操作系统且安装失败，请尝试 `pip install pipwin && pipwin install pyaudio`
> 4. 安装SpeechRecognition：`pip install SpeechRecognition`
> 5. 安装pyautogui：`pip install pyautogui`

## 第二步：完成相应配置

打开 `./config.json` ，填写相应配置。**提示：** 你可以使用 `./快速配置.py` 快速完成配置

> "screensize": 屏幕分辨率【x,y】
> "startpos": 朗读开始按钮的坐标【x,y】
> "startcolor": 记录按钮的颜色（rgb格式）【r,g,b】
> "shotrange": 朗读文本的范围（宽高）【宽,高】
> "clickpos": 朗读文本的坐标【x,y】

这个是1600x900分辨率下，谷歌浏览器全屏打开的设置示例

```json
{
  "screensize": [1600,900],
  "startpos": [546,410],
  "startcolor": [252,177,68],
  "shotrange": [665,70],
  "clickpos": [720,380]
}
```

这个是1600x900分辨率下，谷歌浏览器（左）半屏打开向右拉到底的设置示例

```json
{
  "screensize": [1600,900],
  "startpos": [350,410],
  "startcolor": [252,177,68],
  "shotrange": [665,70],
  "clickpos": [525,380]
}
```

## 第三步：启动程序与故障排除

你可以用cmd运行，也可以用vscode等ide运行文件

```
python speake rV1.0.py
```

**注意：首次启动时会下载语音识别模型，需要耐心等待，如果出现服务器拒绝连接的问题，请重新运行程序或选择适合的代理**

### 出现了录入了但是没有反应的状况？

请检查你的config.json配置文件的clickpos参数是否正确，以及是否关闭了其他可能占用麦克风的程序

### 如果依然无法使用？

请尝试重启程序，或者重启电脑

# 此脚本的不足

由于基于本地的语音识别模型，识别速度和准确度会随着电脑性能而有所不同。我的便携电脑cpu不太好加上未针对模型进行训练和优化，识别准确率不太高（可能也是因为我发音不准吧）。麦克风的质量也会影响识别准确率。
