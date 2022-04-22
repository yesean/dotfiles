local map = require('mapping')

-- setup lightspeed
require('lightspeed').setup({
  ignore_case = true,
})

map.n('s', '<Plug>Lightspeed_omni_s')
map.n('gs', '<Plug>Lightspeed_omni_gs')
