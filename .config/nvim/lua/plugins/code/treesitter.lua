vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
})

require("nvim-treesitter")
	.install({
		"c_sharp",
		"razor",
		"json",
		"javascript",
		"typescript",
		"tsx",
		"toml",
		"yaml",
		"html",
		"xml",
		"css",
		"markdown",
		"markdown_inline",
		"bash",
		"lua",
		"vim",
		"dockerfile",
		"gitignore",
		"vimdoc",
		"c",
		"sql",
		"svelte",
	})
	:wait(300000)

require("tree-sitter-manager").setup({
	auto_install = true,
	highlight = true,
})
