#!/usr/bin/env bash
# ==============================================================================
# AETHER — Comprehensive Atomic Backup Script
# Safely archives SDDM configs and Hyprlock symlink metadata + file contents
# ==============================================================================
set -euo pipefail

BACKUP_ROOT="${HOME}/.config/aether/backups"
TIMESTAMP="$(date +'%Y%m%d_%H%M%S')"
BACKUP_DIR="${BACKUP_ROOT}/${TIMESTAMP}"

mkdir -p "${BACKUP_DIR}"

echo -e "\033[1;35m[AETHER]\033[0m Starting safe configuration backup..."
echo -e "\033[1;34m[INFO]\033[0m Destination: ${BACKUP_DIR}"

# 1. Manifest initialization
MANIFEST="${BACKUP_DIR}/manifest.txt"
cat <<EOF > "${MANIFEST}"
# AETHER Backup Manifest
DATE=$(date -Iseconds)
HOST=${HOSTNAME:-$(uname -n)}
USER=${USER}
EOF

# 2. Backup SDDM configuration
if [ -f /etc/sddm.conf ]; then
    cp /etc/sddm.conf "${BACKUP_DIR}/sddm.conf"
    echo "SDDM_CONF_EXISTS=true" >> "${MANIFEST}"
    echo "  ✓ Backed up /etc/sddm.conf"
else
    echo "SDDM_CONF_EXISTS=false" >> "${MANIFEST}"
fi

if [ -d /etc/sddm.conf.d ]; then
    cp -r /etc/sddm.conf.d "${BACKUP_DIR}/sddm.conf.d"
    echo "SDDM_CONF_D_EXISTS=true" >> "${MANIFEST}"
    echo "  ✓ Backed up /etc/sddm.conf.d/"
else
    echo "SDDM_CONF_D_EXISTS=false" >> "${MANIFEST}"
fi

# 3. Check if /usr/share/sddm/themes/aether already pre-exists
if [ -d /usr/share/sddm/themes/aether ]; then
    echo "AETHER_THEME_PREEXISTED=true" >> "${MANIFEST}"
    cp -r /usr/share/sddm/themes/aether "${BACKUP_DIR}/preexisting_aether_theme"
    echo "  ✓ Backed up pre-existing /usr/share/sddm/themes/aether"
else
    echo "AETHER_THEME_PREEXISTED=false" >> "${MANIFEST}"
fi

# 4. Backup Hyprlock configuration (Preserving symlink target & contents)
HYPR_CONF="${HOME}/.config/hypr/hyprlock.conf"
if [ -L "${HYPR_CONF}" ]; then
    TARGET_PATH="$(readlink -f "${HYPR_CONF}")"
    echo "HYPRLOCK_TYPE=symlink" >> "${MANIFEST}"
    echo "HYPRLOCK_TARGET=${TARGET_PATH}" >> "${MANIFEST}"
    cp -P "${HYPR_CONF}" "${BACKUP_DIR}/hyprlock.conf.symlink"
    cp -L "${HYPR_CONF}" "${BACKUP_DIR}/hyprlock.conf.target_content"
    echo "  ✓ Backed up Hyprlock symlink pointer -> ${TARGET_PATH}"
    echo "  ✓ Backed up Hyprlock target file content safely"
elif [ -f "${HYPR_CONF}" ]; then
    echo "HYPRLOCK_TYPE=file" >> "${MANIFEST}"
    echo "HYPRLOCK_TARGET=none" >> "${MANIFEST}"
    cp "${HYPR_CONF}" "${BACKUP_DIR}/hyprlock.conf"
    echo "  ✓ Backed up Hyprlock regular file"
else
    echo "HYPRLOCK_TYPE=none" >> "${MANIFEST}"
    echo "HYPRLOCK_TARGET=none" >> "${MANIFEST}"
fi

if [ -f "${HOME}/.config/hypr/hyprlock-colors.conf" ]; then
    cp "${HOME}/.config/hypr/hyprlock-colors.conf" "${BACKUP_DIR}/hyprlock-colors.conf"
    echo "  ✓ Backed up ~/.config/hypr/hyprlock-colors.conf"
fi

# 5. Atomically update 'latest' symlink
ln -sfn "${BACKUP_DIR}" "${BACKUP_ROOT}/latest"

echo -e "\033[1;32m[SUCCESS]\033[0m Atomic backup completed successfully!"