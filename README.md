# ✦ AETHER ✦

> *A cinematic, anime/fantasy-inspired login and lockscreen environment for Arch Linux and Hyprland.*

AETHER replaces the disjointed login and locking experience with a coordinated, cinematic interface built with Qt 6 QML and native Hyprlock PAM security.

---

## ✦ Key Features

- **Coordinated Visual Identity**: Deep midnight blue (`#080D1C`), glowing violet (`#7054C8`), and soft lavender (`#A99AFF`) palette.
- **SDDM Login Theme (Qt 6)**:
  - Organic breathing ambient aura.
  - Cinematic high-contrast clock and date display.
  - Native SDDM authentication with dynamic error toasts and busy states.
  - Integrated desktop session selector (Wayland/Hyprland) and power management controls.
  - Integrated login music player using Qt 6 `AudioOutput` with volume fade-out on login.
  - Configurable via `theme.conf` without touching QML code.
- **Hyprlock Lockscreen**:
  - Native PAM authentication with failure indicators.
  - Frosted void background with multi-pass live desktop blur.
  - Now-playing media marquee ticker and clickable media controls (`⟨`, `Ⅱ`, `⟩`).
  - Resilient design: degrades silently without errors if players or `playerctl` are absent.
- **Automated Safety & Recovery**:
  - Non-destructive installer using SDDM drop-in configurations (`/etc/sddm.conf.d/`).
  - Mandatory atomic backup before installation.
  - Single-command emergency rollback at any time (`./scripts/restore.sh`).

---

## ✦ Requirements

- **OS**: Arch Linux
- **Compositor**: Hyprland
- **Display Manager**: SDDM (`0.21+`) with `sddm-greeter-qt6`
- **Dependencies**:
  ```bash
  sudo pacman -S qt6-declarative qt6-multimedia qt6-multimedia-ffmpeg hyprlock sddm
  ```
  *(Optional: `playerctl` for lockscreen media controls)*

---

## ✦ Live Testing (Without Modifying System)

You can test both components live right out of the box:

**Test SDDM Greeter:**
```bash
/usr/bin/sddm-greeter-qt6 --test-mode --theme ./sddm
```
*(Press `Esc` to exit test mode)*

**Test Hyprlock Lockscreen:**
```bash
hyprlock --config ./hyprlock/aether-hyprlock.conf
```
*(Type your normal user password and press `Enter` to unlock)*

---

## ✦ Installation & Recovery

**1. Install AETHER:**
```bash
./scripts/install.sh
```
*Creates an automated backup, safely copies the theme, and interactively asks for confirmation before applying any changes.*

**2. Emergency Rollback / Restore:**
```bash
./scripts/restore.sh
```
*Immediately restores your previous working SDDM and Hyprlock configurations from the backup archive.*

**3. Clean Uninstallation:**
```bash
./scripts/uninstall.sh
```

---

## ✦ Architecture

```text
aether-desktop/
├── sddm/                 # Qt 6 QML SDDM Greeter Theme
│   ├── theme/            # Centralized QML design tokens (AetherTheme)
│   ├── components/       # Clock, Inputs, Buttons, Background, Music, Power
│   └── Main.qml          # Assembled greeter entry point
├── hyprlock/             # Standalone Hyprlock Configuration
│   ├── aether-colors.conf# Hyprlock color tokens
│   ├── aether-hyprlock.conf
│   └── scripts/          # Resilient media query script
├── scripts/              # backup.sh, install.sh, restore.sh, uninstall.sh
└── docs/                 # DESIGN_SYSTEM.md & documentation
```

---

## ✦ License

Released under the [MIT License](LICENSE).