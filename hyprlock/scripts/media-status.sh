#!/bin/bash
# ==============================================================================
# AETHER — Hyprlock Resilient Media Status & Controls
# ==============================================================================

# Graceful degradation if playerctl is not installed
if ! command -v playerctl >/dev/null 2>&1; then
    exit 0
fi

# Detect currently playing player
PLAYER=""
while read -r p; do
    if [ "$(playerctl --player="$p" status 2>/dev/null)" = "Playing" ]; then
        PLAYER="$p"
        break
    fi
done < <(playerctl -l 2>/dev/null)

# Exit silently if nothing is playing
[ -z "$PLAYER" ] && exit 0

# Handle control action arguments
case "$1" in
    previous)
        playerctl --player="$PLAYER" previous 2>/dev/null
        exit 0
        ;;
    play-pause|pause)
        playerctl --player="$PLAYER" play-pause 2>/dev/null
        exit 0
        ;;
    next)
        playerctl --player="$PLAYER" next 2>/dev/null
        exit 0
        ;;
    icon-prev)
        echo "⟨"
        exit 0
        ;;
    icon-play)
        status="$(playerctl --player="$PLAYER" status 2>/dev/null)"
        [ "$status" = "Playing" ] && echo "Ⅱ" || echo "▶"
        exit 0
        ;;
    icon-next)
        echo "⟩"
        exit 0
        ;;
esac

# Metadata formatting with smooth marquee scrolling
MAX_CHARS=50
DISPLAY_CHARS=28

title="$(playerctl --player="$PLAYER" metadata --format '{{ title }}' 2>/dev/null)"
artist="$(playerctl --player="$PLAYER" metadata --format '{{ artist }}' 2>/dev/null)"

[ -z "$title" ] && exit 0

if [ -n "$artist" ]; then
    text="$title — $artist"
else
    text="$title"
fi

if [ "${#text}" -gt "$MAX_CHARS" ]; then
    text="${text:0:$((MAX_CHARS - 1))}…"
fi

text="$text     "
len=${#text}

if [ "$len" -le "$DISPLAY_CHARS" ]; then
    echo "♪ $text"
    exit 0
fi

pos=$(( $(date +%s) % len ))
visible="${text:$pos:$DISPLAY_CHARS}"

if [ "${#visible}" -lt "$DISPLAY_CHARS" ]; then
    visible="$visible${text:0:$((DISPLAY_CHARS - ${#visible}))}"
fi

echo "♪ $visible"