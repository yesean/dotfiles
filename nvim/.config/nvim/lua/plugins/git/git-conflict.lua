return {
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = { 'BufRead' },
    opts = {
      default_mappings = {
        prev = '[x',
        next = ']x',
      },
    },
    config = true,
  },
}
