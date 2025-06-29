#!/bin/bash

BRIGHTNESS_PATH="/sys/class/backlight/amdgpu_bl1"
MAX=$(< "$BRIGHTNESS_PATH/max_brightness")
CUR=$(< "$BRIGHTNESS_PATH/brightness")

STATE_FILE="/tmp/brightness_next_zero"
[ -f "$STATE_FILE" ] || echo "false" > "$STATE_FILE"
NEXT_ZERO=$(< "$STATE_FILE")

if [ "$NEXT_ZERO" = "true" ]; then
  NEW=0
  echo "false" > "$STATE_FILE"
else
  if (( CUR < MAX * 25 / 100 )); then
    NEW=$((MAX * 25 / 100))
  elif (( CUR < MAX * 50 / 100 )); then
    NEW=$((MAX * 50 / 100))
  elif (( CUR < MAX * 75 / 100 )); then
    NEW=$((MAX * 75 / 100))
  elif (( CUR < MAX )); then
    NEW=$MAX
    echo "true" > "$STATE_FILE"
  fi
fi

brightnessctl set "$NEW"
pkill -SIGRTMIN+1 waybar
