#!/usr/bin/env bash

product_file=$(grep -l "USB Receiver" /sys/bus/usb/devices/*/product)
wakeup_file=${product_file/product/power\/wakeup}
tee "$wakeup_file" <<<disabled >/dev/null

product_file=$(grep -l "PRO X Wireless" /sys/bus/usb/devices/*/product)
wakeup_file=${product_file/product/power\/wakeup}
tee "$wakeup_file" <<<disabled >/dev/null
