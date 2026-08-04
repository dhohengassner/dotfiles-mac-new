#
## Execute command at login before zshrc
#
if [[ -z "$LANG" ]]; then
    export LANG='en_US.UTF-8'
    export LANGUAGE=en_US.UTF-8
fi

export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESSCHARSET=utf-8

# set important vars
export GOPATH=$HOME/go
export GOPRIVATE=appsgit.bethel.jw.org
export SDKMAN_DIR="$HOME/.sdkman"
export PATH="$GOPATH/bin:/usr/local/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/opt/homebrew/sbin/usr/local/bin:/opt/homebrew/opt:/Users/dhohengassner/.local/bin"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
export AWS_REGION='eu-west-1'
