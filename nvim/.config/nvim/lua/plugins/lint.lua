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
        ['markdown.mdx'] = {},
        ['*'] = { 'write_good' },
      },
      linters = {
        luacheck = { args = { '--globals', 'vim' } },
      },
    },
    config = function(_, opts)
      local lint = require('lint')

      -- override default linter configs
      lint.linters_by_ft = opts.linters_by_ft
      for linter, config in pairs(opts.linters) do
        lint.linters[linter].args = config.args
      end

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
