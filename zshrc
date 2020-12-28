path+=("$HOME/Library/Mobile Documents/com~apple~CloudDocs/_usr/bin")
path+=("$HOME/Documents/repos/bin")
path+=("/usr/local/sbin")
export PATH


# import personal ZSH functions and alias'
# https://superuser.com/a/1140782
# . "$HOME/Documents/repos/zsh-config/zsh/alias.zsh"
# . "$HOME/Documents/repos/zsh-config/zsh/functions.zsh"
. "/usr/local/zsh-config/zsh/alias.zsh"
. "/usr/local/zsh-config/zsh/functions.zsh"

# disable paste escaping with curl
DISABLE_MAGIC_FUNCTIONS=true

# enable prompt for command correction
ENABLE_CORRECTION="true"

# set autocomplete style
zstyle ':completion:*' menu select

# search history based on current line
# https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# adjust control+w backwards delete
# https://stackoverflow.com/a/58862453
autoload -U select-word-style
export WORDCHARS='-_.' # characters that will be considered part of a word


# iTerm shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/ #

# auto CD
setopt AUTO_CD
# detailed ZSH history
setopt EXTENDED_HISTORY
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are entered, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# save ZSH history
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# limit history size
SAVEHIST=5000
HISTSIZE=2000

# set case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# git
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
# RPROMPT=\$vcs_info_msg_0_
# zstyle ':vcs_info:git:*' formats '(%b)%r%f'
zstyle ':vcs_info:git:*' formats '(%b)%f'
zstyle ':vcs_info:*' enable git

# enable the "more powerful" completion system
# -u suppresses warnings, see https://stackoverflow.com/a/43544733
autoload -Uz compinit && compinit -u

#

# prompt
NEWLINE=$'\n'
isSSH=$(ps ax | grep "sshd:" | grep -v grep)
if [[ "$USER" == "root" && ( -n $isSSH ) ]]; then
    PROMPT='${NEWLINE} %B%F{yellow}${USER}@${HOST}%f : %B%F{cyan}%3~%f%b %F{magenta}${vcs_info_msg_0_}${NEWLINE}%f %(?.%BSSH%f %F{red}ROOT%f %F{green}▶.%F{red}%? ▶)%f '
elif [[ "$USER" == "root" ]]; then
    PROMPT='${NEWLINE} %B%F{cyan}%3~%f%b %F{magenta}${vcs_info_msg_0_}${NEWLINE}%f %(?.%B%F{red}ROOT%f %F{green}▶.%F{red}%? ▶)%f '
# elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
elif [[ -n $isSSH ]]; then
    PROMPT='${NEWLINE} %B%F{yellow}${USER}@${HOST}%f : %B%F{cyan}%3~%f%b %F{magenta}${vcs_info_msg_0_}${NEWLINE}%f %(?.%BSSH%f %F{green}▶.%F{red}%? ▶)%f '
else
    # cyan current path with 2 parents, magenta git branch, new line green
    # prompt or red prompt if command exited with an error.
    PROMPT='${NEWLINE} ${USER} : %B%F{cyan}%3~%f%b %F{magenta}${vcs_info_msg_0_}${NEWLINE}%f %(?.%F{green}▶.%F{red}%? ▶)%f '
fi