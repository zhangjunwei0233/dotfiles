-- this plugin is no longer in use, see 'snacks.terminal' instead

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    enabled = false,
    keys = {
      { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = 'open [t]ernimal under root dir' },
      {
        '<leader>tT',
        function()
          local current_dir = vim.fn.fnameescape(vim.fn.expand '%:p:h')
          vim.cmd('ToggleTerm dir=' .. current_dir)
        end,
        desc = 'open [t]ernimal under current file',
      },
    },
    config = function()
      require('toggleterm').setup {
        size = 10,
        open_mapping = [[<C-/>]],
        hide_numbers = true,
        shade_filetypes = {},
        autochdir = false,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
      }
    end,
  },
}
