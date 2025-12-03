#!/usr/bin/env bash

set -e

echo "[+] Detecting OS..."
OS="$(uname -s)"

# 1. Install package managers & dependencies
if [[ "$OS" == "Darwin" ]]; then
  echo "[+] macOS detected"

  # Homebrew
  if ! command -v brew >/dev/null 2>&1; then
    echo "[+] Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    if [ -f /opt/homebrew/bin/brew ]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  brew install stow git tmux neovim yazi zsh
  brew install alacritty || echo "[+] alacritty already installed"

else
  echo "[+] Linux detected"

  if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y stow git tmux neovim zsh alacritty

  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y stow git tmux neovim zsh alacritty

  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu --noconfirm stow git tmux neovim zsh alacritty

  else
    echo "[!] Unsupported package manager"
    exit 1
  fi
fi

# 2. Install oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "[+] Installing oh-my-zsh..."
  KEEP_ZSHRC=yes RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 3. Install zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Vi mode
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]]; then
  echo "[+] Installing zsh-vi-mode..."
  git clone https://github.com/jeffreytse/zsh-vi-mode "$ZSH_CUSTOM/plugins/zsh-vi-mode"
fi

# Autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  echo "[+] Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Syntax highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  echo "[+] Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# powerlevel10k theme
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  echo "[+] Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# 4. Git configuration
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

# 5. Create symlinks
echo ""
echo "[+] Creating symlinks..."

mkdir -p "$HOME/.config"

stow -vt "$HOME" git
stow -vt "$HOME" zsh
stow -vt "$HOME/.config/nvim" nvim
stow -vt "$HOME" tmux
stow -vt "$HOME/.config/alacritty" alacritty
stow -vt "$HOME/.config/yazi" yazi

# 7. Fix default shell for macOS
if [[ "$OS" == "Darwin" ]]; then
  ZSH_PATH="$(which zsh)"
  if ! grep -Fxq "$ZSH_PATH" /etc/shells 2>/dev/null; then
    echo "[+] Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi
fi

# Change default shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "[+] Changing default shell to zsh..."
  chsh -s "$(which zsh)" || echo "[!] Could not set zsh as default shell"
fi

# 8. Optional: fix missing completions
ZSH_SITE_FUNCTIONS="$(brew --prefix)/share/zsh/site-functions"
if [[ -d "$ZSH_SITE_FUNCTIONS" && ! "$fpath" =~ "$ZSH_SITE_FUNCTIONS" ]]; then
  echo "[+] Adding site-functions to fpath..."
  fpath=($ZSH_SITE_FUNCTIONS $fpath)
fi

echo "[+] Installing JetBrains Mono Nerd Font..."

# 9. Install JetBrainsMonoNerdFont
if [[ "$OS" == "Darwin" ]]; then
  brew tap homebrew/cask-fonts
  brew install --cask font-jetbrains-mono-nerd-font || echo "[+] Font already installed"

else
  FONTS_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONTS_DIR"
  FONT_ZIP="$FONTS_DIR/JetBrainsMonoNerdFont.zip"

  if [[ ! -f "$FONTS_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]]; then
    curl -fLo "$FONT_ZIP" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
    unzip -o "$FONT_ZIP" -d "$FONTS_DIR"
    fc-cache -fv
    echo "[+] Font installed"
  else
    echo "[+] Font already exists"
  fi
fi

echo ""
echo "[+] Setup complete!"
