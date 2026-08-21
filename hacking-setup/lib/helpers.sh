#!/usr/bin/env bash
 
log()  { echo -e "\e[1;32m[+]\e[0m $*"; }
info() { echo -e "\e[1;34m[i]\e[0m $*"; } 
warn() { echo -e "\e[1;33m[!]\e[0m $*"; }
err()  { echo -e "\e[1;31m[-]\e[0m $*" >&2; }


install_apt() {
    local pkg="$1"
    if dpkg-query -s "$pkg" &>/dev/null; then
        info "$pkg already installed, skipping"
        return
    fi

    log "Installing $pkg..."
    if ! sudo apt-get install -qy "$pkg" 2>/dev/null; then
        err "Failed to install $pkg"
        return 1
    fi
}

install_git() {
    local repo_url="$1"
    local dest="$2"

    if [[ -d "$dest" ]]; then
        info "$(basename "$dest") already cloned at $dest, skipping"
        return
    fi

    log "Cloning $(basename "$dest")..."
    if ! sudo git clone "$repo_url" "$dest"; then
        err "Failed to clone $repo_url"
        return 1
    fi
}

print_banner() {
    echo -e "\033[1;32m"
    cat << "EOF"
                                  ,----,                                   
                                ,/   .`|                     ,-.----.      
  .--.--.          ,---,.     ,`   .'  :                     \    /  \     
 /  /    '.      ,'  .' |   ;    ;     /           ,--,      |   :    \    
|  :  /`. /    ,---.'   | .'___,/    ,'          ,'_ /|      |   |  .\ :   
;  |  |--`     |   |   .' |    :     |      .--. |  | :      .   :  |: |   
|  :  ;_       :   :  |-, ;    |.';  ;    ,'_ /| :  . |      |   |   \ :   
 \  \    `.    :   |  ;/| `----'  |  |    |  ' | |  . .      |   : .   /   
  `----.   \   |   :   .'     '   :  ;    |  | ' |  | |      ;   | |`-'    
  __ \  \  |   |   |  |-,     |   |  '    :  | | :  ' ;      |   | ;       
 /  /`--'  /   '   :  ;/|     '   :  |    |  ; ' |  | '      :   ' |       
'--'.     /___ |   |    \ ___ ;   |.'___  :  | : ;  ; | ___  :   : : ___   
  `--'---'/  .\|   :   .'/  .\'---' /  .\ '  :  `--'   Y  .\ |   | :/  .\  
          \  ; |   | ,'  \  ; |     \  ; |:  ,      .-.|  ; |`---'.|\  ; | 
           `--"`----'     `--"       `--"  `--`----'    `--"   `---` `--" 
                                                                                                                                                                                                                                                                                                                               
EOF
    echo -e "\033[0m"
}

auto_update() {
    # Ensure we are in a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return 0
    fi

    log "Checking for updates to the setup script..."

    # Fetch latest changes from remote without merging yet
    if ! git fetch -q; then
        warn "Failed to check for script updates. Continuing with current version."
        return 0
    fi

    local local_commit remote_commit
    local_commit=$(git rev-parse HEAD)
    remote_commit=$(git rev-parse "@{u}" 2>/dev/null)

    # If remote branch exists and doesn't match local commit
    if [[ -n "$remote_commit" && "$local_commit" != "$remote_commit" ]]; then
        log "A newer version of the setup script is available. Updating..."
        
        if git pull -q; then
            log "Script successfully updated! Restarting with the latest version..."
            # Re-execute the script with the arguments the user passed
            exec "$0" "$@"
        else
            warn "Failed to pull updates automatically. Continuing with current version."
        fi
    else
        info "Setup script is already up to date."
    fi
}