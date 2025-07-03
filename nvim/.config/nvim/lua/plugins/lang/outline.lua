-- [[ outline of current file, supported by LSP ]]
return {
  'hedyhli/outline.nvim',
  lazy = true,
  event = 'LspAttach',
  cmd = { 'Outline', 'OutlineOpen' },
  opts = {
    -- Your setup opts here
  },
  config = function(_, opts)
    require('outline').setup(opts)

    -- load keymaps
    local keymaps = require('core.keymaps').outline
    if keymaps then
      keymaps()
    else
      vim.notify('outline loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
