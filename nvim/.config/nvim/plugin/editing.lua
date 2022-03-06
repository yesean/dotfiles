local maps = require('maps')

-- automatically close bracket like items
require('nvim-autopairs').setup()

-- automatically close tags
require('nvim-ts-autotag').setup()

-- preview colors
require('colorizer').setup()

-- toggle trouble
maps.n('<leader>,', '<cmd>TroubleToggle workspace_diagnostics<cr>')
