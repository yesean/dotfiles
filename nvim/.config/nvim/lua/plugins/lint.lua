return {
  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        lua = { 'luacheck' },
        cpp = { 'cppcheck', 'cpplint' },
        python = { 'pylint' },
        docker = { 'hadolint' },
        tex = { 'chktex' },
        markdown = { 'markdownlint', 'vale' },
        ['*'] = { 'write_good' },
      },
      linters = { luacheck = { args = { '--globals', 'vim' } } },
    },
    config = function(_, opts)
      require('lint').linters_by_ft = opts.linters_by_ft
      require('lint').linters = opts.linters
      vim.api.nvim_create_autocmd(
        { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
        {
          callback = function()
            require('lint').try_lint()
          end,
        }
      )
    end,
  },
}
