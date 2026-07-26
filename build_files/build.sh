#!/usr/bin/env bash
set -euo pipefail

# === repos: Third-party repositories ===
rpmkeys --import "/etc/pki/rpm-gpg/RPM-GPG-KEY-terra44"
dnf5 -y copr enable theblackdon/kineticwe
dnf5 -y copr enable lionheartp/Hyprland
dnf5 -y copr enable linuxgamerlife/lgl-dnf-helper
dnf5 -y copr enable linuxgamerlife/lgl-emoji-picker
dnf5 -y copr enable imput/helium
sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/terra.repo
curl -L -o /tmp/rpmfusion-free-release-44.noarch.rpm "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-44.noarch.rpm"
dnf install -y \
    /tmp/rpmfusion-free-release-44.noarch.rpm
rm -f /tmp/*.rpm

# === removals: Packages removed from the base Bazzite image ===

# pre script (removals)
# Leftover Bazzite overlay files not owned by any RPM
# Force Restart Waydroid entry + dead waydroid helper scripts/artwork
rm -f /usr/share/applications/waydroid-container-restart.desktop
rm -f /usr/libexec/waydroid-container-restart \
      /usr/libexec/waydroid-container-start \
      /usr/libexec/waydroid-container-stop \
      /usr/libexec/waydroid-fix-controllers
rm -rf /usr/share/applications/Waydroid
# Discourse forum launcher
rm -f /usr/share/applications/discourse.desktop
# Bazzite Documentation launcher
rm -f /usr/share/applications/bazzite-documentation.desktop
# Bazzite System Update launcher (ujust update)
rm -f /usr/share/applications/system-update.desktop

dnf remove -y \
    waydroid \
    waydroid-selinux \
    input-remapper \
    mariadb \
    mariadb-server \
    mariadb-common \
    mariadb-errmsg \
    mariadb-connector-c \
    mariadb-connector-c-config \
    mariadb-backup \
    mariadb-cracklib-password-check \
    mariadb-gssapi-server \
    bazaar \
    krunner-bazaar \
    kde-connect \
    kdeconnectd \
    kde-connect-libs \
    rom-properties \
    rom-properties-common \
    rom-properties-kf6 \
    rom-properties-utils \
    uupd \
    topgrade \
    bazzite-portal

# === desktop: Desktop environment packages ===

# pre script (desktop)
# /opt is a symlink to /var/opt on atomic Fedora — helium-bin's RPM
if [ -L /opt ]; then
  rm -f /opt
fi

dnf install -y \
    helium-bin \
    kineticwe \
    noctalia-git \
    qt5ct \
    qt6ct \
    nwg-look \
    kitty \
    discord \
    lgl-emoji-picker \
    lgl-dnf-helper \
    plasma-discover \
    plasma-discover-flatpak

#dnf install -y \
#    /ctx/rpms/vm-curator-1.2.1-1.x86_64.rpm

# === media: Media production tools (Firebot, Lightworks) ===

dnf install -y \
    obs-studio \
    obs-studio-plugin-browser

dnf install -y \
    /ctx/rpms/firebot-v5.66.7-linux-x64.rpm \
    /ctx/rpms/Lightworks-2025.2-56356.rpm

# === cli: Cli packages ===

dnf install -y \
    btop \
    zoxide \
    eza \
    htop \
    helix \
    yazi \
    git

# === virt: Virtualization packages (vm-curator runtime deps; libudev/polkit are in base Fedora) ===

dnf install -y \
    qemu-system-x86 \
    qemu-img \
    swtpm \
    edk2-ovmf \
    virt-viewer \
    passt

# === system: System tooling baked into the image (dcli-bootc persists across rebuilds) ===

dnf install -y \
    mediawriter \
    gwenview \
    haruna \
    zathura

# === cleanup ===
dnf clean all && rm -rf /var/cache/dnf/*
