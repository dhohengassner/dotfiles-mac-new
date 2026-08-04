#! /usr/local/bin/zsh

# claude
alias claude-bethel="CLAUDE_CONFIG_DIR=~/.claude-bethel claude"

# tmux aliases
alias t='tmux attach || tmux new -s main'
alias tn='tmux new -s'
alias ta='tmux attach'
alias tan='tmux a -t'
alias tls='tmux ls'
alias tksn='tmux kill-session -t'
alias tk!='tmux kill-server'

# go aliases
alias gor='go run'
alias gob='go build'
alias gog='GIT_TERMINAL_PROMPT=1 go get'
alias goga='GIT_TERMINAL_PROMPT=1 go get -d -t .'
alias gogr='GIT_TERMINAL_PROMPT=1 go get -d -v -t ./...'
alias gogm='GIT_TERMINAL_PROMPT=1 go get -d -v ./...'
alias cdg="cd $GOPATH/src"
alias gt='go test'
alias gtr='go test -v ./...'
alias gomv='go mod verify'
alias gomt='go mod tidy'

# AWS
alias awsp='export AWS_PROFILE=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | fzf)'

# Docker aliases
alias db='docker build .'
alias dcr='docker create'
alias ds='docker start'
alias dk='docker kill'
alias drm='docker rm'
alias drmf='docker rm -f'
alias drmi='docker rmi'
alias dei='docker exec -it'

alias drm!='docker rm -f $(docker ps -a -q)'
alias dk!='docker kill $(docker ps -a -q)'
alias drmi!='docker rmi $(docker images -q)'

alias di='docker images'
alias dia='docker images -a'
alias dps='docker ps'
alias dpsa='docker ps -a'

alias dip!='docker image prune -a'
alias dsp!='docker system prune -a'

alias dcup='docker compose up'
alias dcupd='docker compose up -d'
alias dcstop='docker compose stop'
alias dcdown='docker compose down'
alias dckill='docker compose kill'

alias dlogecr='eval $(aws ecr get-login --no-include-email)'

# terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfa!='terraform apply -auto-approve'

# ssh-agent
alias ssha='ssh-add'
alias sshl='ssh-add -l'
alias sshd='ssh-add -D'

# exa
# http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion
(( $+commands[exa] )) && {
    alias el='exa'
    alias ela='exa -la'
    alias ell='exa -lag'
    alias elg='exa -bghHliS --git'
}

# Homebrew
alias brews='brew list -1'
alias bubo='brew update && brew outdated'
alias bubc='brew upgrade && brew cleanup'
alias bubu='bubo && bubc'

# Antibody
alias antiup='antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh'

# Red Bull Lifter
alias rl='lifter'
alias rls='lifter sso --admin-only --trays cc'

# Ruby
alias be='bundle exec'

# some other stuff
alias re='/bin/zsh --login'
alias h='history'

# Akamai
alias akcurl='curl -I -H "Pragma: akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-get-request-id"'

# overwrite vault oidc login
mkdir -p ~/.vault-tools

cat > ~/.vault-tools/open <<EOF
#!/bin/sh
echo vault-tools
/usr/bin/open -a safari \$1
EOF
chmod +x ~/.vault-tools/open

vault_login_oidc() {
  PATH=~/.vault-tools:$PATH vault login -method=oidc $1
}

alias vault-login-oidc="vault_login_oidc"
