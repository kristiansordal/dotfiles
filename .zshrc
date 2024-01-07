alias neofetch='neofetch --source ~/.config/neofetch/asciiart/macintosh.txt'
neofetch
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

export AOC_SESSION="53616c7465645f5ff24cc4c3ad8ebf13d5d53654e9796a46151f8cb026018769a93b279241ac07277389c6b8ee78cdd789c30a6aa5f8e36dc1fd1b2b91e1a819"
export PATH="usr/bin/clang:$PATH"
export PATH="/usr/bin/gcc:$PATH"
export PATH="/opt/homebrew/bin/g++-12:$PATH" # export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# export PATH="/opt/homebrew/Cellar/openjdk@11/bin/java:$PATH"
export PATH="/opt/homebrew/Cellar/openjdk@17/17.0.6/bin:$PATH"
export PATH="~/.local/bin/lvim:$PATH"
# export PATH="~/kattis-cli:$PATH"
# export PATH="/usr/bin/java:$PATH"
export JAVA_HOME="/opt/homebrew/Cellar/openjdk@17/17.0.7/"
# export JAVA_HOME="/opt/homebrew/opt/openjdk@17/bin/java"
# export JAVA_HOME="/opt/homebrew/bin/gradle"
# export JAVA_HOME="usr/bin/"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# PS1="[\u@\h$'\uE0B0' \W]\$ "

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh

# aliases
alias zshconfig="mate ~/.zshrc"
alias kattis="sh ~/kattis-cli/kattis"
alias pytemp="sh ~/.config/shellscripts/pythontemplate.sh"
alias cpptemp="sh ~/.config/shellscripts/cpptemplate.sh"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias nv='nvim'
alias lvconf='cd ~/.local/share/lunarvim/lvim/'
alias lv='cd ~/.local/share/lunarvim'
alias lvim='~/.local/bin/lvim'
alias home='cd ~/'
alias uib='cd ~/dev/uib'
alias inf122='cd ~/dev/uib/fall22/inf122'
alias inf140='cd ~/dev/uib/fall22/inf140'
alias inf102='cd ~/dev/uib/fall22/inf102'
alias inf112='cd ~/dev/uib/spring23/inf112'
alias inf221='cd ~/dev/uib/spring23/inf221'
alias inf222='cd ~/dev/uib/spring23/inf222'
alias inf329='cd ~/dev/uib/fall23/inf329'
alias inf339='cd ~/dev/uib/fall23/inf339A'
alias inf234='cd ~/dev/uib/fall23/inf234'
alias mat221='cd ~/dev/uib/fall23/mat221'
alias inf236='cd ~/dev/uib/spring24/inf236'
alias inf237='cd ~/dev/uib/spring24/inf237'
alias obs='~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/UiB'
alias ranger='source ranger'
alias g++='/opt/homebrew/Cellar/gcc/13.2.0/bin/g++-13 -std=c++20'
alias clang='/opt/homebrew/Cellar/gcc/13.2.0/bin/g++-13 -std=c++20'

# vim mode
set -o vi


# Goes up a specified number of directories  (i.e. up 4)
up ()
{
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}
setopt autocd
#runs -ls every time cd is run
function cd {
    builtin cd "$@"
    RET=$?
    ls
    return $RET
}

#create and go to directory
mkdirg ()
{
	mkdir -p $1
	cd $1
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export DBUS_SESSION_BUS_ADDRESS='unix:path='$DBUS_LAUNCHD_SESSION_BUS_SOCKET

#[ -f "/Users/kristiansordal/.ghcup/env" ] && source "/Users/kristiansordal/.ghcup/env" # ghcup-env
[ -f "/opt/homebrew/bin" ] && source "/opt/homebrew/bin"

export PATH=$PATH:/Users/kristiansordal/.spicetify

#[ -f "/Users/kristiansordal/.ghcup/env" ] && source "/Users/kristiansordal/.ghcup/env" # ghcup-env

[ -f "/Users/kristiansordal/.ghcup/env" ] && source "/Users/kristiansordal/.ghcup/env" # ghcup-env
