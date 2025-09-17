FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    wget curl git python3 python3-pip fuse unzip \
    && rm -rf /var/lib/apt/lists/*

# Install rclone
RUN curl https://rclone.org/install.sh | bash

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create user
RUN useradd -m coder
USER coder
WORKDIR /home/coder

# Copy rclone config if provided via build or volume
# Expect rclone.conf at /home/coder/.config/rclone/rclone.conf
RUN mkdir -p /home/coder/.config/rclone

EXPOSE 8080

COPY --chown=coder:coder entrypoint.sh /home/coder/entrypoint.sh
RUN chmod +x /home/coder/entrypoint.sh

ENV RCLONE_CONFIG_MYGDRIVE_TYPE=drive
ENV RCLONE_CONFIG_MYGDRIVE_CLIENT_ID=""
ENV RCLONE_CONFIG_MYGDRIVE_CLIENT_SECRET=""
ENV RCLONE_CONFIG_MYGDRIVE_TOKEN=""
ENV RCLONE_CONFIG_MYGDRIVE_SCOPE=drive
ENV RCLONE_SERVICE_ACCOUNT_FILE=/home/coder/.config/rclone/sa-key.json

ENTRYPOINT ["/home/coder/entrypoint.sh"]
