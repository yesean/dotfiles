return {
  {
    'ggandor/leap.nvim',
    opts = {
      case_sensitive = false,
    },
    config = function(_, opts)
      local leap = require('leap')

      leap.set_default_keymaps()
      leap.setup(opts)
      local function leap_bidirectional()
        leap.leap({ target_windows = { vim.api.nvim_get_current_win() } })
      end

      require('mapping').n('s', leap_bidirectional)
    end,
  },
}
