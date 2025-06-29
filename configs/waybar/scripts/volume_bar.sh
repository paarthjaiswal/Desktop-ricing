#!/bin/bash

volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

max_volume=100       # Total volume scale (default 100)
bar_length=10        # Total number of blocks in bar

# Calculate number of filled blocks
filled=$(( (volume * bar_length) / max_volume ))

bar=""
for i in $(seq 1 $bar_length); do
  if [ $i -le $filled ]; then
    bar+="█"
  else
    bar+="░"
  fi
done
if [ "$muted" = "true" ]; then
  echo " [Muted] [ $bar ]"
elif [ "$volume" -eq 0 ]; then
  echo " 0% [ $bar ]"  #  is the low-volume icon
else
  echo " $volume% [ $bar ]"
fi
