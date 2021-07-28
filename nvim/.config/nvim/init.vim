set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vim/vimrc

" initialize plugins
lua << EOF
require('nvim-web-devicons').setup { default = true }
require('nvim-treesitter.configs').setup { ensure_installed = "maintained", highlight = { enable = true } }
require('nvim-autopairs').setup()
require('nvim-autopairs.completion.compe').setup({
map_cr = true, --  map <CR> on insert mode
map_complete = true -- it will auto insert `(` after select function or method item
})
require('nvim-ts-autotag').setup()
require('gitsigns').setup()
require('lualine').setup({
options = {
  theme = 'onedark'
  }
})
local actions = require('telescope.actions')
require('telescope').setup({
defaults = {
  vimgrep_arguments = {
    'rg',
    '--color=never',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--column',
    '--smart-case',
    '--hidden'
    }
  }
})
require('compe').setup({
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
    };
  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    };
  })
EOF

" nvim-lspconfig key bindings and attach them to the lsp
lua << EOF
local on_attach = function(client, bufnr)
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local opts = { noremap=true, silent=true }
buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<space>ql', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
end

-- attach mappings to lsp once client attaches
local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')
local lspinstall = require('lspinstall')

local function setup_servers()
lspinstall.setup()
local servers = lspinstall.installed_servers()
for _, lsp in ipairs(servers) do
  local config = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
      }
    }

  -- modify typescript lsp setup to allow curr dir as project root
  if lsp == 'typescript' then
    config.root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git", vim.loop.cwd())
  end

  nvim_lsp[lsp].setup(config)
end
end

setup_servers()
EOF

" telescope key bindings
nnoremap <C-p> <cmd>lua       require('telescope.builtin').find_files({ find_command = { 'fd', '--hidden', '--follow', '--exclude' ,'{.git,node_modules,games}' } })<cr>
nnoremap <leader>f <cmd>lua   require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua  require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua  require('telescope.builtin').help_tags()<cr>

" nvim-compe key bindings
inoremap <silent><expr> <C-p>     compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" configure kommetary.nvim to provide different commenting for JSX
lua << EOF
--[[ This is our custom function for toggling comments with a custom commentstring,
it's based on the default toggle_comment, but before calling the function for
toggling ranges, it sets the commenstring to something else. After it is done,
it sets it back to what it was before. ]]
function toggle_comment_custom_commentstring(...)
  local args = {...}
  -- Save the current value of commentstring so we can restore it later
  local commentstring = vim.bo.commentstring
  -- Set the commentstring for the current buffer to something new
  vim.bo.commentstring =  "{/*%s*/}"
  --[[ Call the function for toggling comments, which will resolve the config
  to the new commentstring and proceed with that. ]]
  require('kommentary.kommentary').toggle_comment_range(args[1], args[2],
  require('kommentary.config').get_modes().normal)
  -- Restore the original value of commentstring
  vim.api.nvim_buf_set_option(0, "commentstring", commentstring)
end
-- Set the extra mapping for toggling a single line in normal mode
vim.api.nvim_set_keymap('n', 'gjj',
'<cmd>lua require("kommentary");kommentary.go(' .. require('kommentary.config').context.line .. ', '
.. "'toggle_comment_custom_commentstring'" .. ')<cr>',
{ noremap = true, silent = true })
-- Set the extra mapping for toggling a range with a motion
vim.api.nvim_set_keymap('n', 'gj',
'v:lua.kommentary.go(' .. require('kommentary.config').context.init .. ', ' ..
"'toggle_comment_custom_commentstring'" .. ')',
{ noremap = true, expr = true })
-- Set the extra mapping for toggling a range with a visual selection
vim.api.nvim_set_keymap('v', 'gj',
'<cmd>lua require("kommentary");kommentary.go(' .. require('kommentary.config').context.visual .. ', '
.. "'toggle_comment_custom_commentstring'" .. ')<cr>',
{ noremap = true, silent = true })
EOF
