return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  ft = { 'markdown', 'Avante', 'Codecompanion' },
  opts = {
    render_modes = true, -- Enable in all modes
    file_types = { 'markdown' },
    sign = { enabled = false },
    code = {
      -- general
      width = 'block',
      min_width = 80,
      -- borders
      border = 'thin',
      left_pad = 1,
      right_pad = 1,
      -- language info
      position = 'right',
      language_icon = true,
      language_name = true,
      -- prettier inline code in headings
      highlight_inline = 'RenderMarkdownCodeInfo',
    },
    heading = {
      border = true,
    },
    pipe_table = {
      preset = 'round',
    },
    anti_conceal = {
      disabled_modes = { 'n' },
      ignore = {
        bullet = true, -- render bullet in insert mode
        head_border = true,
        head_background = true,
      },
    },
    win_options = { concealcursor = { rendered = 'vnc' } },
    completions = {
      blink = { enabled = true },
      lsp = { enabled = true },
    },
  },
}
