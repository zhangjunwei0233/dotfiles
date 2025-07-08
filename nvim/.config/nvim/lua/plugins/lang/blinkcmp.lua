-- [[ Auto Completion ]]
return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'VeryLazy',
  dependencies = {
    'rafamadriz/friendly-snippets',
    {
      -- enable treesitter hl in menu
      'xzbdmw/colorful-menu.nvim',
      opts = {},
    },
    {
      -- a compatable layer between nvim-cmp and blink-cmp
      -- used to add avante sources to blink-cmp
      'saghen/blink.compat',
      -- use v2.* for blink.cmp v1.*
      version = '2.*',
      -- make sure to set opts so that lazy.nvim calls blink.compat's setup
      opts = {},
    },
  },
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
                local highlights = {}
                local highlights_info = require('colorful-menu').blink_highlights(ctx)
                if highlights_info ~= nil then
                  highlights = highlights_info.highlights
                end
                -- Commented out to prevent match highlighting from overriding treesitter colors
                -- for _, idx in ipairs(ctx.label_matched_indices) do
                --   table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                -- end
                return highlights
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
      enabled = false, -- already shown in menu
    },
    sources = {
      -- default = { 'path', 'snippets', 'buffer', 'lsp' },
      default = { 'path', 'lsp', 'omni', 'avante_commands', 'avante_mentions', 'avante_files' },

      -- configure providers from avante
      providers = {
        avante_commands = {
          name = 'avante_commands',
          module = 'blink.compat.source',
          score_offset = 90, -- show at a higher priority than lsp
          opts = {},
        },
        avante_files = {
          name = 'avante_files',
          module = 'blink.compat.source',
          score_offset = 100, -- show at a higher priority than lsp
          opts = {},
        },
        avante_mentions = {
          name = 'avante_mentions',
          module = 'blink.compat.source',
          score_offset = 1000, -- show at a higher priority than lsp
          opts = {},
        },
      },
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
