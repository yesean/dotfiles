local M = {}

local _config = {
  colorschemes = nil, -- nil → falls back to vim.fn.getcompletion('', 'color')
  prompt_title = 'Theme Picker',
  persist = nil, -- file path to write the selected colorscheme name on select
}

function M.setup(opts)
  _config = vim.tbl_deep_extend('force', _config, opts or {})
end

function M.pick(opts)
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local themes = require('telescope.themes')

  local merged = vim.tbl_deep_extend('force', _config, opts or {})
  local schemes = merged.colorschemes or vim.fn.getcompletion('', 'color')

  local before_color = vim.api.nvim_exec2('colorscheme', { output = true }).output
  local before_background = vim.o.background
  local need_restore = true

  local picker = pickers.new(themes.get_dropdown({ previewer = false }), {
    prompt_title = merged.prompt_title,
    finder = finders.new_table({ results = schemes }),
    sorter = conf.generic_sorter(merged),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        if entry == nil then
          return
        end
        need_restore = false
        actions.close(prompt_bufnr)
        pcall(vim.cmd.colorscheme, entry.value)
        if merged.persist then
          vim.fn.writefile({ entry.value }, merged.persist)
        end
      end)
      return true
    end,
  })

  local orig_set_selection = picker.set_selection
  picker.set_selection = function(self, row)
    orig_set_selection(self, row)
    local entry = action_state.get_selected_entry()
    if entry then
      vim.o.background = before_background
      pcall(vim.cmd.colorscheme, entry.value)
    end
  end

  local orig_close_windows = picker.close_windows
  picker.close_windows = function(status)
    orig_close_windows(status)
    if need_restore then
      vim.o.background = before_background
      pcall(vim.cmd.colorscheme, before_color)
    end
  end

  picker:find()
end

return M
