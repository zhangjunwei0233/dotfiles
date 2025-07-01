-- [[ signs for git ]]
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
  },
  config = function(_, opts)
    require('gitsigns').setup(opts)

    -- load keymaps
    local keymaps = require('core.keymaps').gitsigns
    if keymaps then
      keymaps()
    else
      vim.notify('gitsigns loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
