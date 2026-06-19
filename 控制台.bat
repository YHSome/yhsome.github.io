@echo off
cd /d "%~dp0"
set PYTHONPATH=.
set PYTHONIOENCODING=utf-8
:menu
cls
echo ==========================================
echo   OpenBlogger 控制台
echo ==========================================
echo.
echo    [1] 写文章     打开 Raw 文件夹
echo    [2] 改配置     打开 site.json
echo    [3] 本地预览   构建 + 启动服务器 + 打开浏览器
echo    [4] 仅构建     只渲染，不预览
echo    [5] 推送源码   推送 main 分支
echo    [6] 部署上线   构建 + 推送 gh-pages
echo    [7] 全部推送   推送 main + gh-pages
echo    [8] 退出
echo.
echo ==========================================
choice /c 12345678 /n /m "请输入选项 [1-8]: "
if errorlevel 8 goto exit
if errorlevel 7 goto pushall
if errorlevel 6 goto deploy
if errorlevel 5 goto pushmain
if errorlevel 4 goto build
if errorlevel 3 goto serve
if errorlevel 2 goto config
if errorlevel 1 goto write

:write
start "" "Raw"
echo Raw 文件夹已打开，写完后回来按任意键继续...
pause >nul
goto menu

:config
start "" "OpenBlogger\site.json"
goto menu

:build
echo.
echo [构建中...]
python -m OpenBlogger.cli build --force
echo.
echo 构建完成，按任意键返回...
pause >nul
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
echo [推送 main 分支...]
git add -A
git diff --cached --quiet
if %errorlevel% neq 0 (
    set /p msg="输入 commit 信息: "
    git commit -m "!msg!"
)
git push origin main
echo.
echo 推送完成，按任意键返回...
pause >nul
goto menu

:deploy
echo.
echo [构建...]
python -m OpenBlogger.cli build --force
echo [推送 gh-pages...]
git subtree split --prefix Rendered -b _ghpages_tmp
git push origin _ghpages_tmp:gh-pages --force
git branch -D _ghpages_tmp
echo.
echo 部署完成，按任意键返回...
pause >nul
goto menu

:pushall
echo.
echo [构建...]
python -m OpenBlogger.cli build --force
echo [推送 main...]
git add -A
git diff --cached --quiet
if %errorlevel% neq 0 (
    set /p msg="输入 commit 信息: "
    git commit -m "!msg!"
)
git push origin main
echo [推送 gh-pages...]
git subtree split --prefix Rendered -b _ghpages_tmp
git push origin _ghpages_tmp:gh-pages --force
git branch -D _ghpages_tmp
echo.
echo 全部推送完成，按任意键返回...
pause >nul
goto menu

:exit
echo 再见！
