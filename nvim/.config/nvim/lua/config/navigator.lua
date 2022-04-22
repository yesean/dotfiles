local map = require('mapping')

require('Navigator').setup()
map.n('<m-h>', map.cmd('NavigatorLeft'))
map.n('<m-l>', map.cmd('NavigatorRight'))
map.n('<m-k>', map.cmd('NavigatorUp'))
map.n('<m-j>', map.cmd('NavigatorDown'))
map.n('<m-p>', map.cmd('NavigatorPrevious'))
