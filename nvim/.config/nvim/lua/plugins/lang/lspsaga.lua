-- [[
--  Lspsaga provides vaious display and interface using lsp info
--  such as goto_definition, rename, reference
--  the breadcrumb symbols in winbar, ...
-- ]]
return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
  event = 'LspAttach',
  keys = require('core.keymaps').lspsaga,
  cmd = 'Lspsaga',
  opts = {
    symbol_in_winbar = {
      hide_keyword = true, -- hide keyword like `if`
      show_file = true,
      folder_level = 1,
    },
    finder = {
      keys = {
        toggle_or_open = '<CR>', -- use ENTER to open instead of 'o'
      },
    },
    -- outline = {
    --   layout = 'normal', -- can be 'normal' | 'float'
    --   close_after_jump = false, -- autocmd has been set to do this
    --   max_height = 1.0, --height of outline float layout
    --   left_width = 0.4, --width of outline float layout left window
    --   keys = {
    --     toggle_or_jump = '<CR>', -- use ENTER to jump instead of 'o'
    --   },
    -- },
    lightbulb = { -- show a light bulb when code action is availabe
      enable = false,
    },
    ui = {
      lines = { '└', '├', '│', '─', '┌' },
    },
  },
  config = function(_, opts)
    require('lspsaga').setup(opts)

    -- load autocmds
    require('core.utils').load_plugin_autocmds('lspsaga')
  end,
}
