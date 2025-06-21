return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all other plugins
  opts = {
    style = 'night',
    styles = {
      comments = { italic = true },
    },

    -- set prettier floating windows
    on_colors = function(colors)
      colors.bg_float = colors.bg
      colors.border_highlight = '#589ed7'
    end,
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme('tokyonight')
  end,
}
