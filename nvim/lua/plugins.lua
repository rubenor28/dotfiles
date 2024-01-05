-- Plugins management with Packer
-- You'll need to install Packer first: https://github.com/wbthomason/packer.nvim
-- Using the "opt" flag to load plugins on demand
local packer = require('packer')
packer.startup(function()

    --telescope
    use {
	    'nvim-telescope/telescope.nvim', tag = '0.1.0',
	    -- or                            , branch = '0.1.x',
	    requires = { {'nvim-lua/plenary.nvim'} }
    }
    use{'nvim-lua/plenary.nvim'}
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

    --install:
    --ripgrep
    --
    
    -- nerdtree
    use {'preservim/nerdtree'}
    
    -- catppucci colorscheme
    use { "catppuccin/nvim", as = "catppuccin" } 

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

    --nvim icons
    -- use {'nvim-tree/nvim-web-devicons'}
    use {'ryanoasis/vim-devicons'}

    --colorizer
    use {'norcalli/nvim-colorizer.lua'}

    -- ident-blackline
    use {'lukas-reineke/indent-blankline.nvim'}

    -- Coc
    use{
        'neoclide/coc.nvim',
        branch = 'release',
    }
    -- Omnisharp C# support
    -- use {'OmniSharp/omnisharp-vim'}

    use {'bluz71/vim-nightfly-colors',  as = "nightfly" }
end)

