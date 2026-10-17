# Changelog

User-visible changes to this configuration, newest first. Details live in the git history.

## 2026-10-18

### Added
- Claude Code CLI integration through `coder/claudecode.nvim`: a terminal split, sending the buffer or a visual selection as context, and accepting or denying diffs. Keymaps use the `<leader>C` prefix.
- `<C-h>` and `<C-l>` move focus out of a terminal window (for example the Claude Code terminal).

## 2026-10-16

### Added
- In-buffer Markdown rendering with `render-markdown.nvim` (`<leader>mp` to toggle).
- `tree-sitter-cli` installed through Mason by the installers.

### Changed
- `nvim-treesitter` moved to the `main` branch, since `master` is archived and crashes on Neovim 0.12.

### Fixed
- The macOS installer now surfaces Homebrew errors and checks for the Xcode Command Line Tools.

## 2026-09-21

### Added
- Multi-OS automated installer (`install.sh`, `install.ps1`) and bilingual setup guides.
