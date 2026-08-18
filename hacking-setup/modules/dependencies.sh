#!/usr/bin/env bash

run_dependencies() {
    log "Updating package lists..."
    sudo apt-get update -qq

    log "Installing dependencies..."

    # Check Python 3
    if command -v python3 &>/dev/null; then
        info "Python 3 already installed"
    else
        log "Installing Python 3..."
        install_apt python3
    fi

    # Check Python Pip
    if command -v pip3 &>/dev/null; then
        info "python3-pip already installed"
    else
        log "Installing python3-pip..."
        install_apt python3-pip
    fi

    # Check Java (OpenJDK 21)
    if command -v java &>/dev/null && java -version 2>&1 | grep -q "21"; then
        info "OpenJDK 21 already installed"
    else
        log "Installing OpenJDK 21..."
        install_apt openjdk-21-jdk
    fi

    # Check Unzip
    if command -v unzip &>/dev/null; then
        info "unzip already installed"
    else
        log "Installing unzip..."
        install_apt unzip
    fi

    # Check Wget
    if command -v wget &>/dev/null; then
        info "wget already installed"
    else
        log "Installing wget..."
        install_apt  wget
    fi

    # Check Curl
    if command -v curl &>/dev/null; then
        info "curl already installed"
    else
        log "Installing curl..."
        install_apt curl
    fi

    # Check Git
    if command -v git &>/dev/null; then
        info "git already installed"
    else
        log "Installing git..."
        install_apt git
    fi

}
