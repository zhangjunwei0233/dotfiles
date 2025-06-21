-- [[ LSP Package Manager]]
return {
  'mason-org/mason.nvim',
  event = { 'VimEnter', 'BufReadPost', 'BufNewFile' },
  opts = {},
  config = function(_, opts)
    require('mason').setup(opts)

    -- load keymaps
    local keymaps = require('core.keymaps').mason
    if keymaps then
      keymaps()
    else
      vim.notify('mason loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
