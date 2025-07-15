#!/bin/bash

WALLPAPERS_DIR="/home/settler/Pictures/Wallpapers"
WS0_DIR="$WALLPAPERS_DIR/Збірна жовтий борщ"
WS1_DIR="$WALLPAPERS_DIR/Plain walls"
WS2_DIR="$WALLPAPERS_DIR/Rudymenty"
WS3_DIR="$WALLPAPERS_DIR/Linux canonical"
WS0_INTERVAL=60
WS1_INTERVAL=180
WS2_INTERVAL=60
WS3_INTERVAL=120
SLIDESHOW_PID=""
RANDOM=$$$(date +%s)

# Trap to clean up slideshow on exit
trap '[ -n "$SLIDESHOW_PID" ] && kill "$SLIDESHOW_PID" 2>/dev/null; exit' SIGINT SIGTERM

# Set background image
set_background() {
    [ -f "$1" ] && gsettings set org.cinnamon.desktop.background picture-uri "file://$1"
}

# Slideshow with random starting image
run_slideshow() {
    local dir="$1"
    local ws="$2"
    local interval="$3"
    local images=()
    while IFS= read -r -d '' img; do
        images+=("$img")
    done < <(find "$dir" -type f -print0)
    [ ${#images[@]} -eq 0 ] && return 1

    local indices=($(seq 0 $(( ${#images[@]} - 1 )) | shuf))
    while [ "$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')" = "$ws" ]; do
        for idx in "${indices[@]}"; do
            set_background "${images[$idx]}"
            sleep "$interval"
        done
    done
}

# Main loop
prev_ws=""
while true; do
    current_ws=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')
    if [ "$current_ws" != "$prev_ws" ]; then
        [ -n "$SLIDESHOW_PID" ] && kill "$SLIDESHOW_PID" 2>/dev/null
        SLIDESHOW_PID=""
        case $current_ws in
            0)
                run_slideshow "$WS0_DIR" 0 "$WS0_INTERVAL" &
                SLIDESHOW_PID=$!
                ;;
            1)
                run_slideshow "$WS1_DIR" 1 "$WS1_INTERVAL" &
                SLIDESHOW_PID=$!
                ;;
            2)
                run_slideshow "$WS2_DIR" 2 "$WS2_INTERVAL" &
                SLIDESHOW_PID=$!
                ;;
            3)
                run_slideshow "$WS3_DIR" 3 "$WS3_INTERVAL" &
                SLIDESHOW_PID=$!
                ;;
        esac
        prev_ws="$current_ws"
    fi
    sleep 1
done
