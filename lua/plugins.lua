require("lazy").setup({

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup()
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	{ "folke/which-key.nvim" },

	{ "folke/noice.nvim" },

	{ "lewis6991/gitsigns.nvim" },

	-- autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	-- formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				python = { "ruff" },
				go = { "gofumpt" },
				-- Add more filetypes as needed
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	-- LSP installer
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"basedpyright", -- python
					"ruff", -- python

					"clangd", -- C
					"jdtls", -- java
					"lua_ls", -- lua
				},
			})
		end,
	},
	-- Formatters installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"clang-format",
					"stylua", -- Lua
					"prettier", -- JS/TS/HTML/CSS
					"black", -- Python
					"shellcheck", -- Shell script linter
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
	{ "windwp/nvim-autopairs" },

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		config = true,
	},
})
