#!/usr/bin/env bash
# ==============================================================================
# AETHER — Clean Uninstallation Script
# Removes AETHER system files and offers automatic rollback
# ==============================================================================
set -euo pipefail

BACKUP_ROOT="${HOME}/.config/aether/backups"

echo -e "\033[1;35m[AETHER]\033[0m Starting clean uninstallation..."

# 1. Remove SDDM drop-in configuration
if [ -f /etc/sddm.conf.d/10-theme-aether.conf ]; then
    echo "  [sudo] Removing /etc/sddm.conf.d/10-theme-aether.conf..."
    sudo rm -f /etc/sddm.conf.d/10-theme-aether.conf
    echo "  ✓ Removed SDDM AETHER active override."
fi

# 2. Remove SDDM theme files
if [ -d /usr/share/sddm/themes/aether ]; then
    echo "  [sudo] Removing /usr/share/sddm/themes/aether..."
    sudo rm -rf /usr/share/sddm/themes/aether
    echo "  ✓ Removed AETHER SDDM theme directory."
fi

# 3. Clean up deployed Hyprlock files
if [ -f "${HOME}/.config/hypr/aether-colors.conf" ]; then
    rm -f "${HOME}/.config/hypr/aether-colors.conf"
    echo "  ✓ Removed ~/.config/hypr/aether-colors.conf"
fi

if [ -f "${HOME}/.config/hypr/scripts/aether-media-status.sh" ]; then
    rm -f "${HOME}/.config/hypr/scripts/aether-media-status.sh"
    echo "  ✓ Removed ~/.config/hypr/scripts/aether-media-status.sh"
fi

# 4. Optional rollback of hyprlock.conf from latest backup
if [ -d "${BACKUP_ROOT}/latest" ]; then
    read -rp "  Restore previous Hyprlock configuration from latest backup? (Y/n): " restore_prev
    if [[ ! "${restore_prev}" =~ ^[Nn]$ ]]; then
        if [ -e "${BACKUP_ROOT}/latest/hyprlock.conf" ]; then
            cp -P "${BACKUP_ROOT}/latest/hyprlock.conf" "${HOME}/.config/hypr/hyprlock.conf"
            echo "  ✓ Restored ~/.config/hypr/hyprlock.conf from backup."
        fi
    fi
fi

echo -e "\033[1;32m[SUCCESS]\033[0m AETHER has been cleanly uninstalled!"