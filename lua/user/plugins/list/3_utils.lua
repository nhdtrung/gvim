return {
	----------------------------------------------------------------------
	-- NHÓM PLUGIN TIỆN ÍCH KHÁC
	----------------------------------------------------------------------
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.surround").setup()
			require("mini.ai").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		-- Nhánh `master` đã archive và lỗi trên Neovim 0.12; dùng `main` (cần `tree-sitter` CLI để build parser)
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.install({ "bash", "c", "html", "lua", "markdown", "markdown_inline", "vim", "vimdoc", "php", "javascript", "xml" })

			-- `main` không tự bật highlight/indent: bật theo từng buffer, và tự cài parser còn thiếu
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", {}),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match)
					if not lang then
						return
					end
					if pcall(vim.treesitter.start, ev.buf, lang) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					elseif vim.tbl_contains(ts.get_available(), lang) then
						ts.install(lang)
					end
				end,
			})
		end,
	},

	-- Xem trước Markdown ngay trong buffer
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "codecompanion" },
		opts = { file_types = { "markdown", "codecompanion" } },
		keys = {
			{ "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle [M]arkdown [P]review" },
		},
	},
}
