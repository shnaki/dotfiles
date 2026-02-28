umask 022
limit coredumpsize 0
bindkey -d

# Return if zsh is called from Vim
if [[ -n $VIMRUNTIME ]]; then
    return 0
fi

for f in ~/.zsh/[0-9]*.(sh|zsh)
do
    source "$f"
done

# Auto attach
tmux_automatically_attach_session
