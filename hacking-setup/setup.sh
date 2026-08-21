#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/helpers.sh"
source "$SCRIPT_DIR/modules/recon.sh"
source "$SCRIPT_DIR/modules/revbin.sh"
source "$SCRIPT_DIR/modules/dependencies.sh"
source "$SCRIPT_DIR/modules/net.sh"
source "$SCRIPT_DIR/modules/editors.sh"
source "$SCRIPT_DIR/modules/exploit.sh"

auto_update

print_banner

log "Preparing installation..."

if ! sudo -v; then
    err "Sudo authentication failed. Exiting."
    exit 1
fi

log "Starting Hacking Setup"

run_dependencies
run_editors
run_recon
run_revbin
run_net
run_exploit

log "Finished"
