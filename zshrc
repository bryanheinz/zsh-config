# !Add paths #
path+=("/usr/local/sbin")
# add artisan completions path
# https://wikimatze.de/writing-zsh-completion-for-padrino/
# https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
# https://github.com/scriptingosx/mac-zsh-completions
# https://unix.stackexchange.com/a/598210/307697
# https://stackoverflow.com/a/39856256/7341009
# https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org
fpath+=(/usr/local/zsh-config/zsh/completions)
# -- #

# !Functions & Alias'
# import personal ZSH functions and alias'
# https://superuser.com/a/1140782
. "/usr/local/zsh-config/zsh/alias.zsh"
. "/usr/local/zsh-config/zsh/functions.zsh"
# -- #


# !iTerm Shell Integration #
[[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] \
    && source "${HOME}/.iterm2_shell_integration.zsh"
# -- #

# !Python virtualenvwrapper setup #
if [[ -f "/usr/local/bin/virtualenvwrapper.sh" ]]; then
    VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/dev/python
    export VIRTUALENVWRAPPER_WORKON_CD=1
    source /usr/local/bin/virtualenvwrapper.sh
else
    export PY_VENV="${HOME}/.pyvenv"
fi
# -- #

# !MISC #
# disable paste escaping with curl
DISABLE_MAGIC_FUNCTIONS=true

# enable prompt for command correction
ENABLE_CORRECTION="true"

# adjust control+w backwards delete
# https://stackoverflow.com/a/58862453
autoload -U select-word-style
export WORDCHARS='-_.' # characters that will be considered part of a word

# auto CD
setopt AUTO_CD
# -- #


# !Configure History #
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
# search history based on current line
# https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# terminfo from here: https://unix.stackexchange.com/a/405358/307697
# resolves an issue when SSH'd into linux; OG escape sequence didn't work
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search # Up
bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down
# these new bind keys don't seem to work outside of SSH'd into a linux server
# so i'm going to try both!
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
# -- #


# !Setup Completion System #
# https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
# set autocomplete style
zstyle ':completion:*' menu select
# set case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# enable the "more powerful" completion system
# -u suppresses warnings, see https://stackoverflow.com/a/43544733
autoload -Uz compinit && compinit -u
# -- #


# !Git #
# test if git is installed on the machine. if it's not, don't load git modules.
# on macOS if git isn't installed, then this git prompt will trigger the git
# install stub. this stupid if statement exists because you can't test the same
# way on Linux as macOS since the stub exists.
if [[ -f /usr/bin/sw_vers \
    && -f /Library/Developer/CommandLineTools/usr/bin/git \
    || -f /Applications/Xcode.app/Contents/Developer/usr/bin/git \
    || ! -f /usr/bin/sw_vers \
    && -f $(which git) ]]; then
    autoload -Uz vcs_info
    # this will test and load vcs_info if it exists
    { vcs_info } 2> /dev/null \
        && vcsExists="true" \
        || vcsExists="false"
    if [[ $vcsExists == "true" ]]; then
        precmd_vcs_info() { vcs_info }
        precmd_functions+=( precmd_vcs_info ) \
            && zstyle ':vcs_info:git:*' formats '(%b)%f' \
            && zstyle ':vcs_info:*' enable git
    fi
    # RPROMPT=\$vcs_info_msg_0_
    # zstyle ':vcs_info:git:*' formats '(%b)%r%f'
fi
# -- #


# !Prompt #
NEWLINE=$'\n'
# isSSH=$(ps ax | grep "sshd:" | grep -v grep)
# required for substitution to work
# https://unix.stackexchange.com/a/434697
setopt PROMPT_SUBST
# if [[ "$USER" == "root" && ( -n $isSSH ) ]]; then
# USER doesn't appear to work on Alpine
# LOGNAME seems to exist on macOS, Debian, and Alpine
if [[ "$LOGNAME" == "root" && ( -n $SSH_CONNECTION ) ]]; then
    PROMPT='${NEWLINE} %B%F{yellow}${LOGNAME}@${HOST}%f : %B%F{cyan}%3~%f%b %F{magenta}${vcs_info_msg_0_}${NEWLINE}%f %(?.%BSSH%f %F{red}ROOT%f %F{green}▶.%F{red}%? ▶)%f '
elif [[ "$LOGNAME" == "root" ]]; then
    PROMPT='${NEWLINE} %B%F{cyan}%3~%f%b %F{magenta}${vcs_info_msg_0_}${NEWLINE}%f %(?.%B%F{red}ROOT%f %F{green}▶.%F{red}%? ▶)%f '
elif [[ -n $SSH_CONNECTION ]]; then
# elif [[ -n $isSSH ]]; then
    PROMPT='${NEWLINE} %B%F{yellow}${LOGNAME}@${HOST}%f : %B%F{cyan}%3~%f%b %F{magenta}${vcs_info_msg_0_}${NEWLINE}%f %(?.%BSSH%f %F{green}▶.%F{red}%? ▶)%f '
else
    # cyan current path with 2 parents, magenta git branch, new line green
    # prompt or red prompt if command exited with an error.
    PROMPT='${NEWLINE} ${LOGNAME} : %B%F{cyan}%3~%f%b %F{magenta}${vcs_info_msg_0_}${NEWLINE}%f %(?.%F{green}▶.%F{red}%? ▶)%f '
fi
# -- #

# !Override imports #
# .love - https://overcast.fm/+hYDenHcLc
# load ZSH configs to override anything in this config
# local-only ZSH file
if [[ -f "$HOME/.love/local_rc.zsh" ]]; then
    . "$HOME/.love/local_rc.zsh"
fi
# cloud ZSH file
if [[ -f "$HOME/.love/cloud_rc.zsh" ]]; then
    . "$HOME/.love/cloud_rc.zsh"
fi
# -- #
