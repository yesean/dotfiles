return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      defaults = {
        layout_strategy = 'flex',
        layout_config = {
          width = 0.85,
          height = 0.85,
          vertical = {
            prompt_position = 'top',
          },
          horizontal = {
            prompt_position = 'bottom',
          },
          flex = {
            flip_columns = 220,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = {
            '--hidden',
            '--glob',
            '!*.lock',
            '--glob',
            '!.git/*',
          },
        },
        lsp_code_actions = {
          layout_config = {
            prompt_position = 'bottom',
          },
        },
      },
    },
    config = function(_, opts)
      local map = require('mapping')
      local builtin = require('telescope.builtin')

      -- telescope key bindings
      map.n('<leader>t', map.cmd('Telescope'))
      map.n('<c-p>', builtin.find_files, { desc = 'find files' })
      map.n('<c-f>', builtin.live_grep, { desc = 'find phrase' })
      map.n('gk', builtin.keymaps, { desc = 'show keymaps' })
      map.n('gm', builtin.git_status, { desc = 'show modified files' })
      map.n('gl', builtin.git_bcommits, { desc = 'show git commits' })

      require('telescope').setup(opts)
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    build = {
      'make',
    },
  },
}
