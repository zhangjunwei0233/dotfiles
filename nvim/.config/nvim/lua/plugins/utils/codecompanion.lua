return {
  'olimorris/codecompanion.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    adapters = {
      deepseek = function()
        return require('codecompanion.adapters').extend('deepseek', {
          env = {
            api_key = 'sk-dc983f8c46eb47139c1233e1f62511d3',
          },
        })
      end,
    },
    strategies = {
      chat = { adapter = 'deepseek' },
      inline = { adapter = 'deepseek' },
      agent = { adapter = 'deepseek' },
    },
  },
  config = function(_, opts)
    require('codecompanion').setup(opts)

    -- load keymaps
    local keymaps = require('core.keymaps').codecompanion
    if keymaps then
      keymaps()
    else
      vim.notify('codecompanion loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
