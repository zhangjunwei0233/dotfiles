-- [[ Bufferline: tabs and navigation for buffers ]]
return {
  'akinsho/bufferline.nvim',
  event = 'VimEnter',
  opts = {
    options = {
      -- enable diagnostic icons
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(_, _, diagnostics_dict, _)
        local indicator = ' '
        for level, number in pairs(diagnostics_dict) do
          local symbol
          if level == 'error' then
            symbol = ' '
          elseif level == 'warning' then
            symbol = ' '
          else
            symbol = ' '
          end
          indicator = indicator .. number .. symbol
        end
        return indicator
      end,
      -- only display bufferline when there is more than one buffer
      always_show_bufferline = false,
      auto_toggle_bufferline = true,
      -- handle special buffer: neo-tree
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          text_align = 'center',
        },
      },
    },
  },
  config = function(_, opts)
    require('bufferline').setup(opts)

    -- load keymaps
    require('core.utils').load_plugin_keymaps('bufferline')
  end,
}
