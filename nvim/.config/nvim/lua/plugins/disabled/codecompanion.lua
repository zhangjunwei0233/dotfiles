return {
  'olimorris/codecompanion.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = require('core.keymaps').codecompanion,
  opts = {
    adapters = {
      deepseek = function()
        return require('codecompanion.adapters').extend('deepseek', {
          env = {
            api_key = 'cmd: gpg --batch --quiet --decrypt ~/API/deepseek.gpg',
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
}
