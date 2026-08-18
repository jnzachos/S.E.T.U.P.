#! /usr/bin/env bash

run_net() {
    log "Setting up networking tools..."
    install_apt socat
    install_apt wireshark
    install_apt netcat-openbsd
}