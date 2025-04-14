return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  enabled = true,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
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
    require('custom.keymaps').terminal()
  end,
}
