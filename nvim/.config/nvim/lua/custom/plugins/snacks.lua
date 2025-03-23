return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    animate = { enabled = false },
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    dim = { enabled = false },
    explorer = { enabled = false },
    gitbrowse = { enabled = false },
    image = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    layout = { enabled = false },
    lazygit = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    profiler = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scratch = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    terminal = { enabled = true },
    toggle = { enabled = false },
    win = { enabled = false },
    words = { enabled = false },
    zen = { enabled = false },
  },
  keys = {
    {
      '<leader>tt',
      function()
        local root = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd()
        Snacks.terminal.open(nil, {
          interactive = true,
          cwd = root,
          shell = vim.o.shell,
          win = { relative = 'editor' }, -- force non-floating window
        })
      end,
      desc = 'Toggle terminal (workspace root)',
    },
    {
      '<leader>tT',
      function()
        local dir = vim.fn.expand '%:p:h'
        Snacks.terminal.open(nil, {
          interactive = true,
          cwd = dir,
          shell = vim.o.shell,
          win = { relative = 'editor' }, -- force non-floating window
        })
      end,
      desc = 'Toggle terminal (current file dir)',
    },
  },
  config = function(_, opts)
    require('snacks').setup(opts)
  end,
}
