-- [[ Zoom in window using snacks_win ]]
local snacks_win = nil
local original_win = nil
local disabled_zoom_ft = { sagaoutline = true } -- Use set for O(1) lookup

local function cleanup_zoom()
  if snacks_win and snacks_win:win_valid() then
    snacks_win:close()
  end
  snacks_win = nil
  original_win = nil
end

local function is_window_valid(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local M = function()
  local current_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  -- Validate buffer
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  -- Check disabled filetypes (using modern API)
  local ft = vim.bo[buf].filetype
  if disabled_zoom_ft[ft] then
    return
  end

  -- Close if already in zoom window
  if snacks_win and snacks_win:win_valid() and snacks_win.win == current_win then
    cleanup_zoom()
    return
  end

  -- Close previous instance
  if snacks_win then
    cleanup_zoom()
  end

  -- Store original window reference
  original_win = current_win

  -- Inherit useful window options from original window
  local original_wo = vim.wo[current_win]

  -- Create zoom window with error handling
  local ok, win = pcall(require('snacks').win, {
    buf = buf,
    width = 0.99,
    height = 0.99,
    border = 'rounded',
    wo = {
      spell = original_wo.spell,
      wrap = original_wo.wrap,
      number = original_wo.number,
      relativenumber = original_wo.relativenumber,
      scrollbind = true,
      cursorbind = true,
    },
    on_win = function()
      -- Only set binding if original window is still valid
      if is_window_valid(original_win) then
        vim.wo[original_win].scrollbind = true
        vim.wo[original_win].cursorbind = true
      end
    end,
    on_close = function()
      -- Clean up binding on original window if it still exists
      if is_window_valid(original_win) then
        vim.wo[original_win].scrollbind = false
        vim.wo[original_win].cursorbind = false
      end
      -- Clean up module state
      snacks_win = nil
      original_win = nil
    end,
  })

  if ok then
    snacks_win = win
  else
    vim.notify('Failed to create zoom window: ' .. tostring(win), vim.log.levels.ERROR)
    cleanup_zoom()
  end
end

return M
