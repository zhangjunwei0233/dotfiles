-- [[ better navigation using 'f' and 'F' ]]
return {
  'smoka7/hop.nvim',
  version = '*',
  opts = {
    keys = 'fjdklseitovxqpygbzhcuran',
    quit_key = '<ESC>',
    jump_on_sole_occurrence = true,
    create_hl_autocmd = false, -- Better performance
  },
  config = function(_, opts)
    require('hop').setup(opts)

    -- load keymaps
    require('core.utils').load_plugin_keymaps('hop')
  end,
}
