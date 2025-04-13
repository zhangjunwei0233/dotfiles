return {
  'phaazon/hop.nvim',
  config = function()
    require('hop').setup {
      keys = 'etovxqpdygfblzhckisuran',
      quit_key = '<ESC>',
      jump_on_sole_occurrence = false,
      create_hl_autocmd = false, -- Better performance
    }
  end,
}
