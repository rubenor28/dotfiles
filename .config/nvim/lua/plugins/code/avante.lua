return {
	"yetone/avante.nvim",
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@type avante.Config
	---
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"stevearc/dressing.nvim", -- for input provider dressing
		"folke/snacks.nvim", -- for input provider snacks
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
				},
			},
		},
	},
	opts = {
		instructions_file = vim.fn.getcwd() .. "/avante.md",
		provider = "groq",
		providers = {
			gemini = {
				api_key_name = "GEMINI_API_KEY",
				model = "gemini-1.5-flash-latest",
				endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
				timeout = 30000,
				extra_request_body = {
					temperature = 0,
					max_tokens = 8192,
				},
			},
			groq = {
				__inherited_from = "openai",
				api_key_name = "GROQ_API_KEY",
				model = "llama-3.3-70b-versatile",
				endpoint = "https://api.groq.com/openai/v1",
				timeout = 30000,
				extra_request_body = {
					temperature = 0,
					max_tokens = 8192,
				},
			},
		},
	},
}
