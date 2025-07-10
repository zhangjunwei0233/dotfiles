-- [[ LSP Package Manager]]
return {
  'mason-org/mason.nvim',
  event = { 'VimEnter', 'BufReadPost', 'BufNewFile' },
  keys = require('core.keymaps').mason,
  opts = {},
}
