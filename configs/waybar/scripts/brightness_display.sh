#!/bin/bash

BRIGHTNESS_PATH="/sys/class/backlight/amdgpu_bl1"
MAX=$(< "$BRIGHTNESS_PATH/max_brightness")
CUR=$(< "$BRIGHTNESS_PATH/brightness")

PERCENT=$(( (CUR * 100 + MAX / 2) / MAX ))

echo "☀ ${PERCENT}%"

