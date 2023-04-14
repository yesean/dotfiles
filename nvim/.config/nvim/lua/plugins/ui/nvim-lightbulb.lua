return {
  {
    'kosayoda/nvim-lightbulb',
    opts = {
      autocmd = { enabled = true },
    },
    config = function(_, opts)
      require('nvim-lightbulb').setup(opts)
    end,
  },
}
