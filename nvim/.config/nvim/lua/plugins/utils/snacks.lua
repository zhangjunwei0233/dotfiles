-- [[ tools packs including terminal, lazygit, window manangement, ...]]
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  enabled = true,
  ---@type snacks.Config
  opts = {
    indent = {
      indent = {
        char = ' ',
        only_scope = true,
        only_current = true,
        hl = {
          'SnacksIndent1',
          'SnacksIndent2',
          'SnacksIndent3',
          'SnacksIndent4',
          'SnacksIndent5',
          'SnacksIndent6',
          'SnacksIndent7',
          'SnacksIndent8',
        },
      },
      animate = {
        duration = {
          step = 10,
          duration = 100,
        },
      },
      scope = {
        enabled = true, -- enable highlighting the current scope
        priority = 200,
        char = '┊',
        underline = false, -- underline the start of the scope
        only_current = true, -- only show scope in the current window
        hl = { -- can be a list of hl groups to cycle through
          'SnacksIndent1',
          'SnacksIndent2',
          'SnacksIndent3',
          'SnacksIndent4',
          'SnacksIndent5',
          'SnacksIndent6',
          'SnacksIndent7',
          'SnacksIndent8',
        },
      },
    },
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
