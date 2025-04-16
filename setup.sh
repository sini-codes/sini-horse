#!/bin/bash

# Install Nix non-interactively in multi-user mode if not already installed
echo "Checking for Nix installation..."
if ! command -v nix >/dev/null 2>&1; then
    echo "Installing Nix non-interactively..."
    curl -L https://nixos.org/nix/install | sh -s -- --daemon --no-channel-add --yes
else
    echo "Nix already installed, skipping installation."
fi

# Source Nix environment
echo "Sourcing Nix environment..."
if [ -e /etc/profile.d/nix.sh ]; then
    . /etc/profile.d/nix.sh
else
    echo "Error: Nix environment file not found. Installation may have failed."
    exit 1
fi

# Check for Flake in the same directory and install or update packages
echo "Checking for Flake and installing/updating packages for default sini-horse machine..."
SCRIPT_DIR="$(dirname "$0")"
if [ -f "$SCRIPT_DIR/flake.nix" ]; then
    # Remove existing sini-horse profile entry to force update, if it exists
    nix --extra-experimental-features "nix-command flakes" profile remove sini-horse 2>/dev/null || true
    nix --extra-experimental-features "nix-command flakes" profile install "$SCRIPT_DIR"#default
else
    echo "Error: flake.nix not found in $SCRIPT_DIR."
    exit 1
fi

echo "Ensure fisher installed..."
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'

echo "Ensure fish plugins installed..."
fish -c 'fisher install "woheedev/onedark-fish"' 
fish -c 'fisher install "acomagu/fish-async-prompt@a89bf4216b65170e4c3d403e7cbf24ce34b134e6"'
fish -c 'fisher install "jethrokuan/z"' 
fish -c 'fisher install "patrickf1/fzf.fish"' 

# Copy dotfiles to /root/, forcing replacement of existing files
echo "Copying dotfiles to /root/ with forced replacement..."
if [ -d "$SCRIPT_DIR/dotfiles" ]; then
    cp -rf "$SCRIPT_DIR/dotfiles/." /root/
else
    echo "Warning: dotfiles directory not found in $SCRIPT_DIR."
fi

# Set Fish theme to "One Dark" non-interactively
echo "Setting Fish theme to One Dark..."
echo -e "y\n" | fish -c 'fish_config theme save "One Dark"' >/dev/null 2>&1
