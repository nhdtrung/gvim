#!/usr/bin/env bash
set -e

# Terminal colors
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { printf "${BLUE}${BOLD}[INFO]${NC} %s\n" "$*"; }
success() { printf "${GREEN}${BOLD}[OK]${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}${BOLD}[WARN]${NC} %s\n" "$*"; }
error() { printf "${RED}${BOLD}[ERROR]${NC} %s\n" "$*" >&2; }

REPO_URL="https://github.com/nhdtrung/gvim.git"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Ensure ~/.local/bin is in PATH
export PATH="$LOCAL_BIN:$PATH"

OS="$(uname -s)"
ARCH="$(uname -m)"

info "Starting GVim / Neovim Automated Setup..."
info "Detected OS: $OS ($ARCH)"

# -------------------------------------------------------------
# 1. Install System Dependencies & Neovim (>= 0.11)
# -------------------------------------------------------------
install_neovim_binary() {
    local tar_name=""
    local extract_dir=""

    if [ "$OS" = "Linux" ]; then
        if [ "$ARCH" = "x86_64" ]; then
            tar_name="nvim-linux-x86_64.tar.gz"
            extract_dir="nvim-linux-x86_64"
        elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
            tar_name="nvim-linux-arm64.tar.gz"
            extract_dir="nvim-linux-arm64"
        fi
    elif [ "$OS" = "Darwin" ]; then
        if [ "$ARCH" = "arm64" ]; then
            tar_name="nvim-macos-arm64.tar.gz"
            extract_dir="nvim-macos-arm64"
        else
            tar_name="nvim-macos-x86_64.tar.gz"
            extract_dir="nvim-macos-x86_64"
        fi
    fi

    if [ -z "$tar_name" ]; then
        error "Unsupported OS/architecture ($OS / $ARCH). Please install Neovim >= 0.11 manually."
        exit 1
    fi

    local nvim_url="https://github.com/neovim/neovim/releases/latest/download/$tar_name"
    info "Downloading latest Neovim binary ($tar_name)..."

    local tmp_dir
    tmp_dir="$(mktemp -d)"
    curl -fLo "$tmp_dir/$tar_name" "$nvim_url"

    mkdir -p "$HOME/.local"
    tar -C "$HOME/.local" -xzf "$tmp_dir/$tar_name"
    ln -sf "$HOME/.local/$extract_dir/bin/nvim" "$LOCAL_BIN/nvim"
    rm -rf "$tmp_dir"
    success "Installed Neovim to $LOCAL_BIN/nvim"
}

if [ "$OS" = "Darwin" ]; then
    info "Configuring macOS..."
    if command -v brew >/dev/null 2>&1; then
        info "Installing dependencies via Homebrew..."
        brew install neovim ripgrep fd nodejs 2>/dev/null || true
    else
        warn "Homebrew not detected. Installing Neovim binary directly..."
        install_neovim_binary
    fi
elif [ "$OS" = "Linux" ]; then
    info "Configuring Linux..."
    # Check if apt is available
    if command -v apt-get >/dev/null 2>&1; then
        if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
            info "Installing system dependencies via apt..."
            sudo apt-get update -y
            sudo apt-get install -y git curl gcc make ripgrep fd-find unzip python3 python3-pip nodejs npm
            if [ -x "$(command -v fdfind)" ] && [ ! -x "$LOCAL_BIN/fd" ]; then
                ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
            fi
        else
            info "Passwordless sudo not available. Checking existing dependencies..."
            for pkg in git curl gcc make rg unzip python3 node npm; do
                if ! command -v "$pkg" >/dev/null 2>&1; then
                    warn "Command '$pkg' not found. If needed, run: sudo apt install $pkg"
                fi
            done
        fi
    fi

    # Check Neovim version
    NEEDS_NVIM_INSTALL=1
    if command -v nvim >/dev/null 2>&1; then
        NVIM_VER="$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)"
        MAJOR=$(echo "$NVIM_VER" | cut -d. -f1)
        MINOR=$(echo "$NVIM_VER" | cut -d. -f2)
        if [ "$MAJOR" -gt 0 ] || [ "$MINOR" -ge 11 ]; then
            info "Existing Neovim version ($NVIM_VER) meets requirement (>= 0.11)."
            NEEDS_NVIM_INSTALL=0
        else
            warn "Existing Neovim ($NVIM_VER) is older than 0.11. Installing latest release..."
        fi
    fi

    if [ "$NEEDS_NVIM_INSTALL" -eq 1 ]; then
        install_neovim_binary
    fi

    # Install fd if missing
    if ! command -v fd >/dev/null 2>&1; then
        if command -v fdfind >/dev/null 2>&1; then
            ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
        else
            info "Installing standalone 'fd' binary..."
            FD_URL="https://github.com/sharkdp/fd/releases/latest/download/fd-v10.5.0-x86_64-unknown-linux-musl.tar.gz"
            tmp_fd="$(mktemp -d)"
            curl -fsSL "$FD_URL" | tar -C "$tmp_fd" -xz
            cp "$tmp_fd"/fd-*/fd "$LOCAL_BIN/fd"
            chmod +x "$LOCAL_BIN/fd"
            rm -rf "$tmp_fd"
            success "Installed fd to $LOCAL_BIN/fd"
        fi
    fi
