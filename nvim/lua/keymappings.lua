-- leader
vim.g.mapleader = ' '

-- Save
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>W', ':w!<CR>', { noremap = true, silent = true })

-- Quit
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Q', ':q!<CR>', { noremap = true, silent = true })

-- Resize windows hjkl
vim.api.nvim_set_keymap('n', '<M-k>', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-j>', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-l>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-h>', ':vertical resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-z>', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-Z>', ':split<CR>', { noremap = true, silent = true })

-- Window navigation
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-Up>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true })

-- Change Buffers
vim.api.nvim_set_keymap('n', '<tab>', ':bnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-tab>', ':bprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-q>', ':bd<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-Q>', ':bufdo bdelete<CR>', { noremap = true })

-- Not use esc
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true })
-- Not use ctl+\ + ctr+n on a terminal(?)
vim.api.nvim_set_keymap('t', 'jk', '<C-\\><C-n>', { noremap = true })
vim.api.nvim_set_keymap('t', 'kj', '<C-\\><C-n>', { noremap = true })

-- Open split terminal
vim.api.nvim_set_keymap('n', '<leader>tv', ':botright vnew <Bar> :terminal<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>th', ':botright new <Bar> :terminal<CR>', { noremap = true })

-- Format with lsp
vim.api.nvim_set_keymap('n', '<S-f>', ':LspZeroFormat<CR>', { noremap = true, silent = true })

-- Debugger, needs nvim-dap
vim.api.nvim_set_keymap('n', '<leader>db', ':DapToggleBreakpoint <CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ':DapContinue <CR>', { noremap = true })
