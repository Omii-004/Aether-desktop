#!/usr/bin/env bash
# ==============================================================================
# AETHER — Production-Hardened Safe Installer
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST_LOG="${HOME}/.config/aether/install_manifest.txt"

echo -e "\033[1;35m"
echo "    ___    ________________  ____________ "
echo "   /   |  / ____/_  __/ __ \/ ____/ __ \ "
echo "  / /| | / __/   / / / /_/ / __/ / /_/ / "
echo " / ___ |/ /___  / / / _, _/ /___/ _, _/  "
echo "/_/  |_/_____/ /_/ /_/ |_/_____/_/ |_|   "
echo -e "\033[0m"
echo -e "\033[1;34m[AETHER]\033[0m Starting safe installation..."

# 1. Mandatory Dependency Verification
echo -e "\n\033[1;33m[1/4] Verifying dependencies...\033[0m"
MISSING_DEPS=()
for dep in sddm sddm-greeter-qt6 hyprlock; do
    if command -v "$dep" >/dev/null 2>&1; then
        echo "  ✓ Found binary: $dep"
    else
        MISSING_DEPS+=("$dep")
    fi
done

if [ ! -d "/usr/lib/qt6/qml/QtMultimedia" ]; then
    MISSING_DEPS+=("qt6-multimedia qt6-multimedia-ffmpeg")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "\033[1;31m[ERROR]\033[0m Missing mandatory dependencies: ${MISSING_DEPS[*]}"
    echo "Please install them via: sudo pacman -S ${MISSING_DEPS[*]}"
    exit 1
fi

if ! command -v playerctl >/dev/null 2>&1; then
    echo -e "  \033[1;33m! Note: playerctl not installed. Lockscreen media controls will degrade gracefully.\033[0m"
fi

# 2. Mandatory Pre-Installation Atomic Backup
echo -e "\n\033[1;33m[2/4] Running pre-installation backup...\033[0m"
"${PROJECT_ROOT}/scripts/backup.sh"

mkdir -p "$(dirname "${MANIFEST_LOG}")"
echo "# AETHER Install Manifest - $(date)" > "${MANIFEST_LOG}"

# 3. SDDM Theme Installation & Precedence Handling
echo -e "\n\033[1;33m[3/4] Installing SDDM theme to /usr/share/sddm/themes/aether...\033[0m"
if [ -d /usr/share/sddm/themes/aether ]; then
    echo "PREEXISTED_THEME=true" >> "${MANIFEST_LOG}"
else
    echo "PREEXISTED_THEME=false" >> "${MANIFEST_LOG}"
fi

sudo mkdir -p /usr/share/sddm/themes/aether
sudo cp -r "${PROJECT_ROOT}/sddm/"* /usr/share/sddm/themes/aether/
echo "INSTALLED_THEME=true" >> "${MANIFEST_LOG}"
echo "  ✓ Theme files copied to /usr/share/sddm/themes/aether"

read -rp "  Apply AETHER as the active SDDM theme now? (y/N): " apply_sddm
if [[ "${apply_sddm}" =~ ^[Yy]$ ]]; then
    # Detect /etc/sddm.conf precedence conflict
    if [ -f /etc/sddm.conf ] && grep -q "Current=" /etc/sddm.conf; then
        echo "  Notice: /etc/sddm.conf overrides /etc/sddm.conf.d/."
        sudo sed -i 's/^Current=.*/Current=aether/' /etc/sddm.conf
        echo "ACTIVATED_SDDM_MAIN=true" >> "${MANIFEST_LOG}"
        echo "  ✓ Updated [Theme] Current=aether in /etc/sddm.conf"
    else
        sudo mkdir -p /etc/sddm.conf.d
        echo -e "[Theme]\nCurrent=aether" | sudo tee /etc/sddm.conf.d/10-theme-aether.conf >/dev/null
        echo "ACTIVATED_SDDM_DROPIN=true" >> "${MANIFEST_LOG}"
        echo "  ✓ Applied /etc/sddm.conf.d/10-theme-aether.conf"
    fi
fi

# 4. Hyprlock Deployment (Symlink-Safe)
echo -e "\n\033[1;33m[4/4] Hyprlock lockscreen setup...\033[0m"
read -rp "  Deploy AETHER as your active Hyprlock configuration? (y/N): " apply_hyprlock
if [[ "${apply_hyprlock}" =~ ^[Yy]$ ]]; then
    mkdir -p "${HOME}/.config/hypr/scripts"
    cp "${PROJECT_ROOT}/hyprlock/scripts/media-status.sh" "${HOME}/.config/hypr/scripts/aether-media-status.sh"
    chmod +x "${HOME}/.config/hypr/scripts/aether-media-status.sh"
    cp "${PROJECT_ROOT}/hyprlock/aether-colors.conf" "${HOME}/.config/hypr/aether-colors.conf"
    cp "${PROJECT_ROOT}/hyprlock/aether-hyprlock.conf" "${HOME}/.config/hypr/aether-hyprlock.conf"
    
    # Safely swap symlink without overwriting dotfiles target
    HYPR_DEST="${HOME}/.config/hypr/hyprlock.conf"
    if [ -L "${HYPR_DEST}" ] || [ -f "${HYPR_DEST}" ]; then
        rm -f "${HYPR_DEST}" # Unlinks symlink; target in ~/dotfiles remains completely untouched!
    fi
    ln -s "${HOME}/.config/hypr/aether-hyprlock.conf" "${HYPR_DEST}"
    echo "DEPLOYED_HYPRLOCK=true" >> "${MANIFEST_LOG}"
    echo "  ✓ Linked ~/.config/hypr/hyprlock.conf -> aether-hyprlock.conf (Dotfiles preserved!)"
fi

echo -e "\n\033[1;32m[SUCCESS]\033[0m AETHER installation finished cleanly and safely!"
echo "  To rollback at any time: ./scripts/restore.sh"