fi

# Verify nvim executable
if ! command -v nvim >/dev/null 2>&1; then
    error "Neovim was not found in PATH. Make sure $LOCAL_BIN is in your PATH."
    exit 1
fi

info "Neovim version: $(nvim --version | head -n1)"

# -------------------------------------------------------------
# 2. Clone or Update Config
# -------------------------------------------------------------
if [ -d "$CONFIG_DIR/.git" ]; then
    CURRENT_REMOTE="$(cd "$CONFIG_DIR" && git remote get-url origin 2>/dev/null || true)"
    if echo "$CURRENT_REMOTE" | grep -q "gvim"; then
        info "Existing GVim configuration detected in $CONFIG_DIR."
    else
        BACKUP_DIR="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
        warn "Found existing non-GVim config. Backing up to $BACKUP_DIR..."
        mv "$CONFIG_DIR" "$BACKUP_DIR"
        info "Cloning GVim config..."
        git clone "$REPO_URL" "$CONFIG_DIR"
        success "Cloned GVim to $CONFIG_DIR"
    fi
elif [ -d "$CONFIG_DIR" ]; then
    BACKUP_DIR="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    warn "Existing directory $CONFIG_DIR is not a git repo. Backing up to $BACKUP_DIR..."
    mv "$CONFIG_DIR" "$BACKUP_DIR"
    info "Cloning GVim config..."
    git clone "$REPO_URL" "$CONFIG_DIR"
    success "Cloned GVim to $CONFIG_DIR"
else
    info "Cloning GVim config to $CONFIG_DIR..."
    git clone "$REPO_URL" "$CONFIG_DIR"
    success "Cloned GVim to $CONFIG_DIR"
fi

# -------------------------------------------------------------
# 3. Synchronize Plugins via Lazy.nvim
# -------------------------------------------------------------
info "Syncing plugins via Lazy.nvim..."
nvim --headless "+Lazy! sync" +qa
success "Plugins synchronized."

# -------------------------------------------------------------
# 4. Install Mason LSP Servers and Formatters
# -------------------------------------------------------------
info "Installing Mason LSP servers and formatters..."
nvim --headless -c "MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd" -c "sleep 5" -c "qa" || true
success "Mason tools ready."

# -------------------------------------------------------------
# 5. Summary & Next Steps
# -------------------------------------------------------------
printf "\n${GREEN}${BOLD}============================================${NC}\n"
printf "${GREEN}${BOLD}   GVim / Neovim Setup Complete! 🎉         ${NC}\n"
printf "${GREEN}${BOLD}============================================${NC}\n\n"

echo "Ensure $LOCAL_BIN is in your PATH (e.g. in ~/.bashrc or ~/.zshrc):"
echo "  export PATH=\"$LOCAL_BIN:\$PATH\""
echo ""
echo "Optional: For AI Assistant (CodeCompanion with Claude), set:"
echo "  export ANTHROPIC_API_KEY=\"your_api_key_here\""
echo ""
echo "To start Neovim:"
echo "  nvim"
echo ""
