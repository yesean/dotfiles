#!/usr/bin/env bash

superlight_mouse_receiver="USB Receiver"
superlight_mouse_wired="USB Receiver"

disable() {
  grep -l "$1" /sys/bus/usb/devices/*/product |
    sed -e 's/product/power\/wakeup/g' |
    xargs -d '\n' -I{} sh -c '[ -f {} ] && tee {} <<<disabled >/dev/null'
}

disable "$superlight_mouse_receiver"
disable "$superlight_mouse_wired"
