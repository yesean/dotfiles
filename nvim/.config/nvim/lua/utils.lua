local M = {}

function M.merge_lists(...)
  local merged = {}
  for _, list in ipairs({ ... }) do
    merged = vim.list_extend(merged, list)
  end

  return merged
end

return M
