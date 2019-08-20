#!/bin/bash

set -x

cleanup() {
  echo "Starting cleanup..."
  rm -f /tmp/tmp.file*
  echo "Cleanup complete..."
  exit
}

trap cleanup SIGHUP SIGINT SIGTERM EXIT

xargs -P 2 -I {} sh -c 'eval "$1"' - {} <<'EOF'
time dd if=/dev/urandom of=/tmp/file.$RANDOM bs=2M count=1048
time nice -n 19 ionice -c2 -n7 dd if=/dev/urandom of=/tmp/file.$RANDOM bs=2M count=1048
EOF

cleanup
