# Neovim Config

## Cấu trúc thư mục

```
~/.config/nvim/
├── init.lua          -- File khởi động chính, chỉ gọi các module khác
└── lua/
    └── user/
        ├── core/
        │   ├── options.lua -- Các tùy chỉnh `vim.opt` cơ bản
        │   └── keymaps.lua -- Các phím tắt toàn cục
        └── plugins/
            ├── config.lua      -- File setup chính của lazy.nvim
            └── list/           -- Thư mục chứa các file cấu hình plugin
                ├── 1_ui.lua    -- Các plugin về giao diện (theme, cây thư mục)
                ├── 2_core.lua  -- Các plugin chức năng cốt lõi (LSP, format, tìm kiếm)
                └── 3_utils.lua -- Các plugin tiện ích khác (git, treesitter)
```

---

## Plugins đã cài

### UI (`1_ui.lua`)

| Plugin | Mô tả |
|--------|-------|
| `folke/tokyonight.nvim` | Color scheme — dùng variant `tokyonight-night` |
| `nvim-tree/nvim-tree.lua` | Cây thư mục bên trái, tự highlight file đang mở, hiện `node_modules` |
| `akinsho/bufferline.nvim` | Thanh tab buffer phía trên, hỗ trợ đóng/chuyển buffer |
| `folke/which-key.nvim` | Popup gợi ý phím tắt khi nhấn leader |

### Core (`2_core.lua`)

| Plugin | Mô tả |
|--------|-------|
| `stevearc/conform.nvim` | Format on save — stylua (Lua), php_cs_fixer (PHP), prettierd (JS/TS/XML) |
| `nvim-telescope/telescope.nvim` | Fuzzy finder — tìm file, grep, buffer |
| `neovim/nvim-lspconfig` + Mason | LSP tự động cài qua Mason: `lua_ls`, `intelephense`, `ts_ls`, `lemminx` |
| `hrsh7th/nvim-cmp` | Autocomplete với snippet (LuaSnip) và LSP source |
| `olimorris/codecompanion.nvim` | AI assistant dùng Claude (Anthropic) — chat buffer & inline generation |

### Utils (`3_utils.lua`)

| Plugin | Mô tả |
|--------|-------|
| `lewis6991/gitsigns.nvim` | Git diff signs trong gutter (thêm/sửa/xóa dòng) |
| `echasnovski/mini.nvim` | `mini.surround` (wrap/unwrap text objects) + `mini.ai` (mở rộng text objects) |
| `nvim-treesitter/nvim-treesitter` | Syntax highlight và indent dựa trên AST cho Lua, PHP, JS, HTML, XML... |

---

## Phím tắt

### File Explorer (nvim-tree)

| Phím | Tác dụng |
|------|----------|
| `<leader>e` | Mở tree & reveal file hiện tại (nếu đang mở thì đóng) |
| `<leader>E` | Luôn reveal & focus file hiện tại trong tree |
| `<C-\>` | Reveal file hiện tại trong tree |

### Buffer

| Phím | Tác dụng |
|------|----------|
| `<Tab>` | Sang buffer kế tiếp |
| `<S-Tab>` | Về buffer trước |
| `,x` | Sang buffer kế tiếp (alternative) |
| `,z` | Về buffer trước (alternative) |
| `<leader>c` | Đóng buffer hiện tại |

### Telescope (Fuzzy Finder)

| Phím | Tác dụng |
|------|----------|
| `<leader>sf` | Tìm file |
| `<leader>sg` | Live grep toàn project |
| `<leader><leader>` | Tìm trong các buffer đang mở |
| `<leader>sn` | Live grep trong `node_modules` |

### LSP (khi attach vào buffer)

| Phím | Tác dụng |
|------|----------|
| `gd` | Goto definition |
| `gr` | Goto references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |

### Format

| Phím | Tác dụng |
|------|----------|
| `<leader>f` | Format file hoặc vùng chọn (normal/visual) |

### Window

| Phím | Tác dụng |
|------|----------|
| `<C-h/j/k/l>` | Di chuyển focus giữa các split |
| `vv` | Split dọc |
| `ss` | Split ngang |

### CodeCompanion (AI Assistant)

| Phím | Tác dụng |
|------|----------|
| `<C-a>` | Mở action palette |
| `<leader>a` | Toggle chat buffer |
| `ga` (visual) | Thêm vùng chọn vào chat |
| `:cc` | Shortcut cho `:CodeCompanion` |
| `<C-s>` (insert, trong chat) | Gửi message |
| `<CR>` (normal, trong chat) | Gửi message |

### Debugging (nvim-dap)

| Phím | Tác dụng |
|------|----------|
| `<F3>` | Toggle breakpoint |
| `<F5>` | Continue |
| `<F6>` | Terminate |
| `<F7>` | Step into |
| `<F8>` | Step over |
| `<F9>` | Step out |
| `<F10>` | Run to cursor |
| `<leader>dc` | Toggle DAP UI |
| `<leader>di` | Hover (xem giá trị biến) |
| `<leader>dr` | Mở REPL |

### Misc

| Phím | Tác dụng |
|------|----------|
| `jk` (insert) | Thoát về normal mode |
| `<Esc>` / `//` | Xóa highlight tìm kiếm |
