# AETHER — Troubleshooting & FAQ Guide

This guide covers common questions, configuration tips, and solutions for running AETHER on Arch Linux.

---

## 1. SDDM Login Screen

### Q: I see `Failed to open VDPAU backend libvdpau_nvidia.so` in the terminal.
- **Explanation**: This is a harmless warning from FFmpeg attempting to query NVIDIA hardware video acceleration.
- **Impact**: None. Qt 6 Multimedia automatically falls back to standard FFmpeg decoding. The theme and all animations continue running smoothly.

### Q: How do I enable background music on the login screen?
1. Open `sddm/theme.conf` (or `/usr/share/sddm/themes/aether/theme.conf` if installed).
2. Set:
   ```ini
   PlayMusic=true
   MusicFile="/path/to/your/audio.mp3"
   Volume=0.5
   ```
3. Restart or test the SDDM greeter. The floating music player pill will appear at the bottom center.

### Q: How do I change the clock format from 24-hour to 12-hour?
In `theme.conf`, change:
```ini
TimeFormat="hh:mm AP"
```

---

## 2. Hyprlock Lockscreen

### Q: Media controls or song title are not appearing on the lockscreen.
- **Check 1**: Make sure a media player (Spotify, browser, mpv) is actively playing audio. When no music is playing, the media bar remains cleanly hidden.
- **Check 2**: Ensure `playerctl` is installed:
  ```bash
  sudo pacman -S playerctl
  ```

### Q: How do I test the lockscreen without installing it to my system?
Run:
```bash
hyprlock --config ./hyprlock/aether-hyprlock.conf
```
Type your password to unlock.

---

## 3. Emergency Recovery & Rollback

### Q: What if I want to revert back to my previous theme?
Run our automated restore script:
```bash
./scripts/restore.sh
```
This restores your original `/etc/sddm.conf` and `~/.config/hypr/hyprlock.conf` from your backup archive.

### Q: How do I restore from a virtual console (TTY) if graphical login ever fails?
1. Press `Ctrl + Alt + F3` to open a TTY terminal.
2. Log in with your username and password.
3. Run:
   ```bash
   cd ~/Projects/aether-desktop
   ./scripts/restore.sh
   sudo systemctl restart sddm
   ```