local wk = require("which-key")

wk.add({
	-- THEMES
	{
		"<leader>+",
		function()
			require("nvchad.themes").open()
		end,
		desc = "NvChad Themes",
	},

	-- BUFFERS
	{ "<leader>b", "<cmd>enew<CR>", desc = "New Buffer" },
	{ "<leader>h", ":bprev<CR>", desc = "Previous Buffer" },
	{ "<leader>l", ":bnext<CR>", desc = "Next Buffer" },
	{ "<leader>x", ":bd<CR>", desc = "Delete Buffer" },

	-- COMMENTS
	{ "<leader>c", group = "comment" },
	{
		"<leader>cc",
		function()
			require("Comment.api").toggle.linewise.current()
		end,
		desc = "Toggle Comment",
	},
	{ "<leader>cm", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" }, -- maybe move to git group if it's truly git-related

	-- FILE / FIND
	{ "<leader>f", group = "file/find" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "List Buffers" },
	{ "<leader>fe", "<cmd>NvimTreeFocus<cr>", desc = "Focus File Explorer" },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
	{
		"<leader>fm",
		function()
			require("conform").format({ lsp_fallback = true })
		end,
		desc = "Format File",
	},
	{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
	{ "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Buffer" },

	-- GIT
	{ "<leader>g", group = "git" },
	{
		"<leader>gb",
		function()
			require("gitsigns").blame_line()
		end,
		desc = "Blame Line",
	},
	{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
	{
		"<leader>gp",
		function()
			require("gitsigns").preview_hunk()
		end,
		desc = "Preview Hunk",
	},
	{ "<leader>gt", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
	-- OPEN STUFF
	{ "<leader>o", group = "open" },
	{ "<leader>ol", "<cmd>Lazy<cr>", desc = "Open Lazy" },
	{ "<leader>om", "<cmd>Mason<cr>", desc = "Open Mason" },

	-- TOOLS
	{ "<leader>nd", "<cmd>NoiceDismiss<cr>", desc = "Dismiss Noice" },
	{ "<leader>ts", "<cmd>TSPlaygroundToggle<cr>", desc = "Treesitter Playground" },

	-- TERMINAL
	{ "<leader>t", group = "terminal" },
	{
		"<leader>th",
		function()
			require("nvchad.term").new({ pos = "sp" })
		end,
		desc = "New Horizontal Term",
	},
	{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
	{
		"<leader>tv",
		function()
			require("nvchad.term").new({ pos = "vsp" })
		end,
		desc = "New Vertical Term",
	},

	-- WHICH-KEY
	{ "<leader>wK", "<cmd>WhichKey<CR>", desc = "All Keymaps" },
	{
		"<leader>wk",
		function()
			vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
		end,
		desc = "Query Keymap",
	},
}, { mode = "n" })
