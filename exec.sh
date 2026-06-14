#!/bin/bash

set -e

END='\033[0m\n'
RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'

if [ "$EUID" -ne 0 ]; then
    printf $RED"Please run as root using sudo!"$END
    exit 1
fi

USER_HOME=$(eval printf ~$SUDO_USER)

cp -r etc /
cp -r usr /
rm /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo
rm /etc/yum.repos.d/google-chrome.repo
rm /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo
rm /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
sudo -u "$SUDO_USER" cp -r .bashrc.d "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .config "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .local "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .scripts "$USER_HOME"
sudo -u "$SUDO_USER" cp -r Pictures "$USER_HOME"
plymouth-set-default-theme -R fedora-mac-style

dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm"
dnf5 install -y \
    terra-release-extras \
    terra-release-mesa \
    ./protonvpn-stable-release-1.0.3-1.noarch.rpm \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
cp -r yum.repos.d /etc
dnf5 remove -y \
    dragon \
    kde-partitionmanager \
    kleopatra \
    kmail \
    kmailtransport \
    kompare \
    korganizer \
    kmouth \
    krdc \
    neochat
dnf5 upgrade --allowerasing --allow-downgrade --skip-unavailable --refresh -y
dnf5 install --allowerasing -y \
    alacritty \
    antimicrox \
    audacity-freeworld \
    bat \
    blender \
    bottles \
    brave-browser \
    brave-origin \
    btop \
    btrfs-assistant \
    cargo \
    cmatrix \
    codium \
    default-fonts \
    eza \
    f21-backgrounds-kde \
    f22-backgrounds-kde \
    f23-backgrounds-kde \
    f24-backgrounds-kde \
    f25-backgrounds-kde \
    f26-backgrounds-kde \
    f27-backgrounds-kde \
    f28-backgrounds-kde \
    f29-backgrounds-kde \
    f30-backgrounds-kde \
    f31-backgrounds-kde \
    f32-backgrounds-kde \
    f33-backgrounds-kde \
    f34-backgrounds-kde \
    f35-backgrounds-kde \
    f36-backgrounds-kde \
    f37-backgrounds-kde \
    f38-backgrounds-kde \
    f39-backgrounds-kde \
    f40-backgrounds-kde \
    f41-backgrounds-kde \
    f42-backgrounds-kde \
    f43-backgrounds-kde \
    fastfetch \
    ffmpeg \
    fish \
    freedoom \
    freedoom2 \
    gamescope \
    gimp \
    gnome-disk-utility \
    google-android-emoji-fonts \
    google-arimo-fonts \
    google-droid-fonts-all \
    google-go-fonts \
    google-noto-fonts-all \
    google-noto-sans-cjk-fonts \
    google-noto-sans-hk-fonts \
    google-noto-serif-cjk-fonts \
    google-roboto-fonts \
    google-roboto-mono-fonts \
    google-roboto-slab-fonts \
    google-rubik-fonts \
    gstreamer-plugins-espeak \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly \
    HandBrake \
    HandBrake-gui \
    hardinfo2 \
    hexchat \
    htop \
    inkscape \
    inotify-tools \
    jetbrains-mono-fonts-all \
    jetbrainsmono-nerd-fonts \
    kate \
    kdenlive \
    kid3 \
    kmousetool \
    knights \
    kolourpaint \
    kpat \
    krename \
    krita \
    kstars \
    ksudoku \
    ktimer \
    kweather \
    libavcodec-freeworld \
    libcurl-devel \
    libdnf5-plugin-actions \
    libheif-freeworld \
    libreoffice-base \
    libxcrypt-compat \
    lutris \
    material-icons-fonts \
    mc \
    memtest86+ \
    mesa-vulkan-drivers.x86_64 \
    mission-center \
    mozilla-openh264 \
    nerd-fonts \
    obs-studio \
    okteta \
    okular \
    openrgb \
    openttd \
    pipewire-codec-aptx \
    proton-vpn-gnome-desktop \
    protontricks \
    qbittorrent \
    qrca \
    radeontop \
    remmina \
    rpmfusion-free-appstream-data \
    rpmfusion-free-obsolete-packages \
    rpmfusion-nonfree-appstream-data \
    rpmfusion-nonfree-obsolete-packages \
    rsms-inter-fonts \
    rsms-inter-vf-fonts \
    rust \
    skanpage \
    steam \
    snapper \
    terminus-fonts \
    terminus-fonts-console \
    vim-default-editor \
    virt-manager \
    vlc-plugins-all \
    vlc-plugins-freeworld \
    waycheck \
    wine \
    wine-alsa \
    wine-pulseaudio \
    winetricks \
    yazi \
    zed
dnf5 autoremove -y
dnf5 install -y nano
systemctl disable NetworkManager-wait-online.service
dracut --regenerate-all -f -v
fastfetch
