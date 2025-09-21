vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

--bootstrap block in case we are installing neovim on a new machine
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

if vim.fn.has("macunix") == 1 then
	vim.g.vimtex_view_method = "skim"
elseif vim.fn.has("unix") == 1 then
	vim.g.vimtex_view_method = "zathura"
end

require("settings")
require("plugins")
require("autocmds")
require("lazy").setup("plugins")
require("keymaps")
require("lualine-config")
require("commands")

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end

vim.g.vimtex_compiler_latexmk = {
	out_dir = "build", -- all aux/pdf/log/etc. go here
}

vim.g.copilot_no_tab_map = true

vim.g.vimtex_complete_enabled = 1
vim.g.vimtex_complete_close_braces = 1
