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
    local keymaps = require('core.keymaps').diffview
    if keymaps then
      keymaps()
    else
      vim.notify('diffview loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
