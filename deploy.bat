@echo off
cd /d "%~dp0"
set PYTHONPATH=.
set PYTHONIOENCODING=utf-8
echo ========================================
echo   OpenBlogger GitHub Pages Deploy
echo ========================================
echo.

echo [1/3] Building site...
python -m OpenBlogger.cli build --force
if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo [2/3] Pushing Rendered/ to gh-pages...
git subtree push --prefix Rendered origin gh-pages
if %errorlevel% neq 0 (
    echo First deploy? Trying force push...
    git push origin `git subtree split --prefix Rendered main`:gh-pages --force
)

echo [3/3] Committing source changes...
git add -A
git diff --cached --quiet
if %errorlevel% neq 0 (
    git commit -m "Deploy: %date% %time%"
    git push origin main
) else (
    echo No source changes to commit.
)

echo.
echo Deploy done!
pause
