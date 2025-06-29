#!/bin/bash

# Define your monitor name
MONITOR="eDP-1"

# Define the list of wallpaper keywords you want to cycle through
# MAKE SURE these match the 'name:' keywords in your hyprpaper.conf
WALLPAPERS=("wp1" "wp2" "wp3" "wp4" "default")

# File to store the current wallpaper index
STATE_FILE="/tmp/current_wallpaper_index_$MONITOR.txt" # Use monitor name for unique state per monitor

# Read the current index, default to 0 if the file doesn't exist or is empty/invalid
if [ -f "$STATE_FILE" ] && [ -s "$STATE_FILE" ]; then
    CURRENT_INDEX=$(cat "$STATE_FILE" | tr -d '[:space:]') # Read and trim whitespace
    # Validate index (optional but recommended)
    if ! [[ "$CURRENT_INDEX" =~ ^[0-9]+$ ]] || [ "$CURRENT_INDEX" -ge ${#WALLPAPERS[@]} ]; then
        CURRENT_INDEX=0
    fi
else
    CURRENT_INDEX=0
fi

# Calculate the index of the next wallpaper
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

# Get the keyword for the next wallpaper
NEXT_WALLPAPER_KEYWORD="${WALLPAPERS[$NEXT_INDEX]}"

# Tell hyprpaper to switch the wallpaper on the specified monitor using the keyword
hyprctl hyprpaper wallpaper "$MONITOR, name:$NEXT_WALLPAPER_KEYWORD"

# Save the new index for the next run
echo "$NEXT_INDEX" > "$STATE_FILE"
