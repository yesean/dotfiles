local M = {}

---@class ThemePickerConfig
---@field prompt_title string
---@field save_path string

---@type ThemePickerConfig
local _config = {
  prompt_title = 'Theme Picker',
  save_path = vim.fn.stdpath('data') .. '/theme-picker/colorscheme',
}

---@return string?
local function read_saved()
  if vim.fn.filereadable(_config.save_path) == 1 then
    local colorscheme_name = vim.fn.readfile(_config.save_path)[1]
    return colorscheme_name ~= '' and colorscheme_name or nil
  end
end

---@param colorscheme_name string
local function apply_colorscheme(colorscheme_name)
  pcall(vim.cmd.colorscheme, colorscheme_name)
end

---@param colorscheme_name string
local function persist_colorscheme(colorscheme_name)
  vim.fn.mkdir(vim.fn.fnamemodify(_config.save_path, ':h'), 'p')
  vim.fn.writefile({ colorscheme_name }, _config.save_path)
end

---@param opts ThemePickerConfig?
function M.setup(opts)
  _config = vim.tbl_deep_extend('force', _config, opts or {})

  local saved_colorscheme_name = read_saved()
  if saved_colorscheme_name then
    apply_colorscheme(saved_colorscheme_name)
  end
end

function M.open_picker()
  local colorscheme_names = vim.fn.getcompletion('', 'color')

  local prev_colorscheme = vim.g.colors_name
  local prev_background = vim.o.background

  local is_confirmed = false

  local function revert_colorscheme()
    vim.o.background = prev_background
    apply_colorscheme(prev_colorscheme)
  end

  ---@param colorscheme_name string
  local function preview_colorscheme(colorscheme_name)
    -- Reset background before each preview to prevent light/dark state from bleeding between themes.
    vim.o.background = prev_background
    apply_colorscheme(colorscheme_name)
  end

  local action_state = require('telescope.actions.state')
  local picker = require('telescope.pickers').new(
    require('telescope.themes').get_dropdown({ previewer = false }),
    {
      prompt_title = _config.prompt_title,
      finder = require('telescope.finders').new_table({
        results = colorscheme_names,
      }),
      sorter = require('telescope.config').values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        local actions = require('telescope.actions')
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          if entry == nil then
            return
          end

          is_confirmed = true
          actions.close(prompt_bufnr)
          persist_colorscheme(entry.value)
        end)
        return true
      end,
    }
  )

  -- Override set_selection to preview the colorscheme live as the cursor moves through the list.
  local base_set_selection = picker.set_selection
  picker.set_selection = function(self, row)
    base_set_selection(self, row)
    local entry = action_state.get_selected_entry()
    if entry then
      preview_colorscheme(entry.value)
    end
  end

  -- Override close_windows to revert to the original colorscheme if the picker is closed without confirming.
  local base_close_windows = picker.close_windows
  picker.close_windows = function(status)
    base_close_windows(status)
    if not is_confirmed then
      revert_colorscheme()
    end
  end

  picker:find()
end

return M
