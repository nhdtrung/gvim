# Neovim Config (GVim)

[English](README.md) | [Tiếng Việt](README.vi.md)

> Cấu hình Neovim hiện đại, mở rộng từ `nvim-kickstart`, tối ưu cho lập trình (PHP, JavaScript/TypeScript, Lua, XML, v.v.), tích hợp AI Assistant (CodeCompanion với Claude), LSP, Auto-format và Fuzzy Finder.

---

## ⚡ Cài đặt nhanh bằng 1 lệnh (Automated Install)

Chỉ cần chọn lệnh tương ứng với hệ điều hành của bạn, script sẽ tự động cài đặt Neovim, dependencies, clone cấu hình và khởi tạo toàn bộ plugins:

### Linux (Ubuntu 22.04 / 24.04 / Debian) & macOS (Apple Silicon M1/M2/M3/M4 & Intel)
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nhdtrung/gvim/main/install.sh)"
```

### Windows 11 (PowerShell)
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://raw.githubusercontent.com/nhdtrung/gvim/main/install.ps1 | iex"
```

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

## 💻 Hướng dẫn cài đặt thủ công theo từng hệ điều hành

Nếu bạn muốn tự chạy từng lệnh thay vì dùng script tự động, hãy làm theo hướng dẫn tương ứng dưới đây:

### 🍏 macOS (M1 / Apple Silicon & Intel)

1. **Cài đặt Neovim và công cụ phụ trợ qua Homebrew**:
   ```bash
   brew install neovim ripgrep fd nodejs git
   ```

2. **Sao lưu cấu hình cũ (nếu có)**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
   mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
   ```

3. **Clone repository**:
   ```bash
   git clone https://github.com/nhdtrung/gvim.git ~/.config/nvim
   ```

4. **Khởi tạo plugin & LSP server**:
   ```bash
   nvim --headless "+Lazy! sync" +qa
   nvim --headless -c "MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd" -c "sleep 5" -c "qa"
   ```

---

### 🐧 Ubuntu 22.04 LTS (và các bản Debian/Ubuntu mới hơn)

> [!NOTE]
> APT mặc định của Ubuntu 22.04 chỉ có Neovim v0.6.8 (quá cũ). Chúng ta sẽ cài bản prebuilt chính thức mới nhất (v0.12+) vào `~/.local/bin`.

1. **Cài đặt dependencies hệ thống**:
   ```bash
   sudo apt update
   sudo apt install -y git curl gcc make ripgrep fd-find unzip python3 python3-pip nodejs npm

   # Tạo symlink cho fd (Ubuntu đặt tên gói là fdfind)
   mkdir -p ~/.local/bin
   ln -sf $(which fdfind) ~/.local/bin/fd
   ```

2. **Tải và cài đặt Neovim binary mới nhất (x86_64)**:
   ```bash
   curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
   tar -C ~/.local -xzf nvim-linux-x86_64.tar.gz
   ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
   rm nvim-linux-x86_64.tar.gz

   # Đảm bảo ~/.local/bin có trong PATH:
   export PATH="$HOME/.local/bin:$PATH"
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   ```
   *(Đối với Linux kiến trúc ARM64, thay bằng `nvim-linux-arm64.tar.gz`).*

3. **Clone repository**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
   git clone https://github.com/nhdtrung/gvim.git ~/.config/nvim
   ```

4. **Khởi tạo plugin & LSP server**:
   ```bash
   nvim --headless "+Lazy! sync" +qa
   nvim --headless -c "MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd" -c "sleep 5" -c "qa"
   ```

---

### 🪟 Windows 11 (PowerShell)

1. **Cài đặt các gói công cụ qua `winget`**:
   ```powershell
   winget install --id Neovim.Neovim -e
   winget install --id BurntSushi.ripgrep.MSVC -e
   winget install --id sharkdp.fd -e
   winget install --id OpenJS.NodeJS.LTS -e
   winget install --id Git.Git -e
   ```

2. **Sao lưu cấu hình cũ & clone repository**:
   ```powershell
   if (Test-Path "$env:LOCALAPPDATA\nvim") {
       Move-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.bak"
   }
   git clone https://github.com/nhdtrung/gvim.git "$env:LOCALAPPDATA\nvim"
   ```

3. **Khởi tạo plugin & LSP server**:
   ```powershell
   nvim --headless "+Lazy! sync" +qa
   nvim --headless -c "MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd" -c "sleep 5" -c "qa"
   ```

---

## 🤖 Thiết lập AI Assistant (CodeCompanion - Claude)

Cấu hình tích hợp [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim) sử dụng Claude (Anthropic).

1. Lấy API key tại [Anthropic Console](https://console.anthropic.com/).
2. Thêm biến môi trường:
   - **Linux/macOS (`~/.bashrc` hoặc `~/.zshrc`)**:
     ```bash
     export ANTHROPIC_API_KEY="sk-ant-api..."
     ```
   - **Windows 11 (PowerShell)**:
     ```powershell
     [System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-api...", "User")
     ```

---

## 📂 Cấu trúc thư mục

```
~/.config/nvim/ (hoặc %LOCALAPPDATA%\nvim trên Windows)
├── init.lua          -- File khởi động chính, chỉ gọi các module khác
├── install.sh        -- Script cài đặt tự động (Linux & macOS)
├── install.ps1       -- Script cài đặt tự động (Windows 11)
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
