#!/bin/bash
set -e

# Start system DBus
mkdir -p /run/dbus
dbus-daemon --system --fork

# Clean old VNC locks (important for Docker restarts)
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*

# Start VNC server (display :0 → port 5900)
vncserver :0 -geometry 1360x768 -localhost

# Start noVNC
cd /noVNC-1.2.0
./utils/launch.sh --vnc localhost:5900 --listen 8900
