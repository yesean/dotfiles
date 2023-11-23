local is_nvim = vim.g.vscode == nil

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function()
      return {
        ensure_installed = 'all',
        highlight = {
          enable = is_nvim,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
        },
        matchup = {
          enable = true,
        },
      }
    end,
    config = function(_, opts)
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.o.foldenable = false

      local function resetHighlighting()
        local buffer = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false))
        local is_buffer_empty = buffer == ''
        if
          vim.bo.buftype == ''
          and not vim.bo.readonly
          and not is_buffer_empty
          and is_nvim
        then
          vim.cmd.w()
          vim.cmd.e()
          vim.cmd.TSBufEnable('highlight')
        end
      end

      -- highlighting fix, restart treesitter when opening a new file
      vim.api.nvim_create_autocmd(
        { 'VimEnter' },
        { callback = resetHighlighting }
      )

      -- always use jsonc parser
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = '*.json',
        callback = function()
          vim.bo.filetype = 'jsonc'
          resetHighlighting()
        end,
      })

      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
