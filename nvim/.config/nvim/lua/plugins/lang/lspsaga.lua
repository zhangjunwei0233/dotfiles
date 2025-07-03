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
  cmd = 'Lspsaga',
  opts = {
    symbol_in_winbar = {
      hide_keyword = true, -- hide keyword like `if`
      show_file = true,
      folder_level = 0,
    },
    finder = {
      keys = {
        toggle_or_open = '<CR>', -- use ENTER to open instead of 'o'
      },
    },
    outline = {
      layout = 'normal', -- can be 'normal' | 'float'
      close_after_jump = false, -- autocmd has been set to do this
      max_height = 1.0, --height of outline float layout
      left_width = 0.4, --width of outline float layout left window
      keys = {
        toggle_or_jump = '<CR>', -- use ENTER to jump instead of 'o'
      },
    },
    ui = {
      code_action = '',
      lines = { '└', '├', '│', '─', '┌' },
    },
  },
  config = function(_, opts)
    require('lspsaga').setup(opts)

    -- load keymaps
    local keymaps = require('core.keymaps').lspsaga
    if keymaps then
      keymaps()
    else
      vim.notify('lspsaga loaded without keymap\n', vim.log.levels.WARN)
    end

    -- load autocmds
    local autocmds = require('core.autocmds').lspsaga
    if autocmds then
      autocmds()
    end
  end,
}
