#!/bin/bash
# now-playing.sh

MAX_CHARS=45

if playerctl status 2>/dev/null | grep -q Playing; then
    title="$(playerctl metadata --format '{{ title }}')"
    artist="$(playerctl metadata --format '{{ artist }}')"

    text="$title - $artist"

    if [ "${#text}" -le "$MAX_CHARS" ]; then
        # Short enough — display statically, no scroll needed
        echo "♪  $text"
    else
        # Too long — scroll via time-based rotation.
        # No truncation: length stays stable for the whole song,
        # so the position never jumps when nothing changes.
        scroll="$text    "   # 4-space separator between repetitions
        len=${#scroll}
        pos=$(( $(date +%s) % len ))
        echo "♪  ${scroll:$pos}${scroll:0:$pos}"
    fi
fi
