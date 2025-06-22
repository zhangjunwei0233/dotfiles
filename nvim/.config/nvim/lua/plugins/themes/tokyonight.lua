return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all other plugins
  opts = {
    style = 'night',
    styles = {
      comments = { italic = true },
    },

    on_colors = function(colors)
      -- set prettier floating windows
      colors.bg_float = colors.bg
      colors.border_highlight = '#589ed7'
      -- set prettier fold lines
      colors.fg_gutter = colors.bg_highlight
      -- set clearer window seperators
      colors.border = colors.comment
    end,
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme('tokyonight')
  end,
}
