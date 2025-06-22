-- [[ Auto Completion ]]
return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'xzbdmw/colorful-menu.nvim', -- enable treesitter hl in menu
  },
  event = 'InsertEnter',
  opts = {
    completion = {
      menu = {
        auto_show = true,
        draw = {
          columns = { { 'kind_icon' }, { 'label', gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require('colorful-menu').blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require('colorful-menu').blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
      -- ghost_text = { enabled = false }, -- Display a preview of the selected item on the current line
      -- trigger = {
      --   show_on_keyword = false,
      --
      --   -- show menu after typing a trigger character
      --   show_on_trigger_character = true,
      --   -- Optionally, set a list of characters that will not trigger the completion window,
      --   -- even when sources request it. The following are the defaults:
      --   show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
      --
      --   -- show menu after entering insert mode on a trigger character or accepted one
      --   show_on_insert_on_trigger_character = true,
      --   show_on_accept_on_trigger_character = true,
      --   -- Optionally, set a list of characters that will not trigger the completion window,
      --   -- even when sources request it. The following are the defaults:
      --   show_on_x_blocked_trigger_characters = { "'", '"', '(', '{', '[' },
      -- },
      -- list = {
      --   selection = { preselect = true, auto_insert = true },
      -- },
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
      -- default = { 'path', 'snippets', 'buffer', 'lsp' },
      default = { 'path', 'lsp' },
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
