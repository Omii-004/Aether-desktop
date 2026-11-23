#!/usr/bin/env bash
# ==============================================================================
# AETHER — Backup Script
# Atomically archives active SDDM & Hyprlock configurations
# ==============================================================================
set -euo pipefail

BACKUP_ROOT="${HOME}/.config/aether/backups"
TIMESTAMP="$(date +'%Y%m%d_%H%M%S')"
BACKUP_DIR="${BACKUP_ROOT}/${TIMESTAMP}"

mkdir -p "${BACKUP_DIR}"

echo -e "\033[1;35m[AETHER]\033[0m Starting system configuration backup..."
echo -e "\033[1;34m[INFO]\033[0m Backup target: ${BACKUP_DIR}"

# 1. Backup SDDM configuration
if [ -f /etc/sddm.conf ]; then
    cp /etc/sddm.conf "${BACKUP_DIR}/sddm.conf"
    echo "  ✓ Backed up /etc/sddm.conf"
fi

if [ -d /etc/sddm.conf.d ]; then
    cp -r /etc/sddm.conf.d "${BACKUP_DIR}/sddm.conf.d"
    echo "  ✓ Backed up /etc/sddm.conf.d/"
fi

# 2. Backup Hyprlock configuration
if [ -e "${HOME}/.config/hypr/hyprlock.conf" ]; then
    cp -P "${HOME}/.config/hypr/hyprlock.conf" "${BACKUP_DIR}/hyprlock.conf"
    echo "  ✓ Backed up ~/.config/hypr/hyprlock.conf"
fi

if [ -f "${HOME}/.config/hypr/hyprlock-colors.conf" ]; then
    cp "${HOME}/.config/hypr/hyprlock-colors.conf" "${BACKUP_DIR}/hyprlock-colors.conf"
    echo "  ✓ Backed up ~/.config/hypr/hyprlock-colors.conf"
fi

# 3. Create manifest
cat <<EOF > "${BACKUP_DIR}/manifest.txt"
AETHER Backup Manifest
Date: $(date)
Host: ${HOSTNAME:-$(uname -n)}
User: ${USER}
EOF

# Update 'latest' pointer symlink
ln -sfn "${BACKUP_DIR}" "${BACKUP_ROOT}/latest"

echo -e "\033[1;32m[SUCCESS]\033[0m Backup completed successfully!"
echo -e "\033[1;34m[INFO]\033[0m Pointer 'latest' updated -> ${BACKUP_ROOT}/latest"