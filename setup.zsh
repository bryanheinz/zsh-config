#!/bin/zsh


# setup option parsing #
zmodload zsh/zutil
zparseopts -D -E - a=all_accounts -all=all_accounts \
    u=user_accounts -users=user_accounts \
    c=current_user -current=current_user \
    r=root_user -root=root_user \
    h=print_help -help=print_help
# setup option parsing #


# setup variables #
# usr=$(zsh -c whoami)
usr=$(whoami)
grp=$(id -g $usr)
zshDir="/usr/local/zsh-config"

if [[ -f /usr/bin/sw_vers ]]; then
    macos="true"
else
    macos="false"
fi

if [[ $macos == "true" ]]; then
    users_home="/Users"
    root_home="/var/root"
else
    users_home="/home"
    root_home="/root"
fi
# setup variables #


# setup functions #
script_help() {
    echo "Installs Bryan Heinz's ZSH config, functions, and aliases, and installs"
    echo "the .zshrc config to the specified profiles."
    echo "Installs to: $zshDir"
    echo "Tested on Debian 10,"
    echo "Example: setup.zsh -u -r"
    echo "\t-a, --all\tInstall for all accounts including root. (same as -u -r)"
    echo "\t-u, --users\tInstall for all user accounts."
    echo "\t-r, --root\tInstall only for the root account."
    echo "\t-c, --current\tInstall only for the current user. (default)"
    echo "\t-h, --help\tPrints this help and exits."
    exit 0
}

createLink() {
    # elevate to root so that we can check all accounts and add/move/delete as needed
    sudo -s <<ZEBRA
# check if it's a symlink
if [[ ! -h $1 ]]; then
    # it's not a symlink, check if an actual zshrc file exists
    if [[ -f $1 ]]; then
        # there's an existing zshrc file
        mv $1 "$1-$(date +%s)-bak"
        echo "Renamed .zshrc"
    fi
else
    # an existing symlink exists, remove it to make sure we link to this one
    sudo rm $1
    echo "removed $1"
fi
# fell through to create a symlink
sudo ln -s "$zshDir/zshrc" $zshrc
ZEBRA
}

setupRoot() {
    zshrc="$root_home/.zshrc"
    if (createLink $zshrc); then
        echo "Created $zshrc"
    fi
}

setupUser() {
    # skip if the user folder is the macOS Shared folder
    [[ $1 == /Users/Shared ]] && return
    zshrc="$1/.zshrc"
    if (createLink $zshrc); then
        echo "Created $zshrc"
    fi
}
# setup functions #


# main #
# print help if specified
[[ -n $print_help ]] && script_help

# download config
if [[ -f /usr/bin/curl ]]; then
    curl -s -L https://github.com/bryanheinz/zsh-config/archive/main.tar.gz \
        -o /tmp/zsh-config.tar.gz
else
    wget https://github.com/bryanheinz/zsh-config/archive/main.tar.gz \
        -O /tmp/zsh-config.tar.gz
fi
# create config folder if it doesn't exist
[[ ! -d "$zshDir" ]] && sudo mkdir $zshDir
# untar config into the config folder
sudo tar -zxvf /tmp/zsh-config.tar.gz \
    -C $zshDir/ \
    --strip-components 1

# if [ ! -d "$zshDir" ]; then
#     # ZSH directory doesn't exist
#     cd /usr/local
#     sudo git clone https://github.com/bryanheinz/zsh-config.git
# else 
#     cd "$zshDir"
#     sudo git pull
# fi

if [[ -n $all_accounts ]]; then
    setupRoot
    for d in $users_home/*; do
        setupUser $d
    done
elif [[ -n $user_accounts ]]; then
    for d in $users_home/*; do
        setupUser $d
    done
elif [[ -n $current_user && -n $root_user ]]; then
    setupRoot
    setupUser $users_home/$usr
elif [[ -n $current_user ]]; then
    setupUser $users_home/$usr
elif [[ -n $root_user ]]; then
    setupRoot
else
    setupUser $users_home/$usr
fi

sudo chown -R $usr $zshDir
# main #
