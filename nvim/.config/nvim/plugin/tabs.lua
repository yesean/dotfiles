local maps = require('mapping')
local mappings = require('cokeline.mappings')
local utils = require('cokeline.utils')

local components = {
  {
    text = function(buffer)
      local is_picking = mappings.is_picking_focus()
        or mappings.is_picking_close()
      return is_picking and buffer.pick_letter .. ' '
        or ' ' .. buffer.devicon.icon
    end,
    fg = function(buffer)
      return buffer.devicon.color
    end,
  },
  {
    text = function(buffer)
      return buffer.unique_prefix
    end,
    fg = utils.get_hex('Comment', 'fg'),
    style = 'italic',
  },
  {
    text = function(buffer)
      return buffer.filename .. ' '
    end,
  },
  {
    text = '',
    delete_buffer_on_left_click = true,
  },
  {
    text = ' ',
  },
}

require('cokeline').setup({
  components = components,
  buffers = {
    focus_on_delete = 'prev',
  },
  sidebar = {
    filetype = 'neo-tree',
    components = {
      {
        text = 'F   iles',
        fg = vim.g.terminal_color_3,
        bg = utils.get_hex('NeoTreeNormal', 'bg'),
        style = 'bold',
      },
    },
  },
})

function Close_Buffer(buf)
  pcall(function()
    vim.api.nvim_buf_delete(buf, {})
  end)
  vim.cmd('redrawtabline')
end

function Close_All_Buffers(keep_current)
  keep_current = keep_current or false
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) ~= 0 then
      local current_buf_name = vim.fn.bufname('%')
      if not keep_current or vim.fn.bufname(buf) ~= current_buf_name then
        Close_Buffer(buf)
      end
    end
  end
end

maps.n('<c-h>', '<Plug>(cokeline-focus-prev)', { silent = true })
maps.n('<c-l>', '<Plug>(cokeline-focus-next)', { silent = true })
maps.n('gq', ':lua Close_Buffer(0)<cr>', { silent = true })
maps.n('gqq', ':lua Close_All_Buffers()<cr>', { silent = true })
maps.n('gqw', ':lua Close_All_Buffers(true)<cr>', { silent = true })
