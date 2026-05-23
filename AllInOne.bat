@echo off
chcp 65001 > NUL
set EASY_TOOLS=%~dp0EasyTools
set GITHUB_CLONE_OR_PULL_HASH=%EASY_TOOLS%\Git\GitHub_CloneOrPull_Hash.bat
set CIVITAI_MODEL_DOWNLOAD=%EASY_TOOLS%\Civitai\Civitai_ModelDownload.bat
set HUGGING_FACE=%EASY_TOOLS%\Download\HuggingFace.bat
set "ALL_IN_ONE_MARKER=%~dp0AllInOneInstalled.txt"
set "EXTRA_CHECKPOINTS_ENABLED=0"

if exist "%~dp0AllInOneExtraCheckpoints.txt" (
	set "EXTRA_CHECKPOINTS_ENABLED=1"
	del /Q "%~dp0AllInOneExtraCheckpoints.txt"
)

call "%~dp0Setup-AnimaBaseV10.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

if not exist "%~dp0ComfyUI\custom_nodes\" ( mkdir "%~dp0ComfyUI\custom_nodes" )
if not exist "%~dp0ComfyUI\models\loras\" ( mkdir "%~dp0ComfyUI\models\loras" )
if not exist "%~dp0ComfyUI\models\checkpoints\" ( mkdir "%~dp0ComfyUI\models\checkpoints" )
if not exist "%~dp0ComfyUI\models\controlnet\" ( mkdir "%~dp0ComfyUI\models\controlnet" )
if not exist "%~dp0ComfyUI\input\" ( mkdir "%~dp0ComfyUI\input" )
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

@REM https://github.com/Comfy-Org/Nvidia_RTX_Nodes_ComfyUI
call :GITHUB_HASH_REQUIREMENTS Comfy-Org Nvidia_RTX_Nodes_ComfyUI main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

@REM https://github.com/ltdrdata/ComfyUI-Impact-Pack
call :GITHUB_HASH_REQUIREMENTS ltdrdata ComfyUI-Impact-Pack Main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

@REM https://github.com/ltdrdata/was-node-suite-comfyui
call :GITHUB_HASH_REQUIREMENTS ltdrdata was-node-suite-comfyui main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

@REM https://github.com/spacepxl/ComfyUI-Image-Filters
call :GITHUB_HASH_REQUIREMENTS spacepxl ComfyUI-Image-Filters main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

@REM https://github.com/kohya-ss/ComfyUI-Anima-LLLite
call :GITHUB_HASH_REQUIREMENTS kohya-ss ComfyUI-Anima-LLLite main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

@REM https://github.com/bugltd/ComfyLab-Pack
call :GITHUB_HASH_REQUIREMENTS bugltd ComfyLab-Pack main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

@REM https://github.com/hybskgks28275/ComfyUI-hybs-nodes
call :GITHUB_HASH_REQUIREMENTS hybskgks28275 ComfyUI-hybs-nodes main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

popd rem "%~dp0ComfyUI\custom_nodes"

pushd "%~dp0ComfyUI\models\checkpoints"
if exist sam3.1_multiplex_fp16.safetensors ( goto :EXIST_SAM31_MULTIPLEX )
call "%HUGGING_FACE%" ".\" "sam3.1_multiplex_fp16.safetensors" "Comfy-Org/sam3.1" "checkpoints/"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_SAM31_MULTIPLEX
popd rem "%~dp0ComfyUI\models\checkpoints"

call :ASK_EXTRA_CHECKPOINTS
if %ERRORLEVEL% neq 0 ( exit /b 1 )

pushd "%~dp0ComfyUI\models\loras"
if exist anima-turbo-lora-v0.1.safetensors ( goto :EXIST_ANIMA_TURBO_LORA )
call "%CIVITAI_MODEL_DOWNLOAD%" ".\" "anima-turbo-lora-v0.1.safetensors" "2560840" "2877687"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_ANIMA_TURBO_LORA
popd rem "%~dp0ComfyUI\models\loras"

pushd "%~dp0ComfyUI\models\controlnet"
if exist anima-lllite-any-test-like-v2.safetensors ( goto :EXIST_ANIMA_LLLITE_ANY_TEST_LIKE )
call "%HUGGING_FACE%" ".\" "anima-lllite-any-test-like-v2.safetensors" "kohya-ss/Anima-LLLite" ""
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_ANIMA_LLLITE_ANY_TEST_LIKE

