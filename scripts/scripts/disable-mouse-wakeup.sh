#!/usr/bin/env bash

superlight_mouse_receiver="USB Receiver"
superlight_mouse_wired="USB Receiver"

disable() {
  product_file=$(grep -l "$1" /sys/bus/usb/devices/*/product)
  wakeup_file=${product_file/product/power\/wakeup}
  if [ -f "$wakeup_file" ]; then
    tee "$wakeup_file" <<<disabled >/dev/null
  fi
}

disable "$superlight_mouse_receiver"
disable "$superlight_mouse_wired"
