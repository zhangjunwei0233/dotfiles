-- [[ better navigation using 'f' and 'F' ]]
return {
  'smoka7/hop.nvim',
  version = '*',
  keys = require('core.keymaps').hop,
  opts = {
    keys = 'fjdklseitovxqpygbzhcuran',
    quit_key = '<ESC>',
    jump_on_sole_occurrence = true,
    create_hl_autocmd = false, -- Better performance
  },
}
