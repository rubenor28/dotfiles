-- Configuración del plugin 'oil.nvim' (gestor de archivos en NeoVim)
-- Este plugin proporciona un explorador de archivos minimalista y eficiente.
-- Se integra con 'mini.icons' para mostrar iconos en el explorador.
-- La tecla <leader>ee (por defecto \ee) abre/cierra el explorador.
-- Más información: https://github.com/stevearc/oil.nvim

return {
	"stevearc/oil.nvim",
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
	config = function()
		local o = require("oil")
		local keymap = vim.keymap

		o.setup({})

		keymap.set("n", "<leader>ee", "<cmd>Oil<CR>", { desc = "Toggle Oil file explorer" }) -- toggle file explorer
	end,
}
