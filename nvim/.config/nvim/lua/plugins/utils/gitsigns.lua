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
    require('core.utils').load_plugin_keymaps('gitsigns')
  end,
}
