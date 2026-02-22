@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "DOTFILES_DIR=%%~fI"
set "APPDATA_DIR=%APPDATA%"
set "FAILED=0"

if not exist "%USERPROFILE%\vimfiles" mkdir "%USERPROFILE%\vimfiles"
if not exist "%APPDATA_DIR%\Zed" mkdir "%APPDATA_DIR%\Zed"

call :link_file "%USERPROFILE%\.gitconfig" "%DOTFILES_DIR%\.gitconfig"
call :link_file "%USERPROFILE%\.gvimrc" "%DOTFILES_DIR%\.gvimrc"
call :link_file "%USERPROFILE%\.ideavimrc" "%DOTFILES_DIR%\.ideavimrc"
call :link_file "%USERPROFILE%\.vimrc" "%DOTFILES_DIR%\.vimrc"
call :link_file "%USERPROFILE%\.dein.toml" "%DOTFILES_DIR%\.dein.toml"
call :link_file "%USERPROFILE%\.deinlazy.toml" "%DOTFILES_DIR%\.deinlazy.toml"

call :link_dir "%APPDATA_DIR%\alacritty" "%DOTFILES_DIR%\.config\alacritty"

call :link_file "%APPDATA_DIR%\Zed\settings.json" "%DOTFILES_DIR%\.config\zed\settings.json"
call :link_file "%APPDATA_DIR%\Zed\keymap.json" "%DOTFILES_DIR%\.config\zed\keymap.json"

if "%FAILED%"=="0" (
  echo done
  exit /b 0
)

echo failed
exit /b 1

:link_file
set "DEST=%~1"
set "SRC=%~2"
if exist "%DEST%" del /f /q "%DEST%" >nul 2>&1
mklink /H "%DEST%" "%SRC%" >nul 2>&1
if not errorlevel 1 exit /b 0
mklink "%DEST%" "%SRC%" >nul 2>&1
if not errorlevel 1 exit /b 0
echo link_file failed: %DEST%
set "FAILED=1"
exit /b 0

:link_dir
set "DEST=%~1"
set "SRC=%~2"
if exist "%DEST%" rmdir /s /q "%DEST%" >nul 2>&1
mklink /J "%DEST%" "%SRC%" >nul 2>&1
if not errorlevel 1 exit /b 0
mklink /D "%DEST%" "%SRC%" >nul 2>&1
if not errorlevel 1 exit /b 0
echo link_dir failed: %DEST%
set "FAILED=1"
exit /b 0
