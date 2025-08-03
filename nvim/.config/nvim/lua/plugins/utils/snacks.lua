-- [[ tools packs including terminal, lazygit, window manangement, ...]]
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  enabled = true,
  keys = require('core.keymaps').snacks,
  ---@type snacks.Config
  opts = {
    indent = {
      indent = {
        char = ' ',
        only_scope = true,
        only_current = true,
        hl = {
          'SnacksIndent1',
          'SnacksIndent2',
          'SnacksIndent3',
          'SnacksIndent4',
          'SnacksIndent5',
          'SnacksIndent6',
          'SnacksIndent7',
          'SnacksIndent8',
        },
      },
      animate = {
        duration = {
          step = 10,
          duration = 100,
        },
      },
      scope = {
        enabled = true, -- enable highlighting the current scope
        priority = 200,
        char = '┊',
        underline = false, -- underline the start of the scope
        only_current = true, -- only show scope in the current window
        hl = { -- can be a list of hl groups to cycle through
          'SnacksIndent1',
          'SnacksIndent2',
          'SnacksIndent3',
          'SnacksIndent4',
          'SnacksIndent5',
          'SnacksIndent6',
          'SnacksIndent7',
          'SnacksIndent8',
        },
      },
    },
    lazygit = { enabled = true },
    terminal = {
      enabled = true,
      win = {
        relative = 'editor',
        wo = { winbar = '' }, -- disable winbar
      },
    },
    statuscolumn = {
      left = { 'sign', 'git' },
      right = { 'mark', 'fold' },
      folds = {
        open = true, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { 'GitSign', 'MiniDiffSign' },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    picker = {
      enabled = true,
      layouts = {
        default = {
          layout = {
            backdrop = false,
          },
        },
      },
    },
    explorer = {
      replace_netrw = true,
    },
    zen = {
      -- You can add any `Snacks.toggle` id here.
      -- Toggle state is restored when the window is closed.
      -- Toggle config options are NOT merged.
      ---@type table<string, boolean>
      toggles = {
        dim = false,
        git_signs = true,
        mini_diff_signs = false,
        diagnostics = true,
        inlay_hints = false,
      },
      show = {
        statusline = false, -- can only be shown when using the global statusline
        tabline = false,
      },
      ---@type snacks.win.Config
      win = {
        style = 'zen',
        border = 'rounded',
        width = 0.99,
        height = 0.99,
        backdrop = false,
        wo = { winbar = vim.wo.winbar },
      },
    },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = ' ',
            key = 'c',
            desc = 'Config',
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          {
            icon = ' ',
            key = 's',
            desc = 'Restore Session',
            action = ":lua require('persisted').load({ last = true })",
          },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
        header = [[
███████╗ ███████╗ ██╗   ██╗ ██╗ ███╗   ███╗
╚══███╔╝ ██╔════╝ ██║   ██║ ██║ ████╗ ████║
  ███╔╝  ███████╗ ██║   ██║ ██║ ██╔████╔██║
 ███╔╝   ╚════██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
███████╗ ███████║  ╚████╔╝  ██║ ██║ ╚═╝ ██║
╚══════╝ ╚══════╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝
        ]],
      },
    },
    scroll = {
      animate = {
        duration = { step = 15, total = 150 },
        easing = 'outQuad',
      },
      animate_repeat = {
        easing = 'outQuad',
      },
    },
    styles = {
      blame_line = {
        width = 0.8,
        height = 0.8,
      },
    },
  },
}
