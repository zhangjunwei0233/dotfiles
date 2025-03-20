return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
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
