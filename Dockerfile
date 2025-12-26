FROM archlinux:latest

# Update system and install required packages
RUN pacman -Syu --noconfirm \
    dbus \
    curl \
    firefox \
    git \
    xfce4 \
    xfce4-terminal \
    tigervnc \
    wget \
    xorg-xinit \
    openssh \
    net-tools \
    sudo

# Generate SSH host keys (optional but safe)
RUN ssh-keygen -A

# Download and extract noVNC (FIXED)
WORKDIR /
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && \
    rm v1.2.0.tar.gz

# Setup VNC
RUN mkdir -p /root/.vnc && \
    echo '274600' | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# XFCE startup for VNC
RUN echo '#!/bin/sh' > /root/.vnc/xstartup && \
    echo 'unset SESSION_MANAGER' >> /root/.vnc/xstartup && \
    echo 'unset DBUS_SESSION_BUS_ADDRESS' >> /root/.vnc/xstartup && \
    echo 'exec dbus-launch xfce4-session &' >> /root/.vnc/xstartup && \
    chmod 755 /root/.vnc/xstartup

# noVNC + VNC launcher
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo 'mkdir -p /run/dbus' >> /start.sh && \
    echo 'dbus-daemon --system --fork' >> /start.sh && \
    echo 'vncserver :0 -geometry 1360x768 -localhost' >> /start.sh && \
    echo 'cd /noVNC-1.2.0' >> /start.sh && \
    echo './utils/launch.sh --vnc localhost:5900 --listen 8900' >> /start.sh && \
    chmod 755 /start.sh

EXPOSE 8900

CMD ["/start.sh"]
