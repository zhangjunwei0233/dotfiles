-- [[ Core utility functions ]]

local M = {}

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

-- Setup keymaps for non-plugin entries (like 'native' and 'lsp')
-- plugin entries are already handled by lazy.nvim
-- @param plugin_name: string - The plugin name to load keymaps for
M.setup_keymaps = function(plugin_name)
  local keymaps = require('core.keymaps')[plugin_name]
  if not keymaps then
    vim.notify(plugin_name .. ' keymaps not found\n', vim.log.levels.WARN)
    return
  end

  for _, keymap in ipairs(keymaps) do
    local lhs = keymap[1]
    local rhs = keymap[2]
    local mode = keymap.mode or 'n'

    -- Extract options (everything except lhs, rhs, mode)
    local opts = {}
    for k, v in pairs(keymap) do
      if k ~= 1 and k ~= 2 and k ~= 'mode' then
        opts[k] = v
      end
    end

    -- Set defaults
    if opts.noremap == nil then
      opts.noremap = true
    end
    if opts.silent == nil then
      opts.silent = true
    end

    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

return M
