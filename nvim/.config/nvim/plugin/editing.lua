local map = require('mapping')

-- automatically close bracket like items
require('nvim-autopairs').setup()

-- automatically close tags
require('nvim-ts-autotag').setup()

-- preview colors
require('colorizer').setup()

-- setup lightspeed
require('lightspeed').setup({
  ignore_case = true,
})

map.n('s', '<Plug>Lightspeed_omni_s')
map.n('gs', '<Plug>Lightspeed_omni_gs')
