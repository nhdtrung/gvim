return {
	----------------------------------------------------------------------
	-- NHÓM CHỨC NĂNG CỐT LÕI (CORE FUNCTIONALITY)
	----------------------------------------------------------------------

	-- Tự động format
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					php = { "php_cs_fixer" },
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					xml = { "prettierd" },
				},
				format_on_save = { timeout_ms = 500, lsp_fallback = true },
			})
			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format file or range" })
		end,
	},

	-- Tìm kiếm (Fuzzy Finder)
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("telescope").setup({})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })
      vim.keymap.set("n", "<leader>sn", function()
        require("telescope.builtin").live_grep({
          search_dirs = { "node_modules" },
          additional_args = function()
            return { "--no-ignore", "--hidden" }
          end,
        })
      end, { desc = "[S]earch in [N]ode_modules" })
		end,
	},

	-- Hỗ trợ LSP (Language Server Protocol)
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason").setup()
			require("mason-lspconfig").setup({ automatic_installation = { exclude = { "stylua" } } })

			vim.lsp.config("*", { capabilities = capabilities })
			vim.lsp.enable({ "lua_ls", "intelephense", "ts_ls", "lemminx" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.lsp.handlers["textDocument/hover"] =
						vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "php",
				callback = function()
					vim.bo.tabstop = 4
					vim.bo.shiftwidth = 4
				end,
			})
		end,
	},

	-- CodeCompanion.nvim - AI Assistant với Claude
	{
		"olimorris/codecompanion.nvim",
		version = "^18.0.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_API_KEY",
							},
						})
					end,
				},
				strategies = {
					chat = {
						adapter = "anthropic",
					},
					inline = {
						adapter = "anthropic",
					},
				},
			})

			-- Phím tắt cho CodeCompanion
			vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
			vim.keymap.set(
				{ "n", "v" },
				"<LocalLeader>a",
				"<cmd>CodeCompanionChat Toggle<cr>",
				{ desc = "Toggle CodeCompanion Chat" }
			)
			vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add to CodeCompanion Chat" })

			-- Command abbreviation
			vim.cmd([[cab cc CodeCompanion]])
		end,
	},

	-- claudecode.nvim - Claude Code CLI trong Neovim
	-- Dùng prefix <leader>C vì <leader>a đã gán cho CodeCompanion (tránh trễ do timeoutlen)
	{
		"coder/claudecode.nvim",
		opts = { terminal = { provider = "native" } },
		keys = {
			{ "<leader>Cc", "<cmd>ClaudeCode<cr>", desc = "Toggle [C]laude Code" },
			{ "<leader>Cf", "<cmd>ClaudeCodeFocus<cr>", desc = "[F]ocus Claude Code" },
			{ "<leader>Cr", "<cmd>ClaudeCode --resume<cr>", desc = "[R]esume Claude Code" },
			{ "<leader>CC", "<cmd>ClaudeCode --continue<cr>", desc = "[C]ontinue Claude Code" },
			{ "<leader>Cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select [M]odel" },
			{ "<leader>Cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current [B]uffer" },
			{ "<leader>Cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "[S]end selection" },
			{ "<leader>Ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "[A]ccept diff" },
			{ "<leader>Cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "[D]eny diff" },
		},
	},

	-- Tự động hoàn thành (Autocomplete)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
