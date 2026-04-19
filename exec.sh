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

dnf5 copr enable -y sneexy/zen-browser
dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm"
dnf5 install -y \
    terra-release-extras \
    terra-release-mesa \
    ./protonvpn-stable-release-1.0.3-1.noarch.rpm \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
dnf5 remove -y \
    dragon \
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
    abe \
    alacritty \
    alienblaster \
    amoebax \
    antimicrox \
    armacycles-ad \
    asc \
    astromenace \
    atanks \
    audacity-freeworld \
    auriferous \
    ballbuster \
    bat \
    bottles \
    blobwars \
    bombardier \
    boswars \
    brave-browser \
    btop \
    btrfs-assistant \
    bygfoot \
    bzflag \
    cargo \
    cdogs-sdl \
    clanbomber \
    cmatrix \
    code \
    colossus \
    crack-attack \
    CriticalMass \
    crossfire-client \
    dd2 \
    default-fonts \
    enigma \
    extremetuxracer \
    eza \
    fastfetch \
    ffmpeg \
    fillets-ng \
    fish \
    foobillard \
    freeciv \
    freecol \
    freedoom \
    freedoom2 \
    freedoom \
    frozen-bubble \
    gamescope \
    gemdropx \
    gimp \
    glaxium \
    glob2 \
    gnubg \
    gnugo \
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
    gweled \
    HandBrake \
    HandBrake-gui \
    hardinfo2 \
    haxima \
    hedgewars \
    hexchat \
    htop \
    inotify-tools \
    jetbrains-mono-fonts-all \
    jetbrainsmono-nerd-fonts \
    kate \
    kcheckers \
    kdenlive \
    kid3 \
    klassy \
    kmousetool \
    knights \
    KoboDeluxe \
    krename \
    krita \
    ksnakeduel \
    kspaceduel \
    kstars \
    ksudoku \
    ktimer \
    kweather \
    libavcodec-freeworld \
    libcurl-devel \
    libdnf5-plugin-actions \
    libheif-freeworld \
    libreoffice-base \
    lbrickbuster2 \
    libxcrypt-compat \
    lincity-ng \
    lordsawar \
    lutris \
    Maelstrom \
    material-icons-fonts \
    megaglest \
    mirrormagic \
    methane \
    mc \
    memtest86+ \
    mesa-vulkan-drivers.x86_64 \
    mozilla-openh264 \
    nerd-fonts \
    nethack \
    nethack-vultures \
    netpanzer \
    njam \
    nogravity \
    obs-studio \
    okteta \
    openlierox \
    openrgb \
    openttd \
    pachi \
    papirus-icon-theme \
    pingus \
    pioneers \
    pipenightdreams \
    pipepanic \
    pipewire-codec-aptx \
    planets \
    powermanga \
    proton-vpn-gnome-desktop \
    protontricks \
    pychess \
    PySolFC \
    qbittorrent \
    quarry \
    radeontop \
    remmina \
    rocksndiamonds \
    rogue \
    rpmfusion-free-appstream-data \
    rpmfusion-free-obsolete-packages \
    rpmfusion-nonfree-appstream-data \
    rpmfusion-nonfree-obsolete-packages \
    rsms-inter-fonts \
    rsms-inter-vf-fonts \
    rust \
    scorched3d \
    seahorse-adventures \
    shippy \
    solarwolf \
    sopwith \
    steam \
    stormbaancoureur \
    snapper \
    taxipilot \
    tecnoballz \
    terminus-fonts \
    terminus-fonts-console \
    trackballs \
    tuxpaint \
    tuxpaint-stamps \
    tuxtype2 \
    ularn \
    ultimatestunts \
    vesktop \
    vim-default-editor \
    virt-manager \
    vlc \
    vlc-plugins-all \
    vlc-plugins-freeworld \
    vodovod \
    warmux \
    warzone2100 \
    waycheck \
    wesnoth \
    wine \
    wine-alsa \
    wine-pulseaudio \
    winetricks \
    wordwarvi \
    xblast \
    xgalaxy \
    xmoto \
    yazi \
    zed \
    zen-browser
dnf5 autoremove -y
systemctl disable NetworkManager-wait-online.service
dracut --regenerate-all -f -v
fastfetch
