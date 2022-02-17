vim.g.firenvim_config = {
  localSettings = {
    ['.*'] = {
      selector = 'textarea, input',
      priority = 0,
      takeover = 'never',
    },
  },
}
