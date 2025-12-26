#!/bin/bash
set -e

# Start system DBus
mkdir -p /run/dbus
dbus-daemon --system --fork

# Clean old VNC locks (important for restarts)
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*

# Set VNC geometry (TigerVNC-compatible)
export VNC_RESOLUTION=1360x768

# Start TigerVNC (NEW SYNTAX – display only)
vncserver :0

# Start noVNC
cd /noVNC-1.2.0
./utils/launch.sh --vnc localhost:5900 --listen 8900
