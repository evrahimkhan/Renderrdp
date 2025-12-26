#!/bin/bash
set -e

# DBus (system bus)
mkdir -p /run/dbus
dbus-daemon --system --fork

# Fix Xauthority warning (not fatal but clean)
touch /root/.Xauthority

# Clean stale X locks
rm -rf /tmp/.X*-lock /tmp/.X11-unix

# Ensure runtime dir
mkdir -p /tmp/runtime-root
chmod 700 /tmp/runtime-root

# Start TigerVNC (DO NOT use -localhost on Render)
vncserver :0 -geometry 1360x768

# Start noVNC
cd /noVNC-1.2.0
./utils/launch.sh --vnc localhost:5900 --listen 8900
