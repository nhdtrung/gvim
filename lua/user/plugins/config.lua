-- [[ Cài đặt `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- [[ Cấu hình và cài đặt plugins ]]
-- Dòng quan trọng nhất: lazy.nvim sẽ tự động tìm và tải tất cả các file
-- .lua bên trong thư mục 'user.plugins.list'.
require("lazy").setup("user.plugins.list", {
	ui = { border = "rounded" },
})
