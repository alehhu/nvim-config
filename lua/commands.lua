vim.api.nvim_create_user_command("Telescope dotfiles", function()
	require("telescope.builtin").find_files({
		prompt_title = "Dotfiles",
		cwd = "~/.config/nvim",
		hidden = true,
	})
end, {})

vim.api.nvim_create_user_command("Telescope app", function()
	require("telescope.builtin").find_files({
		prompt_title = "Apps",
		cwd = "~/apps", -- change to your actual folder
		hidden = true,
	})
end, {})
