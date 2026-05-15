@echo off
chcp 65001 > NUL
set EASY_TOOLS=%~dp0EasyTools
set HUGGING_FACE=%EASY_TOOLS%\Download\HuggingFace.bat

call "%~dp0EasyAnima\Setup.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

if not exist "%~dp0ComfyUI\models\diffusion_models\" ( mkdir "%~dp0ComfyUI\models\diffusion_models" )
if not exist "%~dp0ComfyUI\models\text_encoders\" ( mkdir "%~dp0ComfyUI\models\text_encoders" )
if not exist "%~dp0ComfyUI\models\vae\" ( mkdir "%~dp0ComfyUI\models\vae" )
if not exist "%~dp0ComfyUI\user\default\workflows\" ( mkdir "%~dp0ComfyUI\user\default\workflows" )

pushd "%~dp0ComfyUI\models\diffusion_models"
if exist anima-base-v1.0.safetensors ( goto :EXIST_ANIMA_BASE )
call %HUGGING_FACE% .\ anima-base-v1.0.safetensors circlestone-labs/Anima split_files/diffusion_models/
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_ANIMA_BASE
popd rem "%~dp0ComfyUI\models\diffusion_models"

pushd "%~dp0ComfyUI\models\text_encoders"
if exist qwen_3_06b_base.safetensors ( goto :EXIST_QWEN3_TEXT_ENCODER )
call %HUGGING_FACE% .\ qwen_3_06b_base.safetensors circlestone-labs/Anima split_files/text_encoders/
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_QWEN3_TEXT_ENCODER
popd rem "%~dp0ComfyUI\models\text_encoders"

pushd "%~dp0ComfyUI\models\vae"
if exist qwen_image_vae.safetensors ( goto :EXIST_QWEN_IMAGE_VAE )
call %HUGGING_FACE% .\ qwen_image_vae.safetensors circlestone-labs/Anima split_files/vae/
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_QWEN_IMAGE_VAE
popd rem "%~dp0ComfyUI\models\vae"

pushd "%~dp0ComfyUI\user\default\workflows"
if exist AnimaBaseV10.json ( goto :EXIST_ANIMA_BASE_WORKFLOW )
echo copy /Y "%~dp0Workflows\AnimaBaseV10.json" AnimaBaseV10.json
copy /Y "%~dp0Workflows\AnimaBaseV10.json" AnimaBaseV10.json
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )
:EXIST_ANIMA_BASE_WORKFLOW
popd rem "%~dp0ComfyUI\user\default\workflows"

exit /b 0
