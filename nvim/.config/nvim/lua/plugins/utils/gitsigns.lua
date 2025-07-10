-- [[ signs for git ]]
return {
  'lewis6991/gitsigns.nvim',
  keys = require('core.keymaps').gitsigns,
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
  },
}
