-- [[ Neotree: a file explorer ]]
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    open_files_do_not_replace_types = {
      'snacks_terminal',
      'codecompanion',
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)

    -- load keymaps
    require('core.utils').load_plugin_keymaps('neo-tree')
  end,
}
