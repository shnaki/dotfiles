@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "DOTFILES_DIR=%%~fI"
set "APPDATA_DIR=%APPDATA%"

if not exist "%USERPROFILE%\vimfiles" mkdir "%USERPROFILE%\vimfiles"
if not exist "%APPDATA_DIR%\Zed" mkdir "%APPDATA_DIR%\Zed"

call :link_or_copy_file "%USERPROFILE%\.gitconfig" "%DOTFILES_DIR%\.gitconfig"
call :link_or_copy_file "%USERPROFILE%\.gvimrc" "%DOTFILES_DIR%\.gvimrc"
call :link_or_copy_file "%USERPROFILE%\.ideavimrc" "%DOTFILES_DIR%\.ideavimrc"
call :link_or_copy_file "%USERPROFILE%\.vimrc" "%DOTFILES_DIR%\.vimrc"
call :link_or_copy_file "%USERPROFILE%\.dein.toml" "%DOTFILES_DIR%\.dein.toml"
call :link_or_copy_file "%USERPROFILE%\.deinlazy.toml" "%DOTFILES_DIR%\.deinlazy.toml"

call :link_or_copy_dir "%APPDATA_DIR%\alacritty" "%DOTFILES_DIR%\.config\alacritty"

call :link_or_copy_file "%APPDATA_DIR%\Zed\settings.json" "%DOTFILES_DIR%\.config\zed\settings.json"
call :link_or_copy_file "%APPDATA_DIR%\Zed\keymap.json" "%DOTFILES_DIR%\.config\zed\keymap.json"

if not exist "%APPDATA_DIR%\Code\User" mkdir "%APPDATA_DIR%\Code\User"
call :link_or_copy_file "%APPDATA_DIR%\Code\User\settings.json" "%DOTFILES_DIR%\.config\Code\User\settings.json"
call :link_or_copy_file "%APPDATA_DIR%\Code\User\keybindings.json" "%DOTFILES_DIR%\.config\Code\User\keybindings.json"

if not exist "%APPDATA_DIR%\jj" mkdir "%APPDATA_DIR%\jj"
call :link_or_copy_file "%APPDATA_DIR%\jj\config.toml" "%DOTFILES_DIR%\.config\jj\config.toml"

echo done
exit /b 0

:link_or_copy_file
set "DEST=%~1"
set "SRC=%~2"
if exist "%DEST%" del /f /q "%DEST%" >nul 2>&1
mklink "%DEST%" "%SRC%" >nul 2>&1
if errorlevel 1 copy /y "%SRC%" "%DEST%" >nul
exit /b 0

:link_or_copy_dir
set "DEST=%~1"
set "SRC=%~2"
if exist "%DEST%" rmdir /s /q "%DEST%" >nul 2>&1
mklink /d "%DEST%" "%SRC%" >nul 2>&1
if errorlevel 1 xcopy "%SRC%" "%DEST%\" /e /i /y >nul
exit /b 0
