-- [[ Auto Completion ]]
return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  event = 'VeryLazy',
  opts = {
    completion = {
      documentation = {
        auto_show = true, -- show documentation aside
      },
    },
    keymap = {
      preset = 'super-tab', -- <C-p> <C-n> to select, <Tab> to accept
    },
    signature = {
      enabled = true,
    },
    sources = {
      default = { 'path', 'snippets', 'buffer', 'lsp' },
    },
    -- sepecial cases: completion for cmds
    cmdline = {
      sources = function()
        local cmd_type = vim.fn.getcmdtype()
        if cmd_type == '/' or cmd_type == '?' then -- search
          return { 'buffer' }
        end
        if cmd_type == ':' then -- cmd
          return { 'cmdline' }
        end
        return {}
      end,
      keymap = {
        preset = 'super-tab', -- <C-p> <C-n> to select, <Tab> to accept
      },
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
  },
}
