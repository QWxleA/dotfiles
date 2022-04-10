# QWxlea's oh-my-zsh config
#
#
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#export FPATH=~/Projects/dotfiles/zsh/zfunc:$FPATH
#autoload -U ~/Projects/dotfiles/zsh/zfunc/*
if [ -d /opt/homebrew/opt/ruby/bin ]; then 
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
fi

#Clojure stuff
export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-java11-22.0.0.2/Contents/Home #to ~/.zshrc
export PATH=$PATH:$HOME/Developer/logseq/logseq-query/bin


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Using starship atm 
ZSH_THEME="robbyrussell"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git man sudo brew)

source $ZSH/oh-my-zsh.sh

# User configuration

# Get color support for 'less'
[[ -f ~/.config/LESS_TERMCAP ]] && . ~/.config/LESS_TERMCAP
#export MANPAGER="less -s -M +Gg -R --use-color -Dd+r -Du+b"
export MANPAGER="less -s -M +Gg -R --use-color"

#Named directories
hash -d lsnotes=$HOME/Documents/NOTES
hash -d lsVideo=$HOME/Documents/Lsnotes
hash -d qnotes=$HOME/Documents/QNotes/qnotes
hash -d dev=$HOME/Developer
hash -d blog=$HOME/Documents/QWxleA.github.io

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

#Linux Fedora Silverblue
if [[ -f "/run/.containerenv" ]]; then
    export EDITOR=nvim

    alias flatpakhost="flatpak-spawn --host flatpak"

    alias open="flatpak-spawn --host xdg-open"
    alias o="flatpak-spawn --host xdg-open"

    alias wlcopy="flatpak-spawn --host wl-copy"

    alias mybattery="flatpak-spawn --host upower -i \"$(upower -e | grep 'BAT')\""

    alias htop="flatpak-spawn --host toolbox run -c apps htop"

  function am-i-on-wayland() {
      echo "XDG_SESSION_TYPE: $XDG_SESSION_TYPE" 
      printf "Loginctl:         "
      flatpak-spawn --host loginctl show-session $(awk '/tty/ {print $1}' <(flatpak-spawn --host loginctl)) -p Type | awk -F= '{print $2}'
  }

  if [ -f /run/.containerenv ];then 
      export CONTAINER="📦$(grep name /run/.containerenv | sed "s/name=\"\(.*\)\"/\1/")"
  fi

  alias screenoff="busctl --user call org.gnome.Shell /org/gnome/ScreenSaver org.gnome.ScreenSaver SetActive b true"
  alias x="gio trash"

#MacOS
else
  export EDITOR=code

  alias python=python3

fi

# aliases
alias e=$EDITOR
alias vi=$EDITOR
alias vim=$EDITOR
alias edzshconfig="$EDITOR ~/.zshrc && exec zsh"
alias edvimconfig="$EDITOR ~/.config/nvim/init.vim" 

alias edit-espanso="$EDITOR ~/Library/Application\ Support/espanso/match/base.yml"
alias docs-espanso="open https://espanso.org/docs/matches/basics/"
alias edit-organize="$EDITOR ~/Library/Application\ Support/organize/config.yaml"
alias docs-organize="open https://organize.readthedocs.io/en/latest/actions/"

alias edit-logseq-css="$EDITOR ~lsnotes/logseq/custom.css"
alias edit-logseq-config="$EDITOR ~lsnotes/logseq/config.edn"
alias logseq-nightly="open https://github.com/logseq/logseq/releases/nightly"
alias logseq-issues="open https://github.com/logseq/logseq/issues"

alias his="history -i" # zsh timestamp history

alias chmox="chmod -x"



#Functions
function md() {
    mkdir -p "$1" && \
    cd "$1"
}

function mkdirdate() {
    TDATE=$(date +%Y-%m-%d)
    TARGET="$HOME/Downloads/$TDATE" 
    mkdir -p "$TARGET" && \
    cd "$TARGET"
}

# cd into whatever is the forefront Finder window.
cdf() {  # short for cdfinder
  cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}


### SERVERS ###
function docs-andy() {
  cd $HOME/Documents/notes.andymatuschak.org
  (sleep 2 && /usr/bin/open -a Safari http://localhost:8081) &
  python3 -m http.server 8081 
}

function serve() {
  local port=${1:-8080}
  if [[ $port -eq 80 ]]; then
    sudo python3 -m http.server $port
  else
    python3 -m http.server $port
  fi
}

### GIT ###
function gclonecd() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

function gitremotefixall() {
    git fetch origin main
    git reset --hard FETCH_HEAD
    git clean -df
}
alias push="git push"



if [[ $(uname) == "Darwin" ]]; then
  source ~/.iterm2_shell_integration.zsh
  export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
else
  eval "$(starship init zsh)"
fi

### Misc ###

# Automatically list directory contents on `cd`.
auto-ls () {
	emulate -L zsh;
	# explicit sexy ls'ing as aliases arent honored in here.
	# hash gls >/dev/null 2>&1 && CLICOLOR_FORCE=1 gls -aFh --color --group-directories-first || ls
	hash exa >/dev/null 2>&1 && exa || ls
}
chpwd_functions=( auto-ls $chpwd_functions )