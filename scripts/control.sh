#!/bin/bash
# MQTT control script for Alighieri
mosquitto_sub -h 192.168.1.1 -u control_user -P control_pass -t "alighieri/control/#" | while read -r message; do
    if [[ $message == volume* ]]; then
        LEVEL=$(echo $message | cut -d' ' -f2)
        amixer -D hw:1,0 set Master "$LEVEL%"  # UMC1820
    fi
done
