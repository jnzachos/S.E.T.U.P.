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