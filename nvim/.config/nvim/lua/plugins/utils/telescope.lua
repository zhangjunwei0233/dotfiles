-- [[ Telescope: another fuzzy finder, use alongside with snacks.picker ]]
return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() -- enable when have make
        return vim.fn.executable('make') == 1
      end,
    },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  keys = require('core.keymaps').telescope,
  config = function()
    require('telescope').setup({
      -- defaults = {},
      -- pickers = {},
      extensions = {
        persisted = {
          layout_config = { width = 0.55, height = 0.55 },
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'persisted')

    -- load autocmds
    require('core.utils').load_plugin_autocmds('telescope')
  end,
}
