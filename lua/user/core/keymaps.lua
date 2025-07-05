local keymap = vim.keymap.set

-- Xóa highlight khi tìm kiếm
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Điều hướng cửa sổ
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })

-- Phím tắt cho Cây thư mục (TÙY CHỈNH)
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Phím tắt cho Format (TÙY CHỈNH)
keymap({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file or range" })

keymap("n", "vv", "<C-w>v", opts)
keymap("n", "ss", "<C-w>s", opts)

-- Move back and forth through previous and next buffers
-- with ,z and ,x
keymap("n", ",z", ":bp<CR>", opts)
keymap("n", ",x", ":bn<CR>", opts)

-- Highlight
keymap("n", "//", ":nohlsearch<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

--- nvim-tree
keymap("n", "<Leader>e", "<cmd>:NvimTreeFindFile<CR>", opts)
keymap("n", "<Leader>E", "<cmd>:NvimTreeToggle<CR>", opts)
keymap("n", "<C-\\>", "<cmd>:NvimTreeFindFile<CR>", opts)

-- nvim-dap
keymap("n", "<F3>", function()
	require("dap").toggle_breakpoint()
end)
keymap("n", "<leader>dH", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
keymap("n", "<F9>", function()
	require("dap").step_out()
end)
keymap("n", "<F7>", function()
	require("dap").step_into()
end)
keymap("n", "<F8>", function()
	require("dap").step_over()
end)
keymap("n", "<F5>", function()
	require("dap").continue()
end)
keymap("n", "<F10>", function()
	require("dap").run_to_cursor()
end)
keymap("n", "<F6>", function()
	require("dap").terminate()
end)
keymap("n", "<leader>dB", function()
	require("dap").clear_breakpoints()
end)
keymap("n", "<leader>de", function()
	require("dap").set_exception_breakpoints({ "all" })
end)
keymap("n", "<leader>da", function()
	require("debugHelper").attach()
end)
keymap("n", "<leader>dA", function()
	require("debugHelper").attachToRemote()
end)
keymap("n", "<leader>di", function()
	require("dap.ui.widgets").hover()
end)
keymap("n", "<leader>d?", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)
keymap("n", "<leader>dk", ':lua require"dap".up()<CR>zz')
keymap("n", "<leader>dj", ':lua require"dap".down()<CR>zz')
keymap("n", "<leader>dr", ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
keymap("n", "<leader>dc", function()
	require("dapui").toggle()
end)
