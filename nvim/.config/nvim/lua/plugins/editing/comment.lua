return {
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = {
      pre_hook = function(ctx)
        local u = require('Comment.utils')
        if ctx.ctype == u.ctype.line or ctx.cmotion == u.cmotion.line then
          -- only comment when we are doing linewise comment or up-down motion
          return require('ts_context_commentstring.internal').calculate_commentstring()
        end
      end,
    },
  },
}
