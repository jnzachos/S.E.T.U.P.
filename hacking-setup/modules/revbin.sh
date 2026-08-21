#!/usr/bin/env bash

run_revbin() {
    log "Setting up reverse engineering and binary analysis tools..."

    install_apt binutils
    install_apt gdb

    install_pwndbg

    install_apt python3-pwntools
    install_apt checksec

    install_ROPgadget

    install_apt ltrace
    install_apt strace
    install_apt binwalk

    install_ghidra
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

install_ghidra() {
    local target_dir="/opt/ghidra"
    local symlink_path="/usr/local/bin/ghidra"

    log "Installing Ghidra..."

    if [[ -d "$target_dir" ]]; then
        info "Ghidra already exists at $target_dir, skipping"
    else
        log "Fetching latest Ghidra release URL from GitHub..."
        local api_url="https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest"
        local download_url
        download_url=$(curl -s "$api_url" | grep "browser_download_url" | grep "PUBLIC" | cut -d '"' -f 4 | head -n 1)

        if [[ -z "$download_url" ]]; then
            warn "Failed to fetch Ghidra download URL."
            return 1
        fi

        local zip_name="${download_url##*/}"
        log "Downloading Ghidra from $download_url..."
        if ! curl -L -o "/tmp/$zip_name" "$download_url"; then
            warn "Failed to download Ghidra archive."
            return 1
        fi

        log "Extracting Ghidra to /opt"
        if ! sudo unzip -q "/tmp/$zip_name" -d /opt/; then
            warn "Failed to extract Ghidra archive."
            rm -f "/tmp/$zip_name"
            return 1
        fi

        # Find the extracted folder name and rename it 
        local extracted_dir
        extracted_dir=$(unzip -Z1 "/tmp/$zip_name" | head -n 1 | cut -d '/' -f 1)
        if [[ -d "/opt/$extracted_dir" ]]; then
            sudo mv "/opt/$extracted_dir" "$target_dir"
        else
            warn "Extracted directory not found at /opt/$extracted_dir"
            rm -f "/tmp/$zip_name"
            return 1
        fi

        # cleanup
        rm -f "/tmp/$zip_name"
    fi

    # Ensure main run script executable permission is set
    if [[ -f "$target_dir/ghidraRun" ]]; then
        sudo chmod +x "$target_dir/ghidraRun"
    else
        warn "Ghidra execution script not found at $target_dir/ghidraRun"
        return 1
    fi

    # Create symbolic link in /usr/local/bin
    if [[ -L "$symlink_path" ]]; then
        info "Symbolic link for ghidra already exists."
    else
        log "Creating symbolic link in /usr/local/bin/ghidra"
        if ! sudo ln -sf "$target_dir/ghidraRun" "$symlink_path"; then
            warn "Failed to create symbolic link for ghidra."
            return 1
        fi
    fi

}