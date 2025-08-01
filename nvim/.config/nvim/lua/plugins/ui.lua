local colorschemes = require('colorschemes')
local map = require('mapping')
local utils = require('utils')

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
  { 'folke/snacks.nvim' },
  {
    'lukas-reineke/indent-blankline.nvim',
    cond = not utils.is_vscode,
    main = 'ibl',
    opts = {
      scope = { enabled = false },
      exclude = { filetypes = { 'dashboard', 'lazy' } },
    },
  },
  {
    'echasnovski/mini.indentscope',
    cond = not utils.is_vscode,
    version = '*',
    opts = { try_as_border = true },
    config = function(opts)
      vim.api.nvim_create_autocmd({ 'Filetype' }, {
        pattern = { 'dashboard', 'toggleterm' },
        callback = function()
          ---@diagnostic disable-next-line: inject-field
          vim.b.miniindentscope_disable = true
        end,
      })
      require('mini.indentscope').setup(opts)
    end,
  },
  {
    'rktjmp/highlight-current-n.nvim',
    config = function()
      local hcn = require('highlight_current_n')
      vim.keymap.set('n', 'n', hcn.n)
      vim.keymap.set('n', 'N', hcn.N)
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
    branch = 'main',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
      { 'MunifTanjim/nui.nvim' },
    },
    opts = function()
      return {
        close_if_last_window = true,
        event_handlers = {
          {
            event = 'neo_tree_popup_input_ready',
            handler = function(args)
              vim.keymap.set(
                'i',
                '<esc>',
                vim.cmd.stopinsert,
                { noremap = true, buffer = args.bufnr }
              )
            end,
          },
        },
        filesystem = {
          filtered_items = { hide_dotfiles = false, hide_gitignored = false },
          follow_current_file = { enabled = true, leave_dirs_open = true },
          hijack_netrw_behavior = 'open_current',
        },
        window = {
          position = 'right',
          width = 60,
          mappings = {
            ['<space>'] = 'none',
            ['<cr>'] = function(state)
              local commands = require('neo-tree.sources.filesystem.commands')
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
      map.n('<leader>n', map.cmd('Neotree toggle'))
      require('neo-tree').setup(opts)
    end,
  },
  {
    'rachartier/tiny-code-action.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    event = 'LspAttach',
    config = function()
      require('tiny-code-action').setup()
    end,
  },
  {
    'catgoose/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  { 'rcarriga/nvim-notify' },
  {
    'petertriho/nvim-scrollbar',
    cond = not utils.is_vscode,
    config = function()
      require('scrollbar').setup()
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { { 'kevinhwang91/promise-async' } },
    opts = {
      fold_virt_text_handler = utils.fold_virt_text_handler,
    },
    config = function(_, opts)
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

      map.n('zR', require('ufo').openAllFolds)
      map.n('zM', require('ufo').closeAllFolds)
      require('ufo').setup(opts)
    end,
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
              name = { 'Diagnostic' },
              maxwidth = 2,
              auto = true,
            },
          },
          { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
          { sign = { namespace = { 'gitsigns' } } },
        },
      }
    end,
  },
  -- lazy.nvim
  {
    'folke/noice.nvim',
    cond = not utils.is_vscode,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        hover = { silent = true },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
}
