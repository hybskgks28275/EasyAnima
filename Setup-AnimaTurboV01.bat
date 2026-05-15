@echo off
chcp 65001 > NUL
set EASY_TOOLS=%~dp0EasyTools
set GITHUB_CLONE_OR_PULL_HASH=%EASY_TOOLS%\Git\GitHub_CloneOrPull_Hash.bat
set CIVITAI_MODEL_DOWNLOAD=%EASY_TOOLS%\Civitai\Civitai_ModelDownload.bat
set CIVITAI_API_KEY_BAT=%EASY_TOOLS%\Civitai\Civitai_ApiKey.bat
set ARIA=%EASY_TOOLS%\Download\Aria.bat
set PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass

call "%~dp0Setup-AnimaBaseV10.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

if not exist "%~dp0ComfyUI\custom_nodes\" ( mkdir "%~dp0ComfyUI\custom_nodes" )
if not exist "%~dp0ComfyUI\models\loras\" ( mkdir "%~dp0ComfyUI\models\loras" )
if not exist "%~dp0ComfyUI\user\default\workflows\" ( mkdir "%~dp0ComfyUI\user\default\workflows" )

pushd "%~dp0ComfyUI"
call venv\Scripts\activate.bat
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )
popd rem "%~dp0ComfyUI"

pushd "%~dp0ComfyUI\custom_nodes"

@REM https://github.com/hybskgks28275/ComfyUI-Anima-NAG
call :GITHUB_HASH_REQUIREMENTS hybskgks28275 ComfyUI-Anima-NAG main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

@REM https://github.com/AdamNizol/ComfyUI-Anima-Enhancer
call :GITHUB_HASH_REQUIREMENTS AdamNizol ComfyUI-Anima-Enhancer master
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

popd rem "%~dp0ComfyUI\custom_nodes"

pushd "%~dp0ComfyUI\models\loras"
if exist anima-turbo-lora-v0.1.safetensors ( goto :EXIST_ANIMA_TURBO_LORA )
call "%CIVITAI_MODEL_DOWNLOAD%" ".\" "anima-turbo-lora-v0.1.safetensors" "2560840" "2877687"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_ANIMA_TURBO_LORA
popd rem "%~dp0ComfyUI\models\loras"

pushd "%~dp0ComfyUI\user\default\workflows"
if exist workflowForSDXLNoobaiXL_animaTurboLoraNAG.zip ( goto :EXIST_ANIMA_TURBO_WORKFLOW_ZIP )
call "%CIVITAI_API_KEY_BAT%"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
set "CIVITAI_API_KEY_FILE=%EASY_TOOLS%\Civitai\CivitaiApiKey.txt"
set /p CIVITAI_API_KEY=<"%CIVITAI_API_KEY_FILE%"
set "ANIMA_TURBO_WORKFLOW_URL=https://civitai.red/api/download/models/2946113?token=%CIVITAI_API_KEY%"
call "%ARIA%" ".\" "workflowForSDXLNoobaiXL_animaTurboLoraNAG.zip" "%ANIMA_TURBO_WORKFLOW_URL%"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_ANIMA_TURBO_WORKFLOW_ZIP

echo %PS_CMD% "try { Expand-Archive -Path workflowForSDXLNoobaiXL_animaTurboLoraNAG.zip -DestinationPath . -Force } catch { exit 1 }"
%PS_CMD% "try { Expand-Archive -Path workflowForSDXLNoobaiXL_animaTurboLoraNAG.zip -DestinationPath . -Force } catch { exit 1 }"
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo del /Q workflowForSDXLNoobaiXL_animaTurboLoraNAG.zip
del /Q workflowForSDXLNoobaiXL_animaTurboLoraNAG.zip
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem "%~dp0ComfyUI\user\default\workflows"

exit /b 0

:GITHUB_HASH_REQUIREMENTS
set "GITHUB_AUTHOR=%1"
set "GITHUB_REPO=%2"
set "GITHUB_BRANCH=%3"
set "GITHUB_HASH=%4"

call %GITHUB_CLONE_OR_PULL_HASH% %GITHUB_AUTHOR% %GITHUB_REPO% %GITHUB_BRANCH% %GITHUB_HASH%
if %ERRORLEVEL% neq 0 ( exit /b 1 )

if exist %GITHUB_REPO%\requirements.txt (
	setlocal enabledelayedexpansion
	echo pip install -qq -r %GITHUB_REPO%\requirements.txt
	pip install -qq -r %GITHUB_REPO%\requirements.txt
	if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )
	endlocal
)
exit /b 0
