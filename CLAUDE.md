# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration using lazy.nvim as the plugin manager. The configuration is modular, with core settings separated from plugin configurations. The codebase uses Vietnamese comments throughout.

## Architecture

### Entry Point and Module Loading

- `init.lua` - Main entry point that loads core modules and plugin configuration
- Module loading order:
  1. `user.core.options` - Global Vim options
  2. `user.core.keymaps` - Global keybindings
  3. `user.plugins.config` - Plugin manager setup

### Directory Structure

```
lua/user/
├── core/
│   ├── options.lua  -- Global vim.opt settings
│   └── keymaps.lua  -- Global keybindings and plugin-specific keymaps
└── plugins/
    ├── config.lua   -- lazy.nvim setup
    └── list/        -- Plugin configurations (auto-loaded by lazy.nvim)
        ├── 1_ui.lua    -- UI plugins (theme, file tree, bufferline, which-key)
        ├── 2_core.lua  -- Core functionality (LSP, formatter, telescope, autocomplete, copilot)
        └── 3_utils.lua -- Utilities (git, treesitter, mini.nvim)
```

### Plugin Management

- Uses lazy.nvim with automatic loading from `lua/user/plugins/list/` directory
- Plugin files return Lua tables with plugin specifications
- Plugins are organized by category (UI, core functionality, utilities)
- lazy.nvim automatically installs on first run if not present

## Key Configuration Details

### Leader Key
- Leader: `<Space>`
- Local leader: `<Space>`

### File-Specific Settings
- **PHP files**: Use 4 spaces for indentation (tabstop=4, shiftwidth=4)
- **All other files**: Use 2 spaces for indentation (default in options.lua:22-23)

### LSP Servers
Configured in `lua/user/plugins/list/2_core.lua:60`:
- `lua_ls` - Lua
- `intelephense` - PHP
- `ts_ls` - TypeScript/JavaScript
- `lemminx` - XML

All LSP servers are installed via Mason with `automatic_installation = true`.

### Formatters
Configured in `lua/user/plugins/list/2_core.lua:13-19`:
- Lua: stylua
- PHP: php_cs_fixer
- JavaScript/TypeScript: prettierd
- XML: prettierd

Format on save is enabled with 500ms timeout and LSP fallback.

### CodeCompanion.nvim Integration
- AI assistant powered by Anthropic's Claude
- API key configured via `ANTHROPIC_API_KEY` environment variable
- Supports chat buffers and inline code generation
- Used for both chat and inline strategies

### Important Keybindings

CodeCompanion (AI Assistant):
- `<C-a>`: Open action palette
- `<LocalLeader>a` (Space+a): Toggle chat buffer
- `ga` (visual mode): Add selection to chat
- `:cc`: Shortcut for `:CodeCompanion` command
- `<C-s>` (in chat, insert mode): Submit message
- `<CR>` (in chat, normal mode): Submit message

File Explorer (NvimTree):
- `<leader>e` or `<C-\>`: Find current file in tree
- `<leader>E`: Toggle tree

Telescope (Fuzzy Finder):
- `<leader>sf`: Search files
- `<leader>sg`: Live grep
- `<leader><leader>`: Find buffers

LSP (when attached):
- `gd`: Goto definition
- `gr`: Goto references
- `K`: Hover documentation
- `<leader>ca`: Code action

Format:
- `<leader>f`: Format file or range (normal/visual mode)

Buffer Navigation:
- `<Tab>`: Next buffer
- `<S-Tab>`: Previous buffer
- `,z`: Previous buffer (alternative)
- `,x`: Next buffer (alternative)
- `<leader>c`: Close current buffer

Debugging (nvim-dap):
- `<F3>`: Toggle breakpoint
- `<F5>`: Continue
- `<F6>`: Terminate
- `<F7>`: Step into
- `<F8>`: Step over
- `<F9>`: Step out
- `<F10>`: Run to cursor

## Making Changes

### Adding New Plugins
1. Add plugin specification to appropriate file in `lua/user/plugins/list/`:
   - UI-related → `1_ui.lua`
   - Core functionality (LSP, formatting, searching) → `2_core.lua`
   - Utilities → `3_utils.lua`
2. Follow lazy.nvim specification format
3. Include configuration in `config` function if needed
4. Restart Neovim - lazy.nvim will auto-install

### Adding New LSP Server
1. Add server name to `servers` table in `lua/user/plugins/list/2_core.lua:60`
2. Mason will automatically install it on next LSP attach
3. If server needs special configuration, set it up before the loop at line 61

### Adding New Formatter
1. Add filetype and formatter(s) to `formatters_by_ft` in `lua/user/plugins/list/2_core.lua:13-19`
2. Ensure formatter is installed (via Mason or system package manager)

### Adding Global Keybindings
Add to `lua/user/core/keymaps.lua` using `vim.keymap.set()`

### Adding Plugin-Specific Keybindings
Add within the plugin's `config` function in the appropriate list file

### Configuring CodeCompanion API Key
1. Set the `ANTHROPIC_API_KEY` environment variable in your shell profile
2. Restart Neovim to load the environment variable
3. Verify with `:checkhealth codecompanion`
4. Alternatively, modify the `api_key` value in `lua/user/plugins/list/2_core.lua:104` to use a command or function

### Modifying Vim Options
Edit `lua/user/plugins/list/options.lua` using `vim.opt` assignments
