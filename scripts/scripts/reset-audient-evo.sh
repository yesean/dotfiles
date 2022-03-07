#!/usr/bin/env sh

audient_evo_file=$(lsusb | grep "Audient EVO4" | cut -d " " -f 2,4 --output-delimiter="/" | tr -d ":")
sudo usbreset "/dev/bus/usb/${audient_evo_file}"
