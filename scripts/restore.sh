#!/usr/bin/env bash
# ==============================================================================
# AETHER — Restore & Emergency Recovery Script
# Restores active configurations from a selected or latest backup
# ==============================================================================
set -euo pipefail

BACKUP_ROOT="${HOME}/.config/aether/backups"
TARGET_BACKUP="${1:-${BACKUP_ROOT}/latest}"

if [ ! -d "${TARGET_BACKUP}" ]; then
    echo -e "\033[1;31m[ERROR]\033[0m No backup found at: ${TARGET_BACKUP}"
    echo "Available backups in ${BACKUP_ROOT}:"
    ls -1 "${BACKUP_ROOT}" 2>/dev/null || true
    exit 1
fi

REAL_BACKUP_PATH="$(readlink -f "${TARGET_BACKUP}")"
echo -e "\033[1;35m[AETHER]\033[0m Restoring configuration from: ${REAL_BACKUP_PATH}"

# 1. Restore Hyprlock user configurations
if [ -e "${TARGET_BACKUP}/hyprlock.conf" ]; then
    cp -P "${TARGET_BACKUP}/hyprlock.conf" "${HOME}/.config/hypr/hyprlock.conf"
    echo "  ✓ Restored ~/.config/hypr/hyprlock.conf"
fi

if [ -f "${TARGET_BACKUP}/hyprlock-colors.conf" ]; then
    cp "${TARGET_BACKUP}/hyprlock-colors.conf" "${HOME}/.config/hypr/hyprlock-colors.conf"
    echo "  ✓ Restored ~/.config/hypr/hyprlock-colors.conf"
fi

# 2. Restore SDDM system configuration (Requires sudo)
if [ -f "${TARGET_BACKUP}/sddm.conf" ]; then
    echo -e "\033[1;33m[PROMPT]\033[0m Restoring /etc/sddm.conf requires sudo permissions."
    sudo cp "${TARGET_BACKUP}/sddm.conf" /etc/sddm.conf
    echo "  ✓ Restored /etc/sddm.conf"
fi

if [ -d "${TARGET_BACKUP}/sddm.conf.d" ]; then
    sudo cp -r "${TARGET_BACKUP}/sddm.conf.d" /etc/sddm.conf.d
    echo "  ✓ Restored /etc/sddm.conf.d/"
fi

echo -e "\033[1;32m[SUCCESS]\033[0m System configuration restored successfully to previous baseline!"