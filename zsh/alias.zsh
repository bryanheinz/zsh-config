# ping shortcuts
alias pc="ping 1.1" # ping CloudFlare DNS
alias pg="ping google.com"
alias pg4="ping -c 4 google.com"
alias pg100="ping -c 100 google.com"
alias pingl="while true; do ping -c 100 google.com | tail -2; echo ''; done"

# use my gateway function to ping
# see https://github.com/bryanheinz/zsh-config/blob/main/zsh/functions.zsh
alias pgw='ping $(gw)'

# shortcut to get WAN IP address
alias getip="curl ifconfig.co"
alias wan="curl ifconfig.co"
# there's a `lan` function as well

# ps shortcuts
alias pscpu="ps -axrcwwo user,pid,%cpu,%mem,state,start,time,comm"
alias psmem="ps -axmcwwo user,pid,%cpu,%mem,state,start,time,comm"

# git shortcuts
alias gitta="git add"
alias gitpa="git push origin alpha"
alias gitreset="git reset --hard HEAD"
alias gitcom="git commit -m"

# copy my computer's local SSH public key
alias getkey="cat ~/.ssh/localkey.pub | pbcopy"
alias keyme="cat ~/.ssh/localkey.pub | pbcopy"

# use pwgen to generate 10x 15 character passwords
alias getpass="pwgen -c -n -y -s -1 15 10"
alias passme="pwgen -c -n -y -s -1 15 10"

# nmap scan all ports
alias scanall="nmap -p 1-65535"
# nmap function correction
alias checkport='portcheck'

# get an applications team ID for macOS profiles
alias get_team_id="/usr/bin/codesign -dv --verbose=4"

# shortcut to start an SSH reverse proxy
alias ssh_proxy="ssh -D 4020"
# shortcut to start an SSH tunnel VNC session
alias ssh_vnc="echo -e '\nPort 2000\n';ssh -L 2000:localhost:5900"

# shortcut for reading certs
alias certcat="openssl x509 -text -noout -in"

# docker shortcuts
alias dip="docker image prune"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}'"
alias dpsa="docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}'"
alias dscpu="docker stats --format '{{.Name}}: {{.CPUPerc}}'"

# docker compose shortcuts
alias dc="docker compose"
if [[ -f $(which docker-compose) ]]; then
    alias dcu="docker-compose up -d"
    alias dcd="docker-compose down"
    alias dcb="docker-compose build"
    alias dcufr="docker-compose up -d --force-recreate"
    alias dcp="docker-compose pull"
    alias dcl="docker-compose logs"
else
    alias dcu="docker compose up -d"
    alias dcd="docker compose down"
    alias dcb="docker compose build"
    alias dcufr="docker compose up -d --force-recreate"
    alias dcp="docker compose pull"
    alias dcl="docker compose logs"
fi

# munki shortcuts
alias msu="/usr/local/munki/managedsoftwareupdate"
alias msui="/usr/local/munki/managedsoftwareupdate --installonly"

# bin shortcuts
alias ms="$HOME/Documents/repos/bin/munki_scripts"

# autopkg shortcuts
alias avti="autopkg verify-trust-info"

# remove macOS quarantine bit from a binary
alias setitfree="sudo xattr -r -d com.apple.quarantine"

# CLI rewrites
alias ll="ls -lhA"
if [[ -f /etc/issue ]]; then
    alias ls="ls --color"
else
    alias ls="ls -G"
fi

alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto -i"
alias grepS="grep --color=auto"

# custom function alias
alias tart="tarty"

# Egnyte alias
# https://helpdesk.egnyte.com/hc/en-us/articles/7126003875725
alias egcli="/Applications/Egnyte.app/Contents/MacOS/Egnyte --cli"

# Reload the shell (i.e. invoke as a login shell)
# via https://github.com/joeblau/dotfiles/blob/master/topics/aliases/.aliases
alias reload='exec $SHELL -l'
