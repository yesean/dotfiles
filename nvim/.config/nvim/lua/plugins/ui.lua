local colorschemes = require('colorschemes')
local map = require('mapping')

return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'folke/persistence.nvim' },
    },
    opts = function()
      return {
        theme = 'hyper',
        config = {
          week_header = { enable = true },
          shortcut = {
            {
              icon = '󰏓 ',
              desc = 'restore session',
              key = 'r',
              group = 'DashboardShortCutIcon',
              action = require('persistence').load,
            },
          },
        },
      }
    end,
  },
  { 'stevearc/dressing.nvim', opts = { input = { insert_only = false } } },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = { enabled = false },
      exclude = { filetypes = { 'dashboard', 'lazy' } },
    },
  },
  {
    'echasnovski/mini.indentscope',
    version = '*',
    opts = { try_as_border = true },
    config = function(opts)
      vim.api.nvim_create_autocmd({ 'Filetype' }, {
        pattern = 'dashboard',
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require('mini.indentscope').setup(opts)
    end,
  },
  {
    'rktjmp/highlight-current-n.nvim',
    config = function()
      vim.keymap.set('n', 'n', '<Plug>(highlight-current-n-n)')
      vim.keymap.set('n', 'N', '<Plug>(highlight-current-n-N)')
      vim.api.nvim_create_augroup('ClearSearchHL', {})
      vim.api.nvim_create_autocmd(
        { 'CmdlineEnter' },
        { command = 'set hlsearch', group = 'ClearSearchHL' }
      )
      vim.api.nvim_create_autocmd(
        { 'CmdlineLeave' },
        { command = 'set nohlsearch', group = 'ClearSearchHL' }
      )
    end,
  },
  {
    'hoob3rt/lualine.nvim',
    dependencies = { colorschemes.selected_colorscheme },
    opts = {
      options = {
        theme = colorschemes.selected_colorscheme_name,
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            'filename',
            symbols = { modified = ' [modified]', readonly = ' [readonly]' },
            path = 1,
          },
          {
            'diagnostics',
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
          },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = function()
      local commands = require('neo-tree.sources.filesystem.commands')
      return {
        close_if_last_window = true,
        filesystem = {
          filtered_items = { hide_dotfiles = false, hide_gitignored = false },
          follow_current_file = true,
          hijack_netrw_behavior = 'open_current',
        },
        window = {
          mappings = {
            ['<space>'] = 'none',
            ['<cr>'] = function(state)
              local node = state.tree:get_node()
              if node.type == 'file' then
                commands.open(state)
              elseif node.type == 'directory' then
                commands.toggle_node(state)
              end
            end,
          },
        },
      }
    end,
    config = function(_, opts)
      local map = require('mapping')
      map.n('<leader>n', map.cmd('Neotree toggle'))
      require('neo-tree').setup(opts)
    end,
  },
  { 'weilbith/nvim-code-action-menu' },
  { 'norcalli/nvim-colorizer.lua' },
  {
    'kosayoda/nvim-lightbulb',
    opts = { autocmd = { enabled = true } },
    config = function(_, opts)
      require('nvim-lightbulb').setup(opts)
    end,
  },
  {
    'SmiteshP/nvim-navic',
    config = function()
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
      vim.g.navic_silence = true
    end,
  },
  { 'rcarriga/nvim-notify' },
  { 'petertriho/nvim-scrollbar' },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { { 'kevinhwang91/promise-async' } },
    config = function(_, opts)
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      map.n('zR', require('ufo').openAllFolds)
      map.n('zM', require('ufo').closeAllFolds)
      require('ufo').setup(opts)
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
  { 'folke/which-key.nvim', opts = {} },
  {
    'luukvbaal/statuscol.nvim',
    branch = '0.10',
    dependencies = { 'lewis6991/gitsigns.nvim' },
    opts = function()
      local builtin = require('statuscol.builtin')
      return {
        segments = {
          {
            sign = {
              name = { 'LightBulbSign', 'Diagnostic' },
              maxwidth = 2,
              auto = true,
            },
          },
          { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
          { sign = { name = { 'GitSigns' } } },
        },
      }
    end,
  },
  -- lazy.nvim
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
}
