time: 2023.8.22
title: 西柚朗读者（西柚英语辅助）

**此文章同步保存在以下网站**

[森的神秘空间](<https://yhsome.github.io/2023/08/23/xiyouspeaker>)

[github](<https://github.com/YHSome/xiyouspeaker/>)

# 功能简介

该脚本可以帮助你完成 [西柚英语](<https://student.xiyouyingyu.com/>) 中烦人的单词朗读。

[github项目地址/下载地址](<https://github.com/YHSome/xiyouspeaker/>)

# 使用方法

下面是演示视频  
  
  
Your browser does not support the video tag.  


## 第一步：安装python以及相应库

你需要安装的python库有
    
    
    1  
    2  
    3  
    

| 
    
    
    sounddevice  
    soundfile  
    pyautogui  
      
  
---|---  
  
> 要安装sounddevice、soundfile和pyautogui这三个Python库，可以按照以下步骤进行：
> 
>   1. 安装Python：  
> 首先，确保你的计算机上已经安装了Python。你可以从Python官方网站下载并安装最新版本的Python。
>   2. 安装pip：  
> pip是Python的包管理工具，用于安装和管理Python库。如果你还没有安装pip，可以通过以下命令在命令提示符或终端中安装：
>          
>          1  
>          > 
> 
> | 
>          
>          python -m ensurepip --upgrade  
>          >   
>   
> ---|---  
>   3. 安装sounddevice库：  
> 在命令提示符或终端中运行以下命令来安装sounddevice库：
>          
>          1  
>          > 
> 
> | 
>          
>          pip install sounddevice  
>          >   
>   
> ---|---  
>   4. 安装soundfile库：  
> 在命令提示符或终端中运行以下命令来安装soundfile库：
>          
>          1  
>          > 
> 
> | 
>          
>          pip install soundfile  
>          >   
>   
> ---|---  
>   5. 安装pyautogui库：  
> 在命令提示符或终端中运行以下命令来安装pyautogui库：
>          
>          1  
>          > 
> 
> | 
>          
>          pip install pyautogui  
>          >   
>   
> ---|---  
> 这样，你就可以使用这些库来运行该程序了。
> 


## 第二步：完成相应设置

### 设置默认录制设备（十分重要！）

**使用前请将系统默认录制设备改成“立体声混音”，否则无法录音**

### 打开 `./config.json` ，填写相应配置。

以下是配置文件的相关释义  
**提示：** 你可以使用 `./快速配置.py` 快速完成配置

> “screensize”: 屏幕分辨率【x,y】

> “nextpos”: ‘下一个’按钮的坐标【x,y】

> “input_icon”: 左下角’立即录音’按钮的坐标【x,y】

> “input_icon”: 单词下方英式发言右边的小喇叭的坐标【x,y】

这个是这个是1600x900分辨率下，谷歌浏览器（左）半屏打开向右拉到底的设置示例
    
    
    1  
    2  
    3  
    4  
    5  
    6  
    

| 
    
    
    {  
      "screensize": [1600,900],  
      "nextpos": [1025,820],  
      "input_icon": [340,800],  
      "example_icon": [333,250]  
    }  
      
  
---|---  
  
## 第三步：启动程序

你可以用cmd运行，也可以用vscode等ide运行文件
    
    
    1  
    

| 
    
    
    $ python 朗读练习v1.0.py  
      
  
---|---  
  
# 未来的展望

目前只做了几个功能，会考虑以后更多功能的开发
