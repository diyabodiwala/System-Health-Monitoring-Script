#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
CPU_USAGE_INT=${CPU_USAGE%\%}
if (( $(echo "$CPU_USAGE_INT > $CPU_THRESHOLD" |bc -l) )); then
  echo "CPU usage is above threshold: $CPU_USAGE"
fi

# Check memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" |bc -l) )); then
  echo "Memory usage is above threshold: $MEMORY_USAGE%"
fi

# Check disk usage
DISK_USAGE=$(df -h / | grep / | awk '{print $5}')
DISK_USAGE_INT=${DISK_USAGE%\%}
if (( $DISK_USAGE_INT > $DISK_THRESHOLD )); then
  echo "Disk usage is above threshold: $DISK_USAGE"
fi

# Check running processes
RUNNING_PROCESSES=$(ps -e | wc -l)
echo "Number of running processes: $RUNNING_PROCESSES"
