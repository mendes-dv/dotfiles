#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Setting up development environment"

# Detect OS
if [[ "$(uname)" == "Darwin" ]]; then
    OS="macos"
    echo "==> Detected macOS"

    # Install Homebrew if missing
    if ! command -v brew &>/dev/null; then
        echo "==> Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Install Ansible
    if ! command -v ansible &>/dev/null; then
        echo "==> Installing Ansible..."
        brew install ansible
    fi

elif [[ -f /etc/debian_version ]]; then
    OS="debian"
    echo "==> Detected Debian/Ubuntu"
    sudo apt update
    sudo apt install -y ansible git

elif [[ -f /etc/arch-release ]]; then
    OS="arch"
    echo "==> Detected Arch Linux"
    sudo pacman -Sy --noconfirm ansible git

elif [[ -f /etc/fedora-release ]]; then
    OS="fedora"
    echo "==> Detected Fedora"
    sudo dnf install -y ansible git

else
    echo "Unsupported OS"
    exit 1
fi

# Run Ansible playbook
echo "==> Running Ansible playbook..."
cd "$DOTFILES_DIR/ansible"
ansible-playbook playbook.yml --ask-become-pass

echo "==> Done! Restart your shell to apply changes."
