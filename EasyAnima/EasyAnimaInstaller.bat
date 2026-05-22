@echo off
chcp 65001 > NUL

set "PROJECT_NAME=EasyAnima"
set "PROJECT_SETUP_BAT=%~dp0Setup-AnimaBaseV10.bat"
set "PROJECT_ALL_IN_ONE_BAT=%~dp0AllInOne.bat"
@REM set "PROJECT_MODEL_DOWNLOAD_BAT=%~dp0Download.bat"

set PROJECT_URL=https://github.com/hybskgks28275/%PROJECT_NAME%
set PROJECT_BRANCH=main
set "PROJECT_DIR=%~dp0."
set "EASY_TOOLS_DIR=%~dp0EasyTools"

set "EASY_GIT_DIR=%EASY_TOOLS_DIR%\Git"
set EASY_TOOLS_URL=https://github.com/hybskgks28275/EasyTools
set EASY_TOOLS_BRANCH=main

if not exist "C:\Windows\System32\where.exe" (
	echo "[ERROR] C:\Windows\System32\where.exe が見つかりません。"
	pause & exit /b 1
)

set PS_EXE=PowerShell
where /Q %PS_EXE%
if %ERRORLEVEL% neq 0 (
	echo "[ERROR] %PS_EXE% が見つかりません。"
	pause & exit /b 1
)

@REM Windows 10 でプリインストールされているバージョンが 5.1
set PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass

%PS_CMD% -c "if ('%~dp0' -match '^[a-zA-Z0-9:_\\/-]+$') {exit 0}; exit 1"
if %ERRORLEVEL% neq 0 (
	echo "[ERROR] 現在のフォルダパス %~dp0 に英数字・ハイフン・アンダーバー以外が含まれています。"
	echo "英数字・ハイフン・アンダーバーのフォルダパスに bat ファイルを移動して、再実行してください。"
	echo.
	echo "[ERROR] The current folder path %~dp0 contains characters other than alphanumeric, hyphen, and underscore."
	echo "Move the bat file to a folder path with alphanumeric, hyphen, and underscore, and run it again."
	pause & exit /b 1
)

set CURL_EXE=C:\Windows\System32\curl.exe
if not exist %CURL_EXE% (
	echo "[ERROR] %CURL_EXE% が見つかりません。"
	pause & exit /b 1
)
set CURL_CMD=C:\Windows\System32\curl.exe -kL

for %%f in ("%~dp0\*") do (
	if not "%%~nxf"=="%~nx0" (
		echo "[ERROR] インストール先のフォルダに他のファイルが存在します。"
		echo "インストール先のフォルダには %~nx0 しか存在しないようにしてください。"
		echo.
		echo "[ERROR] There are other files in the installation folder."
		echo "There should be only %~nx0 in the installation folder."
		pause & exit /b 1
	)
)

for /d %%d in ("%~dp0\*") do (
	if not "%%~nxd"=="EasyTools" (
		echo "[ERROR] インストール先のフォルダに他のフォルダが存在します。"
		echo "インストール先のフォルダには %~nx0 しか存在しないようにしてください。"
		echo.
		echo "[ERROR] There are other folders in the installation folder."
		echo "There should be only %~nx0 in the installation folder."
		pause & exit /b 1
	)
)

@REM echo "未成年の方は利用できません。"
@REM echo "動作に必要なモデルなどをダウンロードします。よろしいですか？ [y/n]（空欄なら y）"
@REM echo.
@REM echo "Download Model etc. Are you sure? [y/n] (default: y)"
@REM set /p DOWNLOAD_MODEL_YES_OR_NO=

@REM ---- ここから Git/Get_SetPath.bat と同期 ----
where /Q git
if %ERRORLEVEL% equ 0 ( goto :EASY_GIT_FOUND )
cd > NUL

set PORTABLE_GIT_BIN=%EASY_GIT_DIR%\env\PortableGit\bin
set PORTABLE_GIT_VERSION=2.50.1

if not exist %PORTABLE_GIT_BIN%\ (
	setlocal enabledelayedexpansion
	if not exist "%EASY_GIT_DIR%\env\" ( mkdir "%EASY_GIT_DIR%\env" )
	echo https://github.com/git-for-windows/git/

	echo %CURL_CMD% -o %EASY_GIT_DIR%\env\PortableGit.7z.exe https://github.com/git-for-windows/git/releases/download/v%PORTABLE_GIT_VERSION%.windows.1/PortableGit-%PORTABLE_GIT_VERSION%-64-bit.7z.exe
	%CURL_CMD% -o %EASY_GIT_DIR%\env\PortableGit.7z.exe https://github.com/git-for-windows/git/releases/download/v%PORTABLE_GIT_VERSION%.windows.1/PortableGit-%PORTABLE_GIT_VERSION%-64-bit.7z.exe
	if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )

	start "" %PS_CMD% -Command "Start-Sleep -Seconds 5; $title='Portable Git for Windows 64-bit'; $window=Get-Process | Where-Object { $_.MainWindowTitle -eq $title } | Select-Object -First 1; if ($window -ne $null) { [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic'); [Microsoft.VisualBasic.Interaction]::AppActivate($window.Id); Start-Sleep -Seconds 1; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{ENTER}') }"

	echo "操作せずに、そのまま Portable Git for Windows をインストールしてください。"
	echo.
	echo "Please install Portable Git for Windows without operation."
	%EASY_GIT_DIR%\env\PortableGit.7z.exe
	if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )

	echo del %EASY_GIT_DIR%\env\PortableGit.7z.exe
	del %EASY_GIT_DIR%\env\PortableGit.7z.exe
	if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )
	endlocal
)

