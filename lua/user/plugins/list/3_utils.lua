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
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc", "php", "javascript", "xml" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
