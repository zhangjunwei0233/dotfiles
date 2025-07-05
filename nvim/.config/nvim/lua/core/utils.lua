-- [[ Core utility functions ]]

local M = {}

-- Load plugin keymaps with consistent error handling
-- @param plugin_name: string - The plugin name to load keymaps for
M.load_plugin_keymaps = function(plugin_name)
  local keymaps = require('core.keymaps')[plugin_name]
  if keymaps then
    keymaps()
  else
    vim.notify(plugin_name .. ' loaded without keymap\n', vim.log.levels.WARN)
  end
end

-- Load plugin autocmds with consistent error handling
-- @param plugin_name: string - The plugin name to load autocmds for
M.load_plugin_autocmds = function(plugin_name)
  local autocmds = require('core.autocmds')[plugin_name]
  if autocmds then
    autocmds()
  else
    vim.notify(plugin_name .. ' loaded without autocmds\n', vim.log.levels.WARN)
  end
end

return M
