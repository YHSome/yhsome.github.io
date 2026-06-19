@echo off
cd /d "%~dp0"
set PYTHONPATH=.
set PYTHONIOENCODING=utf-8
python -m OpenBlogger.cli build --force
pause
