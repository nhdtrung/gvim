# Neovim Config (GVim)

[English](README.md) | [Tiếng Việt](README.vi.md)

> Modern Neovim configuration extended from `nvim-kickstart`, tailored for full-stack development (PHP, JavaScript/TypeScript, Lua, XML, etc.), featuring an AI Assistant (CodeCompanion with Claude), LSP, Auto-formatting, and Fuzzy Finding.

---

## ⚡ Quick 1-Command Automated Install

Choose the command matching your operating system to automatically install Neovim, dependencies, clone the config, and bootstrap plugins:

### Linux (Ubuntu 22.04 / 24.04 / Debian) & macOS (Apple Silicon M1/M2/M3/M4 & Intel)
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nhdtrung/gvim/main/install.sh)"
```

### Windows 11 (PowerShell)
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://raw.githubusercontent.com/nhdtrung/gvim/main/install.ps1 | iex"
```

---

## 📋 Prerequisites

- **Neovim >= 0.11.0** (Recommended **v0.12+** as this config leverages modern `vim.lsp.config` and `vim.lsp.enable` APIs).
- **Git** (for plugin management and repo cloning).
- **C/C++ Compiler & Make**: `gcc`, `make` (for compiling Treesitter parsers and `telescope-fzf-native`).
- **Search Utilities**:
  - `ripgrep` (`rg`)
  - `fd` (or `fdfind`)
- **Runtimes**:
  - `Node.js` (>= 20) & `npm` (required by Mason for TypeScript LSP, Prettierd, etc.)
  - `Python 3` & `pip`
- **Unzip** (for extracting language server archives like LemMinX)
- *(Recommended)* **Nerd Font** (for file icons in `nvim-tree`, `bufferline`, etc.)

---

## 💻 Manual Setup Guides by Platform

If you prefer to run commands manually instead of using the automated script, follow the guide for your system below:

### 🍏 macOS (M1 / Apple Silicon & Intel)

1. **Install tools and Neovim via Homebrew**:
   ```bash
   brew install neovim ripgrep fd nodejs git
   ```

2. **Backup old configuration (if any)**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
   mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
   ```

3. **Clone the repository**:
   ```bash
   git clone https://github.com/nhdtrung/gvim.git ~/.config/nvim
   ```

4. **Initialize plugins & LSP tools**:
   ```bash
   nvim --headless "+Lazy! sync" +qa
   nvim --headless -c "MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd" -c "sleep 5" -c "qa"
   ```

---

### 🐧 Ubuntu 22.04 LTS (and newer Debian/Ubuntu)

> [!NOTE]
> Ubuntu 22.04's default APT repository provides Neovim v0.6.8, which is too old. We install the official prebuilt binary (v0.12+) to `~/.local/bin`.

1. **Install system dependencies**:
   ```bash
   sudo apt update
   sudo apt install -y git curl gcc make ripgrep fd-find unzip python3 python3-pip nodejs npm
   
   # Setup fd symlink (Ubuntu packages it as fdfind)
   mkdir -p ~/.local/bin
   ln -sf $(which fdfind) ~/.local/bin/fd
   ```

2. **Install latest official Neovim binary (x86_64)**:
   ```bash
   curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
   tar -C ~/.local -xzf nvim-linux-x86_64.tar.gz
   ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
   rm nvim-linux-x86_64.tar.gz

   # Ensure ~/.local/bin is in PATH:
   export PATH="$HOME/.local/bin:$PATH"
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   ```
   *(For ARM64 Linux, use `nvim-linux-arm64.tar.gz` instead).*

3. **Clone configuration**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
   git clone https://github.com/nhdtrung/gvim.git ~/.config/nvim
   ```

4. **Sync plugins & Mason tools**:
   ```bash
   nvim --headless "+Lazy! sync" +qa
   nvim --headless -c "MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd" -c "sleep 5" -c "qa"
   ```

---

### 🪟 Windows 11 (PowerShell)

1. **Install packages using `winget`**:
   ```powershell
   winget install --id Neovim.Neovim -e
   winget install --id BurntSushi.ripgrep.MSVC -e
   winget install --id sharkdp.fd -e
   winget install --id OpenJS.NodeJS.LTS -e
   winget install --id Git.Git -e
   ```

2. **Backup old config (if any) & clone**:
   ```powershell
   if (Test-Path "$env:LOCALAPPDATA\nvim") {
       Move-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.bak"
   }
   git clone https://github.com/nhdtrung/gvim.git "$env:LOCALAPPDATA\nvim"
   ```

3. **Sync plugins & Mason tools**:
   ```powershell
   nvim --headless "+Lazy! sync" +qa
   nvim --headless -c "MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd" -c "sleep 5" -c "qa"
   ```

---

## 🤖 AI Assistant Configuration (CodeCompanion - Claude)

The configuration uses [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim) with Claude (Anthropic).

