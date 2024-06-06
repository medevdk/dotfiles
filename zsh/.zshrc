#https://zsh.sourceforge.io/Doc/Release/Options.html

#Change the ESC to jk
bindkey -M viins 'jk' vi-cmd-mode

#my prompt (back to normal)
# PS1='%F{110} %2~ '$'\n''%F{110} '$'\U27a4'' '
PS1='%F{47 %2~ '$'\n''%F{46} '$'\U27a4'' '
# RPROMPT='%F{241}%B%T%b%f'
#add empty line before prompt
precmd() { print "" }


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

#Misc
setopt auto_cd	#cd by typing directory name if it is not a command (e.g. go will not work)

#ALIAS 
alias cls=' clear'
#
#source this file
alias reload='source $HOME/.zshrc'
#pretty print echo $PATH
alias path="echo $PATH | tr ':' '\n'"

alias ls=" ls -l --color=auto"
alias lsa=" ls -al"
#list only dotfiles
alias lsd=' ls -d .*'

alias cd..=" cd .."
alias ..=' cd ..'
alias mkdir='mkdir -p'

alias cp="cp -i -R"
alias mv="mv -i"
alias rm="rm -R"
alias rsync="rsync -av"
#cat with color
alias cat="bat"
#ping only 5 times
alias ping="ping -c 5"

#in Linux set MacOs as startup disk at next boot
#in MacOs set boot volume in Settings -> General -> Startup Disk
alias macos="sudo asahi-bless --set-boot 1 --next"

#download all website, e.g. wget https://www.google.com
alias wget="wget --wait=2 --level=inf --limit-rate=200K --recursive --page-requisites --user-agent=Mozilla --no-parent --convert-links --adjust-extension --no-clobber -e robots=off "

#increase volume of media
function upvolume() {
     readonly input=${1:?"Input File must be specified"}
     match=".mp4"
     insert="bbb"

     output="${input%%${match}*}${insert}${match}${input##*${match}}"

     command ffmpeg -i "$input" -filter:a "volume=1.5" "$output"

     #echo ${output}
}
#convert to mp4
function 2mp4() {
  readonly input=${1:?"Input File must be specified"}
  #readonly output=${2:?"Output must be specified"}
  suffix="-hls.ts"
  output=${input%"$suffix"}
  output="${output}.mp4"

     #command ffmpeg -y -i "$input" -vcodec copy -acodec copy -map 0:v map 0:a "$output"
     command ffmpeg -y -i "$input" -vcodec copy -acodec copy "$output"
}

#get my (internal) ip
function whatismyip() {
     command ipconfig getifaddr en0
}

#get country by ip
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

export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH

export PATH=/home/devdk/.cargo/bin:$PATH


#just for funs
fortune | cowsay -n | lolcat

#tmux will auto connect to a session called TMUX when launching terminal
if [ -z "$TMUX" ]
then
  tmux attach -t TMUX || tmux new -s TMUX
fi


#
# Plugins - No plugin manager
#

#How to add zsh-autosuggestion see https://asciinema.org/a/37390
source ~/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

#How to add zsh-syntax-highlighting see https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
source ~/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
