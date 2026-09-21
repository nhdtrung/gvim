# Neovim Config (GVim)

[English](README.md) | [Tiếng Việt](README.vi.md)

> Modern Neovim configuration extended from `nvim-kickstart`, tailored for full-stack development (PHP, JavaScript/TypeScript, Lua, XML, etc.), featuring an AI Assistant (CodeCompanion with Claude), LSP, Auto-formatting, and Fuzzy Finding.

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

## 🚀 Installation & Setup

### Step 1: Install Neovim (v0.11+)

#### Linux (Ubuntu / Debian / etc.)
Default APT repositories often package older versions (e.g., v0.9.x). Install the latest official prebuilt binary:

```bash
# Download and unpack official Neovim x86_64 release
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -C ~/.local -xzf nvim-linux-x86_64.tar.gz
ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
rm nvim-linux-x86_64.tar.gz

# Ensure ~/.local/bin is in your $PATH (add to ~/.bashrc or ~/.zshrc if not already present):
export PATH="$HOME/.local/bin:$PATH"
```

#### macOS (Homebrew)
```bash
brew install neovim
```

Verify your installed version:
```bash
nvim --version
# Should output NVIM v0.11.x or v0.12.x
```

---

### Step 2: Install System Dependencies

#### Ubuntu / Debian:
```bash
# Install build tools, ripgrep, python, nodejs, unzip
sudo apt update
sudo apt install -y git curl gcc make ripgrep unzip python3 python3-pip nodejs npm

# Install fd (named 'fd-find' on Ubuntu/Debian)
sudo apt install -y fd-find
mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd
```

#### macOS:
```bash
brew install ripgrep fd nodejs
```

---

### Step 3: Backup Existing Configuration & Clone

```bash
# Backup existing Neovim configs (if any)
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null
mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null

# Clone repository into ~/.config/nvim
git clone https://github.com/nhdtrung/gvim.git ~/.config/nvim
```

---

### Step 4: Launch Neovim & Sync Plugins

Launch Neovim:
```bash
nvim
```
- `lazy.nvim` will automatically bootstrap and install all configured plugins.
- Once finished, press `q` to close the Lazy status window.

---

### Step 5: Install LSP Servers & Formatters via Mason

This setup pre-configures the following Language Servers and Formatters:
- **LSP Servers**: `lua_ls`, `ts_ls`, `intelephense`, `lemminx`
- **Formatters**: `stylua`, `prettierd`, `php-cs-fixer`

To install them all at once, open Neovim and run:
```vim
:MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd
```
*(Or run `:Mason` to open the interactive UI).*

---

### Step 6: Configure AI Assistant (CodeCompanion - Claude)

The configuration uses [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim) powered by Anthropic's Claude.

1. Obtain an API key from the [Anthropic Console](https://console.anthropic.com/).
2. Add the environment variable to your shell profile (`~/.bashrc` or `~/.zshrc`):
   ```bash
   export ANTHROPIC_API_KEY="sk-ant-api..."
   ```
3. Reload your shell configuration (`source ~/.bashrc`) or restart your terminal.

---

### Step 7: Run Healthcheck

Verify that all dependencies, LSP servers, and plugins are properly configured:
```vim
:checkhealth
```

---

## 📂 Directory Structure

```
~/.config/nvim/
├── init.lua          -- Main entry point (loads options, keymaps, plugins)
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
