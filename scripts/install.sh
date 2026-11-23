#!/usr/bin/env bash
# ==============================================================================
# AETHER — Interactive Non-Destructive Installer
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo -e "\033[1;35m"
echo "    ___    ________________  ____________ "
echo "   /   |  / ____/_  __/ __ \/ ____/ __ \ "
echo "  / /| | / __/   / / / /_/ / __/ / /_/ / "
echo " / ___ |/ /___  / / / _, _/ /___/ _, _/  "
echo "/_/  |_/_____/ /_/ /_/ |_/_____/_/ |_|   "
echo -e "\033[0m"
echo -e "\033[1;34m[AETHER]\033[0m Starting safe installation..."

# 1. Automatic pre-installation backup
echo -e "\n\033[1;33m[1/4] Running pre-installation backup...\033[0m"
"${PROJECT_ROOT}/scripts/backup.sh"

# 2. Dependency verification
echo -e "\n\033[1;33m[2/4] Verifying dependencies...\033[0m"
for dep in sddm sddm-greeter-qt6 hyprlock; do
    if command -v "$dep" >/dev/null 2>&1; then
        echo "  ✓ Found: $dep"
    else
        echo -e "  \033[1;31m✗ Missing: $dep\033[0m"
    fi
done

if ! command -v playerctl >/dev/null 2>&1; then
    echo -e "  \033[1;33m! Note: playerctl is not installed. Media controls will degrade silently.\033[0m"
    echo "    (Install via 'sudo pacman -S playerctl' whenever desired)"
fi

# 3. Install SDDM theme
echo -e "\n\033[1;33m[3/4] Installing SDDM theme to /usr/share/sddm/themes/aether...\033[0m"
echo "  [sudo] Copying theme files..."
sudo mkdir -p /usr/share/sddm/themes/aether
sudo cp -r "${PROJECT_ROOT}/sddm/"* /usr/share/sddm/themes/aether/
echo "  ✓ AETHER SDDM theme installed."

read -rp "  Apply AETHER as the active SDDM theme now? (y/N): " apply_sddm
if [[ "${apply_sddm}" =~ ^[Yy]$ ]]; then
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=aether" | sudo tee /etc/sddm.conf.d/10-theme-aether.conf >/dev/null
    echo "  ✓ Active SDDM theme set to 'aether' via /etc/sddm.conf.d/10-theme-aether.conf"
else
    echo "  → SDDM theme active setting unchanged. Existing theme remains active."
fi

# 4. Optional Hyprlock deployment
echo -e "\n\033[1;33m[4/4] Hyprlock lockscreen setup...\033[0m"
read -rp "  Deploy AETHER as your active Hyprlock configuration? (y/N): " apply_hyprlock
if [[ "${apply_hyprlock}" =~ ^[Yy]$ ]]; then
    mkdir -p "${HOME}/.config/hypr/scripts"
    cp "${PROJECT_ROOT}/hyprlock/scripts/media-status.sh" "${HOME}/.config/hypr/scripts/aether-media-status.sh"
    chmod +x "${HOME}/.config/hypr/scripts/aether-media-status.sh"
    cp "${PROJECT_ROOT}/hyprlock/aether-colors.conf" "${HOME}/.config/hypr/aether-colors.conf"
    
    sed "s|/home/omii/Projects/aether-desktop/hyprlock/scripts|${HOME}/.config/hypr/scripts|g" \
        "${PROJECT_ROOT}/hyprlock/aether-hyprlock.conf" > "${HOME}/.config/hypr/hyprlock.conf"
    echo "  ✓ AETHER Hyprlock deployed to ~/.config/hypr/hyprlock.conf"
else
    echo "  → Active Hyprlock configuration unchanged."
fi

echo -e "\n\033[1;32m[SUCCESS]\033[0m AETHER installation process finished cleanly!"
echo "  To test SDDM: /usr/bin/sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/aether"
echo "  To test Hyprlock: hyprlock"
echo "  To rollback at any time: ./scripts/restore.sh"