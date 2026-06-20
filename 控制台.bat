@echo off
cd /d "%~dp0"
set PYTHONPATH=.
set PYTHONIOENCODING=utf-8
setlocal enabledelayedexpansion

:menu
cls
echo ==========================================
echo   OpenBlogger 控制台
echo ==========================================
echo.
echo   [1] 写文章     打开 Raw 文件夹
echo   [2] 改配置     打开 site.json
echo   [3] 本地预览   构建 + 服务器 + 浏览器
echo   [4] 仅构建     只渲染，不预览
echo   [5] 推送源码   推送 main 分支
echo   [6] 部署上线   构建 + 推送 gh-pages
echo   [7] 全部推送   main + gh-pages
echo   [8] 退出
echo.
set "opt="
set /p "opt=请输入选项 [1-8]: "
if "%opt%"=="1" goto write
if "%opt%"=="2" goto config
if "%opt%"=="3" goto serve
if "%opt%"=="4" goto build
if "%opt%"=="5" goto pushmain
if "%opt%"=="6" goto deploy
if "%opt%"=="7" goto pushall
if "%opt%"=="8" goto exit
goto menu

:write
start "" "Raw"
echo Raw 文件夹已打开
pause
goto menu

:config
start "" "site.json"
goto menu

:build
echo.
echo [构建中...]
python -m OpenBlogger.cli build --force
echo.
echo 构建完成
pause
goto menu

:serve
echo.
echo [构建 + 启动预览...]
python -m OpenBlogger.cli build --force
start "" http://localhost:8080
python -m OpenBlogger.cli serve
goto menu

:pushmain
echo.
echo [推送 main...]
git add -A
git diff --cached --quiet
if errorlevel 1 (
    set /p msg="commit 信息: "
    git commit -m "!msg!"
)
git push origin main
echo.
echo 推送完成
pause
goto menu

:deploy
echo.
echo [构建 + 推送 gh-pages...]
python -m OpenBlogger.cli build --force
git add -f Rendered/
git commit -m "gh-pages deploy [auto]" 2>nul
git subtree split --prefix Rendered -b _ghp_tmp
git push origin _ghp_tmp:gh-pages --force
git branch -D _ghp_tmp 2>nul
git reset --soft HEAD~1 2>nul
git reset HEAD Rendered/ 2>nul
echo.
echo 部署完成
pause
goto menu

:pushall
echo.
echo [构建 + 全部推送...]
python -m OpenBlogger.cli build --force
git add -A
git diff --cached --quiet
if errorlevel 1 (
    set /p msg="commit 信息: "
    git commit -m "!msg!"
)
git push origin main
git add -f Rendered/
git commit -m "gh-pages deploy [auto]" 2>nul
git subtree split --prefix Rendered -b _ghp_tmp
git push origin _ghp_tmp:gh-pages --force
git branch -D _ghp_tmp 2>nul
git reset --soft HEAD~1 2>nul
git reset HEAD Rendered/ 2>nul
echo.
echo 全部推送完成
pause
goto menu

:exit
echo 再见！
timeout /t 1 >nul
