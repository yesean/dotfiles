local map = require('mapping')
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
        text = 'Files',
        fg = vim.g.terminal_color_3,
        bg = utils.get_hex('NeoTreeNormal', 'bg'),
        style = 'bold',
      },
    },
  },
})

function Close_Buffer(buf)
  if buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end

  local bufname = vim.api.nvim_buf_get_name(buf)
  if bufname:find('neo%-tree filesystem') then
    vim.cmd('Neotree close')
    return
  end

  local windows = vim.tbl_filter(function(w)
    return vim.api.nvim_win_get_buf(w) == buf
  end, vim.api.nvim_list_wins())
  local buffers = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  local next_buffer = -1
  if #buffers > 1 then
    for i, v in ipairs(buffers) do
      if v == buf then
        next_buffer = buffers[i % #buffers + 1]
      end
    end
  end

  if next_buffer ~= -1 then
    for _, w in ipairs(windows) do
      vim.api.nvim_win_set_buf(w, next_buffer)
    end
  end

  pcall(function()
    vim.api.nvim_buf_delete(buf, {})
  end)
  vim.cmd('redrawtabline')
end

function Close_All_Buffers(keep_current)
  keep_current = keep_current or false
  local buffers = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_is_loaded(b)
  end, vim.api.nvim_list_bufs())
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(buffers) do
    if not keep_current or buf ~= current_buf then
      Close_Buffer(buf)
    end
  end
end

map.n('<c-h>', '<Plug>(cokeline-focus-prev)')
map.n('<c-l>', '<Plug>(cokeline-focus-next)')
map.n('gq', function()
  Close_Buffer(0)
end)
map.n('gqq', Close_All_Buffers)
map.n('gqw', function()
  Close_All_Buffers(true)
end)
