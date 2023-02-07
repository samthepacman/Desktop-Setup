#-----------------------------------------
# ZSHRC INIT
#-----------------------------------------

source ~/.zplug/init.zsh
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
    compinit -i
else
    compinit -C -i
fi
zmodload -i zsh/complist

#-----------------------------------------
# ALIASES
#-----------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias less='less -R'

OS="$(uname)"
if [[ "$OS" == "Linux" ]]; then
    alias bat='batcat --theme base16 -p'
    alias ls='ls -h --color=auto'
    alias la='ls -lah --color=auto'
fi

#-----------------------------------------
# EXPORTS
#-----------------------------------------

export TERM="xterm-256color"
export LANGUAGE="C.UTF-8"
export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"
export LC_CTYPE="C.UTF-8"
export LC_MESSAGES="C.UTF-8"

export GOPATH=$HOME/go
export EDITOR='vim'
export PATH="/usr/bin:$PATH"
export PATH=$GOPATH/bin:$PATH
export host_os=$(uname -s)

#-----------------------------------------
# SOURCES
#-----------------------------------------
zplug "plugins/tmux", from:oh-my-zsh
zplug "bartboy011/cd-reminder"
zplug "joshskidmore/zsh-fzf-history-search", defer:1
zplug "zdharma/fast-syntax-highlighting"
zplug "RobSis/zsh-completion-generator", defer:1
zplug "zsh-users/zsh-syntax-highlighting", defer:1
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "mafredri/zsh-async"
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

#-----------------------------------------
# HISTORY
#-----------------------------------------
function omz_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    echo -n >| "$HISTFILE"
    fc -p "$HISTFILE"
    echo >&2 History file deleted.
  elif [[ -n "$list" ]]; then
    builtin fc "$@"
  else
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

#-----------------------------------------
# KEYBINDINGS
#-----------------------------------------

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use emacs key bindings
bindkey -e

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi

if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

bindkey -M vicmd '^?' backward-delete-char

if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M vicmd "^[[3~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

bindkey -M vicmd '^[[3;5~' kill-word
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5D' backward-word
bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r]
bindkey ' ' magic-space                               # [Space] - don't do history expansion

#-----------------------------------------
# edit the current command line in $editor
#-----------------------------------------

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
bindkey "^[m" copy-prev-shell-word

#-----------------------------------------
# 
#-----------------------------------------

eval "$(starship init zsh)"

