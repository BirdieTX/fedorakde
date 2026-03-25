#!/bin/bash

# This is script is currently broken, don't use  it

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
rm /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo
rm /etc/yum.repos.d/google-chrome.repo
rm /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo
rm /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
flatpak remote-delete fedora
flatpak remote-delete fedora-testing
sudo -u "$SUDO_USER" cp -r .bashrc.d "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .config "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .scripts "$USER_HOME"
sudo -u "$SUDO_USER" cp -r Pictures "$USER_HOME"

dnf5 install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
dnf install --allowerasing -y \
    alacritty \
    antimicrox \
    audacity-freeworld \
    bat \
    bottles \
    btop \
    btrfs-assistant \
    cargo \
    cmatrix \
    codium \
    default-fonts \
    fastfetch \
    ffmpeg \
    fish \
    freedoom \
    freedoom2 \
    gamescope \
    gimp \
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
    inotify-tools \
    jetbrains-mono-fonts-all \
    kate \
    kdenlive \
    kid3 \
    kmousetool \
    knights \
    kompare \
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
    mesa-va-drivers-freeworld \
    mesa-vdpau-drivers-freeworld \
    mesa-vulkan-drivers-freeworld.x86_6 \
    mesa-vulkan-drivers-freeworld.i686 \
    mozilla-openh264 \
    obs-studio \
    okteta \
    openrgb \
    openttd \
    papirus-icon-theme \
    pipewire-codec-aptx \
    protontricks \
    qbittorrent \
    radeontop \
    remmina \
    rpmfusion-free-appstream-data \
    rpmfusion-free-obsolete-packages \
    rpmfusion-nonfree-appstream-data \
    rpmfusion-nonfree-obsolete-packages \
    rsms-inter-fonts \
    rsms-inter-vf-fonts \
    rust \
    steam \
    snapper \
    terminus-fonts \
    terminus-fonts-console \
    vim-default-editor \
    virt-manager \
    vlc \
    vlc-plugins-all \
    vlc-plugins-freeworld \
    waycheck \
    wine \
    wine-alsa \
    wine-pulseaudio \
    winetricks
dnf5 remove -y \
    dragon \
    kmouth \
    kwalletmanager5 \
    neochat
dnf5 autoremove -y
dnf5 upgrade --allowerasing --allow-downgrade --skip-unavailable --refresh -y
bash -c "cat > /etc/dnf/libdnf5-plugins/actions.d/snapper.actions" <<'EOF'
# Get snapshot description
pre_transaction::::/usr/bin/sh -c echo\ "tmp.cmd=$(ps\ -o\ command\ --no-headers\ -p\ '${pid}')"

# Creates pre snapshot before the transaction and stores the snapshot number in the "tmp.snapper_pre_number"  variable.
pre_transaction::::/usr/bin/sh -c echo\ "tmp.snapper_pre_number=$(snapper\ create\ -t\ pre\ -c\ number\ -p\ -d\ '${tmp.cmd}')"

# If the variable "tmp.snapper_pre_number" exists, it creates post snapshot after the transaction and removes the variable "tmp.snapper_pre_number".
post_transaction::::/usr/bin/sh -c [\ -n\ "${tmp.snapper_pre_number}"\ ]\ &&\ snapper\ create\ -t\ post\ --pre-number\ "${tmp.snapper_pre_number}"\ -c\ number\ -d\ "${tmp.cmd}"\ ;\ echo\ tmp.snapper_pre_number\ ;\ echo\ tmp.cmd
EOF
snapper -c root create-config /
restorecon -RFv /.snapshots
snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes
echo 'PRUNENAMES = ".snapshots"' | sudo tee -a /etc/updatedb.conf
sed -i.bkp \
  -e '/^#GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS=/a \
GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="rd.live.overlay.overlayfs=1"' \
  -e '/^#GRUB_BTRFS_GRUB_DIRNAME=/a \
GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"' \
  -e '/^#GRUB_BTRFS_MKCONFIG=/a \
GRUB_BTRFS_MKCONFIG=/usr/bin/grub2-mkconfig' \
  -e '/^#GRUB_BTRFS_SCRIPT_CHECK=/a \
GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check' \
  config
make install
systemctl enable grub-btrfsd.service
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer
systemctl disable NetworkManager-wait-online.service
dracut --regenerate-all -f -v
sudo -u "$SUDO_USER" flatpak install flathub -y com.adamcake.Bolt
sudo -u "$SUDO_USER" flatpak install flathub -y com.brave.Browser
sudo -u "$SUDO_USER" flatpak install flathub -y com.discordapp.Discord
sudo -u "$SUDO_USER" flatpak install flathub -y com.markopejic.downloader
sudo -u "$SUDO_USER" flatpak install flathub -y com.pokemmo.PokeMMO
sudo -u "$SUDO_USER" flatpak install flathub -y com.rafaelmardojai.Blanket
sudo -u "$SUDO_USER" flatpak install flathub -y com.vysp3r.ProtonPlus
sudo -u "$SUDO_USER" flatpak install flathub -y dev.zed.Zed
sudo -u "$SUDO_USER" flatpak install flathub -y io.edcd.EDMarketConnector
sudo -u "$SUDO_USER" flatpak install flathub -y io.github.plrigaux.sysd-manager
sudo -u "$SUDO_USER" flatpak install flathub -y md.obsidian.Obsidian
sudo -u "$SUDO_USER" flatpak install flathub -y me.proton.Mail
sudo -u "$SUDO_USER" flatpak install flathub -y me.proton.Pass
sudo -u "$SUDO_USER" flatpak install flathub -y net.runelite.RuneLite
sudo -u "$SUDO_USER" flatpak install flathub -y org.gnome.gitlab.YaLTeR.VideoTrimmer
sudo -u "$SUDO_USER" flatpak install flathub -y org.signal.Signal
sudo -u "$SUDO_USER" flatpak install flathub -y ro.go.hmlendea.DL-Desktop
sudo -u "$SUDO_USER" flatpak install flathub -y sh.ppy.osu
fastfetch
