return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restaurar sesión para el directorio actual de trabajo" }) -- restaura la última sesión de trabajo para el directorio actual
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Guardar sesión para el directorio raíz de sesiones automáticas" }) -- guarda la sesión de trabajo para el directorio actual
  end,
}
