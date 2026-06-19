@echo off
chcp 65001 >nul
cd /d "%~dp0"
set PYTHONPATH=.
echo ========================================
echo   OpenBlogger GitHub Pages 一键部署
echo ========================================
echo.

REM Step 1: 构建
echo [1/3] 正在构建站点...
python -m OpenBlogger.cli build --force
if %errorlevel% neq 0 (
    echo ❌ 构建失败
    pause
    exit /b 1
)

REM Step 2: 将 Rendered/ 推送到 gh-pages 分支
echo [2/3] 推送 Rendered/ → gh-pages 分支...
git subtree push --prefix Rendered origin gh-pages
if %errorlevel% neq 0 (
    echo ⚠️ 首次部署？尝试强制推送...
    git push origin `git subtree split --prefix Rendered main`:gh-pages --force
)

REM Step 3: 提交源代码变更
echo [3/3] 提交源码...
git add -A
git diff --cached --quiet
if %errorlevel% neq 0 (
    git commit -m "Deploy: %date% %time%"
    git push origin main
) else (
    echo 没有源码变更，跳过
)

echo.
echo ✅ 部署完成！
echo 访问: https://yhsome.github.io/{仓库名}/
pause
