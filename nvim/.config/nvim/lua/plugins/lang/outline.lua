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
    require('core.utils').load_plugin_keymaps('outline')
  end,
}
