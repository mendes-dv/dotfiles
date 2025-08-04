#!/bin/bash

# dotfiles

# DOTFILES_DIR=$HOME/ramboe_dotfiles
DOTFILES_DIR=$PWD

DOTFILES_CONFIG_DIR=$DOTFILES_DIR/.config

mkdir -p ~/.config

# cleanup
for dir in $DOTFILES_CONFIG_DIR/*; do
    target_dir=~/.config/$(basename $dir)
    if [ -d "$target_dir" ]; then
        rm -R "$target_dir"
    else
        echo "Skipping $target_dir: directory does not exist."
    fi
done

# link dotfiles

for dir in $DOTFILES_CONFIG_DIR/*; do
    ln -sfn "$dir" ~/.config/$(basename $dir)
done

# fonts

sudo chown -R $USER:$USER ~/.fonts

mkdir -p $HOME/.fonts

FONTS_DIR="$DOTFILES_DIR/.fonts"

for font in "$FONTS_DIR"/*; do
    cp "$font" $HOME/.fonts/
done

# zsh and tmux configuration

for file in $DOTFILES_DIR/.zshrc $DOTFILES_DIR/.tmux.conf; do
    cp "$file" $HOME
done


