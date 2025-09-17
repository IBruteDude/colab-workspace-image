#!/bin/bash
set -e

# ensure rclone config exists
if [ ! -f ~/.config/rclone/rclone.conf ]; then
  echo "rclone config not found!"
  exit 1
fi

# mount Google Drive
mkdir -p /home/coder/gdrive
# you may need to allow other users to access fuse mount
rclone mount mygdrive: /home/coder/gdrive --allow-other --vfs-cache-mode writes &

# wait a bit
sleep 5

# start code-server
code-server --bind-addr 0.0.0.0:8080 --auth password --password "${PASSWORD:-password}" --user-data-dir /home/coder/.local/share/code-server
