return {
  {
    'SmiteshP/nvim-navic',
    config = function()
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
      vim.g.navic_silence = true
    end,
  },
}
