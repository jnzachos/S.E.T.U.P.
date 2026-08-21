#!/usr/bin/env bash

run_dependencies() {
    log "Updating package lists..."
    sudo apt-get update

    log "Installing dependencies..."

    # Python 3
    if command -v python3 &>/dev/null; then
        info "Python 3 already installed"
    else
        log "Installing Python 3..."
        install_apt python3
    fi

    # Python Pip
    if command -v pip3 &>/dev/null; then
        info "python3-pip already installed"
    else
        log "Installing python3-pip..."
        install_apt python3-pip
    fi

    # Java (OpenJDK 21)
    if command -v java &>/dev/null && java -version 2>&1 | grep -q "21"; then
        info "OpenJDK 21 already installed"
    else
        log "Installing OpenJDK 21..."
        install_apt openjdk-21-jdk
    fi

    # unzip
    if command -v unzip &>/dev/null; then
        info "unzip already installed"
    else
        log "Installing unzip..."
        install_apt unzip
    fi

    # wget
    if command -v wget &>/dev/null; then
        info "wget already installed"
    else
        log "Installing wget..."
        install_apt  wget
    fi

    # curl
    if command -v curl &>/dev/null; then
        info "curl already installed"
    else
        log "Installing curl..."
        install_apt curl
    fi

    # git
    if command -v git &>/dev/null; then
        info "git already installed"
    else
        log "Installing git..."
        install_apt git
    fi

}
