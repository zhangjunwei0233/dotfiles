-- [[
--  a status bar at the bottom
--
--  the status bar is composed of 6 sections:
--  | A | B | C                  X | Y | Z |
--  each section could have multiple components
-- ]]
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'Avante', 'AvanteInput', 'AvanteSelectedFiles', 'codecompanion', 'sagaoutline' },
          winbar = { 'Avante', 'AvanteInput', 'AvanteSelectedFiles', 'codecompanion', 'sagaoutline' },
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true, -- only enable one statusline instead of one for each window
        refresh = {
          statusline = 500,
          tabline = 500,
          winbar = 500,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          {
            'filename',
            path = 1,
            shorting_target = 40,
          },
        },
        lualine_x = { 'progress' },
        lualine_y = { 'filetype' },
        lualine_z = { 'lsp_status' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'progress' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { 'neo-tree' },
    })
  end,
}
