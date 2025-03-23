return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'BufAdd',
  keys = {
    { ';H', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { ';L', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { ';mH', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
    { ';mL', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
    { ';D', ':bdelete<CR>', desc = '[D]elete buffer' },
  },
  config = function()
    require('bufferline').setup {
      options = {
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        auto_toggle_bufferline = true,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    }
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
