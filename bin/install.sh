#!/usr/bin/env bash

set -e

echo "[+] Detecting OS..."
OS="$(uname -s)"

# Install dependencies
if [[ "$OS" == "Darwin" ]]; then
  echo "[+] macOS detected"

  if ! command -v brew >/dev/null; then
    echo "[+] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install stow
  brew install git
  brew install tmux
  brew install neovim
  brew install yazi
  brew install alacritty || echo "[+] alacritty already installed"
  brew install zsh

else
  echo "[+] Linux detected"

  if command -v apt >/dev/null; then
    sudo apt update
    sudo apt install -y stow git tmux neovim zsh alacritty

  elif command -v dnf >/dev/null; then
    sudo dnf install -y stow git tmux neovim zsh alacritty

  elif command -v pacman >/dev/null; then
    sudo pacman -Syu --noconfirm stow git tmux neovim zsh alacritty

  else
    echo "[!] Unsupported package manager"
    exit 1
  fi
fi

# Git configuration
echo ""
echo "[+] Git configuration"

read -p "Enter Git author name: " GIT_NAME
read -p "Enter Git author email: " GIT_EMAIL

if [[ -f git/.gitconfig.template ]]; then
  sed \
    -e "s/{{GIT_NAME}}/$GIT_NAME/g" \
    -e "s/{{GIT_EMAIL}}/$GIT_EMAIL/g" \
    git/.gitconfig.template > git/.gitconfig

  echo "[+] git/.gitconfig generated"
else
  echo "[!] git/.gitconfig.template not found"
  exit 1
fi

# Symlinks via stow
echo ""
echo "[+] Creating symlinks..."

stow -vt "$HOME" git
stow -vt "$HOME" zsh
stow -vt "$HOME" nvim
stow -vt "$HOME" tmux
stow -vt "$HOME" alacritty
stow -vt "$HOME" yazi

echo ""
echo "[+] Setup complete!"
