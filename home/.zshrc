# Debug startup time
# zmodload zsh/zprof

# Set code as editor
export EDITOR=code
export KUBE_EDITOR='code --wait'

export KUBECONFIG="$KUBECONFIG:/Users/dhohengassner/.kube/config:/Users/dhohengassner/.kube/lifter.kubeconfig"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="racotecnic"

# Temporarily remove NVM due to long loading times
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Lazy load any custom functions
lazyload_fpath=$HOME/.zsh/autoload
fpath=($lazyload_fpath $fpath)
if [[ -d "$lazyload_fpath" ]]; then
    for func in $lazyload_fpath/*; do
        autoload -Uz ${func:t}
    done
fi
unset lazyload_fpath

## Plugin environment vars

# Command-time
export ZSH_COMMAND_TIME_MIN_SECONDS=1
export ZSH_COMMAND_TIME_COLOR="yellow"

# Autosuggest
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Completion caching logic
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
    compinit -i
    compdump
else
    compinit -C -i
fi

# Completion performance improvements
unsetopt menu_complete
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.local/share/zsh/cache
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Direnv
eval "$(direnv hook zsh)"

# Execute all .zsh files in HOME directory - some custom functions
for ZFILE in $HOME/.zsh/*; do
    source $ZFILE
done

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

## Source plugins last
# Static method, after updates run:
# antidote bundle <~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
source ~/.zsh_plugins.zsh

# Homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"

# Iterm2 integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# SDKMAN integration (must be at the end)
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Egcli command path update
if [ -f '/Users/dhohengassner/Library/Group Containers/FELUD555VC.group.com.egnyte.DesktopApp/CLI/egcli.inc' ]; then
    . '/Users/dhohengassner/Library/Group Containers/FELUD555VC.group.com.egnyte.DesktopApp/CLI/egcli.inc'
fi

# FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Show startup time
# zprof[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# VS Code Shell Integration for Copilot
# Fix for terminal completion detection issue
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    # Disable RPROMPT in VS Code (causes detection issues)
    unset RPROMPT
    unset RPS1
    
    # Simplify PROMPT for better compatibility
    PROMPT='%F{032}%~%f %F{105}»%f '
    
    # Load VS Code shell integration
    [[ -f "$(code --locate-shell-integration-path zsh)" ]] && \
        . "$(code --locate-shell-integration-path zsh)"
fi
