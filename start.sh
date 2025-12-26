#!/bin/bash

set -e

# Start DBus (Arch way)
mkdir -p /run/dbus
dbus-daemon --system --fork

# Start SSH (Arch uses sshd, not "service ssh")
/usr/bin/sshd

# Prepare X11 directory
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Start XRDP
/usr/bin/xrdp --nodaemon
