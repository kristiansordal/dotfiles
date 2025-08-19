# alias neofetch='neofetch --source ~/.config/neofetch/asciiart/macintosh.txt'
# neofetch
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export AOC_SESSION="53616c7465645f5fc364d93664a9e9b8231046687878ed6abcff620c5b8a4bd32a937da61a4ebe3eabf6a5611eebbdf9d36f3f44d823381198b190e12236453a"
# export PATH="usr/bin/clang:$PATH"
# export PATH="/usr/bin/gcc:$PATH"
export PATH="/opt/homebrew/bin/cmake:$PATH"
export PATH="/Users/kristiansordal/.cargo/bin:$PATH"     
export PATH="/opt/homebrew/bin/g++-12:$PATH" 
export PATH="/opt/homebrew/Cellar/openjdk@17/17.0.6/bin:$PATH"
export PATH="~/.local/bin/lvim:$PATH"
export PATH="~/.local/bin/:$PATH"
export PATH="/opt/homebrew/anaconda3/bin/:$PATH"

# export CXX="/opt/homebrew/Cellar/gcc/14.2.0_1/bin/g++-14"
# export CC="/opt/homebrew/Cellar/gcc/14.2.0_1/bin/gcc-14"
# # export SDKROOT="/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/"

# export SDKROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.4.sdk"
export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
export CC="$(which gcc-14)"
export CXX="$(which g++-14)"
# export CMAKE_OSX_SYSROOT=
# export CXX="/opt/homebrew/Cellar/llvm@17/17.0.6/bin/clang++"
export JAVA_HOME="/opt/homebrew/Cellar/openjdk@17/17.0.7/"
export EDITOR="$HOME/.local/bin/lvim"


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

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
alias g++='/opt/homebrew/Cellar/gcc/14.2.0_1/bin/g++-14 -std=c++20'
alias clang='/opt/homebrew/Cellar/gcc/14.2.0_1/bin/g++-14 -std=c++20'
alias cf='~/go/bin/cf'
alias ytd='yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 320k --cookies-from-browser chrome'

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
eval "$(zoxide init --cmd cd zsh)"
function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd "$cwd"
	fi
	rm -f -- "$tmp"
}

export GDK_PIXBUF_MODULEDIR=/Applications/Inkscape.app/Contents/Resources/lib/gdk-pixbuf-2.0/2.10.0/loaders
export GDK_PIXBUF_MODULE_FILE=/Applications/Inkscape.app/Contents/Resources/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

