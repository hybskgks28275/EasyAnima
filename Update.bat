@echo off
chcp 65001 > NUL

call %~dp0EasyTools\Git\Git_SetPath.bat
if %ERRORLEVEL% neq 0 ( exit /b 1 )

pushd %~dp0EasyTools
echo.
echo git fetch origin
git fetch origin
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

set "EASY_TOOLS_BRANCH="
for /f "delims=" %%b in ('git branch --show-current') do set "EASY_TOOLS_BRANCH=%%b"
if "%EASY_TOOLS_BRANCH%"=="" set "EASY_TOOLS_BRANCH=AnimaBase"
echo git pull --ff-only origin %EASY_TOOLS_BRANCH%
git pull --ff-only origin %EASY_TOOLS_BRANCH%
if %ERRORLEVEL% neq 0 (
	echo "[ERROR] EasyTools を fast-forward 更新できませんでした。未コミット変更や分岐がないか確認してください。"
	pause & popd & exit /b 1
)
popd

pushd %~dp0
echo.
echo git fetch origin
git fetch origin
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

set "SIMPLE_COMFYUI_BRANCH="
for /f "delims=" %%b in ('git branch --show-current') do set "SIMPLE_COMFYUI_BRANCH=%%b"
if "%SIMPLE_COMFYUI_BRANCH%"=="" set "SIMPLE_COMFYUI_BRANCH=AnimaBase"
echo git pull --ff-only origin %SIMPLE_COMFYUI_BRANCH%
git pull --ff-only origin %SIMPLE_COMFYUI_BRANCH%
if %ERRORLEVEL% neq 0 (
	echo "[ERROR] EasyAnima を fast-forward 更新できませんでした。未コミット変更や分岐がないか確認してください。"
	pause & popd & exit /b 1
)
popd

call "%~dp0Setup-AnimaBaseV10.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )
