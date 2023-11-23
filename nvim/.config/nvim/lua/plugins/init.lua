local function merge_arrays(...)
  local merged = {}
  for _, array in ipairs(...) do
    vim.list_extend(merged, array)
  end

  return merged
end

return merge_arrays(
  require('plugins.autocomplete'),
  require('plugins.buffer'),
  require('plugins.editing'),
  require('plugins.language-support'),
  require('plugins.session'),
  require('plugins.snippets'),
  require('plugins.syntax'),
  require('plugins.telescope'),
  require('plugins.terminal'),
  require('plugins.ui'),
  { require('plugins.colorscheme.colorscheme').selected_colorscheme }
)
