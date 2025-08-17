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

printf $CYN"Copying system configuration files ..."$END

OUT='DNF Config added successfully ...'
printf $CYN"Adding DNF config ..."$END
    cp -r dnf.conf /etc/dnf || OUT="Failed to copy dnf config ..."
    echo $OUT

printf $CYN"Copying user configuration files ..."$END

OUT='Successfully copied .shrc to home directory ...'
printf $CYN"Copying .shrc ..."$END
    sudo -u "$SUDO_USER" cp -r .shrc "$USER_HOME" || OUT='Failed to copy .shrc to home directory ...'
    echo $OUT

OUT='Successfully copied .bashrc to home directory ...'
printf $CYN"Copying .bashrc ..."$END
    sudo -u "$SUDO_USER" cp -r .bashrc "$USER_HOME" || OUT='Failed to copy .bashrc to home directory ...'
    echo $OUT

OUT='Successfully copied .bashrc.d folder to home directory ...'
printf $CYN"Copying .bashrc.d folder to home directory ..."$END
    sudo -u "$SUDO_USER" cp -r .bashrc.d "$USER_HOME" || OUT='Failed to copy .bashrc.d folder to home directory ...'
    echo $OUT

OUT='Successfully added user config folder to home directory ...'
printf $CYN"Adding user config folder to home directory ..."$END
    sudo -u "$SUDO_USER" cp -r .config "$USER_HOME" || OUT='Failed to copy .config files to ~/.config'
    echo $OUT

printf $CYN"Removing packages from system ..."$END

OUT='All packages removed successfully ...'
dnf remove -y \
    abrt \
    akregator \
    dragon \
    firefox \
    kaddressbook \
    kmail \
    kmahjongg \
    kmines \
    kmouth \
    korganizer \
    krdc \
    krfb \
    kwrite \
    kpat \
    neochat \
    plasma-welcome || OUT='Failed to remove packages from system ...'
    dnf autoremove -y
    echo $OUT

printf $CYN"Enabling additional repositories ..."$END

OUT='Brave Browser repository added ...'
printf $CYN"Adding Brave Browser rpm repository ..."$END
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    echo $OUT

OUT='Terra repository added ...'
printf $CYN"Adding Terra repository ..."$END
    dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
    echo $OUT

printf $CYN"Adding RPM Fusion repositories ..."$END

OUT='RPM Fusion repositories added ...'
dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    echo $OUT

printf $CYN"Refreshing mirrorlist and performing system update ..."$END
    dnf upgrade --refresh -y

printf $CYN"Installing system rpm packages ..."$END
dnf install --allowerasing -y \
    alacritty \
    antimicrox \
    audacity \
    brave-browser \
    bottles \
    btop \
    btrfs-assistant \
    cargo \
    cmatrix \
    codium \
    decibels \
    discord \
    fastfetch \
    ffmpeg \
    gamescope \
    gimp \
    google-android-emoji-fonts \
    google-arimo-fonts \
    google-carlito-fonts \
    google-crosextra-caladea-fonts \
    google-droid-fonts-all \
    google-go-fonts \
    google-noto-fonts-all \
    google-noto-sans-cjk-fonts \
    google-noto-sans-cjk-vf-fonts \
    google-noto-serif-cjk-vf-fonts \
    google-noto-sans-hk-fonts \
    google-noto-serif-cjk-fonts \
    google-roboto-fonts \
    google-roboto-mono-fonts \
    google-roboto-slab-fonts \
    google-rubik-fonts \
    gstreamer1-plugins-bad-freeworld \
    gstreamer-plugins-espeak \
    gstreamer1-plugin-openh264 \
    hardinfo2 \
    htop \
    inotify-tools \
    jetbrains-mono-fonts-all \
    kdenlive \
    kid3 \
    kstars \
    kvantum \
    libavcodec-freeworld \
    libcurl-devel \
    libdnf5-plugin-actions \
    libheif-freeworld \
    libxcrypt-compat \
    lutris \
    material-icons-fonts \
    memtest86+ \
    mercurial \
    mesa-va-drivers-freeworld \
    mesa-vdpau-drivers-freeworld \
    mc \
    mozilla-openh264 \
    obs-studio \
    papirus-icon-theme \
    pipewire-codec-aptx \
    protontricks \
    pulseaudio-utils \
    qbittorrent \
    radeontop \
    remmina \
    steam \
    snapper \
    terminus-fonts \
    vim \
    vlc
    printf $GRN "System rpm packages installed ..."$END

