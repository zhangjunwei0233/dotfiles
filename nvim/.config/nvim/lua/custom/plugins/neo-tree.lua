return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  config = function()
    require('neo-tree').setup {
      open_files_do_not_replace_types = {
        'snacks_terminal',
        'codecompanion',
      },
      filesystem = {
        -- commands = {
        --   -- a function to quickluy add file/folder to Avante in neo-tree
        --   NOTE: this function has some bugs, thus disabled. add files in avante sidebar
        --
        --   avante_add_files = function(state)
        --     local node = state.tree:get_node()
        --     local filepath = node:get_id()
        --     local relative_path = require('avante.utils').relative_path(filepath)
        --
        --     local sidebar = require('avante').get()
        --
        --     local open = sidebar:is_open()
        --     -- ensure avante sidebar is open
        --     if not open then
        --       require('avante.api').ask()
        --       sidebar = require('avante').get()
        --     end
        --     sidebar.file_selector:add_selected_file(relative_path)
        --     -- remove neo tree buffer
        --     if not open then
        --       sidebar.file_selector:remove_selected_file 'neo-tree filesystem [1]'
        --     end
        --   end,
        -- },
        -- window = {
        --   mappings = {
        --     ['<leader>aa'] = 'avante_add_files', -- <leader>aa for avante add
        --   },
        -- },
      },
    }
  end,
}
