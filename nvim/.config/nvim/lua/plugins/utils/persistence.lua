-- [[ session management ]]
-- session are saved under .local/state/nvim/sessions. you can manage them manually
return {
  'folke/persistence.nvim',
  -- event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  event = 'VeryLazy',
  opts = {
    dir = vim.fn.stdpath('state') .. '/sessions/', -- directory where session files are saved
    -- minimum number of file buffers that need to be open to save
    -- Set to 0 to always save
    need = 3,
    branch = true, -- use git branch to save session
  },
  config = function(_, opts)
    require('persistence').setup(opts)

    -- load keymaps
    require('core.utils').load_plugin_keymaps('persistence')

    -- clean up non-regular buffers before session save
    require('core.utils').load_plugin_autocmds('persistence')
  end,
}