set "PATH=%PORTABLE_GIT_BIN%;%PATH%"

where /Q git
if %ERRORLEVEL% equ 0 ( goto :EASY_GIT_FOUND )
echo "[Error] Git をインストールできませんでした。手動で Git for Windows をインストールしてください。"
echo.
echo "[Error] Git could not be installed. Please install Git for Windows manually."
pause & exit /b 1

:EASY_GIT_FOUND
@REM ---- ここまで Git/Get_SetPath.bat と同期 --------

call :INIT_REPO "%EASY_TOOLS_DIR%" "%EASY_TOOLS_URL%" "%EASY_TOOLS_BRANCH%"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

call :INIT_REPO "%PROJECT_DIR%" "%PROJECT_URL%" "%PROJECT_BRANCH%"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

@REM Python 3.13系を利用します。
@REM Use Python 3.13 series.

echo 3.13.13> "%EASY_TOOLS_DIR%\Python\Python_DefaultVersion.txt"

if not exist "%PROJECT_SETUP_BAT%" (
	echo "[ERROR] Setup-AnimaBaseV10.bat が見つかりません。"
	echo "[ERROR] Setup-AnimaBaseV10.bat was not found."
	pause & exit /b 1
)
call "%PROJECT_SETUP_BAT%"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

call :ASK_ALL_IN_ONE
if %ERRORLEVEL% neq 0 ( exit /b 1 )

@REM if /i "%DOWNLOAD_MODEL_YES_OR_NO%" == "n" ( goto :FINALIZE )
@REM call %PROJECT_MODEL_DOWNLOAD_BAT%

goto :FINALIZE

:INIT_REPO
set "INIT_REPO_DIR=%~1"
set "INIT_REPO_URL=%~2"
set "INIT_REPO_BRANCH=%~3"

if not exist "%INIT_REPO_DIR%\" ( mkdir "%INIT_REPO_DIR%" )
pushd "%INIT_REPO_DIR%"
if %ERRORLEVEL% neq 0 goto :INIT_REPO_FAILED

echo git init -q
git init -q
if %ERRORLEVEL% neq 0 goto :INIT_REPO_FAILED_POPD

git remote get-url origin > NUL 2>&1
if %ERRORLEVEL% neq 0 goto :INIT_REPO_ADD_ORIGIN
goto :INIT_REPO_FETCH

:INIT_REPO_ADD_ORIGIN
echo git remote add origin %INIT_REPO_URL%
git remote add origin %INIT_REPO_URL%
if %ERRORLEVEL% neq 0 goto :INIT_REPO_FAILED_POPD

:INIT_REPO_FETCH
echo git fetch
git fetch
if %ERRORLEVEL% neq 0 goto :INIT_REPO_FAILED_POPD

echo git pull --ff-only origin %INIT_REPO_BRANCH%
git pull --ff-only origin %INIT_REPO_BRANCH%
if %ERRORLEVEL% neq 0 goto :INIT_REPO_FAILED_POPD

popd
exit /b 0

:INIT_REPO_FAILED_POPD
popd

:INIT_REPO_FAILED
pause
exit /b 1

:ASK_ALL_IN_ONE
echo.
echo Run AllInOne.bat if you want to use all sample workflows.
echo All-in-One installation requires a Civitai API Key.
echo Run AllInOne.bat? [y/N]
echo.
set "ALL_IN_ONE_YES_OR_NO="
set /p ALL_IN_ONE_YES_OR_NO=

if /i "%ALL_IN_ONE_YES_OR_NO%"=="y" goto :RUN_ALL_IN_ONE
if /i "%ALL_IN_ONE_YES_OR_NO%"=="yes" goto :RUN_ALL_IN_ONE

exit /b 0

:RUN_ALL_IN_ONE
if exist "%PROJECT_ALL_IN_ONE_BAT%" goto :CALL_ALL_IN_ONE
echo [ERROR] AllInOne.bat was not found.
pause
exit /b 1

:CALL_ALL_IN_ONE
call "%PROJECT_ALL_IN_ONE_BAT%"
if %ERRORLEVEL% neq 0 exit /b 1
exit /b 0

:FINALIZE

@REM HKEY_LOCAL_MACHINE の変更には管理者権限が必要
echo reg add "HKCU\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
reg add "HKCU\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
if %ERRORLEVEL% neq 0 (
	echo "Windows の長いパス対応を有効にできませんでした。"
	echo "Windows の管理者権限で EasyTools/EnableLongPaths.bat を実行してください。"
	echo.
	echo "Windows could not enable long path support."
	echo "Run EasyTools/EnableLongPaths.bat with Windows administrator privileges."
	pause
)

if exist "%~0" ( del "%~0" )
