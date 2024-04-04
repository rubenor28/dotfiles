vim.g.mapleader = ' '
-- Basic settings
vim.opt.syntax = 'on'         -- Enable syntax highlighting
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.tabstop = 4           -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4       -- Number of spaces to use for each step of (auto)indent
vim.opt.shiftwidth = 4        -- Number of spaces to use for indentation
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.o.showmode = false

vim.cmd('set clipboard+=unnamedplus') -- Copiar al portapapeles con xclip
vim.cmd('set guioptions+=a')          -- Pegar desde el portapapeles con xclip

vim.cmd("set background=dark")
vim.cmd("set termguicolors")

-- Desactivar la línea de estado del buffer en la esquina superior izquierda
vim.cmd([[set noshowmode]])

-- Ocultar el nombre del archivo en la esquina superior izquierda
vim.cmd([[set shortmess+=F]])

-- Opcional: Si también deseas ocultar el nombre del archivo en la pestaña
vim.cmd([[set shortmess+=T]])

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

vim.opt.list = true -- enable the below listchars
vim.opt.listchars = {
    tab = '󰧟󰧟',
    space = '󰧟',
    trail = '·',
    extends = '»',
    precedes = '«',
}

