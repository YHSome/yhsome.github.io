@echo off
cd /d "%~dp0"
set PYTHONPATH=.
set PYTHONIOENCODING=utf-8
echo Building...
python -m OpenBlogger.cli build --force
echo.
echo Starting preview server...
python -m OpenBlogger.cli serve
pause
