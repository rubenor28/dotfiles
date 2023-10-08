-- Plugins management with Packer
-- You'll need to install Packer first: https://github.com/wbthomason/packer.nvim
-- Using the "opt" flag to load plugins on demand
local packer = require('packer')
packer.startup(function()

    use {
	    'nvim-telescope/telescope.nvim', tag = '0.1.0',
	    -- or                            , branch = '0.1.x',
	    requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {'preservim/nerdtree'} -- nerdtree
    use { "catppuccin/nvim", as = "catppuccin" } -- catppucci colorscheme

-- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {                                      -- Optional
        'williamboman/mason.nvim',
        run = function()
        pcall(vim.cmd, 'MasonUpdate')
        end,
        },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    }
}

    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    -- lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    
    use {'jiangmiao/auto-pairs'}
    use {'ap/vim-buftabline'}

    --gruvbox colorscheme
    use {'ellisonleao/gruvbox.nvim'}

    --Vim-Cmake
    use {'cdelledonne/vim-cmake'}

    --sonokai colorsheme
    use {'sainnhe/sonokai'}

    --Nightfox theme
    use {'EdenEast/nightfox.nvim'}
end)

