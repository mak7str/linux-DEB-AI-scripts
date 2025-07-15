#!/bin/bash
STATE=$(xinput list-props 10 | grep "Device Enabled" | awk '{print $4}')

if [ "$STATE" -eq 1 ]; then
  xinput disable 10
  notify-send -i input-touchpad "Touchpad Disabled"
else
  xinput enable 10
  notify-send -i input-touchpad "Touchpad Enabled"
fi

