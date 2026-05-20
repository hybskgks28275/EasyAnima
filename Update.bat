@echo off
chcp 65001 > NUL

call "%~dp0EasyTools\Git\Git_SetPath.bat"
if %ERRORLEVEL% neq 0 exit /b 1

call :UPDATE_REPO "%~dp0EasyTools" "EasyTools"
if %ERRORLEVEL% neq 0 exit /b 1

call :UPDATE_REPO "%~dp0" "EasyAnima"
if %ERRORLEVEL% neq 0 exit /b 1

call "%~dp0Setup-AnimaBaseV10.bat"
if %ERRORLEVEL% neq 0 exit /b 1

exit /b 0

:UPDATE_REPO
set "UPDATE_REPO_DIR=%~1"
set "UPDATE_REPO_NAME=%~2"
set "UPDATE_REPO_BRANCH="

pushd "%UPDATE_REPO_DIR%"
if %ERRORLEVEL% neq 0 goto :UPDATE_REPO_FAILED

echo.
echo git fetch origin
git fetch origin
if %ERRORLEVEL% neq 0 goto :UPDATE_REPO_FAILED_POPD

for /f "usebackq delims=" %%B in (`git branch --show-current`) do set "UPDATE_REPO_BRANCH=%%B"
if "%UPDATE_REPO_BRANCH%"=="" set "UPDATE_REPO_BRANCH=main"

echo git pull --ff-only origin %UPDATE_REPO_BRANCH%
git pull --ff-only origin %UPDATE_REPO_BRANCH%
if %ERRORLEVEL% neq 0 goto :UPDATE_REPO_FAILED_POPD

popd
exit /b 0

:UPDATE_REPO_FAILED_POPD
popd

:UPDATE_REPO_FAILED
echo [ERROR] Failed to update %UPDATE_REPO_NAME%.
echo [ERROR] Check uncommitted changes, branch divergence, and remote branch availability.
pause
exit /b 1
