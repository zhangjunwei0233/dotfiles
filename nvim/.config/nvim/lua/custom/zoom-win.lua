-- [[ Zoom in window using snacks_win ]]
local snacks_win = nil
local disabled_zoom_ft = { 'sagaoutline' }

local M = function()
  local current_win = vim.api.nvim_get_current_win()
  -- return on disabled_ft
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
  for _, type in ipairs(disabled_zoom_ft) do
    if ft == type then
      return
    end
  end
  -- Close if already in snacks window
  if snacks_win and snacks_win:win_valid() and snacks_win.win == current_win then
    snacks_win:close()
    snacks_win = nil
    return
  end
  -- Close previous instance
  if snacks_win and snacks_win:win_valid() then
    snacks_win:close()
    snacks_win = nil
  end
  -- Get current buffer from active window
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  -- Create window with current buffer
  snacks_win = require('snacks').win({
    buf = current_buf,
    width = 0.99,
    height = 0.99,
    border = 'rounded',
    wo = {
      spell = false,
      wrap = false,
      number = true,
      relativenumber = true,
      scrollbind = true,
      cursorbind = true,
    },
    on_win = function()
      vim.wo[current_win].scrollbind = true
      vim.wo[current_win].cursorbind = true
    end,
    on_close = function()
      vim.wo[current_win].scrollbind = false
      vim.wo[current_win].cursorbind = false
    end,
  })
end

return M
