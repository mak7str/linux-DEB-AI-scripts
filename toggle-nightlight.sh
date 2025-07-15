#!/bin/bash
status=$(gsettings get org.cinnamon.settings-daemon.plugins.color night-light-enabled)

if [ "$status" = "true" ]; then
    gsettings set org.cinnamon.settings-daemon.plugins.color night-light-enabled false
else
    gsettings set org.cinnamon.settings-daemon.plugins.color night-light-enabled true
fi

