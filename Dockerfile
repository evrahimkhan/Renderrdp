FROM archlinux:latest

# Update system & install packages
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
    xorg-xinit \
    openssh \
    xrdp

# Generate SSH host keys
RUN ssh-keygen -A

# Download & extract noVNC (FIXED – no mv)
WORKDIR /
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && \
    rm v1.2.0.tar.gz

# VNC setup
RUN mkdir -p /root/.vnc && \
    echo '274600' | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

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
