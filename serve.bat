@echo off
chcp 65001 >nul
cd /d "%~dp0"
set PYTHONPATH=.
echo 正在构建...
python -m OpenBlogger.cli build --force
echo.
echo 启动预览服务器...
python -m OpenBlogger.cli serve
pause
