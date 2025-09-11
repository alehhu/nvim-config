-- vim.keymap.set({mode}, {keys}, {command_or_function}, {options})

local keymap = vim.keymap.set

--Editor specific (Inserting mode)
keymap("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
keymap("i", "<C-e>", "<End>", { desc = "move end of line" })
keymap("i", "<C-h>", "<Left>", { desc = "move left" })
keymap("i", "<C-l>", "<Right>", { desc = "move right" })
keymap("i", "<C-j>", "<Down>", { desc = "move down" })
keymap("i", "<C-k>", "<Up>", { desc = "move up" })

keymap("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
keymap("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

keymap({ "n", "x" }, "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-- buffer management
keymap("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })
-- buffers navigation
keymap("n", "<Leader>h", ":bprev<CR>", { desc = "previous buffer", noremap = true, silent = true })
keymap("n", "<Leader>l", ":bnext<CR>", { desc = "next buffer", noremap = true, silent = true })
-- Close current buffer
keymap("n", "<leader>x", ":bd<CR>", { desc = "Delete buffer" })
-- Pick buffer (if using Telescope)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "List buffers" })

-- tab management
keymap("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "tab new" })
keymap("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "tab close" })
keymap("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "tab only" })
keymap("n", "<leader>tm", "<cmd>tabmove<cr>", { desc = "tab move" })
-- tabs navigation
keymap("n", "<leader><Tab>", ":tabnext<CR>", { desc = "next tab", noremap = true, silent = true })
keymap("n", "<leader><S-Tab>", ":tabprev<CR>", { desc = "previous tab", noremap = true, silent = true })

--File explorer
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Explorer", silent = true })
keymap("n", "<leader>fe", "<cmd>NvimTreeFocus<cr>", { desc = "Focus File Explorer" })

--fuzzy finder
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List Buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find oldfiles" })
keymap("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
keymap("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Check repo's all commits" })
keymap("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
keymap("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Pick hidden toggleable terminals" })

keymap("n", "<leader>ts", "<cmd>TSPlaygroundToggle<cr>", { desc = "Toggle Treesitter Playground" })

keymap("n", "<leader>+", function()
	require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })
--Noice
keymap("n", "<leader>nd", "<cmd>NoiceDismiss<cr>", { desc = "Dismiss Noice Messages" })

-- terminal
keymap("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })
-- new terminals (rather using toggleable ones actually)
keymap("n", "<leader>th", function()
	require("nvchad.term").new({ pos = "sp" })
end, { desc = "terminal new horizontal term" })

keymap("n", "<leader>tv", function()
	require("nvchad.term").new({ pos = "vsp" })
end, { desc = "terminal new vertical term" })
-- toggleable terminals
keymap({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "terminal toggleable vertical term" })

keymap({ "n", "t" }, "<A-h>", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "terminal toggleable horizontal term" })

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

-- mason
keymap("n", "<leader>om", "<cmd>Mason<cr>", { desc = "Open Mason" })
keymap("n", "<leader>fm", function()
	require("conform").format({ async = true })
end, { desc = "Format File" })

keymap("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })

-- commenting shortcuts (for every language)
keymap("n", "<leader>gcc", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle Comment" })
keymap("v", "<leader>gc", function()
	require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle Comment" })

-- browsing (already mapped actually, just for doc)
keymap("n", "<leader>ol", "<cmd>Browse<cr>", { desc = "Open Link Under Cursor" })

-- whichkey
keymap("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

keymap("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

local cmp = require("cmp")
local luasnip = require("luasnip")

local M = {}

M.cmp_mappings = function()
	return cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
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
	})
end

return M
