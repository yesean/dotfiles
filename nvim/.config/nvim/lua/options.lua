-- options
local o = vim.o
o.ignorecase = true -- when searching, ignore case
o.smartcase = true -- when searching, apply case if uppercase is specified
o.timeoutlen = 300 -- reduce esc delay (mapping delay)
o.ttimeoutlen = 0 -- reduce esc delay (keycode delay)
o.backspace = 'indent,eol,start' -- enables backspace in insert
o.mouse = 'a' -- enable mouse support
o.scrolloff = 15 -- start scrolling 15 lines from edge
o.sidescrolloff = 30 -- start scrolling 15 lines from edge
o.hlsearch = false -- turn off search highlighting
o.hidden = true -- hides all buffers in background
o.splitright = true -- open vertical splits to the right
o.splitbelow = true -- open horizontal splits below
o.relativenumber = true -- display relative line number
o.number = true -- display current line number
o.colorcolumn = '80' -- column 80 highlight
o.wrap = false -- turn off word wrapping
o.signcolumn = 'yes' -- add extra left column for messages
o.tabstop = 2 -- set tabs to 2 spaces
o.softtabstop = 2 -- set <tab>/<backspace> presses to 2 spaces
o.shiftwidth = 2 -- set shift indent to 2 spaces
o.expandtab = true -- convert tabs to spaces
o.autoindent = true -- maintains indent from prev line
o.smartindent = true -- intelligently indents based on prev line
o.swapfile = false -- creates new buffer without swap file
o.undofile = true -- use permanent undo file
o.termguicolors = true
o.cmdheight = 0

-- globals
local g = vim.g

g.tex_flavor = 'latex' -- set default ft as tex
