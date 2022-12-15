# use smcutil to set the fan speed
fan () {
    /usr/bin/sudo /usr/local/bin/smcutil -s $1 -n 0
    /usr/bin/sudo /usr/local/bin/smcutil -s $1 -n 1
}

# shortcut to flush DNS cache on macOS
flushcache () {
	/usr/bin/sudo /usr/bin/dscacheutil -flushcache
	/usr/bin/sudo /usr/bin/killall -HUP mDNSResponder
}

# generate a generic .gitignore file
gitig () {
    echo -e ".DS_Store\n._*\n*.pyc\n__pycache__\nPodfile.lock\nPods\n*.xcworkspace" >> .gitignore
    git add .gitignore
    git commit -m "updated .gitignore"
    # git push origin $(git symbolic-ref --short HEAD)
    # git push origin $(git branch --show-current)
}

gitpush () {
    git push origin $(git branch --show-current)
}

# shortcut to add all CWD files to git, commit them, and then push them to the current branch
gitpusha () {
    git add ./*
    gitcom "updates"
    # git push origin master
    git push origin $(git branch --show-current)
}

# personal get lyrics from current playing song
lyricme () {
    loc=$(pwd)
    cd "/Users/$(whoami)/Library/Mobile Documents/iCloud~com~omz-software~Pythonista3/Documents/last-lyric"
    python3 gennie.py
    cd "$loc"
}

# shortcut to using nmap to check for an open port
portcheck () {
    nmap -Pn $1 -p $2
}

# fix for nova's CLI
_nova () {
    /usr/local/bin/nova $1
}

# youtube-dl command
getvid () {
    /usr/local/bin/youtube-dl -w -f "(bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best)" --merge-output-format "mp4" -o "%(title)s.%(ext)s" "$1"
}

# autopkg update command
auti () {
    if [[ $1 == "--all" ]]; then
        echo "updating all recipe trust info"
        autopkg update-trust-info /Volumes/storage/autopkg/recipe_overrides/*
    else
        autopkg update-trust-info "$1"
    fi
}

# functions to start/stop sshuttle
proxyme () {
    sshuttle_conf="$config/sshuttle.conf"
    sshuttle @$sshuttle_conf -D $@
}

proxy_down () {
    kill $(cat /tmp/sshuttle.pid)
}

# macOS function to show logs
# $1 == search message
# $2 == timeframe to search for logs
logg () {
    MSG='eventMessage contains "'"$1"'"'
    /usr/bin/sudo /usr/bin/log show --info --debug --predicate \
        ${MSG} --last $2
}

tarty () {
    tart_bin=$(whereis -bq tart)
    if [[ $1 == "ls" ]]; then
        $tart_bin list
    elif [[ $1 == "fresh" ]]; then
        if [[ -e "$HOME"/.tart/"$3" ]]; then
            echo "VM already exists."
            return 1
        fi
        $tart_bin clone $2 $3
        $tart_bin run $3
    elif [[ $1 == "info" ]]; then
        cat "$HOME"/.tart/vms/"$2"/config.json
    elif [[ $1 == "clear" ]]; then
        for vm in $($tart_bin list | grep "$2" | awk '{print $2}'); do
            $tart_bin delete "$vm"
        done
    elif [[ $1 == "dup" ]]; then
        baseTxt="$HOME/.tart/base.txt"
        if [[ $2 == "-u" ]]; then
            if [[ -n $3 ]]; then
                printf "$3" > "$baseTxt"
                return
            else
                rm "$baseTxt"
            fi
        fi
        if [[ ! -f "$baseTxt" ]]; then
            $tart_bin list
            read "vmName?Enter the name for your base VM > "
            printf "$vmName" > "$baseTxt"
            echo "VM base name set."
            return
        fi
        if [[ -e "$HOME"/.tart/"$2" ]]; then
            echo "VM already exists."
            return 1
        fi
        $tart_bin clone "$(cat $baseTxt)" $2
        echo "Used base VM $(cat $baseTxt)"
        $tart_bin run $2
    elif [[ $1 == "rm" ]]; then
        if [[ -z "$2" ]]; then
            echo "Missing VM to delete."
            return 1
        fi
        $tart_bin delete "$2"
    else
        $tart_bin $@
    fi
}

# shortcut for managing Python virtual environments
# $1 == virtual environment name OR create, delete, list OR ls, or freeze.
# $2 == virtual environment if using a command
venv () {
    # setup PY_VENV path if it's not already setup in .zshrc
    if [[ -z $PY_VENV ]]; then
        PY_VENV="${HOME}/.pyvenv"
    fi
    
    if [[ $1 == "create" ]]; then
        # python3 -m venv $HOME/.env/"$2"
        python3 -m venv "${PY_VENV}/$2"
    elif [[ $1 == "delete" ]]; then
        # rm -rf $HOME/.env/"$2"
        rm -rf "${PY_VENV}/$2"
    elif [[ $1 == "list" || $1 == "ls" ]]; then
        # ls $HOME/.env/"$2"
        ls "${PY_VENV}/$2"
    elif [[ $1 == "freeze" ]]; then
        if [[ -z $2 ]]; then
            python3 -m pip freeze > requirements.txt
        else
            python3 -m pip freeze > "$2"/requirements.txt
        fi
    elif [[ -z $1 || $1 == "-h" ]]; then
        echo "venv help"
        echo "Commands: create, delete, list || ls, freeze."
        echo "No commands activates the environment."
    else
        # source $HOME/.env/"$1"/bin/activate
        source "${PY_VENV}/${1}/bin/activate"
    fi
}
