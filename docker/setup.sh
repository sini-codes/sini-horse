#!/bin/bash

# Check if Nix is installed
echo "Checking for Nix installation..."
if ! command -v nix >/dev/null 2>&1; then
    echo "Error: Nix is not installed. Please install Nix first."
    exit 1
fi

# Source Nix environment
echo "Sourcing Nix environment..."
if [ -e /etc/profile.d/nix.sh ]; then
    . /etc/profile.d/nix.sh
else
    echo "Error: Nix environment file not found (/etc/profile.d/nix.sh)."
    exit 1
fi

# Check for Flake in the same directory and install or update packages
echo "Checking for Flake and installing/updating Docker packages..."
SCRIPT_DIR="$(dirname "$0")"
if [ -f "$SCRIPT_DIR/flake.nix" ]; then
    # Remove existing docker-env profile entry to ensure clean update
    nix --extra-experimental-features "nix-command flakes" profile remove docker-env 2>/dev/null || true
    nix --extra-experimental-features "nix-command flakes" profile install "$SCRIPT_DIR"#default
else
    echo "Error: docker-flake.nix not found in $SCRIPT_DIR."
    exit 1
fi

# Ensure Docker service is enabled (idempotent)
echo "Ensuring Docker service is accessible..."
if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl enable docker 2>/dev/null || echo "Warning: Could not enable Docker service (may require root or not be applicable)."
    sudo systemctl start docker 2>/dev/null || echo "Warning: Could not start Docker service."
else
    echo "Warning: systemctl not found, skipping Docker service enablement."
fi

# Add user to docker group (idempotent)
if [ -n "$USER" ]; then
    echo "Adding $USER to docker group for non-root Docker usage..."
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker "$USER" 2>/dev/null || echo "Warning: Could not add $USER to docker group."
fi

echo "Docker and Docker Compose installation complete."
