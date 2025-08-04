source $ZSH/oh-my-zsh.sh
#Android
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:/home/mendes/.local/bin"
#Nvm (js)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#Dotnet
export DOTNET_ENVIRONMENT="Development"
export PATH="$PATH:/home/mendes/.dotnet/tools"
export DOTNET_CLI_TELEMETRY_OPTOUT="1"

ZSH_THEME="macovsky"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

export ZSH="$HOME/.oh-my-zsh"
# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

plugins+=(zsh-vi-mode)

bindkey -v

# Ensure that the Esc key is bound to enter vi-command-mode
bindkey '^[`' vi-command-mode

# Use powerline
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"


# Define a function to run the tmuxsesstionizer script
run_tmuxsesstionizer() {
    /usr/bin/tmux-sessionizer
    zle redisplay
}

# Bind Ctrl-f to the run_tmuxsesstionizer function
zle -N run_tmuxsesstionizer
bindkey '^F' run_tmuxsesstionizer


alias vim=nvim

bindkey '^H' backward-kill-word
