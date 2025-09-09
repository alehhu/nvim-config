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

require("settings")
require("plugins")
require("keymaps")
require("autocmds")
require("lualine-config")
require("commands")

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end
