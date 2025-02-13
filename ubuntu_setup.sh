#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo $0"
    exit 1
fi

# Update package list
echo "Updating package list..."
apt update -y

# Install wget if not installed
if ! command -v wget &>/dev/null; then
    echo "Installing wget..."
    apt install wget -y
else
    echo "wget is already installed."
fi

# Set download directory
DOWNLOAD_DIR="/root/Downloads"
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Get latest Ubuntu version
UBUNTU_VERSION=$(curl -s https://releases.ubuntu.com/ | grep -oP 'href="\K[0-9]+(\.[0-9]+)*\/(?=")' | tail -1)
UBUNTU_ISO_URL="https://releases.ubuntu.com/${UBUNTU_VERSION}ubuntu-${UBUNTU_VERSION%/}-desktop-amd64.iso"

# Download Ubuntu ISO
echo "Downloading Ubuntu from $UBUNTU_ISO_URL..."
wget -c "$UBUNTU_ISO_URL" -O "ubuntu-${UBUNTU_VERSION%/}-desktop-amd64.iso"

# Verify download
if [ $? -eq 0 ]; then
    echo "Ubuntu ISO downloaded successfully!"
else
    echo "Download failed!"
    exit 1
fi

# Optional: Install additional packages
echo "Installing essential tools..."
apt install -y vim curl git

echo "Setup complete. Ubuntu ISO saved at: $DOWNLOAD_DIR/ubuntu-${UBUNTU_VERSION%/}-desktop-amd64.iso"
