-- [[ outline of current file, supported by LSP ]]
return {
  'hedyhli/outline.nvim',
  lazy = true,
  keys = require('core.keymaps').outline,
  cmd = { 'Outline', 'OutlineOpen' },
  opts = {
    -- Your setup opts here
  },
}
