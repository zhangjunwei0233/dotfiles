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
      colors.border = colors.bg_highlight
    end,

    on_highlights = function(hl, c)
      hl.LineNr = { bold = true, fg = hl.CursorLineNr.fg }
      hl.LineNrAbove = { fg = '#3b4261' }
      hl.LineNrBelow = { fg = '#3b4261' }

      -- TreeSitterContext Integration
      hl.TreesitterContextBottom = {
        sp = c.fg_gutter,
        underline = true,
      }
      hl.TreesitterContextLineNumber = {
        fg = '#3b4261',
        bg = c.bg_dark,
      }
      hl.TreesitterContext = { bg = c.bg_dark }
    end,
  },
}
