return {
	----------------------------------------------------------------------
	-- NHÓM GIAO DIỆN & TRẢI NGHIỆM NGƯỜI DÙNG (UI/UX)
	----------------------------------------------------------------------

	-- Theme
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				styles = { comments = { italic = false } },
			})
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},

	-- Cây thư mục
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local ok, nvimtree = pcall(require, "nvim-tree")
			if not ok then
				return
			end

			nvimtree.setup({
				-- tự đồng bộ/highlight file đang mở
				update_focused_file = {
					enable = true,
					update_root = false, -- bật = true nếu muốn đổi root theo buffer hiện tại
				},
				filters = {
					git_ignored = true, -- vẫn ẩn theo .gitignore
					exclude = { "node_modules" }, -- 🔑 luôn hiện node_modules
				},
			})

			local api = require("nvim-tree.api")

			-- <leader>e: nếu tree đang mở thì đóng; nếu đang đóng thì mở & focus đúng file đang mở
			vim.keymap.set("n", "<leader>e", function()
				local view = require("nvim-tree.view")
				if view.is_visible() then
					api.tree.toggle()
				else
					api.tree.find_file({ open = true, focus = true })
				end
			end, { desc = "Reveal current file (smart toggle)" })

			-- Tuỳ chọn: thêm <leader>E để luôn reveal + focus (kể cả đang mở)
			vim.keymap.set("n", "<leader>E", function()
				api.tree.find_file({ open = true, focus = true })
			end, { desc = "Reveal current file (force)" })
		end,
	},

	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	version = "*",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = function()
	-- 		require("nvim-tree").setup({})
	-- 		vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
	-- 	end,
	-- },
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons", -- Dùng chung icon
		config = function()
			require("bufferline").setup({
				options = {
					-- Hiển thị tên buffer một cách gọn gàng
					mode = "buffers",
					themable = true, -- Cho phép theme (tokyonight) tùy chỉnh màu sắc
					numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both"
					close_command = "bdelete! %d", -- Lệnh để đóng buffer
					right_mouse_command = "bdelete! %d",
					-- Các chỉ báo
					indicator = {
						icon = "▎", -- Ký tự chỉ báo buffer hiện tại
						style = "underline",
					},
					buffer_close_icon = "󰅖", -- Icon nút đóng
					modified_icon = "●", -- Icon cho file đã bị sửa
					show_buffer_close_icons = true,
					show_close_icon = true,
					separator_style = "thin", -- "thin" | "thick" | "slant"
					-- Luôn hiển thị dòng bufferline, kể cả khi chỉ có 1 buffer
					always_show_bufferline = true,
				},
			})

			-- Phím tắt để điều hướng buffer
			vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
			vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
			vim.keymap.set("n", "<leader>c", ":bdelete<CR>", { desc = "[C]lose current buffer" })
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VimEnter", -- Tải plugin ngay khi vào Neovim
		config = function()
			require("which-key").setup({
				-- các tùy chọn ở đây
			})

			-- Sử dụng định dạng mới để đăng ký các nhóm phím tắt.
			-- Các phím tắt riêng lẻ (c, e, f) sẽ được which-key tự động nhận diện
			-- từ phần `desc` trong `vim.keymap.set`.
			-- Chúng ta chỉ cần định nghĩa nhóm cho phím 's'.
			require("which-key").register({
				{ "s", group = "[S]earch" },
			})
		end,
	},
}
