vim.cmd("let g:ntrw_liststyle=3")
local opt = vim.opt;

opt.relativenumber = true
opt.number = true

opt.wrap = false        -- Impedir que una linea se divida en varias si no cabe en pantalla

-- tabs e identacion
opt.tabstop = 2         -- Dos espacios como tabs (prettier default)
opt.shiftwidth = 2      -- 2 espacios como largo de identacion
opt.expandtab = true    -- Expandir tabs como espacios
opt.autoindent = true   -- Copiar indentacion de la linea actual cuando se crea una nueva

-- Ajustes de busqueda
opt.ignorecase = true   -- Ignorar mayusculas o minusculas al buscar
opt.smartcase = true    -- Si intercalamos mayusculas y minusculas entonces se asume el case-sensisitve

-- opt.cursorline = true    -- Colocar una linea que resalta la linea donde se encuentra el cursor

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start" -- no se

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true   -- Split vertical por defecto se va a la derecha
opt.splitbelow = true   -- Split horizontal por defecto se va hacia abajo
