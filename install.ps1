# Automated Installation Script for GVim on Windows 11
# Usage:
#   powershell -ExecutionPolicy ByPass -c "irm https://raw.githubusercontent.com/nhdtrung/gvim/main/install.ps1 | iex"

$ErrorActionPreference = "Stop"

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "     GVim Automated Setup for Windows 11      " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# -------------------------------------------------------------
# 1. Install Prerequisites via winget
# -------------------------------------------------------------
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "`n[INFO] Installing / updating dependencies via winget..." -ForegroundColor Blue
    $packages = @(
        "Neovim.Neovim",
        "BurntSushi.ripgrep.MSVC",
        "sharkdp.fd",
        "OpenJS.NodeJS.LTS",
        "Git.Git"
    )
    foreach ($pkg in $packages) {
        Write-Host "[INFO] Checking $pkg..." -ForegroundColor Gray
        winget install --id $pkg -e --accept-source-agreements --accept-package-agreements --silent 2>$null
    }
} else {
    Write-Host "`n[WARN] winget not detected. Please ensure git, nvim, ripgrep, fd, and node are installed." -ForegroundColor Yellow
}

# Refresh environment variables within current PowerShell session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# -------------------------------------------------------------
# 2. Setup Configuration Directory ($env:LOCALAPPDATA\nvim)
# -------------------------------------------------------------
$ConfigDir = "$env:LOCALAPPDATA\nvim"
$RepoUrl = "https://github.com/nhdtrung/gvim.git"

if (Test-Path "$ConfigDir\.git") {
    Write-Host "`n[INFO] Updating existing GVim configuration in $ConfigDir..." -ForegroundColor Blue
    Push-Location $ConfigDir
    git pull origin main
    Pop-Location
} elseif (Test-Path $ConfigDir) {
    $BackupDir = "${ConfigDir}.bak." + (Get-Date -Format "yyyyMMddHHmmss")
    Write-Host "`n[WARN] Existing non-git configuration found. Backing up to $BackupDir..." -ForegroundColor Yellow
    Move-Item -Path $ConfigDir -Destination $BackupDir
    Write-Host "[INFO] Cloning GVim config to $ConfigDir..." -ForegroundColor Blue
    git clone $RepoUrl $ConfigDir
} else {
    Write-Host "`n[INFO] Cloning GVim config to $ConfigDir..." -ForegroundColor Blue
    git clone $RepoUrl $ConfigDir
}

# -------------------------------------------------------------
# 3. Synchronize Plugins via Lazy.nvim
# -------------------------------------------------------------
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Write-Host "`n[INFO] Syncing plugins via Lazy.nvim (headless)..." -ForegroundColor Blue
    nvim --headless "+Lazy! sync" +qa

    Write-Host "`n[INFO] Installing Mason LSP servers and formatters..." -ForegroundColor Blue
    nvim --headless -c "MasonInstall lua-language-server typescript-language-server intelephense lemminx stylua prettierd" -c "sleep 5" -c "qa"

    Write-Host "`n==============================================" -ForegroundColor Green
    Write-Host "   GVim / Neovim Setup Complete! 🎉           " -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host "`nTo launch Neovim, run:" -ForegroundColor White
    Write-Host "  nvim" -ForegroundColor Yellow
    Write-Host "`nOptional: Set ANTHROPIC_API_KEY for Claude AI Assistant in PowerShell:" -ForegroundColor White
    Write-Host '  [System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "your_api_key_here", "User")' -ForegroundColor Yellow
} else {
    Write-Host "`n[WARN] 'nvim' is not in PATH for this session. Please reopen PowerShell and run:" -ForegroundColor Yellow
    Write-Host "  nvim" -ForegroundColor White
}
