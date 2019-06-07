mkdir %HOMEPATH%"\vimfiles" > NUL 2>&1
if ERRORLEVEL 1 cmd /c exit 0
mklink %HOMEPATH%"\.gitconfig" %HOMEPATH%"\dotfiles\.gitconfig"
mklink %HOMEPATH%"\.gvimrc" %HOMEPATH%"\dotfiles\.gvimrc"
mklink %HOMEPATH%"\.ideavimrc" %HOMEPATH%"\dotfiles\.ideavimrc"
mklink %HOMEPATH%"\.vimrc" %HOMEPATH%"\dotfiles\.vimrc"
mklink %HOMEPATH%"\.dein.toml" %HOMEPATH%"\dotfiles\.dein.toml"
mklink %HOMEPATH%"\.deinlazy.toml" %HOMEPATH%"\dotfiles\.deinlazy.toml"
mklink %HOMEPATH%"\.deinlazy.toml" %HOMEPATH%"\dotfiles\.deinlazy.toml"
mklink /d %APPDATA%"\alacritty" %HOMEPATH%"\dotfiles\.config\alacritty"
