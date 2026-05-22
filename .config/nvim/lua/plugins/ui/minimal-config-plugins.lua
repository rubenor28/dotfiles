vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})

require("mini.icons").setup({
	extension = {
		razor = { glyph = "", hl = "MiniIconsAzure" },
	},
})

MiniIcons.mock_nvim_web_devicons()

require("tiny-inline-diagnostic").setup({
	preset = "modern", -- "modern", "classic", "minimal", "powerline"
	hi = {
		error = "DiagnosticError",
		warn = "DiagnosticWarn",
		info = "DiagnosticInfo",
		hint = "DiagnosticHint",
		arrow = "NonText",
		background = "CursorLine",
		mixing_color = "None",
	},
	options = {
		show_source = false,
		add_vertical_line = true,
		border = "rounded",
		softwrap = 30,
	},
})
