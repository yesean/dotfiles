local opts = {
  root_dir = function(fname)
    local project_root = require('lspconfig.server_configurations.tsserver').default_config.root_dir(fname)
    return project_root or vim.fn.getcwd()
  end,
}

return { opts = opts }
