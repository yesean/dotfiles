-- catppuccin
if vim.g.vscode == nil then
  require('catppuccin').setup({
    styles = {
      variables = 'NONE',
    },
  })
  vim.cmd('colorscheme catppuccin')
end
