local utils = require('utils')

return {
  {
    'nvim-telescope/telescope.nvim',
    cond = not utils.is_vscode,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    opts = function()
      local live_grep_args_actions = require('telescope-live-grep-args.actions')

      return {
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
          lsp_code_actions = {
            layout_config = {
              prompt_position = 'bottom',
            },
          },
        },
        extensions = {
          live_grep_args = {
            search_dirs = { 'nvim/.config' },
            auto_quoting = true,
            mappings = {
              i = {
                ['<c-k>'] = live_grep_args_actions.quote_prompt(),
                ['<c-h>'] = live_grep_args_actions.quote_prompt({
                  postfix = ' --hidden ',
                }),
                ['<c-i>'] = live_grep_args_actions.quote_prompt({
                  postfix = ' --iglob **',
                }),
                ['<c-l>'] = live_grep_args_actions.quote_prompt({
                  postfix = ' --hidden --iglob **',
                }),
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local map = require('mapping')
      local builtin = require('telescope.builtin')
      local extensions = require('telescope').extensions

      -- telescope key bindings
      map.n('<leader>t', map.cmd('Telescope'))
      map.n('<c-p>', builtin.find_files, { desc = 'find files' })
      map.n(
        '<c-f>',
        extensions.live_grep_args.live_grep_args,
        { desc = 'find phrase' }
      )
      map.n('gk', builtin.keymaps, { desc = 'show keymaps' })
      map.n('gm', builtin.git_status, { desc = 'show modified files' })
      map.n('gl', builtin.git_bcommits, { desc = 'show git commits' })

      require('telescope').setup(opts)
      require('telescope').load_extension('live_grep_args')
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
