-- [[ better navigation using 'f' and 'F' ]]
return {
  'phaazon/hop.nvim',
  opts = {
    keys = 'fjdklseitovxqpygbzhcuran',
    quit_key = '<ESC>',
    jump_on_sole_occurrence = true,
    create_hl_autocmd = false, -- Better performance
  },
  config = function(_, opts)
    require('hop').setup(opts)

    -- load keymaps
    local keymaps = require('core.keymaps').hop
    if keymaps then
      keymaps()
    else
      vim.notify('hop loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
