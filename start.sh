
#!/bin/bash

set -e

# Start DBus
mkdir -p /run/dbus
dbus-daemon --system --fork

# Start SSH daemon
/usr/bin/sshd

# Prepare X11 socket directory
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Start XRDP
/usr/bin/xrdp --nodaemon
