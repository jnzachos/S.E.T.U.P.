#! /usr/bin/env/ bash

run_editors(){

    install_apt nano
    install_neovim
    install_vscode
    
}

install_neovim() {
    if command -v nvim &>/dev/null; then
        info "Neovim already installed, skipping"
        return
    fi

    log "Installing Neovim..."
    if ! curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz; then
        err "Failed to install Neovim"
        return 1
    fi

    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    
    if [[ -L /usr/local/bin/nvim ]]; then
        info "Symbolic link for penelope already exists."
    else
        if ! sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim; then
            err "Failed to create symbolic link for Neovim"
            return 1
        fi
    fi

    rm -f nvim-linux-x86_64.tar.gz
}

install_vscode() {
    if command -v code &>/dev/null; then
        info "Visual Studio Code already installed, skipping"
        return
    fi

    log "Installing Visual Studio Code..."
    if ! curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/vscode.deb; then
        err "Failed to install Visual Studio Code"
        return 1
    fi

    if sudo apt-get install -qy /tmp/vscode.deb; then
        rm -f /tmp/vscode.deb
    else
        err "Failed to install Visual Studio Code package"
        rm -f /tmp/vscode.deb
        return 1
    fi
}