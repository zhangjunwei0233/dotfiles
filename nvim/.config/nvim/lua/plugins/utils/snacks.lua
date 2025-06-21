-- [[ tools packs including terminal, lazygit, window manangement, ...]]
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  enabled = true,
  ---@type snacks.Config
  opts = {
    lazygit = { enabled = true },
    terminal = {
      enabled = true,
      win = {
        relative = 'editor',
        wo = { winbar = '' }, -- disable winbar
      },
    },
  },
  config = function(_, opts)
    require('snacks').setup(opts)

    -- setup kemaps
    local keymaps = require('core.keymaps').snacks
    if keymaps then
      keymaps()
    else
      vim.notify('snacks loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
