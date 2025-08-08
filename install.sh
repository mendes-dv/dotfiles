#!/usr/bin/env fish
# dotfiles
set DOTFILES_DIR ~/dotfiles
set DOTFILES_CONFIG_DIR $DOTFILES_DIR/.config

mkdir -p ~/.config

# link dotfiles
for file in $DOTFILES_CONFIG_DIR/*
    set target ~/.config/(basename $file)
    if test "$file" != "$target"
        ln -sfn $file $target
    end
end

# tmux config
set TMUX_FILE $DOTFILES_DIR/.tmux.conf
if test "$TMUX_FILE" != "$HOME/.tmux.conf"
    cp $TMUX_FILE $HOME
end

# fish config
if test -f $DOTFILES_DIR/config.fish
    cp $DOTFILES_DIR/config.fish ~/.config/fish/
end

if test -d $DOTFILES_DIR/.config/fish
    cp -r $DOTFILES_DIR/.config/fish/* ~/.config/fish/
end