printf $CYN"Setting default text editor to VS Codium ..."$END
    xdg-mime default codium.desktop text/plain || printf $RED"Failed to change default text editor to Visual Studio Code ..."$END && sleep 2

printf $CYN"Switching mesa drivers to freeworld ..."$END
    dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y || printf $RED"POSSIBLY REDUNDANT COMMAND; IGNORE IF FAILED ..."$END && sleep 5
    dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y || printf $RED"POSSIBLY REDUNDANT COMMAND; IGNORE IF FAILED ..."$END && sleep 5
    printf $GRN "Mesa freeworld drivers installed ..."$END

printf $CYN"Removing unused packages ..."$END
    dnf autoremove -y || printf $RED"Failed to resolve transaction ..."$END
    printf $GRN "Unused packages successfully removed ..."

printf $CYN"Checking for flatpak updates ..."$END
    sudo -u "$SUDO_USER" flatpak update -y
    printf $GRN "Flatpaks are up to date ..."$END

printf $CYN"Installing flatpaks from Flathub ..."$END
    sudo -u "$SUDO_USER" flatpak install flathub -y com.geeks3d.furmark
    sudo -u "$SUDO_USER" flatpak install flathub -y com.jetbrains.Rider
    sudo -u "$SUDO_USER" flatpak install flathub -y com.pokemmo.PokeMMO
    sudo -u "$SUDO_USER" flatpak install flathub -y com.protonvpn.www
    sudo -u "$SUDO_USER" flatpak install flathub -y com.todoist.Todoist
    sudo -u "$SUDO_USER" flatpak install flathub -y com.vysp3r.ProtonPlus
    sudo -u "$SUDO_USER" flatpak install flathub -y io.github.aandrew_me.ytdn
    sudo -u "$SUDO_USER" flatpak install flathub -y io.github.freedoom.Phase1
    sudo -u "$SUDO_USER" flatpak install flathub -y io.github.endless_sky.endless_sky
    sudo -u "$SUDO_USER" flatpak install flathub -y io.github.shiftey.Desktop
    sudo -u "$SUDO_USER" flatpak install flathub -y io.missioncenter.MissionCenter
    sudo -u "$SUDO_USER" flatpak install flathub -y md.obsidian.Obsidian
    sudo -u "$SUDO_USER" flatpak install flathub -y me.proton.Mail
    sudo -u "$SUDO_USER" flatpak install flathub -y me.proton.Pass
    sudo -u "$SUDO_USER" flatpak install flathub -y net.runelite.RuneLite
    sudo -u "$SUDO_USER" flatpak install flathub -y org.azahar_emu.Azahar
    sudo -u "$SUDO_USER" flatpak install flathub -y org.openttd.OpenTTD
    sudo -u "$SUDO_USER" flatpak install flathub -y org.signal.Signal
    sudo -u "$SUDO_USER" flatpak install flathub -y sh.ppy.osu
    printf $GRN "All flatpaks installed ..."$END && sleep 1

printf $CYN"Disabling Network Manager wait online service ..."$END
    systemctl disable NetworkManager-wait-online.service || printf $RED"Failed to disable NetworkManager-wait-online.service"$END
    printf $GRN"NetworkManager-wait-online.service disabled ..."$END

printf $CYN"Regenerating initramfs ..."$END
    dracut --regenerate-all -f
    printf $GRN"Successfully regenerated initramfs ..."$END

printf $CYN"Updating bootloader  ...$END"
    printf $CYN"Updating grub config file ..."$END
    cp -r grub /etc/default || printf $RED"Failed to update grub config file ..."$END && sleep 2
    printf $GRN "Grub config file added ..."$END && sleep 1
    printf $CYN"Updating grub ..."$END
    grub2-mkconfig -o /etc/grub2.cfg || printf $RED"Failed to update grub ..."$END && sleep 2

printf $CYN"Setup complete!"$END
fastfetch