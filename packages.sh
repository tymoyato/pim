#!/bin/bash

# Arch Linux Package Installer with Logging
# -----------------------------------------
# This script installs a list of packages via pacman and yay (for AUR)
# Logs failed installations to failed_packages.log

# File to log failed packages
LOG_FILE="failed_packages.log"
> "$LOG_FILE"  # Clear previous log

# List of packages
PACKAGES=(
    git curl mercurial make binutils gcc bison wmctrl util-linux zlib
    shellcheck shfmt awesome rofi picom xclip flameshot xdotool fish
    eza btop atuin jless bat fzf zoxide neovim ripgrep unzip zellij go
    lazygit lxappearance xorg-xinit xorg-server kitty openssh xorg-setxkbmap
    noto-fonts-emoji nerd-fonts ttf-liberation ttf-dejavu alsa-utils
    playerctl pipewire pipewire-alsa pipewire-pulse pipewire-jack
    nvidia nvidia-utils nvidia-settings xorg-xrandr rbenv ruby-build libyaml
)

# Packages that are likely AUR-only
AUR_PACKAGES=("atuin" "lazygit" "zellij" "nerd-fonts" "eza" "jless")

# Function to install packages via pacman
install_pacman_package() {
    local pkg="$1"
    if ! sudo pacman -S --noconfirm --needed "$pkg"; then
        echo "$pkg" >> "$LOG_FILE"
        echo "[FAILED] $pkg"
    else
        echo "[INSTALLED] $pkg"
    fi
}

# Function to install packages via yay (AUR)
install_aur_package() {
    local pkg="$1"
    if ! yay -S --noconfirm --needed "$pkg"; then
        echo "$pkg" >> "$LOG_FILE"
        echo "[FAILED] $pkg"
    else
        echo "[INSTALLED] $pkg"
    fi
}

# Main installation loop
for pkg in "${PACKAGES[@]}"; do
    if [[ " ${AUR_PACKAGES[@]} " =~ " ${pkg} " ]]; then
        install_aur_package "$pkg"
    else
        install_pacman_package "$pkg"
    fi
done

echo "Installation complete!"
if [[ -s "$LOG_FILE" ]]; then
    echo "Some packages failed to install. Check $LOG_FILE for details."
else
    echo "All packages installed successfully!"
fi
