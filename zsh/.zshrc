#https://zsh.sourceforge.io/Doc/Release/Options.html

#map ESC to jk
bindkey -M viins 'jk' vi-cmd-mode
#using jefferytse/zsh-vi-mode plugin
ZVM_VI_ESCAPE_BINDKEY=jk

# Left prompt
PS1='%F{47} %3~ '$'\n''%F{46} '$'\U27a4 '' '
#add empty line before prompt
precmd() { print "" }

#Right prompt show the git branch when in git repo. Found in in the git book
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT='${vcs_info_msg_0_}'
zstyle ':vcs_info:git:*' formats '%b'

#Tab completion
autoload -Uz compinit && compinit

#HISTORY
HISTFILE=$HOME/dotfiles/zsh/.zsh_history
HISTSIZE=1024
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups #do not save duplicates, the older command will be deleted
setopt hist_ignore_space    #do not write history if first char is space
setopt hist_reduce_blanks   #remove blanks from command being added
setopt inc_append_history
setopt share_history

setopt completealiases      #complete aliases
setopt correct              #spelling correction for commands

#ALIAS 
alias cls=' clear'

#source this file
alias reload='cls; source $HOME/.zshrc'

#pretty print echo $PATH
alias path="echo $PATH | tr ':' '\n'"

alias ls=" ls -lh --color=auto"
alias lsa=" ls -alh"
#list only dotfiles
alias lsd=' ls -dh .*'

#use zoxide for cd
alias cd=" z"

alias cd..=" cd .."
alias ..=' cd ..'

alias mkdir='mkdir -p'
alias cp="cp -i -R"
alias mv="mv -i"
alias rm="rm -R"
alias rsync="rsync -av"
alias tree="tree -C"

#find dotfiles -H and gitignored -I too
alias fd-"fd -H -I"

#cat with color
alias cat="bat"
#ping only 5 times
alias ping="ping -c 5"

#open zathura in full screen
alias zathura="zathura --mode fullscreen"

alias weather="ansiweather"

#in Asahi set MacOs as startup disk at next boot
#(in MacOs set boot volume in Settings -> General -> Startup Disk)
alias macos="sudo asahi-bless --set-boot 1 --next"

#scrape website, e.g. wget https://www.google.com. If nothing else works, it is slow.
alias wget="wget --wait=2 --level=inf --limit-rate=200K --recursive --page-requisites --user-agent=Mozilla --no-parent --convert-links --adjust-extension --no-clobber -e robots=off "

#Start or attach to a tmux session called TMUX
alias tat="tmux attach -t TMUX || tmux new -s TMUX"

#flatpak alias
#localsend
alias localsend="flatpak run org.localsend.localsend_app"

#listen radio 538 in the cli
alias 538="mpv https://www.mp3streams.nl/zender/radio-538/stream/4-mp3-128"

#yazi use yy to change current working directory when exit yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

#Set the keyboard backlight by value (use in Sway)
function backlight() {
  readonly input=${1:?"Value missing 0...255"}
  brightnessctl --device=kbd_backlight set "$1"
}

#increase volume of media
function upvolume() {
     readonly input=${1:?"Input File must be specified"}
     match=".mp4"
     insert="bbb"
     output="${input%%${match}*}${insert}${match}${input##*${match}}"

     command ffmpeg -i "$input" -filter:a "volume=1.5" "$output"
}

#convert to mp4
function 2mp4() {
  readonly input=${1:?"Input File must be specified"}
  suffix="-hls.ts"
  output=${input%"$suffix"}
  output="${output}.mp4"

  command ffmpeg -y -i "$input" -vcodec copy -acodec copy "$output"
}

#get my (internal) ip
function whatismyip() {
     command ipconfig getifaddr en0
}

#get country by ip (check vpn)
function ipinfo() {
  local info=$(curl -s ipinfo.io)
  echo $info | jq -r '.city + " " + .country'
}

#make and cd to new dir
function mkcd() {
	command mkdir -pv $1 && cd $1
}

#open pdf in terminal
function pdf() {
   readonly file=${1:?"no filename"}
   pdftotext "$1" -  | less
}

#test load time Shell
timezsh() {
     shell=${1-$SHELL}
     for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

export PATH="/usr/local/sbin:$PATH"

#Godoc path
export PATH="$HOME/Develop/go/bin:$PATH"

#Mac Silicon
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH

#Rust
export PATH=/home/devdk/.cargo/bin:$PATH

#Colored man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#Avoid weird formatted man pages with above coloring by 'bat'
export MANROFFOPT="-c"

#privatized zoxide
export _ZO_EXCLUDE_DIRS="/Volumes/*"

#just for funs
fortune | cowsay -n | lolcat

#
# Plugins
#

# Antidote (https://getantidote.github.io/) plugin manager
_zsh_plugins=$HOME/.zsh_plugins.txt
_antidote=$HOME/.antidote

[[ -e $_zsh_plugins ]] || touch "$_zsh_plugins"

if ! [[ -e $_antidote ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$_antidote"
fi

source "$_antidote"/antidote.zsh
antidote load

#clean
unset _zsh_plugins _antidote

# Autosuggest settings https://scottspence.com/posts/my-updated-zsh-config-2025
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# 'source' zoxide, a smarter cd comand
eval "$(zoxide init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

