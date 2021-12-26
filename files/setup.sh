#!/usr/bin/env sh
set -e

# Add a non-root user
groupadd mount --gid 100 || true
useradd -m starch -G wheel -G mount || true

# Change passwords
echo 'starch:starch' | chpasswd
echo 'root:root' | chpasswd
chown '0:0' /etc/sudoers

# Install dependencies
pacman -Sy steam xterm --noconfirm

# Install drivers
pacman -S xf86-video-intel mesa lib32-mesa --noconfirm || true
pacman -S xf86-video-amdgpu xf86-video-ati --noconfirm || true
pacman -S nvidia nvidia-utils lib32-nvidia-utils --noconfirm || true
pacman -S pulseaudio alsa-utils --noconfirm || true

# Install helpful utilities
pacman -S firefox thunar xdg-utils --noconfirm || true

# Set required environment variables
echo "export DISPLAY=:0" >> /etc/environment
echo "export PULSE_SERVER=unix:/run/user/host/pulse/native" >> /etc/environment

# Enable persistent setup
systemctl enable --now --wait busaccess.service
systemctl enable --now --wait runhost.service
