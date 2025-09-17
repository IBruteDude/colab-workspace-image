#!/bin/bash
set -e

# ensure rclone config exists
if [ ! -f ~/.config/rclone/rclone.conf ]; then
  if [ -z "$RCLONE_CONFIG_MYGDRIVE_CLIENT_ID" ] || [ -z "$RCLONE_CONFIG_MYGDRIVE_CLIENT_SECRET" ] || [ -z "$RCLONE_CONFIG_MYGDRIVE_TOKEN" ]; then
    echo "Error: neither rclone.conf nor required environment vars (CLIENT_ID, CLIENT_SECRET, TOKEN) provided"
    exit 1
  else
    echo "Using environment-variable based rclone remote configuration"
  fi
fi

# mount Google Drive
mkdir -p /home/coder/gdrive
# you may need to allow other users to access fuse mount
rclone mount mygdrive: /home/coder/gdrive --allow-other --vfs-cache-mode writes &

# wait a bit
sleep 5

# start code-server
code-server --bind-addr 0.0.0.0:8080 --auth password --password "${PASSWORD:-password}" --user-data-dir /home/coder/.local/share/code-server
