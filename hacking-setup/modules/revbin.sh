#!/usr/bin/env bash

run_revbin() {
    log "Setting up reverse engineering and binary analysis tools..."

    install_apt binutils
    install_apt gdb

    install_pwndbg

    install_apt python3-pwntools
    install_apt checksec

    install_ROPgadget
}

install_pwndbg() {
    if command -v pwndbg &>/dev/null || [ -d "$HOME/.cache/pwndbg" ]; then
        info "pwndbg already installed, skipping"
    else
        log "Installing pwndbg..."
        if ! curl --proto '=https' --tlsv1.2 -LsSf 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb 2>/dev/null; then
            err "Pwndbg installation failed."
            return 1
        fi
    fi
}

install_ROPgadget() {
    if command -v ROPgadget &>/dev/null; then
        info "ROPgadget already installed, skipping"
        return
    fi

    log "Installing ROPgadget..."
    if ! sudo -H python3 -m pip install --upgrade ROPgadget --break-system-packages; then
        err "ROPgadget installation failed"
        return 1
    fi
}
