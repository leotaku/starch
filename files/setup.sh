#!/usr/bin/env sh
set -e

# Add a non-root user
useradd -m starch || true

# Install dependencies
pacman -Sy steam xterm --noconfirm || true

# Install drivers
pacman -S xf86-video-intel mesa lib32-mesa --noconfirm || true
pacman -S xf86-video-amdgpu xf86-video-ati --noconfirm || true
pacman -S nvidia nvidia-utils lib32-nvidia-utils --noconfirm || true

# Install helpful utilities
pacman -S firefox thunar xdg-utils --noconfirm || true

# Set required environment variables
echo "export DISPLAY=:0" >> /etc/environment
echo "export PULSE_SERVER=unix:/run/user/host/pulse/native" >> /etc/environment

# Ensure settings are applied every reboot
echo '
if ! [ -e /run/host/etc/ld.so.cache ]; then
    ln -s /etc/ld.so.cache /run/host/etc/
fi

if [ -e /run/user/0/bus ]; then
    chmod 777 /run/user/0/bus
fi
' >> /etc/profile
