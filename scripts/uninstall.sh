#!/usr/bin/env bash
# ==============================================================================
# AETHER — Safe Manifest-Driven Uninstallation Script
# Removes only AETHER-deployed files and preserves pre-existing configurations
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST_LOG="${HOME}/.config/aether/install_manifest.txt"

echo -e "\033[1;35m[AETHER]\033[0m Starting safe uninstallation..."

# Helper to read manifest key-values
get_install_var() {
    if [ -f "${MANIFEST_LOG}" ]; then
        grep "^$1=" "${MANIFEST_LOG}" 2>/dev/null | cut -d'=' -f2- || echo ""
    else
        echo ""
    fi
}

# 1. Clean up SDDM configuration overrides
if [ -f /etc/sddm.conf.d/10-theme-aether.conf ]; then
    echo "  [sudo] Removing /etc/sddm.conf.d/10-theme-aether.conf..."
    sudo rm -f /etc/sddm.conf.d/10-theme-aether.conf
    echo "  ✓ Removed SDDM drop-in override"
fi

# 2. Remove SDDM Theme (Only if AETHER created it)
PREEXISTED_THEME="$(get_install_var PREEXISTED_THEME)"
if [ -d /usr/share/sddm/themes/aether ]; then
    if [ "${PREEXISTED_THEME}" = "true" ]; then
        echo -e "  \033[1;33m! Preserving /usr/share/sddm/themes/aether (pre-dated AETHER installation)\033[0m"
    else
        echo "  [sudo] Removing /usr/share/sddm/themes/aether..."
        sudo rm -rf /usr/share/sddm/themes/aether
        echo "  ✓ Removed AETHER SDDM theme directory"
    fi
fi

# 3. Clean up deployed Hyprlock files
rm -f "${HOME}/.config/hypr/aether-colors.conf"
rm -f "${HOME}/.config/hypr/aether-hyprlock.conf"
rm -f "${HOME}/.config/hypr/scripts/aether-media-status.sh"
echo "  ✓ Cleaned up AETHER Hyprlock standalone files"

# 4. Trigger restoration to re-link original dotfiles
if [ -d "${HOME}/.config/aether/backups/latest" ]; then
    read -rp "  Restore original pre-installation configurations & dotfiles symlinks now? (Y/n): " do_restore
    if [[ ! "${do_restore}" =~ ^[Nn]$ ]]; then
        "${PROJECT_ROOT}/scripts/restore.sh" "${HOME}/.config/aether/backups/latest"
    fi
fi

rm -f "${MANIFEST_LOG}"
echo -e "\033[1;32m[SUCCESS]\033[0m AETHER has been safely uninstalled!"