#!/bin/zsh

# power cycle webcam
sudo usbreset /dev/bus/usb/$(lsusb | grep 'Microdia Webcam Vitade AF' | cut -d ' ' --output-delimiter='/' -f 2,4 | tr -d ':')

# set cropped webcam
#sudo /usr/bin/modprobe v4l2loopback video_nr=5
#killall ffmpeg
#ffmpeg -nostdin -i /dev/video0 -f v4l2 -pix_fmt yuv420p -filter:v "hflip,crop=in_w/2:in_h/2:in_w/4:in_h/4" /dev/video5 &
