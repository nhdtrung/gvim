# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim config (requires Neovim >= 0.11, uses the `vim.lsp.config` / `vim.lsp.enable` API) managed with lazy.nvim. There is no build, lint, or test suite. Code comments are in Vietnamese; keep that convention. `README.md` / `README.vi.md` document installation and the user-facing plugin and keymap lists; `install.sh` / `install.ps1` are the multi-OS installers.

## Commands

- Verify a change loads: `nvim --headless "+Lazy! install <plugin>" +qa`, then open a relevant file and check, e.g. `nvim --headless file.md -c 'lua print(package.loaded["<module>"] ~= nil)' -c 'qa!'`.
- Install exactly what `lazy-lock.json` records: `nvim --headless "+Lazy! restore" +qa`.
- Avoid `Lazy! sync` / `Lazy! update` unless the user wants upgrades: they rewrite `lazy-lock.json` (tracked in git) with newer commits.
- `:checkhealth`, `:ConformInfo`, `:LspInfo` for diagnosing tooling.

## Architecture

`init.lua` loads, in order: `user.core.options` (also sets `mapleader`/`maplocalleader` to Space, so it must stay first), `user.core.keymaps`, then `user.plugins.config`.

`user.plugins.config` bootstraps lazy.nvim and calls `require("lazy").setup("user.plugins.list")`. lazy.nvim merges every file in `lua/user/plugins/list/` (each returns a table of plugin specs). The numeric prefix is only a grouping convention: `1_ui.lua` (theme, nvim-tree, bufferline, which-key), `2_core.lua` (conform, telescope, LSP, CodeCompanion, nvim-cmp), `3_utils.lua` (gitsigns, mini.nvim, treesitter, render-markdown). Put a new plugin in the file matching its category.

### Things that span files

- **Keymaps are split between two places.** Global ones are in `core/keymaps.lua`; plugin ones are inside each spec's `config` or `keys`. Several are defined twice (`<leader>e`, `<leader>E`, `<leader>f`). Because nvim-tree and conform are loaded after `core/keymaps.lua` runs, the plugin-side definition wins; edit that one (for `<leader>e`, the smart toggle in `1_ui.lua`).
- **`core/keymaps.lua` has nvim-dap mappings (`<F3>`–`<F10>`, `<leader>d*`) but no DAP plugin is installed**, and `debugHelper` does not exist in this repo. Those keys error until a DAP spec is added.
- **LSP flow** (`2_core.lua`): servers are listed in `vim.lsp.enable({...})`; Mason installs them via `mason-lspconfig` (`automatic_installation` excludes `stylua`, which is a formatter, not an LSP). Shared capabilities come from `cmp_nvim_lsp` through `vim.lsp.config("*", ...)`. Buffer-local LSP keymaps (`gd`, `gr`, `K`, `<leader>ca`) are set in the `LspAttach` autocmd.
- **Formatting** goes through conform (`formatters_by_ft` in `2_core.lua`) with format-on-save (500ms) and LSP fallback. The external formatter binaries (`stylua`, `php_cs_fixer`, `prettierd`) must be installed separately.
- **Indentation**: 2 spaces globally (`core/options.lua`); PHP is overridden to 4 by a `FileType` autocmd in the LSP config.
- **CodeCompanion** uses the Anthropic adapter and reads the key from the `ANTHROPIC_API_KEY` environment variable. `render-markdown.nvim` is also enabled for the `codecompanion` filetype so chat buffers render.
- **Claude Code CLI** runs inside Neovim through `coder/claudecode.nvim` (spec in `2_core.lua`, native terminal provider, no `snacks.nvim`). It needs the `claude` binary on `PATH`; diagnose with `:checkhealth claudecode`. Its keymaps use the `<leader>C` prefix because `<leader>a` is CodeCompanion's exact mapping and `timeoutlen` is 300, so never add `<leader>a*` mappings. `<C-h>`/`<C-l>` are also mapped in terminal mode (`core/keymaps.lua`) so focus can leave the Claude terminal; `<C-j>`/`<C-k>` are deliberately left to Claude's input line.
- **Treesitter** uses nvim-treesitter's `main` branch (`master` is archived and crashes on Neovim 0.12 in markdown code-fence injections). There is no `nvim-treesitter.configs`: `3_utils.lua` installs parsers with `require("nvim-treesitter").install` and starts highlight/indent per buffer in a `FileType` autocmd. Building parsers needs the `tree-sitter` CLI, installed here via `:MasonInstall tree-sitter-cli`.

## Making Changes

- New LSP server: add its name to `vim.lsp.enable` in `2_core.lua`; add special settings with `vim.lsp.config("<name>", {...})` before that call.
- New formatter: add the filetype to `formatters_by_ft` in `2_core.lua` and install the binary.
- New plugin: add a spec to the matching list file, restart Neovim, and commit the resulting `lazy-lock.json` change.
- Update `README.md` and `README.vi.md` together when the plugin or keymap lists change. Keep them evergreen: no "updated on <date>" notes; record user-visible changes in `CHANGELOG.md` instead.
