return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.load_extension("fzf")

        -- Set keymaps
        vim.keymap.set('n', '<leader>ff', "<cmd>Telescope find_files<cr>", { desc = "Find Files"})
        vim.keymap.set('n', '<leader>fr', "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files"})
        vim.keymap.set('n', '<leader>fs', "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd"})
        vim.keymap.set('n', '<leader>fc', "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd"})
    end
}
