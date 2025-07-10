-- [[ session management ]]
-- session are saved under .local/state/nvim/sessions. you can manage them manually
return {
  'olimorris/persisted.nvim',
  event = 'BufReadPre', -- Ensure the plugin loads only when a buffer has been loaded
  keys = require('core.keymaps').persisted,
  dependencies = {
    'nvim-telescope/telescope.nvim', -- provide session search functions
  },
  opts = {
    autostart = false,
    should_save = function() -- only save session when no less that 2 buffers are opend
      return true
    end,
    autoload = false,

    allowed_dirs = {}, -- Table of dirs that the plugin will start and autoload from
    ignored_dirs = {}, -- Table of dirs that are ignored for starting and autoloading
  },
  config = function(_, opts)
    require('persisted').setup(opts)

    -- [ load autocmds ]
    -- clean up non-regular buffers before session save
    require('core.utils').load_plugin_autocmds('persisted')
  end,
}
