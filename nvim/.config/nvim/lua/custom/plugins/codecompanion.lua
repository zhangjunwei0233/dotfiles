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
      -- display = {
      --   chat = {
      --     window = {
      --       layout = 'float',
      --       position = 'center',
      --       border = 'rounded',
      --       width = 0.9,
      --       height = 0.9,
      --       relative = 'editor',
      --       opts = {
      --         winhighlight = 'Normal:FloatBorder',
      --         wrap = true,
      --         signcolumn = 'no',
      --       },
      --     },
      --   },
      -- },
    }
    require('custom.keymaps').codecompanion()
  end,
}
