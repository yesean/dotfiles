return {
  {
    'folke/neodev.nvim',
    opts = {
      override = function(root_dir, options)
        -- enable neodev.nvim inside ~/.dotfiles
        if root_dir:find('dotfiles') then
          options.enabled = true
          options.runtime = true
          options.types = true
          options.plugins = true
        end
      end,
    },
  },
}
