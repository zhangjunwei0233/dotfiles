-- trouble is another lsp enhancement plugin that works just like lspsaga
-- currently only using its quickfix feature since it's better than lspsaga
return {
  'folke/trouble.nvim',
  opts = {
    preview = {
      type = 'split',
      relative = 'win',
      position = 'right',
      size = 0.5,
    },
  },
  cmd = 'Trouble',
  keys = require('core.keymaps')['trouble'],
  config = function(_, opts)
    require('trouble').setup(opts)

    vim.api.nvim_set_hl(0, 'TroubleNormal', { link = 'NormalFloat' })
  end,
}
