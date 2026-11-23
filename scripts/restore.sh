#!/usr/bin/env bash
# ==============================================================================
# AETHER — Deterministic System Restoration Script
# Restores exact pre-installation state and reconstructs dotfiles symlinks
# ==============================================================================
set -euo pipefail

BACKUP_ROOT="${HOME}/.config/aether/backups"
TARGET_BACKUP="${1:-${BACKUP_ROOT}/latest}"

if [ ! -d "${TARGET_BACKUP}" ]; then
    echo -e "\033[1;31m[ERROR]\033[0m No backup found at: ${TARGET_BACKUP}"
    exit 1
fi

REAL_BACKUP_PATH="$(readlink -f "${TARGET_BACKUP}")"
MANIFEST="${REAL_BACKUP_PATH}/manifest.txt"

if [ ! -f "${MANIFEST}" ]; then
    echo -e "\033[1;31m[ERROR]\033[0m Backup manifest missing: ${MANIFEST}"
    exit 1
fi

echo -e "\033[1;35m[AETHER]\033[0m Starting system restoration..."
echo -e "\033[1;34m[INFO]\033[0m Sourced from: ${REAL_BACKUP_PATH}"

# Helper to read manifest key-values
get_manifest_var() {
    grep "^$1=" "${MANIFEST}" 2>/dev/null | cut -d'=' -f2- || echo ""
}

# 1. Restore SDDM Configurations
if [ -f /etc/sddm.conf.d/10-theme-aether.conf ]; then
    echo "  [sudo] Removing AETHER SDDM override: /etc/sddm.conf.d/10-theme-aether.conf..."
    sudo rm -f /etc/sddm.conf.d/10-theme-aether.conf
    echo "  ✓ Removed AETHER drop-in override"
fi

SDDM_CONF_EXISTS="$(get_manifest_var SDDM_CONF_EXISTS)"
if [ "${SDDM_CONF_EXISTS}" = "true" ] && [ -f "${REAL_BACKUP_PATH}/sddm.conf" ]; then
    echo "  [sudo] Restoring /etc/sddm.conf..."
    sudo cp "${REAL_BACKUP_PATH}/sddm.conf" /etc/sddm.conf
    echo "  ✓ Restored /etc/sddm.conf"
fi

SDDM_CONF_D_EXISTS="$(get_manifest_var SDDM_CONF_D_EXISTS)"
if [ "${SDDM_CONF_D_EXISTS}" = "true" ] && [ -d "${REAL_BACKUP_PATH}/sddm.conf.d" ]; then
    echo "  [sudo] Restoring /etc/sddm.conf.d/..."
    sudo cp -r "${REAL_BACKUP_PATH}/sddm.conf.d" /etc/
    echo "  ✓ Restored /etc/sddm.conf.d/"
elif [ "${SDDM_CONF_D_EXISTS}" = "false" ] && [ -d /etc/sddm.conf.d ]; then
    # Clean up empty directory if AETHER created it
    sudo rmdir /etc/sddm.conf.d 2>/dev/null || true
fi

# 2. Restore Hyprlock Configuration & Symlinks
HYPRLOCK_TYPE="$(get_manifest_var HYPRLOCK_TYPE)"
HYPRLOCK_TARGET="$(get_manifest_var HYPRLOCK_TARGET)"
HYPR_CONF="${HOME}/.config/hypr/hyprlock.conf"

if [ "${HYPRLOCK_TYPE}" = "symlink" ] && [ -n "${HYPRLOCK_TARGET}" ]; then
    echo "  Re-linking Hyprlock configuration to original dotfiles target..."
    ln -sfn "${HYPRLOCK_TARGET}" "${HYPR_CONF}"
    echo "  ✓ Re-established symlink: ${HYPR_CONF} -> ${HYPRLOCK_TARGET}"
elif [ "${HYPRLOCK_TYPE}" = "file" ] && [ -f "${REAL_BACKUP_PATH}/hyprlock.conf" ]; then
    cp "${REAL_BACKUP_PATH}/hyprlock.conf" "${HYPR_CONF}"
    echo "  ✓ Restored regular file ~/.config/hypr/hyprlock.conf"
fi

if [ -f "${REAL_BACKUP_PATH}/hyprlock-colors.conf" ]; then
    cp "${REAL_BACKUP_PATH}/hyprlock-colors.conf" "${HOME}/.config/hypr/hyprlock-colors.conf"
    echo "  ✓ Restored ~/.config/hypr/hyprlock-colors.conf"
fi

# 3. Clean up AETHER-specific deployed helper files
rm -f "${HOME}/.config/hypr/aether-colors.conf"
rm -f "${HOME}/.config/hypr/scripts/aether-media-status.sh"

echo -e "\033[1;32m[SUCCESS]\033[0m Full system restoration completed successfully!"