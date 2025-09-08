-- vim.keymap.set({mode}, {keys}, {command_or_function}, {options})

local keymap = vim.keymap.set
--File explorer
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Explorer", silent = true })
keymap("n", "<leader>f", "<cmd>NvimTreeFocus<cr>", { desc = "Focus File Explorer" })

--fuzzy finder
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List Buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })

keymap("n", "<leader>ts", "<cmd>TSPlaygroundToggle<cr>", { desc = "Toggle Treesitter Playground" })

keymap("n", "<leader>nd", "<cmd>NoiceDismiss<cr>", { desc = "Dismiss Noice Messages" })

-- git signs
keymap("n", "]c", function()
	require("gitsigns").next_hunk()
end, { desc = "Next Hunk" })
keymap("n", "[c", function()
	require("gitsigns").prev_hunk()
end, { desc = "Prev Hunk" })
keymap("n", "<leader>gp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview Hunk" })
keymap("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blame Line" })

keymap("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Open Mason" })
keymap("n", "<leader>fm", function()
	require("conform").format({ async = true })
end, { desc = "Format File" })

keymap("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })

-- commenting shortcuts (for every language)
keymap("n", "<leader>-", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle Comment" })
keymap("v", "<leader>-", function()
	require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle Comment" })

-- browsing (already mapped actually, just for doc)
keymap("n", "<leader>gx", "<cmd>Browse<cr>", { desc = "Open Link Under Cursor" })
