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
  config = function(_, opts)
    require('codecompanion').setup(opts)

    -- load keymaps
    require('core.utils').load_plugin_keymaps('codecompanion')
  end,
}
