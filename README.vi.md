# Neovim Config (GVim)

[English](README.md) | [Tiếng Việt](README.vi.md)

> Cấu hình Neovim hiện đại, mở rộng từ `nvim-kickstart`, tối ưu cho lập trình (PHP, JavaScript/TypeScript, Lua, XML, v.v.), tích hợp AI Assistant (CodeCompanion với Claude), LSP, Auto-format và Fuzzy Finder.

---

## 📋 Yêu cầu hệ thống (Prerequisites)

- **Neovim >= 0.11.0** (Khuyến nghị **v0.12+** do cấu hình sử dụng API `vim.lsp.config` và `vim.lsp.enable` mới).
- **Git** (quản lý plugin và clone repo).
- **C/C++ Compiler & Make**: `gcc`, `make` (để build parser Treesitter và `telescope-fzf-native`).
- **Công cụ tìm kiếm**:
  - `ripgrep` (`rg`)
  - `fd` (hoặc `fd-find`)
- **Runtimes**:
  - `Node.js` (>= 20) & `npm` (dùng cho Mason cài TypeScript LSP, Prettierd, v.v.)
  - `Python 3` & `pip`
- **Unzip** (dùng cho Mason giải nén một số LSP server như LemMinX)
- *(Khuyến nghị)* **Nerd Font** (để hiển thị icon trong `nvim-tree`, `bufferline`, v.v.)

---

## 🚀 Hướng dẫn cài đặt (Installation & Setup)

### Bước 1: Cài đặt Neovim (v0.11+)

#### Trên Linux (Ubuntu / Debian / v.v.)
Gói `neovim` trong kho APT mặc định của Ubuntu thường là phiên bản cũ (v0.9.x). Bạn nên cài bản prebuilt mới nhất:

```bash
# Tải và giải nén bản phát hành Neovim binary x86_64
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -C ~/.local -xzf nvim-linux-x86_64.tar.gz
ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
rm nvim-linux-x86_64.tar.gz

# Đảm bảo ~/.local/bin nằm trong $PATH (thêm vào ~/.bashrc hoặc ~/.zshrc nếu chưa có):
export PATH="$HOME/.local/bin:$PATH"
```

#### Trên macOS (Homebrew)
```bash
brew install neovim
```

Kiểm tra phiên bản Neovim đã cài:
```bash
nvim --version
# Kết quả hiển thị NVIM v0.11.x hoặc v0.12.x là đạt yêu cầu
```

---

### Bước 2: Cài đặt các công cụ phụ trợ (Dependencies)

#### Trên Ubuntu / Debian:
```bash
# Cài đặt build tools, ripgrep, python, nodejs, unzip
sudo apt update
sudo apt install -y git curl gcc make ripgrep unzip python3 python3-pip nodejs npm

# Cài đặt fd (trên Ubuntu gói có tên là fd-find)
sudo apt install -y fd-find
mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd
```

#### Trên macOS:
```bash
brew install ripgrep fd nodejs
```

---

### Bước 3: Sao lưu config cũ (nếu có) và clone repo

```bash
# Sao lưu cấu hình Neovim cũ nếu đã có
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null
mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null

# Clone repository về thư mục cấu hình
git clone https://github.com/nhdtrung/gvim.git ~/.config/nvim
```

---

### Bước 4: Khởi động Neovim & Cài đặt Plugin

Khởi động Neovim:
```bash
nvim
```
- Trình quản lý `lazy.nvim` sẽ tự động tải về và thiết lập toàn bộ các plugin trong danh sách.
- Sau khi quá trình tải hoàn tất, bạn có thể bấm phím `q` để đóng cửa sổ thông báo của Lazy.

---

### Bước 5: Cài đặt LSP Servers & Formatters qua Mason

Cấu hình đã thiết lập sẵn các Language Server và Formatter chính:
- **LSP Servers**: `lua_ls`, `ts_ls`, `intelephense`, `lemminx`
- **Formatters**: `stylua`, `prettierd`, `php-cs-fixer`

Để cài đặt trước tất cả, mở Neovim và chạy lệnh:
```vim
:MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd
```
*(Hoặc nhập `:Mason` để mở giao diện quản lý đồ họa và cài thêm server bạn cần).*

---

### Bước 6: Cấu hình AI Assistant (CodeCompanion - Claude)

Cấu hình tích hợp [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim) sử dụng API của Claude (Anthropic).

1. Đăng ký và tạo API Key tại [Anthropic Console](https://console.anthropic.com/).
2. Thêm biến môi trường vào shell configuration (`~/.bashrc` hoặc `~/.zshrc`):
   ```bash
   export ANTHROPIC_API_KEY="sk-ant-api..."
   ```
3. Nạp lại cấu hình shell (`source ~/.bashrc`) hoặc khởi động lại terminal trước khi mở Neovim.

---

### Bước 7: Kiểm tra tình trạng hoạt động (Healthcheck)

Chạy lệnh kiểm tra trong Neovim để đảm bảo tất cả các thành phần hoạt động trơn tru:
```vim
:checkhealth
```

---

## 📂 Cấu trúc thư mục

```
~/.config/nvim/
├── init.lua          -- File khởi động chính, chỉ gọi các module khác
├── CLAUDE.md         -- Hướng dẫn kiến trúc và phát triển
└── lua/
    └── user/
        ├── core/
        │   ├── options.lua -- Các tùy chỉnh `vim.opt` cơ bản
        │   └── keymaps.lua -- Các phím tắt toàn cục
        └── plugins/
            ├── config.lua      -- File setup chính của lazy.nvim
            └── list/           -- Thư mục chứa các file cấu hình plugin
                ├── 1_ui.lua    -- Các plugin về giao diện (theme, cây thư mục)
                ├── 2_core.lua  -- Các plugin chức năng cốt lõi (LSP, format, tìm kiếm, AI)
                └── 3_utils.lua -- Các plugin tiện ích khác (git, treesitter, mini)
```

---

## 🔌 Plugins đã cài

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

## ⌨️ Phím tắt (Keybindings)

> **Leader key**: `<Space>` | **Local Leader**: `<Space>`

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
| `<leader>sf` | Tìm file theo tên |
| `<leader>sg` | Live grep toàn project |
| `<leader><leader>` | Tìm kiếm trong các buffer đang mở |
| `<leader>sn` | Live grep trong thư mục `node_modules` |

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

### Window & Splits

| Phím | Tác dụng |
|------|----------|
| `<C-h/j/k/l>` | Di chuyển focus giữa các split |
| `vv` | Split màn hình theo chiều dọc |
| `ss` | Split màn hình theo chiều ngang |

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
| `jk` (insert) | Thoát nhanh về normal mode |
| `<Esc>` / `//` | Xóa highlight tìm kiếm |
