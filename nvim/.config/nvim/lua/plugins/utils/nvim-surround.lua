-- [[ add/delete/change surrounding pairs quickly ]]
--
-- 'ys<preposition><char>' to add surround using <char>
-- 'ds<preposition><char>' to delete char surrounding
-- 'cs<char1><char2>' to change <char1> surround to <char2>
-- special chars:
--    t: html tag
--    h: function
--
-- See :h nvim-surround.usage for more usage
return {
  'kylechui/nvim-surround',
  version = '^3.0.0', -- Use for stability; omit to use `main` branch for the latest features
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup({
      -- Configuration here, or leave empty to use defaults
    })
  end,
}
