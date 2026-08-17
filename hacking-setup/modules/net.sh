run_recon() {
    log "Setting up networking tools..."
    install_apt socat
    install_apt wireshark
    install_apt netcat
}