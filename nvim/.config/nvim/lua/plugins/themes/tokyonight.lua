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

      -- set clearer window seperators
      colors.border = colors.bg_highlight
    end,

    on_highlights = function(hl, c)
      -- remove cursorline bg highlight
      hl.CursorLine = { bg = c.bg }

      -- set lighter fold line bg
      hl.Folded = { bg = c.bg_highlight }

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
