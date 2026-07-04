vim.pack.add({
	{ src = "https://github.com/cesaralvarod/tokyogogh.nvim" },
	{ src = "https://github.com/shatur/neovim-ayu" },
})

require("tokyogogh").setup()

vim.cmd("colorscheme tokyogogh-storm")
