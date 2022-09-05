#!/usr/bin/env bash

product_file=$(grep -l "USB Receiver" /sys/bus/usb/devices/*/product)
wakeup_file=${product_file/product/power\/wakeup}
if [ -f "$wakeup_file" ]; then
  tee "$wakeup_file" <<<disabled >/dev/null
fi

product_file=$(grep -l "PRO X Wireless" /sys/bus/usb/devices/*/product)
wakeup_file=${product_file/product/power\/wakeup}
if [ -f "$wakeup_file" ]; then
  tee "$wakeup_file" <<<disabled >/dev/null
fi
