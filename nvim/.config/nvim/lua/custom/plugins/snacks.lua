return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  enabled = true,
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
    terminal = {
      enabled = true,
      win = {
        relative = 'editor',
        wo = { winbar = '' }, -- disable winbar
      },
    },
    toggle = { enabled = false },
    win = { enabled = false },
    words = { enabled = false },
    zen = { enabled = false },
  },
  keys = {
    { -- Current file directory terminal
      '<leader>tt',
      function()
        Snacks.terminal.toggle(nil, {
          cwd = vim.fn.expand '%:p:h',
          start_insert = false,
          auto_insert = false,
          auto_close = true,
        })
      end,
      { desc = 'Toggle terminal (current dir)' },
    },
    { -- Workspace root terminal
      '<leader>tT',
      function()
        Snacks.terminal.toggle(nil, {
          cwd = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd(),
          start_insert = false,
          auto_insert = false,
          auto_close = true,
        })
      end,
      { desc = 'Toggle terminal (workspace root)' },
    },
    { -- Toggle all terminals
      '<leader>ts',
      function()
        local terms = Snacks.terminal.list()
        local any_visible = false
        for _, term in ipairs(terms) do
          if term.win and vim.api.nvim_win_is_valid(term.win) then
            any_visible = true
            break
          end
        end
        for _, term in ipairs(terms) do
          if any_visible then
            term:hide()
          else
            term:show()
          end
        end
      end,
      { desc = 'Toggle all terminals' },
    },
  },
  config = function(_, opts)
    require('snacks').setup(opts)
  end,
}
