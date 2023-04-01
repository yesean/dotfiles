#!/usr/bin/env bash

disable() {
  grep -l "$1" /sys/bus/usb/devices/*/product |
    sed -e 's/product/power\/wakeup/g' |
    xargs -d '\n' -I{} sh -c '[ -f {} ] && tee {} <<<disabled >/dev/null'
}

disable "USB Receiver" # Logitech G Pro X Superlight
