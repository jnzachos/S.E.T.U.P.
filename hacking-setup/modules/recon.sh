#! /usr/bin/env bash

run_recon() {
    log "Setting up reconnaissance tools..."
    install_apt nmap
    install_apt gobuster
    install_apt ffuf
    install_git https://github.com/danielmiessler/SecLists.git /usr/share/seclists
}
