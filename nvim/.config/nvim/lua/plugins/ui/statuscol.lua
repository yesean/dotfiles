return {
  {
    'luukvbaal/statuscol.nvim',
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
}
