-- Buscador en archivos, iconos, atajos lsp
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})

require("mini.icons").setup()

MiniIcons.mock_nvim_web_devicons()

local fzf = require("fzf-lua")

fzf.setup({
	winopts = {
		-- preview window is in fullscreen and takes 70% of the space and is above the search results
		fullscreen = true,
		preview = {
			layout = "vertical",
			vertical = "up:70%",
		},
	},
	grep_curbuf = {
		-- use exact string matching, but only for the files picker
		fzf_opts = {
			["--exact"] = "",
			["--no-sort"] = "",
		},
	},
	files = {
		fzf_opts = {
			["--exact"] = "",
			["--no-sort"] = "",
		},
	},
	diagnostics = {
		cwd_only = false,
		file_icons = false,
		git_icons = false,
		color_headings = true, -- use diag highlights to color source & filepath
		diag_icons = true, -- display icons from diag sign definitions
		diag_source = true, -- display diag source (e.g. [pycodestyle])
		diag_code = true, -- display diag code (e.g. [undefined])
		icon_padding = "", -- add padding for wide diagnostics signs
		multiline = 2, -- split heading and diag to separate lines
		-- severity_only  = 1
		-- severity_only:   keep any matching exact severity
		-- severity_limit:  keep any equal or more severe (lower)
		-- severity_bound:  keep any equal or less severe (higher)
	},
})
-- use `fzf-lua` for replace vim.ui.select
fzf.register_ui_select()

vim.keymap.set("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "FZF Diagnostics" })
vim.keymap.set("n", "<leader>fe", function()
	fzf.diagnostics_workspace({ severity_only = 1 })
end, { desc = "FZF Diagnostics (errors)" })

vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "FZF References" })
vim.keymap.set("n", "<leader>fi", fzf.lsp_implementations, { desc = "FZF Implementations" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "FZF Buffers" })

-- overrides
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fz", fzf.grep_curbuf, { desc = "FZF grep current buffer" })
vim.keymap.set("n", "<leader>fs", fzf.live_grep, { desc = "FZF Live grep" })
vim.keymap.set("n", "<leader>gt", fzf.git_status, { desc = "FZF Git status" })
vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "FZF Old files" })
vim.keymap.set("n", "<leader>qo", fzf.quickfix, { desc = "FZF Quickfix" })
vim.keymap.set("n", "<leader>qO", fzf.lgrep_quickfix, { desc = "FZF Grep → quickfix" })
vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, { desc = "FZF Code actions" })
vim.keymap.set("n", "<leader>?", fzf.builtin, { desc = "FZF Builtins" })
