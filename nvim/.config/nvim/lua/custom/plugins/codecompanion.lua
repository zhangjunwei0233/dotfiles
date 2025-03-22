return {
  'olimorris/codecompanion.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    -- NOTE: keys are added in init.lua
    --
    -- { '<leader>ti', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[t]oggle a[i]' } },
    -- { '<leader>is', '<cmd>CodeCompanionChat Add<cr>', { mode = 'v', desc = 'a[i] add selected codes' } },
    -- { '<leader>ia', '<cmd>CodeCompanionActions<cr>', { mode = { 'v', 'n' }, desc = 'a[i] [a]ctions' } },
    -- { '<leader>ii', ':CodeCompanion', { desc = 'a[i] [i]nline' } },
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
