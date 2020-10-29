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
    git push origin $(git branch --show-current)
}

# shortcut to add all CWD files to git, commit them, and then push them to the master branch
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
    nova $1
}

# youtube-dl command
getvid () {
    /usr/local/bin/youtube-dl -w -f "(bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best)" --merge-output-format "mp4" -o "%(title)s.%(ext)s" "$1"
}
