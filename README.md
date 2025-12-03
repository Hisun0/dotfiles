# Dotfiles (work in progress, some features can not work)

Personal configuration files for macOS and Linux, including zsh, tmux, Neovim, Alacritty, and more.
Setup is automated with a single install script.

---

## Contents

- **Zsh** with Oh My Zsh, Powerlevel10k, and plugins:
  - `zsh-vi-mode`
  - `git`
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
- **Tmux** configuration
- **Neovim** configuration
- **Alacritty** configuration
- **Yazi** configuration
- **Powerlevel10k** theme
- **Git** configuration template

---

## Requirements

- macOS or Linux
- `curl` and `unzip` installed
- `sudo` privileges for Linux package installation

---

## Installation

Run the setup script to automatically install dependencies, create symlinks, configure Git, and install fonts:

If you have error when trying to execute `install.sh` script, you need to do `chmod +x bin/install.sh`

```bash
git clone git@github.com:Hisun0/dotfiles.git
cd ~/dotfiles
./bin/install.sh
```
