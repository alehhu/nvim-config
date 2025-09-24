return {
	{
		"NvChad/base46",
		lazy = false,
		build = function()
			require("base46").load_all_highlights()
		end,
	},

	{
		"NvChad/ui",
		lazy = false,
		dependencies = { "NvChad/base46" },
		config = function()
			require("nvchad")
		end,
	},
	{
		"NvChad/volt", -- optional, for theme switching
	},
	{
		"NvChad/minty",
		config = function()
			require("minty").setup()
		end,
	},

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

	{ "nvim-treesitter/playground" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			vim.defer_fn(function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"lua",
						"python",
						"javascript",
						"swift",
						"c",
						"typescript",
						"java",
						"regex",
						"bash",
					},
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
					indent = { enable = true },
				})
			end, 50)
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function(_, opts)
			require("which-key").setup(opts)
			require("config.whichkey") -- wk.add() is contained inside
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		config = function()
			require("snacks").setup({
				notifier = {
					enabled = true,
					timeout = 8000,
					fade = true,
					slide = true,
				},
			})
		end,
	},

	{ "folke/noice.nvim" },

	{ "lewis6991/gitsigns.nvim" },

	-- autocompletion
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*", -- stick to v2 for stability
		build = "make install_jsregexp", -- works fine on macOS
		dependencies = {
			-- Optional: prebuilt snippet collection
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		config = function()
			local ls = require("luasnip")

			-- Core settings
			ls.setup({
				history = true,
				update_events = "TextChanged,TextChangedI",
				delete_check_events = "TextChanged",
				enable_autosnippets = true,
			})

			-- Keymaps for snippet navigation
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true, desc = "LuaSnip expand/jump" })

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true, desc = "LuaSnip jump back" })

			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true, desc = "LuaSnip next choice" })

			-- Load your own snippets
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/snippets" },
			})
			require("luasnip.loaders.from_lua").load({
				paths = vim.fn.stdpath("config") .. "/luasnippets",
			})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer", --same buffer: semantic repetition
			"hrsh7th/cmp-path", -- autocomplete files and directory names
			"hrsh7th/cmp-cmdline", -- nvim's command line
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local keymaps = require("keymaps")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = keymaps.cmp_mappings(),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "omni" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
	{ "github/copilot.vim" },

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		cmd = "CopilotChat",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		opts = {
			window = { layout = "float", border = "rounded", title = "AI helper 🤖😈" },
			headers = {
				user = "🧑 You",
				assistant = "🤖 Megatron",
			},
			separator = "--/!@§/--",
			auto_follow_cursor = false,
			show_help = true,
			mappings = {},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			chat.setup(opts)
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		event = "VeryLazy",
		config = function()
			require("mason").setup()

			--  Auto-update Mason tools 5 seconds after launch
			vim.defer_fn(function()
				vim.cmd("MasonUpdate")
			end, 5000)
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
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").lua_ls.setup({})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		lazy = true,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"basedpyright", -- python
					"ruff", -- python

					"clangd", -- C
					"jdtls", -- java
					"lua_ls", -- lua
				},
				auto_update = false,
			})
		end,
	},
	-- Formatters installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"clang-format",
					"stylua",
					"prettier",
					"black",
					"shellcheck",
				},
				auto_update = true,
				run_on_start = false, -- disable startup run
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
	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		dependencies = { "nvim-lua/plenary.nvim" }, -- Required for Neovim < 0.10.0
		config = true, -- default settings
		submodules = false, -- not needed, submodules are required only for tests

		-- you can specify also another config if you want
		config = function()
			require("gx").setup({
				open_browser_app = "open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
				open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".

				open_callback = false, -- optional callback function to be called with the selected url on open
				open_callback = function(url)
					vim.fn.setreg("+", url) -- for example, you can set the url to clipboard here
				end,

				select_prompt = true, -- shows a prompt when multiple handlers match; disable to auto-select the top one

				handlers = {
					plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
					github = true, -- open github issues
					brewfile = true, -- open Homebrew formulaes and casks
					package_json = true, -- open dependencies from package.json
					search = true, -- search the web/selection on the web if nothing else is found
					go = true, -- open pkg.go.dev from an import statement (uses treesitter)
					jira = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
						name = "jira", -- set name of handler
						handle = function(mode, line, _)
							local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
							if ticket and #ticket < 20 then
								return "http://jira.company.com/browse/" .. ticket
							end
						end,
					},
					rust = { -- custom handler to open rust's cargo packages
						name = "rust", -- set name of handler
						filetype = { "toml" }, -- you can also set the required filetype for this handler
						filename = "Cargo.toml", -- or the necessary filename
						handle = function(mode, line, _)
							local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

							if crate then
								return "https://crates.io/crates/" .. crate
							end
						end,
					},
				},
				handler_options = {
					search_engine = "google", -- you can select between google, bing, duckduckgo, ecosia and yandex
					--search_engine = "https://search.brave.com/search?q=", -- or you can pass in a custom search engine
					select_for_search = false, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link

					git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
					git_remotes = function(fname) -- you can also pass in a function
						if fname:match("myproject") then
							return { "mygit" }
						end
						return { "upstream", "origin" }
					end,

					git_remote_push = false, -- use the push url for git issue linking,
					git_remote_push = function(fname) -- you can also pass in a function
						return fname:match("myproject")
					end,
				},
			})
		end,
	},

	{
		"lervag/vimtex",
		ft = { "tex", "latex" }, -- load only for these filetypes
		lazy = false,
		init = function() -- function that runs before the plugin is loaded
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.maplocalleader = "\\"
			vim.g.vimtex_quickfix_mode = 0
			vim.opt.conceallevel = 1
			vim.g.tex_conceal = "abdmg"
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "build",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				options = {
					"-pdf",
					"-shell-escape",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
					"-pvc", -- preview continuously
				},
			}
		end,
	},

	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				-- config
				theme = "hyper",
				disable_move = true,
				config = {
					week_header = {
						enable = true,
					},
					shortcut = {
						{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Files",
							group = "Label",
							action = "Telescope find_files",
							key = "f",
						},
						{
							desc = " Apps",
							group = "DiagnosticHint",
							action = function()
								require("telescope.builtin").find_files({
									prompt_title = "Apps",
									cwd = "/bin",
									hidden = true,
								})
							end,
							key = "a",
						},

						{
							desc = " dotfiles",
							group = "Number",
							action = function()
								require("telescope.builtin").find_files({
									prompt_title = "Dotfiles",
									cwd = "~/.config/nvim",
									hidden = true,
								})
							end,
							key = "d",
						},
					},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
}
