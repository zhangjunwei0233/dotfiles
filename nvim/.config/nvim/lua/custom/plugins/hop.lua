return {
  'phaazon/hop.nvim',
  keys = {
    {
      's',
      function()
        require('hop').hint_char1()
      end,
      desc = 'Hop to character',
    },
    {
      'S',
      function()
        require('hop').hint_words()
      end,
      desc = 'Hop to word',
    },
  },
  config = function()
    require('hop').setup {
      keys = 'etovxqpdygfblzhckisuran',
      quit_key = '<ESC>',
      jump_on_sole_occurrence = false,
      create_hl_autocmd = false, -- Better performance
    }
  end,
}
