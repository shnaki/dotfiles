#!/bin/bash

for f in $HOME/dotfiles/.??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -sf ~/dotfiles/"$f" ~/
done
