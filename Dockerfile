FROM archlinux:latest

# Update system and install required packages
RUN pacman -Syu --noconfirm \
    wine \
    qemu-base \
    xz \
    dbus \
    curl \
    firefox \
    gnome-system-monitor \
    mate-system-monitor \
    git \
    xfce4 \
    xfce4-terminal \
    tigervnc \
    wget \
    sudo \
    net-tools \
    xorg-xinit

# Download and extract noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && \
    mv noVNC-1.2.0 /noVNC-1.2.0

# Create VNC config
RUN mkdir -p /root/.vnc && \
    echo '274600' | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# VNC startup script
RUN echo '#!/bin/sh' > /root/.vnc/xstartup && \
    echo 'export MOZ_FAKE_NO_SANDBOX=1' >> /root/.vnc/xstartup && \
    echo 'dbus-launch xfce4-session &' >> /root/.vnc/xstartup && \
    chmod 755 /root/.vnc/xstartup

# Launcher script
RUN echo '#!/bin/bash' > /luo.sh && \
    echo 'whoami' >> /luo.sh && \
    echo 'cd ~' >> /luo.sh && \
    echo 'vncserver :2000 -geometry 1360x768' >> /luo.sh && \
    echo 'cd /noVNC-1.2.0' >> /luo.sh && \
    echo './utils/launch.sh --vnc localhost:7900 --listen 8900' >> /luo.sh && \
    chmod 755 /luo.sh

EXPOSE 8900

CMD ["/luo.sh"]
