# Dotfiles

Personal configuration files for macOS and Linux, including zsh, tmux, Neovim, Kitty, and Yazi.
Setup is automated with a single install script.

---

## Contents

- **Zsh** with Oh My Zsh, Powerlevel10k, and plugins:
  - `zsh-vi-mode`
  - `git`
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
- **Tmux** configuration
- **Neovim** configuration (native tree-sitter, no nvim-treesitter plugin)
- **Kitty** terminal configuration
- **Yazi** file manager configuration
- **Powerlevel10k** theme
- **Git** configuration template

---

## Requirements

- macOS or Linux
- `curl` and `unzip` installed
- `sudo` privileges for Linux package installation

---

## Installation

```bash
git clone git@github.com:Hisun0/dotfiles.git
cd ~/dotfiles
./bin/install.sh
```

If you get a permission error: `chmod +x bin/install.sh`

---

## Neovim — Tree-sitter parsers

Neovim is configured with native tree-sitter (`vim.treesitter.start`) instead of the `nvim-treesitter` plugin.
Parsers must be compiled manually and placed in `~/.local/share/nvim/parser/`.

**One-time setup:**

```bash
# Install tree-sitter CLI
npm install -g tree-sitter-cli   # or: cargo install tree-sitter-cli

mkdir -p ~/.local/share/nvim/parser
```

**Installing a parser (two commands per language):**

```bash
git clone https://github.com/tree-sitter/tree-sitter-<lang>
cd tree-sitter-<lang> && tree-sitter build --output ~/.local/share/nvim/parser/<lang>.so
```

**Parsers used in this config:**

| Language   | Repo                                                 |
|------------|------------------------------------------------------|
| JavaScript | tree-sitter/tree-sitter-javascript                   |
| TypeScript | tree-sitter/tree-sitter-typescript (subdir: `typescript/`) |
| TSX        | tree-sitter/tree-sitter-typescript (subdir: `tsx/`)  |
| Lua        | tree-sitter/tree-sitter-lua                          |
| CSS        | tree-sitter/tree-sitter-css                          |
| SQL        | DerekStride/tree-sitter-sql                          |
| JSON       | tree-sitter/tree-sitter-json                         |
| Bash       | tree-sitter/tree-sitter-bash                         |

> TypeScript and TSX share one repo — build from each subdirectory:
> ```bash
> git clone https://github.com/tree-sitter/tree-sitter-typescript
> cd tree-sitter-typescript/typescript && tree-sitter build --output ~/.local/share/nvim/parser/typescript.so
> cd ../tsx && tree-sitter build --output ~/.local/share/nvim/parser/tsx.so
> ```
