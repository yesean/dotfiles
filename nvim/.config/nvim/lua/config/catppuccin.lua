require("catppuccin").setup({
	compile = {
		enabled = true,
	},
	integrations = {
		which_key = true,
	},
})
vim.g.catppuccin_flavour = "mocha"
vim.cmd("colorscheme catppuccin")
