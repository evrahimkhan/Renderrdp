FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt update && apt install -y \
    dbus-x11 \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    wget \
    curl \
    git \
    net-tools \
    sudo \
    ca-certificates \
    x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

# Download and extract noVNC
WORKDIR /
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && \
    rm v1.2.0.tar.gz

# Setup VNC password
RUN mkdir -p /root/.vnc && \
    echo '274600' | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# XFCE startup script for VNC
RUN echo '#!/bin/sh' > /root/.vnc/xstartup && \
    echo 'unset SESSION_MANAGER' >> /root/.vnc/xstartup && \
    echo 'unset DBUS_SESSION_BUS_ADDRESS' >> /root/.vnc/xstartup && \
    echo 'exec dbus-launch --exit-with-session xfce4-session &' >> /root/.vnc/xstartup && \
    chmod 755 /root/.vnc/xstartup

# Startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo 'mkdir -p /run/dbus' >> /start.sh && \
    echo 'dbus-daemon --system --fork' >> /start.sh && \
    echo 'rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*' >> /start.sh && \
    echo 'vncserver :0 -geometry 1360x768 -localhost' >> /start.sh && \
    echo 'cd /noVNC-1.2.0' >> /start.sh && \
    echo './utils/launch.sh --vnc localhost:5900 --listen 8900' >> /start.sh && \
    chmod 755 /start.sh

EXPOSE 8900

CMD ["/start.sh"]