if exist anima-lllite-inpainting-v2.safetensors ( goto :EXIST_ANIMA_LLLITE_INPAINTING )
call "%HUGGING_FACE%" ".\" "anima-lllite-inpainting-v2.safetensors" "kohya-ss/Anima-LLLite" ""
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_ANIMA_LLLITE_INPAINTING
popd rem "%~dp0ComfyUI\models\controlnet"

pushd "%~dp0ComfyUI\input"
echo copy /Y "%~dp0Image\*.png" ".\"
copy /Y "%~dp0Image\*.png" ".\"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
popd rem "%~dp0ComfyUI\input"

pushd "%~dp0ComfyUI\user\default\workflows"
echo copy /Y "%~dp0Workflows\*.json" ".\"
copy /Y "%~dp0Workflows\*.json" ".\"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
popd rem "%~dp0ComfyUI\user\default\workflows"

echo EasyAnima AllInOne setup completed.>"%ALL_IN_ONE_MARKER%"
echo ExtraCheckpoints=%EXTRA_CHECKPOINTS_ENABLED%>>"%ALL_IN_ONE_MARKER%"
echo Run Update.bat to refresh AllInOne components.>>"%ALL_IN_ONE_MARKER%"

exit /b 0

:GITHUB_HASH_REQUIREMENTS
set "GITHUB_AUTHOR=%1"
set "GITHUB_REPO=%2"
set "GITHUB_BRANCH=%3"
set "GITHUB_HASH=%4"

call "%GITHUB_CLONE_OR_PULL_HASH%" "%GITHUB_AUTHOR%" "%GITHUB_REPO%" "%GITHUB_BRANCH%" "%GITHUB_HASH%"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

if exist "%GITHUB_REPO%\requirements.txt" (
	setlocal enabledelayedexpansion
	echo pip install -qq -r "%GITHUB_REPO%\requirements.txt"
	pip install -qq -r "%GITHUB_REPO%\requirements.txt"
	if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )
	endlocal
)
exit /b 0

:ASK_EXTRA_CHECKPOINTS
if not exist "%ALL_IN_ONE_MARKER%" goto :ASK_EXTRA_CHECKPOINTS_PROMPT
findstr /C:"ExtraCheckpoints=1" "%ALL_IN_ONE_MARKER%" > NUL
if %ERRORLEVEL% equ 0 goto :DOWNLOAD_EXTRA_CHECKPOINTS
exit /b 0

:ASK_EXTRA_CHECKPOINTS_PROMPT
echo.
echo Download additional AnimaBase derivative CheckPoints? [y/N]
set "EXTRA_CHECKPOINTS_YES_OR_NO="
set /p EXTRA_CHECKPOINTS_YES_OR_NO=

if /i "%EXTRA_CHECKPOINTS_YES_OR_NO%"=="y" goto :DOWNLOAD_EXTRA_CHECKPOINTS
if /i "%EXTRA_CHECKPOINTS_YES_OR_NO%"=="yes" goto :DOWNLOAD_EXTRA_CHECKPOINTS

exit /b 0

:DOWNLOAD_EXTRA_CHECKPOINTS
pushd "%~dp0ComfyUI\models\checkpoints"
if exist animayume_v05.safetensors ( goto :EXIST_ANIMAYUME_V05 )
call "%CIVITAI_MODEL_DOWNLOAD%" ".\" "animayume_v05.safetensors" "2385278" "2963515"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_ANIMAYUME_V05

if exist copycatAnima_20260519.safetensors ( goto :EXIST_COPYCAT_ANIMA_20260519 )
call "%CIVITAI_MODEL_DOWNLOAD%" ".\" "copycatAnima_20260519.safetensors" "2377376" "2959156"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_COPYCAT_ANIMA_20260519

if exist silvermoonmixAnima_v10.safetensors ( goto :EXIST_SILVERMOONMIX_ANIMA_V10 )
call "%CIVITAI_MODEL_DOWNLOAD%" ".\" "silvermoonmixAnima_v10.safetensors" "2639339" "2963435"
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_SILVERMOONMIX_ANIMA_V10
popd rem "%~dp0ComfyUI\models\checkpoints"
set "EXTRA_CHECKPOINTS_ENABLED=1"
exit /b 0
