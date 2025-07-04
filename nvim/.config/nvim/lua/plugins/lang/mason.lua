-- [[ LSP Package Manager]]
return {
  'mason-org/mason.nvim',
  event = { 'VimEnter', 'BufReadPost', 'BufNewFile' },
  opts = {},
  config = function(_, opts)
    require('mason').setup(opts)

    -- load keymaps
    require('core.utils').load_plugin_keymaps('mason')
  end,
}
