return {
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      pre_save_cmds = { 'Neotree close' },
    },
    config = function(_, opts)
      vim.o.sessionoptions =
        'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

      require('auto-session').setup(opts)
    end,
  },
}
