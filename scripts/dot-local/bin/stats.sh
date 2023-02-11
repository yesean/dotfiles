#!/usr/bin/env sh

round() {
  printf "%.0f" "$1"
}

cpu_usage=$(round "$(top -bn 1 | grep -oP "(\d+[.]\d+)(?= us,)")")
cpu_temp=$(round "$(sensors | grep Tctl | tr -s " " | cut -d " " -f 2 | tr -d "+" | tr -cd "[:digit:].")")

gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

if [ "$1" = "cpu_usage" ]; then
  echo "$cpu_usage"
elif [ "$1" = "cpu_temp" ]; then
  echo "$cpu_temp"
elif [ "$1" = "gpu_usage" ]; then
  echo "$gpu_usage"
elif [ "$1" = "gpu_temp" ]; then
  echo "$gpu_temp"
else
  echo "CPU_USAGE=${cpu_usage}%"
  echo "CPU_TEMP=${cpu_temp}°C"
  echo "GPU_USAGE=${gpu_usage}%"
  echo "GPU_TEMP=${gpu_temp}°C"
fi
