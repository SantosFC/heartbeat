#!/bin/bash

# Coleta informações em tempo real
UPTIME=$(uptime -p)
LOAD=$(cut -d' ' -f1-3 /proc/loadavg)
DISK_FREE=$(df -h / --output=avail | tail -1 | xargs)
MEM_FREE=$(free -h | awk '/^Mem:/ {print $7}')
TIMESTAMP=$(date -Iseconds)

# Monta o JSON
JSON=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "uptime": "$UPTIME",
  "load": "$LOAD",
  "disk_free": "$DISK_FREE",
  "mem_free": "$MEM_FREE"
}
EOF
)

# Envia para o Healthchecks
curl -fsS -m 10 --retry 3 \
  -X POST \
  -H "Content-Type: application/json" \
  -d "$JSON" \
  https://hc-ping.com/05bcb14f-acc2-4e10-af33-6d0782350b94

