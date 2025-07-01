-- local is_in_blame = false
local is_in_diff = false

local M = {}

-- M.toggle_blame = function()
--   if is_in_blame then
--     vim.cmd('wincmd h') -- make sure cursor is in the very left
--     vim.cmd('wincmd q')
--     is_in_blame = false
--   else
--     require('gitsigns').blame()
--     is_in_blame = true
--   end
-- end

M.toggle_diff = function()
  if is_in_diff then
    vim.cmd('wincmd p | q')
    is_in_diff = false
  else
    require('gitsigns').diffthis()
    is_in_diff = true
  end
end

return M