1. Get an API key from the [Anthropic Console](https://console.anthropic.com/).
2. Add your key to your environment:
   - **Linux/macOS (`~/.bashrc` or `~/.zshrc`)**:
     ```bash
     export ANTHROPIC_API_KEY="sk-ant-api..."
     ```
   - **Windows 11 (PowerShell)**:
     ```powershell
     [System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-api...", "User")
     ```

---

## 📂 Directory Structure

```
~/.config/nvim/ (or %LOCALAPPDATA%\nvim on Windows)
├── init.lua          -- Main entry point (loads options, keymaps, plugins)
├── install.sh        -- Automated setup script (Linux & macOS)
├── install.ps1       -- Automated setup script (Windows 11)
├── CLAUDE.md         -- Project architecture & guidance for AI assistants
└── lua/
    └── user/
        ├── core/
        │   ├── options.lua -- Core `vim.opt` settings
        │   └── keymaps.lua -- Global keymaps
        └── plugins/
            ├── config.lua      -- lazy.nvim bootstrap & configuration
            └── list/           -- Plugin specifications (auto-loaded)
                ├── 1_ui.lua    -- UI plugins (theme, file tree, bufferline, which-key)
                ├── 2_core.lua  -- Core plugins (LSP, formatters, telescope, autocomplete, AI)
                └── 3_utils.lua -- Utilities (git signs, treesitter, text-objects)
```

---

## 🔌 Installed Plugins

### UI (`1_ui.lua`)

| Plugin | Description |
|--------|-------------|
| `folke/tokyonight.nvim` | Theme / Color scheme — uses `tokyonight-night` variant |
| `nvim-tree/nvim-tree.lua` | File explorer with current file reveal & `node_modules` visibility |
| `akinsho/bufferline.nvim` | Buffer tabs header with navigation and close support |
| `folke/which-key.nvim` | Interactive keybinding cheat-sheet popup on `<leader>` |

### Core (`2_core.lua`)

| Plugin | Description |
|--------|-------------|
| `stevearc/conform.nvim` | Format on save — stylua (Lua), php_cs_fixer (PHP), prettierd (JS/TS/XML) |
| `nvim-telescope/telescope.nvim` | Fuzzy finder — search files, live grep, buffers |
| `neovim/nvim-lspconfig` + Mason | LSP management & config: `lua_ls`, `intelephense`, `ts_ls`, `lemminx` |
| `hrsh7th/nvim-cmp` | Autocompletion engine with LuaSnip snippets & LSP source |
| `olimorris/codecompanion.nvim` | AI assistant with Claude (Anthropic) — chat buffer & inline generation |

### Utilities (`3_utils.lua`)

| Plugin | Description |
|--------|-------------|
| `lewis6991/gitsigns.nvim` | Git status signs in signcolumn (add, change, delete) |
| `echasnovski/mini.nvim` | `mini.surround` (surround operators) + `mini.ai` (extended text-objects) |
| `nvim-treesitter/nvim-treesitter` | Fast syntax highlighting & AST-based indentation |

---

## ⌨️ Keybindings

> **Leader Key**: `<Space>` | **Local Leader**: `<Space>`

### File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Open file tree & reveal current file (toggle close if open) |
| `<leader>E` | Always reveal & focus current file in tree |
| `<C-\>` | Reveal current file in tree |

### Buffers

| Key | Action |
|-----|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `,x` | Next buffer (alternative) |
| `,z` | Previous buffer (alternative) |
| `<leader>c` | Close current buffer |

### Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>sf` | Search files by name |
| `<leader>sg` | Live grep project-wide |
| `<leader><leader>` | Search open buffers |
| `<leader>sn` | Live grep inside `node_modules` |

### LSP (when attached to buffer)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |

### Formatting

| Key | Action |
|-----|--------|
| `<leader>f` | Format file or visual selection |

### Windows & Splits

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate focus between splits |
| `vv` | Vertical split |
| `ss` | Horizontal split |

### CodeCompanion (AI Assistant)

| Key | Action |
|-----|--------|
| `<C-a>` | Open CodeCompanion action palette |
| `<leader>a` | Toggle chat buffer |
| `ga` (visual) | Add visual selection to chat |
| `:cc` | Command shortcut for `:CodeCompanion` |
| `<C-s>` (insert, in chat) | Submit message |
| `<CR>` (normal, in chat) | Submit message |

### Debugging (nvim-dap)

| Key | Action |
|-----|--------|
| `<F3>` | Toggle breakpoint |
| `<F5>` | Continue |
| `<F6>` | Terminate |
| `<F7>` | Step into |
| `<F8>` | Step over |
| `<F9>` | Step out |
| `<F10>` | Run to cursor |
| `<leader>dc` | Toggle DAP UI |
| `<leader>di` | Hover (inspect variable value) |
| `<leader>dr` | Open REPL |

### Miscellaneous

| Key | Action |
|-----|--------|
| `jk` (insert mode) | Fast exit to normal mode |
| `<Esc>` / `//` | Clear search highlighting |
