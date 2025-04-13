return {
  'olimorris/codecompanion.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup {
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
    }
  end,
}
