return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  event = 'VeryLazy',
  config = function()
    vim.opt.fillchars:append({ diff = '/' })
    require('diffview').setup({
      enhanced_diff_hl = true,
      view = {
        default = { winbar_info = true },
        file_history = { winbar_info = true },
      },
      hooks = {
        diff_buf_read = function(bufnr)
          vim.b[bufnr].view_activated = false
        end,
      },
    })

    -- load keymaps
    require('core.utils').load_plugin_keymaps('diffview')
  end,
}
