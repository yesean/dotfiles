return {
  {
    'rktjmp/highlight-current-n.nvim',
    config = function()
      vim.keymap.set('n', 'n', '<Plug>(highlight-current-n-n)')
      vim.keymap.set('n', 'N', '<Plug>(highlight-current-n-N)')
      vim.api.nvim_create_augroup('ClearSearchHL', {})
      vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
        command = 'set hlsearch',
        group = 'ClearSearchHL',
      })
      vim.api.nvim_create_autocmd({ 'CmdlineLeave' }, {
        command = 'set nohlsearch',
        group = 'ClearSearchHL',
      })
    end,
  },
}
