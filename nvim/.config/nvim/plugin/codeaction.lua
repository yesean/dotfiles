-- check if lightbulb is available at cursor position
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  callback = function()
    require('nvim-lightbulb').update_lightbulb()
  end,
})
