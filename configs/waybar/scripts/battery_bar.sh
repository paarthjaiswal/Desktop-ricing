#!/bin/bash

battery_info=$(acpi -b)
if [ -z "$battery_info" ]; then
  echo "🔋 [ No Battery Info ]"
  exit 1
fi

battery_percent=$(echo "$battery_info" | grep -oP '\d+%' | tr -d '%')
charging_state=$(echo "$battery_info" | grep -oP 'Charging|Discharging|Full')

max_percent=100
bar_length=10
filled=$(( (battery_percent * bar_length) / max_percent ))

bar=""
for i in $(seq 1 $bar_length); do
  if [ $i -le $filled ]; then
    bar+="█"
  else
    bar+="░"
  fi
done

# Icon logic
if [ "$charging_state" = "Charging" ]; then
  icon=""  # plug
elif [ "$battery_percent" -ge 80 ]; then
  icon=""  # full
elif [ "$battery_percent" -ge 60 ]; then
  icon=""  # 3/4
elif [ "$battery_percent" -ge 40 ]; then
  icon=""  # half
elif [ "$battery_percent" -ge 20 ]; then
  icon=""  # 1/4
else
  icon=""  # low
fi

echo "$icon $battery_percent% [ $bar ]"
