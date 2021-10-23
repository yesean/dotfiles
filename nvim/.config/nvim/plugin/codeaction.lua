-- check if lightbulb is available at cursor position
vim.cmd(
  [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
)
