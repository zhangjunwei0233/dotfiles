-- [[ Code formatter ]]
return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
    },
    formatters = {
      -- configure formatter behaviors here
      stylua = { -- refer to gitbub/conform/formatters/stylua.lua
        command = 'stylua',
        args = {
          '--search-parent-directories',
          '--respect-ignores',
          '--indent-type',
          'Spaces',
          '--quote-style',
          'AutoPreferSingle',
          '--indent-width',
          '2',
          '--stdin-filepath',
          '$FILENAME',
          '-',
        },
      },
    },

    -- auto format on file-save
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { 'c', 'cpp' }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end
      -- ...additional logic...
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  },
  config = function(_, opts)
    require('conform').setup(opts)

    -- setup user cmd to toggle auto format
    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformat-on-save',
      bang = true,
    })
    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Re-enable autoformat-on-save',
    })

    -- load keymaps
    local keymaps = require('core.keymaps').conform
    if keymaps then
      keymaps()
    else
      vim.notify('conform loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
