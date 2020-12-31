#!/bin/sh

speed=$(sensors | grep fan1 | awk '{print $2; exit}')

if [ "$speed" != "" ]; then
    speed_round=$(echo "scale=1;$speed" | bc -l )
    echo "$speed_round rpm"
else
   echo "#"
fi
