-- [[ Better notices and cmdline ]]
return {
  -- lazy.nvim
  'folke/noice.nvim',
  event = 'VeryLazy',
  enabled = true,
  opts = {
    lsp = {
      signature = { enabled = false },
      progress = { enabled = false },
      hover = { enabled = false },
    },
    commands = {
      history = {
        view = 'popup',
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    views = {
      split = {
        scrollbar = false,
      },
      popup = {
        scrollbar = false,
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },
  config = function(_, opts)
    require('noice').setup(opts)
    require('notify').setup({
      timeout = 1000,
    })

    -- load keymaps
    require('core.utils').load_plugin_keymaps('noice')
  end,
}
