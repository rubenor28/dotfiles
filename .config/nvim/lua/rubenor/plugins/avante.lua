return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	build = "make",
	opts = {
		provider = "openai",
		openai = {
			endpoint = "http://localhost:11434/v1",
			model = "deepseek-r1:8b",
			api_key = "n/a",
			timeout = 30000,
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
	},
}
